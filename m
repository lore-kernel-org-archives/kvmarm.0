Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26974052B1;
	Tue, 15 Sep 2026 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789489137; cv=none; b=uO1H2sCeFZWUlzZDDnNdbnXR7DKLzWKCudiC/QMUr+EkHZd/6bHbXVUxTAlhr0yykLjwrfSwiOrgWxBfr9InbOfLg8elZ1MDfF4kNdPT2xmPgYU88vbiCO/Rrv7SP1SURchFvzPCtGaO7iWbLoV+eXBmbhCnqW31ASq5VC8Al8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789489137; c=relaxed/simple;
	bh=93qzettE2VOiPkQMfL8fTk0T5bEOhvx2ege9fRVQFPg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p37ZB3/haZ58IMkB5sWkAsGGw6U3nB7m7Kmd/oeWlwqRn+3QlXknbPTcZlSBNYyJHA1Qvg/mpxWK4wv+A/7f2PrqLhXH2rM4tmWogEVZFz5mdvDe5EpctTO6yZx/fz5po4N6TfESpNokk0mTRFxbhjKCfiMuuwbIGpjEjnnOq6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlEVze9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlEVze9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AEF1F000FF;
	Tue, 15 Sep 2026 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789489135;
	bh=M/VLoSH8ApHKebIib2xn7O9XHPMcOrwtqkCYvwi0UKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mlEVze9X29r7bHlus9SKGyjScZzdI5It9i6H2Q9WTnZkd0okoEqNCG3uFOMBqwJXK
	 pPheJW0nfdCPxvLc5v72/7U1goQFHGrCOdW+Rpptgu1DnPaJ5V9SUWFE/mrWnA/9wb
	 yUHzanckEI/FoZqxHQNVX2WrN7fhDnFbR7rcUAu/Q+7arJ5gqBOGlQWhKfwMey6siw
	 nw1g1rxqWeretDSEFMybIWgbhP4jWe1kg53uSHjAnYQh3amapx48gAkW+uCF5hb+Eo
	 xnXgj1lBPvoh0eOZzAW+h/9YVMz5rexvYJ6Z4c6uH/VO2J6BmPRL0O1K0XCuvXwgA3
	 Kc95iNkhG7H5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 01/23] KVM: arm64: protected VM: Handle set_one_reg
 CNTVCT_EL0/CNTPCT_EL0
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260915160141.3543048-2-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-2-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 16:18:54 +0000
Message-Id: <20260915161855.32AEF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: pKVM: protected VM timer offset vulnerable to host TOC=
TOU
--

commit 960552f9d7645214acac73b01e88ba381530e333
Author: Suzuki K Poulose <suzuki.poulose@arm.com>
Date:   Tue Sep 15 16:01:19 2026 +0000

    KVM: arm64: protected VM: Handle set_one_reg CNTVCT_EL0/CNTPCT_EL0
   =20
This commit fixes a WARN() in timer_set_offset() caused by userspace writing
to CNTVCT/CNTPCT registers for protected VMs. It accomplishes this by setti=
ng
the timer offsets to 0 and marking the offset initialized at pKVM init time,
removing the need for the vm_offset pointer to be NULL.

Link: https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.o=
rg

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 459bd9eb7e4bc..e7b38eff63bd1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -528,19 +528,19 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu =
*hyp_vcpu,
>  	hyp_vcpu->vcpu.arch.cflags =3D READ_ONCE(host_vcpu->arch.cflags);
>  	hyp_vcpu->vcpu.arch.mp_state.mp_state =3D KVM_MP_STATE_STOPPED;
> =20
> -	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> -		/*
> -		 * Timer offsets are pointing to the untrusted KVM copy,
> -		 * which is pinned in __pkvm_init_vm() for the VM life time.
> -		 * It is worth noting that hyp_vm->host_kvm points to an EL2
> -		 * linear map address and timer_get_offset() will use
> -		 * kern_hyp_va() which is safe as it is idempotent.
> -		 */
> -		vcpu_vtimer(&hyp_vcpu->vcpu)->offset.vm_offset =3D
> -			&hyp_vm->host_kvm->arch.timer_data.voffset;
> -		vcpu_ptimer(&hyp_vcpu->vcpu)->offset.vm_offset =3D
> -			&hyp_vm->host_kvm->arch.timer_data.poffset;
> -	}
> +	/*
> +	 * Timer offsets are pointing to the untrusted KVM copy,
> +	 * which is pinned in __pkvm_init_vm() for the VM life time.
> +	 * It is worth noting that hyp_vm->host_kvm points to an EL2
> +	 * linear map address and timer_get_offset() will use
> +	 * kern_hyp_va() which is safe as it is idempotent.
> +	 * Also for protected VMs the offset is fixed to 0 and is prevented
> +	 * from changing.
> +	 */
> +	vcpu_vtimer(&hyp_vcpu->vcpu)->offset.vm_offset =3D
> +		&hyp_vm->host_kvm->arch.timer_data.voffset;
> +	vcpu_ptimer(&hyp_vcpu->vcpu)->offset.vm_offset =3D
> +		&hyp_vm->host_kvm->arch.timer_data.poffset;

[Severity: High]
Does this change introduce a TOCTOU regression for protected VMs? By removi=
ng
the !pkvm_hyp_vcpu_is_protected() check in init_pkvm_hyp_vcpu(), the protec=
ted
VM's vm_offset is now unconditionally assigned to point to the untrusted ho=
st
memory back-pointer (hyp_vm->host_kvm).

Under the pKVM threat model, the host kernel is untrusted. If the host
modifies the voffset or poffset in its timer_data at runtime, EL2 will read
this manipulated value. This could allow a compromised host kernel to alter
the virtual and physical timer offsets observed by a protected VM, violating
guest integrity.

Should the offset instead be derived from the EL2-private &hyp_vm->kvm
structure or statically set to 0 for protected VMs?

[ ... ]
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index bc6f2fdd7ad33..4f0aa3bb69f45 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -176,8 +176,7 @@ static inline bool has_cntpoff(void)
>  		if (__ctxt) {						\
>  			struct arch_timer_offset *ato =3D &__ctxt->offset;\
>  									\
> -			if (ato->vm_offset)				\
> -				off +=3D *KERN_HYP_VA(ato->vm_offset);	\
> +			off +=3D *KERN_HYP_VA(ato->vm_offset);		\
>  			if (ato->vcpu_offset)				\
>  				off +=3D *KERN_HYP_VA(ato->vcpu_offset);	\
>  		}							\

[Severity: High]
Since the pointer is now unconditionally assigned to host memory for protec=
ted
VMs, EL2 will dereference this host-controlled pointer here in
timer_get_offset() via KERN_HYP_VA(). Can this cause the hypervisor to read=
 a
security-sensitive value from untrusted host memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915160141.3543=
048-1-suzuki.poulose@arm.com?part=3D1
