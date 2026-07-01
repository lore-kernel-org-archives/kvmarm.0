Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC438224AF2
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939201; cv=none; b=mq0uKdEtI5CKlU8vBQ40qYDgH+T/NZJkDtHhBsh45XFUl4Z9wyIexKLzTjZJH7uQ+JFUnBI3+hVXebHbwC+eTd9wH2SO4ssbq9F3q6j/cmq/gbt4ASB85FYR8EA3T3PM1l5c4+7rVSSpVDpi4rX2SdqRv3K7uJezqutTU2bQVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939201; c=relaxed/simple;
	bh=7LObhdYdLfhCMpbOg81Xxi5YmNzNb2ISWmHD45v9dMU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gTnCCduaMkC3cNQws4L/rHzuJJ9Rt2VDWuMjJYeHt//4h95FUjG0zi9UZHMxCfZ66zuIjzvuDGCt6IdBk3xdtpSeTKyBI3OFd3etgIYMmRKs9GD9QMv7v6+jOmjtaFkujb7qTHut5sqggGAJYQsCUt9+t5YvBhv3D2+uczT6c7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAm44HA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAm44HA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5AA1F000E9;
	Wed,  1 Jul 2026 20:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782939200;
	bh=FZsItrD9V21bU+98y2A3bU8vyqThW3wSqDCW8I0GhQg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dAm44HA14PYPMFCq61jCKS+Hhjb6kCNBwyq5tHHW1yUWMLJFTYMUcUKX+5HSafZC/
	 n1OgPeRbyJQH+w8vLApo5GLJ3aevtu25oAUdhdKmHQ9F6MdwNVYpJDH0MdiqU9H2AG
	 qfGfi1bRQbRHq0sxpSuFjeuPRHqNVMZxBwHUcYDjUQLz1HAaqZdITF4NKn8j+nepKi
	 gZfJMPWLr9bU+udIyM57pSyqF5LRkf77eoPliBzqdNTm+q/+axbAlu2oKDdp47lAYt
	 T9xF7AOvd11LKarwC652nh8VOniIS1LqqK600VvcPvkAMIu07vXhX+nExS3t9RiaXD
	 0VCQdX2S6G6bQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] KVM: arm64: Initialize HCR_EL2.E2H early
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260701204342.2654385-5-coltonlewis@google.com>
References: <20260701204342.2654385-1-coltonlewis@google.com>
 <20260701204342.2654385-5-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 20:53:19 +0000
Message-Id: <20260701205320.3C5AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (ISB) after control-plane sy=
stem register writes.
--

commit 95b6ac525bcb40ce6a82afcc5f285d6134c949cb
Author: Mark Rutland <mark.rutland@arm.com>

KVM: arm64: Initialize HCR_EL2.E2H early

This patch ensures HCR_EL2.E2H is initialized early during PSCI entry points
to avoid consuming an UNKNOWN state on CPUs without FEAT_E2H0. It factors o=
ut
the existing HCR_EL2 initialization from head.S into a new init_el2_hcr mac=
ro
and extracts EL2 state initialization into a new __kvm_init_el2_state
function.

Link: https://lore.kernel.org/r/20250227180526.1204723-2-mark.rutland@arm.c=
om

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe=
/hyp-init.S
> index 1cc06e6797bda..a08363b9b10fd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S

[ ... ]

> @@ -75,6 +75,16 @@ __do_hyp_init:
>  	eret
>  SYM_CODE_END(__kvm_hyp_init)
> =20
> +/*
> + * Initialize EL2 CPU state to sane values.
> + *
> + * HCR_EL2.E2H must have been initialized already.
> + */
> +SYM_CODE_START_LOCAL(__kvm_init_el2_state)
> +	init_el2_state				// Clobbers x0..x2
> +	finalise_el2_state
> +	ret

[Severity: High]
This isn't a bug introduced by this patch, but does factoring this out into=
 a
function expose us to missing context synchronization events (ISBs)?

Looking at the macros called here, several system register writes are not
immediately followed by an isb instruction. For example, in
arch/arm64/include/asm/el2_setup.h:

__init_el2_fgt() batches msr_s instructions to FGT registers and
interleaves macro-expanded mov_q instructions without immediate isb
synchronization.

finalise_el2_state() interleaves a branch instruction (b) between the
cpacr_el1 write and the isb instruction.

Since this patch extracts the sequence into a new function ending with a
ret, the branch will execute before the pipeline state from these macro
writes is fully synchronized. Could this cause the CPU to operate under a
stale configuration during the return?

> +SYM_CODE_END(__kvm_init_el2_state)

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701204342.2654=
385-1-coltonlewis@google.com?part=3D4
