Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8E93DE43D
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774297368; cv=pass; b=FFYkIW5XzhRoRh/xwuIYxYyBgaSdpduS4/tYWWzH2ctmQyx5g+ntNhf/Odz5WQN/+ZlclgHWs/WniNcUeZy/DlA15wPE6lPjLyoSCOyDWxfSHIuDb6rk8r+YgXUDf4Y4726PgeTkjq/Is5Le8I6mLfSl2N8KyES0pBoeYCxzXr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774297368; c=relaxed/simple;
	bh=+Ww3YVEwz3akOCPkGfwPOz5g/SjxY63PNjUlqwWXbGQ=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iOCnpz3qWXhd/uqmWk3nCmkvZOEWQFWpRLEUMnW6IKEgmbPHSCYl+1SNSv3SaX23jePu/kV2OipJ3U431PyzfYGX/UOJzpa51cls/3OSXjQXmTSjWoEUwNIYKnODX9+dkWVfEmd/E8AMLHKNwdu669GyXmWDxSRKr+WtLCjZIgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hX1kBEqO; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hX1kBEqO"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ffdd9a6155so4591903137.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 13:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774297365; cv=none;
        d=google.com; s=arc-20240605;
        b=TZODpClHf/LkAK3XvNbOQ8IbbcQdSy3twnGeGji1zsJ+ptMrTPUkWkQWcsPMmb1Uag
         ORW++ulStw9Mifzm5Cgx2QhIlXRtEtSpxKkh3Zq/jgUeIeeo5UPTJCsJBoqSDvLJxuT2
         9fdjFU2gqIKNmkxK/QUPQJ/FSeMrSvZ2JMtVIBXEOUci+bBfUVBSXg1sTlY2pT3ERbwr
         IvyzGTA6mrqBapuBzirh+r0idGi4JGWLmafQte4Kulf31TRSGZWcm0iYn63zmUB5Ljek
         hCb/OeS3y9o7dS3qyZBDdlfp3O+AvdwKWTweXurhMdz+TAOpXcG9cCnsDfd4lH1mtZHb
         eo+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
        fh=tjG+LxnZq3oXQs0G8RLM8O7gqhccIxzMOgP9e5RfRVE=;
        b=Cinlzeho5y+8RpR5ecJ77NvIvnQa4OyykM96bGThsaZ+jbRAb8FXInNp9UNOhqXmWh
         JbWlLvJ0Rp+LCppBxd9ZMGDpHGa0dvdyfVBAP1kWNVqo64K2/zgqTgGZRQvKT8M2JFH1
         UGj/Iekc6+KzId+7eQhbJHyJmPc0LlsWx9syOsZ/Rw5Uj+LeJ4lwL3phNsYJCBWwRtt1
         WjLf/d9e0Q5NJG7BeKTqjL3/O5xWh35M2YT6RsFxGvnnMfoBZzdQRusiVMleG+jebQmn
         U4nZyMjWuYALQMcvheBo6+OqrE6qu7f7geRacbawJtr9IBXM8CQvfP1vLQCfz96JqPWG
         b2kg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774297365; x=1774902165; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
        b=hX1kBEqOtb74n5cLCLiFPAhcSlpM6r5Y1NyiTRZgo9Zah/tcm6vFdVMR9vohRWwPtW
         FuwsZfOhuA5kuoVq6JpgpZtSM518dPF9HnYi9HKxy3b4B9V02frdhTTfA4Fcz3xRaEbH
         5729sNP1ygfZr71q8OKUpQliYUZZzwurMcmbc4B3DZSZsyud4aUHUkS6UE47OLIWfXjI
         IaPDVO3xERCI9mOICwZyNekV+l+aEgbor3mUsRUDplD/HS3bfpF6aNcwRUEBmal1EZtQ
         tx3mi3FLzjQosWt7Jk/6oLNvfcrFvm0H2LGTgn5o1IFmAKg0r55m4m8WibGLtZKpkN/I
         kLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774297365; x=1774902165;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
        b=ldqFGneJCt06Hk9TYy1V2bp/vNNJD1rdiXHMwwYLz85NISI2wP5gh8bi9hIYS98RKY
         85ICS+dNRXZnEaVl4b89N4aag/PWuVyZkXxzKm6M6lsknkA0ZbAP9o/378qIGqnopI4b
         26BzD2xvqIODDZiWH66lK9IgnTYjOUd5DPyhc1nCkvjxbIdgrJhbqTLc6dc81DQsaWFH
         cvG7SwdG6EtNrxCquTlTSSLvBXu1lEKx/T9Yf2OnCMAQL72FFyev/RiDK7B/emvaW+ig
         TrmX5CjbxPutmxlyPiZZ+tP+5Lm7TZnDaGN1/FNHnaUN20c7nABcBg4dgxGbmnICw9NK
         zRMA==
X-Forwarded-Encrypted: i=1; AJvYcCW0i4lKTeefXwmT+mO5lNU/srM0rmaFwqCgA3ka+iEZWI/I4wJwgY+xVV48LVvXAnfLVUMoEuw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYFQKBjcahXo6I7+DZNYZUfjAfk/xZsN4nfoXu2MhN2zVPJJFZ
	XmS1XJakgT8/fiHzZr8rmdbCtTd9fnpp2LCklo0apFaswZDQOm6s8gueoDLMyP5RNZ5cAh2JvBx
	tuDcp5Tf77bcvlQB3t4wwKQiiiMbi7bVgtpmGoqy5
X-Gm-Gg: ATEYQzww54njZcFdEq5XoEPzaf5zxZUjuYacXysyV9VZBGrvGTs8d1mwnmbpPtSockR
	2a6WrEkbfJDQK7LOW30lHzWWaEUeoczvn75FF8WHuPSaxUko9emSvMadJbcqWOmEWs8EEe82DiQ
	uWtIXGaM/ceT/qEmhuRt67BuAeLZDqCFUAY/9Ed5fuGWeFIn4cJddc8UnODavMOonW8r+QKfLnt
	boW2tBFXlt9RrIbojkZ2urTUoXIdhBdpxVEDy8tQW0xHOFvhffkiyHs7HCC1YGHw2ICSXfwFbN6
	pXoULesrbn/eOFz61AOntCKaegMp01L76qURz/xHVUktlMYgDYZ65Hll3txdCPztUn+57w==
X-Received: by 2002:a05:6102:3a06:b0:602:8742:1fa with SMTP id
 ada2fe7eead31-60316013f44mr514571137.9.1774297364023; Mon, 23 Mar 2026
 13:22:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 13:22:43 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 13:22:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <0a14c10d-0dab-4b9c-85ec-e0ee25cd0db8@kernel.org>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-6-kalyazin@amazon.com>
 <0a14c10d-0dab-4b9c-85ec-e0ee25cd0db8@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 13:22:43 -0700
X-Gm-Features: AQROBzAJTtmZ8_CHcmYDgt7IaYmvr2Pi4WE03drdmWTq3AGR3rA_vEwuIGtsbTw
Message-ID: <CAEvNRgHqJGwmAfS8TuGBbUoQehpqY9GdtjUS=+Hc1ViK79RL4w@mail.gmail.com>
Subject: Re: [PATCH v11 05/16] mm/gup: drop local variable in gup_fast_folio_allowed
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 3/17/26 15:11, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Move the check for pinning closer to where the result is used.
>> No functional changes.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>  mm/gup.c | 23 ++++++++++++-----------
>>  1 file changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 5856d35be385..869d79c8daa4 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>>   */
>>  static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>  {
>> -	bool reject_file_backed = false;
>>  	struct address_space *mapping;
>>  	unsigned long mapping_flags;
>>
>> -	/*
>> -	 * If we aren't pinning then no problematic write can occur. A long term
>> -	 * pin is the most egregious case so this is the one we disallow.
>> -	 */
>> -	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>> -	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>> -		reject_file_backed = true;
>> -
>>  	/* We hold a folio reference, so we can safely access folio fields. */
>>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>>  		return false;
>> @@ -2793,8 +2784,18 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>  	 */
>>  	if (secretmem_mapping(mapping))
>>  		return false;
>> -	/* The only remaining allowed file system is shmem. */
>> -	return !reject_file_backed || shmem_mapping(mapping);
>> +
>> +	/*
>> +	 * If we aren't pinning then no problematic write can occur. A writable
>> +	 * long term pin is the most egregious case, so this is the one we
>> +	 * allow only for ...
>> +	 */
>> +	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
>> +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>> +		return true;
>> +
>> +	/* ... hugetlb (which we allowed above already) and shared memory. */
>> +	return shmem_mapping(mapping);
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> I'm wondering if it would be a good idea to check for a hugetlb mapping
> here instead of having the folio_test_hugetlb() check above.
>

I think it's nice that hugetlb folios are determined immediately to be
eligible for GUP-fast regardless of whether the folio is file-backed or
not.

> Something to ponder about :)
>
> --
> Cheers,
>
> David
