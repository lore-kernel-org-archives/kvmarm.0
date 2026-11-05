Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793891549;
	b=c/gebTI8YHt7AAfD7Krne4rbEZZQl+h20poMC8yCGVK2TeDF99vdeRqTZ6UNwSvwZfzf
	 seFm1uzIgX0TBu6QTrI4DmsXu4cuFMe4BHPRaan5hOuHB9UGi2TH3N0+U5RJnGEhHYHQb
	 +gxXcW5nvveo2LdPL3FDovu1I0uCl8m46iGFV7UTSj7FSjhQxIZux3RPlOwH3fYexg0t2
	 UrbK88Hn5SpXKa+DneLq0PZCByw0+KA9CASsaLi9eQhSYtTF+XJ/Ny0M4SHc8l4aHJfwR
	 iVzWj9Dsrx0Tc2FYU4HWTOaUFtiL11xxj0FDzY1rQU52iZWbYP6YiV0BachAkZq1cBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891549;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=IWJD0iHItHJ0ZLICudpIGPh2lKAzMkhjEJ2bZxXwT1g=;
	b=WqBZWMg0uwUnXETg9weHwwbejQWuzh3rFz29O5X4Bu2uLCkVPgInYIbGNZBZ8x55A4L7
	 tLbQJqWJlZ+gxV4+PsrBl0cdBX6/K1D0VsPCznbcL7HA85nYxe4/DcDm6Qr3QNEtq9V4d
	 4MvPc5so0lJEDbjx97o0WbZOY1fXCndq+n6yw8E8tXWi2eGGe49j4eJ/V/B1FMEqu0K4B
	 lElzP93idWwpUJ/D+oXxBA862PEbBp3MU8rRm/97NOBF/pipVbYLrJsHhiwlLgu9KPLef
	 SkFtVCVtnavlHxpjgqPb2BDuo3QuodOk8AEgfi3JZa4QMIHOEgdsp30XD0UJ9exaIaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=I9yJWYMO;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678DA606D821;
	Thu,  5 Nov 2026 15:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 678DA606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=I9yJWYMO
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E02B16F2;
	Thu,  5 Nov 2026 07:12:24 -0800 (PST)
Received: from [10.0.128.250] (e122027.cambridge.arm.com [10.0.128.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D24EC3F628;
	Thu,  5 Nov 2026 07:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793891547; bh=K05vKtM+fPDTzjogjywixfTKzhfzKJwvrbfn/flAQKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I9yJWYMOEfAXqlqdwyFVq2M5GIwutk5K6psqq9Cpc7QM5j08Mcw18ktYr7AnqST3/
	 GjFIAmD16GvgTjVNYKV0YLBzFCCAvPxZyKsBXJAoSEfd1Vp0+12u1UwKcGhCWb1cWp
	 eDOuw2QPcrF8XLvPwDKHxwX3Bkyl6a8Ir0NoK4TQ=
Message-ID: <e57e8cd0-79eb-4073-87ea-5b0c27122b71@arm.com>
Date: Thu, 5 Nov 2026 15:12:23 +0000
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
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-5-steven.price@arm.com>
 <f2cb2959-f56d-414c-b4a5-c0656a44f57d@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <f2cb2959-f56d-414c-b4a5-c0656a44f57d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/11/2026 11:47, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 02/11/2026 14:12, Steven Price wrote:
>> If KVM has enabled LPA2 support then check that the RMM also supports
>> it. If there is a mismatch then disable support for realm guests as the
>> VMM may attempt to create a guest which is incompatible with the RMM.
>>
>> Also check for SHA-256 support in the RMM as to begin with we only
>> support SHA-256 based measurements. This can be relaxed in the future.
> 
> 
> This could be merged with the patch 3.

Makes sense.

> 
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> 
>> ---
>>   arch/arm64/kvm/rmi.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 9d118768550d..5b07beff8bc9 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -6,8 +6,30 @@
>>   #include <linux/arm-rmi-cmds.h>
>>   #include <linux/kvm_host.h>
>>   +#include <asm/kvm_pgtable.h>
>>   #include <asm/virt.h>
>>   +static bool rmi_has_feature(int reg, unsigned long feature)
>> +{
>> +    return !!u64_get_bits(rmi_feat_reg(reg), feature);
>> +}
>> +
> 
> minor nit: Do we see this useful for others (e.g., DA) ? May be we could
> move this to the include/linux/arm-rmi-cmds.h ?
> 
> May be we could even make the above a macro, something like
> 
> 
> #define rmi_has_feature(reg, feat)
>     u64_get_bits(rmi_feat_reg(reg), RMI_FEATURE_REGISTER_#reg _#feat)
> 

Sashiko pointed out that my use of u64_get_bits() is problematic. So
I'll fix that up and more it to the header file.

Thanks,
Steve

> 
> Cheers
> Suzuki
> 
>> +static int rmm_check_features(void)
>> +{
>> +    if (kvm_lpa2_is_enabled() &&
>> +        !rmi_has_feature(0, RMI_FEATURE_REGISTER_0_LPA2)) {
>> +        kvm_err("RMM doesn't support LPA2\n");
>> +        return -ENXIO;
>> +    }
>> +
>> +    if (!rmi_has_feature(1, RMI_FEATURE_REGISTER_1_HASH_SHA_256)) {
>> +        kvm_err("RMM doesn't support SHA-256 measurements\n");
>> +        return -ENXIO;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   void kvm_init_rmi(void)
>>   {
>>       if (kvm_get_mode() != KVM_MODE_RMM)
>> @@ -16,5 +38,8 @@ void kvm_init_rmi(void)
>>       if (!is_rmi_available())
>>           return;
>>   +    if (rmm_check_features())
>> +        return;
>> +
>>       /* Future patch will enable static branch kvm_rmi_is_available */
>>   }
> 

