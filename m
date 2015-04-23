From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [PATCH v11 0/4] machvirt dynamic sysbus device instantiation
Date: Thu, 23 Apr 2015 17:05:59 +0200
Message-ID: <CAN9JPjHCMPeY=zouEd=aP_mGQriLfv7q4gTK0Y+DW2K76c9qyA@mail.gmail.com>
References: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8079978565930712067=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6FD4E565
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 10:57:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6edxHW-d2ssw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 10:57:46 -0400 (EDT)
Received: from mail-qk0-f179.google.com (mail-qk0-f179.google.com
 [209.85.220.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5962A4E55C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 10:57:45 -0400 (EDT)
Received: by qkgx75 with SMTP id x75so12251392qkg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 08:05:59 -0700 (PDT)
In-Reply-To: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============8079978565930712067==
Content-Type: multipart/alternative; boundary=001a11376e1210b9160514659e08

--001a11376e1210b9160514659e08
Content-Type: text/plain; charset=UTF-8

Hi Eric,

Is there anything still blocking this patch ? Can I get the status ?

Thanks,
Baptiste

On Wed, Mar 4, 2015 at 5:18 PM, Eric Auger <eric.auger@linaro.org> wrote:

> This patch series enables machvirt to dynamically instantiate sysbus
> devices from command line (using -device option).
>
> All those sysbus devices are plugged onto a platform bus. This latter
> device is instantiated in machvirt and takes care of the binding of
> children sysbus devices on a machine init done notifier. The device
> tree node generation for children dynamic sysbus device also happens
> on a subsequent notifier that must be executed after the above one.
> machvirt registers that notifier before the platform bus creation to
> make sure notifiers are executed in the right order: dt generation after
> actual QOM binding.
>
> Very few sysbus devices are supposed to be instantiated that
> way. VFIO devices belong to them.
>
> Node creation really is architecture specific. On ARM the dynamic
> sysbus device node creation is implemented in a new C module,
> hw/arm/sysbus-fdt.c and not in the machine file.
>
> Machvirt transformations and sysbus-fdt are largely inspired from Alex
> work.
>
> The patch series can be found at:
> http://git.linaro.org/people/eric.auger/qemu.git,
> branch official_dynsysbus_v11
>
> Best Regards
>
> Eric
>
> v10 -> v11:
> - rebase on v2.2.0 and especially Alex'
>   "arm: Add PCIe host bridge in virt machine"
>
> v9 -> v10:
> - add assert and fix return value in add_fdt_node
>
> v8 -> v9:
> Take into account Peter's comments:
> hw/arm/sysbus-fdt:
> - s/Fdt/FDT in struct type names
> - reorder fields in PlatformBusFdtNotifierParams and use DO_UPCAST
> - use assert() when relevant (board model issue)
> - g_free the ARMPlatformBusFDTParams and PlatformBusFDTNotifierParams
>   pointers in platform_bus_fdt_notify
> hw/arm/boot.c
> - fix compilation with arm-linux-user
> - reorder fields in ArmLoadKernelNotifier
> hw/arm/virt.c
> - PLATFORM_BUS_NUM_IRQS set to 32 instead of 20
> - platform bus irq now start at 64 instead of 48
> - remove change of indentation in  a15memmap
> - correct misc style issues
>
> add a separate patch file for re-indentation in virt a15memmap
>
> v7 -> v8:
> - rebase on 2.2.0 (boot.c and virt.c)
> - in virt.c machvirt_init, create_platform_bus simply is added
>   after the arm_load_kernel call instead of moving this latter.
>   should ease the review.
> - Add Alex & Shannon Reviewed-by
>
> v6 -> v7:
> Take into account Shannon's comments:
> - hw/arm/sysbus-fdt.c: revert indentation in add_fdt_node_functions
> - hw/arm/virt.c:
>   - add an additional comment in a15irqmap related to PLATFORM_BUS_NUM_IRQS
>   - correct platform bus size to 0x400000
>   - remove PLATFORM_BUS_FIRST_IRQ macro
>
> v5 -> v6:
> Take into account Peter's comments:
> - dtb overload mechanism rewritten: arm_load_kernel code is moved into a
>   machine init done notifier notify instead. arm_load_kernel only registers
>   that notifier. As a consequence the dtb is loaded once.
> - v5 1-4 patch files are removed and replaced by a single patch file moving
>   arm_load_kernel in the notifier (2).
> - as a consequence arm_load_kernel must be called before sysbus-fdt
>   arm_register_platform_bus_fdt_creator.
> - In virt, platform_bus_params not a const anymore since its fields are
>   initialized from vbi->memmap and vbi->irqmap. Hence create_platform_bus
>   proto can be simplified.
> - In sysbus-fdt add_all_platform_bus_fdt_nodes now takes a handle to
>   an ARMPlatformBusFdtParams. This is not a modify_dtb function anymore
>   fdt pointer is checked in case the callback is called after the load_dtb
>   (this latter deallocated fdt pointer). Check of fdt_filename moved in
> here.
>   upgrade_dtb is removed. copyright aligned between .h and .c.
>
> v4 -> v5:
> - in virt.c: platform_bus_params becomes static const
> - sysbus-fdt: change indentation in add_fdt_node_functions array init
> - s/load_dtb/arm_load_dtb in one boot.c comment
>
> v3 -> v4:
> - dyn_sysbus_binding removed since binding stuff now are implemented by
>   the platform bus device
> - due to a change in ARM load_dtb implementation using rom_add_blob_fixed,
>   the dt no more is generated in a reset notifier but is generated on a
>   machine init done notifier
> - the augmented device tree is not generated from scratch anymore but is
>   added using a modify_dtb function. This required some small change in
>   boot.c
> - the case where the user provides a dtb file now is handled
> - some cleanup in virt additions
> - implement a list of dyanmically instantiable devices in sysbus-fdt
>
> v2 -> v3:
> - patch now applies on top of Alex full patchset
> - dyn_sysbus_devtree: add arm_prefix to emphasize the fact those
>   functions are arm specific; arm_sysbus_device_create_devtree
>   becomes static
> - load_dtb renamed into arm_load_dtb
> - add copyright in hw/arm/dyn_sysbus_devtree.c
>
> v1 -> v2:
> - device node generation no more in sysbus device but in
>   dyn_sysbus_devtree
> - VFIO region shrinked to 4MB and relocated in machvirt to avoid PCI
>   shrink (dynamic vfio-mmio support might come latter)
> - platform_bus_base removed from PlatformDevtreeData
>
>
> Eric Auger (4):
>   hw/arm/sysbus-fdt: helpers for platform bus nodes addition
>   hw/arm/boot: arm_load_kernel implemented as a machine init done
>     notifier
>   hw/arm/virt: add dynamic sysbus device support
>   hw/arm/virt: change indentation in a15memmap
>
>  hw/arm/Makefile.objs        |   1 +
>  hw/arm/boot.c               |  14 +++-
>  hw/arm/sysbus-fdt.c         | 174
> ++++++++++++++++++++++++++++++++++++++++++++
>  hw/arm/virt.c               |  85 ++++++++++++++++++----
>  include/hw/arm/arm.h        |  28 +++++++
>  include/hw/arm/sysbus-fdt.h |  60 +++++++++++++++
>  6 files changed, 348 insertions(+), 14 deletions(-)
>  create mode 100644 hw/arm/sysbus-fdt.c
>  create mode 100644 include/hw/arm/sysbus-fdt.h
>
> --
> 1.8.3.2
>
>

--001a11376e1210b9160514659e08
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi Eric,<br><br></div>Is there anything sti=
ll blocking this patch ? Can I get the status ?<br><br></div>Thanks,<br></d=
iv>Baptiste<br></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Mar 4, 2015 at 5:18 PM, Eric Auger <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:eric.auger@linaro.org" target=3D"_blank">eric.auger@linaro.org<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">This patch series e=
nables machvirt to dynamically instantiate sysbus<br>
devices from command line (using -device option).<br>
<br>
All those sysbus devices are plugged onto a platform bus. This latter<br>
device is instantiated in machvirt and takes care of the binding of<br>
children sysbus devices on a machine init done notifier. The device<br>
tree node generation for children dynamic sysbus device also happens<br>
on a subsequent notifier that must be executed after the above one.<br>
machvirt registers that notifier before the platform bus creation to<br>
make sure notifiers are executed in the right order: dt generation after<br=
>
actual QOM binding.<br>
<br>
Very few sysbus devices are supposed to be instantiated that<br>
way. VFIO devices belong to them.<br>
<br>
Node creation really is architecture specific. On ARM the dynamic<br>
sysbus device node creation is implemented in a new C module,<br>
hw/arm/sysbus-fdt.c and not in the machine file.<br>
<br>
Machvirt transformations and sysbus-fdt are largely inspired from Alex work=
.<br>
<br>
The patch series can be found at:<br>
<a href=3D"http://git.linaro.org/people/eric.auger/qemu.git" target=3D"_bla=
nk">http://git.linaro.org/people/eric.auger/qemu.git</a>,<br>
branch official_dynsysbus_v11<br>
<br>
Best Regards<br>
<br>
Eric<br>
<br>
v10 -&gt; v11:<br>
- rebase on v2.2.0 and especially Alex&#39;<br>
=C2=A0 &quot;arm: Add PCIe host bridge in virt machine&quot;<br>
<br>
v9 -&gt; v10:<br>
- add assert and fix return value in add_fdt_node<br>
<br>
v8 -&gt; v9:<br>
Take into account Peter&#39;s comments:<br>
hw/arm/sysbus-fdt:<br>
- s/Fdt/FDT in struct type names<br>
- reorder fields in PlatformBusFdtNotifierParams and use DO_UPCAST<br>
- use assert() when relevant (board model issue)<br>
- g_free the ARMPlatformBusFDTParams and PlatformBusFDTNotifierParams<br>
=C2=A0 pointers in platform_bus_fdt_notify<br>
hw/arm/boot.c<br>
- fix compilation with arm-linux-user<br>
- reorder fields in ArmLoadKernelNotifier<br>
hw/arm/virt.c<br>
- PLATFORM_BUS_NUM_IRQS set to 32 instead of 20<br>
- platform bus irq now start at 64 instead of 48<br>
- remove change of indentation in=C2=A0 a15memmap<br>
- correct misc style issues<br>
<br>
add a separate patch file for re-indentation in virt a15memmap<br>
<br>
v7 -&gt; v8:<br>
- rebase on 2.2.0 (boot.c and virt.c)<br>
- in virt.c machvirt_init, create_platform_bus simply is added<br>
=C2=A0 after the arm_load_kernel call instead of moving this latter.<br>
=C2=A0 should ease the review.<br>
- Add Alex &amp; Shannon Reviewed-by<br>
<br>
v6 -&gt; v7:<br>
Take into account Shannon&#39;s comments:<br>
- hw/arm/sysbus-fdt.c: revert indentation in add_fdt_node_functions<br>
- hw/arm/virt.c:<br>
=C2=A0 - add an additional comment in a15irqmap related to PLATFORM_BUS_NUM=
_IRQS<br>
=C2=A0 - correct platform bus size to 0x400000<br>
=C2=A0 - remove PLATFORM_BUS_FIRST_IRQ macro<br>
<br>
v5 -&gt; v6:<br>
Take into account Peter&#39;s comments:<br>
- dtb overload mechanism rewritten: arm_load_kernel code is moved into a<br=
>
=C2=A0 machine init done notifier notify instead. arm_load_kernel only regi=
sters<br>
=C2=A0 that notifier. As a consequence the dtb is loaded once.<br>
- v5 1-4 patch files are removed and replaced by a single patch file moving=
<br>
=C2=A0 arm_load_kernel in the notifier (2).<br>
- as a consequence arm_load_kernel must be called before sysbus-fdt<br>
=C2=A0 arm_register_platform_bus_fdt_creator.<br>
- In virt, platform_bus_params not a const anymore since its fields are<br>
=C2=A0 initialized from vbi-&gt;memmap and vbi-&gt;irqmap. Hence create_pla=
tform_bus<br>
=C2=A0 proto can be simplified.<br>
- In sysbus-fdt add_all_platform_bus_fdt_nodes now takes a handle to<br>
=C2=A0 an ARMPlatformBusFdtParams. This is not a modify_dtb function anymor=
e<br>
=C2=A0 fdt pointer is checked in case the callback is called after the load=
_dtb<br>
=C2=A0 (this latter deallocated fdt pointer). Check of fdt_filename moved i=
n here.<br>
=C2=A0 upgrade_dtb is removed. copyright aligned between .h and .c.<br>
<br>
v4 -&gt; v5:<br>
- in virt.c: platform_bus_params becomes static const<br>
- sysbus-fdt: change indentation in add_fdt_node_functions array init<br>
- s/load_dtb/arm_load_dtb in one boot.c comment<br>
<br>
v3 -&gt; v4:<br>
- dyn_sysbus_binding removed since binding stuff now are implemented by<br>
=C2=A0 the platform bus device<br>
- due to a change in ARM load_dtb implementation using rom_add_blob_fixed,<=
br>
=C2=A0 the dt no more is generated in a reset notifier but is generated on =
a<br>
=C2=A0 machine init done notifier<br>
- the augmented device tree is not generated from scratch anymore but is<br=
>
=C2=A0 added using a modify_dtb function. This required some small change i=
n<br>
=C2=A0 boot.c<br>
- the case where the user provides a dtb file now is handled<br>
- some cleanup in virt additions<br>
- implement a list of dyanmically instantiable devices in sysbus-fdt<br>
<br>
v2 -&gt; v3:<br>
- patch now applies on top of Alex full patchset<br>
- dyn_sysbus_devtree: add arm_prefix to emphasize the fact those<br>
=C2=A0 functions are arm specific; arm_sysbus_device_create_devtree<br>
=C2=A0 becomes static<br>
- load_dtb renamed into arm_load_dtb<br>
- add copyright in hw/arm/dyn_sysbus_devtree.c<br>
<br>
v1 -&gt; v2:<br>
- device node generation no more in sysbus device but in<br>
=C2=A0 dyn_sysbus_devtree<br>
- VFIO region shrinked to 4MB and relocated in machvirt to avoid PCI<br>
=C2=A0 shrink (dynamic vfio-mmio support might come latter)<br>
- platform_bus_base removed from PlatformDevtreeData<br>
<br>
<br>
Eric Auger (4):<br>
=C2=A0 hw/arm/sysbus-fdt: helpers for platform bus nodes addition<br>
=C2=A0 hw/arm/boot: arm_load_kernel implemented as a machine init done<br>
=C2=A0 =C2=A0 notifier<br>
=C2=A0 hw/arm/virt: add dynamic sysbus device support<br>
=C2=A0 hw/arm/virt: change indentation in a15memmap<br>
<br>
=C2=A0hw/arm/Makefile.objs=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0hw/arm/boot.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 14 +++-<br>
=C2=A0hw/arm/sysbus-fdt.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 174 ++++++++++=
++++++++++++++++++++++++++++++++++<br>
=C2=A0hw/arm/virt.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 85 ++++++++++++++++++----<br>
=C2=A0include/hw/arm/arm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 28 +++++++<br=
>
=C2=A0include/hw/arm/sysbus-fdt.h |=C2=A0 60 +++++++++++++++<br>
=C2=A06 files changed, 348 insertions(+), 14 deletions(-)<br>
=C2=A0create mode 100644 hw/arm/sysbus-fdt.c<br>
=C2=A0create mode 100644 include/hw/arm/sysbus-fdt.h<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a11376e1210b9160514659e08--

--===============8079978565930712067==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8079978565930712067==--
