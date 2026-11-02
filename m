Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634965;
	b=vKov5eCH32R3+Qh5t+VnRGH7hRm/6ZQTDPOnupMmB+y06pxHC9c4k1ivAqAN6bPt3ZH2
	 XCUEd4WSLy5/UJBh3eTXcrIWt15V9uRXWtDdUx7U90jvJYZyTxIbJHHOfIeOETpt651RR
	 ZEhU8rRFZT31+Ov73Akl+XHJD1TnwaUeelcQeXWkoXgZ5Jr+cUNT9qXkB1Tn3y2SuL2+4
	 S1ZxGaUaX8mk/nidH05tOHukMOpFX9QMDuNhKcBegAilGP/fQFcGRmUDIZEMurioGju6a
	 gjTeWFQB8e86eleUrRdaN+T29o0Mav1CKrHl5E6+iV0XOZ4WCFW7koLMXgLswWteFoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634965;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WOD7jNOguTPM3f0I1EurNaX4vtHpw/z9o1XjLk8dmuM=;
	b=JvbxFPEcvy8tRdBtI2bmSaeTBhACpJfBnK8UDtmXuvNKWYrvMnbR8Ur4Lwqo965Y+Kpc
	 bth1X/bowhMCIUzZDFjvYxTEQ8wB+/ECwcPJ0ziHnkjWikvja2FDM0F95ik+4mfl+qlgY
	 QRTJSU0CYaHJ8lbxTnmH3g8T2sq892FC+q3kj09FpS5XNkeFeLPzo385e7nVBauLNB6ku
	 2jU/n5dympxoEO8v91ZrseEvZkoRWgvYI0ZMf1OM5sJFQv5ZqBcc/iP+XFU55xcY0huQF
	 piJUrHGDIdGJk63Ay608VhdzWFNV6+8MXz3bmer/Xn6PX+DB8wgv4iuYhO/lM7fz2uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="X8w4/AbF";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07546074A46;
	Mon,  2 Nov 2026 15:56:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B07546074A46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=X8w4/AbF
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1C891691;
	Mon,  2 Nov 2026 07:56:00 -0800 (PST)
Received: from [10.57.58.9] (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF8733F673;
	Mon,  2 Nov 2026 07:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793634963; bh=sK8CDXUGmOLbKSZoZedtgP+NgS11nXnsgqrqH7cwaJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X8w4/AbFkMqcI9AjrwJEDpVcy2lynhF/HzWTp314P2oc9qiwkI11BehY2vEXmSTDO
	 bZDiW2thPiKLVRtAaVD9womR1e4wQ8XitrZ6Exs3J+oFAcis8xCy/VALmiC/IO1CoK
	 wRI1OKmieIuLJ3gFQs1NSBC0fz8eD8HNP76WiMA0=
Message-ID: <0bdedddb-a235-48b4-a60b-27f369624732@arm.com>
Date: Mon, 2 Nov 2026 15:56:01 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] KVM: arm64: CCA: Check for LPA2 support and SHA-256
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-5-steven.price@arm.com>
 <sashiko-outbox-193589@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-193589@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2026 14:38, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] KVM: arm64: rmi_has_feature() passes non-constant mask to u64_get_bits()
> --
> 
> commit a9400749495394b73c9cccd919996b48771556fe
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Check for LPA2 support and SHA-256
> 
> This commit adds feature checks during KVM RMI initialization to verify that
> the RMM supports LPA2 when KVM has LPA2 enabled and that the RMM supports
> SHA-256 measurements.
> 
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 9d118768550d6..5b07beff8bc91 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -6,8 +6,30 @@
>>  #include <linux/arm-rmi-cmds.h>
>>  #include <linux/kvm_host.h>
>>  
>> +#include <asm/kvm_pgtable.h>
>>  #include <asm/virt.h>
>>  
>> +static bool rmi_has_feature(int reg, unsigned long feature)
>> +{
>> +	return !!u64_get_bits(rmi_feat_reg(reg), feature);
>> +}
> 
> [Severity: Low]
> Can this fail to build if the compiler decides not to inline
> rmi_has_feature()?
> 
> In include/linux/bitfield-fix-width.h, u64_get_bits() calls
> field_multiplier(field):
> 
> static __always_inline
> u64 field_multiplier(u64 field)
> {
> 	if ((field | (field - 1)) & ((field | (field - 1)) + 1))
> 		__bad_mask();
> 	return field & -field;
> }
> 
> Because rmi_has_feature() is not marked __always_inline, if the compiler does
> not inline it (for example under CONFIG_CC_OPTIMIZE_FOR_SIZE or compiler
> instrumentation), the feature parameter is not a compile-time constant inside
> field_multiplier(), preventing constant folding from eliminating the call to
> __bad_mask().
> 
> Should rmi_has_feature() be marked __always_inline, or use field_get() or a
> direct bitwise test instead?
> 

I'm not sure how likely this was to fail. But there's an even easier way
of writing this function:

       return !!(rmi_feat_reg(reg) & feature);

So lets go with that. I'm not sure why I'd used get_bits here in the
first place.

Steve

