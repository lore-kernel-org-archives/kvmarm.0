Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D4C3EB7FD
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 09:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503845; cv=none; b=a2y4ICPs4rb9OMFQiTgkwx+LWYw719/2doITnJ4mSF/QnsM9NkjB9sZIMDVIqHPtSUlyhX3dO6XnaX1LWvE0ev0YFTDcrujhFJWcNoVhigz6EpRlZz9ngan/cup2VxIyENn9mPbDyvBpbCeSHExbS59XJfG+GYg5IUOJ3SKENUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503845; c=relaxed/simple;
	bh=iAp/2iIyG11ZG11l4saqEYvca5yGcgnsjr+HcDo3CNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UkDRwFEVj0FnLCGpU42XRpmtAAPb976N61I/olQNlKkQGsVoZWl6eQ3fLsrTnnPzkd9eDsGLrktKveWK4R1GwavBMWVdEe+64Y50s2/oWHmWqYnp2DX0/YWw50dMY92w59YwqXQiz+VTqrf+Uf7ajdCL7U5BTVZOmx7zyNVflU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=i5/M71p/ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="i5/M71p/"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 6689hWTh023275
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 8 Jul 2026 18:43:33 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=5rGUgl8D8cEFi7JteuJI6fPSAC+UPbsjLAqZsYFvBLY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1783503813; v=1;
        b=i5/M71p/b8sSTK+HDV4OHUq/SgIc9wIyvsE8xdPImpdn4DlyASk6OCwfGZiB4AV7
         QixiwPfKNM++x5DdafRW/wl24DGg0NFa9IXroeXxpS7Ln4z8cH+dgAgzI2mNJDsa
         UV9SYpU2sL7Fj/lLqQ2OhnQvVNrtgUbruVG3CpWZtD6XWrqmqcyKKmBQhedrymw/
         b7yXnKmuqBcMfeGZn753Chok+ZaLEfh/NCxlJHLRF1R24b5NQelMjxXXrRqf2tfc
         j0RVP2JGVBe8gnVi4sSl4zm+FMOJgW7vQqeWrmMc7510oHCGR+oU4a8OvPvWYPt/
         /diQ9dYSZcwlUnWPP3IqKg==
Message-ID: <a2d7ed42-b82e-4c0c-8985-32c12d7c49b0@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 8 Jul 2026 18:43:32 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/7] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvyvclUQ2b2YHiU@kernel.org>
 <cb5d5f13-a1a9-47dd-a717-5533a8b32b20@rsg.ci.i.u-tokyo.ac.jp>
 <5e66748a-bfda-41a9-8614-88cbf2fe1f09@rsg.ci.i.u-tokyo.ac.jp>
 <ak0_PSnxyAWm9_Fu@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <ak0_PSnxyAWm9_Fu@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/07/08 3:02, Oliver Upton wrote:
> On Tue, Jul 07, 2026 at 09:52:49PM +0900, Akihiko Odaki wrote:
>> On 2026/07/07 20:23, Akihiko Odaki wrote:
>>> On 2026/07/07 3:23, Oliver Upton wrote:
>>>> Just detect the changing PMU implementation here, KVM_REQ_RELOAD_PMU
>>>> will need to detect the PMCs that require an update anyway. Stash the
>>>> last cpu in kvm_arch_vcpu_load() and pass it to this:
>>>>
>>>> void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu)
>>>> {
>>>>      if (!kvm_pmu_fixed_counters_only(vcpu->kvm) || vcpu->cpu == last_cpu)
>>>>          return;
>>>>
>>>>      if (kvm_pmu_probe_armpmu(vcpu->cpu) !=
>>>> kvm_pmu_probe_armpmu(last_cpu))
>>>>          kvm_make_request(KVM_REQ_RELOAD_PMU);
>>>> }
>>>
>>> It is a nice way to simplify the code and to avoid hardcoding
>>> ARMV8_PMU_INSTR_IDX. I'll use the code for the next version.
>>
>> I tried this but unfortunately it doesn't seem to work. kvm_arch_vcpu_put()
>> sets vcpu->cpu to -1 so we cannot simply read it to get the last cpu in
>> kvm_arch_vcpu_load().
> 
> Urgh, there's no reason for doing that any more. Let's fix it, I want a
> straightforward way to detect pCPU migrations. There may be other
> reasons for using it in the future.
> 
> Untested, but could you give this a whirl?

It looks good to me. I'll test it and include it in the next version.

Regards,
Akihiko Odaki

> 
>  From bb5af058030aada66f5c9eafa54db604979acf55 Mon Sep 17 00:00:00 2001
> From: Oliver Upton <oupton@kernel.org>
> Date: Tue, 7 Jul 2026 09:50:00 -0700
> Subject: [PATCH] KVM: arm64: Don't clear vcpu->cpu in kvm_arch_vcpu_put()
> 
> commit e9b152cb957c ("arm/arm64: kvm: Set vcpu->cpu to -1 on vcpu_put")
> reset vcpu->cpu in order for the VGIC to determine if there was any vCPU
> running at the time of access. The VGIC has gone through an entire
> rewrite since then, and with commit 7d450e282171 ("KVM: arm/arm64:
> vgic-new: Add userland access to VGIC dist registers") the user
> accessors just grab all vCPU mutexes instead.
> 
> Drop this remaining vestige such that kvm_arch_vcpu_load() can properly
> detect a CPU migration. While at it, rework kvm_reset_vcpu() to do a
> much more pedantic check that the provided vCPU is actually what's
> running on the present CPU.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>   arch/arm64/kvm/arm.c   |  1 -
>   arch/arm64/kvm/reset.c | 15 ++++++++++-----
>   2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be8..735acc42b50b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -749,7 +749,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   	kvm_arm_vmid_clear_active();
>   
>   	vcpu_clear_on_unsupported_cpu(vcpu);
> -	vcpu->cpu = -1;
>   }
>   
>   static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b963fd975aac..6aba085c0673 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -190,7 +190,8 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_reset_state reset_state;
> -	bool loaded;
> +	struct kvm_vcpu *running;
> +	bool loaded = false;
>   	u32 pstate;
>   
>   	spin_lock(&vcpu->arch.mp_state_lock);
> @@ -198,10 +199,15 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   	vcpu->arch.reset_state.reset = false;
>   	spin_unlock(&vcpu->arch.mp_state_lock);
>   
> -	preempt_disable();
> -	loaded = (vcpu->cpu != -1);
> -	if (loaded)
> +	guard(preempt)();
> +
> +	if ((running = kvm_get_running_vcpu())) {
> +		if (KVM_BUG_ON(running != vcpu, vcpu->kvm))
> +			return;
> +
> +		loaded = true;
>   		kvm_arch_vcpu_put(vcpu);
> +	}
>   
>   	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
>   		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
> @@ -269,7 +275,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   
>   	if (loaded)
>   		kvm_arch_vcpu_load(vcpu, smp_processor_id());
> -	preempt_enable();
>   }
>   
>   u32 kvm_get_pa_bits(struct kvm *kvm)

