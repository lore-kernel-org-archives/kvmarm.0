Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCF127F754;
	Tue, 31 Mar 2026 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774998137; cv=none; b=iq0wWzA/XzPwGFcbLEwPW/ExPZujV1Fr1D8mozNUN8eOZJzyBbhkxibTZ6dL8PjP6S6a3FqRMtzJmoJSz7VeSFl8K7iuGIr6Ud+d+Tr05eseJULzCqa1gmrX4RnYDXvfUacrgBzXMMjYylI+edi9FKhX/IRyu6BJ2VMdNzDKtWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774998137; c=relaxed/simple;
	bh=OW/XLNdysiIJQF3nWAMI661DMkxF2EE8210XPK0GwVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyAlJa7cye1SUZYYzYA9/SqaBvO24s9kG9tZXxr1JGpwC4nmWjVAbKUmNc39/LPZF8fBqOgax9DVFQV2QWNPdCsZmNMmfVWVf+DO207OYUTl38HTlarn6szUgo/pXAGf9ljuOGty+eJeLdX19udtuBhboysZPS9oml/bnhAiijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwmoBV31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwmoBV31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E52C19423;
	Tue, 31 Mar 2026 23:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774998136;
	bh=OW/XLNdysiIJQF3nWAMI661DMkxF2EE8210XPK0GwVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gwmoBV31HBuFTBWIcAl71LqzfnjvY2UucgtAwiuH8/LcGsNGi69QsiPTfrnOllVfC
	 XhvDLU3wEHIObeBiIGft+j+AxZoQYUqeSfuFaAYFiehaJI4S7vJDJathBpaV2pLQCL
	 WxIVHDKNMLDFSBP4yvfyCBzYUD4QaVZ+UXm+5dTGaBlgQCGYqfm4Fq1FDguCX5nW8+
	 qdqEUE1pA/2scuA2fiyhzuL/jE7mf4kI3LD94HaoFzfh5JlxiwbBqlyCKqWRMrEwgQ
	 +E+82OcByxTpBjOwFO/AdqTK8aC/7FCzuN/l00Bzy+ZCTbejjJ1PotbBdSwkmsPQs8
	 pSmlW3JzXi5ew==
Date: Tue, 31 Mar 2026 18:02:13 -0500
From: Rob Herring <robh@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH V3 7/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Message-ID: <20260331230213.GB2082670-robh@kernel.org>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-8-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241216040831.2448257-8-anshuman.khandual@arm.com>

On Mon, Dec 16, 2024 at 09:38:31AM +0530, Anshuman Khandual wrote:
> Currently there can be maximum 16 breakpoints, and 16 watchpoints available
> on a given platform - as detected from ID_AA64DFR0_EL1.[BRPs|WRPs] register
> fields. But these breakpoint, and watchpoints can be extended further up to
> 64 via a new arch feature FEAT_Debugv8p9.
> 
> This first enables banked access for the breakpoint and watchpoint register
> set via MDSELR_EL1, extended exceptions via MDSCR_EL1.EMBWE and determining
> available breakpoints and watchpoints in the platform from ID_AA64DFR1_EL1,
> when FEAT_Debugv8p9 is enabled.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in V3:
> 
> - Used SYS_FIELD_PREP() in read_wb_reg() and write_wb_reg()
> - Added MAX_PER_BANK based BUILD_BUG_ON() tests in arch_hw_breakpoint_init()
> - Dropped local variables i.e mdsel_bank and index
> - Derived bank and index from MAX_PER_BANK as required
> 
>  arch/arm64/include/asm/debug-monitors.h |  1 +
>  arch/arm64/include/asm/hw_breakpoint.h  | 47 ++++++++++++++++++------
>  arch/arm64/kernel/debug-monitors.c      | 15 +++++---
>  arch/arm64/kernel/hw_breakpoint.c       | 48 +++++++++++++++++++++++--
>  4 files changed, 95 insertions(+), 16 deletions(-)
> 

[...]

>  void enable_debug_monitors(enum dbg_active_el el)
>  {
> -	u32 mdscr, enable = 0;
> +	u64 mdscr, enable = 0;
>  
>  	WARN_ON(preemptible());
>  
> @@ -90,6 +91,9 @@ void enable_debug_monitors(enum dbg_active_el el)
>  	    this_cpu_inc_return(kde_ref_count) == 1)
>  		enable |= DBG_MDSCR_KDE;
>  
> +	if (is_debug_v8p9_enabled())
> +		enable |= DBG_MDSCR_EMBWE;

Just to record my own findings, this is in the wrong place. This will 
cause the below code to run every time, not just on the first enable or 
kernel or user mode breakpoints. it needs to be moved into the below if.

> +
>  	if (enable && debug_enabled) {
>  		mdscr = mdscr_read();
>  		mdscr |= enable;
