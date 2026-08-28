Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46686362153
	for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 10:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787914226; cv=none; b=s076M86ljFqIZ5WznDAMJ6mQiuyY6rC2a+Iu0qXFMVKsjwMNbkmVl+p8Pe8Adbz8YY3jllFSUKztD4ofHckFK0BzPdaJHBBMfn4/GGNuEXO1lUmoVTz8YfGwEmh6sLO26RpyKzCtmELcoupPuuGU0UsCnHfoSRcoIyUnF7Vz95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787914226; c=relaxed/simple;
	bh=HZfwVBpv4wxsbtGEupJ6THrOaSzncjo27eGuLcBbZ3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7bbRI1y5h8KCJ3FzOSvGLYnTZFD9QfvVppSUhW65KZC5e1Ndi0PEanGMU3+MG95IhKYVTQncPCwD/nimSYYpDR2CYNbFVEJKk/sjhcs5MTxcJuXiyFXpT5QhHuzL/EQn9eZVnDzyfmz8D61P+lZATiO7wI628gQn6tJV6hFYUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LZ8V4gjv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LZ8V4gjv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA2C71595;
	Fri, 28 Aug 2026 03:50:18 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F05453F85F;
	Fri, 28 Aug 2026 03:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787914222; bh=HZfwVBpv4wxsbtGEupJ6THrOaSzncjo27eGuLcBbZ3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZ8V4gjvEaZKWWC4ivOCqNwgHmxnpR/KY2xHffOcOqh42/zM2ZY9GvdcMAcPrbUsK
	 w4ITCbpWeewkvuRNDNlx+hJecUq0UTkB9mDupmXOJvxiaoMXLLoyy/ln7rQC1oXSPv
	 jCIn+UprzLVTOu9a5mtuveimihQc1Dr5ynoW8woo=
Date: Fri, 28 Aug 2026 11:50:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 2/2] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <apFn5JihFkRoqX06@arm.com>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
 <20260825164219.3347229-3-fuad.tabba@linux.dev>
 <apA0A-bqLVBcmdSv@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apA0A-bqLVBcmdSv@willie-the-truck>

On Thu, Aug 27, 2026 at 01:56:35PM +0100, Will Deacon wrote:
> On Tue, Aug 25, 2026 at 05:42:19PM +0100, Fuad Tabba wrote:
> > +/* No ID register reflects CONFIG_ARM64_MTE. */
> > +static inline bool gmid_el1_accessible(void)
> > +{
> > +	if (!IS_ENABLED(CONFIG_ARM64_MTE))
> > +		return false;
> > +
> > +	return id_aa64pfr1_mte(__read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1));
> 
> I'm planning to internalise __read_sysreg_by_encoding() into cpufeature.c
> so I'd prefer to avoid adding another user of it, if possible. In this case,
> __cpuinfo_store_cpu() has already read the thing, so all it needs is the
> override logic (but see below).

That's a valid point.

> > @@ -502,7 +502,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
> >  	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
> >  	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
> >  
> > -	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
> > +	if (gmid_el1_accessible())
> >  		info->reg_gmid = read_cpuid(GMID_EL1);
> 
> I'm not sure this is safe. For the boot CPU, __cpuinfo_store_cpu() is
> called before init_cpu_features(), so the arm64_ftr_regs[] array hasn't
> been sorted and we can't call get_arm64_ftr_reg() reliably.

We no longer sort this array at boot-time, we just check that it's
pre-sorted.

> In fact, it
> doesn't even look like the overrides will have been processed.

init_feature_override() runs from early_map_kernel() but yes,
init_cpu_ftr_reg() hasn't been called yet to vet the override. Suzuki's
patch was adding extra checks in __read_sysreg_by_encoding() but if we
drop that patch (and function eventually), better not to rely on it.

So I don't think we have a correctness issue here but I don't mind v5
either. I'll go and check.

-- 
Catalin
