Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2961F94A
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 05:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744089587; cv=none; b=HY62q0E9W6dyGIWQpKumRutH/zgghFU6aAXw71eLrtK3fQrne95MfYnZvTdftGTWi6d4IiCU7iTVtUzC0LBirRHI6mWQA+FaxCf03Wh5u7ScjDBiZKA0Ph0eXjSWZIDW2Appbw2yM8gkWqwIeRzC1Qc+39Lfe5RRIWNJarHhVW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744089587; c=relaxed/simple;
	bh=es+SNh0P9NtPGWcq5WsV3Y8WBvXwDiLbdcGTXKuwMv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sfxg7zSi9ALaX4Q2AG1LYWHVo3JpCr2FoIY2RlbcnvC6LhhutkdmP9jxFKMvshCTbrpuV4zsA3cwTnHYBARU6ar1w5wLCnhOOjtBTu6FrvQHOGk+zNLDXxiF2755EyHUqpfD8JUKI15/o9UqxDW7+R1odVZQ1lfHvWMYAKqY2c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WgcFEs0j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WgcFEs0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744089584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SZYs4PdDssFQWEmrDvKTFbTZUVJpYWm3vSQBh2J9Vlg=;
	b=WgcFEs0jI9uOOb2RI5mUkuoqJ7NOjP7wQGJOJq8UKhTlxkdCMW3Q6Hai2TaXpVYd9bb2ZF
	jaBRCCPid8yhUJnZwVHHSjIPlTWPMPKnlFc8HfiKcVj7ZeIM63U4lJeamPBs/BJCPxlxdn
	FrCbJ4yZVEr/DiBx1TCp3B8aa5Nk/c8=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-22dBWXqhO82Q9dhYQpTORg-1; Tue, 08 Apr 2025 01:19:43 -0400
X-MC-Unique: 22dBWXqhO82Q9dhYQpTORg-1
X-Mimecast-MFC-AGG-ID: 22dBWXqhO82Q9dhYQpTORg_1744089582
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b00aa1f50d1so592746a12.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 22:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744089582; x=1744694382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZYs4PdDssFQWEmrDvKTFbTZUVJpYWm3vSQBh2J9Vlg=;
        b=k5y7Ffg1b5EBFT+IB+HnUeLdDHZZkkSL+5CKZIJaz2uG/+xezgzNL5buR2+vdTcutv
         RpGWX8LTOaGmB8b4srVcYd8dfFPHH4x9e4+XQewKmptvJ0gAQCDzCcOAjghCoKRcPW6f
         AgJO/LFhm4DkeKRlLT7O7mNlnSsE9ceo4BEmyUpKyoBRi9+jZbI5IREg5ju68mhHNBqn
         n23ifez+CYOvmzYFyAM1agfJzQ7qFg97BIrX8hQ4CyyXLP/DT8eg3w4kcQj42EvOWegU
         eV5lQRrT5HKndreRiTKdDaspRWLTCogiGbEeIFpavu/1Qg3ZlS1oWsBAQmpaqIrbyLJA
         nvWg==
X-Forwarded-Encrypted: i=1; AJvYcCUChErp3s5r8OD7h6KTnVBx/fJbm0SjIetdScUXwYmcGbd72Jza2isnCJ6jesYumMq/CnVArYk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwssqOG+J+xPP7kKfzBW7+EzaJqWvH/izhh0vYd2jkdXrpj8IyP
	kSWinrNWdDSiLJygX+rCmSIlpb2mirF0U5TjoKUuu45qIVpCnFGR6nuB6m1HnB/Lypx6Cg22lPk
	v917BP1a3/jCnBdPriH1WiZP19+2PMczySumTgw86jObEqcWf2Mmiww==
X-Gm-Gg: ASbGncs+H6mCN+EJ3jROT8P0k5OHHxk7ONDYkw2/abA5Lr3C4Yge9DDBcodZrUO412J
	SRhK0xDhlQj8l9EX3okyKJZOqcX9SEMgYKuVRD8l4ovm4SjWz+vbtQ1/j2r1tGqDeqmPhZyKl+N
	7qJ57qdc5NCkws2QANUNraUxGBtsSDSuw8fNpC9KKuY3iIEnpVQ9HYa16EINiEJ38NFsFof+siO
	tgb7BeAba5CypgH84xdvq/82ig/eiClbVLYZTf+It1Vrpsad+Ql4xZkFK9J3sJU25otqaRY4FCP
	KE+qrjQFK4q5wJN2
X-Received: by 2002:a17:902:f610:b0:220:fce7:d3a6 with SMTP id d9443c01a7336-22a8a06b429mr204562475ad.23.1744089582312;
        Mon, 07 Apr 2025 22:19:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHON1uwm7bR+2w9kanWBPOGcZHKNZxG2Wp+hjgiN2PniqOi1+L2J3B1ic75+U0mQ/IeetE7VA==
X-Received: by 2002:a17:902:f610:b0:220:fce7:d3a6 with SMTP id d9443c01a7336-22a8a06b429mr204562115ad.23.1744089581919;
        Mon, 07 Apr 2025 22:19:41 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229786608d1sm91213655ad.120.2025.04.07.22.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 22:19:41 -0700 (PDT)
Message-ID: <b76ffc1c-32e1-4bf6-916a-41af9378fb4b@redhat.com>
Date: Tue, 8 Apr 2025 15:19:32 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/45] arm64: rme: support RSI_HOST_CALL
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-29-steven.price@arm.com>
 <12b5ba41-4b1e-4876-9796-d1d6bb344015@redhat.com>
 <54f1fbb1-4fa1-4b09-bbac-3afcbb7ec478@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <54f1fbb1-4fa1-4b09-bbac-3afcbb7ec478@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iC0PBJPU_aVRu0PjL6ecU-TS1NksmXpp3l3OcMMM3UQ_1744089582
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/8/25 2:34 AM, Steven Price wrote:
> On 04/03/2025 06:01, Gavin Shan wrote:
>> On 2/14/25 2:14 AM, Steven Price wrote:
>>> From: Joey Gouly <joey.gouly@arm.com>
>>>
>>> Forward RSI_HOST_CALLS to KVM's HVC handler.
>>>
>>> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v4:
>>>    * Setting GPRS is now done by kvm_rec_enter() rather than
>>>      rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>>>      enter/exit). This fixes a bug where the registers set by user space
>>>      were being ignored.
>>> ---
>>>    arch/arm64/kvm/rme-exit.c | 22 ++++++++++++++++++++++
>>>    1 file changed, 22 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>>> index c785005f821f..4f7602aa3c6c 100644
>>> --- a/arch/arm64/kvm/rme-exit.c
>>> +++ b/arch/arm64/kvm/rme-exit.c
>>> @@ -107,6 +107,26 @@ static int rec_exit_ripas_change(struct kvm_vcpu
>>> *vcpu)
>>>        return -EFAULT;
>>>    }
>>>    +static int rec_exit_host_call(struct kvm_vcpu *vcpu)
>>> +{
>>> +    int ret, i;
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +
>>> +    vcpu->stat.hvc_exit_stat++;
>>> +
>>> +    for (i = 0; i < REC_RUN_GPRS; i++)
>>> +        vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
>>> +
>>> +    ret = kvm_smccc_call_handler(vcpu);
>>> +
>>> +    if (ret < 0) {
>>> +        vcpu_set_reg(vcpu, 0, ~0UL);
>>> +        ret = 1;
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>
>> I don't understand how a negative error can be returned from
>> kvm_smccc_call_handler().
> 
> I don't believe it really can. However kvm_smccc_call_handler() calls
> kvm_psci_call() and that has a documentation block which states:
> 
>   * This function returns: > 0 (success), 0 (success but exit to user
>   * space), and < 0 (errors)
>   *
>   * Errors:
>   * -EINVAL: Unrecognized PSCI function
> 
> But I can't actually see code which returns the negative value...
> 

I think the comments for kvm_psci_call() aren't correct since its return value
can't be negative after 7e484d2785e2 ("KVM: arm64: Return NOT_SUPPORTED to guest
for unknown PSCI version"). The comments should have been adjusted in that commit.

Please take a look on 37c8e4947947 ("KVM: arm64: Let errors from SMCCC emulation
to reach userspace"). Similarly, the block of code to set GPR0 to ~0ULL when negative
error is returned from kvm_smccc_call_handler() in this patch needs to be dropped.

>> Besides, SMCCC_RET_NOT_SUPPORTED has been set to GPR[0 - 3] if the
>> request can't be
>> supported. Why we need to set GPR[0] to ~0UL, which corresponds to
>> SMCCC_RET_NOT_SUPPORTED
>> if I'm correct. I guess change log or a comment to explain the questions
>> would be
>> nice.
> 
> I'll add a comment explaining we don't expect negative codes. And I'll
> expand ~0UL to SMCCC_RET_NOT_SUPPORTED which is what it should be.
> 

Please refer to the above reply. The block of code needs to be dropped.

> Thanks,
> Steve
> 
>>>    static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>>>    {
>>>        struct realm_rec *rec = &vcpu->arch.rec;
>>> @@ -168,6 +188,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int
>>> rec_run_ret)
>>>            return rec_exit_psci(vcpu);
>>>        case RMI_EXIT_RIPAS_CHANGE:
>>>            return rec_exit_ripas_change(vcpu);
>>> +    case RMI_EXIT_HOST_CALL:
>>> +        return rec_exit_host_call(vcpu);
>>>        }
>>>          kvm_pr_unimpl("Unsupported exit reason: %u\n",
>>

Thanks,
Gavin

