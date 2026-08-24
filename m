Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95458372ED5
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787592107; cv=none; b=oDPnmRPIfx3Ze8WSlqkmRsHCbzz77SgtMt/jgNMw9Z3P1qhAlSB/4xOORtnZHtMrtW5iAt9Uh7S6JeNLfbqqd1TsJn0uw1bOToGF5+zHTo0vQBdMMA14q1dk/TW/6+LqdJpS0rCvuz/Dpt6t1nAzZBvQdTJDeH88htjqqkMb3ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787592107; c=relaxed/simple;
	bh=Wcq1kuxqeoc/mV0wBwb7AjQ6/H3J1d9I+JZvl0xIa2U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Fh66Rne6Vi935nHsBr4EOwqAg9RD+GRUdOZYPNqWrd7XIgYEoEPhRDqHd7S/3khBKMn4iF5pBlLATRZ9O+XUc2je2V/Vk+KI5uy7QLMTtafF8VS1TUskeSZNG6mmGYFuCHVyUwttSgv8nGGqsZBUjGIRO9RTZSIyCJ1v0WOJ+aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IO4W7EmY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IO4W7EmY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787592104;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbUK19ldvIBWtcuD0oTMHA2hFkXjZn0gQlWJ+k3b3+E=;
	b=IO4W7EmYX0AXieynOvE1A48Suwug0roMz+Rgf6mNL/KFMf4UKTm2dbjoslp8sSqooQWIci
	OS4XO9IS7F82ZASj4kPMbgJm8SjeR5nSsVmWhURQR0Z9x2BLwtwsK8hU665d8CEzsjTqHt
	EWCn839+qCf/eQvLByuXXB3pb7cbYGI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-w9RJn8n2NJe4lEAheOJiCA-1; Mon, 24 Aug 2026 13:21:43 -0400
X-MC-Unique: w9RJn8n2NJe4lEAheOJiCA-1
X-Mimecast-MFC-AGG-ID: w9RJn8n2NJe4lEAheOJiCA_1787592102
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15ceb17a28so283539566b.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 10:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787592102; x=1788196902;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:reply-to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GbUK19ldvIBWtcuD0oTMHA2hFkXjZn0gQlWJ+k3b3+E=;
        b=pTT5YmImPCE8LzuZfkHgCi3osAhXrD3iMYjqxxL+4oEDX83Y6tSasdtXWzd5pa4W84
         Ivoa3wIVVSnfOCTI/+O7LrTNWCTKmeCPqWi/D6/8X3BK/xBtkTHyCV1+FNr5ea5UbCCb
         J47MTVxup9IQXYBIgf+Nmvb/Thi/WbiQZiPjNnuJciKb3XbqYEAcY0Sdvm+YjcLZck6V
         o7eKi1hstNiLX6UrJ0y4nAvo9+bmJtlK5eLJU4FBoIV7Hj50AAXH6SIb2UHO8eUGS57H
         6YrNp8nq35ff1PPbtEE6trQ4YwUsoKCb6JTOYTWCB3Rnj0e6h0txkH4qgoUCa2fUu2pF
         w06g==
X-Forwarded-Encrypted: i=1; AHgh+RpHHHJIuxQZ2uUUcDUhI3CTjcL8D0KaqQZHD/98mNf3rAJrNUpOhqK7nyOV4LSHRV/vfMvwcWI=@lists.linux.dev
X-Gm-Message-State: AFuF++mcXQPAx4mytv9fieXxKymq45nF1BfGYng+OAoNs4J+wuCi9vSp
	HrLe+1O0d6kYwNwhb1SxofpKG3bfvrDgyfNbLdoLMsCgZ1ujJRJB/+ngIhUIHUnJgyMbYyE1luB
	HrrQPpCHHs/yMpiDAZNkYELQA3jD/uO0XmPrZSPmWHHX9geDp/KDJDq9rqw==
X-Gm-Gg: AR+sD12TI120TQrRRj/ao4y4aU9+t2zGQjoWHu07tvtWU1j+Gn+zESh5tLeAZLfAi92
	edeo5KxfHuX15ly6YGXwVRqZXIAM5JeUs/rGc6ac2fE/rbH+jvxErbvweKbqS6ESSTKoG/nhKq1
	Gdv+zduYgtnRDHEV9GJCD5O5gdRemyIzpJrS+3FZhwa7HqNQvoWwrvMoyK2brxLgBka5j795+Zj
	rjbc4cNT3N/K9MTCY4GX8IrX9rM0752Js10736oP05hTOn5MTkM9y9/uB9cHC34JuoDXcpKTCAx
	V47Yu7pPtl4kL92bCGVa5Cddo7uhOjBcV9GqlyDMQAZm3XH5fMUaf1bPRZ/fnlRKDJMdw2/IIep
	xHrL0zSRsrNXCC449LeZpVpMYBa3akOs9kzHQ6iRAUaOgoaS6
X-Received: by 2002:a17:907:940f:b0:c21:74ad:8b7a with SMTP id a640c23a62f3a-c24e5a5243amr4844166b.9.1787592101829;
        Mon, 24 Aug 2026 10:21:41 -0700 (PDT)
X-Received: by 2002:a17:907:940f:b0:c21:74ad:8b7a with SMTP id a640c23a62f3a-c24e5a5243amr4840866b.9.1787592101419;
        Mon, 24 Aug 2026 10:21:41 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249629563dsm1407710366b.17.2026.08.24.10.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2026 10:21:40 -0700 (PDT)
Message-ID: <e2fbfb8a-b3e5-4e27-b938-d92d3ccfe83f@redhat.com>
Date: Mon, 24 Aug 2026 19:21:39 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC PATCH v7 12/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Reply-To: eric.auger@redhat.com
To: Markus Armbruster <armbru@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, shaju.abraham@nutanix.com,
 khushit.shah@nutanix.com, yangjinqian1@huawei.com, cohuck@redhat.com,
 richard.henderson@linaro.org, sebott@redhat.com, skolothumtho@nvidia.com,
 philmd@oss.qualcomm.com, maz@kernel.org, oliver.upton@linux.dev,
 pbonzini@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-13-eric.auger@redhat.com> <87a4qh3tbn.fsf@pond.sub.org>
In-Reply-To: <87a4qh3tbn.fsf@pond.sub.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AOVhts3aNZIFdJFYML-A3qhTqqhqrhhtbkRs9wl6f_s_1787592102
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Markus,
On 8/20/26 1:49 PM, Markus Armbruster wrote:
> Eric Auger <eric.auger@redhat.com> writes:
>
>> This helper decode the ID reg writable mask, matches it against
>> ID reg fields defined in target/arm/cpu-idregs.h.inc and
>> for each writable named field, generates a uint64 property.
>>
>> REVIDR_EL1 and AIDR_EL1 are writable but they do not expose any
>> field. They will be handled separately.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> [...]
>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 4f9b0a559d..1a78893f87 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
> [...]
>
>> +static void set_sysreg_prop(Object *obj, Visitor *v,
>> +                            const char *name, void *opaque,
>> +                            Error **errp)
>> +{
>> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    uint64_t *idregs = cpu->isar.idregs;
>> +    uint64_t old, value, mask;
>> +    int lower = field->shift;
>> +    int length = field->length;
>> +    int index = field->index;
>> +
>> +    if (!visit_type_uint64(v, name, &value, errp)) {
>> +        return;
>> +    }
>> +
>> +    if (length < 64 && value > ((1 << length) - 1)) {
>> +        error_setg(errp,
>> +                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
>> +                   name, value, length);
>> +        return;
>> +    }
>> +
>> +    if (field->arch_vals) {
>> +        /* this field has some enum values */
>> +        for (int i = 0; i < field->arch_vals_count; i++) {
>> +            if (value == field->arch_vals[i].value) {
>> +                goto valid;
>> +            }
>> +        }
>> +        error_setg(errp,
>> +                   "idreg %s set value (0x%lx) does not match any "
>> +                   "arch valid enum value!", name, value);
> Scratch the !
>
> From error_setg()'s contract:
>
>  * The resulting message should be a single phrase, with no newline or
>  * trailing punctuation.

done. Thank you for the reminder!

Eric
>
>> +        return;
>> +    }
>> +
>> +valid:
>> +
>> +    mask = MAKE_64BIT_MASK(lower, length);
>> +    value = value << lower;
>> +    old = idregs[index];
>> +    idregs[index] = old & ~mask;
>> +    idregs[index] |= value;
>> +    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
>> +}
> [...]
>

