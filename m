From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH RFC 6/7] ARM64: KVM: Support heterogeneous system
Date: Wed, 15 Mar 2017 14:36:45 +0100
Message-ID: <20170315133645.GQ1277@cbox>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-7-git-send-email-zhaoshenglong@huawei.com>
 <20170128145551.sknp447ieue56xgo@hawk.localdomain>
 <20170315115044.GO1277@cbox>
 <20170315125113.erfl2gk6fwmbccsn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 091A240B58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 09:35:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nWfMQAxm26wN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 09:35:22 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DBD440A54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 09:35:22 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id n11so87843460wma.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 06:36:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170315125113.erfl2gk6fwmbccsn@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, wu.wubin@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 15, 2017 at 01:51:13PM +0100, Andrew Jones wrote:
> On Wed, Mar 15, 2017 at 12:50:44PM +0100, Christoffer Dall wrote:
> > Hi Drew,
> > 
> > [Replying here to try to capture the discussion about this patch we had
> > at connect].
> > 
> > On Sat, Jan 28, 2017 at 03:55:51PM +0100, Andrew Jones wrote:
> > > On Mon, Jan 16, 2017 at 05:33:33PM +0800, Shannon Zhao wrote:
> > > > From: Shannon Zhao <shannon.zhao@linaro.org>
> > > > 
> > > > When initializing KVM, check whether physical hardware is a
> > > > heterogeneous system through the MIDR values. If so, force userspace to
> > > > set the KVM_ARM_VCPU_CROSS feature bit. Otherwise, it should fail to
> > > > initialize VCPUs.
> > > > 
> > > > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> > > > ---
> > > >  arch/arm/kvm/arm.c       | 26 ++++++++++++++++++++++++++
> > > >  include/uapi/linux/kvm.h |  1 +
> > > >  2 files changed, 27 insertions(+)
> > > > 
> > > > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > > > index bdceb19..21ec070 100644
> > > > --- a/arch/arm/kvm/arm.c
> > > > +++ b/arch/arm/kvm/arm.c
> > > > @@ -46,6 +46,7 @@
> > > >  #include <asm/kvm_coproc.h>
> > > >  #include <asm/kvm_psci.h>
> > > >  #include <asm/sections.h>
> > > > +#include <asm/cputype.h>
> > > >  
> > > >  #ifdef REQUIRES_VIRT
> > > >  __asm__(".arch_extension	virt");
> > > > @@ -65,6 +66,7 @@ static unsigned int kvm_vmid_bits __read_mostly;
> > > >  static DEFINE_SPINLOCK(kvm_vmid_lock);
> > > >  
> > > >  static bool vgic_present;
> > > > +static bool heterogeneous_system;
> > > >  
> > > >  static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
> > > >  
> > > > @@ -210,6 +212,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > > >  	case KVM_CAP_ARM_CROSS_VCPU:
> > > >  		r = 1;
> > > >  		break;
> > > > +	case KVM_CAP_ARM_HETEROGENEOUS:
> > > > +		r = heterogeneous_system;
> > > > +		break;
> > > 
> > > What's this for? When/why would usespace check it?
> > > 
> > 
> > Without a capability, how can userspace tell the difference between "I
> > got -EINVAL because I'm on an old kernel" or "I asked for something that
> > any kernel cannot emulate"?
> > 
> > Do we need to distinguish between these cases?
> 
> Yup, I'm in full agreement that we need a capability for the
> cross-vcpu support. Above this heterogeneous one there's the
> CROSS_VCPU one though. Do we need both? 

Probably not.

> If QEMU wants to know
> whether or not the host it's running on is heterogeneous, then
> it can just query sysfs, rather than ask KVM.
> 

Can it?  Is this information available in a reliable way from userspace?

> > 
> > > >  	case KVM_CAP_COALESCED_MMIO:
> > > >  		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
> > > >  		break;
> > > > @@ -812,6 +817,12 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> > > >  	int phys_target = kvm_target_cpu();
> > > >  	bool cross_vcpu = kvm_vcpu_has_feature_cross_cpu(init);
> > > >  
> > > > +	if (heterogeneous_system && !cross_vcpu) {
> > > > +		kvm_err("%s:Host is a heterogeneous system, set KVM_ARM_VCPU_CROSS bit\n",
> > > > +			__func__);
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > Instead of forcing userspace to set a bit, why not just confirm the
> > > target selected will work? E.g. if only generic works on a heterogeneous
> > > system then just 
> > > 
> > >  if (heterogeneous_system && init->target != GENERIC)
> > >     return -EINVAL
> > > 
> > > should work
> > > 
> > 
> > Yes, I think we concluded that if we advertise if we can do the
> > cross type emulation or not, then if we can do the emulation we should
> > just do it when possible, for maximum user experience.
> 
> Your agreement here implies to me that we only need the one capability.
> 

Yes.

> > 
> > I'm sure I missed some aspect of this discussion though.
> 
> Me too. As we discussed, it's probably time to try and hash out a fresh
> design doc. It'd be good to get a clear design agreed upon before
> returning to the patches.
> 

Yes, it's on my list.

Thanks,
-Christoffer
