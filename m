Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B48242D60
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 22:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753137827; cv=none; b=nUtz5pYQXe59ADeN2EKtk9DU55jtfIb8LtRCMyU0kLYxkM1nSUMU3zAhSY6UNGF3ox7buidis2HrsE9B7gUSTOFCXOlxW81v78bYPVZ2loajL3v8hxXRcPoS/85sz3jSgSuNITpt6Z36zzqrg1OlMVpQdapqx27pnE9gBSSqpVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753137827; c=relaxed/simple;
	bh=7vCPTSGyCLREhkwADBBcRHlYWjmofVT+oCRCxeLlj8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y5ekhwf6rKnqg0mohCPYEtlbNdurV7JzIlyxQf+oUMVUK64LkNBrWMfF6QF9a8VEANCid5eZMBmC9kpiT0tbdsOv7ONGUZaZQ0SucXhrwx/rXygoflAmT5S7J0J+Nq0V+0nVOTdpFzEiyFj1avKeYtWwIMJtKzlVLJWjanYrVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=EDcRpBpN; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="EDcRpBpN"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e7311e66a8eso3960522276.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 15:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1753137825; x=1753742625; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YDLiz8FMfzrfsb7Xo3AVv+D+VOndCOPqvNkFpYC+ujA=;
        b=EDcRpBpNV7R5aMEn0HlxeBtYRQJwTr3FK3rofFRfKFPnF5CGX05e7G5QVLxtiRkmnJ
         g6izVkOkavRi2OJyxHfsKzbZljFGq6xGSIbfQLuMwnA8pFmXVJGMOb0+OV+vcZqkzoHE
         XE+XOTvaBfZaeHtDvF6ihSWJzHj6Tw0h7ZycXvvEXEt8wSsNBsHo09i5nyr6djVq35En
         IfVpDRWwIYAmhL8UHKEdUINnrtFYgw1dH+algQeHnf00lCF582mQO/uD9V5wX84op932
         b5tMDaQfgoMdBxwWfM9AqnTpXJ36tqbBczrtyguL5DpzAsNhosd9SKBNZ60DbcrdfO2t
         s9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753137825; x=1753742625;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YDLiz8FMfzrfsb7Xo3AVv+D+VOndCOPqvNkFpYC+ujA=;
        b=BchtXAVKej7qDb+gG5yCXaaXdzfzFCfGqSSgd1txLiL2FHvOc9m1ktldE6rCeoqcVd
         aKSPcHD42j/qZB9qBaAfGy533ZA4UQknMnlX1x1tA6ZkqBsBwqSVl1ITfxa6INP+2Fnc
         gcsSgb3rH/HZhuJI7kF0CeJJBei5pmGeVymeD2ODG63ivaDDeCf/BfwnaczRd5MTBs9T
         P+KHWUum1n/zvrwPyZWkiE140cxmvU6Tb/wvAg7wKlPliYQDJsw27pa8o9mSfu4fLqIr
         D4Q9db6Iaxe0OGYnrmURjnrZS7ZwApIW3aSeTVkUt54DuxTi0eQVeRDiQcb6Jda2CiwM
         m6yw==
X-Forwarded-Encrypted: i=1; AJvYcCU8lwio404pKCo1hp/gaSXdO9jP9+tZIN3oQJiU+oBq8vwLlXuosxKDD4yxyVQayvjDxUtegrk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtoWtQxlq0Aky4HpDp/mGIj8Wfs9wQx0dqjsumOXoZKuzGx9Pj
	sZDnuiQ8eXBHlWb+e/r3DTipdOf+nPSXZac2hP5Nty8D56miNHF5BeuA1kFjvttzGHI=
X-Gm-Gg: ASbGncsK3nZvKlMnN4RAanOJgf1WaBILHuwG8fiDktVAzAbHGb5VLlFe2nm/HYU80/2
	bLuVWeBejGnW2M8/Sm7ueVnmm8DpjylwO0HHLULVpdfUGS7vFsWWc84HTGXAlNAK6EZy2BTNHnK
	p0aoD4GdX0i5eao01AyadjWmndCV5UuFIdKIC7t8dOHFE4KC/1bazBkIYSMzT9GLdyfHhNv2+UZ
	t5ipAE+BPGsc1zbeRNQxab8fvLpuPwjMwsg0/09vxJxFrZu/k0MzJlRKOhfNw++QOVB/fog34N9
	/kE0O8xyfN6REQU4cUv+DEKU7O2s5YRkqP2d2ovPBJYvFuadPssR8MGSaBg6elGH8jBUW9lgHi9
	gvvseP0xQy9zTKE7jvfd5/GdPKw==
X-Google-Smtp-Source: AGHT+IEpyRag75hc7wIz2NAkH4ib5Oe2/59jHMeOSeAr7Vhqgp5XGFfjMhc7CtftjhemnWwEjA2myQ==
X-Received: by 2002:a05:6902:2190:b0:e87:bdbe:103b with SMTP id 3f1490d57ef6-e8bc2433f8dmr26729859276.5.1753137824850;
        Mon, 21 Jul 2025 15:43:44 -0700 (PDT)
Received: from [10.10.1.14] ([12.9.190.3])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8d7ce0e246sm2864343276.28.2025.07.21.15.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 15:43:44 -0700 (PDT)
Message-ID: <25ba5929-79c0-40b8-b529-79a37914605d@immunant.com>
Date: Mon, 21 Jul 2025 15:43:42 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/5] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
To: Will Deacon <will@kernel.org>, perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com,
 arve@android.com, ayrton@google.com, qperret@google.com,
 sebastianene@google.com, qwandor@google.com
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-5-995afc3d385e@google.com>
 <aHpRvBO864x1vvqP@willie-the-truck>
Content-Language: en-US
From: Per Larsen <perl@immunant.com>
In-Reply-To: <aHpRvBO864x1vvqP@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/18/25 6:53 AM, Will Deacon wrote:
> On Tue, Jul 01, 2025 at 10:06:38PM +0000, Per Larsen via B4 Relay wrote:
>> From: Per Larsen <perlarsen@google.com>
>>
>> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
>> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
>> uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
>> argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
>> in the host ffa handler.
>>
>> Signed-off-by: Per Larsen <perlarsen@google.com>
>> ---
>>   arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
>>   include/linux/arm_ffa.h       |  2 ++
>>   2 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
>> index 79d834120a3f3d26e17e9170c60012b60c6f5a5e..21225988a9365219ccfd69e8e599d7403b5cdf05 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
>> @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
>>   	case FFA_NOTIFICATION_GET:
>>   	case FFA_NOTIFICATION_INFO_GET:
>>   	/* Optional interfaces added in FF-A 1.2 */
>> -	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> 
> I think that's the only change needed. In fact, maybe just don't add it
> in the earlier patch?
> 
>>   	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
>>   	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
>>   	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
>> @@ -862,6 +861,22 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>>   	hyp_spin_unlock(&host_buffers.lock);
>>   }
>>   
>> +static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
>> +			       struct kvm_cpu_context *ctxt,
>> +			       u64 vm_handle)
>> +{
>> +	DECLARE_REG(u32, endp, ctxt, 1);
>> +
>> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
>> +
>> +	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
>> +		ffa_to_smccc_error(regs, FFA_RET_INVALID_PARAMETERS);
>> +		return;
>> +	}
> 
> Why do we care about checking the src id? We don't check that for
> FFA_MSG_SEND_DIRECT_REQ and I don't think we need to care about it here
> either.
FFA_MSG_SEND_DIRECT_REQ is handled by do_ffa_direct_msg [0] (in the 
android common kernels, I'm not aware of efforts to upstream this).

I patterned the check in do_ffa_direct_msg2 off the checking done in 
do_ffa_direct_msg. I pressume your reasoning is that this check can
never fail since we pass in HOST_FFA_ID in kvm_host_ffa_handler. My
thinking was that we do need to validate the source ID once we start
using this function for requests that come from a guest VM. I could
of course add the check in an android-specific patch, WDYT is best?

Also note that since do_ffa_direct_msg was switched to use SMCCC 1.2, I 
think it can handle both FFA_MSG_SEND_DIRECT_REQ and 
FFA_MSG_SEND_DIRECT_REQ2. If you agree, should we upstream 
do_ffa_direct_msg and use it to handle both of these direct requests?

[0] 
https://cs.android.com/android/kernel/superproject/+/common-android16-6.12:common/arch/arm64/kvm/hyp/nvhe/ffa.c;l=1446

Thanks,
Per



