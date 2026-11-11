Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794375963;
	b=cYEpgXLIej/q4IYKKJsZx2wU9Zh2bPDSEa+Mkp4NzErAt99WJon3vUS7hAdh9fUE0Jnv
	 nBEvZWQvQFx9EJHRGEo5IH2w/wruyWIv6ox7B4fSL9R4w2tzHZGcfhoN7UAkyDUZ4KK2Z
	 iNFgjS6RX5xge26fSfyEWBsMNw9EuOg45fD8MsJYXz+6GWUkHd6tquBYINljOrBegQ/gr
	 RgOmIABlPiS6DCAk1gSlA3kPZcUDqsF0nV0Fy/vQQ1TeA5bBPv3fq/LbrU73OrYdR9iB9
	 oHamweUDcRInFEklrI6fHbL36egzFO0YNSNgXikekKqxcErji6H69+sYxtFkbRJ02XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794375963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=lhosHtg8wPbXMxrTNQaWwGDOdBWHTWddIh+Zj1SEb0g=;
	b=OsoaGEKMSeDicqVt91Kk+zHa8yH1umcOtT10zqGT+NriLangG/oF8u9GZj8+Fg71O8YY
	 +s/ym6EZ+4nWYlHfsbXGalisl5p5qsrEqsc9JnIWWRLswEkJ1+pCOfIZmzJFumHqh+tJa
	 l1CRtx9Z9a4gPSfPPmsBsUc2FkbWjBYI1qLhY9YwVE7b2Kco68CI71crVwqZuDlnGB5DQ
	 Uq+gtew3RaLkC38fdEz4PSN9LF103MDFGw7wCWGjdG11OP4jqQ5CVrGuHvOFfKq15qJrI
	 ePzAsNWOzYZ04YzMAdOW6VU+YvLYHp/uSHJRT6zvJjp8AghnWeB2x3b+oP6vizaGiAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eHPqZqMC;
	arc=none smtp.remote-ip=209.85.208.71
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9F4606A321
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 05:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E9F4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eHPqZqMC
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b706aec674so2857663a12.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 21:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794375961; x=1794980761; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lhosHtg8wPbXMxrTNQaWwGDOdBWHTWddIh+Zj1SEb0g=;
        b=eHPqZqMCdMhXF/RnBSMaUTG6pO33NwTSPB2lulY8vocoKXbJHIsUKh6WnbQ92Bwhyc
         nSJhKz1/6n154nRawQcBAJCD1I8avXpqWMQyo7vLgnOXRBIa/n+iyOjIzRR344GnbZ04
         cP1owHSiRYb0rq48IwAnfzxCDqfzSK3pQkTJQl0XEtZaJQD48m6r2RL4qJKgKU5GEA5l
         9n0KBhtbwqWVvr8vuJ87y+pxPrh/b936GzGcwq8wNkwZWGBsYJjyDbwsMMsfOCBwnOH4
         z0k4YCU2C98UBQzifOHXmnd0InIMBN9LFMBJuHeiwXKv1jHqnlvjSRB1DRxgDCV3RDaw
         MOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794375961; x=1794980761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lhosHtg8wPbXMxrTNQaWwGDOdBWHTWddIh+Zj1SEb0g=;
        b=uUGNXRuKBVsZP8tsO0++6gbthIe5Oq+sM31fey4UWOvKZLHTnrL+nDjbJowkNNkZXj
         /7+DjLaLpbzrllLzzZ08UztT8kEycKt8Cf0pAMqB/tPcSRQX5d0tFpQT5e+JvjhPZm56
         Pi3A6bcmxU9n05yxMWAAdgVkvggmw0JrzSmGkKtS0kgBCCsQOxD9HPPMUDXx+4kDoMZs
         S1oSqKRwqaCqst+Lybswao5mz329GzMRFeWkk4yzhfgzhmWAQbsWz99MMon3betRNksm
         DNjpoiySrqVz3la8wDS7B9TP03xOAnlC3PMl0Sd9U3qyZnZ4U+WLE7i4ycPKHS1qflQo
         o7Eg==
X-Gm-Message-State: APuU4Z8nHiWFiAfZTAnM1yqS9fWd2P8mCaC/Hk5jVQ6QrsbVIjVtqFgK
	lxSb6j64t/Ij6Ed3cM46HDXuw5gTEyJUk7ZzZWMObk08ugXbhO95sYXgF+C3BALUqwX4ZQ+826f
	SxdtuUD1D8/poK+gGGA==
X-Received: from eduw9.prod.google.com ([2002:aa7:dcc9:0:b0:6aa:448f:b887])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:b18:b0:6b1:c1e5:a85b with SMTP id 4fb4d7f45d1cf-6b777342a32mr753053a12.3.1794375960798;
 Tue, 10 Nov 2026 21:46:00 -0800 (PST)
Date: Wed, 11 Nov 2026 05:45:59 +0000
In-Reply-To: <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-3-tarunsahu@google.com>
 <DMRK0PU0VCN3.15F59WLOQ05P4@soleen.com>
Message-ID: <9huz1p8rrkdk.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block header
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

"Pasha Tatashin" <pasha.tatashin@soleen.com> writes:

> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
>> Subsystems using the KHO Serialization Blocks framework currently do
>> not record the serialized entry size in the block header. The entry size
>> is only known to individual callers, which must track and store it in an
>> owning serialized data structure. If a newer source kernel adds fields
>> to an entry, the changed entry size breaks the stride when an older
>> target kernel iterates over blocks.
>>
>> Add an entry_size field to struct kho_block_header_ser. On the outgoing
>> side, record bs->entry_size into every block header during allocation.
>> During restoration, derive the entry stride directly from the block
>> header instead of relying on caller-supplied dimensions. The
>> kho_block_set_init() interface remains unchanged. A zero entry size,
>> or one that differs between blocks of a set, is rejected during
>> restoration.
>>
>> This change modifies the serialized layout of struct kho_block_header_ser
>> and shifts the offset of serialized entries within preserved blocks.
>> Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
>> kernels cleanly reject mismatched handover state during boot. Also
>> update the stale compatible string example in the documentation.
>>
>> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  include/linux/kho/abi/block.h          | 10 ++++----
>>  include/linux/kho/abi/kexec_handover.h |  6 ++---
>>  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
>>  3 files changed, 38 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
>> index 36bdbaf9b3b8..a40b0906c821 100644
>> --- a/include/linux/kho/abi/block.h
>> +++ b/include/linux/kho/abi/block.h
>> @@ -40,9 +40,10 @@
>>  
>>  /**
>>   * struct kho_block_header_ser - Header for the serialized data block.
>> - * @next:  Physical address of the next struct kho_block_header_ser.
>> - * @count: The number of entries that immediately follow this header in the
>> - *         memory block.
>> + * @next:       Physical address of the next struct kho_block_header_ser.
>> + * @count:      The number of entries that immediately follow this header in the
>> + *              memory block.
>> + * @entry_size: The size in bytes of each serialized entry in the block.
>>   *
>>   * This structure is located at the beginning of a block of physical memory
>>   * preserved across a kexec. It provides the necessary metadata to interpret
>> @@ -51,9 +52,10 @@
>>  struct kho_block_header_ser {
>>  	u64 next;
>>  	u64 count;
>> +	u64 entry_size;
>>  };
>>  
>> -static_assert(sizeof(struct kho_block_header_ser) == 16);
>> +static_assert(sizeof(struct kho_block_header_ser) == 24);
>>  static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>>  	      __alignof__(struct kho_block_header_ser) == 8);
>
> The above change goes away once my comment on the previous patch 
> is addressed.

Ack.

>
>>  
>> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
>> index 2f4fb9c63942..6f12f5037ea5 100644
>> --- a/include/linux/kho/abi/kexec_handover.h
>> +++ b/include/linux/kho/abi/kexec_handover.h
>> @@ -41,7 +41,7 @@
>>   *   restore the preserved data.::
>>   *
>>   *     / {
>> - *         compatible = "kho-v3";
>> + *         compatible = "kho-v5";
>>   *
>>   *         preserved-memory-map = <0x...>;
>>   *
>> @@ -62,7 +62,7 @@
>>   *     };
>>   *
>>   *   Root KHO Node (/):
>> - *     - compatible: "kho-v3"
>> + *     - compatible: "kho-v5"
>
> These are just examples, don't update them.
>
Got it.

>>   *
>>   *       Identifies the overall KHO ABI version.
>>   *
>> @@ -90,7 +90,7 @@
>>   */
>>  
>>  /* The compatible string for the KHO FDT root node. */
>> -#define KHO_FDT_COMPATIBLE "kho-v4"
>> +#define KHO_FDT_COMPATIBLE "kho-v5"
>>  
>>  /* The FDT property for the preserved memory map. */
>>  #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
>> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
>> index 0d2a342ef422..9b148009085e 100644
>> --- a/kernel/liveupdate/kho_block.c
>> +++ b/kernel/liveupdate/kho_block.c
>> @@ -16,6 +16,12 @@
>>   * array of serialized entries. Multiple blocks are linked together via a
>>   * physical pointer in the header, forming a linked list that can be easily
>>   * traversed in both the current and the next kernel.
>> + *
>> + * Each block header also records the size of its entries. A newer kernel may
>
> "newer kernel" does not make sense in the documentation comment, as any 
> kernel can do that. I would suggest "outgoing kernel." By the way, in 
> this series you use the terms "source" and "destination" kernel, whereas 
> traditionally we have used "outgoing" and "incoming." While both 
> conventions work, it would be preferable to maintain consistency.
>

I used source and target, based one of the discussion we had in
hypervisor liveupdate meeting. But, for consistency, I agree, I will
change it to outgoing and incoming.

~Tarun

>> + * append fields to an entry, so the kernel that writes a block and the kernel
>> + * that reads it can use different entry sizes. The reader steps through the
>> + * entries with the recorded size, so every entry is found, and it does not read
>> + * beyond the recorded size of an entry.
>>   */
>>  
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> @@ -110,6 +116,8 @@ static int kho_block_set_grow_one(struct kho_block_set *bs)
>>  	if (IS_ERR(ser))
>>  		return PTR_ERR(ser);
>>  
>> +	ser->entry_size = bs->entry_size;
>> +
>>  	err = kho_block_add(bs, ser);
>>  	if (err) {
>>  		kho_block_free_ser(bs, ser);
>> @@ -242,7 +250,8 @@ static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
>>   *
>>   * Restores a serialized block set from a given physical address. The caller is
>>   * responsible for ensuring that the block set @bs has been allocated and
>> - * initialized prior to calling this function.
>> + * initialized prior to calling this function. The entry size and the number
>> + * of entries per block are taken from the restored block headers.
>>   *
>>   * Return: 0 on success, or a negative errno on failure.
>>   */
>> @@ -250,6 +259,7 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
>>  {
>>  	struct kho_block_header_ser *ser;
>>  	u64 next_pa = head_pa;
>> +	u64 entry_size = 0;
>>  	int err;
>>  
>>  	/* Restored block sets use size from the previous kernel */
>> @@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
>>  	}
>>  
>>  	while (next_pa) {
>> +		u64 capacity;
>> +
>>  		ser = phys_to_virt(next_pa);
>> -		if (!ser->count || ser->count > bs->count_per_block) {
>> +		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
>> +			pr_warn("Block contains invalid entry size: %llu\n",
>> +				ser->entry_size);
>> +			err = -EINVAL;
>> +			goto err_destroy;
>> +		}
>> +		entry_size = ser->entry_size;
>> +		bs->entry_size = entry_size;
>> +		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
>> +		bs->count_per_block = capacity;
>> +
>> +		if (!ser->count || ser->count > capacity) {
>>  			pr_warn("Block contains invalid entry count: %llu\n",
>>  				ser->count);
>>  			err = -EINVAL;
>> @@ -370,7 +393,10 @@ void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
>>   * @it: The block iterator.
>>   *
>>   * Iterates through previously written entries during state deserialization,
>> - * respecting the actual count stored in each block's header.
>> + * respecting the actual count stored in each block's header. Entries are
>> + * spaced by the entry size recorded by the kernel that wrote them, which can
>> + * be smaller or larger than the caller's structure. Fields beyond that size
>> + * are not present in the entry.
>>   *
>>   * Return: A pointer to the next serialized entry, or NULL if all serialized
>>   * entries have been read.
>
>
>
>
>
> -- 
> Pasha
