From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 8/9] KVM: arm/arm64: fix race in kvm_psci_vcpu_on
Date: Tue, 4 Apr 2017 21:42:08 +0200
Message-ID: <20170404194208.GH31208@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-9-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBE3340992
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 15:39:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYt-Uy3julRM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 15:39:53 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EC6740966
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 15:39:53 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id y22so34006428wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 12:42:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170331160658.4331-9-drjones@redhat.com>
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
Cc: Levente Kurusa <lkurusa@redhat.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 31, 2017 at 06:06:57PM +0200, Andrew Jones wrote:
> From: Levente Kurusa <lkurusa@redhat.com>
> 
> When two vcpus issue PSCI_CPU_ON on the same core at the same time,
> then it's possible for them to both enter the target vcpu's setup
> at the same time. This results in unexpected behaviors at best,
> and the potential for some nasty bugs at worst.
> 
> Signed-off-by: Levente Kurusa <lkurusa@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/kvm/psci.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> index f732484abc7a..0204daa899b1 100644
> --- a/arch/arm/kvm/psci.c
> +++ b/arch/arm/kvm/psci.c
> @@ -88,7 +88,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	 */
>  	if (!vcpu)
>  		return PSCI_RET_INVALID_PARAMS;
> -	if (!test_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
> +
> +	if (!test_and_clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests)) {
>  		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
>  			return PSCI_RET_ALREADY_ON;
>  		else
> @@ -116,7 +117,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	 * the general puspose registers are undefined upon CPU_ON.
>  	 */
>  	vcpu_set_reg(vcpu, 0, context_id);
> -	clear_bit(KVM_REQ_POWER_OFF, &vcpu->requests);
>  
>  	wq = kvm_arch_vcpu_wq(vcpu);
>  	swake_up(wq);
> -- 
> 2.9.3
> 

Depending on what you end up doing with the requests, if you keep the
bool flag you could just use the kvm->lock mutex instead.

Have you considered if there are any potential races between
kvm_psci_system_off() being called on one VCPU while two other VPCUs are
turning on the same CPU that is being turend off as part of system-wide
power down as well?

I'm wondering if this means we should take the kvm->lock at a higher
level when handling PSCI events...

Thanks,
-Christoffer
