Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05933FADE7
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540160; cv=none; b=h84MSVb35upeLdumRd659Kue/x7k4qKzjU9jdSHyeOlG4DOF7e5Pu7sxWu1Hxw2VY/WqUKc+I9L4qMvGz091OqWjnrk8PIAj+BGaQ0BbHceHz03nw3s8FvMbfuBwq1o//fToVOPjgME0m/QG+StuGkFfcLlM6u2EvFcjMLV/x5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540160; c=relaxed/simple;
	bh=hTtlP/QqSsUw2EpG04vwnXGEzoXHtHIDItfhdWtKU7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=APjwZwPI5UpRJsxPxmphGbPgENAXZGrcZ8G8Efox62yLn7NvVbjgjum+66BjhBHsX2ZlJdVgYYW9U2bj1eiD3o48O/cMEmUDGoO1EMOSe44iz/ewkRFZK/b1oNCl9HLn4Jm7bv2KuRDOmBj4B6csDjy7ix+4M9sLk8cTwUf1WDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y22rYQgF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y22rYQgF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781540157;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTtlP/QqSsUw2EpG04vwnXGEzoXHtHIDItfhdWtKU7s=;
	b=Y22rYQgFO1uzI2VokN/SM2sHRDRDj10bm8XE5/qyUjaSy/xGfZlBuA6n9co9WvnFMYdv7F
	luZ7P7gh2kJgrHAS9wv+CahJvmz9HBB9DaAi14yTXNJ3j8rX0pTW0qZWYXaWgv7kqIWdzi
	Puh4MHvTUdBqXtGPqoCfRho/CCixM8Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-NpG_a2wjOwG-pRivOWCXuw-1; Mon, 15 Jun 2026 12:15:56 -0400
X-MC-Unique: NpG_a2wjOwG-pRivOWCXuw-1
X-Mimecast-MFC-AGG-ID: NpG_a2wjOwG-pRivOWCXuw_1781540155
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490b93debc8so35605215e9.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 09:15:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781540155; x=1782144955;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTtlP/QqSsUw2EpG04vwnXGEzoXHtHIDItfhdWtKU7s=;
        b=o/lFyYWEJ3Fivb7KC8Mis6vBJaJvG/HtQlDE1YxGtFOQcZTq1hrioUP/WeJIN9xPTn
         yaPbhatFqz2KhYrPvZvFzyC7E/O76eEsYmfq2np3ffm+b4ujyOuJi7t+QNTWwyTEcBMl
         i/AA/YVjgDZa2QCtZEmG9jfLvaBmy+7GDeD5trpQ0BKM5PyJrrzeWLXdi0d0//bcxEkB
         RfY+JKda0hNPwMnw34KcufVH2lG+nbswCmJ2/AWOEh/fTWR14nmOsSvyNYpYmrC82+US
         fRwmjkNeeS9vCA5HQcipyDPJqpi7XTJhAOOSjR3c6e65qu55uImmXxR/McG9c91ZncQ0
         FV3A==
X-Forwarded-Encrypted: i=1; AFNElJ+T4hlZZcQGsMg+qwVT/itVbJxV2eoFrvCZAoI/hS+x6cd+J32xAGaiNbmmyvf0jR8/c4vC1Sw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzRKmy4cc26PKL9KOeSllj5bDAcCdyzino70R0yfA0fjGyy/yM
	85CanfQopwsW/uG7MSel//rUGTRKfV09slzOn0UzlcldAJH3flj73vwoRYJKnHqV2IcbPiM/dW0
	TOFeb8FkKJSPQ9pYwcE+AK9TeQSqwka+/2LZPtRPNKpmeiNg80e1LsGjdGg==
X-Gm-Gg: Acq92OGs+JDKHEFv1Pj+foGRP5EAbU00DsTWzZmwTGL9cpQmZ38Xn37tvGEZF3FO/Le
	rO8Cgm9hzrkO4leQ+r8LwuI2Pxuxk4S5jL7Pq6PiSqOKDkqjDSzoyw3kZeeHPkgrVFL7wZvnQ0Z
	QWlcI13AUKt7cgCH0pUDoxYVpHNQkScocQKnT2TjNJL9QmkVZd3WYRKVhZscSHRwJbYLEWLoI8k
	rTTHgoSYV99G3QbI1d+qjI2/316wnTAUMh1Nzv3grnYpprdLsHAe/kfYcfEuOevpuW8gW9cnaQu
	fLG9cbtv3SthsQ5OAdVOFaiS1PmfRTM2TGnNFHyNaxGKKpV1fo0b5t85eGUbipNY59xAhxjHQoP
	dRUNYygiGG22dRHKmI5WlylCjfJLBSPPFTJhwAwHqIUL9Nj8jgWvSZH+eI24Bb3YDHo+vTA==
X-Received: by 2002:a05:600c:6d8b:b0:492:1e36:bb03 with SMTP id 5b1f17b1804b1-4922011dfd7mr118353015e9.36.1781540155114;
        Mon, 15 Jun 2026 09:15:55 -0700 (PDT)
X-Received: by 2002:a05:600c:6d8b:b0:492:1e36:bb03 with SMTP id 5b1f17b1804b1-4922011dfd7mr118352165e9.36.1781540154539;
        Mon, 15 Jun 2026 09:15:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c10sm36563089f8f.21.2026.06.15.09.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 09:15:53 -0700 (PDT)
Message-ID: <a21e48fd-c614-4bcd-b5d3-9e5a72a9343a@redhat.com>
Date: Mon, 15 Jun 2026 18:15:51 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v2 00/29] target/arm: Named CPU models for Arm64 on
 KVM
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Cornelia Huck <cohuck@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Andrea Bolognani <abologna@redhat.com>, Jiri Denemark <jdenemar@redhat.com>,
 Gavin Shan <gshan@redhat.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
 Sebastian Ott <sebott@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Jinqian Yang <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
 <eb5f98a0-1fc4-4a5a-839f-8bc3afc44165@redhat.com>
 <C0A0943B-12A4-40CF-97E6-BF272A61AC36@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <C0A0943B-12A4-40CF-97E6-BF272A61AC36@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BDtyAm1exkPmE33Aj8XIsaEqggDRGQBRumys9yHOV64_1781540155
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 6/15/26 7:45 AM, Khushit Shah wrote:
>
>> On 12 Jun 2026, at 8:20 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Please could you share a branch. This fails to apply on mainline due to
>> recent changes
>
> Here is the v2 branch:
> https://github.com/khushit-shah-nx/qemu/tree/upstream-checkout-2

thank you very much.

I should be able to send my v6 on Tuesday or Wed.

Eric
>
> Please do let me know if you also want v1 branch.
>
> Warm Regards,
> Khushit
>

