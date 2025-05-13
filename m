Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C00818E1F
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747149399; cv=none; b=pWxjsNyzCoaskf7CI40kvSNiHZEDBCmdVNnvqap7rvu6lMt1q4HTE3KQrI/VefEK2IX/BOlQu3aCXFouMCI2fjZeTkOeuY7IFtQZM7EmV2EfIfAjB3mdj/p0W/tV3UzSRFlKj2iRjC0FIi2nl34kEUNnWwtCiJXZm2VnsK0Cu5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747149399; c=relaxed/simple;
	bh=94P94eJc7x4T5OebFcGLwzjvtyyYxZm7baogL1P3QoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1tDvw3a6PK+ShBUYb7evVI3KkKGOmWpHBIyNoZA1TSSvNAOoiVecUQCdr1oWYqP13RLAHIiswHarq4m1fPUfTh87E/y8XQWyQhGDizpB6YtNvvpAQxzF3pJnEaI7CUMNXj6NceK73onVmfSFdmgc3k8TED3NucQ6OWhVv6yReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edVE0MQU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edVE0MQU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747149396;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XoJ42U2y/9zd0YP7um9oFc+AhPWl/ZEz6pZ6QwMtwA=;
	b=edVE0MQUj5kIjJYyc2XBE84QUrCUI+zOi0FX+jFRPazpNOzsnL/lFzZ3I8YFYHgik/8E19
	ThGqsbf6JvLr54UgoWy5tfokiqvmgPKf5seuuZhebY7AVdZNjr40tO+IxBuIspaxQlqCC7
	sNoNmrF7lwA3XMU13mkLw4bKgFDURJo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-kXNhUBqhO_2mh1geA89cVg-1; Tue, 13 May 2025 11:16:35 -0400
X-MC-Unique: kXNhUBqhO_2mh1geA89cVg-1
X-Mimecast-MFC-AGG-ID: kXNhUBqhO_2mh1geA89cVg_1747149394
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a0b7c8b3e2so3667141f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 08:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747149394; x=1747754194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/XoJ42U2y/9zd0YP7um9oFc+AhPWl/ZEz6pZ6QwMtwA=;
        b=R9AIYAbYVywXKFIeiZcXat/AAapK9xsL4lqciUnc/HIuR/2XtaVpDlqcvHrxQcE9YJ
         crnK+OmFOxkqSfAtD4yw4YXGQoSN9/opirFQGjPr82co1JcBPb2C+AdoMJlya3JJNHA6
         KJn/zXV5fBVhlnRmxixP3QpjoezCu0N1980WUlyFNyJD6ewHr0STtAj7WW8UY4KOZxku
         od2rxjF9B+GKYC48q5VTyncLn8inQxvIoiEJ4IL67AMLEPna/1auaLhahj8lzLuN35q6
         npZ6qg6aKzCURTCQHQRyzkS+7OkqRYIbRnA0iSONYLGC9z+si0O5+Lz05extFkAmmXuA
         1C1w==
X-Forwarded-Encrypted: i=1; AJvYcCU2ofmYIzNgl639kM5JTYUnDBW72a0vdmRmjtpeUot++mXFlX7dWOfrPXiFFSgvdPK/SbXumZE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfEd+0eEB/v2GHSXIb0EGEJFh+WMsQzbz5mLrGd0+rKxyelIDR
	b4bCimPrVUChpSXOZ1XqkfaheyLqTdZybXNkDGZai5TgtW0Di7NgpnCFB26J/sVOmiat+dB5ftq
	GcJHOqoU63tdkVpAC2CqCqJBnxphbIIlNQWy1AxOFiX07zppRJDQMEw==
X-Gm-Gg: ASbGnctF5tToBDqjFda/RydTl36JrZ1uCUt1HokQjhsRxx9diP2W79SzL/BIRufIxo5
	Q3UVf4ArLcL4sRh0AxYglVpbINYjZizGN2SWVb1dK+lqqkI1z8JgIehrGCvh8TMk0pc5Pv9dRco
	Xe517IYPccpQNBKBx6bEEyKWfyVoRbLH0P9luIdPlC+CrFKZzeglbTWNwc3gf+2tz+0elnoxrkc
	sndIt2x36CXRKRRzYt7+sn2OwSQzATDffyyIV2GxLP7Z8nQCZjMAQnaR1CP+tFaGakFU/Rc8fGn
	OGDkgGaFoB355UmoobaWTO5fmkH+03IERz0Y5TKyle3DUeHRu3whHJteNx8=
X-Received: by 2002:a5d:598e:0:b0:39c:2688:612b with SMTP id ffacd0b85a97d-3a1f64277femr15646996f8f.7.1747149394177;
        Tue, 13 May 2025 08:16:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEO9N1Muxi40863izt+xRGg83Sc69SpQT6SZfRFMKC1kCRtYNKU+SmXOLs5AdVDo+SN9lle3Q==
X-Received: by 2002:a5d:598e:0:b0:39c:2688:612b with SMTP id ffacd0b85a97d-3a1f64277femr15646959f8f.7.1747149393817;
        Tue, 13 May 2025 08:16:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ecb46sm16707990f8f.30.2025.05.13.08.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 08:16:33 -0700 (PDT)
Message-ID: <b62b7529-e782-41d6-91d4-c59af1b92020@redhat.com>
Date: Tue, 13 May 2025 17:16:30 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 04/10] kvm: kvm_get_writable_id_regs
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-5-cohuck@redhat.com>
 <4f370fae-8234-48ca-97e2-3b7038092974@redhat.com> <878qn0po69.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <878qn0po69.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vwy3n76BQCCBuaEgWkY0p9HykQ5jv08ZRVjJJMl_PDI_1747149394
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/13/25 4:42 PM, Cornelia Huck wrote:
> On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:
>
>> Hi Connie,
>>
>> On 4/14/25 6:38 PM, Cornelia Huck wrote:
>>> Add an helper to retrieve the writable id reg bitmask. The
>>> status of the query is stored in the CPU struct so that an
>>> an error, if any, can be reported on vcpu realize().
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  target/arm/cpu.h     | 26 ++++++++++++++++++++++++++
>>>  target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
>>>  target/arm/kvm_arm.h |  7 +++++++
>>>  3 files changed, 65 insertions(+)
>>>
>>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>>> index d27134f4a025..bbee7ff2414a 100644
>>> --- a/target/arm/cpu.h
>>> +++ b/target/arm/cpu.h
>>> @@ -856,6 +856,26 @@ typedef struct {
>>>      uint32_t map, init, supported;
>>>  } ARMVQMap;
>>>  
>>> +typedef enum ARMIdRegsState {
>>> +    WRITABLE_ID_REGS_UNKNOWN,
>>> +    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
>>> +    WRITABLE_ID_REGS_FAILED,
>>> +    WRITABLE_ID_REGS_AVAIL,
>>> +} ARMIdRegsState;
>>> +
>>> +/*
>>> + * The following structures are for the purpose of mapping the output of
>>> + * KVM_ARM_GET_REG_WRITABLE_MASKS that also may cover id registers we do
>>> + * not support in QEMU
>>> + * ID registers in op0==3, op1=={0,1,3}, crn=0, crm=={0-7}, op2=={0-7},
>>> + * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
>>> + */
>>> +#define NR_ID_REGS (3 * 8 * 8)
>> We may rename this define to better associate to the KVM API. I tend to
>> mix it with NUM_ID_IDX now ;-)
>> maybe something like KVM_NR_EXPOSED_ID_REGS
> The kernel calls it KVM_FEATURE_ID_RANGE_SIZE, but I'd like to avoid
> adding 'KVM' in the name, as it is basically a range of registers and
> nothing really KVM specific... maybe ID_REG_RANGE_SIZE?
what about NR_ID_REG_MASKS
because it is masks actually.
>
>>> +
>>> +typedef struct IdRegMap {
>>> +    uint64_t regs[NR_ID_REGS];
>>> +} IdRegMap;
>> I would add a comment saying this is the mask array, just to prevent the
>> reading from thinking it is the actual reg content.
> "More comments" seems to be a theme :) I'll go ahead and add them where
> it makes sense.
yeah. I am sorry. previously we had a single indexing and on top of that
we have several kinds of definitions for id regs and writable masks.
Even for me who contributed to that mess it can be difficult to parse so
I imagine it can be painful to read for other readers too ;-)

Eric
>
>>> +
>>>  /* REG is ID_XXX */
>>>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>>>      ({                                                                  \
>>> @@ -1044,6 +1064,12 @@ struct ArchCPU {
>>>       */
>>>      bool host_cpu_probe_failed;
>>>  
>>> +    /*
>>> +     * state of writable id regs query used to report an error, if any,
>>> +     * on KVM custom vcpu model realize
>>> +     */
>>> +    ARMIdRegsState writable_id_regs;
>> maybe rename into writable_id_reg_status that would better reflect what
>> it is.
> Indeed.
>

