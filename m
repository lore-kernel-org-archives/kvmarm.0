Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E32457C9F;
	Fri, 28 Aug 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787925200; cv=none; b=hx4NJjIoKkiEnYsYg+cOXlHn+zPUtcxpEYfhT8oUuk4ihZzrgjl5YLNy7QdgzXWQnU9QP8B0VAZ8pZK9zcSdjmLFjHHHebcHynPBIQCrs6ur5hFf4IyasQw9mRg7sdCIY0ciYcq1AFm1rDbdfbqtmmyC81K/fYqORBx5PEKbMFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787925200; c=relaxed/simple;
	bh=/eLzOt2jP53ZhLkDuOg3I7udBfAM7daywjAdbVuZvIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjzla3MHqtGQz9AP6XQAdZdsudz1ej2eiF1fFxlQbdUX3pnK3reTvVQuADM2hYNxd3E5Kmj0bW2DRYr3mQtjNgvqMzI4kEpfEHQvt0GKsB93i7C2N7ufl59Ybewlvmw7p4a1PbZAjTUCH5WaNemVPJ8zRFO5FrfV3Z15C4AyHIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUdx5Sge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUdx5Sge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE68C1F00A3A;
	Fri, 28 Aug 2026 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787925198;
	bh=bY0OwgPal6QlPB3ty/eOUhetwtY4hZxNYf6/eJ0Xpq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mUdx5SgeR+7kSaRoPuUgUMnVzm3fhdg8NQ2Oc/VCXSJlKo5B7Wyha57FemARc7g8d
	 WTfbjGIC5T7No8nZ87o8kDxcYBgyTAVwXqNVsz1NtzKKe0+8fSsGvDehx90Bpp27/0
	 uChQ1BehxD/grIKjBUQyZsiWgpahoj+eTh9xm9yBejCwehPpYC8EobjdvW8MH9lu5Q
	 ruvT5o5In58HuJXKLZ2Xfz/wfc3U9A2QNSkIKe340Eq2MCR7+YEep1JNdWu7i+fg4g
	 9DN9W6MKDKi5/SrBXb/0sck0/UoWaMoUNCPnybd0pWCpArGhVcH6ZoZfkKMSmSc+vG
	 DVGwM9NCFrugw==
Date: Fri, 28 Aug 2026 14:53:13 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 2/2] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <apGSye1_M737mITN@willie-the-truck>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
 <20260825164219.3347229-3-fuad.tabba@linux.dev>
 <apA0A-bqLVBcmdSv@willie-the-truck>
 <apFn5JihFkRoqX06@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apFn5JihFkRoqX06@arm.com>

On Fri, Aug 28, 2026 at 11:50:12AM +0100, Catalin Marinas wrote:
> On Thu, Aug 27, 2026 at 01:56:35PM +0100, Will Deacon wrote:
> > On Tue, Aug 25, 2026 at 05:42:19PM +0100, Fuad Tabba wrote:
> > > +/* No ID register reflects CONFIG_ARM64_MTE. */
> > > +static inline bool gmid_el1_accessible(void)
> > > +{
> > > +	if (!IS_ENABLED(CONFIG_ARM64_MTE))
> > > +		return false;
> > > +
> > > +	return id_aa64pfr1_mte(__read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1));
> > 
> > I'm planning to internalise __read_sysreg_by_encoding() into cpufeature.c
> > so I'd prefer to avoid adding another user of it, if possible. In this case,
> > __cpuinfo_store_cpu() has already read the thing, so all it needs is the
> > override logic (but see below).
> 
> That's a valid point.
> 
> > > @@ -502,7 +502,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
> > >  	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
> > >  	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
> > >  
> > > -	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
> > > +	if (gmid_el1_accessible())
> > >  		info->reg_gmid = read_cpuid(GMID_EL1);
> > 
> > I'm not sure this is safe. For the boot CPU, __cpuinfo_store_cpu() is
> > called before init_cpu_features(), so the arm64_ftr_regs[] array hasn't
> > been sorted and we can't call get_arm64_ftr_reg() reliably.
> 
> We no longer sort this array at boot-time, we just check that it's
> pre-sorted.

Fair enough, but I still don't think we should access it until we've
checked that.

> > In fact, it
> > doesn't even look like the overrides will have been processed.
> 
> init_feature_override() runs from early_map_kernel() but yes,
> init_cpu_ftr_reg() hasn't been called yet to vet the override. Suzuki's
> patch was adding extra checks in __read_sysreg_by_encoding() but if we
> drop that patch (and function eventually), better not to rely on it.

Right, and we have to be really careful here with things like the new
"nohaft" override because otherwise we could accidentally end up
thinking we have hardware dirty on CPUs that don't have it. In other
words, it's not just about people passing bonkers settings on the cmdline.

> So I don't think we have a correctness issue here but I don't mind v5
> either. I'll go and check.

Thanks.

Will
