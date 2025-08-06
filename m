Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D8835898;
	Wed,  6 Aug 2025 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754519163; cv=none; b=OQ8HwK9JdAADoV69Nje8XTJacFXpclfAEaMj8Ct19OcGTZiFD+NPznK4xqV4GrhldKjMh7AsX8uzkdlZN+osgpNPNakgYDUHzjem96MqLKDXSPreFDo6NmIYInvKQgWtCNM4K55pmqtuadEwa5DdITO1yRM4p/rgbGIJX0VmY8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754519163; c=relaxed/simple;
	bh=wSP/FnjATYBkD9tjSijm87GKcLGQ9Dv8hJCzfo90h/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbbPQJwcc2cAWRYMqvaOFjhP1PlLsQCwMv2f7xABJE/7t4C4cIOF4dU/Y2p8nje5lXcz0oFSafZZLBEngAix3h1QeX7ljfkucagZ5SFkhmpOulxjM4LrSS2BMTevY4ZqOK/Y1oGz265ljcdwzqyGtNUBozayk6JqENMTq3BgRJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZVZtpHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZVZtpHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487F9C4CEE7;
	Wed,  6 Aug 2025 22:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754519163;
	bh=wSP/FnjATYBkD9tjSijm87GKcLGQ9Dv8hJCzfo90h/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZVZtpHcJ84kPEusQRbGh0yw0RjPpg0xx99EEBSWIBT7fatVExcSR13RCFr0P/Am9
	 f2rvIpIy9szjA5QOgilFY47ledEhI6DZBUnBeVsHIa6foNSKny7oPvL/byTHW/fhTr
	 UnwXixzezWxz5XRhtEWzuk1Ypp9tdH5bYTc9opJToSJ/fx2bbRqIebIzkKbNENvG1W
	 NJsvHnXcqdajLfRfpjWXrBzmSSTm5hIwNg4NCzwwUmkZyCA8zHEis15KZ4E///gMeC
	 XEO+0WBvsRRHw7PazG7Z22ryiE+ERSdb085I8LV78NiNdQmClZ/9uAxCOAHac92DHo
	 97Th+tup2Yegw==
Date: Wed, 6 Aug 2025 15:25:57 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Tom Rix <trix@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.1.y] KVM: arm64: sys_regs: disable
 -Wuninitialized-const-pointer warning
Message-ID: <20250806222557.GA1654483@ax162>
References: <20250728-stable-disable-unit-ptr-warn-v1-1-958be9b66520@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728-stable-disable-unit-ptr-warn-v1-1-958be9b66520@google.com>

On Mon, Jul 28, 2025 at 02:07:36PM -0700, Justin Stitt wrote:
> A new warning in Clang 22 [1] complains that @clidr passed to
> get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
> doesn't really care since it casts away the const-ness anyways -- it is
> a false positive.
> 
> |  ../arch/arm64/kvm/sys_regs.c:2978:23: warning: variable 'clidr' is uninitialized when passed as a const pointer argument here [-Wuninitialized-const-pointer]
> |   2978 |         get_clidr_el1(NULL, &clidr); /* Ugly... */
> |        |                              ^~~~~
> 
> Disable this warning for sys_regs.o with an iron fist as it doesn't make
> sense to waste maintainer's time or potentially break builds by
> backporting large changelists from 6.2+.
> 
> This patch isn't needed for anything past 6.1 as this code section was
> reworked in Commit 7af0c2534f4c ("KVM: arm64: Normalize cache
> configuration").
> 
> Cc: stable@vger.kernel.org
> Fixes: 7c8c5e6a9101e ("arm64: KVM: system register handling")
> Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---

Yes, I think this is an appropriate way to address this for stable.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  arch/arm64/kvm/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 5e33c2d4645a..5fdb5331bfad 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -24,6 +24,9 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>  
> +# Work around a false positive Clang 22 -Wuninitialized-const-pointer warning
> +CFLAGS_sys_regs.o := $(call cc-disable-warning, uninitialized-const-pointer)
> +
>  always-y := hyp_constants.h hyp-constants.s
>  
>  define rule_gen_hyp_constants
> 
> ---
> base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
> change-id: 20250728-stable-disable-unit-ptr-warn-281fee82539c
> 
> Best regards,
> --
> Justin Stitt <justinstitt@google.com>
> 
