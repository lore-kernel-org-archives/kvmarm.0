Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1FF42E404
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787752093; cv=none; b=A76gTydRZUcNvERzl77ewPNB6Y469zJYPDsGUR7CmiTMVpgkQMcwEuOTVYBYuAjxgbuFSS8jt9puTiWVaq7IF4jUSRNRxFAI9dljtPUBL0WywjarKb4K9xooaMsHixGhqXqwnAhPKGOW5bAalAYekF+aVe6ZQPeD/L8Bi3PlhrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787752093; c=relaxed/simple;
	bh=0UXHHnY9sWi5Mt+TALLKcMNNYkDUWfNr6VdZ1KNid5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkpUNhqro+/24Jlo+EclRH2IXBRnzoYdHErhv6p6q65WiqW5hrsUCumd9x0/WPyUbi6cT0uGSps5/dNzcS7yyH1QrHKMbXNbveQuJU0vHgeG/kGAIPoibQc65CD/o+bHR2q/4LsCCsADn+nd7gcOH+uS1GlPQa3jcMSQg29rEZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FKZ1g40Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FKZ1g40Y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02461165C;
	Wed, 26 Aug 2026 06:48:07 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FD233F66F;
	Wed, 26 Aug 2026 06:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787752090; bh=0UXHHnY9sWi5Mt+TALLKcMNNYkDUWfNr6VdZ1KNid5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKZ1g40YgIUhhK26pv8YfaYOFuKL+lh5KcBOKAfI2xbETnvre0C6fth7ioPNi9wo9
	 lEWFLDPGA3ZXoJfrwTH9xmy43U7i4OsL8VuDNuFduM7mDX5wdbX2vaGcF9gf1MfiLt
	 xqxwDicZT+yK1gJt6GTYKZBpwR5kfnwJ2aUCv8s0=
Date: Wed, 26 Aug 2026 14:48:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 2/2] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <ao7ukb2xewCp92uc@arm.com>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
 <20260825164219.3347229-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825164219.3347229-3-fuad.tabba@linux.dev>

On Tue, Aug 25, 2026 at 05:42:19PM +0100, Fuad Tabba wrote:
> __cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
> ID_AA64PFR1_EL1, so it reads the register even when the kernel has
> disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets HCR_EL2.TID5
> in that case, and pKVM injects an UNDEF the host cannot handle:
> 
>   Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
>   pc : __cpuinfo_store_cpu+0xf4/0x264
>   Kernel panic - not syncing: Attempted to kill the idle task!
> 
> Only pKVM reaches it, and only after a CPU is offlined and brought back
> online: its CPU_ON relay sets the host HCR before the CPU enters EL1,
> while plain nVHE sets it at CPUHP_AP_KVM_ONLINE.
> 
> Gate the read on __read_sysreg_by_encoding(), which applies the cmdline
> override, and on CONFIG_ARM64_MTE, which no register reflects.
> 
> Fixes: f35abcbb8a084 ("KVM: arm64: Trap MTE access and discovery when MTE is disabled")
> Cc: stable@vger.kernel.org # needs "arm64: Apply overrides to CPU local capabilities"
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
