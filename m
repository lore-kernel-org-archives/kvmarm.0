Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4EE5464F
	for <kvmarm@lists.linux.dev>; Sat, 15 Nov 2025 04:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763182621; cv=none; b=ME6ntL9AzVCehJR1U4ei/aojHQCrLvjvPZy9UUogQW23IDMjfIpfQA5jLdrMeqz8RQTN75OjWXwwph1b6IgaoUUkVyZ1LI4GtzSNu7zJ6rRJ8TOlEdNJOxSnY3EwHVMCbVeNU5LU2M/FAUkAbMekcdAMp/rSHne6B2I4WknqoSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763182621; c=relaxed/simple;
	bh=Ue8W9wz7bNY1Oxv+sfUYzlidX9qH9jMkO/z1LnNKOhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gF2/FdACtUglXXCkTa3ynKqvSbePMMlcyWHK8QnvZ+Pdckr0Ztxn49upWjSC224KtJsCMYM5+I/9e2o38MjTdUeZNVszR5108q2tBxBwWhDui5dwK7eJ5Vix4RGzPrVRpKXaY7Il2EEDkf/SjYM46jm4pUuIgvmW0mf1KHe40/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=iOIhIPkk; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="iOIhIPkk"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477549b3082so22079305e9.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 20:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763182618; x=1763787418; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yQ5s1rExmV8qLnvUKMhTxOfSSYufGuTPKFcxFC9k02U=;
        b=iOIhIPkkyW/17yoPdc2HvEkKJPHbI7QNgjbtJcUYyk2xC38DWHtQ+UGG9RFFMgMskC
         F19jtUWvtV3cycKS+cIvaZe/pBv6nW8bBGashjcI3pjKHqLEO0vLaXH21YKMhC8u93O7
         7iOWha1/kVtwnjtUhd33a833KpKSQ8qp2mo3oOIMD7trFb3IgkyNnVhwKuD3wdAhoqxm
         hLevSy/8CM5NTdwouz2gUvqmI8tgsWq5dzOFdKT5E7Y45lJP1vqAyjXcegAI8pRKTIsO
         yJcy0BCFCA3p1ehGyXPwAv0MncToDuHCLAoFTF8eDiGb70HgHbiD12VlmlOjRPNP+Dhn
         5Frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763182618; x=1763787418;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQ5s1rExmV8qLnvUKMhTxOfSSYufGuTPKFcxFC9k02U=;
        b=Jz/6vmlTDDRhcQaxC7yM3+2kwPBIPFgehpbffHpCabWBoCUHBwV79mw//2LMuZ5Cba
         YbkPoxgoXb5roG6m8rQI3B/QdfDIn+W9fGKoJHfSvKIPY/WT/y2k2z8aM6O6NBh9GdQQ
         i9K5xFZmqqjc2OZ2Z3iAR6ej0LohQRaKxYgsRhHoVwdZHXlS95I8lTYZrFjJuAIworK9
         0XK3J/my5g2dxsf9LAIMqGqCQ/wBrGUgDvW1NufTRFW7sSLRNtlRBgW/Bu9mw0hHPNWn
         gMR4oT1GXZg+JO1uKMRLQduqhb+DiFS7oHLhufQHbelTywyTmbW+PGdGsG9IBjnRZSzX
         R/+g==
X-Forwarded-Encrypted: i=1; AJvYcCX9FoYCig2OOQ3dULN0vAdJ720FUpVRCAphyjUs8O3q7Ipgis73dHD+4lTv7Ol85KphWFl27/w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC9pbk1ujh5SkMfGXRURkEZgGcuUrEURv3oUv1E3Gj3DgnlUqm
	FY1FvQmDmQc42UEW1Ve/nzQVV+0Wyj50oO+JAP+XpSP99LADq3/e13s4KoDPPFNVv5I=
X-Gm-Gg: ASbGncu999jbgHMyovjqFfntTTJSjRI8NWvyueF4JZVbCTf/gBGQZceWytW+T+bdzc9
	A+pYx4bvcswiO+bewX3QIOU6WXr/NVJYq99/wioHcBxe7ppexR3FrVr2ZzznoMfpV+zE7WRZmGY
	5OuXQK5ycUwilr1nDd9cxGDmr4dOvRHzTgnBrklFYcvQzjr01Aa+pLWUepUfjDGH6mBWocSs9NF
	R0grvMc2a2Y6ZLEE4wLQDQ95QFC2eeVnysfaT+rBAeaYZ4ba9xtxV7nDDcNYPWWXFax452/98gm
	LeUMgWER9EjcDHNI4egJfgvqDfNgwn9b3y7y1zCgpy0F0EilWuNJWX8OPHTuNu7E0He+KX/3B1L
	7IkgxhhNXAxjz41ZLkEFoU8Kt95xp+k8qz9bg1uqRoDdJDMDWBZOhrMuvXgWjMda/lYdVvNlCeo
	IOb74jBxTRc3Z6Pm5sUIacnM/bJlYWitDaDvtAa0YNIReWHL3hgsF6S7n/CCQWb0fj5B7Izhndd
	hiUAJAAKq5DvssRvkYmIEALKjODpaNH0yCNi61TZnySrA==
X-Google-Smtp-Source: AGHT+IFfYKxHq+8CrgTHwrllYhNaYxZwba+UfoQ7YL1zovfcPCVBHzTrJpu7J+qt7oExABqAqeDw0w==
X-Received: by 2002:a05:600c:3586:b0:477:7b16:5f87 with SMTP id 5b1f17b1804b1-4778fe121famr55216465e9.0.1763182617554;
        Fri, 14 Nov 2025 20:56:57 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477975022ecsm23159855e9.4.2025.11.14.20.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 20:56:57 -0800 (PST)
Message-ID: <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
Date: Sat, 15 Nov 2025 05:56:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <176314469132.1828515.1099412303366772472.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 19:25, Sean Christopherson wrote:
> On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
>> This is v2 of [1], trying to enhance backtraces involving leaf
>> functions.
>>
>> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
>> fails hard for leaf functions lacking a proper stack frame setup, making
>> it dereference invalid pointers. ARM64 just skips frames, much like x86
>> does.
>>
>> [...]
> 
> Applied to kvm-x86 next, thanks!

Thanks a lot, Sean!

> P.S. This also prompted me to get pretty_print_stacks.py working in my
>      environment, so double thanks!

Haha, you're welcome! :D

> 
> [1/4] Makefile: Provide a concept of late CFLAGS
>       https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
> [2/4] x86: Better backtraces for leaf functions
>       https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a
> [3/4] arm64: Better backtraces for leaf functions
>       https://github.com/kvm-x86/kvm-unit-tests/commit/da1804215c8e
> [4/4] arm: Fix backtraces involving leaf functions
>       https://github.com/kvm-x86/kvm-unit-tests/commit/c885c94f523e
> 
> --
> https://github.com/kvm-x86/kvm-unit-tests/tree/next

