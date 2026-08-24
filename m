Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26762361DA8
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787603350; cv=none; b=gbj0kzHRKjD0c6ozQ6M7bPvNeJ/6ClDhMVM8XC2L/lr51zJPesHPESdxzj7XCa2/EoGhJcbS/a9fT/gJty+VG4IU5TGLf9skbvVVIuFnni60tVm1f+NZxIQL7j12r8Z7rzzL68FaDMLCb87jCYW/8fDtVyQETanRZibQNSFmCeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787603350; c=relaxed/simple;
	bh=kkEoJVrwhvSQohI08+GwUFtwJ2wt4Bh968PHvPB/9Ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufEHjMrEzCayN8SWQaHUzbhJpQbaH7CCvA/l9TuIuahfjZlclIOYOLP7nCyi668KCTE/IqLdWeKNjdGkds3kgYC0iAMJuaryD0ri6a6zLwx4Cm47VgJ5KTIRkB28olAInXnOCuu7zR4WowwmhOcumHN/iOF69eSCy3voojTQ71I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DT7qgynb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DT7qgynb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F0B21BA8;
	Mon, 24 Aug 2026 13:29:03 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D4AD3F7D8;
	Mon, 24 Aug 2026 13:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787603347; bh=kkEoJVrwhvSQohI08+GwUFtwJ2wt4Bh968PHvPB/9Ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DT7qgynbF5QFkVC9xu5uYwXWAp6m9gprdFEoKlio8dN1pDIal/jDyVaw0ViUVto6c
	 RgEShccVTBujpqaM9cv7V87zg7ieEYoNhiTGcR7AR9af1A87YfvKjDe8FMYG8hLdWi
	 RNa0IumFXRhzOKzyH+TRGTKOW+Whd7Y6NJwF8oUg=
Date: Mon, 24 Aug 2026 21:29:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <aoypji6EJ8zToWvh@arm.com>
References: <20260824184155.2644646-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824184155.2644646-1-fuad.tabba@linux.dev>

On Mon, Aug 24, 2026 at 07:41:55PM +0100, Fuad Tabba wrote:
> +/*
> + * Reading GMID_EL1 when the kernel has disabled MTE traps to EL2, and the raw
> + * ID_AA64PFR1_EL1 reflects neither CONFIG_ARM64_MTE nor the cmdline override.
> + */
> +static inline bool gmid_el1_accessible(u64 pfr1)
> +{
> +	if (!IS_ENABLED(CONFIG_ARM64_MTE))
> +		return false;
> +
> +	pfr1 &= ~id_aa64pfr1_override.mask;
> +	pfr1 |= id_aa64pfr1_override.val;
> +
> +	return id_aa64pfr1_mte(pfr1);
> +}

Can this function not use __read_sysreg_by_encoding() directly and not
get an argument at all? We'd get the override from that function rather
than open-coding it here. Eventually, once we get Suzuki's clamping fix,
it also ensures we won't be able to bump the MTE version to unsafe
values (but that's a different fix from this one).

If you are worried about additional trapping of the MRS, we should go
for Will's improvement to always read the cached values in
__read_sysreg_by_encoding().

-- 
Catalin
