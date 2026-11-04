Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809774;
	b=hK1YLFT5ZBF29FPW1Ke6I/4Cxj4Et9yObscNv/oKgvgMc0RTGn0rXIbCxaUrRPYcIrIp
	 cBntIiFVtHWuuHlHGlqvntIXcojJO8XebAd40O1KqdeEqvvhqvnDonROomLCBzzUOHnsj
	 +MZ9wrb60PlT+Gy34rJwYbK7hEZ+fiWEsNUcT+DtDorWPwpCVlJvCngBdnNeDozZ3B/Z2
	 t3xVBnfWme/2VosXc0pjBUEhsqHgVE0ZpViS0ndxzW9phczbxx5MWORNHTkYcuuBGwURc
	 5K4XzG8Zn3xfpwGcdUND2UPUk/9jcAx1zh9Qli9mqByLQMUVyB8wYtvgZdSqc285JlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809774;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Tc6smF+Vh/7CE2W9Q/F22hD5NIH3zyct+Y2aCzOC+DA=;
	b=xOi5Gvw4gWTlVrD+0jClLPscLtgrzGFrlO0LOkHwP60mPXQci0dw5pR+YUszolet1s8J
	 WeF5NvgZLxKRjFHOfVbtwZatkh3HKKLl4UOCQ01OKgTom39CpspZ+KDxHYMmFHJ7d7COD
	 m2dDM/l9y6ZGCvx0gepDfszpj7/1i38e/OkNkdfXXIUL+Iiqq5gGaqrt3764H4empTCpi
	 WuVc08wNe1nK1eIrkmShopYR8BdVgXryoMA7U+2BQjL/cHXuQSIM7Hs1LpPZcKckp8bq/
	 395UnapLDRCNrGZgE9lCvt1kUxhb9cw8YdqBOOwn+I31DbxOhlU/kFaHY2re23TCcRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=U2a4Njyg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E757606A32D;
	Wed,  4 Nov 2026 16:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E757606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=U2a4Njyg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB3A5169C;
	Wed,  4 Nov 2026 08:29:29 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81C573F632;
	Wed,  4 Nov 2026 08:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793809772; bh=ydxgtyBO23MN1U/TWCJdx3UsLKm/E3RiNWlRo8QZ6KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U2a4Njyg1d4kBYH6XRCD/4nFi8EGVsAiy1I04x+liwPLk0pEpt9bibEPLsXaoB/yi
	 4nmRDin7U5A1xAVGyj7UxPTcXv/GtfdroRU+DW/DsiqXVajn7MYTHNZXWuFipL+JaM
	 WO8nG2dhgkauSdKkPH7PF4jORybqs1tD87KXTzUM=
Date: Wed, 4 Nov 2026 16:29:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: michael.reeves077@gmail.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Myria Sarvay <myrialsarvay@gmail.com>,
	Yureka Lilian <yureka@cyberchaos.dev>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Sven Peter <sven@kernel.org>, Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>, asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arm64: Add CPU part numbers for newer Apple
 Silicon CPUs
Message-ID: <autdZ07WVQ0MMR3A@arm.com>
References: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
 <20261021-apple-m3-m4-kvm-v2-1-04905152cc2a@gmail.com>
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
In-Reply-To: <20261021-apple-m3-m4-kvm-v2-1-04905152cc2a@gmail.com>

On Wed, Oct 21, 2026 at 10:53:20AM +1100, Michael Reeves via B4 Relay wrote:
> From: Myria Sarvay <myrialsarvay@gmail.com>
> 
> Add CPU part numbers and MIDR definitions for M3, M3 Pro, M3 Max,
> base M4, A18 Pro and M5 Pro so CPU workarounds can identify these cores.
> 
> Use the SoC codenames for M4, A18 Pro and M5 Pro, with suffixes for
> their core types, as separate core codenames are not known.
> 
> Signed-off-by: Myria Sarvay <myrialsarvay@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
