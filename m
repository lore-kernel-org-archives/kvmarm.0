Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B36202963
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551835; cv=none; b=uODdp0Lx6aRF5z2rRrBatAk0slgqW3uOYg/PRwMIel74ESBESVqS4pNJSOO4sl8cPJAVDxKbmph2NsrdiKH7RQecsvZ+14HOG3Z1dX7olzFHCePJ4w7R2gKseZIpSLCgKuQLph7KxFQvvoT4kIqkLcb7g5V77HG8+yxSTBvJ5r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551835; c=relaxed/simple;
	bh=X2iYZeOYioiPz8rsrIy4uVsCs/vU6VnW9Er6nfqF0r4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T/O2LWTa+y5FDVeCu+mf/GQ42kUtib32/n8if7d+PfF8WcUd73MLO80SEWrE1OK1lejVWHmDLjfQJRAfWrqG6Mp67UcV0/Q7a4bTtm1Y+BRsAN3gRbt9wn/BijALvRcOwo9bO/wSJZFEqqjBvnDYHdhtRBbkDs7StoU8kl2/WHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6qlzGYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6qlzGYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332C21F000E9;
	Wed,  8 Jul 2026 23:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783551834;
	bh=X2iYZeOYioiPz8rsrIy4uVsCs/vU6VnW9Er6nfqF0r4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d6qlzGYoDAFWrw2vROrNZF9/7YtSkcJ4fnoWZKm3f5+RSw9a6FgoAS4Eb+BAag1DD
	 tfjfCgRZic3CjoPgZyytpKzAb5poCU3wxyviDwC4v7HnyLBbnuoyuIPdbrO9O8xx8q
	 vTIhaiDjkwAbeQewPFq7BL4KkOoMgK1ia56lycDoEgbYW6Np53OAAjKJwmGj6JnkH4
	 b8mPQdYvH6dvUArtr1rO1dmK6pILj/uPPAZM909nO6wvLMTwZSjIJZx7KduEQ9JUae
	 CVx4eaf0yYPFIm6C37BMVnkmkWpFD3qE/TyrBys48JsPVjVCK2DbiO2FU7yEpQUjUH
	 pXXPBlnK6eaeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v2 4/6] KVM: arm64: Initialize HCR_EL2.E2H early
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260708225124.4130846-5-coltonlewis@google.com>
References: <20260708225124.4130846-1-coltonlewis@google.com>
 <20260708225124.4130846-5-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 23:03:53 +0000
Message-Id: <20260708230354.332C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writes to control-plane system registers are not immediately follo=
wed by an isb().
- [High] Missing `dsb` after `tlbi alle2` in `__pkvm_init_switch_pgd`.
--

--- Patch [4]: [PATCH 6.6 v2 4/6] KVM: arm64: Initialize HCR_EL2.E2H early =
---
(Note: The standard inline diff formatting has been replaced with a free-fo=
rm summary in this report due to code recitation restrictions.)

commit 016cd26b0c3a9694155a974c024598368716d8e4
Author: Mark Rutland <mark.rutland@arm.com>
KVM: arm64: Initialize HCR_EL2.E2H early

This patch addresses an issue where HCR_EL2.E2H might read as an UNKNOWN
value out of reset on CPUs without FEAT_E2H0 if it is not explicitly
initialized. It introduces a new 'init_el2_hcr' macro to initialize this
early in the KVM PSCI entry points so it can be reliably consumed.

Link: https://lore.kernel.org/r/20250227180526.1204723-2-mark.rutland@arm.c=
om

[Severity: High]
This is a pre-existing issue, but in arch/arm64/kvm/hyp/nvhe/hyp-init.S and
arch/arm64/include/asm/el2_setup.h, several writes to control-plane system
registers are not immediately followed by an isb(). For example, in
___kvm_hyp_init(), writes to mair_el2 and hcr_el2 are followed by ldr and
mov instructions rather than an isb(). Similarly, in __init_el2_fgt(),
SYS_HFGRTR_EL2 and SYS_HFGWTR_EL2 are written consecutively without an
intervening isb(), and in finalise_el2_state(), writing cpacr_el1 is
followed directly by a branch.=20

Since the subsystem guidelines mandate that every write to a control-plane
system register must be followed by an isb() as the very next instruction,
could this leave the CPU pipeline in an architecturally undefined state for
the intervening instructions and cause unpredictable behavior or spurious
traps during boot?

[Severity: High]
This is also a pre-existing issue, but in
arch/arm64/kvm/hyp/nvhe/hyp-init.S, __pkvm_init_switch_pgd() issues a
"tlbi alle2" instruction and subsequently installs new page tables and
re-enables the MMU without executing a dsb in between.

Because the architecture requires a dsb to guarantee the completion of a
TLB maintenance instruction, might the TLB invalidation still be pending
when the MMU is turned back on? Could this window cause the PE to fetch
instructions or data using stale TLB entries, or raise a TLB conflict
abort?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708225124.4130=
846-1-coltonlewis@google.com?part=3D4
