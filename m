Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F181C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 13:02:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 172E94B175;
	Thu,  2 Dec 2021 08:02:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xO24x2POe+lX; Thu,  2 Dec 2021 08:02:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 120BB4B1A0;
	Thu,  2 Dec 2021 08:02:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8B54B19D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 08:02:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OY0xlqzyswnQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 08:02:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B252E4B19A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 08:02:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638450129;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=x1DDUlEbW7+TEcKrOe/PwHbaKXvgftYv4zFADOMy298=;
 b=cHijUvy92GgHlTfGpXiWSMaNyVnwZouO58KsDYTCL/25hQftOfxnLyOpXRnOlsGTgjXRkk
 q8ZpMdEkWiIETJRWLOmwH84CuyD7wGSCmDR21IJZqrA/GNux/hA+cFS/NKzXgzXUhNVsPx
 aZGKgytmt0DchN7HFptIqx2ROdpJVJg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-POYy9O_VOJKNLd9W2wF0Uw-1; Thu, 02 Dec 2021 08:02:08 -0500
X-MC-Unique: POYy9O_VOJKNLd9W2wF0Uw-1
Received: by mail-wr1-f69.google.com with SMTP id
 q5-20020a5d5745000000b00178abb72486so5029866wrw.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 05:02:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=x1DDUlEbW7+TEcKrOe/PwHbaKXvgftYv4zFADOMy298=;
 b=j4lR06D8bij/lF+BHbVnozBMMj1GoNN6Qg+rV0zZB1W7SAmwVFqFr9ZlEfQUY/KIOj
 NAXR3EAGuDzdhmrLNopDXVH2HUzdVYeLgBxcXEO+MmfVCFKKI2UIU5KrxMzbLm1Qe6RE
 mYbGdzbvbk758jsJ9YHNZ3bmr/xVFKILwDmMNGqeHYWH9FekuhQyjL8t3ZhlJ8Vr9a7/
 buHVp04I2wpndZg1aJZvCnS/dBUfLNWiud7rjodtLeyQZJ3D40cRTHnVu5p/Vw6Vjs6H
 l6NqN6e74AY/TjhaLPWtH537Rc15RAG5zpk+BSV0AeHGVlS6rmtMWBk2nGH+JPgsh8ZA
 /fnw==
X-Gm-Message-State: AOAM531Ttmd6UUlI4SCni7fPil2+wuJMKnlDKTVVdby4QWom9krGMEgr
 9r62EvDzdAoXWC/cynwqCBFfOK3Q2X7JNL0ADGw7KicSLmwSA2HkNLhHrhcCl5oPuATmicIxrHQ
 zolfh+CBp9XnorGoGcYVSTZ4Y
X-Received: by 2002:a05:6000:143:: with SMTP id
 r3mr14462656wrx.236.1638450127233; 
 Thu, 02 Dec 2021 05:02:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMvw1j4167feOTyg3bdIJl0KldZ/+JDB+tLVdpAglu6yx0xuOJYBL7gNenCbomHVVt1er+1Q==
X-Received: by 2002:a05:6000:143:: with SMTP id
 r3mr14462621wrx.236.1638450126984; 
 Thu, 02 Dec 2021 05:02:06 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id a22sm2110828wme.19.2021.12.02.05.02.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Dec 2021 05:02:06 -0800 (PST)
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To: Reiji Watanabe <reijiw@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-5-reijiw@google.com>
 <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
 <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
Date: Thu, 2 Dec 2021 14:02:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
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

On 11/30/21 2:29 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
>>> userspace.
>>>
>>> The CSV2/CSV3 fields of the register were already writable and values
>>> that were written for them affected all vCPUs before. Now they only
>>> affect the vCPU.
>>> Return an error if userspace tries to set SVE/GIC field of the register
>>> to a value that conflicts with SVE/GIC configuration for the guest.
>>> SIMD/FP/SVE fields of the requested value are validated according to
>>> Arm ARM.
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
>>>  1 file changed, 103 insertions(+), 56 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 1552cd5581b7..35400869067a 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
>>>               id_reg->init(id_reg);
>>>  }
>>>
>>> +#define      kvm_has_gic3(kvm)               \
>>> +     (irqchip_in_kernel(kvm) &&      \
>>> +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>> you may move this macro to kvm/arm_vgic.h as this may be used in
>> vgic/vgic-v3.c too
> 
> Thank you for the suggestion. I will move that to kvm/arm_vgic.h.
> 
> 
>>> +
>>> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>> +                                 const struct id_reg_info *id_reg, u64 val)
>>> +{
>>> +     int fp, simd;
>>> +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
>>> +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
>>> +     int gic;
>>> +
>>> +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
>>> +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
>>> +     if (simd != fp)
>>> +             return -EINVAL;
>>> +
>>> +     /* fp must be supported when sve is supported */
>>> +     if (pfr0_has_sve && (fp < 0))
>>> +             return -EINVAL;
>>> +
>>> +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
>>> +     if (vcpu_has_sve ^ pfr0_has_sve)
>>> +             return -EPERM;
>>> +
>>> +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
>>> +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
>>> +             return -EPERM;
>>
>> Sometimes from a given architecture version, some lower values are not
>> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
>> Shouldn't we handle that kind of check?
> 
> As far as I know, there is no way for guests to identify the
> architecture revision (e.g. v8.1, v8.2, etc).  It might be able
> to indirectly infer the revision though (from features that are
> available or etc).

OK. That sounds weird to me as we do many checks accross different IDREG
settings but we may eventually have a wrong "CPU model" exposed by the
user space violating those spec revision minima. Shouldn't we introduce
some way for the userspace to provide his requirements? via new VCPU
targets for instance?

Thanks

Eric
> 
> 
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
>>> +{
>>> +     u64 limit = id_reg->vcpu_limit_val;
>>> +     unsigned int gic;
>>> +
>>> +     limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
>>> +     if (!system_supports_sve())
>>> +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
>>> +
>>> +     /*
>>> +      * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
>>> +      * isn't affected.  Userspace can override this as long as it
>>> +      * doesn't promise the impossible.
>>> +      */
>>> +     limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
>>> +                ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
>>> +
>>> +     if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
>>> +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
>>> +     if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
>>> +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
>>> +
>>> +     gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
>>> +     if (gic > 1) {
>>> +             /* Limit to GICv3.0/4.0 */
>>> +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
>>> +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
>>> +     }
>>> +     id_reg->vcpu_limit_val = limit;
>>> +}
>>> +
>>> +static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>> +                                  const struct id_reg_info *idr)
>>> +{
>>> +     u64 val = idr->vcpu_limit_val;
>>> +
>>> +     if (!vcpu_has_sve(vcpu))
>>> +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
>>> +
>>> +     if (!kvm_has_gic3(vcpu->kvm))
>>> +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
>>> +
>>> +     return val;
>>> +}
>>> +
>>> +static struct id_reg_info id_aa64pfr0_el1_info = {
>>> +     .sys_reg = SYS_ID_AA64PFR0_EL1,
>>> +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
>>> +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
>> is it needed as it is the default?
> 
>>> +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
>>> +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
>> is it needed as it is the default?
> 
> They are needed because they are signed fields (the default is unsigned

Ah OK, I did not catch it at first glance while looking at the ARM ARM.

Thanks

Eric

> and FCT_LOWER_SAFE).  Having said that, ftr_check_types itself will be
> gone in the next version (as arm64_ftr_bits will be used instead).
> 
> Thanks,
> Reiji
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
