Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9E941C93
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIybnI0X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701194125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6IpfI+5hX9oWAaqFKgR7pMHL53l1oeTSERZKZMVDwEk=;
	b=NIybnI0XHi8b6h0H2OE7QaEIEDQJNJpdPj5aPLM8RMOuPJ1rbPHPyS47P7HkAUQpH+ynYN
	808KDRDd68mM2/9el+wwTjjwixBMSah0v4uM5vfEp/7fHjpaGRqVs9/29MWIJH0/sBjeKb
	Xgr+VZ0KKyJZOhU0z3VSdD7FRoa8khI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-Yd4IGitmODinzEh6Ikb1qw-1; Tue, 28 Nov 2023 12:55:21 -0500
X-MC-Unique: Yd4IGitmODinzEh6Ikb1qw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33309619b52so6762f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 09:55:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701194121; x=1701798921;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IpfI+5hX9oWAaqFKgR7pMHL53l1oeTSERZKZMVDwEk=;
        b=Uq5Ym9QCTLlaXcmpdj37EelzSFzwuyse/Amjq4sV3z5org4ti5Utb0hCIavBJmvC4w
         QqSuKOk+HTclQ1MkRELRPYpiSCgfd5XNgBsE1zJRjG0XNXOHno/31lkzGmYSo1pCCrvX
         cjyhT1WG46ozu8W6IwkIXP7Ejdh7w7MuXP4XUVJYpayZEHe+T+mwoCCK//oHcL6x4FJw
         UsNX4zKId0s601MBsmwT3w1f0/arC71rdwQeV2S7A+P8z6C36HnzF6IIYWix/7IdW8F6
         ukJbYlUY0kc1Rs24k0SaQLz7eQJiTkt8tEyuYQBktWoMkcNZ9JtyEMYx33pkpr1sRWig
         oTYQ==
X-Gm-Message-State: AOJu0Yz2i53eKdaI4lmKWjsIo1LD/qaUoi0HzzzlPZVvlDrUILlxKA8P
	MrZazY08clzB0CSBrxlycLmhAgdbA/B5CvEjLSkbs64xcHS+/UT+bqm3Ph5Ynco9KzGy3QzPOVP
	w1+9Jm43+eNJ33nFh
X-Received: by 2002:adf:e9c6:0:b0:332:ff64:ff50 with SMTP id l6-20020adfe9c6000000b00332ff64ff50mr6720277wrn.3.1701194120763;
        Tue, 28 Nov 2023 09:55:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxtIUmo/xgDPU+4SynBCZAKg3hJMQbTbqo7KrIGmu/9sGiONimAtj8MpqI83o1bVOsygmqVw==
X-Received: by 2002:adf:e9c6:0:b0:332:ff64:ff50 with SMTP id l6-20020adfe9c6000000b00332ff64ff50mr6720265wrn.3.1701194120413;
        Tue, 28 Nov 2023 09:55:20 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:1d00:99ec:9656:7475:678d? (p200300cbc7081d0099ec96567475678d.dip0.t-ipconnect.de. [2003:cb:c708:1d00:99ec:9656:7475:678d])
        by smtp.gmail.com with ESMTPSA id x1-20020adfec01000000b00332cfd83b8dsm15601843wrn.96.2023.11.28.09.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 09:55:20 -0800 (PST)
Message-ID: <1c79ad05-cb52-4820-b2aa-bbe07ff82b19@redhat.com>
Date: Tue, 28 Nov 2023 18:55:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 19/27] mm: mprotect: Introduce PAGE_FAULT_ON_ACCESS
 for mprotect(PROT_MTE)
To: Alexandru Elisei <alexandru.elisei@arm.com>, catalin.marinas@arm.com,
 will@kernel.org, oliver.upton@linux.dev, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 arnd@arndb.de, akpm@linux-foundation.org, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com,
 mhiramat@kernel.org, rppt@kernel.org, hughd@google.com
Cc: pcc@google.com, steven.price@arm.com, anshuman.khandual@arm.com,
 vincenzo.frascino@arm.com, eugenis@google.com, kcc@google.com,
 hyesoo.yu@samsung.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20231119165721.9849-1-alexandru.elisei@arm.com>
 <20231119165721.9849-20-alexandru.elisei@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231119165721.9849-20-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19.11.23 17:57, Alexandru Elisei wrote:
> To enable tagging on a memory range, userspace can use mprotect() with the
> PROT_MTE access flag. Pages already mapped in the VMA don't have the
> associated tag storage block reserved, so mark the PTEs as
> PAGE_FAULT_ON_ACCESS to trigger a fault next time they are accessed, and
> reserve the tag storage on the fault path.

That sounds alot like fake PROT_NONE. Would there be a way to unify hat 
handling and simply reuse pte_protnone()? For example, could we special 
case on VMA flags?

Like, don't do NUMA hinting in these special VMAs. Then, have something 
like:

if (pte_protnone(vmf->orig_pte))
	return handle_pte_protnone(vmf);

In there, special case on the VMA flags.

I *suspect* that handle_page_missing_tag_storage() stole (sorry :P) some 
code from the prot_none handling path. At least the recovery path and 
writability handling looks like it better be located shared in 
handle_pte_protnone() as well.

That might take some magic out of this patch.

-- 
Cheers,

David / dhildenb

