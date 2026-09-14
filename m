Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044CC3905F4
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789372493; cv=none; b=eUlRw9vcwYBepI9U2UoFLOAJhrL9Z3z4+HjVpWzvYWAbbpsXJSZ97yAXZXvjdvJe87UaemXHXCdGwr/i7TCla17XvwXwEY0YPNP9ykCrRERiDkYNQEwjzPqgbNikGgkrbTpEZLf8VfjxxkAcH+eabSlXTQJPyHTu3LE9x+9vWjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789372493; c=relaxed/simple;
	bh=bArJOzH0jmmCpUJgT39QaHyki9O1ZnIdy19LmKGn3M8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZRlCIaIXb8RyOjMCAVnSqzAXE3q/H1USxIMSSeRXO4xfnsBL3gl7dVNRyuOp3TR6lGD7S52ICCK6SaLe4rtNTZyZf1pTC5VaQWrxfkn0DTpS01DwRaArpxDUKV0rzY5Rs63aY+WaCyHTc3X1iOBQhpFMarpytN+sAgDGpRNsHjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K/Pq8LoD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/Pq8LoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789372490;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dYuLJW4P/YrBVk/hs4Chg8zTHAJI+p8avT4eA1ZbX3E=;
	b=K/Pq8LoDUBD13F60SkSwcp3dve7L/af2PwcT2BuUG7vBAqnESlZdix5KRWukFN4tXo8U1n
	TV8eIfuuNgYdnjRclVu7h79VuLB5WbJJFpxXVF6GkTkAHLmP9mHtOzBFOg8VMWOMWVnvw/
	U87nL3kUBfL75qRLwEWPHBHjYr6TSDs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258--f-bSjScOZSgLTN4rKBeTg-1; Mon, 14 Sep 2026 03:54:49 -0400
X-MC-Unique: -f-bSjScOZSgLTN4rKBeTg-1
X-Mimecast-MFC-AGG-ID: -f-bSjScOZSgLTN4rKBeTg_1789372488
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e65bee41aso18807795e9.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 00:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789372488; x=1789977288;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dYuLJW4P/YrBVk/hs4Chg8zTHAJI+p8avT4eA1ZbX3E=;
        b=YP0kNMqrhk+f5kOBLevqNjwcg6B7vafoR8Spa9txxfyvM6ItD1S1PF2ye916CDrmhw
         AdZeR9dI2twN/7wS8oTbyt6zS47EAY6KNilpY/1+ygEzH/GaB4BiBIwiMZTi4hQCCuDj
         VyFB5ga4T64ilas8gnlcklQXnr4uVsoz70ZMxzQbvzB5LiECLLFgVCzed6wbz7g4lnnp
         9RlIJmIOyyALRERq6vsEv2ih5fZ329qgDDwi1GaAp7CT8P9A2dXYtIf+BnYRodyu0UnY
         v1CSWVFbGgq9Ca/X3paI7hbWRU+AeuotT0uIARiXMS4XyPxfZ75tKlbMF2PP+MD0lS/q
         XIYw==
X-Forwarded-Encrypted: i=1; AKwUvBwsbDD5y2QDU3XoRzb+ZT926MyU2oB6IFkZJKkUKPQB+nwecBm1HAc7xp5SASpDulNp2/ndvlU=@lists.linux.dev
X-Gm-Message-State: AFuF++mxTZSoFjzZVnaSnVtG5pFG5dYaw4JefOqfTPWQH8OwiQ7Z4dEY
	YnpVqgYoLZFdpIHE0LUSd+R2FSd74qLfdqrLzzN2FyyWz51gwoF5zpee4dUKeWVDF0o/UPiuJZ3
	16aletV/TQM2P4HLGoyKn0uwyRBmyHuCUKesALJeAVV2pHz4Qz1z/wfQNQA==
X-Gm-Gg: AYBFou2b5GJthTv8SA0gEfZvFZrnMBCLkXCEoLwMv7komem0q8vl45dYJmH/nJ43z3R
	GWUH2Je1q6js8NM4PwE2gAwUTD1wbTNEjDH8kQSlyq0e1vw/8T+nIImh0bQ6UfsVGK3SS4uAjUU
	hIFILdUCG7hz9rQT8FwLCIHVxXJ3LKxuMufOTne/O3Zh5KSB2gQs+aMGJPYKA6fgxSX9xeEdQMD
	JlVVZZN6HMDV3Bm3BRIWyk7Ecj9BSk0/lImqmWOSIzyu/TyvwwiGMweMb83Teyq//jpvi9QqaSs
	qf2kVOAoGas12bZu08jvQPFz4oUYtRne/Swy6h7jC8CGCwZFgtekPcr43gnpai/f9Tn/fcorO68
	1Ram5UBzJDDb00kXs2hKiIN68+WtrrnYzLQH+w/JWxFMt9cwn
X-Received: by 2002:a05:600c:3484:b0:49c:f13e:e52 with SMTP id 5b1f17b1804b1-49e7a6865c1mr15391635e9.15.1789372488002;
        Mon, 14 Sep 2026 00:54:48 -0700 (PDT)
X-Received: by 2002:a05:600c:3484:b0:49c:f13e:e52 with SMTP id 5b1f17b1804b1-49e7a6865c1mr15391265e9.15.1789372487661;
        Mon, 14 Sep 2026 00:54:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm442316115e9.3.2026.09.14.00.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 00:54:46 -0700 (PDT)
Message-ID: <7fdbeeb9-3439-49d2-9ad9-33c3379d58c4@redhat.com>
Date: Mon, 14 Sep 2026 09:54:44 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v8 15/20] target/arm/kvm: Ignore and trace unexpected
 writable reserved fields
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
 "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
 <20260826093747.1670077-16-eric.auger@redhat.com>
 <SJ0PR12MB8614E4CF6C7C81CAE67A018DABBE2@SJ0PR12MB8614.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <SJ0PR12MB8614E4CF6C7C81CAE67A018DABBE2@SJ0PR12MB8614.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QqLQsbbNkmaPyDn7g0IqIOcXAcpcrAQJ3USwEddOo30_1789372488
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shameer,

On 9/11/26 3:50 PM, Shameer Kolothum Thodi wrote:
> Hi Eric,
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 26 August 2026 10:36
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; shaju.abraham@nutanix.com;
>> khushit.shah@nutanix.com; yangjinqian1@huawei.com;
>> cohuck@redhat.com; richard.henderson@linaro.org; sebott@redhat.com;
>> Shameer Kolothum Thodi <skolothumtho@nvidia.com>;
>> philmd@oss.qualcomm.com
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [RFC PATCH v8 15/20] target/arm/kvm: Ignore and trace unexpected
>> writable reserved fields
>>
>> External email: Use caution opening links or attachments
>>
>>
>> KVM currently reports some bits as writable whereas they are
>> RES0 or RAZ. The code easily allows to do some sanity checking
>> for such inconsistencies. Let's add a trace event when this is
>> encountered and skip the field
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  target/arm/kvm.c        | 8 ++++++++
>>  target/arm/trace-events | 1 +
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 2557d7b0d9..8ec9bc51cd 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -433,6 +433,14 @@ decode_idreg_writemap(Object *obj,
>> ARM64SysReg *reg)
>>          }
>>          lower = field->shift;
>>          upper = field->shift + field->length - 1;
>> +
>> +        /* Sanity check the field is not a reserved field */
>> +        if (strstr(field->name, "RES0") || strstr(field->name, "RES1") ||
>> +            strstr(field->name, "RAZ")) {
>> +            trace_unexpected_writable_reserved_field(reg->name, field->name,
>> +                                                     lower, upper);
> This hangs QEMU on my setup, the guest never starts.
> I think, we need to advance map/i: 
>
> +            map &= ~MAKE_64BIT_MASK(lower, field->length);
> +            i = ctz64(map);

Thank you for the report. Corrected in v9

Eric
>
> Thanks,
> Shameer
>

