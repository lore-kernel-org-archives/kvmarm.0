Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729294;
	b=nCbf1YPtpOXVkAFxPTBvzGnAQjqjWd5A2jtrV9RVQGUdUxIjv+XLyb7JyJD6AEtYiF6v
	 wedbCeiJKL5pAmGHR+EnAK2YEtu00hBAwrQ4QZmmASrIJSN5qngqiqV1/awGVBn13+L8n
	 TXeJPW4CnsbCDtPy1yU1yYq32mHCVwr4W2VJmnx71J34jOEdi3NHxtKaIlEVSNPuLIMwA
	 BB/BRW21ooIVsGR2AqGoCJSy3rmFDYSbhrFgIMRfZiC/YykJUaWqystPIjxRp4y3NRhaC
	 HZtjQMpRNLpnjbhvz6MlkyHzh+Ad9UH4LPrRxCfJ/qudtwIS3zWXip9eycwalpjR3CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729294;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=CX7KsGRvfMi8sSaFIycRH1gk1nz8kOlyJvWAR6hLDGQ=;
	b=tugtx6u1GMfewrHD6eK1BwGhZKjqHXJlQHiRx1LbtKoLXZZIDv6Xftec3KgI4ZjyH8oh
	 FNBs5oVF32ypSbKgKPizsHdoGrlph3ybEs/fNjG2PZbVlWDkwDb3KTendMpHbW1hgAxFl
	 4LNjBSkbivhRTH1B2NLVXEVLWD9NFSEF8ZHykOMXTWtfbumZYd4jQod1ICrUHTzTLbp8K
	 CMcNGcdCIxDLqTk9kVr8+yeAQ4OcypewDvAx75Zx4bAGdn9rcmW7m7ALMBw4hHqYUFgL8
	 pqdUEphSsSHCyhM1JRtdDTwt6GS97HUzjAcvcEOtHQeoii+ULM74cZt5yQjGF0ypnGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oRvRPA21;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1B0606A330
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 18:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB1B0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oRvRPA21
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17BB01595;
	Tue,  3 Nov 2026 10:08:10 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1E0E3F628;
	Tue,  3 Nov 2026 10:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793729293; bh=eMBQh6Es3Cx6YejfUPOcrZdff/o/zTyZB1GbN6OabuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRvRPA21izd1QR+JpVJV7Gz7W1GzdJ9NQs3onqSVR18r2cfconpjhwoKBTt17sGlB
	 k7PNjWMnK7TZDeYUiSeFUATB465UhU8iMKarv6+Ex8J+Al8AITM56nUTT3+DGz7FkX
	 9eMOAXA9bVXRgPlnH57y93zriiED6KUg++EtwB2k=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 15/28] KVM: arm64: nv: Respect HD when computing translated TCR
Date: Tue,  3 Nov 2026 18:08:09 +0000
Message-ID: <auojCeTzUnG0ljcF@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-16-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-16-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:55:57PM -0700, Oliver Upton wrote:
> In a similar vein to the recent fix for FEAT_HAF, propagate the L1
> hypervisor's setting for HD to the translated TCR_EL1 value, allowing
> FEAT_HAFDBS to be used by an L1 hypervisor in the EL2 translation
> regime.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index d51d011fc68a..11944dfb204c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -30,7 +30,8 @@ static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
>  	       (tcr & TCR_EL2_ORGN0_MASK) |
>  	       (tcr & TCR_EL2_IRGN0_MASK) |
>  	       (tcr & TCR_EL2_T0SZ_MASK) |
> -	       ((tcr & TCR_EL2_HA) ? TCR_HA : 0);
> +	       ((tcr & TCR_EL2_HA) ? TCR_HA : 0) |
> +	       ((tcr & TCR_EL2_HD) ? TCR_HD : 0);
>  }
>  
>  static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
> -- 
> 2.47.3
> 

Same as previous patch, but for dirty-bit management.
LGTM.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
