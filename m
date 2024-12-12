Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D28211A0E
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734012743; cv=none; b=kPtc6bx6ZoPJkmB8oH5S8dN7jliDAf2RBKTHOL9q9t9RuvHc0vRZ5cEb9Gzi91zi2f69NjHt7nI5Z7dy5DSmScaFlVt2npfiBc2fce0uyy1H6xStOaydzNu6P5ri8lc3V7R7tVuRthH7K3fpmEDhIitzUXRmjGAa9GjyQKF3DzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734012743; c=relaxed/simple;
	bh=lNzM/5KHaOdjwOXaIll3vIt6zX42tMOo69nIstNet+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EbC52S7nl76fo+I1viYtc7DhBReBrRB9lmUB/uKf97vf3PFwQ5E7SO6q48nkBcnhYoRvuaR2S91R6CaQn/ERhAfWLLQFZJBkVqr29BFTaSX5Yz0+HarPC0rY5WaXmZhNPpNELVWNgmc32Sm6yNfCYogicIvDqJTsYgCqlzEZHxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iysdQTE2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iysdQTE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734012740;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNzM/5KHaOdjwOXaIll3vIt6zX42tMOo69nIstNet+E=;
	b=iysdQTE2bdsKOFs+uXCbXxyhnXJG7xxknE6yy0d2IB6waznL+Z2ds/WCaKGq7znggoHp5V
	U9xilxPTZOVs0kirsFTa8s0PkJ2WCpHDbVsPwvrhoOaqjoaU6bJbUiUmSDzcuEdV8k4AGN
	vmODWmyvm0XjEkansbvVpsEEC/GT/Vs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-osn5nVihPOe9-JNDnuQ4sQ-1; Thu, 12 Dec 2024 09:12:19 -0500
X-MC-Unique: osn5nVihPOe9-JNDnuQ4sQ-1
X-Mimecast-MFC-AGG-ID: osn5nVihPOe9-JNDnuQ4sQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43625ceae52so3853145e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 06:12:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734012738; x=1734617538;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lNzM/5KHaOdjwOXaIll3vIt6zX42tMOo69nIstNet+E=;
        b=jK7EuuWXwF2U12KYCuC3iZn+lmRRo7Q/S0+bgWPnNSCwLySyieLq6522x9cdMLiRFo
         gaUQVzY6dH/J9dTRIyCeFX88ef81/ruRvzI5YqsuTuGW+y75WDnTR+2z0pKvN2ZdlVn6
         HquubBpuczs9domQaY+35GO2RSD+yxemTD/o579pB+jFORVMY22RYn3vxcuwA1YT1J9Z
         map7Di00OYW42Hu53B4iQIVqWnaMWdg0vMevvipy1jQyS5XvqSnHP/Q3r2lPEzuai7Qz
         icYqAIVn4cj6x9RXghW8ce94+awrPn18IZn7BvZ/qcKiCG69OkjYBJtrzVOXCG7ROQxG
         Srag==
X-Forwarded-Encrypted: i=1; AJvYcCUr1LbEa/7SuZazZtlVu70Fh77jcJ8RbO2aU0I/eX0KZ/QRGRA3RRXTL/SdZ+M0QI+b6l2UA6I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx30L7aLbp8EdurPSwVK3UzyB4TlyqeVIVh9+qVrVIZU9XVaJsg
	8fqnJ7Htl4HVRKBYELKifvEvP7NacVfcbJJEC+j5XNO5JYaxxXArGHIJM2+HZRxdDImqsRNzdnq
	L+QhGVDRfn1Psbmo3M92m+bkH6wppcMyCbIDm7TD5enfcGfFmi/hZrA==
X-Gm-Gg: ASbGncuMUCQMIUrn4wwIsO/HxRyrJn9bZEb11OkHTaHT+mMl8m+Mv6psu+z1zOvcbJP
	si+nwQKS3RvYb1zOOSx6bsjf5M0t10ZLhUipVz90WMxMrj79LjKXxQi95aIm8BG60qWIeivkzdV
	ajH7T1NNQdcMFNQLjuW+rkk+CEdwkZlEuooXFtvnM5Uu3RJB+pzUpfmy3rFy2U7O8wWfaPVskJn
	Vi3Yn40qK65eU7ZiXpegPEw7zDORdFUQL1Z60V5b2Qd1wpA9m1Vxs8o5RpR66yQ9ZJk5HkW0Oun
	LA35FwB/HewsOfM+tLlWHCaU7FLK
X-Received: by 2002:a05:600c:5107:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-43622842924mr34681945e9.17.1734012738455;
        Thu, 12 Dec 2024 06:12:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGU8Gkh/6x9u1nP/VCWEubXoDik5WGdtMCiI9rgLd/giqAVYpPerfHi1FsZqd0S62AvM7EIUQ==
X-Received: by 2002:a05:600c:5107:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-43622842924mr34677335e9.17.1734012733105;
        Thu, 12 Dec 2024 06:12:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436255531f2sm17862685e9.9.2024.12.12.06.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 06:12:12 -0800 (PST)
Message-ID: <f06b5f10-6ff4-4851-96db-56d6596bd176@redhat.com>
Date: Thu, 12 Dec 2024 15:12:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 01/20] kvm: kvm_get_writable_id_regs
To: Richard Henderson <richard.henderson@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-2-cohuck@redhat.com>
 <a1ad71d4-4148-42ee-b77a-fc4df1f5c2c0@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <a1ad71d4-4148-42ee-b77a-fc4df1f5c2c0@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IY4UX6Yu4bBZpzzgZQdfEN4OGtMMAvKHPplvcinvBFs_1734012738
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Richard,

On 12/12/24 14:59, Richard Henderson wrote:
> On 12/6/24 05:21, Cornelia Huck wrote:
>> +#define NR_ID_REGS (3 * 8 * 8)
>> +
>> +typedef struct IdRegMap {
>> +    uint64_t regs[NR_ID_REGS];
>> +} IdRegMap;
>> +
>
> Where does the NR_ID_REGS come from?  In particular the * 3?
> IIRC, all of the id registers are in op0=3, op1=0, crn=0, crm={0-7},
> op2={0-7}.

According to the KVM API and code,

"The Feature ID space is defined as the AArch64 System register space
with +op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}."


hence that choice

See:
https://lore.kernel.org/all/20230919175017.538312-3-jingzhangos@google.com/

Definitively we can add a comment

Thanks

Eric

>
> Whatever the actual answer, some comments would be good.
>
>
> r~
>

