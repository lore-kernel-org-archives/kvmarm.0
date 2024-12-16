Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2611D54EF;
	Mon, 16 Dec 2024 23:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734390914; cv=none; b=JKA690Kt+KixzfgX2bhrxNtO2YHYY24JnSjTU0twnhk1aRfs0dqjmjUDh8LQtovcOwxKwoRfqlePnk6wlxk2+ihWf2ujT+XkITw4DfVW9W6sdShD5qI+/1VRdBhwEumAVEOKjss5mnRbInU+KX3ILOdR1YGqs6DoJn5i/qoquLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734390914; c=relaxed/simple;
	bh=WDQGE0FFR/+3pDl5MBnQd9HPJMHqNLi1cxrtKgTsVJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhDRyTRdAhndHjfkcw8fHC/RJ0ioMwo60E2H4uueXMb0AC3DkKQki8Oox8w2yaOdpTzY5G0jT9+aKr7fOhZ6jqcB+HmrObsL22I420/Vz2nYw5XcGEzQyYdGgz5kF9PBd91Y0f1AdDWsWYJ2DfNghqaSxREKCctBt6lUqdQ81IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EczuVcps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EczuVcps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B59BC4CED0;
	Mon, 16 Dec 2024 23:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734390913;
	bh=WDQGE0FFR/+3pDl5MBnQd9HPJMHqNLi1cxrtKgTsVJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EczuVcpsRKVXCx0lYb5AdO0DfZtDyc0OfdX1XCRaKY5G5FnncKpFRuGDSEv498F0s
	 +xX0kftqNilbwMoL2B+3vy3htfse1J7b8bjov9lXk5bjaIjiJ76zV4f/IFD/Btq8V5
	 SUBv8c03T+udxenBUuYd1ge/HiudjWA3JyPw8kUpcwA+SLs0gGJ4bWjxSFZ4aY4uKo
	 eV3VsryU7XdRnzIrwuSEHgPv0EzUQS0Ypm8N/pd77nza1oTR7GJd3XqvPD9YCs4EvA
	 aX/hKsqvcqDkPjRb/v/kmCD+5Jkf32MjNqVkKObramCBDQUdMnw92l+O9fujlq5uZK
	 cmJO8DGbuxH3A==
Date: Mon, 16 Dec 2024 17:15:05 -0600
From: Rob Herring <robh@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH V2 18/46] arm64/sysreg: Add register fields for PMUACR_EL1
Message-ID: <20241216231505.GA601635-robh@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-19-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-19-anshuman.khandual@arm.com>

On Tue, Dec 10, 2024 at 11:22:43AM +0530, Anshuman Khandual wrote:
> This adds register fields for PMUACR_EL1 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 214ad6da1dff..462adb8031ca 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2349,6 +2349,43 @@ Res0	63:5
>  Field	4:0	SEL
>  EndSysreg
>  
> +Sysreg	PMUACR_EL1	3	0	9	14	4

I already added this and various other PMUv3.9 registers you've added 
here in v6.12 and v6.13. So are you on an old base or the tool allows 
multiple definitions? If the latter, that should be fixed.

> +Res0	63:33
> +Field	32	FM
> +Field	31	C
> +Field	30	P30
> +Field	29	P29
> +Field	28	P28
> +Field	27	P27
> +Field	26	P26
> +Field	25	P25
> +Field	24	P24
> +Field	23	P23
> +Field	22	P22
> +Field	21	P21
> +Field	20	P20
> +Field	19	P19
> +Field	18	P18
> +Field	17	P17
> +Field	16	P16
> +Field	15	P15
> +Field	14	P14
> +Field	13	P13
> +Field	12	P12
> +Field	11	P11
> +Field	10	P10
> +Field	9	P9
> +Field	8	P8
> +Field	7	P7
> +Field	6	P6
> +Field	5	P5
> +Field	4	P4
> +Field	3	P3
> +Field	2	P2
> +Field	1	P1
> +Field	0	P0

We're never going to use Pnn defines. This is just useless bloat unless 
we're aiming to top amd gpu defines LOC.

Rob
