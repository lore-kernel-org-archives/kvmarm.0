Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457DE1A3154
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 00:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559676; cv=pass; b=gGHAT+3JsbVGdDhYlB9BuWP/jmzjTX0Dco4qbvvzgOeHV/F4z/AdOw0AmlbnIgbwcGq65X1CqMXqx97rjplMHlEb5cVHGZLz+DgsGLiXUgnbeWHmwBmBHtZYLSabQFNXneaARWXmsgRMIcnz3pKgswnZ/KTR6Sb39J9x1/VaiGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559676; c=relaxed/simple;
	bh=/kA8M2mqA273+dmaL09+/9pRCOJMn38c8HSeLt8VdYo=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mJqpBLpRTaFRkIZPHD8H3vwYOO/zWWJqjE8bsQO63IoCzk2gJvTEYuI9NMPpCtLMekQkqtZOf9Z6QeKu0SJR5NRnYa0L6ozVuxAoyYLOuj9BzE5J8mG6hpxU+WyKP1HGY3XlTISweQa945Kvn2x97LG5PLvphzMN6P8zQTOmTns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2RJw8huo; arc=pass smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2RJw8huo"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-93f5774571eso1621476241.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 16:21:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769559673; cv=none;
        d=google.com; s=arc-20240605;
        b=Bt+qNL3XKp6skCCNjVLFDxkvIIuGBrh738SCi1SQGsGxHLOFmXrRwrokfVBiuNOzVi
         OAP0CyHy8wp3EjPN7mATlJtGcvsQoRNLGHnQ2y/vq/sHsuVutkoQM716VcPmd9mr+f7n
         yJ6gioJNmFVHK3VFBRUQiCKhsgQMsrE9RGBc6idNhxcu69YkH2KZwE6iMotafoXMbkXN
         O6S61RYalTIVwyHPyguAUY6fjOgE55Psh+tOwEKXQtmOMCLwFBnAgz1puFp3mKmLK6Yz
         BZQaRNlxojIdtW7dNq96vM7JWfbwFY9j0/AE0TriVhqVkAa2YgsKRumQ8CfEkc7i4zp7
         koxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
        fh=iPr6PO9b70thTeMi21IuAqbiyJZ13p5y9uN0UymlKqI=;
        b=GTiBKcm+BfM79ObmD7Qtlk+s6g9P2OJUKmVWwjQKRkJ7uMYgFoMAoad8PXFCiqakTR
         Tmze3VC6CaBcUyfNKUEtrNqtn5N5r5ri3r5HKgYzSmRSlNLTzpOxriGQozRt0z7yNN56
         DIkLYRR0ANJ3NpXW9n/LGNX9ns6rS4udSVUN6zT8LveEUSd5iB9Cgy9Zqe+PMwoaR011
         mQBo8b7dxHnVD6ckpIl2nXALz7HHSk4JH7jJqIH2PjIEcfJ5o31m9WKP0aphOQOsoW/S
         RFmgpcLh6BBzp41djG7TswsOf9xObflvUXtknohUipU2kP2Im+OS88V7lgrmBstTjI5g
         dSCg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769559673; x=1770164473; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
        b=2RJw8huogR28EKXUwNngQmOFOki40CuupkT/9S+Ix2UY5CD9B4C7357MPIyQuHcH6L
         5fh2xgcZZo2XxnpzpvWojcbMhDiLjpur6NZWqxTenD0ZQAhfIdvu7EKUD1AzJFahr2CU
         u5QHq4utb+CoHXPgm7uxZXOaRB7ixlHJxQBeZ/o7evyLSKMFbCBfRoGcGIYRdm8Ny0aJ
         vFkFH0Dhbb3IK2Vp4HmZ8AcSrrgZoG6EAP2Y8t2LsPaox0wjV0U5LW9IRJhu2A70lXnq
         +NiMdW6Hp3WeR4aRKWc+dOZq9izs+mNoxV1BaHnt80qLqU+SnePhYr4MF8LTTJL67+Tf
         f9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769559673; x=1770164473;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
        b=i3hSoUCJwGp5DT5BursBChPb+GZ0GGkVaEm2D67OmITmXCo1wbROSbKs06EcXvdzdA
         JHcS1lM8D8FS/5N1AaPium2TcWNSLrQh5mn+TzwdMyTuKCOl2ioeFN9blorIO/qWa0Zq
         8kt3KF0S8Q0K7asUfpKVMrR8t08fF9tt8ltusxrRqp8qLWayu1zBHMdyJgwrViiEH93p
         gSb5/H+Y3YK+C1kUcnppBsfBM5JCG7xrhzBZv/bs1aKooKcUZKavky0vjSzPoBQbn9vt
         ivCvQqLFw7PdsP/RqpLgKYbaJJKqtOlV+/cAD7iGJ8PrwRB6gqHJLeFpvPiKOBgqVwM/
         uiOg==
X-Forwarded-Encrypted: i=1; AJvYcCX7FuRkzujFm1/BZLpgRnwmyoQZ1+LhuYK+1aRDxpo5ODGth1OOQFBPn9nsOOcMV7NdBRV7UQk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaJBGb9yQDXYv8/vIKem+hU1kk9njqfimVqkcteqMR0g/PoxZh
	dypLgM7QLH21woq7pLVXqemSri75j9FjUGZMGIp7VqOgtPygATmzI5wFnxvlrt2ecXMq0l7MMho
	Dedbtonf1MNJr94b7PS00eIm5m/Hzn8RjBduF+zix
X-Gm-Gg: AZuq6aKHCH0yGG8qItBmnw1eXGtT8WPUfBLBSWVYG7kg5NXnelThwehljEwNi6xFy/J
	nWPhQ3RgzUSyr9yaSYaxrtNeG9DJcGmDM7HrEQLzRAcQ/jr0GEr8k6FIP+nUDPeLKlBiWO0njB8
	RKdMNUkvaElJgGXBla7MKxTU75MYC/Soc7tLjBCAbJjLsph4tTImVBF8eLI4CdfQnLNagzljX1B
	OPTwkPI9807mNiYEfr/tioAIlTkXzPxkDbs7SLWkl/ZN910g2RtpXhjvNujb1pWGhoUJ34lgSJF
	cEpX5eUhnr10yWPiXsqaAyD4zA==
X-Received: by 2002:a05:6102:2926:b0:5f5:2ab7:cef4 with SMTP id
 ada2fe7eead31-5f7236280c7mr1308564137.12.1769559672438; Tue, 27 Jan 2026
 16:21:12 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 16:21:11 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 16:21:11 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <afddc163-4b1e-46ee-920a-85de3b347291@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com> <CAEvNRgEvd9tSwrkaYrQyibO2DP99vgVj6_zr=jBH5+zMnJwYbA@mail.gmail.com>
 <afddc163-4b1e-46ee-920a-85de3b347291@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 27 Jan 2026 16:21:11 -0800
X-Gm-Features: AZwV_QgCVtca03XgnQCypNXAbjgX301aeAGuQByaW4GAjqTre8UeoPpevsc7bzA
Message-ID: <CAEvNRgFCwU7ezDV4Spj=H1JZohG9CSQRKMh_h1OGY1GrR2=7Eg@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "surenb@google.com" <surenb@google.com>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"thuth@redhat.com" <thuth@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com" <derekmn@amazon.com>, 
	"xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On 22/01/2026 18:37, Ackerley Tng wrote:
>> Nikita Kalyazin <kalyazin@amazon.com> writes:
>>
>>> On 16/01/2026 00:00, Edgecombe, Rick P wrote:
>>>> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>>>>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>>>>> +{
>>>>> +     /*
>>>>> +      * Direct map restoration cannot fail, as the only error condition
>>>>> +      * for direct map manipulation is failure to allocate page tables
>>>>> +      * when splitting huge pages, but this split would have already
>>>>> +      * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().
>>
>> Do you know if folio_restore_direct_map() will also end up merging page
>> table entries to a higher level?
>>
>>>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>>>> +      */
>>>>> +     if (kvm_gmem_folio_no_direct_map(folio)) {
>>>>> +             WARN_ON_ONCE(folio_restore_direct_map(folio));
>>>>> +             folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>>>> +     }
>>>>> +}
>>>>> +
>>>>
>>>> Does this assume the folio would not have been split after it was zapped? As in,
>>>> if it was zapped at 2MB granularity (no 4KB direct map split required) but then
>>>> restored at 4KB (split required)? Or it gets merged somehow before this?
>>
>> I agree with the rest of the discussion that this will probably land
>> before huge page support, so I will have to figure out the intersection
>> of the two later.
>>
>>>
>>> AFAIK it can't be zapped at 2MB granularity as the zapping code will
>>> inevitably cause splitting because guest_memfd faults occur at the base
>>> page granularity as of now.
>>
>> Here's what I'm thinking for now:
>>
>> [HugeTLB, no conversions]
>> With initial HugeTLB support (no conversions), host userspace
>> guest_memfd faults will be:
>>
>> + For guest_memfd with PUD-sized pages
>>      + At PUD level or PTE level
>> + For guest_memfd with PMD-sized pages
>>      + At PMD level or PTE level
>>
>> Since this guest_memfd doesn't support conversions, the folio is never
>> split/merged, so the direct map is restored at whatever level it was
>> zapped. I think this works out well.
>>
>> [HugeTLB + conversions]
>> For a guest_memfd with HugeTLB support and conversions, host userspace
>> guest_memfd faults will always be at PTE level, so the direct map will
>> be split and the faulted pages have the direct map zapped in 4K chunks
>> as they are faulted.
>>
>> On conversion back to private, put those back into the direct map
>> (putting aside whether to merge the direct map PTEs for now).
>
> Makes sense to me.
>
>>
>>
>> Unfortunately there's no unmapping callback for guest_memfd to use, so
>> perhaps the principle should be to put the folios back into the direct
>> map ASAP - at unmapping if guest_memfd is doing the unmapping, otherwise
>> at freeing time?
>
> I'm not sure I fully understand what you mean here.  What would be the
> purpose for hooking up to unmapping?  Why would making sure we put
> folios back into the direct map whenever they are freed or converted to
> private not be sufficient?

I think putting the folios back into the direct map when the folios are
freed or converted to private should cover all cases.

I was just thinking that being able to hook up to unmapping is nice
since unmapping is the counterpart to mapping when the folios are
removed from the direct map.
