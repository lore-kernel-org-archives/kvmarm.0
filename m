Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA26E3750AC
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777388059; cv=none; b=mxwkPK7Wa7Pt9ltPQfTuz6QQiSmmR2s27VKKlhsudWvEYM8cbPDgqsIGGZhPZ/zSckomiVOhtG2jsRtMvX2eJTvglaXdJD7DuVu/mrf8QsDsQRec9marBr4pY/Hh1Kurv1fzSDsyWXxjElceItlTwPZxJbdz06uhgCEPKx13pIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777388059; c=relaxed/simple;
	bh=5730Ij/YR5Jarz1eBbQXRVC50ATSOObe10t8tR4kZNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghCfrAPYazCTUlKlfxmChDf5crg4s/2plcio3V0AaiBGeBpHZmAo6Z+5Zzyo85gukEvB15kg4eXnS4hydXG9AFGqL+ZZ4n3EKUF9epgos9SLlgTUgJWQtIfvv8TBQi7pBvLbGjOdQRbZut/QuquE9UqCbQGP07FVm7KiizfnY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UkEAh8YT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UkEAh8YT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4C871C0A;
	Tue, 28 Apr 2026 07:54:11 -0700 (PDT)
Received: from [10.1.29.174] (e121487-lin.cambridge.arm.com [10.1.29.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 912963F763;
	Tue, 28 Apr 2026 07:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777388057; bh=5730Ij/YR5Jarz1eBbQXRVC50ATSOObe10t8tR4kZNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UkEAh8YTGV8jNR++BZu5acdMKaPvOa2JtNsHYgQKXU71VEFRH72DB4IT6zv487lTA
	 ZIwDldf22BXP80+6fADk3OoSZrRz4jRmjJ1ybBqC2ALP/zL/uYi/odZqtSr9imPe8U
	 xqt8Vibq1qyQgiXw4owXvEMZR941s0wZeU8Ql8Fw=
Message-ID: <9de41a97-0701-447e-bb28-63796eaa8f60@arm.com>
Date: Tue, 28 Apr 2026 15:54:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/43] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Timothy Hayes <Timothy.Hayes@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
 <20260427160547.3129448-8-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260427160547.3129448-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sascha,

On 4/27/26 17:08, Sascha Bischoff wrote:
> +
> +	if (virt_to_phys(l2_table) & ~GICV5_VMTEL1E_L2_ADDR) {
> +		kfree(l2_table);
> +		return -EINVAL;
> +	}
> +
> +	vmt_info->l2.l2ptrs[l1_index] = l2_table;
> +
> +	/* Alignment issue! */
> +	if (virt_to_phys(l2_table) & ~GICV5_VMTEL1E_L2_ADDR) {
> +		kfree(l2_table);
> +		return -EFAULT;
> +	}
> +
> +	tmp = virt_to_phys(l2_table) & GICV5_VMTEL1E_L2_ADDR;
> +	WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], cpu_to_le64(tmp));

It seems the same l2_table alignment calculated (and checked) multiple times...

Cheers
Vladimir
