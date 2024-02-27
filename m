Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CCE41C60
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 14:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044879; cv=none; b=ADtfeiIL721tFaTwBFJu3dedNcPModHQvNpyUC+vCPpwb/q1LyByruSRvWReou+ComXb/a39brGhpMOJFEYrGASwDhuUSH8lsuWipI+FTWcxjV5z4ITDvCmc6IxAVrYnqX8ny/VHSEeN6jyp4qFBq9Cw7IGiE1BXoKrz33Krg+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044879; c=relaxed/simple;
	bh=sPPQY+Ht7+JB5Enuh7hmHp5RiuYQ24rYBxCori7yCco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5wZH212g9x1BYCL+rSAraINJfvHlGAR2saZLpvNgGahOF/FAAX8N4S1nBtFhpAqak+77bgaLSzhhYQ2SUj205bkYxMFR1zAeKCca8UTssFR7bE2xpYloNaqbpZEOzd7k85C8KivnoCbUDA3Z9ZNkVpvyRpTXWYtdv/uOLXb9mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z+F3cq5y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+F3cq5y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709044876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fMFn2z3V7KntafHUZIAx5fgq+ByceEctXtwYsdZQnxY=;
	b=Z+F3cq5yq0ZU5cjzBbIC3n7EUfFQ1EVuvALXw5ixWKyz/JAl1jnwXFLooxz1EYtDDHWimT
	Ll/pgVDMO0f2iEXrCwtbCBba3M3aNwwbDnOdw6YAh9AtDWGjlNTXVdkjRT0x3oCD125/oP
	u/Ig8Kuj/ujFIi3f5I53V5zCW0VjIHs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-IjXCg4E-Oj6doGdSF8pTyg-1; Tue, 27 Feb 2024 09:41:14 -0500
X-MC-Unique: IjXCg4E-Oj6doGdSF8pTyg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412aae6022bso4794595e9.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 06:41:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709044873; x=1709649673;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMFn2z3V7KntafHUZIAx5fgq+ByceEctXtwYsdZQnxY=;
        b=X/DqOcuCxRbqG0mk7jnqc0hZEMnGXafmo+0RnLkxjdFRShXgOwzq/rP+L0Z5nmuefg
         FRXFH3/e84Ie5yXpTYEc2tWWN+dbQ0FL+i1NnYGrHJTvdUWNo3a3uPAskRTi7sqdIiTr
         VL7MJkcZ0P+0BMftcKW7RNykYWIQzeybFEZ7l3Y/5sYJq1NLY2JE3GHb7fh5T6BWzY+u
         /StWm0JlHuemqGnxz2sx7MWPAsoos1NWZs/SJ6eYO9zSXcN2sPR5nNfBl3gIVppWIGw2
         Mb2ro5x0iEo6eUJGPtgqKYVXSJyhW7Tnl29fJeY+Bm2dgKOhKKVGoMd2rrhZTZm/LMwS
         4kGw==
X-Forwarded-Encrypted: i=1; AJvYcCWWP35MNI6KdgUGjTv4QMBU96S33++PShcPDAiPay/YK/s52NKJCACUaa+O08Poc6ZmzGd6n3w1bnVF2jsK1vDY3if6cpMs
X-Gm-Message-State: AOJu0Yy5MvazLprmxW9lzeGLCmwU0hzwCgSq0m7xlxbvmwf+WVRvUBuQ
	bwVaAXC8/S67w4Bex1MqxYd0VwrSuhZohPlRKTf+73Kzjb5HzQVzg2ST5MjBblfF+bhLnGqvW0V
	T8CAniNVB3+KNMoAsLAe2f6gaBDlipZ6J+ciHJHP1gWQBkSvFjvDrIA==
X-Received: by 2002:a5d:6a48:0:b0:33d:22a3:28bc with SMTP id t8-20020a5d6a48000000b0033d22a328bcmr7354678wrw.63.1709044873121;
        Tue, 27 Feb 2024 06:41:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHWusWsuiPM126Xschmcvaw8D+mOVjd1I5QPatOLj8i+m3Ic/PFikY/ATYVJu0odSRIFYjLQ==
X-Received: by 2002:a5d:6a48:0:b0:33d:22a3:28bc with SMTP id t8-20020a5d6a48000000b0033d22a328bcmr7354642wrw.63.1709044872654;
        Tue, 27 Feb 2024 06:41:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9? (p200300cbc70776005c185a7dc5b7e7a9.dip0.t-ipconnect.de. [2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d4d4a000000b0033d13530134sm11426339wru.106.2024.02.27.06.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 06:41:12 -0800 (PST)
Message-ID: <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
Date: Tue, 27 Feb 2024 15:41:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com
References: <20240222161047.402609-1-tabba@google.com>
 <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
 <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

>> Can you elaborate (or point to a summary) why pKVM has to be special
>> here? Why can't you use guest_memfd only for private memory and another
>> (ordinary) memfd for shared memory, like the other confidential
>> computing technologies are planning to?
> 
> Because the same memory location can switch back and forth between
> being shared and private in-place. The host/vmm doesn't know
> beforehand which parts of the guest's private memory might be shared
> with it later, therefore, it cannot use guest_memfd() for the private
> memory and anonymous memory for the shared memory without resorting to

I don't remember the latest details about the guest_memfd incarnation in 
user space, but I though we'd be using guest_memfd for private memory 
and an ordinary memfd for shared memory. But maybe it also works with 
anon memory instead of the memfd and that was just an implementation 
detail :)

> copying. Even if it did know beforehand, it wouldn't help much since
> that memory can change back to being private later on. Other
> confidential computing proposals like TDX and Arm CCA don't share in
> place, and need to copy shared data between private and shared memory.

Right.

> 
> If you're interested, there was also a more detailed discussion about
> this in an earlier guest_memfd() thread [1]

Thanks for the pointer!

> 
>> What's the main reason for that decision and can it be avoided?
>> (s390x also shares in-place, but doesn't need any special-casing like
>> guest_memfd provides)
> 
> In our current implementation of pKVM, we use anonymous memory with a
> long-term gup, and the host ends up with valid mappings. This isn't
> just a problem for pKVM, but also for TDX and Gunyah [2, 3]. In TDX,
> accessing guest private memory can be fatal to the host and the system
> as a whole since it could result in a machine check. In arm64 it's not
> necessarily fatal to the system as a whole if a userspace process were
> to attempt the access. However, a userspace process could trick the
> host kernel to try to access the protected guest memory, e.g., by
> having a process A strace a malicious process B which passes protected
> guest memory as argument to a syscall.

Right.

> 
> What makes pKVM and Gunyah special is that both can easily share
> memory (and its contents) in place, since it's not encrypted, and
> convert memory locations between shared/unshared. I'm not familiar
> with how s390x handles sharing in place, or how it handles memory
> donated to the guest. I assume it's by donating anonymous memory. I
> would be also interested to know how it handles and recovers from
> similar situations, i.e., host (userspace or kernel) trying to access
> guest protected memory.

I don't know all of the s390x "protected VM" details, but it is pretty 
similar. Take a look at arch/s390/kernel/uv.c if you are interested.

There are "ultravisor" calls that can convert a page
* from secure (inaccessible by the host) to non-secure (encrypted but
   accessible by the host)
* from non-secure to secure

Once the host tries to access a "secure" page -- either from the kernel 
or from user space, the host gets a page fault and calls 
arch_make_page_accessible(). That will encrypt page content such that 
the host can access it (migrate/swapout/whatsoever).

The host has to set aside some memory area for the ultravisor to 
"remember" page state.

So you can swapout/migrate these pages, but the host will only read 
encrypted garbage. In contrast to disallowing access to these pages.

So you don't need any guest_memfd games to protect from that -- and one 
doesn't have to travel back in time to have memory that isn't 
swappable/migratable and only comes in one page size.

[I'm not up-to-date which obscure corner-cases CCA requirement the s390x 
implementation cannot fulfill -- like replacing pages in page tables and 
such; I suspect pKVM also cannot cover all these corner-cases]


Extending guest_memfd (the one that was promised initially to not be 
mmappable) to be mmappable just to avoid some crashes in corner cases is 
the right approach. But I'm pretty sure that has all been discussed 
before, that's why I am asking about some details :)

-- 
Cheers,

David / dhildenb

