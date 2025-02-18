Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9AB26E14F
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739894013; cv=none; b=g6AaDPQU4Mo5jJTZutTqrGoadP2qj2xcIcRDZFej01+bLZ2XdspT+ONs3GCXHBZWxynMKHtpItu21RG4319JgmC5WZeI2ZjVWpPhjBqkZ7vtgQKwQ8pxmxiA0+0lNiTnt/GOa1Eeur0g+H0fEw6MfCNR5DFaVpXyf2kaDSYrhME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739894013; c=relaxed/simple;
	bh=0MrY0o8q7SSkfv+KE4Sd4GzKDRGangjGr9ENyIlSpyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gqS8xCRv+9/8j8aPbLTy2hCWDv29oZc7ZVCcWaR+ivySrnHPtHaSPWbkZdTv0H6mbYUaGqccEaBtetRshrhRVc1TyU3jdfuxjBDzxmYupxnqadq8Ggn96NHintluTYaZbMRCsVbXrYWyVv7S7uZlqj+pWE5p8jksSn/k/VnmfQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AmPN98Xo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmPN98Xo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739894010;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0MrY0o8q7SSkfv+KE4Sd4GzKDRGangjGr9ENyIlSpyo=;
	b=AmPN98XookE+ssswx4dGzhq311AjCbGOmV7RoZxRoyLByFG2josChNXvZbyjxyut9FvkY1
	pxvxf1NId56WMC1WsP1YfB6fgkiyc2kgF8ujgYVmntjd+lxheQgWHS9xOlcITuhy4rLKxk
	fe7HaIjEg4hP+bEF0a2Cgg387i4qT9Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-dqiazK4HOzudSGXoHYpjgQ-1; Tue, 18 Feb 2025 10:53:28 -0500
X-MC-Unique: dqiazK4HOzudSGXoHYpjgQ-1
X-Mimecast-MFC-AGG-ID: dqiazK4HOzudSGXoHYpjgQ_1739894008
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38f3eb82fceso1313966f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 07:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739894007; x=1740498807;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0MrY0o8q7SSkfv+KE4Sd4GzKDRGangjGr9ENyIlSpyo=;
        b=iJQugreKI7YvVM0wKv/SIynAz+ltPKdlmAHthvss4xuriZlNDz4BOYIpLxrXp4PzRW
         9athlWLj90KjQyHAjmXc6H/3dQdUPJICnqMiKrEa23cHMeqiKNOfmAtBYx1r5jDZBcZF
         KgSGlwDSz2DLIdrKjbZ3IYI7XYR155XVD4IQeZziPKBUhw5tewom5nbOUZI4klTSismP
         Dh5M1axG5iQBjetUvI+/okkSo5CFok5FBe3r2zHrS4XX3WJfhyAQjWIbvHsRy2DIPn38
         ulvdKhdqMzV2I01n4bPETgygzee9D6Yow7phNXxBFrFIcjuo8/tZ147zLh6k727mIAOo
         7JsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjZIwSpUiewaixh1ajS9JXkmNnbBAsWgWRqiLDrazM0wqGHnpswqfpxO69CyFJOWRxlwQoGiM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXU/CrzDmPeONxzFe0/YoXhhc1wy8z3xPQa0r6LdCtn6UaBIYZ
	yICS/pW4wgnXMDdjb6dXyDUH8mR+zmmLJws632fMPRPxUVoVZAL/8sYm0y2JYBXUEwmyEzQW2r7
	rg+0VmP8vWN35B+bJ5m7fiEtZ2EuwFn5vylbDdyDudNEhpGOcyz6z0A==
X-Gm-Gg: ASbGnct5K8+MERKWUsDjQTWgqJyX/Jj8rTlcEG2JBgXDJWJ8lads0kyd+Ze0vN+G/p0
	CcHRog87FwKKGVwQTv34VnumEpTBaJZKmSMlPQTmqp2bdcQvfp6/4gufPIGXEXwDi3rZa+ve6tv
	BAJJvwv66AU41rvamiPUxw5+bYJoU+5LAzGU0sX/B7TWTaGqTGzdz6GdO3zUsY2K7COU+49kpXg
	pH7S3L38jFCaoBENiELt/nlgUWgglNyEyW7bPtaBj6XuekGz2xdttda8TSs9r1W507PPvFD9Ge3
	HABkrGwGSKuABT2z18ZMdWuhxjP4K6jcq2QNGJ4SBoK66BXOMv6R
X-Received: by 2002:a5d:64ec:0:b0:38f:47f0:e7b7 with SMTP id ffacd0b85a97d-38f47f0e871mr8711191f8f.16.1739894007643;
        Tue, 18 Feb 2025 07:53:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEPdn89bxLQwws9Y3KfLy8aycIDZe1kRyr39nkzm3i56eOV6/acpHmTDq8O4gtGlMao/TcsA==
X-Received: by 2002:a5d:64ec:0:b0:38f:47f0:e7b7 with SMTP id ffacd0b85a97d-38f47f0e871mr8711089f8f.16.1739894006013;
        Tue, 18 Feb 2025 07:53:26 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f8115sm15569779f8f.92.2025.02.18.07.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 07:53:25 -0800 (PST)
Message-ID: <07bed04b-e000-42d0-971a-53d96344d658@redhat.com>
Date: Tue, 18 Feb 2025 16:53:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 03/15] arm/cpu: Store aa64isar0 into the idregs arrays
To: Richard Henderson <richard.henderson@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-4-cohuck@redhat.com>
 <1af2d33f-c876-4c23-afb8-be63447960f4@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <1af2d33f-c876-4c23-afb8-be63447960f4@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qYXy59jRv3d29JyXQ7V_zShlAyib3cBdFMYm7AIJmx8_1739894008
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 2/7/25 7:46 PM, Richard Henderson wrote:
> On 2/7/25 03:02, Cornelia Huck wrote:
>> -    t = cpu->isar.id_aa64zfr0;
>> +    t = GET_IDREG(idregs, ID_AA64ZFR0);
>>       t = FIELD_DP64(t, ID_AA64ZFR0, SVEVER, 1);
>>       t = FIELD_DP64(t, ID_AA64ZFR0, AES, 2);       /*
>> FEAT_SVE_PMULL128 */
>>       t = FIELD_DP64(t, ID_AA64ZFR0, BITPERM, 1);   /*
>> FEAT_SVE_BitPerm */
>> @@ -1252,7 +1262,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>>       t = FIELD_DP64(t, ID_AA64ZFR0, I8MM, 1);      /* FEAT_I8MM */
>>       t = FIELD_DP64(t, ID_AA64ZFR0, F32MM, 1);     /* FEAT_F32MM */
>>       t = FIELD_DP64(t, ID_AA64ZFR0, F64MM, 1);     /* FEAT_F64MM */
>> -    cpu->isar.id_aa64zfr0 = t;
>> +    SET_IDREG(idregs, ID_AA64ZFR0, t);
>
> This doesn't belong to this patch.
Yes my fault, ID_AA64ZFR0 handling can easily be put in a separate patch

Eric
>
>
> r~
>

