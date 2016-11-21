From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 6/7] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Mon, 21 Nov 2016 14:41:13 +0100
Message-ID: <20161121134113.GE23588@cbox>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <1478258013-6669-7-git-send-email-vijay.kilari@gmail.com>
 <20161116185232.GF3811@cbox>
 <CALicx6t5D5n3dDQzeKZNUWdS-q5LNiSq-UrP4HdmbdUCj1tF1g@mail.gmail.com>
 <20161117160951.GB23588@cbox>
 <CALicx6uxU8nC+gayWAxf_BX7JrZ9twsFr4YfMr64bNUSneqZow@mail.gmail.com>
 <20161120132005.GC23588@cbox>
 <CALicx6sxchAbDJ2rioTytwFG1C0tD-Fnr4HC-DweSdkkCF7BFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D29F403F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 08:40:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I05nOys8VnIF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2016 08:40:44 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCD1E40293
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 08:40:43 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id f82so145632482wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2016 05:41:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6sxchAbDJ2rioTytwFG1C0tD-Fnr4HC-DweSdkkCF7BFw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 21, 2016 at 07:02:36PM +0530, Vijay Kilari wrote:
> On Sun, Nov 20, 2016 at 6:50 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Sat, Nov 19, 2016 at 12:18:53AM +0530, Vijay Kilari wrote:
> >> On Thu, Nov 17, 2016 at 9:39 PM, Christoffer Dall
> >> <christoffer.dall@linaro.org> wrote:
> >> > On Thu, Nov 17, 2016 at 09:25:59PM +0530, Vijay Kilari wrote:
> >> >> On Thu, Nov 17, 2016 at 12:22 AM, Christoffer Dall
> >> >> <christoffer.dall@linaro.org> wrote:
> >> >> > On Fri, Nov 04, 2016 at 04:43:32PM +0530, vijay.kilari@gmail.com wrote:
> >> >> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> >> >>
> >> >> >> VGICv3 CPU interface registers are accessed using
> >> >> >> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> >> >> >> as 64-bit. The cpu MPIDR value is passed along with register id.
> >> >> >> is used to identify the cpu for registers access.
> >> >> >>
> >> >> >> The version of VGIC v3 specification is define here
> >> >> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> >> >> >>
> >> >> >> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> >> >> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> >> >> ---
> >> >> >>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
> >> >> >>  arch/arm64/kvm/Makefile             |   1 +
> >> >> >>  include/kvm/arm_vgic.h              |   9 +
> >> >> >>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 +++
> >> >> >>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  19 +++
> >> >> >>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 324 ++++++++++++++++++++++++++++++++++++
> >> >> >>  virt/kvm/arm/vgic/vgic-v3.c         |   8 +
> >> >> >>  virt/kvm/arm/vgic/vgic.h            |   4 +
> >> >> >>  8 files changed, 395 insertions(+)
> >> >> >>
> >> >> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >> >> >> index 56dc08d..91c7137 100644
> >> >> >> --- a/arch/arm64/include/uapi/asm/kvm.h
> >> >> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >> >> >> @@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
> >> >> >>                       (0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
> >> >> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT      0
> >> >> >>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK       (0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> >> >> >> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
> >> >> >>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS 3
> >> >> >>  #define KVM_DEV_ARM_VGIC_GRP_CTRL    4
> >> >> >>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >> >> >> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> >> >> >> +
> >> >> >>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT 0
> >> >> >>
> >> >> >>  /* Device Control API on vcpu fd */
> >> >> >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> >> >> >> index d50a82a..1a14e29 100644
> >> >> >> --- a/arch/arm64/kvm/Makefile
> >> >> >> +++ b/arch/arm64/kvm/Makefile
> >> >> >> @@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
> >> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
> >> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
> >> >> >>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> >> >> >> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
> >> >> >
> >> >> > Thi is making me wonder:  Are we properly handling GICv3 save/restore
> >> >> > for AArch32 now that we have GICv3 support for AArch32?  By properly I
> >> >> > mean that either it is clearly only supported on AArch64 systems or it's
> >> >> > supported on both AArch64 and AArch32, but it shouldn't break randomly
> >> >> > on AArch32.
> >> >>
> >> >> It supports both AArch64 and AArch64 in handling of system registers
> >> >> save/restore.
> >> >> All system registers that we save/restore are 32-bit for both aarch64
> >> >> and aarch32.
> >> >> Though opcode op0 should be zero for aarch32, the remaining Op and CRn codes
> >> >> are same. However the codes sent by qemu is matched and register
> >> >> are handled properly irrespective of AArch32 or AArch64.
> >> >>
> >> >> I don't have platform which support AArch32 guests to verify.
> >> >
> >> > Actually this is not about the guest, it's about an ARMv8 AArch32 host
> >> > that has a GICv3.
> >> >
> >> > I just tried to do a v7 compile with your patches, and it results in an
> >> > epic failure, so there's something for you to look at.
> >> >
> >>
> >> Could you please share you config file?. I tried with multi_v7 defconfig with
> >> CONFIG KVM and CONFIG_KVM_ARM_HOST enabled. it compiled for me.
> >
> > I think this has to do with which branch you apply your patches to.
> > When applied to kvmarm/next, it fails.
> >
> > Here's the integration I did:
> > https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git tmp-gicv3-migrate-v8
> >
> > Here's the config:
> > https://transfer.sh/xkAxp/.config
> >
> 
> Thanks for shareing the details, I could reproduce them.
> However virt/kvm/arm/vgic/vgic-sys-reg-v3.c is written with
> sys_regs_desc for AArch64.
> For AArch32/v7, it has be to coproc_reg. I propose to add separate file for arm
> which handles ICC* reg save/restore using coproc_reg.

That might make sense.  In that case they want to be moved into
arch/arm/kvm/ and arch/arm64/kvm/

-Christoffer
