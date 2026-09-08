Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015BB5111A2;
	Tue,  8 Sep 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863854; cv=none; b=tz4EKKLxmc0+e5Ae2bXps3TW3zWb1wXdwhfxn9I0sAy+L1zocT8TyGb+xVL4AMej0kDV3rq5btTq1eUarddnYk2f8qugixpgX3gdUQn8EAvIAc7/pacjnCg3EBNx0h6QSnJau00Vs7mYUf0SZnoWEvFxfm7M9+/EC/8m+hrpGJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863854; c=relaxed/simple;
	bh=mPR/5rdwTgC9l9WCRpx7dI5u8fBM4ZE1OdWDZMyT26E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqfAvNKfhRYgSJU+5jVr0sEDg2/N53a/Cp8xlev0eZrYdleI84E6XEdTnfssq6UIkJOinVIUTvVE4M68zVzowY60MQmDY3fTfcNbMBEnOQYVBb5ClULO8MYSbXfOllhYQeFX9wC4zj2rAK9iicAVA5ZuHLZ7yq/uU5fJ9BxqHXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UegS7oEa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UegS7oEa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61CFB1476;
	Tue,  8 Sep 2026 03:37:27 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 765AA3F528;
	Tue,  8 Sep 2026 03:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788863851; bh=mPR/5rdwTgC9l9WCRpx7dI5u8fBM4ZE1OdWDZMyT26E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UegS7oEaa/SoCeqvarZ1I1F0T0OKVgqAcIvO1bQVSb4yVTpBhu4oVNhrpZxE2xOIX
	 Lngo42gCXiGmJpTEYAwAlBjjA4WV+jHmgjFNjq+FslZQ1Foy8RQVS5UMo2fZySHa5p
	 ImHPR4dRWJnxEdoWXrYJ4TimuA1qU+ElkANdafUk=
Message-ID: <aca629b2-27a0-4c47-acac-87edb3b0d3d9@arm.com>
Date: Tue, 8 Sep 2026 11:37:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-2-suzuki.poulose@arm.com>
 <c9990440-acab-4c6c-b67f-8bde17feddce@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <c9990440-acab-4c6c-b67f-8bde17feddce@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/09/2026 07:19, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by SMC calls from the host.
>>
>> The SMC definitions are based on DEN0137[1] version 2.0-bet3
>>
>> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

...

>> ---
>>   include/linux/arm-smccc-rmi.h | 494 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 494 insertions(+)
>>   create mode 100644 include/linux/arm-smccc-rmi.h
>>
> 
> Some nitpicks below, please pick up the commits that look reasonable :)
> 


>> +
>> +#define RMI_RETURN_STATUS_MASK        (0xFFUL)
>> +#define RMI_RETURN_INDEX_MASK        (0xFFUL << 8)
>> +#define RMI_RETURN_MEMREQ_MASK        (0x3UL << 8)
>> +#define RMI_RETURN_CAN_CANCEL_MASK    (0x1UL << 10)
>> +
>> +#define RMI_RETURN_STATUS(ret)        
>> FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
>> +#define RMI_RETURN_INDEX(ret)        FIELD_GET(RMI_RETURN_INDEX_MASK, 
>> ret)
>> +#define RMI_RETURN_MEMREQ(ret)        
>> FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
>> +#define RMI_RETURN_CAN_CANCEL(ret)    
>> FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)
>> +
> 
> If I'm correct enough, RMI_RETURN_{STATUS, INDEX, MEMREQ, CAN_CANEL} 
> _MASK are used
> for once in this header file. So we needn't explicitly expose them and 
> combine their
> definitions with users to fetch the corresponding fields, as below.
> 
> #define RMI_RETURN_STATUS(ret)        FIELD_GET(GENMASK(7, 0), ret)
> #define RMI_RETURN_INDEX(ret)        FIELD_GET(GENMASK(15, 8), ret)
> #define RMI_RETURN_MEMREQ(ret)        FIELD_GET(GENMASK(10, 8), ret)
> #define RMI_RETURN_CAN_CANCEL(ret)    FIELD_GEt(GENMASK(10, 10), ret)

I belive the header files were generated from a tool (by Steven) and
these would make it easier to compare with the generated header file for
any deviation from the spec. So, I am a bit reluctant make these
changes.

That said, I am happy to convert the mask definitions to GENMASK() for
consistency and readability. i.e., something like:

diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
index 3eb88caf40964..078197284415e 100644
--- a/include/linux/arm-smccc-rmi.h
+++ b/include/linux/arm-smccc-rmi.h
@@ -139,10 +139,10 @@
  #define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
  #define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))

-#define RMI_RETURN_STATUS_MASK         (0xFFUL)
-#define RMI_RETURN_INDEX_MASK          (0xFFUL << 8)
-#define RMI_RETURN_MEMREQ_MASK         (0x3UL << 8)
-#define RMI_RETURN_CAN_CANCEL_MASK     (0x1UL << 10)
+#define RMI_RETURN_STATUS_MASK         GENMASK(7, 0)
+#define RMI_RETURN_INDEX_MASK          GENMASK(15, 8)
+#define RMI_RETURN_MEMREQ_MASK         GENMASK(10, 8)
+#define RMI_RETURN_CAN_CANCEL_MASK     BIT(10)


> 
>> +#define RMI_SUCCESS            0
>> +#define RMI_ERROR_INPUT            1
>> +#define RMI_ERROR_REALM            2
>> +#define RMI_ERROR_REC            3
>> +#define RMI_ERROR_RTT            4
>> +#define RMI_ERROR_NOT_SUPPORTED        5
>> +#define RMI_ERROR_DEVICE        6
>> +#define RMI_ERROR_RTT_AUX        7
>> +#define RMI_ERROR_PSMMU_ST        8
>> +#define RMI_ERROR_DPT            9
>> +#define RMI_BUSY            10
>> +#define RMI_ERROR_GLOBAL        11
>> +#define RMI_ERROR_TRACKING        12
>> +#define RMI_INCOMPLETE            13
>> +#define RMI_BLOCKED            14
>> +#define RMI_ERROR_GPT            15
>> +#define RMI_ERROR_GRANULE        16
>> +
>> +#define RMI_CONTINUE_KEEP_GOING        0
>> +#define RMI_CONTINUE_STOP        1
>> +
>> +#define RMI_OP_MEM_REQ_NONE        0
>> +#define RMI_OP_MEM_REQ_DONATE        1
>> +#define RMI_OP_MEM_REQ_RECLAIM        2
>> +
>> +#define RMI_DONATE_SIZE_MASK        3UL
>> +#define RMI_DONATE_COUNT_MASK        GENMASK(15, 2)
>> +#define RMI_DONATE_CONTIG_MASK        BIT(16)
>> +#define RMI_DONATE_STATE_MASK        GENMASK(18, 17)
>> +
>> +#define RMI_DONATE_SIZE(req)        FIELD_GET(RMI_DONATE_SIZE_MASK, req)
>> +#define RMI_DONATE_COUNT(req)        FIELD_GET(RMI_DONATE_COUNT_MASK, 
>> req)
>> +#define RMI_DONATE_CONTIG(req)        
>> FIELD_GET(RMI_DONATE_CONTIG_MASK, req)
>> +#define RMI_DONATE_STATE(req)        FIELD_GET(RMI_DONATE_STATE_MASK, 
>> req)
>> +
> 
> As above, RMI_DONATE_{SIZE, COUNT, CONTIG, STATE}_MASK are used for once 
> in this
> header file. So their definitions can be dropped by modifying the 
> followup macros,
> as below. Some enhancements are also applicable: (a) Use 'BLOCK' to 
> indicate the
> unit encoded in the request. (b) The macros are put into order from MSB 
> to LSB.
> 
> #define RMI_DONATE_STATE(req)        FIELD_GET(GENMASK(18, 17), req)
> #define RMI_DONATE_CONTIG(req)        FIELD_GET(GENMASK(16, 16), req)
> #define RMI_DONATE_BLOCK_COUNT(req)    FIELD_GET(GENMASK(15, 2), req)
> #define RMI_DONATE_BLOCK_SIZE(req)    FIELD_GET(GENMASK(1, 0), req)

Same as above.

> 
>> +#define RMI_OP_MEM_DELEGATED        0
>> +#define RMI_OP_MEM_UNDELEGATED        1
>> +#define RMI_OP_MEM_CONDITIONAL        2
>> +
> 
> B4.6.40 RmiOpMemContig type is missed here and they should be used in 
> the c code.
> 
> #define RMI_OP_MEM_NON_CONTIG    0
> #define RMI_OP_MEM_CONTIG    1
> 
> In the c code, we shall have:
> 
> if (RMI_DONATE_CONTIG(req) == RMI_OP_MEM_CONTIG)) {
>     ...
> } else {
>     ...
> }
> 

Does it make much sense though ? I prefer

if (RMI_DONATE_CONTIG(req))

to


if (RMI_DONATE_CONTIG(req) == RMI_OP_MEM_CONTIG)) {


than having a field for a single bit values. I am happy to change
this if there is strong preference to the other.


> Similarly, B4.6.39 RmiOpCanCancel type is missed here and they should be 
> used in
> the c code.
> 
> #define RMI_OP_CANNOT_CANCEL    0
> #define RMI_OP_CAN_CANCEL    1
> 
> In the c code, we shall have:
> 
> if (RMI_RETURN_CAN_CANCEL(ret) == RMI_OP_CAN_CANCEL) {
>      ...
> } else {
>      ...
> }
> 

Same as above.

>> +#define RMI_ADDR_TYPE_NONE        0
>> +#define RMI_ADDR_TYPE_SINGLE        1
>> +#define RMI_ADDR_TYPE_LIST        2
>> +
>> +#define RMI_ADDR_RANGE_SIZE_MASK    GENMASK(1, 0)
>> +#define RMI_ADDR_RANGE_COUNT_MASK    GENMASK(PAGE_SHIFT - 1, 2)
>> +#define RMI_ADDR_RANGE_ADDR_MASK    (PAGE_MASK & GENMASK(51, 0))
>> +#define RMI_ADDR_RANGE_STATE_MASK    GENMASK(63, 62)
>> +
>> +#define RMI_ADDR_RANGE_SIZE(ar)        
>> (FIELD_GET(RMI_ADDR_RANGE_SIZE_MASK, \
>> +                           (ar)))
>> +#define RMI_ADDR_RANGE_COUNT(ar)    
>> (FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, \
>> +                           (ar)))
>> +#define RMI_ADDR_RANGE_ADDR(ar)        ((ar) & RMI_ADDR_RANGE_ADDR_MASK)
>> +#define RMI_ADDR_RANGE_STATE(ar)    
>> (FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, \
>> +                           (ar)))
>> +
> 
> I guess it wouldn't a bad idea to explictly indicate 'BLOCK' in the 
> definitions, as
> below. Some improvements are applicated either: (a) 'ar' is renamed to 
> 'r'; (b) The
> excessive parentheses are dropped to follow the patterns we already had; 
> (c) For
> RMI_ADDR_RANGE_ADDR(r), FIELD_GET() is used.
> 
> #define RMI_ADDR_RANGE_BLOCK_SIZE_MASK        GENMASK(1, 0)
> #define RMI_ADDR_RANGE_BLOCK_COUNT_MASK        GENMASK(PAGE_SHIFT - 1, 2)
> #define RMI_ADDR_RANGE_ADDR_MASK        (PAGE_MASK & GENMASK(51, 0))
> #define RMI_ADDR_RANGE_STATE_MASK        GENMASK(63, 62)
> 
> #define RMI_ADDR_RANGE_BLOCK_SIZE(r)        
> FIELD_GET(RMI_ADDR_RANGE_SIZE_MASK, r)
> #define RMI_ADDR_RANGE_BLOCK_COUNT(r)        
> FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, r)
> #define RMI_ADDR_RANGE_ADDR(r)                
> FIELD_GET(RMI_ADDR_RANGE_ADDR_MASK, r)
> #define RMI_ADDR_RANGE_STATE(r)                
> FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, r)

Ack

> 
>> +enum rmi_ripas {
>> +    RMI_EMPTY = 0,
>> +    RMI_RAM = 1,
>> +    RMI_DESTROYED = 2,
>> +    RMI_DEV = 3,
>> +};

>> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB    BIT(0)
>> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB    BIT(1)
>> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB    BIT(2)
>> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_256    BIT(3)
>> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_384    BIT(4)
>> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_512    BIT(5)
>> +#define RMI_FEATURE_REGISTER_1_MAX_RECS_ORDER    GENMASK(9, 6)
>> +#define RMI_FEATURE_REGISTER_1_L0GPTSZ        GENMASK(13, 10)
>> +#define RMI_FEATURE_REGISTER_1_PPS        GENMASK(16, 14)
>> +
>> +#define RMI_FEATURE_REGISTER_2_DA        BIT(0)
>> +#define RMI_FEATURE_REGISTER_2_DA_COH        BIT(1)
>> +#define RMI_FEATURE_REGISTER_2_VSMMU        BIT(2)
>> +#define RMI_FEATURE_REGISTER_2_ATS        BIT(3)
>> +#define RMI_FEATURE_REGISTER_2_PDEV_MAX_VDEVS_ORDER    GENMASK(7, 4)
>> +#define RMI_FEATURE_REGISTER_2_VDEV_KROU    BIT(8)
>> +#define RMI_FEATURE_REGISTER_2_NON_TEE_STREAM    BIT(9)
>> +#define RMI_FEATURE_REGISTER_2_REALM_MAX_VDEVS_ORDER    GENMASK(14, 10)
>> +
>> +#define RMI_FEATURE_REGISTER_3_MAX_NUM_AUX_PLANES    GENMASK(3, 0)
>> +#define RMI_FEATURE_REGISTER_3_RTT_PLANE        GENMASK(5, 4)
>> +#define RMI_FEATURE_REGISTER_3_RTT_S2AP_INDIRECT    BIT(6)
>> +
>> +#define RMI_FEATURE_REGISTER_4_MEC_COUNT        GENMASK(63, 0)
>> +
> 
> We would reorder those feature register definitions from MSB ro LSB :-)

Ack

Thanks for your review.

Cheers
Suzuki

