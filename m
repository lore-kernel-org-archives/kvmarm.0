Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7964981727;
	Thu, 19 Dec 2024 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734623352; cv=none; b=dQT7MCHTrODVmHaHcj5/X4JhqvUN609KqxoEBHmlWaZiTHYgNr0PZrpgyDxqogHSNi1bNpWTO4JcDZ+VLK0j+vYEXCJ+XY/NIDTGkkp3SBEWPJlbHAHgvRWIl38Y1q14UI99dvRG08u3PGF5tcepQDCQ0ss/VP7mI6xqGvmtZ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734623352; c=relaxed/simple;
	bh=Em6tjA4shpu07NzsF3bttoRoasi6FATll0gF+/u1AaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAyEJwNNrDBs2mENUHDLMNVLNHcrYIu9O3y9E00hLxNDlDlthtuvztoEyVZVp7vD0ZYk7/hlbvTBqLnE7kv/mp4qGkyQIwaFIlCQR4L7PFVpt+kW4LIHMJyTmE7o/sXxm7CU2LUBCU8O7OWPEozawjyxOCVvHwf/f0gZSBtNXm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpTedCyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpTedCyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EDAC4CECE;
	Thu, 19 Dec 2024 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734623352;
	bh=Em6tjA4shpu07NzsF3bttoRoasi6FATll0gF+/u1AaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mpTedCyGbS2Qz6Hu3kWxKi9equYBguWZ8nsXhXkkF9vjOE7G0/e3kwCDoThhdoc1V
	 tXIU4rRqrwITm27Lk1S6G0g0xRedDuunpL5sADY1cpaMeM4Kp2pve6dq0nsbNPt+yA
	 GvAW3jUtcYHQN49d7iI8Bk5ec1APOqgnjXOEokCQkp9ef7JJBcXk9itbrGtu6che9r
	 ZjyvAbChGmr7jgbyYcoPRS/+SpO0DbvV62aSqalS2DRU3f+lG6D3ewlIp/3k0puGHZ
	 KF43plamGupTNbwUkdB4H/e9nlOXsZWPUmyRy5uu6TvC1xWHo4CtKhfJtyDRHXB5NA
	 T53TpmkaVB6uQ==
Date: Thu, 19 Dec 2024 15:49:06 +0000
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH V2 5/7] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
Message-ID: <20241219154905.GA24724@willie-the-truck>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
 <20241028053426.2486633-6-anshuman.khandual@arm.com>
 <20241210164144.GA16039@willie-the-truck>
 <a382200e-00c4-405a-a417-f4c09bd91fb7@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a382200e-00c4-405a-a417-f4c09bd91fb7@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 11, 2024 at 10:02:42AM +0530, Anshuman Khandual wrote:
> 
> 
> On 12/10/24 22:11, Will Deacon wrote:
> > On Mon, Oct 28, 2024 at 11:04:24AM +0530, Anshuman Khandual wrote:
> >> This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
> >> ftr_raz[] array which is now redundant. These register fields will be used
> >> to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
> >> later.
> >>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will@kernel.org>
> >> cc: Mark Brown <broonie@kernel.org>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ---
> >>  arch/arm64/kernel/cpufeature.c | 21 ++++++++++++++++-----
> >>  1 file changed, 16 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> >> index 718728a85430..bd4d85f5dd92 100644
> >> --- a/arch/arm64/kernel/cpufeature.c
> >> +++ b/arch/arm64/kernel/cpufeature.c
> >> @@ -530,6 +530,21 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
> >>  	ARM64_FTR_END,
> >>  };
> >>  
> >> +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
> >> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
> >> +	ARM64_FTR_END,
> >> +};
> > 
> > I think I mentioned this on an earlier series, but it would be useful to
> > see some justification in the commit message as to why some of these
> > features are considered STRICT vs NONSTRICT and why LOWER_SAFE is
> > preferred over EXACT.
> 
> I have updated the commit message regarding STRICT vs NONSTRICT as Mark had
> mentioned earlier (see below). But just wondering about FTR_LOWER_SAFE. All
> similar fields have been marked as FTR_LOWER_SAFE.
> 
> > 
> > For example, why is EBEP strict whereas other PMU-related fields aren't?
> 
> IIUC there are two types of fields here.
> 
> - Feature presence     (EBEP, ITE, ABLE etc)		---> FTR_STRICT
> - Debug resource count (WRPs, BRPs, CTX_CMPs etc)	---> FTR_NONSTRICT
> 
> > Why is the CTX_CMPs field treated differently to the same field in DFR0?
> 
> There is mismatch not only for CTX_CMPs but for WRPs and BRPs as well. As
> mentioned earlier, being resource count type, I believe these should be
> marked as FTR_NONSTRICT in existing DFR0 as well. I could send a patch
> fixing DFR0 first.
> 
> > 
> > I'm not saying the above table is wrong, it just looks arbitrary without
> > the justification.
> 
> Please find the updated version (v3) for this patch here for reference.

Please send new versions as new threads otherwise it's too easy to lose
track. Also, please give the rationale for the handling of each new field
in the commit message.

Will
