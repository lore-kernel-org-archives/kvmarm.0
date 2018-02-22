From: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Thu, 22 Feb 2018 11:04:30 +0000
Message-ID: <e5ffc52f-4510-f757-aa83-2a99af3ae06b@arm.com>
References: <20180214145340.1223-2-jean-philippe.brucker@arm.com>
	<201802220455.lMEb6LLi%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <201802220455.lMEb6LLi%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org" <tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org" <jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, "eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org" <virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org>, "jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Marc Zyngier <Marc.Zyngier-5wv7dgnIgG8@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/02/18 20:12, kbuild test robot wrote:
[...]
> config: arm64-allmodconfig (attached as .config)
[...]
>    aarch64-linux-gnu-ld: arch/arm64/kernel/head.o: relocation R_AARCH64_ABS32 against `_kernel_offset_le_lo32' can not be used when making a shared object
>    arch/arm64/kernel/head.o: In function `kimage_vaddr':
>    (.idmap.text+0x0): dangerous relocation: unsupported relocation

Is this related?

>    arch/arm64/kernel/head.o: In function `__primary_switch':
>    (.idmap.text+0x340): dangerous relocation: unsupported relocation
>    (.idmap.text+0x348): dangerous relocation: unsupported relocation
>    drivers/iommu/virtio-iommu.o: In function `viommu_probe':
>    virtio-iommu.c:(.text+0xbdc): undefined reference to `virtio_check_driver_offered_feature'
>    virtio-iommu.c:(.text+0xcfc): undefined reference to `virtio_check_driver_offered_feature'
>    virtio-iommu.c:(.text+0xe10): undefined reference to `virtio_check_driver_offered_feature'
>    drivers/iommu/virtio-iommu.o: In function `viommu_send_reqs_sync':
>    virtio-iommu.c:(.text+0x130c): undefined reference to `virtqueue_add_sgs'
>    virtio-iommu.c:(.text+0x1398): undefined reference to `virtqueue_kick'
>    virtio-iommu.c:(.text+0x14d4): undefined reference to `virtqueue_get_buf'
>    drivers/iommu/virtio-iommu.o: In function `virtio_iommu_drv_init':
>    virtio-iommu.c:(.init.text+0x1c): undefined reference to `register_virtio_driver'
>    drivers/iommu/virtio-iommu.o: In function `virtio_iommu_drv_exit':
>>> virtio-iommu.c:(.exit.text+0x14): undefined reference to `unregister_virtio_driver'

Right. At the moment CONFIG_VIRTIO_IOMMU is a bool instead of tristate,
because the IOMMU subsystem isn't entirely ready to have IOMMU drivers
built as modules. In addition to exporting symbols it would also needs to
hold off probing endpoints behind the IOMMU until the IOMMU driver is
loaded. At the moment (I think) it gives up once userspace is reached (see
of_iommu_driver_present).

The above report is due to VIRTIO=m and VIRTIO_IOMMU=y. To solve it we could:

a) Allow VIRTIO_IOMMU to be built as module by exporting a dozen IOMMU
symbols. It would be a lie. The driver wouldn't be usable because of the
probe issue discussed above, but it would build.

b) Actually make any IOMMU driver work as module. Whilst it would
certainly be a nice feature, it's a bigger problem and I don't think it
has its place in this series.

c) Make VIRTIO_IOMMU depend on VIRTIO_MMIO=y instead of VIRTIO_MMIO, which
I think is the sanest for now (and does work), even though distro kernels
probably all have VIRTIO=m.

I prefer doing c) now and experiment with b) once I got some time.

Thanks,
Jean
