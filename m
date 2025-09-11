Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37456343D7A;
	Thu, 11 Sep 2025 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605087; cv=none; b=QKBD0dJJTqePYF53kYAMSYxVST3LEmIb2bNHjLcVu6IVBnQASGqxhcSCxH72f3mBZHfBZClZp0qI/K1tTsbo+zhHXu3Ue0xCSnSAJxXlSaKv/o6gqyxL1PFXT8fASK5cH445zuEMrzflw90QdjQr5paklKKNACoezBhFEovnWHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605087; c=relaxed/simple;
	bh=6P7TRYNOF7lDU5UaN1FbR0F71Q85GTIwRzbYM8hTeno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvivyX6eicKqcGyRJ99vGGARsP4ymIxeqUDqciWJcrBfVxyNTiwh8zGSTH9IHqv7nbdJ1LqJAbGr1nqltTXlt6+CcFJOAV1k4/jvvSfqhT53yxUd310hAOTpoxUyEOsI+MUKcx2W2G/qbsrATWCPczuzriaFm4pbr2gPjPm8jNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGsOXkd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGsOXkd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077EBC4CEF0;
	Thu, 11 Sep 2025 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757605086;
	bh=6P7TRYNOF7lDU5UaN1FbR0F71Q85GTIwRzbYM8hTeno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WGsOXkd+1Y4hHnazxMQbb6HbneQJPdyJzgI/ZuSK3L1vKkYOIydxBe6mZo1udgV6b
	 Xg2fAMNVaoqQdsW0Ox9CO92bmONWVPL9lPnFJxmklBs2inzz5uFMKybYHa/uovgY2G
	 KY6+L3Q6gthV+FHggk8D/dS0DDFX8DhEbwAmvUQ9+4Dr6wBdpZYepnTVkltz7xRSFX
	 drV8N5P5XVCQ8ZJFjVqXc//k2GxIwCuwvfy1mYHNAjRXHm3liCU9G1cBwOKUITojts
	 eDhSki1ZfzoKELpiWTAVGJlN2c584OVz5Vv7aUywy4wyGe8/Ui//CJWE1isC4UjisC
	 Sd8qCapieGd3Q==
Date: Thu, 11 Sep 2025 16:38:00 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMLs2LcnflSw2uNr@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-5-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> Refactor futex atomic operations using ll/sc method with
> clearing PSTATE.PAN to prepare to apply FEAT_LSUI on them.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/include/asm/futex.h | 132 +++++++++++++++++++++------------
>  1 file changed, 84 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index bc06691d2062..ab7003cb4724 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -7,17 +7,21 @@
> 
>  #include <linux/futex.h>
>  #include <linux/uaccess.h>
> +#include <linux/stringify.h>
> 
>  #include <asm/errno.h>
> 
> -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> 
> -#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
> -do {									\
> -	unsigned int loops = FUTEX_MAX_LOOPS;				\
> +#define LLSC_FUTEX_ATOMIC_OP(op, insn)					\
> +static __always_inline int						\
> +__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> +{									\
> +	unsigned int loops = LLSC_MAX_LOOPS;				\
> +	int ret, oldval, tmp;						\
>  									\
>  	uaccess_enable_privileged();					\
> -	asm volatile(							\
> +	asm volatile("// __llsc_futex_atomic_" #op "\n"			\
>  "	prfm	pstl1strm, %2\n"					\
>  "1:	ldxr	%w1, %2\n"						\
>  	insn "\n"							\
> @@ -35,45 +39,103 @@ do {									\
>  	: "r" (oparg), "Ir" (-EAGAIN)					\
>  	: "memory");							\
>  	uaccess_disable_privileged();					\
> -} while (0)
> +									\
> +	if (!ret)							\
> +		*oval = oldval;						\

Why push the store to '*oval' down into here?

Will
