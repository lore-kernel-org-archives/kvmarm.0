Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6211D319B
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 18:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728326386; cv=none; b=XnXYl4N1QdT1kZ3zcK92iW64PqMgl8INtn/g1JSDXsi+AcAaMKelW18dxsnU0DfDnsyFhjyhaBjKW5LMJoTcYFTQdaz2dzI9sW4zJSTjURY0XenD34ZEdR3D5G9PvwWzN3yF0xqjRsgTWIybuZzlAh/QnabkVPUKL5TmB+IqiuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728326386; c=relaxed/simple;
	bh=fGvYOTBWAo43a/cG/VWMjqUp1hPAW9Qj1IJyFjs+ZK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aHpwqXa7c1ZPjAN6GPw7jd9JLOWzGfWzkgyrKESqtJoP0HK4YRyRa/Avl+rC5aDZ63NC4IUE8S2hZsiVFt05xrdeP7NhZRs//GbKHcJJxxbibwGtXwJN0tzem4mZ6h/TwOwysiPF+DYYypXCP650X2fYAltLHiz+gde8KSMvApo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4L1+iSlv; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4L1+iSlv"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e1fbe2a6b1so79512277b3.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 11:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728326384; x=1728931184; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WJVmL8JMJ+lhyHYBsyCiv7y5fIWLqt5TrDYSVYZPx1Y=;
        b=4L1+iSlvz7fTpqv6fFztPZUkdAwu1i8I5Y03kjBV2NHLo620bg2V8HBTSLj/MiJGY+
         ak3a7zEw0X/TBKqFuYiQrXgn1wSECfYEGMBAmL1bQ9rO6ZJl09cKtB74a3UrdP9yQUvc
         d5J+DUmqTRZYXse6Ziu26r63/i40S26muaCAZfImHywLHPk1UTCxdAPv72G3nwAOxjlY
         gSSMj2gACr20cj3qzAS2wn8ksI8SI2a07EzarpMzFYM9CECrQnfY47fOUlJJ/bSp+4WT
         0UX1NgFnnlpVf6Rc808jrs0YrdP8X3f8n83ADEf1aKrYftSTEOd7gQORekq+winU1fZV
         EU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728326384; x=1728931184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJVmL8JMJ+lhyHYBsyCiv7y5fIWLqt5TrDYSVYZPx1Y=;
        b=M1vhL+3AirBLxYFcmTqXvxINkuYfbhOzUPwSWPPsDARIGmOqO+rNpLiotJxkxeQykB
         QsCP6emSa+bBDiODDRLk1QwsyH7YKae9LXVoPeWz7cqUGjMPTp1Cqx/f1ij5UpvKWjCW
         NaZaE6Z55b/TR7+rIC4+QL3pq3yqoUvPK0rMHz5Uy8abp9M3/BmARrBU4793fULsxHLQ
         GLt8KfuTajEmfYlMZjraMncDrkrKl8y8Lp76Ph1umxtMOJ7FNGgSWuossJ9fd8yCzPi+
         Jnfb2PJhkZykQnO1klQp8X9UAipFbuVvwfijSDR2kJ4NSeW1nGUC6E2j2STAUJTP6Mlw
         hK9g==
X-Gm-Message-State: AOJu0YzqoYEECGIzhbzWoTEQcEM710iHS2hS/k9/73+BR8W/4J3GxCb/
	a1VKgXiCDzweQpfPNdWRi6gNYQAoeycnBp4zXeByGQojicBsw+Vka7T4Pi4lNeUQ4tCcBBXGJI4
	PVw==
X-Google-Smtp-Source: AGHT+IFD8qLanmm5lTuGPXO6GRwJBfjkEIIbn6hGmEzy/PUz9Q9ehESCCF+UXQylzxFSFIRAm8N8RimlGo8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6d0a:b0:6db:c6ac:62a0 with SMTP id
 00721157ae682-6e2c72a0cc0mr2578697b3.5.1728326383920; Mon, 07 Oct 2024
 11:39:43 -0700 (PDT)
Date: Mon, 7 Oct 2024 11:39:37 -0700
In-Reply-To: <20241007164256.1795250-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241007164256.1795250-1-oliver.upton@linux.dev> <20241007164256.1795250-2-oliver.upton@linux.dev>
Message-ID: <ZwQq6Vk5_7Or4hW1@google.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU when
 scheduled out
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 07, 2024, Oliver Upton wrote:
> If a vCPU is scheduling out and not in WFI emulation, it is highly
> likely it will get scheduled again soon and reuse the MMU it had before.
> Dropping the MMU at vcpu_put() can have some unfortunate consequences,
> as the MMU could get reclaimed and used in a different context, forcing
> another 'cold start' on an otherwise active MMU.
> 
> Avoid that altogether by keeping a reference on the MMU if the vCPU is
> scheduling out, ensuring that another vCPU cannot reclaim it while the
> current vCPU is away. Since there are more MMUs than vCPUs, this does
> not affect the guarantee that an unused MMU is available at any time.
> 
> Furthermore, this makes the vcpu->arch.hw_mmu ~stable in preemptible
> code, at least for where it matters in the stage-2 abort path. Yes, the
> MMU can change across WFI emulation, but there isn't even a use case
> where this would matter.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/nested.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index f9e30dd34c7a..df670c14e1c6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -663,6 +663,13 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>  
>  void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * The vCPU kept its reference on the MMU after the last put, keep
> +	 * rolling with it.
> +	 */
> +	if (vcpu->arch.hw_mmu)
> +		return;
> +
>  	if (is_hyp_ctxt(vcpu)) {
>  		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>  	} else {
> @@ -674,10 +681,18 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>  
>  void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
> +	/*
> +	 * Keep a reference on the associated stage-2 MMU if the vCPU is
> +	 * scheduling out and not in WFI emulation, suggesting it is likely to
> +	 * reuse the MMU sometime soon.
> +	 */
> +	if (vcpu->scheduled_out && !vcpu_get_flag(vcpu, IN_WFI))
> +		return;

Assuming KVM arm64 supports halt-polling, I think it makes more sense to check
kvm_vcpu_is_blocking() instead of IN_WFI.  That way, KVM will keep the MMU resident
if the vCPU happens to be preempted and halt-polling is successful.

And somewhat of a side topic, calling kvm_vgic_put() from kvm_arch_vcpu_blocking()
instead of kvm_vcpu_wfi() would provide the same optimization for the GIC, as KVM
would only need to put/reload the vGIC if the vCPU is actually scheduled out.

Unfortunately, using kvm_vcpu_is_blocking() in vgic_v4_put() won't do the right
thing, as KVM deliberately calls prepare_to_rcuwait() _after_ kvm_arch_vcpu_blocking(),
because x86's AVIC implementation relies on kvm_vcpu_is_blocking() to be false
when reloading after unblocking.

Aha!  With vcpu->scheduled_out, I think we can swap the order and make it more
obvious what's going on in the AVIC code at the same time.  With that, I think
KVM arm64 could drop IN_WFI and use kvm_vcpu_is_blocking() throughout.  E.g.

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..bba93d1d65ae 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1038,13 +1038,12 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
                return;
 
        /*
-        * No need to update anything if the vCPU is blocking, i.e. if the vCPU
-        * is being scheduled in after being preempted.  The CPU entries in the
-        * Physical APIC table and IRTE are consumed iff IsRun{ning} is '1'.
-        * If the vCPU was migrated, its new CPU value will be stuffed when the
-        * vCPU unblocks.
+        * No need to update anything if the vCPU is preempted while blocking.
+        * The CPU entries in the Physical APIC table and IRTE are consumed iff
+        * IsRun{ning} is '1'.  If the vCPU was migrated, its new CPU value
+        * will be stuffed when the vCPU unblocks.
         */
-       if (kvm_vcpu_is_blocking(vcpu))
+       if (kvm_vcpu_is_blocking(vcpu) && vcpu->scheduled_out)
                return;
 
        /*
