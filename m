Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ACC3FC7
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 13:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748351729; cv=none; b=YAb0388HGtDjMPEgd4sHBDSWQK520QS67bUlxK7MJyWRglcSuWLdyozMQhsBNyrBNXJY3aRYShNHz0ts6KJh/GsRr1y4LFbGrFePZngqXsWD/bOMq28YGF9ur1KBX+I9B+m6czVRMZUbNwBie3dTRlSmO3lP+2fPvaxxihs58Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748351729; c=relaxed/simple;
	bh=6D54vByl5BJVj7Q5acyjMDCFnX+ZDlUCn2n+jBrJ18Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhPlqyBiJ7Bfekjr5nhRDG1g3/vQRAZFYpNtRWXfPUrEtki9xyn7vCSlEIuA5y7sn+kYIUiTZLWupsOSb5gFPXzpAs7r/yYwsIXSe6YrMPjk0CFzw1F5UQOkfyx82ttgXDdXBHl2KJ/4Sx+JkjZ6aFyt7jZMXuNAcvXfQxSi57s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W23sI7XW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W23sI7XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8FFC4CEE9;
	Tue, 27 May 2025 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748351729;
	bh=6D54vByl5BJVj7Q5acyjMDCFnX+ZDlUCn2n+jBrJ18Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W23sI7XW7HJ4bRv/EKFKvnWoqni4NiXspbqA0f5IZ3Mw4rtBP2qPzGl0MPWDF6TiK
	 VOIlkSp/HF4PqJI5IFXn3CVZ+BbtECGfc20ZsqRGVnDoHzBiDhGwP8ffTMM/B8V6gs
	 xPbnEQ2UrOsjhJCOMtZHmYsreTu7uDr6A59qbTpCtQGKRydnOV2dBAgiWxI3JAG12s
	 uJgBS2qrOwMu0ZFc/jKhzc2O+2TTH0Wz5yclE/Snoy+ICowWIzRq+8SG6540cRvM+E
	 QKJjqEq7BBt1jO0h3ebDfoUGUKVSnvzkKEkVaeOSSyGSy/CIA1uYfJPINRuPtYBdZq
	 uyNMd2YjkmZxw==
Date: Tue, 27 May 2025 14:15:24 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] arm64: sysreg: Drag linux/kconfig.h to work around vdso
 build issue
Message-ID: <20250527131523.GA26734@willie-the-truck>
References: <20250523170208.530818-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523170208.530818-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 23, 2025 at 06:02:08PM +0100, Marc Zyngier wrote:
> Broonie reports that fed55f49fad18 ("arm64: errata: Work around
> AmpereOne's erratum AC04_CPU_23") breaks one of the vdso selftests
> (vdso_test_chacha) as it indirectly drags asm/sysreg.h.
> 
> It is rather unfortunate (and worrying) that userspace gets built
> with non-UAPI headers. In any case, paper over the issue by dragging
> linux/kconfig.h in asm/sysreg.h. It is the right thing to do, at
> least from the kernel perspective.
> 
> Reported-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: fed55f49fad18 ("arm64: errata: Work around AmpereOne's erratum AC04_CPU_23")
> Link: https://lore.kernel.org/r/aDCDGZ-G-nCP3hJI@finisterre.sirena.org.uk
> Cc: D Scott Phillips <scott@os.amperecomputing.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index cd853801a8f7b..f1bb0d10c39a3 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -12,6 +12,7 @@
>  #include <linux/bits.h>
>  #include <linux/stringify.h>
>  #include <linux/kasan-tags.h>
> +#include <linux/kconfig.h>
>  
>  #include <asm/gpr-num.h>

Marc, it will be quickest for you to take this as you also took the
AC04_CPU_23 workaround:

Acked-by: Will Deacon <will@kernel.org>

Will
