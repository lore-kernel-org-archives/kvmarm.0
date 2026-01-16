Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53069145348;
	Fri, 16 Jan 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.156.205.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575382; cv=none; b=Wqaav0DocZhMRVW24XtHCm8KiDT2MPD3xL6t7xGtjCw7A/hQkS8BuT2a8qi29MEvygpk/Xaaw+2O09IKQJo+FviLvEbf3X9Kjp4e5HWEVg84Ghi9uarzStQSmEILzlpLfm9538A2VN9k3H2Cyqo5nRbHfJVK7xYr848vHXUnqu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575382; c=relaxed/simple;
	bh=BxZnyiI6YgvskaCwpGEH+hfPdJiGYdOF3yczju02EHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Z23Aq9ewS2F9z9BqrnjZtvDNrWEPBKXp+s751UWTp2WK3dkYWBnIzXktHgD/R0KFgqxP+nWPjb6ddFuFcObyW0FZniLmQE3EdXBmVAjiFv1e94x9m50UXwQBQ5XyPz4vfgQFT5PToz5C8tQpla3/MAyt5l3v1FltvcwmXkq23bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=E0kFmVWd; arc=none smtp.client-ip=18.156.205.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="E0kFmVWd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768575380; x=1800111380;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=IEO4wkDrWsP8gb8dVRwVt7tfKvgBUuiF6zz/e0uDn6E=;
  b=E0kFmVWdSct5dPf1WwjANwcxW4WVDYPPlQRzslfKBnZ/I3S1SuWfdMaq
   1JQPcy/oHEhO3uC+e6uWsXpKSvAaCmHeKs+RxWLKYseLymm3iwE7KdXVV
   b2DDnEl7jP3cx/tUEYslwJCNf74M6KhcPL/Mqs315NbfF7QG9HGmP5kvU
   /4XLKosJ3GbYB6qFxXIR9/KHBSwWqAHvgVVIg6X5sz8yMKhiHDU4gXpnN
   Cpzba0zDFv0s7VAwnBzYOf9RtM1xQ4l5BCVOzJa7V40a0CDoQzlZvL6YE
   aKZYBjjZKXUKypX4QQPcdTOp/IPvgK1s8d2GPeLF13f+wHYMxBJQ8NKkp
   Q==;
X-CSE-ConnectionGUID: t80jrskTRzKiYCPAndralA==
X-CSE-MsgGUID: hn4FZT+mTRGLqNyYAxxD5Q==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="7704673"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 14:56:02 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:3849]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.41.192:2525] with esmtp (Farcaster)
 id 260b6298-10cb-4eed-9151-e85b598fcfcc; Fri, 16 Jan 2026 14:56:02 +0000 (UTC)
X-Farcaster-Flow-ID: 260b6298-10cb-4eed-9151-e85b598fcfcc
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 14:56:01 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 14:55:57 +0000
Message-ID: <6b50a83e-acd7-4db3-ae9b-015ffad4f615@amazon.com>
Date: Fri, 16 Jan 2026 14:55:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 02/13] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
To: Ackerley Tng <ackerleytng@google.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
	<jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
	<shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
	<wyihan@google.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-3-kalyazin@amazon.com>
 <CAEvNRgGrpv5h04s+btubhUFHo=d6mBFbr2BVrMt=bWuWOztdJQ@mail.gmail.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <CAEvNRgGrpv5h04s+btubhUFHo=d6mBFbr2BVrMt=bWuWOztdJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D012EUA003.ant.amazon.com (10.252.50.98) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)



On 15/01/2026 21:40, Ackerley Tng wrote:
> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:
> 
>> From: Patrick Roy <patrick.roy@linux.dev>
>>
>> This drops an optimization in gup_fast_folio_allowed() where
>> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
>> by default"), so the secretmem check did not actually end up elided in
>> most cases anymore anyway.
>>
>> This is in preparation of the generalization of handling mappings where
>> direct map entries of folios are set to not present.  Currently,
>> mappings that match this description are secretmem mappings
>> (memfd_secret()).  Later, some guest_memfd configurations will also fall
>> into this category.
>>
>> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   mm/gup.c | 11 +----------
>>   1 file changed, 1 insertion(+), 10 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 95d948c8e86c..9cad53acbc99 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2739,7 +2739,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>   {
>>        bool reject_file_backed = false;
>>        struct address_space *mapping;
>> -     bool check_secretmem = false;
>>        unsigned long mapping_flags;
>>
>>        /*
>> @@ -2751,14 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
> 
> Copying some lines the diff didn't contain:
> 
>          /*
>           * If we aren't pinning then no problematic write can occur. A long term
>           * pin is the most egregious case so this is the one we disallow.
>           */
>          if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>              (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> 
> If we're pinning, can we already return true here? IIUC this function
> is passed a folio that is file-backed, and the check if (!mapping) is
> just there to catch the case where the mapping got truncated.

I have to admit that I am not comfortable with removing this check, 
unless someone says it's certainly alright.

> 
> Or should we wait for the check where the mapping got truncated? If so,
> then maybe we can move this "are we pinning" check to after this check
> and remove the reject_file_backed variable?

I can indeed move the pinning check to the end to remove the variable. 
I'd do it in a separate patch.

> 
>          /*
>           * The mapping may have been truncated, in any case we cannot determine
>           * if this mapping is safe - fall back to slow path to determine how to
>           * proceed.
>           */
>          if (!mapping)
>                  return false;
> 
> 
>>                reject_file_backed = true;
>>
>>        /* We hold a folio reference, so we can safely access folio fields. */
>> -
>> -     /* secretmem folios are always order-0 folios. */
>> -     if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
>> -             check_secretmem = true;
>> -
>> -     if (!reject_file_backed && !check_secretmem)
>> -             return true;
>> -
>>        if (WARN_ON_ONCE(folio_test_slab(folio)))
>>                return false;
>>
>> @@ -2800,7 +2791,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>         * At this point, we know the mapping is non-null and points to an
>>         * address_space object.
>>         */
>> -     if (check_secretmem && secretmem_mapping(mapping))
>> +     if (secretmem_mapping(mapping))
>>                return false;
>>        /* The only remaining allowed file system is shmem. */
>>        return !reject_file_backed || shmem_mapping(mapping);
>> --
>> 2.50.1

