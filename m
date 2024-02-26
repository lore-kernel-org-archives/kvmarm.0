Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C349C1CAA5
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 09:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941467; cv=none; b=Y3zOQrDMDU28EdvzJ2R+qvVOcJuo+TpHcaX6lZZBVeYcMM5X4zIqTcAat42zQ14sGWYA4aVy0ACncqmt0GAbSvi+2AgvrgImcsNDe9j2vF/ONG0BNlGQl51/zPo4ViE/+H1uLcApJ0W+1dOA7NONmbZLShN3NZJwmVtZvEyZEM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941467; c=relaxed/simple;
	bh=XSL/g/14xpqyEGYdhwSeZ/pM0ibpj9YTYSBugxs/ZP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWjb5sv7gK5sk4DvlVeFiXAzu1OthpZ/hy3/mMT5lAxX+VeZLLspwtfN5hk10p7hlxkWCqIOmASIYpemUR2SW3ApF3OjX8nYN4WVCPbhbkJ7ryUbIvA6k8QNgKvof5zPHVyXLCH8EX4OswZdTKpBHZxFHVUG3ZgscOTW1hLcr8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VpiBYN5V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VpiBYN5V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708941464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=im4R+nBxYy2FHrdNhZNGGO9MPDKXc8UdPpcjtEZVW2A=;
	b=VpiBYN5VvMoDW6pSEMj1U8MVVPU15Zwiu4ibamHi18H/G4yxEMFNCUoocpqymvs53AMQBA
	iCjKm+eXIZJWI/jb6vDrTnP8nrCq71zwaRo8PTU0WDgDoujtNguDQQeGijj67qxVvW73Bt
	uCDhrAwygrvSSRm/WnTmTC7ID2deCtk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-HoabChDEMKyTwQ37M0je_w-1; Mon, 26 Feb 2024 04:57:43 -0500
X-MC-Unique: HoabChDEMKyTwQ37M0je_w-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d7fcb70c2so1080171f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 01:57:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708941462; x=1709546262;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=im4R+nBxYy2FHrdNhZNGGO9MPDKXc8UdPpcjtEZVW2A=;
        b=Oys8Qp7oxF0J+CTyrq7C3HQf/t4120Ayj0Vi2gd8r4qLMrxvKz35eJxlADiUlAbjbs
         dJE6W6D0lFDhEcbyvn9eutFPDxEqMmNemBkHpYo1hfzqTN8l1xLmH9jGZQbFX4jxmktw
         Kw5b7F3DmamqJM+PwdQz/rERSJsXW/QzL4HQvtRD/s+uO0sgxr9hkLKVsqMjNY/zk70Q
         IloZ8ououDleRt6r1AkwGC3lL54lABJUPyVLlHNH6u+zMaIaRMrobIyfw5AbYWP93KVU
         h+X7hS4J/fUYX1KevRCpypJrw20kGcdmi1gg8UlRnMiaRQVrd/lXGEiE/SbJUxIirL+K
         FC1w==
X-Forwarded-Encrypted: i=1; AJvYcCUEk32cVG2tZmnOYbLGi1DHMy/qdKJE9n/3C3CXhokdZBJzCGBFXalpq1ATLfMxdGzoF9pkmy0YvON5Gf9t0c2khD0CeNcJ
X-Gm-Message-State: AOJu0YzC6irl/77pO3H+0ADH8x1WEM2Q0i3U0jcq8lSsHkVXrLv2TJ6X
	FHVFyytEIWxmDKAxyjUNxlNYnjlK/dfEuQuFa6ebVa39sy/JpXtwkEmd7MADEztnJQX+9+53y7C
	PQ/oDO2yjYVF2dGn1mV95nKc/XTHo+LRqNEsZd0sXoNS8VqLkvpYnTQ==
X-Received: by 2002:a05:6000:154c:b0:33d:4dbd:d05e with SMTP id 12-20020a056000154c00b0033d4dbdd05emr6892869wry.22.1708941462379;
        Mon, 26 Feb 2024 01:57:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvWzHnMF0vh73+i9nlM3lu4hssE+pUvVas00Bfe3XcTkhPqlvZi0z4WdDyosJeAE4NjVhEpw==
X-Received: by 2002:a05:6000:154c:b0:33d:4dbd:d05e with SMTP id 12-20020a056000154c00b0033d4dbdd05emr6892819wry.22.1708941461951;
        Mon, 26 Feb 2024 01:57:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c72f:f700:104b:9184:1b45:1898? (p200300cbc72ff700104b91841b451898.dip0.t-ipconnect.de. [2003:cb:c72f:f700:104b:9184:1b45:1898])
        by smtp.gmail.com with ESMTPSA id k6-20020a056000004600b0033d87f61613sm7647716wrx.58.2024.02.26.01.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 01:57:41 -0800 (PST)
Message-ID: <83d6edb8-bfd0-4233-a4cf-b573fa62c8d9@redhat.com>
Date: Mon, 26 Feb 2024 10:57:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 03/26] KVM: Add restricted support for mapping
 guestmem by the host
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
 <20240222161047.402609-4-tabba@google.com>
 <86461043-fa5b-405d-bd2e-dc1aba9977c5@redhat.com>
 <CA+EHjTyYQWdc14kFiQs0Ous2Hnep88v9-Us9m68TneLm9Eqvzw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTyYQWdc14kFiQs0Ous2Hnep88v9-Us9m68TneLm9Eqvzw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26.02.24 09:58, Fuad Tabba wrote:
> Hi David,
> 
> On Thu, Feb 22, 2024 at 4:28 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>>> +{
>>> +     struct folio *folio;
>>> +
>>> +     folio = kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->pgoff);
>>> +     if (!folio)
>>> +             return VM_FAULT_SIGBUS;
>>> +
>>> +     /*
>>> +      * Check if the page is allowed to be faulted to the host, with the
>>> +      * folio lock held to ensure that the check and incrementing the page
>>> +      * count are protected by the same folio lock.
>>> +      */
>>> +     if (!kvm_gmem_isfaultable(vmf)) {
>>> +             folio_unlock(folio);
>>> +             return VM_FAULT_SIGBUS;
>>> +     }
>>> +
>>> +     vmf->page = folio_file_page(folio, vmf->pgoff);
>>
>> We won't currently get hugetlb (or even THP) here. It mimics what shmem
>> would do.
> 
> At the moment there isn't hugetlb support in guest_memfd(), and
> neither in pKVM. Although we do plan on supporting it.
> 
>> finish_fault->set_pte_range() will call folio_add_file_rmap_ptes(),
>> getting the rmap involved.
>>
>> Do we have some tests in place that make sure that
>> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) will properly unmap
>> the page again (IOW, that the rmap does indeed work?).
> 
> I'm not sure if you mean kernel tests, or if I've tested it. There are
> guest_memfd() tests for
> fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) , which I have
> run. I've also tested it manually with sample programs, and it behaves
> as expected.

Can you point me at the existing tests? I'm interested in 
mmap()-specific guest_memfd tests.

A test that would make sense to me:

1) Create guest_memfd() and size it to contain at least one page.

2) mmap() it

3) Write some pattern (e.g., all 1's) to the first page using the mmap

4) fallocate(FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE) the first page

5) Make sure reading from the first page using the mmap reads all 0's

IOW, during 4) we properly unmapped (via rmap) and discarded the page, 
such that 5) will populate a fresh page in the page cache filled with 
0's and map that one.

-- 
Cheers,

David / dhildenb

