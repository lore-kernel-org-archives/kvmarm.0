Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C902E7621
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781455601; cv=none; b=h7eHwtKIYnaibqmPoaInMU71NJkrahy7DjEQshs7Aiqlo4Fv3fQjnDxY67Jp5w+qLJ3cWMztVU7xxaHEuoXGs+VLp2VyG04kwx2ZylLE2taOfbciMf4Cn6ntKKmUnKzrzGOxO5rZWIVUC7MwCr/yUS4SNht4CCN4GVdPMsYpkPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781455601; c=relaxed/simple;
	bh=MnI/O2EOJdWb2oOHPisads/PbUNGMXRqq/qoaORFjC8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ojpX5j1kQDu7s7KXP7qGRadvtdYtLWDWAXKOkUU+IG+4ExMHoATbz03aFD8bFSIK86f6bO5LoFT72njKZzpM8pCXuxpNwXdlz1NLF40kY+Lapiol1lSG+fOM4e74lnAYntDjmerns5p7pqmQ6ps46RNYQDBYDSwAWwkM3wM8ewI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GpPIk58N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpPIk58N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2741F000E9;
	Sun, 14 Jun 2026 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781455600;
	bh=X/gpy+XpeZBjh3BAyzgI0385dfD5KKI0h3vNqSewUuE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GpPIk58NJaASYRQhXdHWENyDchqMJWbkHxdAojoPuJhxJT4LEAeIfXAHktE8FeBHH
	 kJBQqMfMO6SL1a/BbB6bsWKzet/Zb8Ap0G0HkPG0JUo+Q1cug/jvB4h2XUwbXpQjYw
	 C6zBlfEYCaSBeSVB1unDT1SVH3VpiozgBk20jSPaCPASn8HK3kBDlxwAygG76e04Vg
	 YSLsCwhtr0rp/ixtFYYnaAcagrJcDuFSvA4KD73nucf33qZk9ZXRRtKSUFjp7FkpPj
	 MrwVmiA5Hx7ktPjri0+sZwDxGdsCOrOVdFhOHRrlkKmxzQUlxLBW5kqx/Mnm3DP8k8
	 6pkWZUn14xFsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/7] KVM: arm64: Set IL for emulated SError injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260614163336.3490925-6-tabba@google.com>
References: <20260614163336.3490925-6-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 14 Jun 2026 16:46:39 +0000
Message-Id: <20260614164640.2C2741F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch series attempts to fix SError syndrome IL bits, but the =
constructed ESR is silently dropped when injecting a nested SError because =
`kvm_inject_el2_exception()` ignores the `esr_el2` argument.
--

commit 3adb0abe8b63984396e6d2ad4fb963bab5512c79
Author: Fuad Tabba <tabba@google.com>
Subject: KVM: arm64: Set IL for emulated SError injection

This commit updates kvm_inject_serror_esr to include the IL bit when
constructing an SError syndrome. It fixes an architectural compliance issue
where IL must be 1 for SErrors unconditionally.

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 444d219b02174..d6c4fc16f8795 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -381,7 +381,7 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 =
esr)
>  	 */
>  	if (!serror_is_masked(vcpu)) {
>  		pend_serror_exception(vcpu);
> -		esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> +		esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;

[Severity: High]
This is a pre-existing issue, but while we are ensuring the SError syndrome
is correctly populated here, does the nested SError injection path drop the
syndrome entirely?

When injecting a nested SError, kvm_inject_nested_serror() passes the
constructed syndrome down to kvm_inject_el2_exception(). However, looking at
kvm_inject_el2_exception() in arch/arm64/kvm/emulate-nested.c:

arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception() {
        ...
        switch (except_type) {
        case except_type_sync:
                kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
                vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
                break;
        case except_type_serror:
                kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
                break;
        ...
}

Unlike the except_type_sync case, the except_type_serror case does not call
vcpu_write_sys_reg() to write esr_el2 into ESR_EL2.

Will this cause the guest hypervisor to observe a stale ESR_EL2 value when
it takes the SError, effectively rendering the syndrome fixes ineffective f=
or
nested guests?

>  		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
>  		return 1;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260614163336.3490=
925-1-tabba@google.com?part=3D5
