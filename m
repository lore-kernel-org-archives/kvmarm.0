Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794677751;
	b=oyuxOkrKr5fMRdd+oGZ0ictKJaQeMiTGI4KFr9IKCWHMKPlnRxAVTblh9TcTcySXwqpD
	 aSsU6wSJGpEGFf8sCFJxToUGdlgWZ21d84RWFzK0ikvKbsj6eI4wpb5sKmTOqvXXDbK4M
	 qKmt8zmHdC+keJYK9D8uQNF4WKUXc488PMjLMqWdKd8oK8HZ2PWCQkHf8/S2PJnyx8D9r
	 5NI6QKm8gY7JwklkuVPwTYYenrKBrFXLeEgUn6DGUDWLod7Kb/WkxkD3EiNPyifSMwRwu
	 vI1ay+jvoKHw9Bj7vfs+iSrs7jQo8rpLy8UU+t2Np9Mx/metEdzwjtoj5zI9x76el+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794677751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=JNaJcXdU6JL88Hplnr1u9aTEynknq2tK7kpa3hgYbA8=;
	b=xfVdMR5QDPqhBjkO65kcO4ukCr4aBuI+R0sXp+DVvUsBg/1tZnfzWKyfJmBdwKySxYGJ
	 Cm5drwU+EA10gV3dbk8FwyzMEQXhJfaoEz7fQYltPQJL1MzAVCMw77l7aqk7+cvYgoUv9
	 bRtWLgSTdkQw0IYFqvBla63Hseze9PypvkCSGm2kchd5Kzz9EXNEwuHNboVvKclvWIJ0A
	 OOVRFZ8p63b0SiFOEh3kUmzRn28MC0oQFhsEmPgIkcjPtm5ezpX2++ciw43rm22Gq9sS0
	 M3YkmlQyeMWITfu8D5WjXo+5ga/n8qdRovjYc2M/LlyUMOfB7V02991zlkPmtAg1nCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fFZZ39fn;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058C7606A338
	for <kvmarm@lists.linux.dev>; Sat, 14 Nov 2026 17:35:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 058C7606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fFZZ39fn
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c50713860c0so198186666b.0
        for <kvmarm@lists.linux.dev>; Sat, 14 Nov 2026 09:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794677748; x=1795282548; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JNaJcXdU6JL88Hplnr1u9aTEynknq2tK7kpa3hgYbA8=;
        b=fFZZ39fn2MZTv+bfIh0wc5tSOYJYUm/RsTm+/1Nc+KtA3Fk2FMxHhNgLJr89aq//V+
         BYR7fWq8NduYICbCxgl5H7sedT9H3mc7hamIq76spyf/9Pem0ZgmdccqJTMKUrGqBU5u
         zCpGacw21rZybQx2BGvTMRPm3cx2BMcqwnp0glCNuDRyH/GQeBnR8ORGdfHANSW7kNtJ
         GGvl/BvWOk3m+cJ6XI5O/rebLV2wTTD0VOmKocqecvXuocPafrtS99wx4mF778X9xm7Z
         bESO5/aHI7XC8Dloy0O6kMfrHMMNWtPBLzVbBmX74XGEea3X6nOov0xq9F7gNrh1UKxf
         ljcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794677748; x=1795282548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JNaJcXdU6JL88Hplnr1u9aTEynknq2tK7kpa3hgYbA8=;
        b=g+0AzZSTiis872PME7zHrPzFhu2K/8anYgHSZ3pGQyhcMBCR7hc9CZCSCz1Kw34dTQ
         PW9S1OF9FN5aNx65ZqflVRIx6H1y1biyzKlOycktbo1k8dO6yQWLf0fMqsV9/5iQEsTj
         o2Nv2V95dXEdGLmQt6RfzaRVJZOaAqGP5BzqhTCiaOyDTR2aLoY49V3dO3pIAjqmmUhK
         2r8/nHWha+wdoSKRjb7I7TCb+2MCdldnoASyeZ3a9Fb6tN5AZBQuAs6t/f2xj00lUuPD
         TucCMAIRxv2sNELpGYpQrG3iFhvGWyw61EPrIXi0l4DVXj/EJ/3I5qNvXb8KfsiwK3iS
         TrpQ==
X-Gm-Message-State: APuU4Z8BTgDjhu4CAvjlsuFi8WycUUXhLlpQwaipLXt4w2UaFmv6AsK3
	9qSe1FckoVC4N7NLgr6GoSYn7YGhHfuB8CXEmBruNuIweulcqSii00seWmQdMu2sulE+Kt+mKNv
	+NF5D7U6JzIHEsdM0bQ==
X-Received: from ejfz7.prod.google.com ([2002:a17:906:ac7:b0:c2e:3202:ef75])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:868f:b0:c33:ae8b:817d with SMTP id a640c23a62f3a-c509654f9admr515384166b.46.1794677747981;
 Sat, 14 Nov 2026 09:35:47 -0800 (PST)
Date: Sat, 14 Nov 2026 17:35:47 +0000
In-Reply-To: <DMRO4QXXB8H4.127C1CPT3RZ18@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-17-tarunsahu@google.com>
 <DMRO4QXXB8H4.127C1CPT3RZ18@google.com>
Message-ID: <9huzmrrbpb7w.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 16/19] PCI: liveupdate: Add feature header to struct pci_dev_ser
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
>> Precede each serialized PCI device entry in the PCI Live Update KHO block
>> set with struct kho_ser_hdr via DECLARE_KHO_SER so future per-device PCI
>> Live Update features can append fields to struct pci_dev_ser without
>> breaking compatibility between adjacent kernels.
>
> Elements of a collection should not have their own feature headers. This
> applies to patches 10, 12, 14, 16 and 18. I raised this during the v2
> discussion [1][2], but I don't think it was addressed.
>

As per [3], I tried to add feature header to all possible instances of
ser structs. Maybe this is the right time to audit these structs and decide
which one will never need feature header.

[3]: https://lore.kernel.org/kexec/CA+CK2bB9xoAWP0kC+KtXeDTdwt0kWqb-PLHN=6DsA=mnRpMfxA@mail.gmail.com/

> All entries in a KHO block set are written by the same kernel using the
> same struct, and the block set has a single entry_size, so every entry
> header is necessarily identical. They don't convey anything that the
> header of the struct that owns the collection can't. In this case,
> struct pci_ser's header can define features that describe fields in
> struct pci_dev_ser, and the PCI core checks them once before iterating.
> If a feature only applies to some devices, the field's value in each
> entry says whether that device uses it.
>

pci_dev_ser can be refrained from using kho_ser_hdr but not
memfd_luo_folio_ser.

The difference lies in their API usage. one use kho block and other one
kho_vmalloc. With kho block, we carry entry_size, so the parent
pci_ser's kho_ser_hdr can communicate about the new field/feature in the
pci_dev_ser and entry_size will carry correct the size of pci_dev_ser
for iterator on deserialization. But for memfd_luo_ser, kho_vmalloc does
not carry such entry_size. So we can solve this by adding the
folio_ser_size into memfd_luo_ser struct.

Without entry_size, we can only add new changes to such structs by
adding feature in parent struct with required = 1. That way rollback or
upgrade will fail to the kernel which does not support this required
feature. Incase, if we have entry_size (folio_ser_size in above
example), it will help marking such feature to be optional also and
deserialization can correctly parse with entry_size and can ignore those
changes if the kernel wants to.


> Per-entry headers also cost a lot for small entries. struct pci_dev_ser
> goes from 8 to 16 bytes, and to 24 bytes once the first feature is
> added. Patch 18 does the same for every preserved memfd folio, which for
> a large guest backed by 4K pages adds gigabytes of preserved metadata.
>

Yeah, we are carrying 8/16 byte of extra memory where every entry share
the same header. Which is a waste.

> They also add new ways to read out of bounds. kho_ser_payload() trusts
> nr_required/nr_optional in each entry, and nothing checks that the entry
> header plus payload fit within entry_size. In patches 14 and 18 the walk
> uses each entry's fhdr->size to find the next entry, so one bad header
> throws off every entry after it.

Bad feature header is not the reasoning here we should back this
requirement. A bad feature header already imply the deserialization is
compromised and hence accessing anything further is undefined. This
holds true for any struct with feature header.

>
> Instead I would keep struct pci_dev_ser as a plain struct, take the
> entry size from the KHO block header (patch 2), and in pci_flb_retrieve()
> check once that the entry size covers the base fields, plus the fields
> of any features set in struct pci_ser's header, e.g.:
>
> 	entry_size = kho_block_set_entry_size(&incoming->block_set);
> 	if (entry_size < offsetofend(struct pci_dev_ser, refcount))
> 		panic(...);
>
> That also restores the minimum entry size check that the v10 PCI series
> had with PCI_DEV_SER_MIN_SIZE, which this version drops.

offsetofend() is a good idea to replace PCI_DEV_SER_MIN_SIZE.

>
> [...]
>
>> -	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
>> +	kho_block_set_init(&incoming->block_set, kho_ser_size(pci_dev_ser));
>
> This size is never used. kho_block_set_restore() overwrites it with the
> entry size recorded by the previous kernel. Passing this kernel's size
> here is misleading: pci_flb_retrieve() (and the LUO session/file restore
> paths) read as if they iterate incoming entries with the outgoing entry
> size, which would be a bug.
>
> Incoming block sets should not take an entry size at all.
> kho_block_set_restore() should initialize the block set itself from the
> incoming block headers, and the incoming paths should drop the
> kho_block_set_init() call.

Yes, We can avoid this dual initialization. kho_block_set_restore can
take care of it. Also once we will agree on having having
kho_block_set_ser to have entry_size which will be part of only
block[0], then we will not have to update the entry_size inside the loop
again and again and count_per_block can also be calculated before the
loop for block 0 and 1..N.

~Tarun
>
> [1] https://lore.kernel.org/kexec/atl6K2Juy6Bh29lh@google.com/
> [2] https://lore.kernel.org/kexec/at-8vkVpN2SF3XgB@google.com/
