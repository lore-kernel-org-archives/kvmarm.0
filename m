Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7A3286D6D
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758828753; cv=none; b=nOyeOGBmQsYZS9uTgjzgwu008jXJLKWzCwgCSO7FxknR+UK9nxFTe5mK7iS+0R4AwwxP0bdvumKZdaEfQpCVDY7q1xNizg9B+zedM6hjw1qjPWz2cWMEmIH5q5kgC8vR27AjtauLHiUZOWeL+3zEsE9JcyrWoWbsdS5d8xTlRZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758828753; c=relaxed/simple;
	bh=jpqmsgmAQIqXP57KiX7lxY1y974aUYb01QrMbrU8Ahg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVfcVtSkAci8Yw5PadAfVsKFwuXDvGSuFiIQgHRuL1Ow2xv8eYAzP9h0t6qZFMC6kQkPDoOfhokv1AjjtPZMM/kN3VnWXsDiy7rRedLSrHQ3HK4tYMyolgYDCb2scaaof7Y5QNOt3izOsYqxvxKPb6QLuMytQjbC/g22nDoutnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPC/q4Ir; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPC/q4Ir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758828750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D5jCgvyWVjXaOxE5qhMkjeDubZJSnlT/2ztleqWrFCE=;
	b=VPC/q4IrPAbIk/S46tksLxrLnh+d4t1igIOUTnIkjkm1PqFaDWFzp1/cdg97WN9HiS5xIy
	oRH9o59Ikn+Xna/Ve+8YJaD7bKKDNzv0jXmhQXPTYCbFOY1AlaMuliAsHb38IZ74l5v8dB
	K2cezcHf6Syjr5OaxFqmX69Y+2Ys0SE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-qtL5Q4pSNvefIWcCZG43nA-1; Thu, 25 Sep 2025 15:32:29 -0400
X-MC-Unique: qtL5Q4pSNvefIWcCZG43nA-1
X-Mimecast-MFC-AGG-ID: qtL5Q4pSNvefIWcCZG43nA_1758828748
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee13e43dd9so662572f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 12:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758828748; x=1759433548;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5jCgvyWVjXaOxE5qhMkjeDubZJSnlT/2ztleqWrFCE=;
        b=QGJ7mAWEYWH1L40RuZBrYKbzUQhuiQOsDDesKp/P3EOazU2Fw2i/KJZqcYq6ufHYzw
         BktJx9ESdYGtxypV4iku38HjpzxKWQfsvNhMYjkDgbFtgeDQWkePupRwjHIuja+yXcOY
         IcAzOcHkqO9SdNl8UUMKQ8AN9+gOlb1DYBxe5mXDLlZnnM0wSi45q4EtfJLoBI6SLKDK
         pzF9cp+531z0g+FnRE8WXg540GjLvIWMhwcPk83LQ+HqiFz+hAllrJMv22B+723J0FoX
         cFa8G3gcjDllDKlDaAOoD5XfSXnRwLnrBuMEe79jRfqp3WMMFtReaEOwhAZMbGo7UCB5
         L+DA==
X-Forwarded-Encrypted: i=1; AJvYcCUTesYMIeVhGXw5lFj7ji6q/ZxULWWLIEOgzFA+F9DgDWmiPgtzG0jFcUG97a70v0k2GjdbhIY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr7jQgo4qYNQyIyw0ywLhvMhEHnxYDBvTz3IwP+NfTAswXnsee
	pdicG47neFNRoasnUCSgO5jlUYikxOtwqxCgw8cbQqt2AqnvFl8jgtfC0vydqeCPG3JHE9DptVU
	GgwIUhUZ+rzpbs8sMoahTOhZ8KyN0jeNVp4P735F0jCztp8FqiYIE5pUqqw==
X-Gm-Gg: ASbGncsm6PtgZrrDsfK21rxTgKwZjm14pOvnObfJflKuJv91TdpK8iJAI1+imdipibz
	Dg7coOFgQlUDA78u/He6sgD/Rw2XmG1MZwIr7OcUDDEZWRWxelz90p/nR1FzOxas3haZVKKMQvm
	7rGNBt6w5r+FmyOGyZudfHvn3sq16mCQzqOcrDR1c7/d0MJ7x+zkQ5aOyuQAMUcE+uG6LzGPutz
	RxSLQvkISzI3fo2/Mgmir5yjAi4egXhSnndsMpl5iWQlnMlWrEaOWNpfKZV6WZoqXOq0G8k2F3v
	p8vK1nA8Hmjhuh+jCzj+WGA2+A9Yxl7oZ97G1PYsaYGb7RQ/7v5exGZXPnD1h+h8zis1l6Og27/
	V/s9IkhdkcRW2FoJWp5dFAbLgrMaKX9p4qlPP0+dxQ5zn/hyOLkoZon17AGJaztQeIHmt
X-Received: by 2002:a05:6000:3102:b0:3f9:1571:fe04 with SMTP id ffacd0b85a97d-40e4b1a06b4mr4993192f8f.48.1758828747351;
        Thu, 25 Sep 2025 12:32:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFUL795NU1gcu1A2U+hWPDoMkyU660Ad1UyOUZxyr2NlakU+3syyUj7XJkeC88am/EkGOIvw==
X-Received: by 2002:a05:6000:3102:b0:3f9:1571:fe04 with SMTP id ffacd0b85a97d-40e4b1a06b4mr4993145f8f.48.1758828746777;
        Thu, 25 Sep 2025 12:32:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-410f2007372sm3193903f8f.16.2025.09.25.12.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 12:32:26 -0700 (PDT)
Message-ID: <1b34dd89-cbbb-474e-be75-808e174c8ed9@redhat.com>
Date: Thu, 25 Sep 2025 21:32:22 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "andrii@kernel.org" <andrii@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "corbet@lwn.net" <corbet@lwn.net>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "haoluo@google.com" <haoluo@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "maz@kernel.org" <maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "pfalcato@suse.de" <pfalcato@suse.de>, "rppt@kernel.org" <rppt@kernel.org>,
 "sdf@fomichev.me" <sdf@fomichev.me>, "seanjc@google.com"
 <seanjc@google.com>, "shuah@kernel.org" <shuah@kernel.org>,
 "song@kernel.org" <song@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "tabba@google.com" <tabba@google.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>, "x86@kernel.org"
 <x86@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>
References: <cf57bdec-6a2d-4d6a-b27c-991a7e2833ab@redhat.com>
 <20250925155051.2959-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250925155051.2959-1-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EEsSVXcgzPJMs28UhXfntQ9Z8e7suL8TkaNd29f0y30_1758828748
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.09.25 17:50, Roy, Patrick wrote:
> On Thu, 2025-09-25 at 12:02 +0100, David Hildenbrand wrote:
>> On 24.09.25 17:22, Roy, Patrick wrote:
>>> Add an option to not perform TLB flushes after direct map manipulations.
>>> TLB flushes result in a up to 40x elongation of page faults in
>>> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
>>> of memory population, which is inacceptable when wanting to use direct
>>> map removed guest_memfd as a drop-in replacement for existing workloads.
>>>
>>> TLB flushes are not needed for functional correctness (the virt->phys
>>> mapping technically stays "correct", the kernel should simply not use it
>>> for a while), so we can skip them to keep performance in-line with
>>> "traditional" VMs.
>>>
>>> Enabling this option means that the desired protection from
>>> Spectre-style attacks is not perfect, as an attacker could try to
>>> prevent a stale TLB entry from getting evicted, keeping it alive until
>>> the page it refers to is used by the guest for some sensitive data, and
>>> then targeting it using a spectre-gadget.
>>>
>>> Cc: Will Deacon <will@kernel.org>
>>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
>>> ---
>>>    include/linux/kvm_host.h | 1 +
>>>    virt/kvm/guest_memfd.c   | 3 ++-
>>>    virt/kvm/kvm_main.c      | 3 +++
>>>    3 files changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 73a15cade54a..4d2bc18860fc 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2298,6 +2298,7 @@ extern unsigned int halt_poll_ns;
>>>    extern unsigned int halt_poll_ns_grow;
>>>    extern unsigned int halt_poll_ns_grow_start;
>>>    extern unsigned int halt_poll_ns_shrink;
>>> +extern bool guest_memfd_tlb_flush;
>>>
>>>    struct kvm_device {
>>>        const struct kvm_device_ops *ops;
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index b7129c4868c5..d8dd24459f0d 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -63,7 +63,8 @@ static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
>>>        if (!r) {
>>>                unsigned long addr = (unsigned long) folio_address(folio);
>>>                folio->private = (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>> -             flush_tlb_kernel_range(addr, addr + folio_size(folio));
>>> +             if (guest_memfd_tlb_flush)
>>> +                     flush_tlb_kernel_range(addr, addr + folio_size(folio));
>>>        }
>>>
>>>        return r;
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index b5e702d95230..753c06ebba7f 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -95,6 +95,9 @@ unsigned int halt_poll_ns_shrink = 2;
>>>    module_param(halt_poll_ns_shrink, uint, 0644);
>>>    EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
>>>
>>> +bool guest_memfd_tlb_flush = true;
>>> +module_param(guest_memfd_tlb_flush, bool, 0444);
>>
>> The parameter name is a bit too generic. I think you somehow have to
>> incorporate the "direct_map" aspects.
> 
> Fair :)
> 
>> Also, I wonder if this could be a capability per vm/guest_memfd?
> 
> I don't really have any opinions on how to expose this knob, but I
> thought capabilities should be additive? (e.g. we only have
> KVM_ENABLE_EXTENSION(), and then having a capability with a negative
> polarity "enable to _not_ do TLB flushes" is a bit weird in my head).

Well, you are enabling the "skip-tlbflush" feature :) So a kernel that 
knows that extension could skip tlb flushes.

So I wouldn't see this as "perform-tlbflush" but "skip-tlbflush" / 
"no-tlbflush"

> Then again, if people are fine having TLB flushes be opt-in instead of
> opt-out (Will's comment on v6 makes me believe that the opt-out itself
> might already be controversial for arm64), a capability would work.

Yeah, I think this definitely should be opt-in: opt-in to slightly less 
security in a given timeframe by performing less tlb flushes.

-- 
Cheers

David / dhildenb

