Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3F030DD28
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 11:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763466978; cv=none; b=s1FgqZGlB0unt83Z9fl6sZSEhDpp7eZwx86zDuf8U2HqvZbTp2yI1qxOrecMRcjU7gqccO1Y0Go5Sd5sP3rV2/RQOcPei0SZBkwNlUZtx9xFpPkSQGfS3m2lJmweBUvVuliUCPqav+qfqt/afJL7Tr0mB2NsxjEuGGAWVjMwHkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763466978; c=relaxed/simple;
	bh=qzcZIddEA1VxDvQb9GkLctVL+UH7omrMWlZmQBeGfaY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PSpSTz4rgcO7bztwzrtjfRBEeh0NRAIzPT7oWuyws/MAAkEJCJ+YCM7Nwz/B+fIUHhEJmmFoh0UdZ8YHYWIl2HPzIVU12tXhbms9OLJogkJECO63rz96yxGjM7rrAy+h70w8RoHBw0xsxORWQKP3+TvWvLHqBrufv3msHo0ZWXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=cFW2V9q8; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="cFW2V9q8"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8823dfa84c5so59539056d6.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 03:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763466975; x=1764071775; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LQRr7ykcKRuQ2H+DZ+tTFQTOL6/+JF18/rTcAWF2fUE=;
        b=cFW2V9q8PMEhg1aBXeFuJFHYES1drtBpH1ynCsM4UpaPo6JvV1SOmbsRLyI5kvGKoq
         FBYnpB6kBErxgQ/zD2qoQURYKuNCGClh6kAMGP5RmzHrltR0QayzhYVsMhYyY9sEzg6b
         /5G48/LycLzlqdSqMWFS+UZIDENAggLx0Vueb0CvduOOtlhg1jdu5jO/uSxgUWnQIPC+
         QmkIJh1p7ZiGYdFRt6Vzi5ebj80JpuWIIFmXstgoSbYOZc0ZF+UuMmfNZ0SjyKj+3Ydl
         OVOb5lD4dj8hPGTbsahHNvR90vQNuxWWPipnwsowN5oMywz1lIu52Hi54HTFgOmkSmjZ
         j3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763466975; x=1764071775;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQRr7ykcKRuQ2H+DZ+tTFQTOL6/+JF18/rTcAWF2fUE=;
        b=Dk9hJ2Cv90X08YCTYiRFIPL0Sn40mRmVdzXEY2MFEuRzbGnNluoxeiEVwSwZuZwC7i
         xG7HlXd6YFDzfW3Av3vZyzLWMxEewpHj2iIjgTLBdoNR+Ix3PStEUeSZEqEEIFOd5RWL
         py/XjdESIGLj7zaiHNXyun5xAVBt5pnuxWqvvwqKpOwwccECPvFzl6TEDhSgkbCJn+zL
         qbMUzTJ3tyYX5T4alBgeL8BlpnE5upq2Dk5TpIDS0Fp1cMsOuafSjbyM71ACG5qdKA/V
         PBFGDCoghVYL9BduMe0uZjgoL/Nv0jK2s+cpYljlqqyLR9nS3SOONwAuUX42svuR/YDW
         0PgA==
X-Forwarded-Encrypted: i=1; AJvYcCUdAxWMgsdWIAr09kViFlJnA10Y9Csl8XNWxeHQQi4mkV+KfYzfN7eWMZPmNkbn/7GCzP+gEZM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvnlcxrBbwV2cZSFhOud8/3WzlHleacMMytQwX5iGHQy3X5Tml
	nJsVEUmlDYDrs59asqrQioD+M1SQucugbyA1doOxKZn2D3UDkt+TSbCMHCMNHIz6mkQ=
X-Gm-Gg: ASbGncs8a2MflGls9E07NjTDbFGvdls9X1wl94H3gvWB60Rn5gRz6BC+Xjrmxwb0uHi
	kkg6tFcu9Y0AU2Z94iLi6Plc7eYCxUKPUdhu6+P/RVqdMdc1D2exVCDTz8n3z6T27PON92ceeKs
	RTQyak9HcTRVEWLsoHIpBx+LzNsxD647UpTrMGQlRfxgloGTgMA4w+dbezxqJbVdOIgFWESdDT1
	Gp4Okph05NXZMSTycd21qjQgpwFTu+ul5kGyG7ON9m26qxdYG6I2csTfCPR1sdwHcJWFEOlPFDp
	hNVI4LDVeHmgxqR+ulmyQD4TIaDr1CvmygpqkkDARvJNSWIYDbnwFQK/rE9toxuN8KFNm+Tnfb9
	uDVUg94UMQRzTt3Xg06CWKC5KwYjy8gfw27udHS/dKNrQ/G9cceDqg1wGnCOrP7WvbqE1EkAJK3
	JBKxYjv0/FZZYhOeEz7zxeactDsZmbHucvWPkjCVQ1vvaR1MQWQwEz3GZV/tu9o5JqAzTJz88WE
	37wluJ20JUgZE2nMeuL1PbHRzPervs3F0TtuYtGcjBDUPwoaeQDchOpD0Njkhfiu+w=
X-Google-Smtp-Source: AGHT+IGAMniWDVOnPyf6j8g6qorhYih+6sXf8RQPPiUffUe4eSaS7J46wfc1A0WuZcSwDnIsjBg/EA==
X-Received: by 2002:a05:6214:21c5:b0:880:1fb9:a30a with SMTP id 6a1803df08f44-882925ed0c1mr237008176d6.3.1763466975446;
        Tue, 18 Nov 2025 03:56:15 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-882862cf6d5sm112908506d6.11.2025.11.18.03.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 03:56:15 -0800 (PST)
Message-ID: <8a42b563-71b7-4bab-9f1d-248c81295704@grsecurity.net>
Date: Tue, 18 Nov 2025 12:56:11 +0100
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
 <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <d67ede24-0b75-4bdb-bdc9-272b9608f632@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 05:04, Mathias Krause wrote:
> On 18.11.25 02:47, Mathias Krause wrote:
>> On 18.11.25 02:33, Mathias Krause wrote:
>>> On 17.11.25 23:19, Sean Christopherson wrote:
>>>> Spoke too soon :-(
>>>>
>>>> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
>>>> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.
>>
>> Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
>> functions") broke vmx_sipi_signal_test too :(
>>
>> Looking into it!
> 
> Can't see it. The issue is, the call to hypercall(1) does return in
> x86/vmx.c:guest_entry() with f01ea38a385a applied but not w/o it. But
> that makes no sense to me whatsoever. :/

After some sleep it makes lot more sense. Well, not really, but it's a
race that f01ea38a385a, apparently, makes easier to hit.

> 
> Below debug diff shows the issue:
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index c803eaa67ac6..e49668f5ff95 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -806,4 +806,5 @@ asm(
>         "       mov $1, %edi\n\t"
>         "       call hypercall\n\t"
> +       "       ud2"
>  );
That hypercall call shouldn't return, as it's HYPERCALL_VMEXIT which
makes vmx_run() return and not re-enter the guest. But, apparently, it
does so and it does so because the guest/VMM shared variable
'hypercall_field' to communicate to the VMM what to do can also be
modified concurrently by the other CPU/guest #2 after it was written by
CPU/guest #1 but before read by the VMM. Bummer!

I'll send a fix in a few.

Thanks,
Mathias
