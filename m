Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2835764A80
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 10:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709201059; cv=none; b=R+7AGJ9k38yILFqhTsC9y6KQjc5mwAIoFCuOp2fpVDOnynm6zH8OgUD7fzroy+HLrpGcdr6LfBSaiUGSQCUk2wWvbXyY7o1TLXWBG/is9hiKJxzJ2N84+9tuuWjiVwTgJbpfDXKSBXGUT6IbaJOyVijbcwFxB3539UNtj/JhLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709201059; c=relaxed/simple;
	bh=fzbMVu2wPCkrjTrHnnICVi7xWA4fcgwnHk3H9a5w3As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rWusM3FJuZGZehDnvRBvrtSFIgHhvax2VqH0uV6Hk/Nl25KbrTpTfvWqL+GUFGlaQE1Vp6wii47VVA4UNtZDoDaZg5lTdTxuQR1YjbUCp5W6nureEhD/wxHI8Tk1Sa525udT6R6RzZwPElsBRkqgmVqm9HSICxwBc98MK/rzDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CjVb99ex; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CjVb99ex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709201055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U3U1t0u9oZOIN4c6R0zV7/Fyp6NfHXt7SJqSEz9Kqdc=;
	b=CjVb99exGfBkC6NOPpO6bVsqnyJMrRquSom9rMUn3WTAZWEDsGhPAN/ZSAO8AsDer1ggOM
	CKwXDxVHNYTMlLv9nSKdwpfSLVfGdPvOWmwuxLoRZhFS2j8LhXsRXh2gMkGMONZvVg62g3
	UnQ+3OpZ8KFqJhM2jCAlzwq9SUZEr+8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-nvDJLGMvM8m0xI40OKKEZg-1; Thu, 29 Feb 2024 05:04:14 -0500
X-MC-Unique: nvDJLGMvM8m0xI40OKKEZg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4129fb7a631so4644245e9.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 02:04:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709201053; x=1709805853;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3U1t0u9oZOIN4c6R0zV7/Fyp6NfHXt7SJqSEz9Kqdc=;
        b=u9k79GXhaIxk66mfR0FX1udVBaRn4awPcVdbx5Q+1DOVQoAyB2B6uzCo5511cwi39v
         J+iboDRSHY7MBK3GgHCde13qVH+ZZ0TUN1u7BpPo28HN4CLhXrL9IZoJZB1vVziAWv0+
         /8V2j9T7JoQ2d1MMseDwqxPmGbylRVilb6wFm/+0uqaEWkHFRpACyBR4v8/l0XRVb0b3
         2d6hpa5DZHA17jg0w+JSrM4psr2vCZRW66MA8lO3cJEBiJ5oQvJlh15U8XGLDI6/Kx7f
         161mnErKfV205trw539dkql3o3wQEZXMqrmGN/UEcTU1A07B77oToXb6LTyvlLh6M1jL
         A4sA==
X-Forwarded-Encrypted: i=1; AJvYcCUrKhh0vnMinALUDDNQFCz56yUNAWJgrqXUzjbLipLD56y+j1uAb/7cEtV+iyr6TtPs3Q3FwItgwd1g/TZC5I1c30tjtND2
X-Gm-Message-State: AOJu0Yx4NyVHC2U+jroa/aZPc+h7+TAW7ZOZDxJgAKZGs3goJ5REgUbl
	TbRboSS08Fai8WaRAJtsugfryvor+qv2V9m3WB/VLpgvr/Ch6LKHf8eSSFS2ntyzO/ID9ST5PDF
	5RF0wYy0+ZmT2NVWsViXZX9QsvsXYYUpQp9A+LEfw0u1K5re0H1wRyg==
X-Received: by 2002:a5d:66d2:0:b0:33d:3566:b5d1 with SMTP id k18-20020a5d66d2000000b0033d3566b5d1mr1138937wrw.57.1709201053123;
        Thu, 29 Feb 2024 02:04:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwOCa7N7/ldoGk+JOCK/uJcXN9uJ97XONysaQvHF2J14mwN2Lh7S8xHzyQ5fnVxa5KpBRczA==
X-Received: by 2002:a5d:66d2:0:b0:33d:3566:b5d1 with SMTP id k18-20020a5d66d2000000b0033d3566b5d1mr1138894wrw.57.1709201052553;
        Thu, 29 Feb 2024 02:04:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:fa00:74f2:89da:ed65:8b50? (p200300cbc707fa0074f289daed658b50.dip0.t-ipconnect.de. [2003:cb:c707:fa00:74f2:89da:ed65:8b50])
        by smtp.gmail.com with ESMTPSA id d2-20020a5d5382000000b0033b4dae972asm1304347wrv.37.2024.02.29.02.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 02:04:12 -0800 (PST)
Message-ID: <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
Date: Thu, 29 Feb 2024 11:04:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
To: Quentin Perret <qperret@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, keirf@google.com, linux-mm@kvack.org
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zd82V1aY-ZDyaG8U@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.02.24 14:34, Quentin Perret wrote:
> On Wednesday 28 Feb 2024 at 14:00:50 (+0100), David Hildenbrand wrote:
>>>>> To add a layer of paint to the shed, the usage of SIGBUS for
>>>>> something that is really a permission access problem doesn't feel
>>>>
>>>> SIGBUS stands for "BUS error (bad memory access)."
>>>>
>>>> Which makes sense, if you try accessing something that can no longer be
>>>> accessed. It's now inaccessible. Even if it is temporarily.
>>>>
>>>> Just like a page with an MCE error. Swapin errors. Etc. You cannot access
>>>> it.
>>>>
>>>> It might be a permission problem on the pKVM side, but it's not the
>>>> traditional "permission problem" as in mprotect() and friends. You cannot
>>>> resolve that permission problem yourself. It's a higher entity that turned
>>>> that memory inaccessible.
>>>
>>> Well that's where I'm not sure to agree. Userspace can, in fact, get
>>> back all of that memory by simply killing the protected VM. With the
>>
>> Right, but that would likely "wipe" the pages so they can be made accessible
>> again, right?
> 
> Yep, indeed.
> 
>> That's the whole point why we are handing the pages over to the "higher
>> entity", and allow someone else (the VM) to turn them into a state where we
>> can no longer read them.
>>
>> (if you follow the other discussion, it would actually be nice if we could
>> read them and would get encrypted content back, like s390x does; but that's
>> a different discussion and I assume pretty much out of scope :) )
> 
> Interesting, I'll read up. On a side note, I'm also considering adding a
> guest-facing hypervisor interface to let the guest decide to opt out of
> the hypervisor wipe as discussed above. That would be useful for a guest
> that is shutting itself down (which could be cooperating with the host
> Linux) and that knows it has erased its secrets. That is in general
> difficult to do for an OS, but a simple approach could be to poison all
> its memory (or maybe encrypt it?) before opting out of that wipe.
> 
> The hypervisor wipe is done in hypervisor context (obviously), which is
> non-preemptible, so avoiding wiping (or encrypting) loads of memory
> there is highly desirable. Also pKVM doesn't have a linear map of all
> memory for security reasons, so we need to map/unmap the pages one by
> one, which sucks as much as it sounds.
> 
> But yes, we're digressing, that is all for later :)

:) Sounds like an interesting optimization.

An alternative would be to remember in pKVM that a page needs a wipe 
before reaccess. Once re-accessed by anybody (hypervisor or new guest), 
it first has to be wiped by pKVM.

... but that also sounds complicated and similar requires the linear 
map+unmap in pKVM page-by-page as they are reused. But at least a guest 
shutdown would be faster.

> 
>>> approach suggested here, the guestmem pages are entirely accessible to
>>> the host until they are attached to a running protected VM which
>>> triggers the protection. It is very much userspace saying "I promise not
>>> to touch these pages from now on" when it does that, in a way that I
>>> personally find very comparable to the mprotect case. It is not some
>>> other entity that pulls the carpet from under userspace's feet, it is
>>> userspace being inconsistent with itself that causes the issue here, and
>>> that's why SIGBUS feels kinda wrong as it tends to be used to report
>>> external errors of some sort.
>>
>> I recall that user space can also trigger SIGBUS when doing some
>> mmap()+truncate() thingies, and probably a bunch more, that could be fixed
>> up later.
> 
> Right, so that probably still falls into "there is no page" bucket
> rather than the "there is a page that is already accounted against the
> userspace process, but it doesn't have the permission to access it
> bucket. But yes that's probably an infinite debate.

Yes, we should rather focus on the bigger idea: have inaccessible memory 
that fails a pagefault instead of the mmap.

> 
>> I don't see a problem with SIUGBUS here, but I do understand your view. I
>> consider the exact signal a minor detail, though.
>>
>>>
>>>>> appropriate. Allocating memory via guestmem and donating that to a
>>>>> protected guest is a way for userspace to voluntarily relinquish access
>>>>> permissions to the memory it allocated. So a userspace process violating
>>>>> that could, IMO, reasonably expect a SEGV instead of SIGBUS. By the
>>>>> point that signal would be sent, the page would have been accounted
>>>>> against that userspace process, so not sure the paging examples that
>>>>> were discussed earlier are exactly comparable. To illustrate that
>>>>> differently, given that pKVM and Gunyah use MMU-based protection, there
>>>>> is nothing architecturally that prevents a guest from sharing a page
>>>>> back with Linux as RO.
>>>>
>>>> Sure, then allow page faults that allow for reads and give a signal on write
>>>> faults.
>>>>
>>>> In the scenario, it even makes more sense to not constantly require new
>>>> mmap's from user space just to access a now-shared page.
>>>>
>>>>> Note that we don't currently support this, so I
>>>>> don't want to conflate this use case, but that hopefully makes it a
>>>>> little more obvious that this is a "there is a page, but you don't
>>>>> currently have the permission to access it" problem rather than "sorry
>>>>> but we ran out of pages" problem.
>>>>
>>>> We could user other signals, at least as the semantics are clear and it's
>>>> documented. Maybe SIGSEGV would be warranted.
>>>>
>>>> I consider that a minor detail, though.
>>>>
>>>> Requiring mmap()/munmap() dances just to access a page that is now shared
>>>> from user space sounds a bit suboptimal. But I don't know all the details of
>>>> the user space implementation.
>>>
>>> Agreed, if we could save having to mmap() each page that gets shared
>>> back that would be a nice performance optimization.
>>>
>>>> "mmap() the whole thing once and only access what you are supposed to
>   (> > > access" sounds reasonable to me. If you don't play by the rules, you get a
>>>> signal.
>>>
>>> "... you get a signal, or maybe you don't". But yes I understand your
>>> point, and as per the above there are real benefits to this approach so
>>> why not.
>>>
>>> What do we expect userspace to do when a page goes from shared back to
>>> being guest-private, because e.g. the guest decides to unshare? Use
>>> munmap() on that page? Or perhaps an madvise() call of some sort? Note
>>> that this will be needed when starting a guest as well, as userspace
>>> needs to copy the guest payload in the guestmem file prior to starting
>>> the protected VM.
>>
>> Let's assume we have the whole guest_memfd mapped exactly once in our
>> process, a single VMA.
>>
>> When setting up the VM, we'll write the payload and then fire up the VM.
>>
>> That will (I assume) trigger some shared -> private conversion.
>>
>> When we want to convert shared -> private in the kernel, we would first
>> check if the page is currently mapped. If it is, we could try unmapping that
>> page using an rmap walk.
> 
> I had not considered that. That would most certainly be slow, but a well
> behaved userspace process shouldn't hit it so, that's probably not a
> problem...

If there really only is a single VMA that covers the page (or even mmaps 
the guest_memfd), it should not be too bad. For example, any 
fallocate(PUNCHHOLE) has to do the same, to unmap the page before 
discarding it from the pagecache.

But of course, no rmap walk is always better.

> 
>> Then, we'd make sure that there are really no other references and protect
>> against concurrent mapping of the page. Now we can convert the page to
>> private.
> 
> Right.
> 
> Alternatively, the shared->private conversion happens in the KVM vcpu
> run loop, so we'd be in a good position to exit the VCPU_RUN ioctl with a
> new exit reason saying "can't donate that page while it's shared" and
> have userspace use MADVISE_DONTNEED or munmap, or whatever on the back
> of that. But I tend to prefer the rmap option if it's workable as that
> avoids adding new KVM userspace ABI.

As discussed in the sub-thread, that might still be required.

One could think about completely forbidding GUP on these mmap'ed 
guest-memfds. But likely, there might be use cases in the future where 
you want to use GUP on shared memory inside a guest_memfd.

(the iouring example I gave might currently not work because 
FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and 
guest_memfd will likely not be detected as shmem; 8ac268436e6d contains 
some details)

-- 
Cheers,

David / dhildenb

