From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: [PATCH] updated: arm64: KVM: vgic: deal with GIC sub-page alignment
Date: Fri, 1 Jul 2016 13:57:56 +0900
Message-ID: <5775F854.3060306@riken.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7975415775139137475=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1801949B21
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2016 00:51:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vwe3q6RMN-0G for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2016 00:51:54 -0400 (EDT)
Received: from postman.riken.jp (postman2.riken.jp [134.160.33.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4E2412A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2016 00:51:53 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This is a multi-part message in MIME format.
--===============7975415775139137475==
Content-Type: multipart/alternative;
 boundary="------------000803000007060306040703"

This is a multi-part message in MIME format.
--------------000803000007060306040703
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

This is merely an update to the patch Marc posted in 2014:

https://lists.cs.columbia.edu/pipermail/kvmarm/2014-June/010055.html

This updated patch is against today's current kvmarm git tree tag, 
kvm-for-arm-v4.7-rc6.

The GIC CPU interface is always 4k aligned. If the host is using
64k pages, it is critical to place the guest's GICC interface at the
same relative alignment as the host's GICV. Failure to do so results
in an impossibility for the guest to deal with interrupts.

Add a KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET attribute for the VGIC, allowing
userspace to retrieve the GICV offset in a page. It becomes then trivial
to adjust the GICC base address for the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>>
Signed-off-by: Itaru Kitayama <itaru.kitayama@riken.jp>

diff --git a/arch/arm64/include/uapi/asm/kvm.h 
b/arch/arm64/include/uapi/asm/kvm.h
index f209ea1..803b097 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -203,6 +203,7 @@ struct kvm_arch_memory_slot {
  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK (0xffffffffULL << 
KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS   3
  #define KVM_DEV_ARM_VGIC_GRP_CTRL      4
+#define KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET 5
  #define   KVM_DEV_ARM_VGIC_CTRL_INIT   0

  /* Device Control API on vcpu fd */
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c 
b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 850eb88..3e33778 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -196,8 +196,14 @@ static int vgic_get_common_attr(struct kvm_device *dev,
                              VGIC_NR_PRIVATE_IRQS, uaddr);
                 break;
         }
+       case KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET: {
+               u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+               u32 val = kvm_vgic_global_state.vcpu_base & ~PAGE_MASK;
+               r = put_user(val, uaddr);
+               break;
         }

+       }
         return r;
  }

@@ -362,6 +368,7 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
         case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
                 return vgic_v2_has_attr_regs(dev, attr);
         case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+       case KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET:
                 return 0;
         case KVM_DEV_ARM_VGIC_GRP_CTRL:
                 switch (attr->attr) {

--------------000803000007060306040703
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>

    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dutf=
-8">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    This is merely an update to the patch Marc posted in 2014:<br>
    <br>
    <a class=3D"moz-txt-link-freetext" href=3D"https://lists.cs.columbia.=
edu/pipermail/kvmarm/2014-June/010055.html">https://lists.cs.columbia.edu=
/pipermail/kvmarm/2014-June/010055.html</a><br>
    <br>
    This updated patch is against today's current kvmarm git tree tag,
    kvm-for-arm-v4.7-rc6.<br>
    <br>
    <meta charset=3D"utf-8">
    <pre style=3D"white-space: pre-wrap; color: rgb(0, 0, 0); font-style:=
 normal; font-variant: normal; font-weight: normal; letter-spacing: norma=
l; line-height: normal; orphans: auto; text-align: start; text-indent: 0p=
x; text-transform: none; widows: 1; word-spacing: 0px; -webkit-text-strok=
e-width: 0px;">The GIC CPU interface is always 4k aligned. If the host is=
 using
64k pages, it is critical to place the guest's GICC interface at the
same relative alignment as the host's GICV. Failure to do so results
in an impossibility for the guest to deal with interrupts.

Add a KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET attribute for the VGIC, allowing
userspace to retrieve the GICV offset in a page. It becomes then trivial
to adjust the GICC base address for the guest.

Signed-off-by: Marc Zyngier &lt;<a href=3D"https://lists.cs.columbia.edu/=
mailman/listinfo/kvmarm">marc.zyngier@arm.com</a>&gt;
Signed-off-by: Itaru Kitayama <a class=3D"moz-txt-link-rfc2396E" href=3D"=
mailto:itaru.kitayama@riken.jp">&lt;itaru.kitayama@riken.jp&gt;</a>
</pre>
    diff --git a/arch/arm64/include/uapi/asm/kvm.h
    b/arch/arm64/include/uapi/asm/kvm.h<br>
    index f209ea1..803b097 100644<br>
    --- a/arch/arm64/include/uapi/asm/kvm.h<br>
    +++ b/arch/arm64/include/uapi/asm/kvm.h<br>
    @@ -203,6 +203,7 @@ struct kvm_arch_memory_slot {<br>
    =C2=A0#define=C2=A0=C2=A0 KVM_DEV_ARM_VGIC_OFFSET_MASK (0xffffffffULL=
 &lt;&lt;
    KVM_DEV_ARM_VGIC_OFFSET_SHIFT)<br>
    =C2=A0#define KVM_DEV_ARM_VGIC_GRP_NR_IRQS=C2=A0=C2=A0 3<br>
    =C2=A0#define KVM_DEV_ARM_VGIC_GRP_CTRL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 4<br>
    +#define KVM_DEV_ARM_VGIC_GRP_ADDR_OFFSET 5<br>
    =C2=A0#define=C2=A0=C2=A0 KVM_DEV_ARM_VGIC_CTRL_INIT=C2=A0=C2=A0 0<br=
>
    =C2=A0<br>
    =C2=A0/* Device Control API on vcpu fd */<br>
    diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c
    b/virt/kvm/arm/vgic/vgic-kvm-device.c<br>
    index 850eb88..3e33778 100644<br>
    --- a/virt/kvm/arm/vgic/vgic-kvm-device.c<br>
    +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c<br>
    @@ -196,8 +196,14 @@ static int vgic_get_common_attr(struct
    kvm_device *dev,<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 VGIC_NR_PRIVATE_IRQS, uaddr);<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_DEV_ARM_VGIC_GRP_ADDR_=
OFFSET: {<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u32 __user *uaddr =3D (u32 __user
    *)(long)attr-&gt;addr;<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u32 val =3D kvm_vgic_global_state.vcpu_base &amp;
    ~PAGE_MASK;<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 r =3D put_user(val, uaddr);<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 break;<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>
    =C2=A0<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return r;<br>
    =C2=A0}<br>
    =C2=A0<br>
    @@ -362,6 +368,7 @@ static int vgic_v2_has_attr(struct kvm_device
    *dev,<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_DEV_ARM_VGIC_GRP_=
CPU_REGS:<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return vgic_v2_has_attr_regs(dev, attr);<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_DEV_ARM_VGIC_GRP_=
NR_IRQS:<br>
    +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_DEV_ARM_VGIC_GRP_ADDR_=
OFFSET:<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return 0;<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_DEV_ARM_VGIC_GRP_=
CTRL:<br>
    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 switch (attr-&gt;attr) {
  </body>
</html>

--------------000803000007060306040703--

--===============7975415775139137475==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7975415775139137475==--
