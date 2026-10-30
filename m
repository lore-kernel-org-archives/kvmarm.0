Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793323597;
	b=XgHWGgDPOQen6n9OiYPzklgijablqXrc5XRYONrlmkI1X74K954KUu6fq57kn306U2CZ
	 ZiuNuvV/pgHBiDsI+kDpwSDsWlnzfYRwv9TkjvBn9Z7NsOVIrh18Soj/R4G4QyEcziYrv
	 r4gw9FjJc6vagf4L5dotoz1QPFlNbvO/YPVIzRs5eRHY6Y7JJNfJTS0cOG6pFgwGiV3sk
	 I6BQfoEE3Zkn088gHBvawpzlAe4u5fFw+EKw29Le/z0DQp47HsxGnObIlPYCY9v6gDh2m
	 iy5yPjgdFzTSsFV8hKQdJhdjEudTPiZUzLtL5a39qRmMDMGFZBWxNegpwLyB7/tetLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793323597;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=OJ+RA1MFN/tYwZT96jfvwbSkbkM4XrViFYe+9mXpmMQ=;
	b=sKKz6QbnvYU4SSHzKWdYWG9GHIxIMzlqtY2WwiyOqkT2z9beb/M/O4rrj5x7+iCeLyVP
	 96ZHdPxpTY+MdZOCf3KypL5Nn+tQVsF7tPOKTe0B2Pq89OXIAxgXnTjmI056VtzYNfk2U
	 U0+NYaoshmlGXwABGseEIK2ibkTI0qDCSkHQPA3yjJDNHBTqaB7R0xq7HxI08wFMS8X2D
	 6aEXsyKSDK2a/PDP5CiJhLg/PQUs4pZqJXZbPDnHg0BqNGfenb9iyO39Hq33/QwS2Czbr
	 K9nCLQsXjKjfIrWskAgVSfkwFUtzMUMdP9hgnaL0C4Lkf6QUVzMx2oD5FmRHHiiBEiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=U9IVcFYg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F044A606A31A
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 01:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F044A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=U9IVcFYg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C57901FC7;
	Thu, 29 Oct 2026 18:26:32 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 042B93F7B4;
	Thu, 29 Oct 2026 18:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793323595; bh=c3dCfOq5rdlhpaAn51I6eyxK5FRsCMeQ5FIKY6g7Mi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U9IVcFYgthdvT8M3/QbvAyyJ60gx3RhNU3kZbb9RFhGtTw8SZJiqMH8TIMQoqrHGE
	 hkh4gOQJ/caOfqQeVJ8Pi1jnwV8WKIq6d/q2dHuOpfC3/+e96fO40SgH/xHSk4+sNm
	 nC7tXfmxpdqBXfgTO1N2y7zr39ZvJClr8JI83HZc=
Date: Fri, 30 Oct 2026 01:26:27 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v3 4/5] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <xtnzg5xaw4lbya7br36nyxrfp2p3yvmbk74gesnp6jugsgrpzv@bk26zmsdjsrl>
References: <20261029223732.103785-1-oupton@kernel.org>
 <20261029223732.103785-5-oupton@kernel.org>
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
In-Reply-To: <20261029223732.103785-5-oupton@kernel.org>

Hi Oliver,

I have checked TCR_EL2 information in the latest 2026-09 release,
the only difference is it correctly states TCR_EL2.AS is dependent on
FEAT_ASID16 now, like what Joey said.

On Thu, Oct 29, 2026 at 03:37:31PM -0700, Oliver Upton wrote:
> From: Wei-Lin Chang <weilin.chang@arm.com>
> 
> Feature dependencies of the fields in TCR_EL2 are extracted from
> Registers.json of the BSD licenced AARCHMRS
> (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).

So if you like you can change this to 2026-09,

> 
> Places where we slightly deviate from the above:
> 
>  - Stick to the ARM ARM M.c requirement for TCR_EL2.TCMA*, which only

and change this to M.d,

>    depends on FEAT_MTE2. This avoids updating ID_AA64PFR2_EL1 with new
>    VMTE* definitions that we don't know the meaning of, as they aren't
>    present in the ARM ARM yet.
> 
>  - Ignore TCR_EL2.DS's requirement of needing the effective value of
>    TCR2_EL2.D128 be 0. This requires runtime detection of TCR2_EL2.D128
>    and we don't have D128 support yet.
> 
>  - TCR_EL2.AS is dependent on FEAT_ASID16, this information is missing
>    from the json.

and remove this item.

Not that these stay up to date for long though, but just thought I'd
point them out.

Thanks,
Wei-Lin Chang

> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---

[...]
