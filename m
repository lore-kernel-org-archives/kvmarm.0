Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846BD4A3866;
	Fri, 18 Sep 2026 10:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727992; cv=none; b=ckdfbarQCbNyp4svWI8Syq4Hwes6rhAZaJd3VefnxrQRhJ/j2jz/efeJmwebOA5oECA67b+5MhBgYXs2kSC4fURUeYm0MLi99bWvAlIjQuvyEBWWMtPb533W6nX9mq6jTB30Cz2kMf1cd7JGJimDQzAvQc+H7Sv+VjanXKHVpts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727992; c=relaxed/simple;
	bh=Q3effGCMdhsIowj3+2D3KI8Gvn6WszBpcgNaEbD3C5o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LYzivFUc31n8MJdcxtm7qoFijL3Bd6Nl3MmmDnaLSrinakcWHe3S1Yq0xxM0NioqeqBOBsIHi1dO/dh3JAqOTzY1aQNr99owymtm3gS/ylviUk+55SWUM0gN7jmZrwJpAv2Dm25wNtC/CRkT7HEAwrdYsAIYyKTu5eK/bx0TCiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBcdchVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBcdchVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC7F1F0089C;
	Fri, 18 Sep 2026 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727989;
	bh=l6Kjwu9OSKxioUG7up9HvmTZyOT5q6Qmeq/xm2VHMYM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=hBcdchVYzJfSkDZhhMg2J1WA+1AG5z73Fi/mCSF+R4bC8Q0+wQ6SFnK8li8MQ5Q/w
	 gNODIKxkqE6vg9V+nbab0ZpgdPCSKmiAdiEPIZFHJs8FUf6w+G0E9l2NDWUZXJG3Sv
	 WanFtejBRsZus0xR+KPUrKcV9zMcNJlG03TmUcH5uvbP7FFfwMzcbzh9uKquWSWhyE
	 7Lp1OCdyAEYUHz20gYOkBvITSgGOpPC0lkc5fsCfaDUaT79jSKdanNfBUoU1Bikat+
	 MXTbtjjSR3HHbSG/gSP7S10xTM/AxEtPrr+0W8SOdUKuV6dQGyEExsIZWjeDQ3hYC2
	 WhOQpiXnNZH/A==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 8/9] arm64: realm: Add RHI helper to query IPA state
 change alignment
In-Reply-To: <73c921bb-9897-481d-bcb2-ef9b578a7c9f@arm.com>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
 <20260904103452.1197239-9-aneesh.kumar@kernel.org>
 <73c921bb-9897-481d-bcb2-ef9b578a7c9f@arm.com>
Date: Fri, 18 Sep 2026 16:09:42 +0530
Message-ID: <yq5awlsizvv5.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 04/09/2026 11:34, Aneesh Kumar K.V (Arm) wrote:
>> Arm CCA guests need to know the granularity at which the host expects IPA
>> state changes to be performed. This can be larger than the guest page size
>> and is needed when deciding the alignment for memory shared with the host.
>> 
>> Add the Realm Host Interface host configuration definitions and an
>> get_ipa_state_change_alignment() helper. The helper uses RSI_HOST_CALL to
>> query the supported HostConf version and features, reads the IPA change
>> alignment when available, and falls back to PAGE_SIZE if the interface is
>> unavailable or returns an invalid value.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>
> It may be worth mentioning the document number and may be the link
> for RHI spec.
>
> e.g., The Realm Host Interface specification Arm DEN00148 defines ...
>
>
>
>> ---
>>   drivers/firmware/arm_rmm/rsi.c | 46 ++++++++++++++++++++++++++++++++++
>>   include/linux/arm-rsi-cmds.h   | 10 ++++++++
>>   include/linux/arm-smccc-rhi.h  | 25 ++++++++++++++++++
>>   include/linux/arm-smccc-rsi.h  |  7 ++++++
>>   4 files changed, 88 insertions(+)
>>   create mode 100644 include/linux/arm-smccc-rhi.h
>> 
>> diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
>> index 52f40256bd78..2cd53f82432f 100644
>> --- a/drivers/firmware/arm_rmm/rsi.c
>> +++ b/drivers/firmware/arm_rmm/rsi.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/swiotlb.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/arm-rsi-cmds.h>
>> +#include <linux/arm-smccc-rhi.h>
>>   #include <linux/kobject.h>
>>   #include <linux/sysfs.h>
>>   
>> @@ -164,6 +165,51 @@ static int realm_register_memory_enc_ops(void)
>>   	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
>>   }
>>   
>> +/* we need an aligned struct for rsi_host_call. slab is not yet ready */
>> +static struct rsi_host_call hostconf_call __initdata;
>> +static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
>> +{
>> +	long ret;
>> +	unsigned long shared_granule_size;
>> +
>> +	hostconf_call.imm = 0;
>> +	hostconf_call.gprs[0] = RHI_HOSTCONF_VERSION;
>
> Do we need to 0 out the other GPRs for RES0 arguments ?
>
>> +	ret = rsi_host_call(lm_alias(&hostconf_call));
>> +	if (ret != RSI_SUCCESS)
>> +		goto err_out;
>> +
>> +	if (hostconf_call.gprs[0] != RHI_HOSTCONF_VER_1_0)
>> +		goto err_out;
>> +
>> +	hostconf_call.imm = 0;
>> +	hostconf_call.gprs[0] = RHI_HOSTCONF_FEATURES;
>
> Same here, especially gprs[] could be overwritten by the results from
> the Host for the previous call.
>

 [ ... 75 lines skipped ... ] 

>> +
>> +#define RHI_HOSTCONF_VER_1_0		0x10000
>> +#define RHI_HOSTCONF_VERSION		SMC_RHI_CALL(0x004E)
>> +
>> +#define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)
>
> minor nit: Could this be:
>
> RHI_HOSTCONF_FEATURE_GET_IPA_CHANGE_ALIGNMENT	BIT(0)
>
> to indicate this applies to the RHI_HOSTCONF_FEATURES output ?
>


Will make this change.

-	hostconf_call.imm = 0;
+	memset(&hostconf_call, 0, sizeof(hostconf_call));
 	hostconf_call.gprs[0] = RHI_HOSTCONF_FEATURES;
 	ret = rsi_host_call(lm_alias(&hostconf_call));
 	if (ret != RSI_SUCCESS)
 		goto err_out;
 
-	if (!(hostconf_call.gprs[0] & __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT))
+	if (!(hostconf_call.gprs[0] & RHI_HOSTCONF_FEATURE_GET_IPA_CHANGE_ALIGNMENT))
 		goto err_out;

-aneesh
