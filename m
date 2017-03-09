From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH RFC 5/7] ARM64: KVM: Support cross type vCPU
Date: Thu, 9 Mar 2017 02:56:52 -0800
Message-ID: <20170309105652.GC114809@lvm>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-6-git-send-email-zhaoshenglong@huawei.com>
 <20170128144754.cl7pikdwxbw7ovwz@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA62140A14
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 06:02:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jeYrMo3UhGov for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 06:02:56 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D24740625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 06:02:55 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id n11so53078307wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 03:04:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170128144754.cl7pikdwxbw7ovwz@hawk.localdomain>
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
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 28, 2017 at 03:47:54PM +0100, Andrew Jones wrote:
> On Mon, Jan 16, 2017 at 05:33:32PM +0800, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao@linaro.org>
> > 
> > Add a capability to tell userspace that KVM supports cross type vCPU.
> > Add a cpu feature for userspace to set when it doesn't use host type
> > vCPU and kvm_vcpu_preferred_target return the host MIDR register value
> > so that userspace can check whether its requested vCPU type macthes the
> > one of physical CPU and if so, KVM will not trap ID registers even
> > though userspace doesn't specify -cpu host.
> > Guest accesses MIDR through VPIDR_EL2 so we save/restore it no matter
> > it's a cross type vCPU.
> > 
> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> > ---
> >  arch/arm/kvm/arm.c                   | 10 ++++++++--
> >  arch/arm64/include/asm/kvm_emulate.h |  3 +++
> >  arch/arm64/include/asm/kvm_host.h    |  3 ++-
> >  arch/arm64/include/uapi/asm/kvm.h    |  1 +
> >  arch/arm64/kvm/guest.c               | 17 ++++++++++++++++-
> >  arch/arm64/kvm/hyp/sysreg-sr.c       |  2 ++
> >  include/uapi/linux/kvm.h             |  1 +
> >  7 files changed, 33 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index 1167678..bdceb19 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_ARM_PSCI_0_2:
> >  	case KVM_CAP_READONLY_MEM:
> >  	case KVM_CAP_MP_STATE:
> > +	case KVM_CAP_ARM_CROSS_VCPU:
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_COALESCED_MMIO:
> > @@ -809,8 +810,9 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >  {
> >  	unsigned int i;
> >  	int phys_target = kvm_target_cpu();
> > +	bool cross_vcpu = kvm_vcpu_has_feature_cross_cpu(init);
> >  
> > -	if (init->target != phys_target)
> > +	if (!cross_vcpu && init->target != phys_target)
> >  		return -EINVAL;
> 
> I'm not sure we need the vcpu feature bit. I think qemu should be
> allowed to try any target (if using -cpu host it will try the
> kvm preferred target). kvm should check that the input target is
> a known target and that it is compatible with the phys_target,
> otherwise -EINVAL.
> 

I agree. I think we just need to advertise the capability to user space
instead.

Thanks,
-Christoffer
