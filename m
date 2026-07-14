Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835CD1F3BA4;
	Tue, 14 Jul 2026 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024161; cv=none; b=AzX1ScwWMJmyoPxrQuVB021TPqT8erxbbUMqiaJg9c/gme9WU3SiibZTJc1X4YhoE93XlQE0uzF/3DaFSa2H6NWD+8/VwnLXkIIbQzcAwB0Y5xze9yY8mNLevHtMeAFGHtIbQW7bXBYBXTdJIW9y1X9EkZYMFMyuNazq4TKkd7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024161; c=relaxed/simple;
	bh=JnCno2jxTXkQUe36GoS6ojc79zXls/o7MWA1gsEGIdg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bsTQxAAO6HVs+ViZJyPWgM2GY280KlDslShmnYGjL8HYTVeYpOuPqU51R/CYROHq+/eFDM1DK7WAFvG9NN4lC9x0C6zXIgWNSzVzkaGXwrVeJUSp7Xo8d+2bnSi63yb9ORD9CLO06cvjvKhGq5nShB4ZXBIMEtaj45Ak9eje58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZRYSMrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZRYSMrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60F61F000E9;
	Tue, 14 Jul 2026 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024160;
	bh=Wy0KY8YHux+fWBHAz5oVfuomfaYqKA+n+KXUr57piIQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QZRYSMrNMsH4sv45VWSWoSDsEI3bqsxlD8isnqyv0wJWV3OA1nHVEuHOn27PkX5+2
	 R10iwGIzvY3YVF/asxhTQXdm606ccWemkUahR5SEpxt8wHCZJfwly6TKai2SjsRtDK
	 hxoYm9P8l+t94pQWVzKbGUQ2Hq3YurAzvxHqGV9ZiOx2st3ZDl+1kV1WXKEeVf/660
	 dqVAnITk0EgXZhJG5LqTCEQ0AnP533zT11ist3p/QXgAvs/gtkn285Q5uqUPWERLf9
	 zbCIbNXwMqSt2PLxbZ7Hug+/ICSiYwdoK8UBHuA5dQwn1IJqJdWNIuS7kMcJVIhGf5
	 1HoI/zjw3nY6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260714091641.1970822-28-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-28-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:15:59 +0000
Message-Id: <20260714101559.C60F61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Host nested virtualization capabilities (ID_AA64MMFR4_EL1.NV_frac)=
 are leaked to non-NV guests, breaking live migration across heterogeneous =
hosts.
--

--- Patch [27]: [PATCH v2 27/28] KVM: arm64: Expose FEAT_NV3 to guests ---
commit 508d53194bf7ddb4e61f279e50216aa88dd973ad
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Expose FEAT_NV3 to guests
   =20
Further enable FEAT_NV3 by making it visible to NV guests.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index f646894fec9a9..70d605e60cfb3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -1741,7 +1741,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 v=
al)
>  			val =3D 0;
>  		} else {
>  			val &=3D ID_AA64MMFR4_EL1_NV_frac;
> -			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			if (cpus_have_final_cap(ARM64_HAS_NV3))
> +				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
> +			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
>  				val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P=
1);
>  			else
>  				val =3D SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);

[Severity: High]
This isn't a bug introduced by this patch, but while looking at NV feature
exposure here, could ID_AA64MMFR4_EL1.NV_frac leak into non-NV guests?

Looking at __kvm_read_sanitised_id_reg() in arch/arm64/kvm/sys_regs.c,
it seems SYS_ID_AA64MMFR4_EL1 is not explicitly masked out for non-NV guests
in the switch statement:

	case SYS_ID_MMFR4_EL1:
		val &=3D ~ID_MMFR4_EL1_CCIDX;
		break;
	}

If a non-NV guest is created on an NV3-capable host, will the host's raw
NV_frac leak into the VM's ID_AA64MMFR4_EL1 register?

If this VM is later migrated to a host with only NV2P1, could userspace's
attempt to restore the capability via KVM_SET_ONE_REG fail because the
destination host's arm64_check_features() rejects the higher NV_frac value?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D27
