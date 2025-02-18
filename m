Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0326AA94
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739893139; cv=none; b=e5ndz/c2d7JoSKRiVV02kdGcKA7K83g+54Ki1+kcpdVoVqyb1G8qg9JlIOl6E9ah+gEPe1NbMTQFkFU4J4/ZiRXSu98srxkRt0pOKU/LfTpXGzXgHFuz1xad5uTaUnMzd/g0VanxDvYQoPS4C+Qv445yYRZIQ/IQi49aU4TFaTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739893139; c=relaxed/simple;
	bh=9hOIGklkY5rGo0pEItCRO1euzttXEr3jpZ9Y02+FSSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XTh4opdxfvl17Ur9hv45kMWNgNSjOUEXERrkGRWm2Pcz7Ey9EBH6Wtqgi+s8TDQ0wuLlsaACV/0XOng6n2dR7kY/5gjEPT5Tm9yhGo5DrQ9uB1P6rtRxzlVaScorvvtOYzxbVbZ/mdDzO5sFUTFvYNs8CHTjgx3ExqLRgGEsJo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DhTW56uV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DhTW56uV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739893135;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6RSWJxfEGqes3umox+llGPyGNYXu5Aw8FHp2E+UoKk=;
	b=DhTW56uVrKv+cluen3DHNTV/fP7fNUjwP7uakRp2zwqA2RupNMhLnv9FHLCiLYddN8oCUK
	9cz76AaMbigt7/9zN2XooZ2awrzBtxHr5/M7m2ES2wCkq2/J5h5ARxLOH2nm8Q3en0XZ/l
	K0xtpsYpq0fSHaRbpb7uHjWiYGaI684=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-xWxutqzzMN2XWKb1yjlTsQ-1; Tue, 18 Feb 2025 10:38:52 -0500
X-MC-Unique: xWxutqzzMN2XWKb1yjlTsQ-1
X-Mimecast-MFC-AGG-ID: xWxutqzzMN2XWKb1yjlTsQ_1739893131
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43935bcec0aso46180455e9.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 07:38:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739893131; x=1740497931;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6RSWJxfEGqes3umox+llGPyGNYXu5Aw8FHp2E+UoKk=;
        b=DTc/rAPTYOnjDEeeQy30cpASBxXSdmdBinnzfrsGNpOvwRtYcM2DEyg/YpvQv5PU1H
         +HYpQaQx7X19Haubpmcij+WFGiUTVNJ7GmuCA7VnSzotSuvLsf8IpQNRNL5Y865adxJD
         OjXaGCmUxRw+23jAqxewIsqFm/NbDo/D6n0H9ZJxvjscudGWPb/GCh0sWoxTAH6CqNnh
         yyjtH9hG2pe8Dn0ta1Qjc8fI9y4m1rupu83dXJmgNMw1EhjXCHOK60VujrR6FzQOsU86
         WhCQwpiIL4ctT8AVt5dHXz+untlA6TKly71IbNwnaXtELaqm8wYJK8zHhwqolJjjMWg+
         uuaA==
X-Forwarded-Encrypted: i=1; AJvYcCW41FB5kPDdS/WK6gwr/kWJYs1gzo+nTpKV9lMiquURuD6Myz6QDLgEXojtK9OJNwPiEwx5S9E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ2rKdvmyCvY7vQJWNRZYLR41J18KuTNChpMdgS8lkhOHX4vzh
	439iWVmcPQdPPMgXpjgaeL7n++FhrlPhYLJRzP0PzSmNsmjbuEeas+n4D3lPAXa3WcaDLQKb+eU
	w0O4ZDwhrKvNCcGcbYYQXEMWsacKItwQyOQd786JKqzHb49AAmwsziQ==
X-Gm-Gg: ASbGncuaHmskq7glYoi4jQlQmw3R7b0jd8BiZUr9NB65qNoQRZSEOn+kc5Q8YV5rBxx
	gcYYd21+kYrWps8xW+zg01hIoC4t5MbbAx9Jso+4toE/BFAqxJYNHTRj2RlCdYK8DyxF+KOucj2
	51yffUWbBXl6Nn/aXF4wArrVxINn6U3tEUXnalvbXfpS3ppJ+5yzyYeCmC4HlkaC2s0DlzjRePJ
	2GovnSEtStHlxiUGQ0XrfQzjc9DC7tUarR0BQvI/6nfPoRJkFvMHIsYDKKEYqWyCJKgazMzk58R
	P+MFmkuKKMUDz5XUMQzFLxQIDPUnFdcaH+7hl0bfbzFOV0QwmDaD
X-Received: by 2002:a05:600c:4450:b0:439:916a:b3db with SMTP id 5b1f17b1804b1-439916ab5bdmr53775055e9.6.1739893131144;
        Tue, 18 Feb 2025 07:38:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0lXXYKr9Ztikg8NlradTIHoBc+AjlyWYZwDDRD7KWTu7PVtvQSEf4kPCeJMnHMcT0YHL+kg==
X-Received: by 2002:a05:600c:4450:b0:439:916a:b3db with SMTP id 5b1f17b1804b1-439916ab5bdmr53774765e9.6.1739893130745;
        Tue, 18 Feb 2025 07:38:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43959d3d5f3sm185943015e9.0.2025.02.18.07.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 07:38:49 -0800 (PST)
Message-ID: <884138d7-3b76-406d-8603-16eaa59deaba@redhat.com>
Date: Tue, 18 Feb 2025 16:38:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 15/15] arm/cpu: Add generated files
To: Cornelia Huck <cohuck@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-16-cohuck@redhat.com>
 <f5878231-79b8-4e29-bfb0-f9a57ac3f6a4@linaro.org> <874j117rnn.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <874j117rnn.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9mff7Dp5hdQboJobGSDu-JZpTQX_eLW6dNsDOumTRUY_1739893131
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,


On 2/10/25 4:20 PM, Cornelia Huck wrote:
> On Fri, Feb 07 2025, Richard Henderson <richard.henderson@linaro.org> wrote:
>
>> On 2/7/25 03:02, Cornelia Huck wrote:
>>> And switch to using the generated definitions.
>>>
>>> Generated against Linux 6.14-rc1.
>>>
>>> Signed-off-by: Cornelia Huck<cohuck@redhat.com>
>>> ---
>>>   target/arm/cpu-sysreg-properties.c | 716 ++++++++++++++++++++++++++++-
>>>   target/arm/cpu-sysregs.h           | 116 +----
>>>   target/arm/cpu-sysregs.h.inc       | 164 +++++++
>>>   3 files changed, 860 insertions(+), 136 deletions(-)
>>>   create mode 100644 target/arm/cpu-sysregs.h.inc
>> Why are we committing generated files and not generating them at build-time?
> We'd either have to carry a copy of Linux' sysregs file, or generate a
> build dependency on Linux. I think we should handle this similar to the
> Linux headers update, where we do an explicit update and check for
> anything unexpected that might have crept in. (Same applies if we switch
> to any other external source for register definitions.)

Yes this was the initial intent, I mean do a manual import from linux
sysreg or any other reliable source such as the JSON dump pointed out by
Marc. That way we are still able to analyze potential breakages.

Eric
>
>

