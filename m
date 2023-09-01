Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970CFC15A
	for <kvmarm@lists.linux.dev>; Fri,  1 Sep 2023 16:46:33 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-26f9107479bso2482615a91.1
        for <kvmarm@lists.linux.dev>; Fri, 01 Sep 2023 09:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693586793; x=1694191593; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xCon5474F9WwphxhfgFhUzbwn0ALvK9xFv6P5Xz3AWM=;
        b=5Rj+G73Gd6P8uZJxphuODvPgl/9GSG7AOAVrH+5BG2dtu6dqDbVRFzj24WYZwwq5Em
         WXmJCegM3TwfeHVeuyxE+NIdw54ltVeecU4enr/AOWQmCA9kZBpp7bNuhhQq0xlhliSy
         2FwTlUP2xQQTFCuAWJbdKXH2MCRPTRDr/rtKUa2os+FZYXaOZuKPah8PslOfAjmroouP
         8a7mgEI2AHtl7SfmpJgHRiSL00sgKleA+AbbSVs8R3E8u0x/oAGBXd4sprVu9zhU044y
         oSIMLddG0MTQT2HWoSFZjf0fFHMoz3RTlDwH3JPkis6EHWwWF52kfy+OewO+eBCurh9s
         6MhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693586793; x=1694191593;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCon5474F9WwphxhfgFhUzbwn0ALvK9xFv6P5Xz3AWM=;
        b=BZgqcHIDo6OBQhX5AEQbF+yJKbUFHfPp5RNvdJPTBi+J0mTNEETXUd+EWlzESKMaOV
         1AZAzP4Nz+r/ZgVtcgzjfv0Y+owLac/b/ZIt5z08ldCrSK3Nej0oReaWh+dS7kEcXbqv
         Y2JyZ9Yu+/19OD/qr2ATkWlk/dS7H9d2PKfY/4q2Mxf37T37p+3BJe8qrIrsjomXFQ32
         lTrTdJ1yxjm/CUQmfB3XxCKdcYHUs1nukWZaQ5qlS/776o5kt/FpfqzSvx/BuFzvIYRT
         5iseOVwNN1iW+0cEsFgGqUDT3fsLeetIwT1x6g2yGz9ujaVI1EyHWzICeHjQk1RnevH7
         mVCw==
X-Gm-Message-State: AOJu0YwLL3+E0s02bH9jNUUcuERLLTv+Mt/MSRVUfQCwKrbjjyzzgyQx
	kj+ZCVdpElBuP55EjEE/ugXOQFrW5nlx1kmu7Q==
X-Google-Smtp-Source: AGHT+IE7IWuztjp33Ush39YmsLck94qkQHf2UcyeDE5trFHuf5V0W6HBwaqY0C7q2Vl17GPr3mAIvAb6tklgxvjU0g==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:e887:b0:1bc:e6a:205e with SMTP
 id w7-20020a170902e88700b001bc0e6a205emr1066486plg.5.1693586792693; Fri, 01
 Sep 2023 09:46:32 -0700 (PDT)
Date: Fri, 01 Sep 2023 16:46:31 +0000
In-Reply-To: <f7aaf097-6f83-0ee9-e16d-713d392b2299@linux.intel.com> (message
 from Binbin Wu on Fri, 1 Sep 2023 11:45:43 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <diqz34zxg7tk.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Ackerley Tng <ackerleytng@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, david@redhat.com, yu.c.zhang@linux.intel.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, chao.p.peng@linux.intel.com, 
	linux-riscv@lists.infradead.org, isaku.yamahata@gmail.com, maz@kernel.org, 
	paul@paul-moore.com, anup@brainfault.org, chenhuacai@kernel.org, 
	jmorris@namei.org, willy@infradead.org, wei.w.wang@intel.com, 
	tabba@google.com, jarkko@kernel.org, serge@hallyn.com, 
	mail@maciej.szmigiero.name, aou@eecs.berkeley.edu, vbabka@suse.cz, 
	michael.roth@amd.com, paul.walmsley@sifive.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, qperret@google.com, seanjc@google.com, 
	liam.merwick@oracle.com, linux-mips@vger.kernel.org, oliver.upton@linux.dev, 
	linux-security-module@vger.kernel.org, palmer@dabbelt.com, 
	kvm-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	pbonzini@redhat.com, akpm@linux-foundation.org, vannapurve@google.com, 
	linuxppc-dev@lists.ozlabs.org, kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="UTF-8"

Binbin Wu <binbin.wu@linux.intel.com> writes:

> <snip>
>
>>
>> I'm not sure whose refcount the folio_put() in kvm_gmem_allocate() is
>> dropping though:
>>
>> + The refcount for the filemap depends on whether this is a hugepage or
>>    not, but folio_put() strictly drops a refcount of 1.
>> + The refcount for the lru list is just 1, but doesn't the page still
>>    remain in the lru list?
>
> I guess the refcount drop here is the one get on the fresh allocation.
> Now the filemap has grabbed the folio, so the lifecycle of the folio now 
> is decided by the filemap/inode?
>

This makes sense! So folio_put() here is saying, I'm not using this
folio anymore, but the filemap and the lru list are stil using the
folio.

> <snip>
