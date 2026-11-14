Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794648885;
	b=HFB1mMK2Bh1Zw6+jNkNF3OlZ0UhZ3uRSDhKBU3Td9wl0FnvZMkkjly6EKcrpqyha6nbP
	 HoFgqqAlUlwGdKpAT/IwwO/mmGcdcFZ63eJs2EN0ykZLzFP0jFfva++a4DUMVeaJFOqZR
	 EPV9NDVIv2w65Y57ROlrniCBMetaNk9KhaDtXZpIN3aweC2F+uyh27+kF99Zqym8h+s5y
	 HCkHKd11vO4GoQLhDW9IEPQMcVEUjNiIZRHWz94i/uRlg4VZ5XzgRgwdXT+AJEQCHVWa6
	 M1XpXv1Hw2GMAYyDvZmLMB43517I0kX9mIwmKBD2qPmYnRfXbC/a1K0H1ke3rM4/gBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794648885;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=cYfB8ZYjzkbZTu8PkWr5VdyVYonCx+ZsO65KHqfQojE=;
	b=sPvFU6FlIgC2UA93CxrtugwM+ah6/p1Twt8dhvxnXPLoxN2RhLgJZufeThTfPlD5K/px
	 CqKZNcdPRer3eXZN3eRkzhUSpfzfyUaq26Xw4Hj+CfmurTWvrUST8qratpiDJT6r5j9jR
	 RctZtZDWoGJlfxTl5d+kKqI1T34vAiSBKquxpWCXC3lw08EHegTPwV38KpxiANX4HxYfe
	 VMCCAsGshZudVchfTGXZwIoNTLmlXKs/TPYklCMseQH89xo0EV1CP+y4Cg8wkQq24yj84
	 NICmpj0u4btsdDcSzvlgbld/OMxpDMqXhSYBvJXWo3e0tfFKbFAneQ8tTSnWpuN9bug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZZ0Bdc7a;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4D4606A336
	for <kvmarm@lists.linux.dev>; Sat, 14 Nov 2026 09:34:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D4D4606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZZ0Bdc7a
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4d34d6082fso170335166b.0
        for <kvmarm@lists.linux.dev>; Sat, 14 Nov 2026 01:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794648884; x=1795253684; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYfB8ZYjzkbZTu8PkWr5VdyVYonCx+ZsO65KHqfQojE=;
        b=ZZ0Bdc7aNfX61/F0ANr5xkvk9K62pFsAenBTG8ZxCOmDIF6nKad0BHMIpSijUz9oLl
         l/0D6Qw/tBkhh4ZlCaqOVrbG1X8YXvdBz6i8qICymbqYgJg/nyoD7ZkzBqQn+KrgB1yr
         Ear77WzRrekOPxSlhJlnRz7LzWs6Hcupa4jP1GdBRsE1yf0ovgGCB4sl4ra7CDg4Nyu9
         TD1J1Ugr7LowtxTYYjX4SDL1Yo37RBuSpZGWCFcAPxVvEQIAduZ/2ez2+Y0vXWkIHKhu
         +ELr11L1AMQvsYyHswyqxrg3oP/eULC1TQVfGwV95VVEGc9k/sXDkaOcqdvHgYVBxG7k
         ktUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794648884; x=1795253684;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYfB8ZYjzkbZTu8PkWr5VdyVYonCx+ZsO65KHqfQojE=;
        b=qUZMTBUn8HSGU8FCf3g15CCi95u9EUKgShrkrzumBaSB2pAd60fYsiYZ8/mrw6Iyh4
         UKjW9LGwX43Esk19fFhCP02SRgQGQ8Z9+dNV/PlfRKIhfB8xojNt8Jow9/tKfumGCOn9
         BKQ4Og0YjXMArRTvTzwUz2RmLi0LXKh0YS7fMivrgQEyGa9E2kD9wFxgPqxP2c0AJXS/
         JI8M3rS0vKqCzow8gF+ndVShYwRA+fm6NbApqjUbU5qTA3/nhVkD3AmpZQNPwEd5IFMw
         MscyUtvjxa+gYX/DOBbjUQuzg55uAVUnHsUgwQh8yRDvvA3HGvp3ac+MTvaCYNwYQHyo
         KXOA==
X-Gm-Message-State: APuU4Z/WIvpWKBYrGjvA0OCpndLxuF41XVx21VDz/nBKVaaiCMmS8e1o
	EJWP99KlzaU7qSMqCn/1i0ORJzsDw4yMvUf8GVtWb+uyfBnWdOTOaCF26sauqA7lGwieYId1wxD
	quVOR1pvoNbSffRmt+w==
X-Received: from ejbgl17.prod.google.com ([2002:a17:906:e0d1:b0:c50:537a:6835])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7b83:b0:c41:b4e4:7958 with SMTP id a640c23a62f3a-c5095dd7931mr418395066b.0.1794648883281;
 Sat, 14 Nov 2026 01:34:43 -0800 (PST)
Date: Sat, 14 Nov 2026 09:34:41 +0000
In-Reply-To: <DMRP21FATCC0.ARAURXWV85JP@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-9-tarunsahu@google.com>
 <DMRP21FATCC0.ARAURXWV85JP@google.com>
Message-ID: <9huzse13pxhq.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 08/19] kho: block: Add the feature header to blocks
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, 
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

"David Matlack" <dmatlack@google.com> writes:

> On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
>> Precede struct kho_block_header_ser with struct kho_ser_hdr using
>> DECLARE_KHO_SER. Each block in a block set starts with struct
>> kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
>> start immediately after the header payload at offset fhdr->size.
>
> This adds a feature header to every block in the set, but the layout it
> describes is a property of the whole set: all blocks are written by the
> same kernel with the same header.
>
> Blocks are only ever added and removed at the tail, so the head block
> is stable for the lifetime of the set. I'd put a single set-wide
> header in the first block only, e.g. a struct kho_block_set_ser with
> its own feature header, and keep the per-block header to next and
> count.
>
> entry_size (added in patch 2) is another set-wide property that belongs
> there. All blocks in a set have the same entry size, so recording it in
> every block is redundant, and restore has to check that the copies
> agree.
>

Yes, adding a ser_hdr to each block_header is unnecessary and also cause
8 bytes to get added to every block. This can be solved like you said by
adding it only to the first block. But this will make number of entries
in block[0] to be less than blocks 1..N. I am not sure if that is
acceptable but if it can be then we can avoid adding ser_hdr to each
block. Same for entry_size which can be moved to the first block only
like you suggested part of struct kho_block_set_ser.

> [...]
>
>>  		entry_size = ser->entry_size;
>>  		bs->entry_size = entry_size;
>> -		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
>> +		capacity = (KHO_BLOCK_SIZE - fhdr->size) / bs->entry_size;
>>  		bs->count_per_block = capacity;
>
> Nothing checks that the blocks agree. Each block's entries start at its
> own fhdr->size, and count_per_block ends up being whatever the last
> block implies. With a single set-wide header this can't happen.

yes.

~Tarun
