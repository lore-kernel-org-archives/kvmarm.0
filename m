Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2426E262FE4
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763438668; cv=none; b=Qt5Jat5x9OKIOqsMqNP1nowr5kWSadH7Cdf8ktqCVa4jYLUjhzbBXEnw2nlNTVGnkHel6Wi44io3OPY/fBfnY4PYDxU2yV2enLEWTe7U8gxkFjCGXi792a8P5UDtPgonM7yGOHUZcvCi5HlXD2eDHb/oUYCtxSLq/yzbLBqcBMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763438668; c=relaxed/simple;
	bh=ljbbiYERFeSOTRGaceHAzEEubwKLchVHrZZCtpHtoTY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NOnCC+wtUMCSYmKtQvyeB4E0Mb+wZ8s4xgG2BePQRYKOvluI/esKlIw93hcALS3focZjClsMpPu3BYeBV5ZO9pKizflL9RzDJYjsppuWVNAPJaAqVFclonWFexwFQS9OVCbICToYEipM92jzysZSBIrjSwWIH/o0kNPrJa6MxJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=tv/IHhae; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="tv/IHhae"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8823dfa84c5so55600716d6.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 20:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763438666; x=1764043466; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LIet07/lRHEtB6AmwUtzkeLdfdQoCqns9tuhswSScXk=;
        b=tv/IHhaeljUN1RieJCBrRlKSE9r6asFlCdYnWpIiN4On702TwlhkH7nYrq9bFPywc5
         j78+Af6kwy4K61+7ZKaaCsIV+udiId0CszR639lvasPsiujg2mn/ces7uU0zoUQ8Fh+I
         Igz4DAXxpxgZXYLV7363GK5fgrhXS46bqzHEN5KDf9UlucuL36mUaoVDlzBGOqjVVhuU
         KdXsI6jPWNMjjCWZbjZDHy2/YV93Rud5Jnm3Ut9oqTD1DQphd4m874NtBRegwFI+p899
         7J3zBBwC9XJJwvmgjRvmbCSP+MrLuE03rxFw4b+D9F5wOvq9T7krynfWDTpSc1ihFXi9
         VODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763438666; x=1764043466;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIet07/lRHEtB6AmwUtzkeLdfdQoCqns9tuhswSScXk=;
        b=xIanpKxCfxQESZMoWHQsIUnghgRrv0d0wU46r4GjzJosbCnKZ4W+gR2hyzMVChAkhx
         4SIvjbDYzb767OF+omvvpksBYGdYDuUGrtdwL3KQqXRAFkNzOpai4s5K/2lNMMxwFo4D
         PCqhaGHPtJuVLgwRuik8QH6VJyf/bQoKtv0SikppfxoZa59jwu5wRmp/WrpyFj4/dd/T
         +WY4VpYFBbyBXNTI9Vf6U6IZSOZQ53gzb4Rrr1b0Pl7upCbiyKXyzIokc5avqMp3DpyN
         bRgumhr+gb/U4b98p0OsyqU3FyRGYQPSGXJ7fIKk2Llok0hwQSU/HgIgGUeBKyN6b3cz
         6O0g==
X-Forwarded-Encrypted: i=1; AJvYcCWyoxf3NZn74qp+FcCPCtS16zYkAOuSwafePIFDUW5YC8vrYbeHov2ivGppOel4d0ZIJNwRRRg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoSfHk1qJgKcwxlnewVBRD8Vu2QUcg2tkdFi3+TUSOVo5WgbgV
	Mc1TWJNLP31W0xjSLum8iVZtzxf4+/AfNX9n75FwgAu4Yh2O364edI2N1B8Knp3YNmQ=
X-Gm-Gg: ASbGncteaG7Lus99yHSfcki+cc+VK45K+EAdCur0WVHRmbsTUChl+oTqKT5Tta4Y1Hq
	pcJGqicxn8Q9sIT0fRnjWEAOBG1XByuMbTZsa0Os7xXS2avlwKfutMT2LPojf4/xa5IyeRuH4rI
	8tUg6SFcBFgECL71FUtUZiWkpK/rQkjssfAw0trEp1EOLNsc5gVqkDLM/oedhXzgiVb4zcKfKCi
	KSh2TsWHncaWnjW7S1G6ERGHdomKZ0V+zcLPL5e2pWdf4ybJoMYjRi4Ad5BaVpISxsENs7cqh2J
	kZxfYKWGQWSmDMrkSVTnIIjdWi7tSriRiUeLO9M3xl2lcA6Qt5Dg5ezvdC0z27jNs7+hSpDD7vN
	pcFfZULSWAViyYv8vtpwEiqjpeamOC+iBvsZCMvdttQkPUxImKLG6KVQIL9MahfVdWwmh3jHDLU
	J+VQLihUMeOqwXbPJLaj9DeogRWtXrbdyRanyte/QBqeO2xPPLEcD7uPckJ+7PJCuzB2x8XrFEg
	41oclvInMrS4Md4kG52qXaepQzwqzXhrV6j0rgG8WRln4oa5HehJePX
X-Google-Smtp-Source: AGHT+IFy1GDWeEfH9CbsPtmLofTYHqdYBSwkguwrnMsd9CZfO3rsUWpmnvaCcZ/461CTJvepwhjkiw==
X-Received: by 2002:a05:6214:d6c:b0:87d:c94a:17f4 with SMTP id 6a1803df08f44-8829275dc8cmr215233066d6.62.1763438666005;
        Mon, 17 Nov 2025 20:04:26 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede87e6abesm97547591cf.23.2025.11.17.20.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 20:04:25 -0800 (PST)
Message-ID: <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
Date: Tue, 18 Nov 2025 05:04:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 02:47, Mathias Krause wrote:
> On 18.11.25 02:33, Mathias Krause wrote:
>> On 17.11.25 23:19, Sean Christopherson wrote:
>>> Spoke too soon :-(
>>>
>>> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
>>> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.
> 
> Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
> functions") broke vmx_sipi_signal_test too :(
> 
> Looking into it!

Can't see it. The issue is, the call to hypercall(1) does return in
x86/vmx.c:guest_entry() with f01ea38a385a applied but not w/o it. But
that makes no sense to me whatsoever. :/

Below debug diff shows the issue:

diff --git a/x86/vmx.c b/x86/vmx.c
index c803eaa67ac6..e49668f5ff95 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -806,4 +806,5 @@ asm(
        "       mov $1, %edi\n\t"
        "       call hypercall\n\t"
+       "       ud2"
 );

It also explains why the test fails: it's executing random code that
follows, in my case, __this_cpu_has().

Catching some sleep!

Mathias
