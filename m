Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2073176EE
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895084; cv=none; b=JK4kQOUwsyBVS9tXsRlDwC63LZuEwA1uwPl4QOPoQya3k1XeMFHkIEfV3sIOazo0Od8WIpNlGF72VyWoXrzhT/jWE7y+28Rky1I3AeQTzWf3FhJ9wLxzdrabcr1mu1RPY3Tx2Q1CfHzkun7Pq+DK2FpPXFKSSZeRFyl7LdA2Xd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895084; c=relaxed/simple;
	bh=4BlorftIGADgFtHSYCq3qxHWejOoR+eqT0CXFa5pEQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlUY0B+LHW1hQLr8jLzodV6KvJJ/TFLLpB1T08AaueAnLZPuUALd7BjQhTPYcWjQG3fs7zkq5VTIRw1SEna2ExfrjJZwN6pOjIRDlWtAn6mwr0OZKL7p2p2l8Vj2Si5Dt5X5amc24kTA0KQHG3nG7C+PHs2GRl42DJtWflmHeKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFm4V3L+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFm4V3L+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779895082;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sQvj0wwCTqJ+sGXiLk6kzvtAtH/Avbnj+KF7JOy6SJ4=;
	b=MFm4V3L+GG0s673QnurEUHLjud3Fb6iZz7OzGQ0sLeaLcJkMNt+uidjN42RWEWdgF8yrf8
	gvEgf6KL3kz74n9Sygfxvh4SZ3GAOGb4GSoIRfNdBH3sjJLhBa16H88Prp1+Nu3O+6IyKk
	IrilhpHC3WlC2+3XxfX4+/Vx3CElgy8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-zMZWB87CMbaGMhPx0ozobA-1; Wed, 27 May 2026 11:18:00 -0400
X-MC-Unique: zMZWB87CMbaGMhPx0ozobA-1
X-Mimecast-MFC-AGG-ID: zMZWB87CMbaGMhPx0ozobA_1779895080
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fe40b61a3so78105795e9.3
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779895079; x=1780499879;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQvj0wwCTqJ+sGXiLk6kzvtAtH/Avbnj+KF7JOy6SJ4=;
        b=aKRuRW37ypZORNA719v3b3Af2z2r72dnlfx2cQNL3l79QtjOF+wI1rsJYnlyfVVQb1
         ymyGYLF5IFclVJ7X8gF/eeU0eOQilZ15NJEHmdkyWJkf6gLlGwmJRNsGkZ43WdMoj+in
         TjMXCZU/7QjCcNqN+l1tJf3yMMUqQoO+in1mUL0r9JXfnqJ3R4ogWs4aikWuZq94KcdV
         EoFrkq0JxnyrKFidy41KfPQZVt0bXPV+W8+YnBuPeckLPKfSowPq6QQZ52rGY2RKiZmW
         hGPXAY0AUa1DR9fjcDlcQOqPwppoV0ixh5lyjaFehinPgcav8mQmpSyfxEmYgW5xP/tW
         jFsA==
X-Forwarded-Encrypted: i=1; AFNElJ8m6TbS3sbSZxlZs1VhowK7kuJwBTo9MlCRebtX5tnvZrBj64klrq2CF+rnXu6Woqrb+Q4XwPA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5XA5OtSO+GGAXCnYB8bvQXclvAtm+IKJ6VVTjZKtuUeSFyK+2
	fNXqLi39eZc9t+4Y7gbzef8u3lDt12bKFWJByggRhP6FHSz2WC9iGP4CxExsgSVlVLBtPWy4BW4
	qGHZQPlgOZjmCPssMZTyD22iFmeHyEJ+/bxWYfMU2OrFqXZaIjvz2cLVN8A==
X-Gm-Gg: Acq92OH0XUd9kvUeJyF++QPjmwgkzRwxaOV6VuGEq2o+qBJxdCGOl7MovJWQAqToRvo
	iVu+yxWzZndLzE0lHk/H/q4XVTtniS4qz9ZVWLfvhGGq6O4ymEIEH8oFosXoD9DTeS1DWRz/1wP
	wl2Nj8rEXgZyrvHMjEjxKvtc9ke9YVCRpvnPW7YmzJIEEx+bukW3aHgrrRVIcencGg9IvsTvQ23
	AE2TedIiyM4uuc4OutantorP10q0lbsbs/lYYICFyoK8uBM36pPlJu5nXJRiJHTufi8QUQh4iz9
	JuuQT5HyGCjsJiSfq2xROmQt+zZ91/VlfynGqmjzL6GnoRFsSTNm6VlNnEf/GrbwUfBGBKwf5UH
	R4ydGOzdIvDkZzOl/kouETQG2gD86nqtPFJmNZBSUCflzaxVe9Dc+I/MmRolT8RvqlfMpHZbQlc
	VSW06S
X-Received: by 2002:a05:600c:474a:b0:490:51e2:d992 with SMTP id 5b1f17b1804b1-49051e2daa6mr324911205e9.13.1779895079648;
        Wed, 27 May 2026 08:17:59 -0700 (PDT)
X-Received: by 2002:a05:600c:474a:b0:490:51e2:d992 with SMTP id 5b1f17b1804b1-49051e2daa6mr324910655e9.13.1779895079227;
        Wed, 27 May 2026 08:17:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb549e79sm7283945f8f.7.2026.05.27.08.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:17:58 -0700 (PDT)
Message-ID: <bd69090f-856e-4996-a310-bac0456b1bca@redhat.com>
Date: Wed, 27 May 2026 17:17:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 10/18] target/arm/cpu64: Retrieve writable ID reg map
 in aarch64_host_initfn()
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
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-11-eric.auger@redhat.com>
 <5A95F33A-5FAA-4292-A8AA-9AA20B508A13@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <5A95F33A-5FAA-4292-A8AA-9AA20B508A13@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ruXUGeh_Ma_y_q3iY05XYP5cRqovUNdK-p_915HQp-k_1779895080
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 4:54 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> +
>> +    cpu->writable_map = g_new(uint64_t, KVM_ARM_FEATURE_ID_RANGE_SIZE);
>> +
>> +    ret = kvm_arm_get_writable_id_regs(cpu->writable_map);
>> +    if (ret) {
>> +        g_free(cpu->writable_map);
>> +        cpu->writable_map = NULL;
>> +    }
> I feel it should not be in ARMCPU state. The is a KVM property, which does not
> change for a given kernel version.

in cpu.h struct ArchCPU there are other KVM specific flags
See    /* KVM CPU state */

I agree we can eventually copy the result in ID reg structs but I am not
sure what is the best

Thanks

Eric
>
> Warm Regards,
> Khushit

