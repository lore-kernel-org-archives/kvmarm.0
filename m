Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E416418D649
	for <kvmarm@lists.linux.dev>; Fri, 27 Sep 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727441988; cv=none; b=WamM14bcOigWzqS19TqIdM56gS/j677eG3+7af5Z2KeEc4UnBrFxDqikBHa6l3nIceS5+6q+NCyBN/8LtZGCCmZKy+RckNOjHpH0JDxUoVVNczR/kOg1I8+/EcUFdIJEujDMjDTbd9l/2pdjMH2C0m+D4zgDLhLkshwvCe1LrI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727441988; c=relaxed/simple;
	bh=N/5CAZZeLNF2+HfMHtTAkzxMJvSlcbAphNSzkVwxVSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LtH7XxXuSsoQq5DZvDBJz2CvoS4ZXSZf+MyzH9aqBn6PZ0ILgGoJIFRcChN3R0Xz8M44md/MfuUCtnoYxWnT6YwST9Euxd1+8z8Gy4fRzDO8DhKHHcGw0WaL0ZZ6ev7JsxgN0mZDxE89FUzEa5PSs+bspIvYwlFc4ZIPZWCYISQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V+OGDq1Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V+OGDq1Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727441985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1cAYqNnznIpaL2OR+FI2hyJu8oZ8S20vf+FCtiXbbEQ=;
	b=V+OGDq1Z3Nw4AN7OmKk1mLshZ7igdN5mUIfwthXTuU6HIyb8LG58xPWPfcE9o4qnJSG+w8
	zV6Stu+Ar0CyFDlbQa8eVZygS2f70NCXyphntMxBDN2yJ5AgduD7K3YjaKcVwEc6gARTi6
	s5rVlb5hHTfmkrLAhDCl8/AC1SsXi8U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-qRGnjhuvOUarO6In85UQuA-1; Fri, 27 Sep 2024 08:59:44 -0400
X-MC-Unique: qRGnjhuvOUarO6In85UQuA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42caf073db8so17555745e9.3
        for <kvmarm@lists.linux.dev>; Fri, 27 Sep 2024 05:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727441983; x=1728046783;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1cAYqNnznIpaL2OR+FI2hyJu8oZ8S20vf+FCtiXbbEQ=;
        b=DT0aX7r4cOXn9OJi1dl6zkty/9U9x+jsG5sLJlFVLRbm5iQafbXd6+VEWh/rU7wJAu
         XdzFt8hKUPJdYawUhA49fp9q++95YYAafd87EYDIiLEg5Ktv2S+EMWBLg/PMLfoHI17q
         QdskfLn95YsmnEWkD3z9fTT7nFPW2ZqOULn/ANI/JEX/osgN4Rh/nPIqpFkkRNBebPni
         z1FI1FzEluTqpR+7DkoG+5f8qF7coa7FPf0p8uoYgD6SN2hl3ngtaUuTZxAPydqduApr
         zjxZ/UmkWBvwvIePaHhjDSvQjwu46fIRCjjtPSUGb8OE/55Mm5ljt+3X2ZM2u/pXtf4F
         uI2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcDe+gA459D96jvRzoBPzcXqtAhSL23a3TfyU6GzqtDcoSXktOktrVTK/zp7gIa3J2M5pReXs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo/3gh4i9G2c5Zt1T6jUXLWOR3zyWpCpwJVGH3ApFGI1ju8laS
	ObqKGbz5P0NgmC4u8RTcUgaeUSfek8O4F4ECjuhWI8DJL3cLviF/CvKLjl5BJ/HMjKK7EqAUkDJ
	rzY/gPGXtcrdOkXv/KEvbS70qBicN7eLumYBP7K1JPZzlxzR6HZPwfA==
X-Received: by 2002:a05:600c:3541:b0:42c:c080:7954 with SMTP id 5b1f17b1804b1-42f5849fb09mr25203645e9.30.1727441983214;
        Fri, 27 Sep 2024 05:59:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+rQp8YhBfzYRu+58aycmtGQdSRhM5UBylIOfB3fQV0gw1txRUPPMs5UU9KE8j67WB90/zjw==
X-Received: by 2002:a05:600c:3541:b0:42c:c080:7954 with SMTP id 5b1f17b1804b1-42f5849fb09mr25203265e9.30.1727441982705;
        Fri, 27 Sep 2024 05:59:42 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:8000:b502:8c1c:3624:99d4? (p200300cbc7098000b5028c1c362499d4.dip0.t-ipconnect.de. [2003:cb:c709:8000:b502:8c1c:3624:99d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd566a41fsm2476804f8f.45.2024.09.27.05.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 05:59:41 -0700 (PDT)
Message-ID: <813b9bcb-afde-40b6-a604-cdb71b4b6d7a@redhat.com>
Date: Fri, 27 Sep 2024 14:59:39 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use
 it
To: Fares Mehanna <faresx@amazon.de>
Cc: nh-open-source@amazon.com, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Javier Martinez Canillas <javierm@redhat.com>, Arnd Bergmann
 <arnd@arndb.de>, Fuad Tabba <tabba@google.com>,
 Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>, Roman Kagan <rkagan@amazon.de>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
 <linux-arm-kernel@lists.infradead.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
 <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
References: <20240911143421.85612-1-faresx@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.09.24 16:33, Fares Mehanna wrote:
> In a series posted a few years ago [1], a proposal was put forward to allow the
> kernel to allocate memory local to a mm and thus push it out of reach for
> current and future speculation-based cross-process attacks.  We still believe
> this is a nice thing to have.
> 
> However, in the time passed since that post Linux mm has grown quite a few new
> goodies, so we'd like to explore possibilities to implement this functionality
> with less effort and churn leveraging the now available facilities.
> 
> An RFC was posted few months back [2] to show the proof of concept and a simple
> test driver.
> 
> In this RFC, we're using the same approach of implementing mm-local allocations
> piggy-backing on memfd_secret(), using regular user addresses but pinning the
> pages and flipping the user/supervisor flag on the respective PTEs to make them
> directly accessible from kernel.
> In addition to that we are submitting 5 patches to use the secret memory to hide
> the vCPU gp-regs and fp-regs on arm64 VHE systems.

I'm a bit lost on what exactly we want to achieve. The point where we 
start flipping user/supervisor flags confuses me :)

With secretmem, you'd get memory allocated that
(a) Is accessible by user space -- mapped into user space.
(b) Is inaccessible by kernel space -- not mapped into the direct map
(c) GUP will fail, but copy_from / copy_to user will work.


Another way, without secretmem, would be to consider these "secrets" 
kernel allocations that can be mapped into user space using mmap() of a 
special fd. That is, they wouldn't have their origin in secretmem, but 
in KVM as a kernel allocation. It could be achieved by using VM_MIXEDMAP 
with vm_insert_pages(), manually removing them from the directmap.

But, I am not sure who is supposed to access what. Let's explore the 
requirements. I assume we want:

(a) Pages accessible by user space -- mapped into user space.
(b) Pages inaccessible by kernel space -- not mapped into the direct map
(c) GUP to fail (no direct map).
(d) copy_from / copy_to user to fail?

And on top of that, some way to access these pages on demand from kernel 
space? (temporary CPU-local mapping?)

Or how would the kernel make use of these allocations?

-- 
Cheers,

David / dhildenb

