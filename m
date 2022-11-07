Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530C1C4332F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 18:09:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F159F4B877;
	Mon,  7 Nov 2022 13:09:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YtokXbj+id3n; Mon,  7 Nov 2022 13:09:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD0F74B87B;
	Mon,  7 Nov 2022 13:09:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB5F4B866
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:09:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWIwzKQ0x3D6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 13:09:15 -0500 (EST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 219E34B85E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 13:09:15 -0500 (EST)
Received: by mail-wr1-f51.google.com with SMTP id bs21so17480522wrb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 10:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=uOpqPDyTUSiqcW9AE9ZFTA2+wjqaCyh2aCjJrDKlnbA=;
 b=mdr1STT8vj0QFWGZb2RRYOAyG3zzA5ctn5Ll2oh1jN5x8qIbZ8lIg5mKdBcxOTCOmu
 bhpe6oylW71uAfxcyvBrWzh3aU/CPHIOm7uUe1zYlp3oqZKL+xYdLOUoHGGH0/O/Nt10
 1tX20jYa4kPHhD6ivBX7xK38FuWE3g0ETVfJ87Mu9wQfDsnl3AognWL4fxNL8jDH197K
 M5k/J+xmwkq7g0msatKv59uOl6d9TbVxkEueQ+cjNtxXI1ST9N5AsvAd42hsnHOj3wpk
 bhPsPwfcio7B1y5dR20zt1HUa3QoxZ1Mn4PaXLSR2j3ruXUaddUa0m9/fXqo6VyQN2om
 UBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=uOpqPDyTUSiqcW9AE9ZFTA2+wjqaCyh2aCjJrDKlnbA=;
 b=U6Mzl7l6Bf5eWtKSti8qb9RvUqnrefTmKfonb44mMnUIf8NJzUSH7mgdB3tirVtUN1
 1q4E215w0dV2ADdwzCwXoDxb/72jrORsaEgGUYSW9OJzZV4WCNAPzQ4LYCju3gy3OBjj
 oQiUV5uzV0kuxLmq0RajUkF3M4u3X15WGLHFdN4n3vyXwvA/R0AQzdIxLam+NHgGcH5z
 bwDx6PqAV1NGmP4GlkKh6MVIEAykRwtcU2HS6TR0T9kPeaJZGTSN+Xt1kwQZP0BxIRyj
 UIcLsfJgHZLCzbAC+6tmT0aq8LK+DaxK+lF/u1daRayP7sNvpTRl9qKyGO+WS7UQP7YT
 KoaQ==
X-Gm-Message-State: ACrzQf1Z+/ZisKqp0RPEUJquJjLS3jllvgNaD9WqBO0lMucxDJz2hTh2
 PUK4AM1in2lH9YyQXj2hHBYwzg==
X-Google-Smtp-Source: AMsMyM4VXf54h4Uw25CsOniEXMTUZ4koxgR7BvIQnTzVEHpwof+Db6MVYOTpNdTiT8wz4ojF/h6fgw==
X-Received: by 2002:adf:dc06:0:b0:236:f36f:8263 with SMTP id
 t6-20020adfdc06000000b00236f36f8263mr18865909wri.522.1667844554317; 
 Mon, 07 Nov 2022 10:09:14 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8?
 ([2a02:6b6a:b4d7:0:ebf7:de38:f6bc:8fe8])
 by smtp.gmail.com with ESMTPSA id
 g12-20020adffc8c000000b0022cd96b3ba6sm9140588wrr.90.2022.11.07.10.09.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Nov 2022 10:09:13 -0800 (PST)
Message-ID: <de1327c2-f751-ac28-8dd7-7dd40bf1eab3@bytedance.com>
Date: Mon, 7 Nov 2022 18:09:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [v2 3/6] KVM: arm64: Support pvlock preempted via shared structure
Content-Language: en-US
To: Punit Agrawal <punit.agrawal@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <20221104062105.4119003-4-usama.arif@bytedance.com> <8735au3ap2.fsf@stealth>
From: Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <8735au3ap2.fsf@stealth>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, bagasdotme@gmail.com, maz@kernel.org,
 linux@armlinux.org.uk, liangma@liangbit.com, steven.price@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 07/11/2022 18:02, Punit Agrawal wrote:
> Usama Arif <usama.arif@bytedance.com> writes:
> 
>> Implement the service call for configuring a shared structure between a
>> VCPU and the hypervisor in which the hypervisor can tell whether the
>> VCPU is running or not.
>>
>> The preempted field is zero if the VCPU is not preempted.
>> Any other value means the VCPU has been preempted.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   Documentation/virt/kvm/arm/hypercalls.rst |  3 ++
>>   arch/arm64/include/asm/kvm_host.h         | 18 ++++++++++
>>   arch/arm64/include/uapi/asm/kvm.h         |  1 +
>>   arch/arm64/kvm/Makefile                   |  2 +-
>>   arch/arm64/kvm/arm.c                      |  8 +++++
>>   arch/arm64/kvm/hypercalls.c               |  8 +++++
>>   arch/arm64/kvm/pvlock.c                   | 43 +++++++++++++++++++++++
>>   tools/arch/arm64/include/uapi/asm/kvm.h   |  1 +
>>   8 files changed, 83 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/kvm/pvlock.c
>>
>> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
>> index 3e23084644ba..872a16226ace 100644
>> --- a/Documentation/virt/kvm/arm/hypercalls.rst
>> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
>> @@ -127,6 +127,9 @@ The pseudo-firmware bitmap register are as follows:
>>       Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
>>         The bit represents the Precision Time Protocol KVM service.
>>   
>> +    Bit-2: KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK:
>> +      The bit represents the Paravirtualized lock service.
>> +
>>   Errors:
>>   
>>       =======  =============================================================
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 45e2136322ba..18303b30b7e9 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -417,6 +417,11 @@ struct kvm_vcpu_arch {
>>   		u64 last_steal;
>>   		gpa_t base;
>>   	} steal;
>> +
>> +	/* Guest PV lock state */
>> +	struct {
>> +		gpa_t base;
>> +	} pv;
> 
> Using "pv" for the structure isn't quite describing the usage well. It'd
> be better to call it "pv_lock" or "pvlock" at the least.
> 
Yes makes sense, will change in next patchset, Thanks.

> [...]
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
