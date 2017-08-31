From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 0/4] kvm: arm/arm64: vgic: APRn uaccess support.
Date: Thu, 31 Aug 2017 22:33:56 +0200
Message-ID: <20170831203356.GE13572@cbox>
References: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6807149C2A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 16:31:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RjFGIPnVwHbx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Aug 2017 16:31:45 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0C5049C1C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 16:31:44 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id v2so4540384wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 13:33:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wanghaibin,

On Wed, Aug 23, 2017 at 09:05:22AM +0800, wanghaibin wrote:
> v3: Coding style fix.
>     Add the valid APRn access check which Marc proposed. 
> 
> v2: Split the patch again to make it easier for review
>     some fixes were proposed by Marc

Usually we put the changelog at the end of the description, before the
diff state.  I suggest you have a look at other patch series on the
kvmarm list or on the ARM linux mailing list and see how most people do
it.

> 
> v1: the problem describe:
> In the case (GICv2 on GICv3 migration), I did the test on my board as follow:
> vm boot => migrate to destination => shutdown at destination => start at destination 
> => migrate back to source ... go round and begin again;
> 
> I tested many times, but unlucky, there maybe failed by accident when shutdown the vm 
> at destination. (GICv3 on GICv3 migration, 1000+ times, That's OK).
> while failed,  we can watch the interrupts in the vm, some vcpus of the vm can not 
> receive the virt timer interrupt. And, these vcpus will 100% with top tool at host.
> 
> vgic_state debug file at destination shows(a active virt timer interrupt) that:
> VCPU 0 TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID
> ---------------------------------------------------------------
>             ....................
>        PPI   25      0 000001        0        1   0 160      -1
>        PPI   26      0 000001        0        1   0 160      -1
>        PPI   27      0 011111       27        1   0 160       0
> 
> 
> I added log to print ICH* registers for VCPU0 at destination:
> **HCR:0x1, VMCR:0xf0ec0001,SRE:0x0, ELRSR:0xe**
> -----AP0R:0: 0x0------
> -----AP0R:1: 0x0------
> -----AP0R:2: 0x0------
> -----AP0R:3: 0x0------
> -----AP1R:0: 0x0------
> -----AP1R:1: 0x0------
> -----AP1R:2: 0x0------
> -----AP1R:3: 0x0------
> -----LR:0: 0xa0a0001b0000001b------
> -----LR:1: 0x0------
> -----LR:2: 0x0------
> -----LR:3: 0x0------
> 
> and the ICH_AP1R0 value is 0x10000 at source.
> 
> At present, QEMU have supproted GICC_APRn put/set interface for emulated GICv2,
> and kvm does not support the uaccess interface. This patchset try to support this.
> 

So I feel like this series is horribly complicated for what it does, and
does things in the reverse order.  If you really want to take your
appraoch, it would be much nicer if you first changed existing functions
and added infrastructure, and then in the end wired it up to the user
space ABI.  In other words, reverse your patches.

However, I think I have a simpler approach to solving this.  Please have
a look at this:

commit 1d49c5ef047a2218379aa170d9a3bdd39cd70e3a (HEAD -> gicv2-apr-uaccess)
Author: Christoffer Dall <cdall@linaro.org>
Date:   Thu Aug 31 22:24:25 2017 +0200

    KVM: arm/arm64: Support uaccess of GICC_APRn
    
    When migrating guests around we need to know the active priorities to
    ensure functional virtual interrupt prioritization by the GIC.
    
    This commit clarifies the API and how active priorities of interrupts in
    different groups are represented, and implements the accessor functions
    for the uaccess register range.
    
    We live with a slight layering violation in accessing GICv3 data
    structures from vgic-mmio-v2.c, because anything else just adds too much
    complexity for us to deal with (it's not like there's a benefit
    elsewhere in the code of an intermediate representation as is the case
    with the VMCR).  We accept this, because while doing v3 processing from
    a file named something-v2.c can look strange at first, this really is
    specific to dealing with the user space interface for something that
    looks like a GICv2.
    
    Signed-off-by: Christoffer Dall <cdall@linaro.org>

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index b2f60ca..b3ce126 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -83,6 +83,11 @@ Groups:
 
     Bits for undefined preemption levels are RAZ/WI.
 
+    Note that this differs from a CPU's view of the APRs on hardware in which
+    a GIC without the security extensions expose group 0 and group 1 active
+    priorities in separate register groups, whereas we show a combined view
+    similar to GICv2's GICH_APR.
+
     For historical reasons and to provide ABI compatibility with userspace we
     export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
     field in the lower 5 bits of a word, meaning that userspace must always
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 37522e6..5436989 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -303,6 +303,45 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	vgic_set_vmcr(vcpu, &vmcr);
 }
 
+static unsigned long vgic_mmio_read_apr(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len)
+{
+	int n; /* which APRn is this */
+
+	n = (addr >> 2) & 0x3;
+
+	if (kvm_vgic_global_state.type == VGIC_V2) {
+		/* GICv2 hardware systems support max. 32 groups */
+		if (n != 0)
+			return 0;
+		return vcpu->arch.vgic_cpu.vgic_v2.vgic_apr;
+	} else {
+		struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
+		return vgicv3->vgic_ap0r[n] | vgicv3->vgic_ap1r[n];
+	}
+}
+
+static void vgic_mmio_write_apr(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
+{
+	int n; /* which APRn is this */
+
+	n = (addr >> 2) & 0x3;
+
+	if (kvm_vgic_global_state.type == VGIC_V2) {
+		/* GICv2 hardware systems support max. 32 groups */
+		if (n != 0)
+			return;
+		vcpu->arch.vgic_cpu.vgic_v2.vgic_apr = val;
+	} else {
+		struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
+		vgicv3->vgic_ap1r[n] = val;
+	}
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -364,7 +403,7 @@ static const struct vgic_register_region vgic_v2_cpu_registers[] = {
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		vgic_mmio_read_apr, vgic_mmio_write_apr, 16,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,


Thanks,
-Christoffer
