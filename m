Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3862F7EF4
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782460755; cv=none; b=uNZ4vux4szHFXHHlki9C8VbZr6Lx0uDhtiZKNMmz0St5IHTC1fZFliuoppOOVEwLp/R8oyFEZfm5xwdl3WXn/fM9XI03H83Rdip8fuZuiZFRqYrslNwSdOKZaXsiyxa1vqIxrUD5XZ226Jn3mqbFYzIM2MhVEK+Iqd8XgnAt/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782460755; c=relaxed/simple;
	bh=RO4F75OBYkTZKHxVy9e+z4rWHRQCPPBTXNu7vmltzQQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KF5Elj77p0LhN6C8/cBpLBon/QfhIPGgqGTFZ53O6LjPE+EdmFihizw5ndYVS29f7VauoGTI7uqIvyfNLRZAtekOYFFWBfKLAWmbPWbJiSZS3z/G02+cDAeMxQW9XUhUkmrd4ZgSdlrM/Xx0d7OSKmWqj6cWMVeWyvnVtZrmxTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTPSyPN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTPSyPN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970411F000E9;
	Fri, 26 Jun 2026 07:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782460754;
	bh=7FKGKqhF4xyujuZZv2LM/V+aML50aX7zruCV3S8fuLs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PTPSyPN22zt1s1d/Bf3fvWyDpW9zbHdWRYVyv6MGZfPNMaIACVqVHsFAyuf7lN/0n
	 EKcatY4nBzl+BhBnMrLhEStgQ5q2vYyXyyd/hqGwpYy/LZwg+G20iZ0d8CK/HhdZiu
	 hnSTW6cCHXKTbi6sO/FH5dxMaxZcgdK4HysbjMq412mQVibaxQAtE0pnb3ZIxhmf6S
	 VBVUa9m8Jb8k8R17w+jefSk1XJqr4SQqQCgF3iuyhK8GOz0p4KIodBLCASFneNNIWl
	 yye+Wu9ZgSsjjbIPfUFXi/1VFFXWcxGc7cW0STtCTV7qkfm2168/mqQ2RJDtF5KzTY
	 PybnT3h7KwgeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260626074545.433234-6-sebastianene@google.com>
References: <20260626074545.433234-1-sebastianene@google.com>
 <20260626074545.433234-6-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:59:14 +0000
Message-Id: <20260626075914.970411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] `do_ffa_notif_set` fails to validate the upper 16 bits of the fl=
ags parameter, violating the MBZ requirement before proxying the call to Tr=
ustZone.
--

commit dc6778bf3607c00222a50fb85f58ca74257482ea
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_GET in host handler

Allow FF-A notification GET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments sent from the host
driver.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 2bb16aa414f9f..c22fe45147414 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -938,6 +937,27 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_re=
gs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }

[Severity: Medium]
This is a pre-existing issue, but looking at do_ffa_notif_set() just above
this diff, it uses GENMASK(15, 2) to validate the flags parameter:

arch/arm64/kvm/hyp/nvhe/ffa.c:do_ffa_notif_set() {
    ...
	if (flags & GENMASK(15, 2)) {
		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
		return;
	}
    ...
}

Does this fail to validate the upper 16 bits of the flags parameter?

The FF-A 1.1 specification defines bits [31:2] of the flags parameter (W2)
in FFA_NOTIFICATION_SET as Reserved (Must Be Zero).

By using GENMASK(15, 2), the validation logic only checks if bits 2 through=
 15
are zero, ignoring bits 16 through 31. This allows unvalidated, non-zero
reserved bits to bypass the strict MBZ checks and be forwarded to EL3.

> =20
> +static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
> +			     struct kvm_cpu_context *ctxt)
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626074545.4332=
34-1-sebastianene@google.com?part=3D5
