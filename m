Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B718B3FF1DF
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860015; cv=none; b=JRwJ0vLBsl50D7OkInJW1IOp2E9KCyL0P3F6DkqUv01zO+iW8TC/2UMaxD9m3cd0Idlaa4pAZ8sewUqoxJ4Pb1QULAWC2flRIjVoAkacHe9CO/Z6ADUJPQGqlVK0M9hJIBUsSQp8MGRRGy1zwWiNtPnM5CFuvNh5NpC03LUq4oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860015; c=relaxed/simple;
	bh=zBh0hDgA6QYoTLs14yCAqGpDJ2D8zeaqoA557ZD9m8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljm37L3b23XpFlJ/3y9hQVebXXH5MWnrdNMoRRzRqCz79rPc9BnMQxxa+oWy+NN7IGQN8phlf2Lw7rsQBUb2f96pYeBeWQHB8IUScY5TklKrkZ4+Ha0EYBKaLKiPQ4gWlGwgN0Y4AjGbF7kkwrUBdEQFmXumpriDPQagyke0pV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hIecpRQs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hIecpRQs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778860012;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YvOUScZZ/Xv4TAXhr6Aj3DCRwHhk5SYpQlDYhFoqcQE=;
	b=hIecpRQskD0Ublyhw7GM3bvRhhyGsvzd27QIRd6uwK2KU72UZNn5DpIptrzjOm1UaAdCxO
	dOtzYVRqQCBP2E++JEJ3qx/fVoIt3OoQvWl8zBcyjdHhq4PTc2G+SHZdsNSJ03AVLZLF22
	xPturAyJNgerT0D+BMvTlhyMdKnXx1M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-yYmVpat1OA27V5GQkdpacw-1; Fri, 15 May 2026 11:46:51 -0400
X-MC-Unique: yYmVpat1OA27V5GQkdpacw-1
X-Mimecast-MFC-AGG-ID: yYmVpat1OA27V5GQkdpacw_1778860010
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48feb8b9acfso5039575e9.3
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 08:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778860010; x=1779464810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YvOUScZZ/Xv4TAXhr6Aj3DCRwHhk5SYpQlDYhFoqcQE=;
        b=k5fKjGkdXX/w4OjYjIH/NXDnkFMFj8KTC5Q8sjdCOOFZUMc/PyxSEvOvdFHj48tGfN
         a23KWcHsyJvHN3AdcGimZgByDy5lAxAiwMXeWmc5WecJL5aPhBr333Ce8Zzs0UZMdmBq
         iYVa3DicyQz7DDvYrX+xGgzpA02v+lMq42VrTQ27rFfbOSJFSFEwHU8iffw0ypCquM6j
         kBI2uaMpZ2NyOGdUezwhn9opI+XUA3qI2wyoMe0l/oE5HW8M7ExEL2lr94tBW72wEd8V
         rNOUyPH+dI48R0MVg/LKUQMTixHezpM5Q5jcHb6k+meaLi3m/IvCnKh7DHsKecLFPwfc
         LxpQ==
X-Forwarded-Encrypted: i=1; AFNElJ9oNAhe1L3Rziz4XqxdQxRJE9EOuQlrExPvBWLRX9efqQQ5JsXPEYPnxbzkeWDF6INuu2A3RDE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy48pd/icxHoqLXfkgBHvnO3K1qi6DVd0lagq/zDgZJXcboh8U5
	LJnTn8V5mUap8PNLfNoPIyhdcNpUtyWG0MdXLffr8Zq6q6PIQYbT45i51wTADObpGrwbDQI7bG9
	OIb6NPjbFAcbNPpp+RPhwylkqaJqYl2B0Fk2Bn21TKQD0JtoVWhjS8sQdyQ==
X-Gm-Gg: Acq92OFDMr0N8JUaAU0WmXygsLnqCN4SDKqEFLDFSGWKrfujxkMX1l4lO2l8SwPKzTS
	rD1IpXMq12mPi0kRr1d1Ox+564bCWygXXub42V0Z33ogb8WuVa8qyiod4BLfNSTUxsyzOpvHRNs
	qEDBcPEHCJm4Y/N9xPEhmmQXTGjKhfvv6GsQPXdOY3OylNwX9EAwQomUZ7mH7WbTSnBTSGEVPvY
	7r8NXbSNnzrQ5TFeVmFcJ3LRpHAbLrowQk+2e+wrOoQuuntu52AQJqgmrE23+OZHsSPKxAEIYJC
	J7ddXTMcXCUWN1MngcadN64ayehI/7nl8QfsETTMXTUI3+apZZw6MowDtbYA8oxVqOLAEx7BwR8
	8cZZHDdk3dn3HyXt1gowKxj7cjbzoiil+uuOU+3oiVoEk/61ouMorU0owthB+B3HaquvdKQ==
X-Received: by 2002:a05:600c:8189:b0:488:ac01:72b6 with SMTP id 5b1f17b1804b1-48fe6323addmr69927695e9.21.1778860010029;
        Fri, 15 May 2026 08:46:50 -0700 (PDT)
X-Received: by 2002:a05:600c:8189:b0:488:ac01:72b6 with SMTP id 5b1f17b1804b1-48fe6323addmr69927295e9.21.1778860009715;
        Fri, 15 May 2026 08:46:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ec39ff1sm15937194f8f.10.2026.05.15.08.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 08:46:49 -0700 (PDT)
Message-ID: <338ec6f3-499f-4232-9049-17118209c05f@redhat.com>
Date: Fri, 15 May 2026 17:46:47 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v1 05/13] target/arm: named_cpu_model: replace FIELD
 macro with IDREG_FIELD
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: Shaju Abraham <shaju.abraham@nutanix.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>, Jon Kohler <jon@nutanix.com>,
 Jonathan Davies <jond@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-6-shaju.abraham@nutanix.com>
 <2a1eb06f-1293-4d6a-8354-445891ba36ec@redhat.com>
 <A84C8759-6EF8-4DFA-B5C5-A4381022F81C@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <A84C8759-6EF8-4DFA-B5C5-A4381022F81C@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DmklOMCC34H-wd8oMicy1HN-wpSYU_UxPLvQ2rPsGbw_1778860010
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/15/26 5:36 PM, Khushit Shah wrote:
>
>> On 15 May 2026, at 8:58 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> MIDR_EL1 is also described in 
>>
>> target/arm/cpu-idregs.h.inc 
>> so it could be removed I guess. Please check others
> I do not see MIDR_EL1 in cpu.h, both MIDR and REVIDR are
> maintained separately in ArchCPU struct and are not in cpu.isar->idregs[] (or is duplicated).
it is defined in cpu-features.h just after CTR_EL0

Eric
>
> Warm Regards, 
> Khushit

