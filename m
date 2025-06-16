Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C1C2857E2
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083406; cv=none; b=rKAEE8IOb79uCWIoTuCoNA9ghQEox3vdgFSVMo40z6ZXOoTnM4XYePTgWcrz3jsJL/ZInjXk1QGHx7T9ijeBP7By4PoLJKWezRqgfdkwfs68CctXF35vtsJfBGkPpc6EUZ2vpNHMi1i0abAe7itvPbixW1dTlDob1lcYIZM3nXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083406; c=relaxed/simple;
	bh=ZwA+gEVAu0ZDVOapx1CjTw58l6vDwTX7zYbC8/mjxLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E0elJ0xxlq+PNYuBU03cNFGzSSt79nXQQWy0zdjEOnXEYMdNJxazlNksZKBwwLxHBBkTqAwjRh9ya8IRZEFFtrZVLxK/uAL7s9yTc1B2EFN5isJ1xm0MdA7+3VEyDoGInH/sKN/uF67n1MPazWcVZxL+TOJrxa7I4tEBZYlxuR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GCoVJCTk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GCoVJCTk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750083403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vjK8Nf6jMk+Pum6yX6c4qB22D+C1QIkma246h/PK85c=;
	b=GCoVJCTkjR0OsM4yddXnJQDN4G2NqgPUliHdnY2Hp9ajcZG+Vzji9FsawbDQwsnft9Dmtt
	mEfqZI5WlRimyBu0BTncDPKDi2tU47kwPMtXxnStBeGS+REzL8ILEjG7xGH6+Mo6+UwbFd
	k6wZC+OTuTkGcCOXQEgMNvPusuO1+MU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-yZfPyqoNPHGzEIgjQ94tpg-1; Mon, 16 Jun 2025 10:16:38 -0400
X-MC-Unique: yZfPyqoNPHGzEIgjQ94tpg-1
X-Mimecast-MFC-AGG-ID: yZfPyqoNPHGzEIgjQ94tpg_1750083397
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f65a705dso2334270f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 07:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750083397; x=1750688197;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vjK8Nf6jMk+Pum6yX6c4qB22D+C1QIkma246h/PK85c=;
        b=NY/pCGrdqSrpLrS8ShX6S9fJauhkv9I5LDMZhsuqSFCaPWrDsY7K9gxniKaiQw+NJ4
         w8z68Ylx9uzh52MT2UQic0gCTMzCBIscjRcw69h21MM/42pllqXCOZ9Q9fQyUI/g7ihR
         H3lqlNLYIdYf9bMCPq/UZ8wUje6Bypp4OfzGfnOUXvbeZnBwdouQXjyvMjXKYgn/l/22
         HVwl4VB7ICmeLMf9//YuhbQrz4iVNi4A5SwiJxCaQb98PAtJvdYEoSBnIQ1itVzhQSX3
         mMu2kpJa8aAEIfFvIOSQMoA97NH+EvfhGly/M7Xb4q1Xrbe1Yn4nhOuHtwLdqyRmts9+
         dhhA==
X-Forwarded-Encrypted: i=1; AJvYcCWEaumoKJq0FH2phbA6Dvg+5qA12FJgR43zfxdkGPWMk3vr60U8bfk0TRVj/3ALTHfa9h6XlWw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLVw9VWdBn070eV8oLbTBdm7URfo1Zl955QT3dyLMdot3rhEw0
	9RcbEPHdv594gs3xzO5fvI6kAajAh3TktyW0p0bppcc4MYOPOUS4WSHd2MjbgLFSE4EeZNAY4tk
	2OToy+SeJnHnfLweBoUWC1iurX7CTA4mKnTTOO5ET4hyV6RofKqb9Ps3ngg==
X-Gm-Gg: ASbGnctC6M8rNaxSktSdLKUUTj4ndllm5cZinRurkeT/7D/rEmvKnZvUi4a+Xpx51T0
	VxIaeq8HHIHQJNMUEAxfNBSxI7GCJYwvjlSaBWMrtrCFzUGfuQgfkgWJC14EgbeU0/vE98gqVUt
	o83jqIy9Lc0nEmJDv2dfcoaRdwPJLOw9vRawP2UsfNFUttUVtpVIAPF3kiNtsU5iNJCimTVdbUg
	QqK+sfQN9eINqZlg6nFy8PDNif1pNa+5QOgovKwTlD6oXIA+r+XjP2NryNMl37BdKCvjrV4zXCY
	WrrkLolVVGcgMORe2CemVU9X1G1PPuzRUGcIIwrFXEE93o0AQa9UGnnlg6/gtS/02RAz9MyC3te
	8PRjZc5isA00q8+FeZJ2CFE3emofwYKRB1vcmaZfcULwzJoE=
X-Received: by 2002:a05:6000:2f88:b0:3a4:f8e9:cef2 with SMTP id ffacd0b85a97d-3a572e6be35mr7540182f8f.36.1750083396557;
        Mon, 16 Jun 2025 07:16:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQl+H4gKAexmH+c+8O6fMdakOslVhiTKcSUvbsnhOt912uYCjxqkjRCiwR/3QT4RQjnHYahQ==
X-Received: by 2002:a05:6000:2f88:b0:3a4:f8e9:cef2 with SMTP id ffacd0b85a97d-3a572e6be35mr7540078f8f.36.1750083395859;
        Mon, 16 Jun 2025 07:16:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:bd00:949:b5a9:e02a:f265? (p200300d82f25bd000949b5a9e02af265.dip0.t-ipconnect.de. [2003:d8:2f25:bd00:949:b5a9:e02a:f265])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a72cd3sm11304103f8f.32.2025.06.16.07.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 07:16:35 -0700 (PDT)
Message-ID: <bb278ecd-298b-46d3-a4eb-58aa61640ef2@redhat.com>
Date: Mon, 16 Jun 2025 16:16:32 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com> <aEySD5XoxKbkcuEZ@google.com>
 <CA+EHjTyO1tP1uiVkoReZxvV6h2VwfX+1qxBT15JcP3+AXdB8fA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTyO1tP1uiVkoReZxvV6h2VwfX+1qxBT15JcP3+AXdB8fA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aMAdspzf8P8z_6w0HfCbhEAX4QgMhEt9rJ5S3Hq86XE_1750083397
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 08:52, Fuad Tabba wrote:
> Hi Sean,
> 
> On Fri, 13 Jun 2025 at 22:03, Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Jun 11, 2025, Fuad Tabba wrote:
>>> This patch enables support for shared memory in guest_memfd, including
>>
>> Please don't lead with with "This patch", simply state what changes are being
>> made as a command.
> 
> Ack.
> 
>>> mapping that memory from host userspace.
>>
>>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
>>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
>>> flag at creation time.
>>
>> Why?  I can see that from the patch.
> 
> It's in the patch series, not this patch. Would it help if I rephrase
> it along the lines of:
> 
> This functionality isn't enabled until the introduction of the
> KVM_GMEM_SHARED_MEM Kconfig option, and enabled for a given instance
> by the GUEST_MEMFD_FLAG_SUPPORT_SHARED flag at creation time. Both of
> which are introduced in a subsequent patch.
> 
>> This changelog is way, way, waaay too light on details.  Sorry for jumping in at
>> the 11th hour, but we've spent what, 2 years working on this?
> 
> I'll expand this. Just to make sure that I include the right details,
> are you looking for implementation details, motivation, use cases?
> 
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index d00b85cb168c..cb19150fd595 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
>>>   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>>>
>>>   #define KVM_CREATE_GUEST_MEMFD       _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>>> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED      (1ULL << 0)
>>
>> I find the SUPPORT_SHARED terminology to be super confusing.  I had to dig quite
>> deep to undesrtand that "support shared" actually mean "userspace explicitly
>> enable sharing on _this_ guest_memfd instance".  E.g. I was surprised to see
>>
>> IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
>> weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
>> novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
>> is to share memory, but that's a _use case_, not the property of guest_memfd that
>> is being controlled by userspace.
>>
>> And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
>> memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
>> instance is the _only_ entry point to the memslot.
>>
>> So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
>> KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:
>>
>>          if (kvm_slot_has_gmem(slot) &&
>>              (kvm_gmem_memslot_supports_shared(slot) ||
>>               kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>>                  return kvm_gmem_max_mapping_level(slot, gfn, max_level);
>>          }
>>
>> much more intutive:
>>
>>          if (kvm_is_memslot_gmem_only(slot) ||
>>              kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
>>                  return kvm_gmem_max_mapping_level(slot, gfn, max_level);
>>
>> And then have kvm_gmem_mapping_order() do:
>>
>>          WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
>>          return 0;
> 
> I have no preference really. To me this was intuitive, but I guess I
> have been staring at this way too long. If you and all the
> stakeholders are happy with your suggested changes, then I am happy
> making them :)
> 
> 
>>>   struct kvm_create_guest_memfd {
>>>        __u64 size;
>>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>>> index 559c93ad90be..e90884f74404 100644
>>> --- a/virt/kvm/Kconfig
>>> +++ b/virt/kvm/Kconfig
>>> @@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>>>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>>>          bool
>>>          depends on KVM_GMEM
>>> +
>>> +config KVM_GMEM_SHARED_MEM
>>> +       select KVM_GMEM
>>> +       bool
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 6db515833f61..06616b6b493b 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>>>        return gfn - slot->base_gfn + slot->gmem.pgoff;
>>>   }
>>>
>>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>>> +{
>>> +     const u64 flags = (u64)inode->i_private;
>>> +
>>> +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>>> +             return false;
>>> +
>>> +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +}
>>> +
>>> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>>
>> And to my point about "shared", this is also very confusing, because there are
>> zero checks in here about shared vs. private.
> 
> As you noted in a later email, it was you who suggested this name, but
> like I said, I am happy to change it.
> 
>>> +{
>>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
>>> +     struct folio *folio;
>>> +     vm_fault_t ret = VM_FAULT_LOCKED;
>>> +
>>> +     if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>>> +             return VM_FAULT_SIGBUS;
>>> +
>>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>> +     if (IS_ERR(folio)) {
>>> +             int err = PTR_ERR(folio);
>>> +
>>> +             if (err == -EAGAIN)
>>> +                     return VM_FAULT_RETRY;
>>> +
>>> +             return vmf_error(err);
>>> +     }
>>> +
>>> +     if (WARN_ON_ONCE(folio_test_large(folio))) {
>>> +             ret = VM_FAULT_SIGBUS;
>>> +             goto out_folio;
>>> +     }
>>> +
>>> +     if (!folio_test_uptodate(folio)) {
>>> +             clear_highpage(folio_page(folio, 0));
>>> +             kvm_gmem_mark_prepared(folio);
>>> +     }
>>> +
>>> +     vmf->page = folio_file_page(folio, vmf->pgoff);
>>> +
>>> +out_folio:
>>> +     if (ret != VM_FAULT_LOCKED) {
>>> +             folio_unlock(folio);
>>> +             folio_put(folio);
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
>>> +     .fault = kvm_gmem_fault_shared,
>>> +};
>>> +
>>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>> +{
>>> +     if (!kvm_gmem_supports_shared(file_inode(file)))
>>> +             return -ENODEV;
>>> +
>>> +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>>> +         (VM_SHARED | VM_MAYSHARE)) {
>>
>> And the SHARED terminology gets really confusing here, due to colliding with the
>> existing notion of SHARED file mappings.
> 
> Ack.
> 
> Before I respin, let's make sure we're all on the same page in terms
> of terminology. Hopefully David can chime in again now that he's had
> the weekend to ponder over the latest exchange :)

Fortunately, the naming discussions I have in my spare time (e.g., how 
to name my two daughters) are usually easier ;)

As raised in my other reply, talking about mappability is IMHO the wrong 
way to look at it.

VM_SHARED is about shared mappings.

shmem is about shared memory.

You can have private mappings of shmem.

You can have shared mappings shmem. (confusing, right)

One talks about mmap() semantics (CoW), the other talks about memory 
semantics.

This is existing confusion even without guest_memfd making some of its 
memory behave like it shmem I'm afraid.


If we want to avoid talking about "shared memory" in the context of 
guest_memfd, maybe we can come up with a terminology that describes this 
"non-private memory" clearer. (and fixup the existing doc that uses 
private vs. shared)

kvm_gmem_supports_ordinary_memory()
kvm_gmem_supports_non_private_memory()
...

which also don't sound that great.

(I don't like kvm_gmem_supports_shared() either, because there it is not 
clear what is actually supported to be shared. 
kvm_gmem_supports_shared_memory() would be clearer IMHO )

-- 
Cheers,

David / dhildenb

