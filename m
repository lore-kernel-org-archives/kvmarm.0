Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99125FB86
	for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127783; cv=none; b=hGG0V3RN0kbe3BLEra5vm/QT47TzjCx/JIcCfcaqKFUzqpd87TYvkD4+z2YB/fASaUUN0CWmb49jdl9FifE2hxAve0QFNzoItHgfKFd5VxmbmeqTVqbNj4nmgJv2z8lLRfYAINHkAyKMpthyFwW6rm+VeV9TfgQXc4iMEJqKtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127783; c=relaxed/simple;
	bh=dFJ7AyAueVLIOdQadfAykfpRSeqXPQxc9hYu4W/xLh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=spvd4O4gyEOQdlmj8eMcwZlfzJ1dI5weVVhfQbjVFQUy4ctV+IwvZGLK7f2q7E0sOesAXnJl32fN769q7Fvv1wwUscrg6mBBb2XsB1TaSUg7omPNSwgL9pqDCUR4Wk1lqL71a7fFynuCLdIO59m5CacbzQ/1tfoWxW8vrkcobzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQz9+inW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQz9+inW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711127780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=klqHjOaIuyFCnzM5B3FmN7hDkmvtMAPsnM/IHZxrE00=;
	b=DQz9+inWXhavr1/5iDU4a66VBArW4vos8hfFvGkV8L+Nrv44pBi1K/dU9u5Mru1Vgt7MJz
	ertz/jX29uUUcMKeOL947mrdJSDciy+PMY8iuTBHdUf4AzzyOYQwQ9v1apiZBahfwgsrpy
	wECxdVFzWDhAT2gcmqZX8oQed9tJ+3U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-qly4MTePMvOMCwyu020P4w-1; Fri, 22 Mar 2024 13:16:19 -0400
X-MC-Unique: qly4MTePMvOMCwyu020P4w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-414042da713so16388245e9.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 10:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711127778; x=1711732578;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klqHjOaIuyFCnzM5B3FmN7hDkmvtMAPsnM/IHZxrE00=;
        b=YdCEi2DQpfc2PCBkohpgc1dqLGMiMcyRyeM/7a9+hpJV2SjmShZquosTNyVq6qqnY1
         s2d4OHd8An4m6+BcCz+xn0pZnKSFN7ESRH8xGFo8s5jsmbKeahdBxIzztKfsWsbciunV
         P8UisfWSCi2rHlFe2S5bMOf57mjt5t/2AW89nUft0jWaI8ufwBGsy+HpqGlGvGPWN0vV
         IYSz/ODzZ3uFVUjXk5/wmNM+KFOwEDmoBiyH2SL9stQZLsf1w0W56Q0kq9DkSNwUx/9r
         JsBSyMCwZAcW4g1Q1VxMg+/MseX3GcB3caoydILQK2DzTPnwSZZruKPuLzP8qx17jk6G
         6Q7g==
X-Forwarded-Encrypted: i=1; AJvYcCXBc2+KbUqBU1HBaXv/l9a5FK1oyVHqv3klUFAeC1hdCSGxbpA4/ypyWR8X6nsqFALMnokQKEJFWADL6qC7sAHBDU/rDRjq
X-Gm-Message-State: AOJu0Yyg5IGB7StQdxgLHU3c5+ztkbIc4HVbwCtxYPyZ0W5LCr05B2jh
	LoVfl472hb9+75pzoQ59DVIAwMlWhfIPKtjIbZPTENo/S6x9p87u0oNfSDX55KMp13PKbgS5jsQ
	02yov/KNrst47wbwHHFBPlMVgR6/D0Irn+IY+fOZpsc90ULuwUAMl2A==
X-Received: by 2002:a05:600c:3b07:b0:414:5e9d:ad31 with SMTP id m7-20020a05600c3b0700b004145e9dad31mr154191wms.13.1711127777987;
        Fri, 22 Mar 2024 10:16:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQdO82oLPzALpP9gkvuYCo9te6ENB+z5j7mVxrSnKELp0zHwvcjFMFGCJIh34d8uRhsWivCw==
X-Received: by 2002:a05:600c:3b07:b0:414:5e9d:ad31 with SMTP id m7-20020a05600c3b0700b004145e9dad31mr154151wms.13.1711127777464;
        Fri, 22 Mar 2024 10:16:17 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71b:7e00:9339:4017:7111:82d0? (p200300cbc71b7e0093394017711182d0.dip0.t-ipconnect.de. [2003:cb:c71b:7e00:9339:4017:7111:82d0])
        by smtp.gmail.com with ESMTPSA id p32-20020a05600c1da000b0041478834562sm118842wms.0.2024.03.22.10.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 10:16:17 -0700 (PDT)
Message-ID: <e5f1c475-a8c7-461e-9ee8-75bcc000d9a5@redhat.com>
Date: Fri, 22 Mar 2024 18:16:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
To: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
 Quentin Perret <qperret@google.com>, Matthew Wilcox <willy@infradead.org>,
 Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <Zfmpby6i3PfBEcCV@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zfmpby6i3PfBEcCV@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19.03.24 16:04, Sean Christopherson wrote:
> On Tue, Mar 19, 2024, David Hildenbrand wrote:
>> On 19.03.24 01:10, Sean Christopherson wrote:
>>> Performance is a secondary concern.  If this were _just_ about guest performance,
>>> I would unequivocally side with David: the guest gets to keep the pieces if it
>>> fragments a 1GiB page.
>>>
>>> The main problem we're trying to solve is that we want to provision a host such
>>> that the host can serve 1GiB pages for non-CoCo VMs, and can also simultaneously
>>> run CoCo VMs, with 100% fungibility.  I.e. a host could run 100% non-CoCo VMs,
>>> 100% CoCo VMs, or more likely, some sliding mix of the two.  Ideally, CoCo VMs
>>> would also get the benefits of 1GiB mappings, that's not the driving motiviation
>>> for this discussion.
>>
>> Supporting 1 GiB mappings there sounds like unnecessary complexity and
>> opening a big can of worms, especially if "it's not the driving motivation".
>>
>> If I understand you correctly, the scenario is
>>
>> (1) We have free 1 GiB hugetlb pages lying around
>> (2) We want to start a CoCo VM
>> (3) We don't care about 1 GiB mappings for that CoCo VM,
> 
> We care about 1GiB mappings for CoCo VMs.  My comment about performance being a
> secondary concern was specifically saying that it's the guest's responsilibity
> to play nice with huge mappings if the guest cares about its performance.  For
> guests that are well behaved, we most definitely want to provide a configuration
> that performs as close to non-CoCo VMs as we can reasonably make it.

How does the guest know the granularity? I suspect it's just implicit 
knowledge that "PUD granularity might be nice".

> 
> And we can do that today, but it requires some amount of host memory to NOT be
> in the HugeTLB pool, and instead be kept in reserved so that it can be used for
> shared memory for CoCo VMs.  That approach has many downsides, as the extra memory
> overhead affects CoCo VM shapes, our ability to use a common pool for non-CoCo
> and CoCo VMs, and so on and so forth.

Right. But avoiding memory waste as soon as hugetlb is involved (and we 
have two separate memfds for private/shared memory) is not feasible.

> 
>>      but hguetlb pages is all we have.
>> (4) We want to be able to use the 1 GiB hugetlb page in the future.
> 
> ...
> 
>>> The other big advantage that we should lean into is that we can make assumptions
>>> about guest_memfd usage that would never fly for a general purpose backing stores,
>>> e.g. creating a dedicated memory pool for guest_memfd is acceptable, if not
>>> desirable, for (almost?) all of the CoCo use cases.
>>>
>>> I don't have any concrete ideas at this time, but my gut feeling is that this
>>> won't be _that_ crazy hard to solve if commit hard to guest_memfd _not_ being
>>> general purposes, and if we we account for conversion scenarios when designing
>>> hugepage support for guest_memfd.
>>
>> I'm hoping guest_memfd won't end up being the wild west of hacky MM ideas ;)
> 
> Quite the opposite, I'm saying we should be very deliberate in how we add hugepage
> support and others features to guest_memfd, so that guest_memfd doesn't become a
> hacky mess.

Good.

> 
> And I'm saying say we should stand firm in what guest_memfd _won't_ support, e.g.
> swap/reclaim and probably page migration should get a hard "no".

I thought people wanted to support at least page migration in the 
future? (for example, see the reply from Will)

> 
> In other words, ditch the complexity for features that are well served by existing
> general purpose solutions, so that guest_memfd can take on a bit of complexity to
> serve use cases that are unique to KVM guests, without becoming an unmaintainble
> mess due to cross-products.

And I believed that was true until people started wanting to mmap() this 
thing and brought GUP into the picture ... and then talk about HGM and 
all that. *shivers*

-- 
Cheers,

David / dhildenb

