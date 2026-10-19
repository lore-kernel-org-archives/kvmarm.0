Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8365A3EDAB8
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401887; cv=none; b=KscAuiWSybig8LWEj3V2ab//O6TYuM2VLysiwgXl0CgH4qrChCjSZ9gQDu3ms85wc7Dqqnr0ZRDO8hxfDNwsacnsatjEm0UUxw4Ofej/pptwF70bnGVJp3cXCMuLv2upiftOzWjjj0tooKbVthI3N1Vv+ogntxCH1VPRIDAJOMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401887; c=relaxed/simple;
	bh=ukRusOcMMasuUt/MwOWYxonH6KR48F/Wx4D6Fv9GpqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TzLHpH5u3iTxiVwQrNEtYrlU6YOjWSTj3+51+Hb+ziVpGUuyZtogvlPgPGqNA3GY12kBx3AlejMhFXv/zEhO4LQHNiN3Ofk3UtMkSkVwEa5yQvDKNuBc41Q7rQiQDOfP6t5U0w/g0XZybXsrPwY1i6veykcOuHfD26qHex9/AXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BNYAY1Jc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BNYAY1Jc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A76FB1477;
	Mon, 19 Oct 2026 02:24:42 -0700 (PDT)
Received: from [10.0.152.204] (e121487-lin.cambridge.arm.com [10.0.152.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E63C3F7D8;
	Mon, 19 Oct 2026 02:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792401885; bh=ukRusOcMMasuUt/MwOWYxonH6KR48F/Wx4D6Fv9GpqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BNYAY1Jck3zw8ScybT4oeFNCrm8ZFnrIKBEZ5Yjn7b5T4cHBmLUh6Z4fE6I+Nx1kL
	 tbrcuafotMI669u48d7cHis7Qtrnhf7p1S0P5RFnB6FObocI8x3QSomHrNCyd/ai1Q
	 SBZf82AH2Hg8g+tQ/6yrtfx2l4wqhTnwCzJ9z2Aw=
Message-ID: <c8970dbe-2d37-49b3-b62d-f60d7cd6cec6@arm.com>
Date: Mon, 19 Oct 2026 10:24:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
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
 <20261016-monaka-fix-for-upstream-v2-3-fc7ede7f9f48@fujitsu.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-3-fc7ede7f9f48@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 10/16/26 11:00, Tomohiro Misono wrote:
> +#ifdef CONFIG_FUJITSU_ERRATUM_030002
> +	{
> +		.desc = "FUJITSU-MONAKA Erratum E#030002",
> +		.capability = ARM64_WORKAROUND_FUJITSU_030002,
> +		ERRATA_MIDR_RANGE_LIST(((const struct midr_range[]) {
> +					MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
> +					{}
> +				})),
> +	},

Similarly to my other comment, that can be simplified to

+               ERRATA_MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),

Cheers
Vladimir
