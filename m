Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578C636D51B;
	Tue, 14 Jul 2026 10:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024663; cv=none; b=WSkIlpsC+y11iJUMRwIAi7T9cnn17Mt5PA0df9QCUtRjnlktaFQPl0DgnRKAcCuXBcTBn6dn1r8jpHZLi6tueNOjxhvaGoGXgDuVMQ2dz5lK0Ks+eEGtQitR0uv5c8w7rj3i0xp8Ob7ae18lGokHQtxN6/gFC08gIpSxJVXVfJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024663; c=relaxed/simple;
	bh=4zRjDrVqf+zN+crKsH68dffewld0b1rT5Q7gMu6Q2Mg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WqtLxdl2x4qdqjMdCsSWOkn07AwZaurbrqjNH/xS0VVKZF8ZZxvDQY5k5KrUFXADNjHxUZlxIsDw8WXBWXrEiw2TeNdTXvF/adERgIVWB/9IbSRDOLdPTZFx01/kD7111IdLV2VfndE0TbPJG33YHMbb+DldbCoAbI7pxn6MyZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BF6iD9RI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BF6iD9RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51341F000E9;
	Tue, 14 Jul 2026 10:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024662;
	bh=kVTa6hHhrvDzfmFIiasGo8lhxKcyzJN/IkFUa5EyRbs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BF6iD9RIDY8qsr7oCnq5WrrKS8d1BEHiOopE9JMfgMWrjmL2lJQ5xErzdffVosmyE
	 Jj4ikf8H8rwaL73K2mnGx+1dgn0SiF5an8eAFF4i5UrIxnzBWcp72wgvx9hOQuTnaT
	 +BNlitP8+AC2Jkkc4VlS6aaqo8GOSTfjTdCvn+rQRqCk7BOIeEHneieDAVeXmWNxmU
	 D7LX/Pn0hr5BQobLhGqaIa0oDL8ODGJv/Aqrn5ctJJxXBGZHkwv4ZTSMpztTuY4IQ3
	 IlA8xbboFi67OsyFP1omUH2icXoA8u97sOqQyHdrWhZ4JwdU/5CgfgUkUcB+ayQy5u
	 MuMKBz0znMytg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/28] KVM: arm64: Add NVHCR_EL2 handling to the
 sysreg array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714091641.1970822-22-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-22-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:24:21 +0000
Message-Id: <20260714102421.E51341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Userspace writes to NVHCR_EL2 via KVM_SET_ONE_REG are silently d=
iscarded upon L1 guest entry.
--

--- Patch [21]: [PATCH v2 21/28] KVM: arm64: Add NVHCR_EL2 handling to the =
sysreg array ---
commit 40ce0e0627839603da739968567e9f3998f1ed15
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add NVHCR_EL2 handling to the sysreg array

Expose NVHCR_EL2 to userspace, and treat the direct access as UNDEF,
as that would only outline a bug in our exception routing.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9439c5b2b1fe8..0aeb2e736fde3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> @@ -3774,6 +3800,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>  			 sve_el2_visibility),
> =20
>  	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
> +	EL2_REG_FILTERED(NVHCR_EL2, undef_access, reset_val, 0,
> +			 nvhcr_el2_visibility),

[Severity: Medium]
Will userspace writes to NVHCR_EL2 be silently discarded upon L1 guest entr=
y?

Because NVHCR_EL2 is exposed without a custom .set_user handler, writes via
KVM_SET_ONE_REG will update vcpu->arch.ctxt.sys_regs[NVHCR_EL2] using the
default behavior. However, upon running the VCPU in hyp_ctxt (L1 hypervisor=
),
__compute_hcr() unconditionally executes:

  __vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));

This seems to clobber the userspace write, causing UAPI state loss and a KVM
ABI violation where KVM_SET_ONE_REG writes are expected to be preserved.

Does this require a custom .set_user handler to maintain alias synchronizat=
ion
between NVHCR_EL2 and HCR_EL2?

> =20
>  	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
>  	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D21
