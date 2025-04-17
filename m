Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E672566CE
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913494; cv=none; b=WZ8fZVOtcseAokAtsLtTyto4NvSYmLBS+YfTTwpfoxeE4z4U1THNr63G4q/IrQ3wOrVn21ackjBQH32ZQTrg7xnR3hSxU4MjfgcsdvjYskljk83/bTFzZGEsQegdKYxROTGzoljqQsFP9naY7/UH2NTQiE2QFpgRK8+A8oZ0Dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913494; c=relaxed/simple;
	bh=Firc0cRgV1ArBlilPVIKy29fSByQMjw0rGUzbaoNpwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcIroN3qtwHw2cpgzOfjTwiZm9umwGlhM3CVIsO5jN4MmdN2WQv6CY9/28o5rrg4laTrkuemYbAVb0ExoP3TygvShmFtFGW9DSFagTw5LNrAdcP0/sEggotAavRt6zgBDzHv1+UMYosX983r9ebnuPH6a9eMzHA+hiNxIND0DmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=aInTtjNq; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="aInTtjNq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VHYbpwLHuvljn8dVbt/fXb3LbUKc7Sc+NNW5fjMzCUU=; b=aInTtjNqwlrROOwNVA9D6/KOgb
	tdljBolfEjvm5NfCpi86ZldFZoGJKfxFdNAWfSPV12YVSfK09E53mETYDb8yeJt35iNS4GKQ8YOBn
	Lf76bylRCZiVU2F7O9DTElD+j2Z+yjB1zzBufle0HD92rcof6bd8zBhVqq9WAui1CgoRT14He4hTE
	2psFzmGVL3CD4xG+2TMEmxat4si0N+Tl2jEWNzPZnYd4ho7pdp7eoOQVFrcPbazJDYG78qH77dVTm
	eAYwTGT3BpdmHV/sudXjyVmeWr5caNNum07ficSULUB8L3u0tm1/R6Eq9z+nYS0KFN5EryidJ/Ten
	VSUmjoBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57866)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1u5Thg-0007nk-0W;
	Thu, 17 Apr 2025 19:11:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.96)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1u5Tha-0002fW-1R;
	Thu, 17 Apr 2025 19:11:06 +0100
Date: Thu, 17 Apr 2025 19:11:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Luo Jie <quic_luoj@quicinc.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, andrew@lunn.ch, quic_kkumarcs@quicinc.com,
	quic_linchen@quicinc.com, quic_leiwei@quicinc.com,
	quic_suruchia@quicinc.com, quic_pavir@quicinc.com
Subject: Re: [PATCH v3 3/6] arm64: tlb: Convert the opencoded field modify
Message-ID: <aAFEOr_PnZRH2ocR@shell.armlinux.org.uk>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-3-6f7992aafcb7@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417-field_modify-v3-3-6f7992aafcb7@quicinc.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Thu, Apr 17, 2025 at 06:47:10PM +0800, Luo Jie wrote:
> Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> - reg &= ~MASK;
> - reg |= FIELD_PREP(MASK, val);
> The semantic patch that makes this change is available
> in scripts/coccinelle/misc/field_modify.cocci.
> 
> More information about semantic patching is available at
> https://coccinelle.gitlabpages.inria.fr/website
> 
> Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> ---
>  arch/arm64/include/asm/tlbflush.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index eba1a98657f1..0d250ef4161c 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -112,8 +112,7 @@ static inline unsigned long get_trans_granule(void)
>  	    level >= 0 && level <= 3) {					\
>  		u64 ttl = level & 3;					\
>  		ttl |= get_trans_granule() << 2;			\
> -		arg &= ~TLBI_TTL_MASK;					\
> -		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);			\
> +		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);			\

This could equally be:
		arg = u64_replace_bits(arg, ttl, TLBI_TTL_MASK);

which already exists, so doesn't require a new macro to be introduced.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
