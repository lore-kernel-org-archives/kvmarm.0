From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 17/19] arm/arm64: KVM: Inject virtual abort when guest
 exits on external abort
Date: Thu, 8 Sep 2016 11:09:33 +0200
Message-ID: <20160908090933.GV23592@cbox>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
 <1473166937-15271-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C7C4998D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 04:58:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id adOuDf-HREPQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 04:58:33 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08FDD41AF6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 04:58:32 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id 1so76266347wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2016 02:07:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473166937-15271-18-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 06, 2016 at 02:02:15PM +0100, Marc Zyngier wrote:
> If we spot a data abort bearing the ESR_EL2.EA bit set, we know that
> this is an external abort, and that should be punished by a the injection

nit: s/a//

(I can fix this up though)

> of an abort.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/mmu.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index bda27b6..6827b54 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1434,6 +1434,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	int ret, idx;
>  
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
> +		kvm_inject_vabt(vcpu);
> +		return 1;
> +	}
> +
>  	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>  
>  	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
> -- 
> 2.1.4
> 
