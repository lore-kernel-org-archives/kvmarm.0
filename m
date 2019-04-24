From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: inject an async abort to host if SEA
 handling failed
Date: Wed, 24 Apr 2019 08:46:39 +0100
Message-ID: <06e33e9a-9c77-09bf-d53f-94496cffe8ef@arm.com>
References: <1556080907-25158-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556080907-25158-1-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>, christoffer.dall@arm.com, james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 24/04/2019 05:41, Dongjiu Geng wrote:
> If host failed to handle the SEA, KVM should inject an async abort
> to guest for both SEA data and instruction abort, but it currently
> only handles the data abort, so correct it.
> 
> Cc: James Morse <james.morse@arm.com>
> Cc: Xiang Zheng <zhengxiang9@huawei.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  virt/kvm/arm/mmu.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 27c9583..5882516 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1924,14 +1924,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		/*
>  		 * For RAS the host kernel may handle this abort.
>  		 * There is no need to pass the error into the guest.
> +		 * If host failed to handle it, inject an async abort
> +		 * to guest.
>  		 */
> -		if (!kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_hsr(vcpu)))
> -			return 1;
> -
> -		if (unlikely(!is_iabt)) {
> +		if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_hsr(vcpu)))

We've so far excluded instruction aborts from the delivery of a virtual
SError. You now decide to inject an SError in all cases, but your commit
message doesn't explain *why* this is a sensible thing to do.

I'm not saying that this patch is wrong (the IABT handling predates RAS
by several years and was  designed to deal with with badly behaved guest
rather than flaky HW), but I'd like to understand why you think it is right.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
