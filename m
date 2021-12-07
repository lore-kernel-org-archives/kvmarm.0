Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474E4C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 09:42:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7F0C4018F;
	Tue,  7 Dec 2021 04:42:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id isWmjcTBu12h; Tue,  7 Dec 2021 04:42:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4AC4057F;
	Tue,  7 Dec 2021 04:42:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8914018F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 04:42:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U4MZAG+5ZU0D for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 04:42:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BCBD400D5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 04:42:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638870131;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IfdtTnAi2J8orsL+RMPenY5oP4wZsK7814Lhx3qxSSo=;
 b=X3FxfdkOd1tt7pCdRR9VjzVQxNljiU1nj5XQmukh/msHsqr+tRKd8y6Q0ZIMOn558t7gYl
 noQ1TtaSym/iV9slPFg58qhzv93cKeJrcZCJ0eENM4s4TJYgUcjqKcwoxgeP5YzaXiaNPK
 +M50iOe7dG9SRNfv+sBuzOGyYurpVpA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-k5NWEiodNlOBVkn4cluD3Q-1; Tue, 07 Dec 2021 04:42:10 -0500
X-MC-Unique: k5NWEiodNlOBVkn4cluD3Q-1
Received: by mail-wm1-f71.google.com with SMTP id
 j193-20020a1c23ca000000b003306ae8bfb7so7462165wmj.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 01:42:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=IfdtTnAi2J8orsL+RMPenY5oP4wZsK7814Lhx3qxSSo=;
 b=3SCnedJ8KDNs+3UrRCkgynqg/AgveayNNv2YiiA2Zv2fQGSMDfM60Wr62oAUrq07O4
 LW9VrbZA4W1z9GhXDXvLuzgrZncbItWUFJ/esTFCDOkw6ULJcvOVunXgfLFofs3jRdP6
 oWXneP01383FCjlChILQNpei8CUPKJan7i6SNAXq1FFZdWpuzIeek0T9Ceh8G9WwgfGy
 qfz8U/Pvlue8vK5dpX/IomJqIe2ZLUQrLAZieHhHrm4V7gB8DuWLpawRelFdlqLkswPL
 XWQJRfoRNA2VMGoiI229DvymozN6fnkIU5Ogz+qTQZY0ZOIZWpuuPdSfDStPs/ueeFC1
 cmzw==
X-Gm-Message-State: AOAM531ZqduJ5l0E3/dTrBRYi8SHrYRqb/3VOcyEimDBEnv2aKOdKXkq
 hlIEfubg7Umk2Llx7Sx9uAJOxMBXcf8lRfO7KI32qYTB5n9gQZ4/iwVTLjNlMqvoxOyn0zQwS8j
 A63jLFqM/cZyL/bZl9oW8+WvL
X-Received: by 2002:a05:600c:35c8:: with SMTP id
 r8mr5642769wmq.8.1638870129249; 
 Tue, 07 Dec 2021 01:42:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgiz4h3rob+EwyRswCrpRZGyj0kE1qIofZJRmkuP700RK+ws81XqcftlJ91CeLT3kVM2yBuA==
X-Received: by 2002:a05:600c:35c8:: with SMTP id
 r8mr5642733wmq.8.1638870129012; 
 Tue, 07 Dec 2021 01:42:09 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d15sm18436814wri.50.2021.12.07.01.42.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Dec 2021 01:42:08 -0800 (PST)
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To: Reiji Watanabe <reijiw@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-5-reijiw@google.com>
 <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
 <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
 <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
 <CAAeT=Fz2tLMDOkZ4kQYV0tS44MEtSUxPH71+XD3r+VyJxbjd_g@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <728dae43-c97e-0982-b7d0-dd7d6eed6d6b@redhat.com>
Date: Tue, 7 Dec 2021 10:42:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=Fz2tLMDOkZ4kQYV0tS44MEtSUxPH71+XD3r+VyJxbjd_g@mail.gmail.com>
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

On 12/4/21 8:59 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Dec 2, 2021 at 5:02 AM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/30/21 2:29 AM, Reiji Watanabe wrote:
>>> Hi Eric,
>>>
>>> On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Reiji,
>>>>
>>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>>>> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
>>>>> userspace.
>>>>>
>>>>> The CSV2/CSV3 fields of the register were already writable and values
>>>>> that were written for them affected all vCPUs before. Now they only
>>>>> affect the vCPU.
>>>>> Return an error if userspace tries to set SVE/GIC field of the register
>>>>> to a value that conflicts with SVE/GIC configuration for the guest.
>>>>> SIMD/FP/SVE fields of the requested value are validated according to
>>>>> Arm ARM.
>>>>>
>>>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>>>> ---
>>>>>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
>>>>>  1 file changed, 103 insertions(+), 56 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> index 1552cd5581b7..35400869067a 100644
>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
>>>>>               id_reg->init(id_reg);
>>>>>  }
>>>>>
>>>>> +#define      kvm_has_gic3(kvm)               \
>>>>> +     (irqchip_in_kernel(kvm) &&      \
>>>>> +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>>> you may move this macro to kvm/arm_vgic.h as this may be used in
>>>> vgic/vgic-v3.c too
>>>
>>> Thank you for the suggestion. I will move that to kvm/arm_vgic.h.
>>>
>>>
>>>>> +
>>>>> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>>>> +                                 const struct id_reg_info *id_reg, u64 val)
>>>>> +{
>>>>> +     int fp, simd;
>>>>> +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
>>>>> +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
>>>>> +     int gic;
>>>>> +
>>>>> +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
>>>>> +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
>>>>> +     if (simd != fp)
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     /* fp must be supported when sve is supported */
>>>>> +     if (pfr0_has_sve && (fp < 0))
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
>>>>> +     if (vcpu_has_sve ^ pfr0_has_sve)
>>>>> +             return -EPERM;
>>>>> +
>>>>> +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
>>>>> +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
>>>>> +             return -EPERM;
>>>>
>>>> Sometimes from a given architecture version, some lower values are not
>>>> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
>>>> Shouldn't we handle that kind of check?
>>>
>>> As far as I know, there is no way for guests to identify the
>>> architecture revision (e.g. v8.1, v8.2, etc).  It might be able
>>> to indirectly infer the revision though (from features that are
>>> available or etc).
>>
>> OK. That sounds weird to me as we do many checks accross different IDREG
>> settings but we may eventually have a wrong "CPU model" exposed by the
>> user space violating those spec revision minima. Shouldn't we introduce
>> some way for the userspace to provide his requirements? via new VCPU
>> targets for instance?
> 
> Thank you for sharing your thoughts and providing the suggestion !
> 
> Does the "new vCPU targets" mean Armv8.0, armv8.1, and so on ?

Yeah my suggestion probably is not a good idea, ie. introducing such
VCPU targets. I was simply confused by the fact we introduce in this
series quite intricate consistency checks but given the fact we miss the
spec rev information we are not exhaustive in terms of checking. So it
is sometimes difficult to review against the spec.

> 
> The ID registers' consistency checking in the series is to not
> promise more to userspace than what KVM (on the host) can provide,
> and to not expose ID register values that are not supported on
> any ARM v8 architecture for guests (I think those are what the
> current KVM is trying to assure).  I'm not trying to have KVM
> provide full consistency checking of ID registers to completely
> prevent userspace's bugs in setting ID registers.
> 
> I agree that it's quite possible that userspace exposes such wrong
> CPU models, and KVM's providing more consistency checking would be
> nicer in general.  But should it be KVM's responsibility to completely
> prevent such ID register issues due to userspace bugs ?
> 
> Honestly, I'm a bit reluctant to do that so far yet:)

understood. I will look at the spec in more details on my next review
cycle. Looking forward to reviewing the next version ;-)

Thanks

Eric
> If that is something useful that userspace or we (KVM developers)
> really want or need, or such userspace issue could affect KVM,
> I would be happy to add such extra consistency checking though.
> 
> Thanks,
> Reiji
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
