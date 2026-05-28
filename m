Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348EF2FE591
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779974520; cv=none; b=CUFnCcgOggpAHEEK0zxm8Ns4aLZ34SIJ26A8UyUbvEYvA6BuzTVRCGYiCGIYkgDsc4OL+kqN2x14wJOfPLfuJaNN+4kKqcZ4xuBq12qais59buQsKzlmWJjQJ78daXlYZAJwvuLqt6UazrcTR/bw4phF89g4cGDY9m4gG0zASkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779974520; c=relaxed/simple;
	bh=xeNTUjxCAp37gut1KA/qb/JTq4+uyS8+/YlvClklkhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aDIZQeY3T6pEtfusggjvQ/WvjEdLSC6EoecGyIqIFuQMtgKb7BCDgxUYceYaG7jsdHs6jffK+JUYDhtV0hkYv1jF6eJhmtElq0eGUq6cy7XbdBgEe91bw8v5PmUHskm9sfE4Gi69DO9DxzIMakOB9fE7F0hSSkRoWH8GmED43xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tp5WdJrW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tp5WdJrW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D1074402;
	Thu, 28 May 2026 06:21:52 -0700 (PDT)
Received: from [10.1.28.164] (unknown [10.1.28.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3334E3F632;
	Thu, 28 May 2026 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779974517; bh=xeNTUjxCAp37gut1KA/qb/JTq4+uyS8+/YlvClklkhk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tp5WdJrWMzxPnuLH/8BmIm8mZfCzIhvMfaEyjZNMQHpWUZN0VFY2cpAcGyCLaseqX
	 JQZ6Sv+LGShXrg8MzVwHG71av1nMP1oeoUWaTJelqVoFQsu7tCjDVBX2QGl5lpfw4h
	 W3jynD8NJ1gUlC8+vi997pt0VpEAulwJrtfl4dm8=
Message-ID: <9f95f8df-8c28-4c8c-b13e-87bc366f43a8@arm.com>
Date: Thu, 28 May 2026 14:21:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] arm64+KVM: FPSIMD/SVE/SME cleanups
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 5/21/26 14:25, Mark Rutland wrote:
> Hi.
> 
> This series cleans up low-level FPSIMD/SVE/SME state management code,
> making it easier to maintain and extend (e.g. adding SME support to
> KVM), and enabling better debugging (e.g. by making SVE/SME save/restore
> visible to KASAN and KCSAN).
> 
> This is purely cleanup, there are NO bugs addressed by this series.
> 
> The series aims to do a few key things:
> 
> * Make it harder to mis-manage in-memory SVE state and SME state. These
>   are given opaque types (struct sve_state and struct sme_state), and
>   the (awkward) calling convention for saving/restoring SVE state is
>   simplified to take a pointer to the base of the state rather than a
>   pointer to the FFR within the state.
> 
> * Minimize duplications between KVM and the rest of the kernel. The
>   FPSIMD/SVE/SME routines are moved to inline assembly such that the
>   same helper functions can be used everywhere, without the need to wrap
>   assembly macros.
> 
> * Make the code easier to follow. Assembly sequences are minimized to
>   avoid address generation and control-flow that can be written more
>   clearly in C. Awkward assembly macros are removed where possible.
> 
> * Make it easier to debug state management. Explicit instrumentation is
>   added to the save/restore functions so that KASAN and KCSAN can detect
>   memory safety issues and concurrency issues.
> 
>   This instrumentation is inhibited for nVHE hyp objects, and does not
>   adversely affect KVM. I've confirmed by looking at compiler flags
>   during the build, and disassembling the relevant object files.
> 
> * Remove unnecessary code. By relying on assembler support for SVE and
>   SME we can remove awkward assembly macros, making the code
>   significantly simpler and easier to read.
> 
> I've compile-tested this with a variety of toolchains:
> 
> * GCC  8.1.0 + binutils 2.30
> * GCC 11.1.0 + binutils 2.36.1
> * GCC 12.1.0 + binutils 2.38
> * GCC 15.2.0 + binutils 2.45
> * LLVM 15.0.7
> * LLVM 21.1.8
> 
> I've boot-tested on an SVE+SME capable model, both with KASAN enabled
> and without KASAN enabled. All the FPSIMD/SVE/SME kselftests passed in
> both configurations, without any KASAN splats. Unfortunately, with KCSAN
> enabled, some tests hit timeouts (without any KCSAN splat), which I
> believe is simply due to the overhead of KCSAN rather than some adverse
> functional effect.
> 
> I've boot-tested on an SVE+SME capable model, booting with KVM in each
> of:
> 
> * VHE mode
> * hVHE mode
> * Protected mode
> 
> In each case I've boot-tested a v7.0 defconfig guest, both with SVE and
> without SVE.
> 
> Mark.
> 
> Mark Rutland (18):
>   KVM: arm64: Don't include <asm/fpsimdmacros.h>
>   KVM: arm64: Don't override FFR save/restore argument
>   KVM: arm64: pkvm: Save host FPMR in host cpu context
>   KVM: arm64: pkvm: Remove struct cpu_sve_state
>   arm64: fpsimd: Fold sve_init_regs() into do_sve_acc()
>   arm64: fpsimd: Remove sve_set_vq() and sme_set_vq()

This may be out of scope for the series, but I noticed that
write_vl() and sve_cond_update_zcr_vq() might similarly benefit
from using sysreg_clear_set_s()

>   arm64: fpsimd: Use assembler for SVE instructions
>   arm64: fpsimd: Use assembler for baseline SME instructions
>   arm64: fpsimd: Move sve_get_vl() and sme_get_vl() inline
>   arm64: sysreg: Add FPCR and FPSR
>   arm64: fpsimd: Split FPSR/FPCR from SVE save/restore
>   arm64: fpsimd: Move fpsimd save/restore inline
>   arm64: fpsimd: Use opaque type for SVE state
>   arm64: fpsimd: Use opaque type for SME state
>   arm64: fpsimd: Move SVE save/restore inline
>   arm64: fpsimd: Move sve_flush_live() inline
>   arm64: fpsimd: Move SME save/restore inline
>   arm64: fpsimd: Remove <asm/fpsimdmacros.h>
> 
>  arch/arm64/Kconfig                      |   5 +
>  arch/arm64/include/asm/fpsimd.h         | 369 ++++++++++++++++++++++--
>  arch/arm64/include/asm/fpsimdmacros.h   | 357 -----------------------
>  arch/arm64/include/asm/kvm_host.h       |  27 +-
>  arch/arm64/include/asm/kvm_hyp.h        |   5 -
>  arch/arm64/include/asm/kvm_pkvm.h       |   3 +-
>  arch/arm64/include/asm/processor.h      |   7 +-
>  arch/arm64/kernel/Makefile              |   2 +-
>  arch/arm64/kernel/entry-common.c        |   8 +-
>  arch/arm64/kernel/entry-fpsimd.S        | 134 ---------
>  arch/arm64/kernel/fpsimd.c              |  90 +++---
>  arch/arm64/kvm/arm.c                    |  16 +-
>  arch/arm64/kvm/guest.c                  |   4 +-
>  arch/arm64/kvm/hyp/entry.S              |   1 -
>  arch/arm64/kvm/hyp/fpsimd.S             |  33 ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  23 +-
>  arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  20 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c         |   4 +-
>  arch/arm64/kvm/hyp/vhe/Makefile         |   2 +-
>  arch/arm64/tools/sysreg                 |  45 +++
>  21 files changed, 480 insertions(+), 677 deletions(-)
>  delete mode 100644 arch/arm64/include/asm/fpsimdmacros.h
>  delete mode 100644 arch/arm64/kernel/entry-fpsimd.S
>  delete mode 100644 arch/arm64/kvm/hyp/fpsimd.S
> 
> -- 2.30.2
> 

Cheers
Vladimir
