Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A321B1AAE00
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722419447; cv=none; b=JJH6RyHhkFL6PtnmpD6JYTFpNZtv4CFr+O5iAisidNoqa9SQA0FSzFCVfxQvCs3g7uSIsjkPwwYMbISXqRHnYZbVLp+uIELfIYHk/4uBQXod9Fd0+r2+C/jdNrf0SWU805JWa3FQXpmI6+NyvYpoNfPyTQcbGoLP9LVnq5CtH1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722419447; c=relaxed/simple;
	bh=XTrejJ34wyqTmqzJGqmoE5EbaZZYWrCKbhJX3mWbjW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o8EgfjHKBDcJcEP0tVhycQWb5aq5xbT4J6NSgJxuSJGusySas4mHeVFl78iHgI3OiBcX6PgPqFsqG43E5CN5/J0dRkDZYn3DvpNvSHQlFJURB2deodYMsPFn9T+Si2UvocEPSHeL9ymN7tIsuHG5U+QxcOGGK38PguI6KI8iimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KrEy5xBV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KrEy5xBV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722419444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kF8YsGqLWNT4+a8R4w4P9MUEGEAYWYiYSABna27uXpU=;
	b=KrEy5xBVc1iGF2PVOY7dITK1PYtisicQgOaKSayL34SW7TgJ27MZDD7csgG0vXDCoIV4lP
	XDevCAOVyoCv7zJYenootvNrJFekg08VPCUcOwVk5HetdAL1xAdx/5306f55E8Cpo0cFe5
	6YT1V7vpeNo/sA63WDaazWkq43GtuRs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-IJkElFs9PfSS2ub5p4KcIA-1; Wed, 31 Jul 2024 05:50:41 -0400
X-MC-Unique: IJkElFs9PfSS2ub5p4KcIA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a7aa020cef5so502213666b.0
        for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 02:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722419440; x=1723024240;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kF8YsGqLWNT4+a8R4w4P9MUEGEAYWYiYSABna27uXpU=;
        b=rPv99+Q1n0a/dSS4wB3ZUsNaEqJ7OjVyDwFdh6gh5q/Cob3JPTFaspcrSd3NLOYpc/
         5dh1qnGg6HOTCcSDWtLuyE57fkqxHWemHj8pDZ7W0ZeczzCa4N/CxkGqYeeNb/Z2pvDu
         1st7MSN6SMoXwP90aBq4fJh7BfSYpXMFAEcnotRWfBqIpFaNSLsTXZxwuKqumTjBiToa
         McrNyhZpRyMgau3GNrQwd/l98hiU4CYpLbwlGhsMVFD6oHHe/9is7lxAaxoW5c2O1IXp
         evG/8lV6t3MWAi+4Vy7pmKSx1nFJZSDoJZhttiZYTejQm3bG257Dm30xHOyrrz1GuqiU
         R53A==
X-Forwarded-Encrypted: i=1; AJvYcCVpq2gTMquCPFe3Za1XEj6mL2NxyRPKeuMZy8LxjpQh5qmbYJMSCS9G9GcpZEflREd6idk2khtu0kEvPm8WoHMsjY1Pqg8r
X-Gm-Message-State: AOJu0YzwzAt/JJINk8VJXY511cYLab8CZiOFDYOiRFQWAxqyTXmFjJ6/
	OGc74XxoqXcWCcE9n7mcS1XjppsnIZQWSw6Dek2ZYeTrd2DO31QXG3Ahcmj9RMl2IO3edvjK/Xz
	26aZH3LurplKf8qnAej1RpR4RAMAqwlW382+uJ5J8FYDhCtrZmnfslQ==
X-Received: by 2002:a17:907:94cb:b0:a7a:bece:6223 with SMTP id a640c23a62f3a-a7d3ff7b8e4mr1064731266b.6.1722419440613;
        Wed, 31 Jul 2024 02:50:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHm0sw2f7Q/hSxPLtTI3KYQw5uCrmW/NKDuI5rQ7HlgfsjazxGbnWK3KS2H8Xhx5SNKvtVQug==
X-Received: by 2002:a17:907:94cb:b0:a7a:bece:6223 with SMTP id a640c23a62f3a-a7d3ff7b8e4mr1064728266b.6.1722419440130;
        Wed, 31 Jul 2024 02:50:40 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acad93105sm746255566b.167.2024.07.31.02.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 02:50:39 -0700 (PDT)
Message-ID: <57ba7e1d-0121-4d71-89b8-c61c476ca724@redhat.com>
Date: Wed, 31 Jul 2024 11:50:38 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 84/84] KVM: Don't grab reference on VM_MIXEDMAP pfns
 that have a "struct page"
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-85-seanjc@google.com>
 <992c4a07-fb84-42d8-93b3-96fb3a12c8e0@redhat.com>
 <ZqlLWl0R1p41CS0O@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZqlLWl0R1p41CS0O@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 22:21, Sean Christopherson wrote:
> On Tue, Jul 30, 2024, Paolo Bonzini wrote:
>> On 7/27/24 01:52, Sean Christopherson wrote:
>>> Now that KVM no longer relies on an ugly heuristic to find its struct page
>>> references, i.e. now that KVM can't get false positives on VM_MIXEDMAP
>>> pfns, remove KVM's hack to elevate the refcount for pfns that happen to
>>> have a valid struct page.  In addition to removing a long-standing wart
>>> in KVM, this allows KVM to map non-refcounted struct page memory into the
>>> guest, e.g. for exposing GPU TTM buffers to KVM guests.
>>
>> Feel free to leave it to me for later, but there are more cleanups that
>> can be made, given how simple kvm_resolve_pfn() is now:
> 
> I'll revisit kvm_resolve_pfn(), Maxim also wasn't a fan of a similar helper that
> existed in v11.

FWIW kvm_resolve_pfn() is totally fine as an intermediate step.  Just 
food for thought for possible follow-ups.

>> Also, check_user_page_hwpoison() should not be needed anymore, probably
>> not since commit 234b239bea39 ("kvm: Faults which trigger IO release the
>> mmap_sem", 2014-09-24) removed get_user_pages_fast() from hva_to_pfn_slow().
> 
> Ha, I *knew* this sounded familiar.  Past me apparently came to the same
> conclusion[*], though I wrongly suspected a memory leak and promptly forgot to
> ever send a patch.  I'll tack one on this time around.

As you prefer.

Paolo

