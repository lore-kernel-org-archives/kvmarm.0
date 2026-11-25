Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610457;
	b=bjjZlKM3ZrQOGySZzOby43nVIHccz0SWxFNzMF1D4rKZ5Ri+uOatkfj1JtX8djsRHQQi
	 I211aOjVU+lZkZJFCghojqQ0JNepL9tUjb+KPz9Ut3PTBs1OFbHBKCxjeg0Qb0uihhrdm
	 9iW5WEDfhPWSDm7vbcIwU90e8woSintpPNag3ohfac6GpsZ9zYhjyjOuiAbEUZmvIEAU2
	 ZoG6JX9cnLOf3VSexyWMLFxSOpqhNhhj3l5MtUshtZQKYKQLiDU0Ip/6YyKPRN5nwkd0P
	 nTcB5gFu/um0s8vmvUfmqXM9NpDCNPi1YtSlFn0fDyjyX5p/gw4DMzDl6wrZ2tFjiMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610457;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9NPu3aDK/2YqdhrnjFTPM5ZeCK4ie5ETAEgfBAnFIH4=;
	b=zQTEwDZ9zJBBaLxoTJVmfuKTCLvlhGWbuupVjW50lcZVYpfIqTBpgboBoAyX0oKfuSKC
	 kLh5LWB32vXcYcveMXdeU61gjotAlXzmvbIHYn3UyDCfwVi1UJL2s1xd+8ha67fXuQBPM
	 h33vDv9VU/ntauyA+pg8roFFqBIpULcE8zfmC6K80fD3HL7l+VQnBAFNo4X7Su0/o3gTy
	 X0Ov/io/miOR9+YOPl20sbi/Flo4CYBXa6NKUCThynKkveNZZ68l2y4eq3RSJOUcMzg3G
	 GwEROnnjqCqgVcvA2TyU2xChnaNaqRr5zrHfIMpTiIVfObwvKjZArSlhzEBgNWmXRcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DmEMuVNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D5606A333
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 12:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DmEMuVNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA3E1F000D1;
	Wed, 25 Nov 2026 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795610456;
	bh=9NPu3aDK/2YqdhrnjFTPM5ZeCK4ie5ETAEgfBAnFIH4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DmEMuVNUyUgSvVi3N/0og9IrW6vuHBNTzUM+JsctCDTA+zefEpfvIm5j9dxoRNsor
	 ZO6yCAL/gUFqmzdytASQZWtZhp5lQ3ePmWprF/AN4DkTqK8hWYZFhkO/B1xP4+H7Tp
	 az/246VP6prRSzWi0I+DJJz2vCSlgKGbCUyyiB9wWkZYAigKA7EhtbQhY/Dc/8Ij65
	 keXgL4y5MtTdahfTp9dxetQ2bcTmoDYBtQHYYXfvi3E9Oen+AeKIQKWi8X6TpTeWqj
	 vnzvvIfAmINl1KtjxQFmkPLvUR+G15MBTM8bwhOkG5q54ot+mtnboyJWKr1pPWW9lh
	 pbS5ZJw3kz8SQ==
Message-ID: <sashiko-outbox-233383@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting
 an unmasked SError
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
References: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 12:40:53 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] KVM: arm64: nv: sleep in atomic in kvm_pmu_nested_transition()
  during KVM_RUN [1]
--

commit 0b7882ef6381cc8daa05a0be58edf59878cf99df
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: Drop a pending MMIO access when injecting an unmasked SError

This commit drops any pending MMIO access in kvm_inject_serror_esr() when
injecting an unmasked SError into a non-protected vCPU without nested
virtualization, matching the emulated exception entry path.

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index aa2011cc0d5a0..01bc8f098cf6e 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -386,6 +386,14 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64=
 esr)
>  		return 1;
>  	}
> =20
> +	/*
> +	 * Like the emulated entry above, an unmasked SError cancels the MMIO
> +	 * access the vcpu exited on.  The host's copy of a protected vcpu's
> +	 * PSTATE is stale so checking serror_is_masked() doesn't make sense.
> +	 */
> +	if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu))
> +		vcpu->mmio_needed =3D false;
> +
>  	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
>  	*vcpu_hcr(vcpu) |=3D HCR_EL2_VSE;
>  	return 1;

[Severity: High]
This problem wasn't introduced by this patch, but can
kvm_inject_serror_esr() sleep in atomic context [1] when routing a
pending SError to vEL2?

kvm_arch_vcpu_ioctl_run() calls kvm_nested_flush_hwstate() with preemption
disabled:

arch/arm64/kvm/arm.c:kvm_arch_vcpu_ioctl_run() {
    ...
		preempt_disable();

		if (kvm_vcpu_has_pmu(vcpu))
			kvm_pmu_flush_hwstate(vcpu);

		kvm_nested_flush_hwstate(vcpu);
    ...
}

When NESTED_SERROR_PENDING is set and the SError targets vEL2,
kvm_nested_flush_hwstate() calls kvm_inject_serror_esr() ->
kvm_inject_nested_serror() -> kvm_inject_nested() ->
kvm_pmu_nested_transition().  If an enabled PMU counter has different EL1
and EL2 event filters, kvm_pmu_nested_transition() calls
kvm_pmu_create_perf_event(), which calls perf_event_release_kernel() and
perf_event_create_kernel_counter() and sleeps on mutexes while preemption
is disabled.

[1] https://sashiko.dev/#/bug/linux-aa99e2cc-de31-4882-82e9-68786cf22648

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-serror-dro=
p-mmio-v1-1-48076f59608c@pereq.eu?part=3D1
