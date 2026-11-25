Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591479;
	b=zp3FQtlHrUQLxV6LsohCZ7TCzuUEvL6cG6MAz6glg6m0M5G5IWWaZQWNFU6pl7xPuIPQ
	 BYs7L3Hu3ZmGAlHQXk5vlLyOXer6uPKlRBaEKTum1u7hIuLuE5VvPTmkE3CezRW9vhN98
	 6vMJPSDELzI+vsdqxPV+W9jokvMdzz2kkYK36ScAhJI1A3ulJv4Z1kXPbnnwb5L3Jo27c
	 WrzTCiKZNLGMWJXPCc8RYp6W7ETeuVlS7C2yTNk6YDhcxwf9+BeGh/BlmzI+cVklDrKbc
	 7OOjqHJlTalEcnKTvQnU1uZtT8WWYpu8jP/YtUxNLX5KRdD4G0U5VzotEzB4fMkMimw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591479;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+l93dXtHRQW0EV58b/3nKh4/KSBiO7DJ6aZmG48jBL8=;
	b=A5sh4YDKYXTn2hP6how7pirnXXaIqnqf++EyT03GyPMsHztqEW80FVZ1bOTWAvfNI3pt
	 JT5esQHg+W3jjl6j7uMKRnCNBScNlRW9c+gPCRsT/bL3cUBhUKEBv9F32NZ4AKV0lxxju
	 KQbvQiJrrNjr11buKgZnu2lGlIINHFylNnfGmQF631s9W/WMktttqci5nEKi1mLGfy69R
	 n9EBcYt4U9na+shfHjGZhF0GAdaCmfwu1oA7g7ij0VGvNOEQ2sDsSVQJGAwETCckA42Mr
	 InVqM0VSLgIXw/e7MycDhiruRnKuHSoiHHd3lBmbC9ZTb/t+a/0k26oSZUASCjF1ykg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loeKHpXa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26D5606A321;
	Wed, 25 Nov 2026 07:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loeKHpXa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C43C1F000C6;
	Wed, 25 Nov 2026 07:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795591479;
	bh=+l93dXtHRQW0EV58b/3nKh4/KSBiO7DJ6aZmG48jBL8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=loeKHpXaBC9FrNf66nSNMrP9Axjcq9SJIDc5wrvXJgRG/vfAoOI3DI0Wv4zSWAbb7
	 ZNbGCJGZzOZCJGQcdoSvVxSZIx/AqIuKtHInsbChPb4Rjn5r5eegCXwOTt1SUhmFY/
	 lLsrUwRJo0qNDGT7ht72vkgms8Sw6eyHAsUFEn4yuD+0yRJPpXCMpxlcpeiMiETtbS
	 AbZTAdXEnd3AYqHnoXk9Cryi3KjUte8jI4rPRzEGHwhcYOJIayjbFM0COMkHzyljQy
	 UaaFQwdK1w5AA9aEA/h88YBPzp/h2rflaQHM7gueiZETbKxuLmG6iHjOwlG7T2MH8e
	 hQCqgoJziUalg==
Message-ID: <sashiko-outbox-232776@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] KVM: arm64: nv: Don't deliver a pending SError
 to the wrong guest
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261125-double_exception-v2-6-224689d8a764@pereq.eu>
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-6-224689d8a764@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:24:38 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] KVM: arm64: nv: sleeping in atomic context via
  kvm_nested_flush_hwstate()
--

commit 81f527c7f211ae919b4cadce520f83a546cfd38d
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: nv: Don't deliver a pending SError to the wrong guest

This commit stashes a pending HCR_EL2.VSE bit into NESTED_SERROR_PENDING
when switching between L1 and L2 so that kvm_nested_flush_hwstate()
re-evaluates SError routing in the new context.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 39136a89d74bb..cccaf02610e87 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2792,6 +2792,18 @@ static u64 kvm_check_illegal_exception_return(stru=
ct kvm_vcpu *vcpu, u64 spsr)
>  	return spsr;
>  }
> =20
> +/*
> + * HCR_EL2.VSE was set for the context we are leaving.  Store the SError
> + * instead, so that kvm_nested_flush_hwstate() routes it in the new cont=
ext.
> + */
> +static void kvm_nested_stash_serror(struct kvm_vcpu *vcpu)
> +{
> +	if (*vcpu_hcr(vcpu) & HCR_EL2_VSE) {
> +		*vcpu_hcr(vcpu) &=3D ~HCR_EL2_VSE;
> +		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
> +	}
> +}
> +
>  void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  {
>  	u64 spsr, elr, esr;
> @@ -2823,6 +2835,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  	preempt_disable();
>  	vcpu_set_flag(vcpu, IN_NESTED_ERET);
>  	kvm_arch_vcpu_put(vcpu);
> +	kvm_nested_stash_serror(vcpu);

[Severity: High]
Can stashing NESTED_SERROR_PENDING here cause sleeping in atomic context
on the next guest entry when a virtual PMU counter is active?

When L1 has a masked pending SError in HCR_EL2_VSE with HCR_EL2.AMO set
and executes ERET into L2, setting NESTED_SERROR_PENDING causes the next
iteration of kvm_arch_vcpu_ioctl_run() to re-inject the SError back to
vEL2 while preemption is disabled:

  kvm_arch_vcpu_ioctl_run()
    preempt_disable()
    kvm_nested_flush_hwstate()
      kvm_inject_serror_esr()
        kvm_inject_nested_serror()
          kvm_inject_nested()
            preempt_disable()
            ...
            preempt_enable()
            kvm_pmu_nested_transition()
              kvm_pmu_create_perf_event()

Because kvm_inject_nested() only balances its own inner preempt_disable(),
the outer preempt_disable() from kvm_arch_vcpu_ioctl_run() is still in
effect when kvm_pmu_nested_transition() recreates perf events for counters
whose EL1 and EL2 filters differ.  kvm_pmu_create_perf_event() then calls
perf_event_release_kernel() and perf_event_create_kernel_counter(), which
acquire sleeping mutexes and allocate with GFP_KERNEL while atomic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-double_exc=
eption-v2-0-224689d8a764@pereq.eu?part=3D6
