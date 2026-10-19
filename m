Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8E84AD7E3
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 09:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401799; cv=none; b=lbKhxYx+kQWRhqdJk1lDXQVXdWnvl2vNb5mxoLUKW1gbrR6AM3ks5Ub71dTe8G0xFqtgMFVHBYRFTepb08SgerRvWpUoG3h2kv2aCclG5dqrH1kZlSZ6/BsqvPgoh9hhBxYRky+DGdNJVpGreZr79cEWH4C0byQLXrnTd0Z1XGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401799; c=relaxed/simple;
	bh=9PebdIH/SVuVj9MRbPB/1J1o0shLFs/Jpdx34TKGXEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jlr1noSM+lth8ejndvjbJhoWVKCbxmdlCsDLhzY/dkHLRwbtppXnYzw/mprQ+bQDv3S3bKoF12Fav0MNiA4JB4JlvrADn5jHhuLMtpTKyV1++UihNuquiYAMqscrsLkcn4Bk2fDg5RlxXBXHzeOAdKihImvoxtCwo+efGhTCSTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C+Y1yTco; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C+Y1yTco"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB0351477;
	Mon, 19 Oct 2026 02:23:12 -0700 (PDT)
Received: from [10.0.152.204] (e121487-lin.cambridge.arm.com [10.0.152.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BF463F7D8;
	Mon, 19 Oct 2026 02:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792401796; bh=9PebdIH/SVuVj9MRbPB/1J1o0shLFs/Jpdx34TKGXEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C+Y1yTcoKKTeRGxeqTyg1bb//zBo/34B94yQoPCY8Z3TFTWlPLYAqR+kfzFP/WUTg
	 wcMt2ARDZEf2af+mvA9gjVQuj5IIGdx+Cvs/7LSXLhe70k4TcVAJprfzM2ozRDBJKM
	 AD6JEGRA9yLKmyScnBGv/fMHzUKKr7+ir8KeI1Cc=
Message-ID: <494fd8b9-b7cc-43ef-af0a-218c6afe0fed@arm.com>
Date: Mon, 19 Oct 2026 10:23:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA
 Erratum E#030001
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 10/16/26 11:00, Tomohiro Misono wrote:
> +#ifdef CONFIG_FUJITSU_ERRATUM_030001
> +	{
> +		.desc = "FUJITSU-MONAKA Erratum E#030001",
> +		.capability = ARM64_WORKAROUND_FUJITSU_030001,
> +		ERRATA_MIDR_RANGE_LIST(((const struct midr_range[]) {
> +					MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
> +					{}
> +				})),
I reckon that can be simplified to

+	ERRATA_MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),

Cheers
Vladimir


