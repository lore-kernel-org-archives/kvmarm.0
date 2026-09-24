Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D763C37B400
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232178; cv=none; b=MWgJ1/rkrd9Qq7Z0lWlnHudASmFYiNIbSQyXYMcHYfMF+ehm3i+S5dckQsrO+7y27UMm6jfF6ikUP7fpL80demZPmUJHzkMFPZFiD4xiShSOikNhLrcUmFBT6ainfycV0p2s+Ey03VAy3FRNqpZLEr5i9AIWLvu/dFixq7F8Pdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232178; c=relaxed/simple;
	bh=Szudz58Ufu11dhDt5j6ErmsGXsZcoeUDZxe9xtrXalQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aOfLFLE+3I+R4CQxPvPeSllGH1mTd2rgFRmL8s4v0WeB/+ulJ55dxQhhsHN6CnJuS+9RTHpNFRq8pEe0WPPP5eBX6Uiid/dSbBq2BKPVpv8QHOAY2/SQEhqFVRmm4Wb6fEX8UqwN4MjGYWFrZt2BaOIKFcYm6Ba2FC3z4gG6+88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hcv5N+0u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hcv5N+0u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232175;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xix05AhKt/VlngQg3Kkr8TZMZqtmCdybbbxgv1lqsHA=;
	b=Hcv5N+0ul1JvgPzN+5l976v16vE9fy98mCnbdFaH3Gi71wDBqkg4fx60fmx5Gk1/xAVuKt
	kIt388m2BJPXUkR8WgCJkYVVz1gkvskNMTgKResb6GcDu9ghrm9UyfChWgQBd6lU2/6WMe
	aJIDbIQL9pRV+NgKfqnnI/JVwS3p494=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-vg14C09bPnWC8mzVMicvXw-1; Thu, 24 Sep 2026 02:42:54 -0400
X-MC-Unique: vg14C09bPnWC8mzVMicvXw-1
X-Mimecast-MFC-AGG-ID: vg14C09bPnWC8mzVMicvXw_1790232173
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cd55ee2f7so13331865e9.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 23:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232173; x=1790836973;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xix05AhKt/VlngQg3Kkr8TZMZqtmCdybbbxgv1lqsHA=;
        b=kWCO+En8VV87NpIrqJksy+6AW7XQ4WV7BaOZZ+DTfpriZtAcWl1qnFEJdV76AutEhI
         tllgMSWL68QoiNnyDvRN9x26x6Pt0ShyUsPcknO71CPVRqGWds9k3hClpwyxpkJGyvrm
         ymesnjB/Sg3OHPWQYxAvxG8z/XX9TvZoQwNGpuvzzZ8qMvJ8KKlizmnPp/wKBLqU4fNh
         Rf4m5alUAj2tI4DPsGjzckoiRYHeHopMGdVFKMhBTWYKaV2/hD3SBVKY7Y36slkAX2Ts
         nWzkP4RhOFUfc/kYEogiEv3p2fizqQgt34XJarSKg4I1HI0bWRmoeXk08Jveo7lOL9/6
         TM7Q==
X-Forwarded-Encrypted: i=1; AKwUvBzH4yPhzaw5joaDIa38bnTImob+CVio+ub5QnFDBuv2bLFnqctQmcqoFVEfP3ASd5uqxhvSds4=@lists.linux.dev
X-Gm-Message-State: AFuF++lA/SDCp3WgHtngJdlrhBXPPvKMnwHZQlmoWhwOeSDNPbH1UX7W
	OnoPhCAUaf+8mvgA+S6IQ8H4V1CsEWQEyTizbYWrCyRMMY+/N7shYOZCjh8Xxtb56l+1/umwQCF
	9tShMivPzaz6Y9OQ9LG8RKQQG3kKs5q1l3tQ8oBvoNuan6p/0ej8t7mbTeA==
X-Gm-Gg: AYBFou3LW4sKMmZDjbgQHQXYYtSto5wwiHd0iQvwrFjDNzW5vGDIqeEuwkwAzz4LuMB
	6TGvlcghBLtx4bgOz2tIu6dNM50pD2PnV6fNbtZqADgavxfHGlbmaFWBfB6G6VOojPiV4x75sVo
	5VNGcAMPFiVKseKaPRqOgTuO1h3senBO8RsAQxN2d0WIerIsUjVEEF/WMrubYLZQv/ecPEByVwL
	Uc+R2erkw6KOf7bk7sFxZI1gYRjMGQYo1ZJj6d+gMVeDv7IsWC57XAyhhgKBRa8eE2V9ViI0F7W
	q9vl1qzuGMTKdVfN9qnJWZ0og+fgiZTJHnZm/RrH2Vzogi8bu1cuOhoIJnMt9jbJufoHhkkL90E
	qstbaPua3ywk/kL2h+rmqK9yu3yEKiphYwHYSFntJIaCF1r/3
X-Received: by 2002:a05:600c:1c16:b0:49c:ff3c:973f with SMTP id 5b1f17b1804b1-49fe7bba7c1mr16937615e9.24.1790232173016;
        Wed, 23 Sep 2026 23:42:53 -0700 (PDT)
X-Received: by 2002:a05:600c:1c16:b0:49c:ff3c:973f with SMTP id 5b1f17b1804b1-49fe7bba7c1mr16937215e9.24.1790232172662;
        Wed, 23 Sep 2026 23:42:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5de4de4sm45838335e9.8.2026.09.23.23.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 23:42:52 -0700 (PDT)
Message-ID: <b8bcd28e-3e4a-4b87-8775-3d994396ddbe@redhat.com>
Date: Thu, 24 Sep 2026 08:42:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 13/26] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-14-eric.auger@redhat.com>
 <67EB28E9-F8CE-4BE1-8712-88583DEFF24E@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <67EB28E9-F8CE-4BE1-8712-88583DEFF24E@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cU2B5e0U7CzbY6y4Vb8k0mO5JbBghG6EH78lCOq6Ric_1790232173
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/24/26 8:26 AM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> +
>> +/*
>> + * decode_idreg_writemap: Generate props for writable fields
>> + *
>> + * @obj: CPU object
>> + * @reg: description of the sysreg
>> + */
>> +static int
>> +decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
>> +{
>> +    uint64_t map = reg->writable_mask;
>> +    int i = ctz64(map);
>> +    int nb_sysreg_props = 0;
>> +
>> +    while (map) {
>> +        ARM64SysRegField *field = get_field(i, reg);
>> +        int lower, upper;
>> +        char *prop_name;
>> +        uint64_t field_mask;
>> +
>> +        if (!field) {
>> +            warn_report("%s bit %d of %s is writable but no named field "
>> +                        "in target/arm/cpu-idregs.h.inc",
>> +                        __func__, i, reg->name);
>> +            map =  map & ~BIT_ULL(i);
>> +            i = ctz64(map);
>> +            continue;
>> +        }
>> +        lower = field->shift;
>> +        upper = field->shift + field->length - 1;
>> +        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
>> +        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
>> +        object_property_add(obj, prop_name, "uint64",
>> +                            get_sysreg_prop, set_sysreg_prop, NULL, field);
>> +        g_free(prop_name);
>> +        nb_sysreg_props++;
>> +
>> +        field_mask = MAKE_64BIT_MASK(lower, field->length);
>> +        map = map & ~field_mask;
>> +        i = ctz64(map);
>> +    }
>> +    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
>> +    return 0;
>> +}
>> +
> We can try field based handling, it is more elegant.
> - for each field, check if not RES and writable.

I guess you refer to what you did in 

[RFC PATCH v4 02/25] target/arm: expose all non-res ID reg fields as
properties
ie. enumerate through all reg->fields[] array instead of parsing the
writable bitmask. Yes I agree your implementation is simpler.
We can still implement checks against writable masks if wanted.
>
> <Though I will argue that all fields should be present not just writable :)>
Let's discuss that separately. This function could be enhanced to
support both modes anyway.

Thanks

Eric
>
>
>

