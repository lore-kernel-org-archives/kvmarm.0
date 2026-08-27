Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821333033D6;
	Thu, 27 Aug 2026 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787836807; cv=none; b=IYLxQfgok74FyAx+31IOt8LhHx3d2FuOUtW+Upn6g4yySwgqJW2TdGt1Mb8xexHrS64te/nIJejzPW0/JE7dXiTJsl8iKZSrrLfVIdU/dJpR3afJ8U6BuDa/SAaP3Krb1z6TpzUkkdBFLzwH22bSKuFW9G/+wZNY4p/6AI2TwQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787836807; c=relaxed/simple;
	bh=QSANIG3hcVSmqWaS2zkWvVsBpmmZZpCXezCyuF91FCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWcgMtndyPJxrnJFhwssCZVDgg+L61I7+qCTVoNK7YUFDz8WicnIXE8t7vmJOsx2qV7KwytKYc/03075++U6NjIgG8gRWCQcSUmyeIv2sJ4Dvb2iiLzrFWL6Oi8utVCmR9W8We1OWydLI+zYoMQFPHtcXSmui+MqykIzk+rLQmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2EhxUu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2EhxUu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0680D1F000E9;
	Thu, 27 Aug 2026 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787836795;
	bh=CEVtPBkm+IoyOpWd89dXe6eCoqDd0rD0qWlUQ8IixjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c2EhxUu0JLTQ0HxBXS4qWFw8NGFqQFW99MOapNxmO6IEMsC7+noMSrdEjTacc2zl1
	 JDCuoY9mdTdGomEgEEW/fDTOSAS1HZyEl4cDkBO/b70PJAdWA0N0rRZ5U6X1C9wXE/
	 kYR81Gr4SBO26RIAJsfHOAPJPN0gLe+99+S+ilFKyFA3mZ9vDOIHsMTbWXjDDRzt2T
	 5kYPaPsIFBKIS1g/6u9EeYtSzWGfgWfhURqSmPFkCquJTV5e80EUAcsSUfAzd81aWJ
	 ilqtOytoSNzoRP8CA2w90GHdBf2c6PxlBZwq1tqOsCnHWcqPlfcUrfoi13QNH6RPVA
	 mJMVbuUQd3saQ==
Date: Thu, 27 Aug 2026 14:19:49 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 2/2] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <apA5dYIPEQbQVJLf@willie-the-truck>
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
> > diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> > index d50e2a9b066b3..389fca84f106b 100644
> > --- a/arch/arm64/kernel/cpuinfo.c
> > +++ b/arch/arm64/kernel/cpuinfo.c
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
> been sorted and we can't call get_arm64_ftr_reg() reliably. In fact, it
> doesn't even look like the overrides will have been processed.
> 
> So we're in a bit of a chicken-and-egg problem here. Perhaps we need an
> early (__init) function that can apply the override manually to the
> value read from hardware using arm64_ftr_safe_value(). You'll probably
> need something like my old hack [1] to avoid the bsearch though :/

Thinking about this for a few more minutes, perhaps the best option for
a quick fix would be to:

 - Internalise gmid_el1_accessible() in cpufeature.c and take cpuinfo *
   as a parameter

 - It could then refer directly to the ftr reg, along the lines of:

	val = arm64_ftr_safe_value(&ftr_id_aa64pfr1,
				   <value from id_aa64pfr1_override>,
				   <value from cpuinfo>);

 - Then check val before accessing the gmid.

Then we can fix all this properly in the future by moving the override
stuff earlier.

Will
