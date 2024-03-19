Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82197E76C
	for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 10:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710843974; cv=none; b=sPpFJxBs2Ov1E+dnDqhbG1aokjSTBRrSz9KbFkfhSyLvInqYc1sUOSwsD97dplGsoPvAw8TUckxAFESyeB3JZ0bYA6ClOBaYNbNQM0bC0SqK/vUSYnUBpa1V/XOoqlKVi2yindopVWSoXitEPEFpjrSsi0NwcPLvt0xd0N/DABg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710843974; c=relaxed/simple;
	bh=oMuBlCvH0d8pn2zMOskiLVv1Cm6VZlVr+3iqtG+8aEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=diri/qviE2lqGrz2ByF+3KiKHHhcLuTb70S++Vk5VoZ1p00APQdwjaoybheeJpMDc1m3z53gG7lJXSvXBlQhf2d8NVAkjzMDMK2jeUisQ4h9ig8ZMxaGsKwaX5ENn7D7C7ck9mzilkM701qU14qHE6UBp98A2ww4+CYNJPw/xwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I0UxxGY/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0UxxGY/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710843971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i6ZOSJeD43/crSFjue1PMzcUp2KbsGxaPoBQotC5eFo=;
	b=I0UxxGY/pBn63nl9FXBmAZ3B+/MuXyYjZLjley/jTkpp07YbDCl9E5Rn1+mBoY77trwjmk
	co9wkrGiMQcEb/ARRkQY5XdM2O2rikGWAOtF/IfJZEePAYE9ydhl+EhvJ2Ycs62mtRUBZD
	e6C4YuRM2M2EXdQhmPmkTGufdsgo254=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-4Ug3NDwzPZafe6Phqa_hAw-1; Tue, 19 Mar 2024 06:26:10 -0400
X-MC-Unique: 4Ug3NDwzPZafe6Phqa_hAw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33ed483c2ecso1793075f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 03:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710843969; x=1711448769;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6ZOSJeD43/crSFjue1PMzcUp2KbsGxaPoBQotC5eFo=;
        b=WRBzAPArPVNxnzH37engO8qdpX9dIy6eXJ6sdzaxvi5uED1khkVBWSxg6ipox74g7M
         jkrEpe6WGky4fnRbg4NR7ixwPcr7X+PG+xGAPS63i4EvKPyfpUS7VW4x6KxKrER9mlkn
         IW/rPUeSNoU4zD6AxQtA1O/gpTDKuIqyt5ud0lYhH8AjgSmWjvHnpkf8efGdMP1LEOq0
         CYgQ4qOVWnO30xMtUIgghOxJNaEciE67thym7FloDyNIEIKbMITmTrszeFee2EoC22Y3
         a4+cJEhLvoEsMRTApHBrDmucM4vWNrVFmjDwY/UkfVDt0rfJe3Cp7E8m8OeimSk6bhtc
         wkww==
X-Forwarded-Encrypted: i=1; AJvYcCV34hXFVU9tzW0+vEcUtLWqKss+y7QNI5tQbm94HcHskfQJlpICRQxQ/ctAWU6O07MchQwQL+3mQ+GsKm7rYPM9OqzNfnTo
X-Gm-Message-State: AOJu0Yzy2mcuslCQCAtzUNIR8HG62MJ1DpFua4eiS/Oo1cAWO22uitmg
	ncHdoRJaWqCGl92KfucDAy4NNkV7IFBiwsnKYpiFG1Vm2kj+ZDw3g/Wl4a2fJCE9hAKmPPVDsg9
	fKfwwiNUZCj1eRsQalp8yJmKKABIR0Y6P0XH6gDoRB9o1bKjyfxx4hw==
X-Received: by 2002:adf:eb11:0:b0:33d:2472:eb8c with SMTP id s17-20020adfeb11000000b0033d2472eb8cmr9078551wrn.19.1710843969160;
        Tue, 19 Mar 2024 03:26:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6i9XKzjcNwRUudCNtCW8g4HygSmm4PSLFFzmEOE/2MUnyb9ygsA4MHE3BJYL+kdOVIwDJdA==
X-Received: by 2002:adf:eb11:0:b0:33d:2472:eb8c with SMTP id s17-20020adfeb11000000b0033d2472eb8cmr9078522wrn.19.1710843968572;
        Tue, 19 Mar 2024 03:26:08 -0700 (PDT)
Received: from ?IPV6:2003:cb:c741:2200:2adc:9a8d:ae91:2e9f? (p200300cbc74122002adc9a8dae912e9f.dip0.t-ipconnect.de. [2003:cb:c741:2200:2adc:9a8d:ae91:2e9f])
        by smtp.gmail.com with ESMTPSA id i18-20020adffc12000000b0033e786abf84sm12044137wrr.54.2024.03.19.03.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 03:26:08 -0700 (PDT)
Message-ID: <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
Date: Tue, 19 Mar 2024 11:26:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Quentin Perret <qperret@google.com>, Matthew Wilcox
 <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
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
In-Reply-To: <ZfjYBxXeh9lcudxp@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19.03.24 01:10, Sean Christopherson wrote:
> On Mon, Mar 18, 2024, Vishal Annapurve wrote:
>> On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
>>> Second, we should find better ways to let an IOMMU map these pages,
>>> *not* using GUP. There were already discussions on providing a similar
>>> fd+offset-style interface instead. GUP really sounds like the wrong
>>> approach here. Maybe we should look into passing not only guest_memfd,
>>> but also "ordinary" memfds.
> 
> +1.  I am not completely opposed to letting SNP and TDX effectively convert
> pages between private and shared, but I also completely agree that letting
> anything gup() guest_memfd memory is likely to end in tears.

Yes. Avoid it right from the start, if possible.

People wanted guest_memfd to *not* have to mmap guest memory ("even for 
ordinary VMs"). Now people are saying we have to be able to mmap it in 
order to GUP it. It's getting tiring, really.

> 
>> I need to dig into past discussions around this, but agree that
>> passing guest memfds to VFIO drivers in addition to HVAs seems worth
>> exploring. This may be required anyways for devices supporting TDX
>> connect [1].
>>
>> If we are talking about the same file catering to both private and
>> shared memory, there has to be some way to keep track of references on
>> the shared memory from both host userspace and IOMMU.
>>
>>>
>>> Third, I don't think we should be using huge pages where huge pages
>>> don't make any sense. Using a 1 GiB page so the VM will convert some
>>> pieces to map it using PTEs will destroy the whole purpose of using 1
>>> GiB pages. It doesn't make any sense.
> 
> I don't disagree, but the fundamental problem is that we have no guarantees as to
> what that guest will or will not do.  We can certainly make very educated guesses,
> and probably be right 99.99% of the time, but being wrong 0.01% of the time
> probably means a lot of broken VMs, and a lot of unhappy customers.
> 

Right, then don't use huge/gigantic pages. Because it doesn't make any 
sense. You have no guarantees about memory waste. You have no guarantee 
about performance. Then just don't use huge/gigantic pages.

Use them where reasonable, they are an expensive resource. See below.

>> I had started a discussion for this [2] using an RFC series.
> 
> David is talking about the host side of things, AFAICT you're talking about the
> guest side...
> 
>> challenge here remain:
>> 1) Unifying all the conversions under one layer
>> 2) Ensuring shared memory allocations are huge page aligned at boot
>> time and runtime.
>>
>> Using any kind of unified shared memory allocator (today this part is
>> played by SWIOTLB) will need to support huge page aligned dynamic
>> increments, which can be only guaranteed by carving out enough memory
>> at boot time for CMA area and using CMA area for allocation at
>> runtime.
>>     - Since it's hard to come up with a maximum amount of shared memory
>> needed by VM, especially with GPUs/TPUs around, it's difficult to come
>> up with CMA area size at boot time.
> 
> ...which is very relevant as carving out memory in the guest is nigh impossible,
> but carving out memory in the host for systems whose sole purpose is to run VMs
> is very doable.
> 
>> I think it's arguable that even if a VM converts 10 % of its memory to
>> shared using 4k granularity, we still have fewer page table walks on
>> the rest of the memory when using 1G/2M pages, which is a significant
>> portion.
> 
> Performance is a secondary concern.  If this were _just_ about guest performance,
> I would unequivocally side with David: the guest gets to keep the pieces if it
> fragments a 1GiB page.
> 
> The main problem we're trying to solve is that we want to provision a host such
> that the host can serve 1GiB pages for non-CoCo VMs, and can also simultaneously
> run CoCo VMs, with 100% fungibility.  I.e. a host could run 100% non-CoCo VMs,
> 100% CoCo VMs, or more likely, some sliding mix of the two.  Ideally, CoCo VMs
> would also get the benefits of 1GiB mappings, that's not the driving motiviation
> for this discussion.

Supporting 1 GiB mappings there sounds like unnecessary complexity and 
opening a big can of worms, especially if "it's not the driving motivation".

If I understand you correctly, the scenario is

(1) We have free 1 GiB hugetlb pages lying around
(2) We want to start a CoCo VM
(3) We don't care about 1 GiB mappings for that CoCo VM, but hguetlb
     pages is all we have.
(4) We want to be able to use the 1 GiB hugetlb page in the future.

With hugetlb, it's possible to reserve a CMA area from which to later 
allocate 1 GiB pages. While not allocated, they can be used for movable 
allocations.

So in the scenario above, free the hugetlb pages back to CMA. Then, 
consume them as 4K pages for the CoCo VM. When wanting to start a 
non-CoCo VM, re-allocate them from CMA.

One catch with that is that
(a) CMA pages cannot get longterm-pinned: for obvious reasons, we
     wouldn't be able to migrate them in order to free up the 1 GiB page.
(b) guest_memfd pages are not movable and cannot currently end up on CMA
     memory.

But maybe that's not actually required in this scenario and we'd like to 
have slightly different semantics: if you were to give the CoCo VM the 1 
GiB pages, they would similarly be unusable until that VM quit and freed 
up the memory!

So it might be acceptable to get "selected" unmovable allocations (from 
guest_memfd) on selected (hugetlb) CMA area, that the "owner" will free 
up when wanting to re-allocate that memory. Otherwise, the CMA 
allocation will simply fail.

If we need improvements in that area to support this case, we can talk. 
Just an idea to avoid HGM and friends just to make it somehow work with 
1 GiB pages ...

> 
> As HugeTLB exists today, supporting that use case isn't really feasible because
> there's no sane way to convert/free just a sliver of a 1GiB page (and reconstitute
> the 1GiB when the sliver is converted/freed back).
> 
> Peeking ahead at my next comment, I don't think that solving this in the guest
> is a realistic option, i.e. IMO, we need to figure out a way to handle this in
> the host, without relying on the guest to cooperate.  Luckily, we haven't added
> hugepage support of any kind to guest_memfd, i.e. we have a fairly blank slate
> to work with.
> 
> The other big advantage that we should lean into is that we can make assumptions
> about guest_memfd usage that would never fly for a general purpose backing stores,
> e.g. creating a dedicated memory pool for guest_memfd is acceptable, if not
> desirable, for (almost?) all of the CoCo use cases.
> 
> I don't have any concrete ideas at this time, but my gut feeling is that this
> won't be _that_ crazy hard to solve if commit hard to guest_memfd _not_ being
> general purposes, and if we we account for conversion scenarios when designing
> hugepage support for guest_memfd.

I'm hoping guest_memfd won't end up being the wild west of hacky MM ideas ;)

> 
>>> For example, one could create a GPA layout where some regions are backed
>>> by gigantic pages that cannot be converted/can only be converted as a
>>> whole, and some are backed by 4k pages that can be converted back and
>>> forth. We'd use multiple guest_memfds for that. I recall that physically
>>> restricting such conversions/locations (e.g., for bounce buffers) in
>>> Linux was already discussed somewhere, but I don't recall the details.
>>>
>>> It's all not trivial and not easy to get "clean".
>>
>> Yeah, agree with this point, it's difficult to get a clean solution
>> here, but the host side solution might be easier to deploy (not
>> necessarily easier to implement) and possibly cleaner than attempts to
>> regulate the guest side.
> 
> I think we missed the opportunity to regulate the guest side by several years.
> To be able to rely on such a scheme, e.g. to deploy at scale and not DoS customer
> VMs, KVM would need to be able to _enforce_ the scheme.  And while I am more than
> willing to put my foot down on things where the guest is being blatantly ridiculous,
> wanting to convert an arbitrary 4KiB chunk of memory between private and shared
> isn't ridiculous (likely inefficient, but not ridiculous).  I.e. I'm not willing
> to have KVM refuse conversions that are legal according to the SNP and TDX specs
> (and presumably the CCA spec, too).
> 
> That's why I think we're years too late; this sort of restriction needs to go in
> the "hardware" spec, and that ship has sailed.

Once could consider extend the spec and glue huge+gigantic page support 
to new hardware.

But ideally, we could just avoid any partial conversion / HGM just to 
support a scenario where we might not actually want 1 GiB pages, but 
somehow want to make it work with 1 GiB pages.

-- 
Cheers,

David / dhildenb

