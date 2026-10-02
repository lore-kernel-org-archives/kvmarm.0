Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238EA472545;
	Fri,  2 Oct 2026 09:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932431; cv=none; b=VTUbo627yX0mMI1dDr+wRUDhgKZOyRyfYEMPaRXon/Xvn69H2XEES0mQtRrDebXStoc+WYNWNSzoBeOBM4TIwD27YKFecxGyWnbsKr5V+R1IWP7I4QDYeHLJMcX/v5X6JKplIi4WITfUNRfhrrSUDefUA/4jVAGw3gPdyQyoWqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932431; c=relaxed/simple;
	bh=ecbCso4L5heKFyHycOrXxSFn2uM/T4PRoMZC8wqsobo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dsjqHVn6KAO9MBtCnJqPGvw9Cdi6yFgo7e7untpNtf5Qs9UqDM4COxdEilgGpUyNXechYLUNS4dlY98O6MscSh2G50xslCF1Hb87uyCCthoZwS4d58W7CA+Z6alaGJUX22Rlo9VH9z0flo7RX5YGCOtn3zVBauJJX+OPRCX7zL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5/NQ9+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5/NQ9+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90461F0089A;
	Fri,  2 Oct 2026 09:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932430;
	bh=4WoBk4y7g4w2Xw2iUNNdQfGRrptu6fnoO4H9WOKx3QQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5/NQ9+IiLXXuDVb0cPPPWcq5chwKyDyCPHSIYE9vlBnysUHl5+O+lYriuIfWZQQY
	 Xl8ml2zRSEfgHVOyQYSFHvex/CrCwexxlw6yIpaTsNh3DEYLdWHhBAdEZhQYRx2h4v
	 gB8zXnItULJKKS41+FGct38Ccglh5Cxhgacv/Z+dJPNFF5/D6U2Fts5djG0L5uJ/n3
	 U+ddRLSDGVw23yWB7z7QxNxhH6f0yz2jR7ZB9IonIFK73cmckZtGk0IhJmMjHUu47J
	 NX8/f6kzanp5bSjUtYdeO+3oZ2/BsK6mGQKBcUXss5zTS0jIAiWJrowiFqUq34O7Jk
	 0XtJwcZfmLqbA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 22/23] KVM: arm64: CCA: Expose SVE VL register
 before VCPU finalization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001210703.1597150-23-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-23-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:49 +0000
Message-Id: <20261002091349.B90461F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: commit message inaccurately describes KVM_GET_REG_LI=
ST failure behavior
--

commit a8d5a1d267ddf1f3bfd568fee43772989e294b1c
Author: Jean-Philippe Brucker <jpb@kernel.org>

KVM: arm64: CCA: Expose SVE VL register before VCPU finalization

Userspace must configure the SVE vector length before the Realm is created
(as it is part of the parameter for Realm creation), but the Realm VCPUs
cannot be finalized until after the Realm Descriptor has been created.
[ ... ]
Allow KVM_GET_REG_LIST for unfinalized RECs and make the SVE register
enumeration handle the unfinalized case explicitly. i.e., only expose
KVM_REG_ARM64_SVE_VLS before SVE is finalized.

> One adverse side effect of this change is that a KVM_GET_REG_LIST call th=
at
> only probes for the array size will now succeed even if SVE is not
> finalized, but that seems harmless since the following KVM_GET_REG_LIST
> with the full array will fail.

[Severity: Medium]
Is this description accurate for the current implementation?

The stated failure behavior does not seem to occur for either VM type.

For normal VMs, kvm_arm_vcpu_reg_list_allowed() returns false if SVE is
unfinalized, meaning KVM_GET_REG_LIST fails immediately with -EPERM for both
size probes and full array requests.

For REC VMs, kvm_arm_vcpu_reg_list_allowed() returns true. The array size
probe succeeds, and the full array query also succeeds because
copy_sve_reg_indices() explicitly handles the unfinalized case by safely
copying KVM_REG_ARM64_SVE_VLS and returning 1.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d43ae985ab1b4..2e153b4fc8f62 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -2004,6 +2004,19 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu=
 *vcpu,
>  	return __kvm_arm_vcpu_set_events(vcpu, events);
>  }
> =20
> +/*
> + * Realm VCPUs can be finalized only after the Realm descriptor is creat=
ed.
> + * But in order to seal the SVE VL, we need to allow the userspace to re=
ad/write
> + * to the SVE_VL, before everything is finalized.
> + * Allow the register list for RECs before the VCPUs are finalized.
> + */
> +static bool kvm_arm_vcpu_reg_list_allowed(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_arm_vcpu_is_finalized(vcpu))
> +		return true;
> +	return vcpu_is_rec(vcpu);
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> @@ -2059,7 +2072,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			break;
> =20
>  		r =3D -EPERM;
> -		if (!kvm_arm_vcpu_is_finalized(vcpu))
> +		if (!kvm_arm_vcpu_reg_list_allowed(vcpu))
>  			break;

[Severity: Medium]
Doesn't this check block all KVM_GET_REG_LIST operations on unfinalized nor=
mal
VMs? This seems to prevent the array size probe from succeeding as claimed
in the commit message.

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index b01d6622b8720..c3ca369882273 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
[ ... ]
> @@ -628,6 +625,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu=
 *vcpu,
>  		return -EFAULT;
>  	++num_regs;
> =20
> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +		return num_regs;

[Severity: Medium]
For REC VMs, doesn't this explicitly handle the unfinalized case, allowing =
the
full KVM_GET_REG_LIST ioctl to successfully complete and return a count of 1
instead of failing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001210703.1597=
150-1-suzuki.poulose@arm.com?part=3D22
