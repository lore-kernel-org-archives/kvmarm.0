Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9AA4315F
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 22:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637220; cv=none; b=L18yObUd7rEZmv6SbJesbqmbo/GBSTLDB1ZcEZuUjc74qmXgXRlA7a0irHYw+CtxH9WuXqeoSNkxnILnL0VQ40+wWJCJfqw9Mf5mbJLnAarwZMDlVzp/WUnfgn0lA4KjjnjeFicgqTFUyf+USBGVEGoEZW/cU705rvxjqzNfwOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637220; c=relaxed/simple;
	bh=Dx+bvElB0HBKCjB1SwDsvrXdi76ReqAIT+bAyHpflCo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EE3Uh1TcluMqT0F0932vngDHvWdAUF90drrVu2ocKCVNeBx8Rao0y75adM58JQlqtqOhzXj7Rl5rizgCxHqOAh1jFrFftbq7vqW80dxgIti0Dz0MLYHY4f8ECm8I6kGWlvH6n4ztDxoeZNPC5/Vb2e4zZN/i/Aj+qQ5X3jBEYFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zcr1WEKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zcr1WEKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCA61F00A3D;
	Thu,  9 Jul 2026 22:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783637218;
	bh=Dx+bvElB0HBKCjB1SwDsvrXdi76ReqAIT+bAyHpflCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zcr1WEKz4zS4SFEg1aK8+lw0I59XHNUucJMczzbxA9N4G4FgNxh+gan9MFWWYaCma
	 BoyNEmXINZdigL004v9fQ6WprZytKphtSYT8q5gLg0+Oe1dkhhKxIlpJI7M3u5it90
	 FlGDVRU240x01WgCM0q0ALhP0H97jPKlFGELo23gOUM1OcLKm1XYX5DJ8+iBqy1Imh
	 M5wFtZazSqyczt/RDn3uy/vSq4xwHochkdwbO0FW7BRCBss8869MekAQavO7rV4HNq
	 mRliltN+yO2PX3mYAZ2R3TcT97cs8zTFNZV4DadjZNNOj435eNUvzELoxIUK+r/1tN
	 gEQ2xCXd4iewQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v3 4/6] KVM: arm64: Initialize HCR_EL2.E2H early
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260709223604.12934-5-coltonlewis@google.com>
References: <20260709223604.12934-1-coltonlewis@google.com>
 <20260709223604.12934-5-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 22:46:58 +0000
Message-Id: <20260709224658.8FCA61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting sysreg write paths in `___kvm_hyp_init` and `init_el2_=
state` macros omit the architecturally required `isb` immediately after wri=
ting control-plane system registers.
--

--- Patch [4]: [PATCH 6.6 v3 4/6] KVM: arm64: Initialize HCR_EL2.E2H early =
---
(Note: The format of this report is altered to provide a free-form summary =
instead of quoting the patch code directly, due to recitation restrictions.)

commit 726047e1aa205da54b261630927b54303540481f
Author: Mark Rutland <mark.rutland@arm.com>

KVM: arm64: Initialize HCR_EL2.E2H early

This commit initializes HCR_EL2.E2H early in KVM PSCI entry points to avoid
consuming an uninitialized value on CPUs without FEAT_E2H0. It factors out
existing head.S logic into a new init_el2_hcr macro.

Link: https://lore.kernel.org/r/20250227180526.1204723-2-mark.rutland@arm.c=
om

[Severity: High]
This isn't a bug introduced by this patch, but there appears to be a
pre-existing issue with missing context synchronization events in the EL2
initialization paths.

In arch/arm64/kvm/hyp/nvhe/hyp-init.S:___kvm_hyp_init, writes to mair_el2,
hcr_el2, and vttbr_el2 are followed by memory loads or other operations
without an immediate isb instruction.

Similarly, in arch/arm64/include/asm/el2_setup.h:__init_el2_hcrx, the write
to SYS_HCRX_EL2 is followed by a branch rather than an isb. Also, in
__init_el2_timers within the same file, cnthctl_el2 and cntvoff_el2 are
written consecutively without an isb between or immediately after them.

Could this cause the CPU to execute subsequent instructions under a stale
architectural configuration, potentially leading to unpredictable behavior
or unexpected traps during hypervisor setup?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709223604.1293=
4-1-coltonlewis@google.com?part=3D4
