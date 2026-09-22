Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297B4A260D;
	Tue, 22 Sep 2026 19:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790106482; cv=none; b=q23Y4qC6IgBDQ9L25pRZAFduvwwv3lEuDF0gNHDWG3963KEuOCeol/9ndDXKrz/WjU84hgZ8nrxCli9bYDDEe8h1m+DfAtR3XM2jOX+315Cbs/+cCfK0oG8006Ml2FBP0pIYed577ANvt7oJU8UUT0PRbouEw+bAEK6Ld81wMH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790106482; c=relaxed/simple;
	bh=aHXrgBqHSNdE34bA3mwYpGQGCFLMLwX48HK8ZDiGO5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwMT33o5WSr+uwtOeZ2uGBjjnINh7pJxzk+FZwAg8rNf5QBUbZQ10iFGsih8gwKXAKNDO1BCOFm4FMizZbP54Rj9aJnFO8NxEnhgYWzQc0IDmCfFjZc4ipdWvA9lutmoucd6BAply5EUwH6CYWw29+V+3fOrEXNy7P9neJ6yCqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXxgk9nb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXxgk9nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0315F1F000FF;
	Tue, 22 Sep 2026 19:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790106480;
	bh=U1CJyunyawRyT6NVPV+xNlT8gvGQUIX4y5MepeUtCuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GXxgk9nb3AMRlzRpSB3wYHO6yWArv2HDQ1w2erqc4s7yG9CCe0LvgUwkI9/DaQL6E
	 OImjKa38Cw+4XNbVdMFIB5ULBb4rQiVXc8o7n+wtohOXxVvWoOgD6Aus+nNEBVbKoI
	 jpqmg41TeuGBrerAgcjQXmmPVYUwBil8Wlfz3baU85xvoXdSpC2DumJnMpDJ5G+Hdk
	 4xa8+Rvpi9A58i0a00tuyndk3sug05u1wSWQgecI9tBCgsPARtW2UGiHdOhywVRknB
	 rI3Xcu1Hgpfsf0YSlvuhZWkAXYWI1bYHz99CCftV0DDZnIfgj1CsGH+N/xV0h9sq6d
	 2Iwth7b/DfGAg==
Date: Tue, 22 Sep 2026 12:47:58 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>, James Clark <james.clark@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
Message-ID: <arLbbtuRuOrxlh1Y@kernel.org>
References: <20260922181430.3532371-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922181430.3532371-1-fuad.tabba@linux.dev>

Hi Fuad,

On Tue, Sep 22, 2026 at 07:14:30PM +0100, Fuad Tabba wrote:
> @@ -426,6 +427,11 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMICNTR_EL0
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMICFILTR_EL0
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMUACR_EL1
> +	/* PMZR_EL0 is write-only, so it has no read trap to disable */
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMZR_EL0

We can trim 3 instructions from this by using the read-trap bits as the
starting point for the write-trap bits, like below. It also makes clear
the point that most of our trap bits are symmetrical for read and write.

Thanks,
Oliver

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..6c5d2cc4e6fa 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -418,6 +418,7 @@
 	b.lt	.Lskip_fgt2_\@
 
 	mov	x0, xzr
+	mov	x2, xzr
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
 	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
@@ -426,6 +427,9 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
+
+	/* PMZR_EL0 is write-only, so it has no read trap to disable */
+	orr	x2, x0, #HDFGWTR2_EL2_nPMZR_EL0
 .Lskip_pmuv3p9_\@:
 	/* If SPE is implemented, */
 	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
@@ -439,7 +443,7 @@
 
 .Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
-	msr_s   SYS_HDFGWTR2_EL2, x0
+	msr_s   SYS_HDFGWTR2_EL2, x2
 	msr_s   SYS_HFGRTR2_EL2, xzr
 	msr_s   SYS_HFGWTR2_EL2, xzr
 	msr_s   SYS_HFGITR2_EL2, xzr
