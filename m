Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8849569F2C
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 16:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884386; cv=none; b=TUhaHetnEnjL2gg1THrJhUpogvdfUX+FyN53aXMsZgBxhAg+1yFNFJlnl9IQdFasjqWtZHyvyyFq9I7zLtIJ2tyBoLu6jKr4jRum4xBk1ozZ0z0RKdMR9N8/MTCBSLyPnMgHvt+wh5SNykeW2bmjDEkDmazqk5yVNvhyKOqOaBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884386; c=relaxed/simple;
	bh=dR7gu87uNwDxeR+EZwq4z+4Id2o1CljMYJwUBZ26JdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9W5lOfskwJWC+iET7DdLTBf/O338DT60zf2XiApt7AVkBYbNAo68ZEN/jdCuRRYefUeK8GnFXJk1ntoUAcXa+YD1jQXdAJTHDoiF8FlRSyueUkmAsSUF17cCbkjq16r0KtiamRSW/ZnB3l2iPGyYeks+r+wpm37/e1S26IIfjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bKLA+kcp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bKLA+kcp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 903C31476;
	Tue,  8 Sep 2026 09:19:40 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 806B63F7B4;
	Tue,  8 Sep 2026 09:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884384; bh=dR7gu87uNwDxeR+EZwq4z+4Id2o1CljMYJwUBZ26JdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKLA+kcpxksCOfvmdrVLpPFISwpSyiOLfwWXfXkZWOp0i7GgObZfbMEBxdGq5+bmM
	 b5On4nUY5nFQfZ8maY6lbag/3Quj5Masczbyo6SKQCFTByuvLdWVNvwXeA/2qD1GBh
	 /uVIQpTwW0V8APMeWVfbJlWnIXEew3lp6hPxKTyY=
Date: Tue, 8 Sep 2026 17:19:35 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	nd <nd@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm64: sysreg: Make write_sysreg_s() select XZR
 without optimisation
Message-ID: <aqA1l_86CGSeL_2B@J2N7QTR9R3>
References: <20260904174855.76185-1-sascha.bischoff@arm.com>
 <20260904174855.76185-2-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904174855.76185-2-sascha.bischoff@arm.com>

On Fri, Sep 04, 2026 at 06:49:25PM +0100, Sascha Bischoff wrote:
> write_sysreg_s() tests whether its local __val variable is constant when
> deciding whether to use XZR. Compilers only recognise that __val was
> initialised with a constant zero after constant propagation.
> 
> With optimisation disabled, the fallback path therefore selects an
> arbitrary general-purpose register. This is incorrect for instructions
> such as GIC CDEOI, where Rt must be XZR rather than a register containing
> zero.

Which CONFIG_* option needs to be selected for that to happen?

I'm struggling to see how other usage of __builtin_constant_p() wouldn't
blow up in such a configuration, so knowing that would help to
investigate and test.

> Test the macro argument directly so that constant zero selects XZR
> regardless of the optimisation level.
> 
> Fixes: e9ad390a4812 ("arm64/sysreg: Fix GIC CDEOI instruction encoding")
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 7aa08d59d4944..a80bede50f865 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1204,7 +1204,7 @@
>  #define write_sysreg_s(v, r) do {					\
>  	u64 __val = (u64)(v);						\
>  	u32 __maybe_unused __check_r = (u32)(r);			\
> -	if (__builtin_constant_p(__val) && __val == 0)			\
> +	if (__builtin_constant_p(v) && (u64)(v) == 0)			\

It's not safe to use 'v' here, since 'v' could be an expression with
side-effects, and we must not evaluate it multiple times.

I think we should just enxcode the GIC instructions manually. While they
are SYS/SYSL instructions, they *aren't* MSR/MRS, and using
write_sysreg_s() is a hack.

Mark.

>  		asm volatile(__msr_s(r, "xzr"));			\
>  	else								\
>  		asm volatile(__msr_s(r, "%x0") : : "r" (__val));	\
> -- 
> 2.34.1
