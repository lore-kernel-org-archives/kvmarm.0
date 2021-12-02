Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC76BC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 10:57:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C74C4B121;
	Thu,  2 Dec 2021 05:57:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HwjBeXcJ0Xq0; Thu,  2 Dec 2021 05:57:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 482064B11E;
	Thu,  2 Dec 2021 05:57:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19DA84B121
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 05:57:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v7vLnm1FGZBi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 05:57:17 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B9E4B119
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 05:57:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638442637;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=D2VcVFQrB5DiBW+WXhArOQYyBQnCLPGn334r2cU2z28=;
 b=GwVfPViKkiuKUdYl5K6nSJx1QTNQ+1IUo7anm1fEkr5/u/tNkiINWG3Oiy+fSyIV9JgVMm
 tRV9sFpk1iNzjXrhjBuvjNYMIqo5PMEJaBT1k82RNfjXhmYL/A1GnyydjDE1w5UYQMs2r8
 6/dBXlXa5FssDc+qbvIZ8zcgxAvrTWI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-MYd_vK3eNMubvCXcKsk2Bw-1; Thu, 02 Dec 2021 05:57:14 -0500
X-MC-Unique: MYd_vK3eNMubvCXcKsk2Bw-1
Received: by mail-wm1-f71.google.com with SMTP id
 r129-20020a1c4487000000b00333629ed22dso1488356wma.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 02:57:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=D2VcVFQrB5DiBW+WXhArOQYyBQnCLPGn334r2cU2z28=;
 b=ftrVNMxRS33u9lpm7otcAmL5PWhdUw+7ZUXhWcfdXiHjq2JON/KBne3fb6NnaiN37w
 fm63z79rXKIqrOHq02HWKAmUTtSYlL69Q5SrH7RZNdYaUK/sMkJCJA7C528JbqzNkDUA
 O4EXEEjoEg3avnDWGkzZq8EhIrpuSSb58SjzKvmTu0NT0QuUFtNjd7XIPnWdINEmKjdL
 TbWrZqy6cSrD7clJKXXrrgxj6091iyRMj25oLYEgcjL3p79cDn8dg13Dfea50yOdR4oG
 z51LjGBtuiMDmExOiUxVaY5jbUyaPDt5jx8fku5JjD+k5VRpz3djEWCphbMJPZ4H00IF
 D27Q==
X-Gm-Message-State: AOAM530s385JR8BhO1iV28DBQvj3Fa2OZpSxgyAWGovNc1CYH7/Q4Urj
 +HrtLWV7EgGSBCISPMNDk3YhdY6XLBLChQ/7QdbX90KRyVQgmWVaaEfw8y083c/Rc7GfBw+R84+
 VQwnnyx2bfmfEzz+aFHdjvEXm
X-Received: by 2002:adf:aac5:: with SMTP id i5mr13864062wrc.67.1638442633663; 
 Thu, 02 Dec 2021 02:57:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyX44La4y5VA1cgP3RPzlda8vKuQzx3m3QaQe/i+Qj0upafaYqtzXJF52EratMa3sVUXhqR4g==
X-Received: by 2002:adf:aac5:: with SMTP id i5mr13864039wrc.67.1638442633487; 
 Thu, 02 Dec 2021 02:57:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id ay21sm1902044wmb.7.2021.12.02.02.57.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Dec 2021 02:57:12 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Reiji Watanabe <reijiw@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
Date: Thu, 2 Dec 2021 11:57:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
>>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
>>> expose the value for the guest as it is.  Since KVM doesn't support
>>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
>>> exopse 0x0 (PMU is not implemented) instead.
>> s/exopse/expose
>>>
>>> Change cpuid_feature_cap_perfmon_field() to update the field value
>>> to 0x0 when it is 0xf.
>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>> guest should not use it as a PMUv3?
> 
>> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
>> guest should not use it as a PMUv3?
> 
> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> Arm ARM says:
>   "IMPLEMENTATION DEFINED form of performance monitors supported,
>    PMUv3 not supported."
> 
> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> be exposed to guests (And this patch series doesn't allow userspace
> to set the fields to 0xf for guests).
What I don't get is why this isn't detected before (in kvm_reset_vcpu).
if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
init request if the host pmu is implementation defined?

Thanks

Eric
> 
> Thanks,
> Reiji
> 
>>
>> Eric
>>>
>>> Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/include/asm/cpufeature.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>> index ef6be92b1921..fd7ad8193827 100644
>>> --- a/arch/arm64/include/asm/cpufeature.h
>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>> @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
>>>
>>>       /* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
>>>       if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
>>> -             val = 0;
>>> +             return (features & ~mask);
>>>
>>>       if (val > cap) {
>>>               features &= ~mask;
>>>
>>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
