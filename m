Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F34378814
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027418; cv=none; b=NPRw7KFzrep6PuFXfzeW0uWKw2AMYr18DUBMzh65BDMTLzEX1pu4n81Di1FQ8w7qp8p14Ee4SPbfuU1Xtcurv6IxM5O9CjpVGzOaOQd6SZE+1V3zuNcDJN1SYFjt7aE+omRpM9z6MQl0r5TmIcFAgTeOBfHFSKijZJ2TBSjOR1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027418; c=relaxed/simple;
	bh=GLKWJ/MOhDGIZGEIOVPUCquLIqlipl5Csc85Hc4Wr+M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GTs/VIwunC6h+2YN2NQrd16qOJqHffKPFBRZBq1w/BJIN62Fus6FSGy1o9oayC5W4YBu2AxAmdgZqIeK2p19caW3UaIqbVpL1srJdhLkzsHkExsq1eN2OIu34Kg16a8m7GAGxHl4y9T25hCrIModfNzN0Xdvjs4SExWhVpPhlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvWwh7RS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvWwh7RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23701F000E9;
	Tue, 14 Jul 2026 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784027417;
	bh=GLKWJ/MOhDGIZGEIOVPUCquLIqlipl5Csc85Hc4Wr+M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bvWwh7RSw0ibjk7k2fEMKCeAhkhvgq8b76/MQJbYg4DU/vQCe0VEIKBBx3lVOPorQ
	 koEvfBHIiYv1QEcbratrKR5sG2hytKiTdh9+jSNweqtxj7S+sGfCZozoaKVM4ZIVWS
	 l+WQRbjH63Aaj7p5WZU5ycLje5kPDua6mcfm2Rj5cj/zjI5cHj8FDSQCDUaZ9s7XNp
	 E7k+I0/im9qK8c6uB/LIUWda4Y9E9+Mn8potLidW1hg3XPHiYNAoWf1Z8PHhNYEGUi
	 91pE/1gf9Fx69GLIGAyPkyIw+kYEsxZENoR+sk8UdT/QokdEN7PTQQ7GmOsiQBgiOh
	 JkzJDfiyy11nQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/8] KVM: arm64: Move PSCI helper functions to a
 shared header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714101601.4142645-5-fuad.tabba@linux.dev>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 11:10:16 +0000
Message-Id: <20260714111016.E23701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The header `include/kvm/arm_psci.h` uses architecture-specific func=
tions (`vcpu_get_reg`, `vcpu_set_reg`) without including the necessary head=
er `<asm/kvm_emulate.h>`, breaking header self-containment.
--

--- Patch [4]: [PATCH v5 4/8] KVM: arm64: Move PSCI helper functions to a s=
hared header ---
Note: The format of this report has been altered due to recitation restrict=
ions. The original patch code is not quoted directly.

commit 0c74ab23a0a20b7f1a788c6ac3e03217bd5099cd
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Move PSCI helper functions to a shared header

This commit moves several PSCI helper functions out of arch/arm64/kvm/psci.c
and into the shared include/kvm/arm_psci.h header. This allows the functions
to be reused, specifically for a follow-up series that handles protected-gu=
est
PSCI calls at EL2.

[Severity: Low]
Does include/kvm/arm_psci.h need to explicitly include <asm/kvm_emulate.h>?

Looking at the moved inline function kvm_psci_narrow_to_32bit(), it relies
on vcpu_get_reg() and vcpu_set_reg(). These functions are provided by
<asm/kvm_emulate.h>, but that header does not appear to be included in=20
include/kvm/arm_psci.h.

Will this cause build failures if a new compilation unit (such as the EL2=20
pKVM follow-up series mentioned in the commit message) includes=20
<kvm/arm_psci.h> directly without having already included <asm/kvm_emulate.=
h>?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.4142=
645-1-fuad.tabba@linux.dev?part=3D4
