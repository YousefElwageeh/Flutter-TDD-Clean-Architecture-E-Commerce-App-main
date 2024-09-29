import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/delivery/presentation/bloc/delivery_info_action/delivery_info_action_cubit.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  @override
  void initState() {
    context.read<DeliveryInfoActionCubit>().getNearestBranche(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<DeliveryInfoActionCubit, DeliveryInfoActionState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                    height: size.height * 0.6,
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: (controller) {
                        context
                            .read<DeliveryInfoActionCubit>()
                            .onMapCreated(controller);
                      },
                      initialCameraPosition: context
                                  .read<DeliveryInfoActionCubit>()
                                  .userLocation !=
                              null
                          ? CameraPosition(
                              target: LatLng(
                                  context
                                      .read<DeliveryInfoActionCubit>()
                                      .userLocation!
                                      .latitude,
                                  context
                                      .read<DeliveryInfoActionCubit>()
                                      .userLocation!
                                      .longitude))
                          : const CameraPosition(
                              target:
                                  LatLng(37.42796133580664, -122.085749655962),
                              zoom: 14.4746),
                      markers: context.read<DeliveryInfoActionCubit>().markers,
                    )),
                Expanded(
                  child: ListView.builder(
                    itemCount: context
                        .read<DeliveryInfoActionCubit>()
                        .nearestBranches
                        .length,
                    itemBuilder: (context, index) {
                      NearestBrancheModel data = context
                          .read<DeliveryInfoActionCubit>()
                          .nearestBranches[index];
                      return BranchWidget(
                        Id: data.id.toString(),
                        branchName: data.name ?? '',
                        distance: data.distance ?? 0.0,
                        lat: data.latitude ?? '0.0',
                        long: data.longitude ?? '0.0',
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class BranchWidget extends StatefulWidget {
  String branchName;
  String Id;

  double distance;
  String lat;
  String long;

  BranchWidget({
    super.key,
    required this.branchName,
    required this.Id,
    required this.distance,
    required this.lat,
    required this.long,
  });

  @override
  State<BranchWidget> createState() => _BranchWidgetState();
}

class _BranchWidgetState extends State<BranchWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<DeliveryInfoActionCubit>().cahngeSelectedCalue(
            NearestBrancheModel(
                id: int.parse(widget.Id),
                name: widget.branchName,
                distance: widget.distance,
                latitude: widget.lat,
                longitude: widget.long));

        context
            .read<DeliveryInfoActionCubit>()
            .gotoPoint(double.parse(widget.lat), double.parse(widget.long));
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            context
                        .read<DeliveryInfoActionCubit>()
                        .selectedBranch
                        .id
                        .toString() ==
                    widget.Id
                ? const Icon(Icons.done)
                : const SizedBox.shrink(),
            const SizedBox(
              width: 10,
            ),
            Text(widget.branchName),
            const Spacer(),
            Text('${widget.distance.toInt()} M away'),
          ],
        ),
      ),
    );
  }
}
