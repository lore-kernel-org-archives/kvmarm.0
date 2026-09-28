Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BE04E56CB
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608871; cv=none; b=n6ZzzdKRmGBSpE9iEnPviCQzEEpZiTWPb75NkjLS+e+iueLPr6jmh76k+IEwAloq5gfaZPf2pisgT+YNzplW8wFQ6Qvrd/9AERXqHVFkgtMIz1cbFBh7MFNaJXKmZnni85KPUJ0Vu6tKfu6sHR66hshU+g7hre0krxu+LHjMHd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608871; c=relaxed/simple;
	bh=BLvCstjG1Yj3NsKWLpFT62ggLZ10+sibOavmqypXAKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NP2oQ2HQMZLEe5FKhQyNyCUsOrJ2ZTA2qiRaPcFzPoNf98IBlXH3/944KRfzwuzgAxNalp7xcmKLWco2iT91LZnVhdqs0gzDIkMGdUcLsaqBpBbn7K7zIXmpi9yAOwxlsok6yHEuhjL6wju9tSic9+hcHEN6Z2DrNHZNN07RzFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQyZxNpw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQyZxNpw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790608869;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lfyQe5YfS2fsAUZ3PMujSKCnEKbPILudt9YglQ0qNCA=;
	b=OQyZxNpwnW/guNdkMW7Wezp8eqlgBksjxIeS28jOBWJT1DopBojd0e6QfzasWHIa5fOieK
	PF5QOhINoS/DQSghHa/ZXI5xj9EMddxLD0jg+4ey20PRywLg1yWYnmA11CgePS+lFIOAyx
	Xz2oc/mM2QzECWR2pabcYzBQjSuBCCM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-46Msd7i4OQGiaQ2qQ4ao2w-1; Mon, 28 Sep 2026 11:21:07 -0400
X-MC-Unique: 46Msd7i4OQGiaQ2qQ4ao2w-1
X-Mimecast-MFC-AGG-ID: 46Msd7i4OQGiaQ2qQ4ao2w_1790608866
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48aec0407daso493093f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 08:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608866; x=1791213666;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lfyQe5YfS2fsAUZ3PMujSKCnEKbPILudt9YglQ0qNCA=;
        b=iUUmS84rrSGa5ZnK15emBTf27e+OxpbQmqMMDh6/tIleA5kpcR2evXdMO3mEGmK+/n
         8rHLC2dTE34xP5Pug3ICXEcS5ofw1JLh8u5swcaEWwAxSUeKc+iM8XmGrxXDn9cG8+Vx
         FYONA0h1NKvn7q4OOv7wOaow733O2JEtXL976LxTlrSF/8fXfsdUCaKvxBwLx3sCYkzn
         3LQ7hIdreaaZmjpAMYr+UsEitUFuAyLxc6Ic/GWdQJDocmUHm+mBsyBIvHVy/kCYzOsA
         E6sJceLe6uyRKFYMsePUx7JwF5kv1xERBwuZXmAZmDfwpxOfUysXa6ZhhmpyiVqyiqef
         SyZg==
X-Forwarded-Encrypted: i=1; AKwUvByDsHVVwrpZDitB4aMsDEGpCy+0p4SdPCQMxp4x4k8QNt9ThOVN1fqH/8dcbvVo4eukVl6dlfY=@lists.linux.dev
X-Gm-Message-State: AFuF++lx4dJjMXI3n6MWDrHhMDQ4nO+BEjQdE5nQLpOXpiW0J9zFwtiF
	wJ6TSX4/ztgI+8wu0O5RouM9qI/nAbchuXHwrV9OFdUPDHSF9CaIS5joRPn0FP+dOyZSMJMsxJ3
	ehF/Q3o9VW5geIOx58kJZCY3aTsUjNn5w3VWz4+1BJSexkuclIxT63iEWAQ==
X-Gm-Gg: AYBFou2lGB02eV41d6U1v9mndfCXX5gkfvx5UsAXA+VVPcevn2PPSD9CmvfS9dopw26
	gFsdhf62An2mOOcJqQqtcbq39cMqEzqByhJI2bhwV+KRulq/wgojnwRnbLYhP07nd40UkvHakTc
	drLtzADShx91vAoBwf5wxBMxXd5wNQxmMUMNG5tPdPHAMT1AqpXa4qLCtkgBKzqWfAuU5pKuX4P
	NlbLEmds/+LeyxiYC6MpRfJX5GAi1Wbzlx93dStvRBOU9lwcCUiCgWRADL1fI64ZNULpW6fA1ml
	1dJkOhhX9A7eVAWCyeOQ/O/ANMrz3Np+xcEDGU+S5CbR8oxVC4KykJslF4ljmYKgpr9J3O36j1A
	alPhS5uZiRMFwKp6zb6XTtOSpsE1l97tKANuOM0L9ibG/Ad+J
X-Received: by 2002:a05:600d:6409:20b0:49f:f099:6f8c with SMTP id 5b1f17b1804b1-49ff0996fd6mr120575435e9.9.1790608866480;
        Mon, 28 Sep 2026 08:21:06 -0700 (PDT)
X-Received: by 2002:a05:600d:6409:20b0:49f:f099:6f8c with SMTP id 5b1f17b1804b1-49ff0996fd6mr120574815e9.9.1790608865959;
        Mon, 28 Sep 2026 08:21:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30bcdbsm27793547f8f.2.2026.09.28.08.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 08:21:05 -0700 (PDT)
Message-ID: <598d5c80-7b03-41cd-b708-6f833c1e9b08@redhat.com>
Date: Mon, 28 Sep 2026 17:21:02 +0200
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
X-Mimecast-MFC-PROC-ID: Bmd6sZrCVD4hc_ZCFgAtIhWlw4dXKNAmKHDOPWnuAUM_1790608866
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
As discussed I now enumerate all the fields instead of decoding the
writbale bitmask. But I still do some sanity checks on the consumed
writable bitmask:
- check the field is fully writable
- check if, after enumerating all fields I still have some writable bits.
The above cases would highlight some inconsistencies between KVM outputs
and qemu architecture description. I think it is worth.

Thanks

Eric
>
> <Though I will argue that all fields should be present not just writable :)>
>
>
>

