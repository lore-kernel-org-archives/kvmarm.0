Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794724654;
	b=KT92Ylo2FwxR8DDcGNFQ2cwwR6KMy9B15y8DGDGMGa14rahfY8wcuBIQubY0lxcSQeqn
	 Cg2OzbqGZPG1vSEiTX8C7R6dGhS/tDlc03Fs6l+u1o5HoE2QWiV7H8lN2LqgiOQQxhFIP
	 iV8FfJeBpsrHjTbq+74ZjXB48Qw6PTtuRbHzMMXbW6ko9OA0GxEfApD7/Xd4P9doL1iF7
	 3lpIJypn/77DqVmBvgFsMZwqRIGz5qkSB7/FCWeHzw1yr3Jm/Kwg/7Xr/IeY2UjeKGOlh
	 MmOUNxhAEZiDsCQ195phmoUulYta1bdChX6HIMQpnbH9h79mRPz5TA8tB+UxV1rQEvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794724654;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=aE92BuA/q+u7mWs8kchTDkcjs1m/i8lsv1ezZ7OruqU=;
	b=pCSyb9NZuu5PkkWRKV8aoxhDPvcilxq4h15SvgibqsMwgSX5/kYOTlbGjeGQBA8CJac5
	 mj8WsUKKFys50WcoBcTiYJxXzspksbkPv/O4o3RVBRHXcXdGkkewxQv0IVg8dUH4DOFoY
	 FCVe3sID9CKGRFd7m/SnhZclSXFDGGr1vsZkk8qPcJDPbBxru7TbVGWgt3DITRqLINzxW
	 OvCY+HaE0m/gEXI3+v5EYURMJEaEubugyAI+tJoP8G9xxxT7lslKEDpG0CnGSaBiGP45b
	 CLt81DVPRuMX2nq4FaDKYfHUd6Mq/LOyEXJhcBC9Jli2mByAvamlMZmIaOPtguDOgLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="lfic/lB3";
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13285606A327
	for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 06:37:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13285606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lfic/lB3
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c505eecba6cso103602566b.1
        for <kvmarm@lists.linux.dev>; Sat, 14 Nov 2026 22:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794724652; x=1795329452; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aE92BuA/q+u7mWs8kchTDkcjs1m/i8lsv1ezZ7OruqU=;
        b=lfic/lB32zga7USVCjmudfQwrO/kW9r41/zrmbRUMIvViMsr6q8bwchfXWZC4lDO0v
         +TwVWPFxZ9HdVjkLdQQvQqlWSJhFYM8PuNC4M0tTimvqosuEzEi15vfx6HkY7VUHGyr0
         Und6fsWrdW1W30H1uicsjXh2PBNw9xnPU7b0UbHv1miRizjX+BQ+IywKc3FVHnuo8NMK
         oaJBqibJJy2PuJUElgTteoCwKgfiFie4E3Zy9twe9jjlBzrnsqrOjXnkCHlONZfamqFC
         sjKUZq3DOQkFv/xnjMYIR0wP1At3FpT8LXSRK3vkAcFxFAj6VEhZG587SbKz2vcPL5qi
         jzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794724652; x=1795329452;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aE92BuA/q+u7mWs8kchTDkcjs1m/i8lsv1ezZ7OruqU=;
        b=NtigEfGPzAs00jy6UUE0+MP3wzY97YgNFAJuAGe/cgBoEmtnVlrbJD5+01acSHFnRz
         8WbcWuLhW5zxA41kFoLxNPcfXmsW52pO34/u43Aw7LRvihbbq9vnvDp+eHU2QKq36AEu
         acgiDO6Q3iAZu+9iZz4eBIRgDuuahrGw/9DQIlDnnqBN/ToDrQmIqDMCgeniDMO1H1T6
         F4wilmISrQX6FXp5KpCTZxW5OTGQaNILKc8wd751gHs6h0KyEBVHhTBBjjQSq/IAs3af
         WmlTqkIGilQZDT9x2BpCEfE1rCu24TaqbTlSqV/dcMoLlJ+IVmUi95tG7VGs7QpVx8pw
         YS9A==
X-Gm-Message-State: APuU4Z8nDDEJNzA7rVEslv1tcSb+JK61o4nBcxlDveTsAR8CjkGOHmgR
	Q7zxZl1j/KDCxYMpMYdi5cjTzoIC8YCyGjFjEU45Wsnu+J/sCCLW3Y0LkO537K4xPuiVVvpoXGK
	ZlSHwxuXTkbHg3kvhbg==
X-Received: from ejbge24.prod.google.com ([2002:a17:907:9098:b0:c46:7bd3:aa06])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a714:b0:c42:5363:38dc with SMTP id a640c23a62f3a-c509637e20cmr533164966b.25.1794724652053;
 Sat, 14 Nov 2026 22:37:32 -0800 (PST)
Date: Sun, 15 Nov 2026 06:37:31 +0000
In-Reply-To: <DMROZB8DPEWD.W2BFC7JIBVZP@google.com>
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
 <DMROZB8DPEWD.W2BFC7JIBVZP@google.com>
Message-ID: <9huzjymepplg.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block header
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
>> Add an entry_size field to struct kho_block_header_ser. On the outgoing
>> side, record bs->entry_size into every block header during allocation.
>> During restoration, derive the entry stride directly from the block
>> header instead of relying on caller-supplied dimensions. The
>> kho_block_set_init() interface remains unchanged. A zero entry size,
>
> Since the entry size now comes from the block headers, incoming block
> sets should not take an entry size at all. I pointed this out on the
> PCI patch (16/19) as well. As is, every incoming path still calls
> kho_block_set_init() with this kernel's (outgoing) entry size, which
> kho_block_set_restore() then silently overwrites. That makes the
> callers (e.g. pci_flb_retrieve() and the LUO session/file restore
> paths) read as if they iterate incoming entries with the outgoing entry
> size. kho_block_set_restore() should initialize the block set itself
> from the incoming block headers, and the incoming paths should drop the
> kho_block_set_init() call.
>
I agree, responded to the PCI 16/19 patch.

> Please also add an accessor for the entry size, e.g.
> kho_block_set_entry_size(). Users of the block set need it to check that
> incoming entries are large enough for the fields they read, and that
> the fields of a feature are within the entry.

Sure, Will update it.

> [...]
>
>> + * Each block header also records the size of its entries. A newer kernel may
>> + * append fields to an entry, so the kernel that writes a block and the kernel
>> + * that reads it can use different entry sizes. The reader steps through the
>> + * entries with the recorded size, so every entry is found, and it does not read
>> + * beyond the recorded size of an entry.
>
> KHO blocks can't guarantee the last part. The iterator returns a void *
> that the caller casts to its own struct, so it is up to the caller to
> not read fields beyond the entry size. Please document that callers must
> check the entry size before accessing fields that may not be present.

Yes, I meant the same thing. by having a check on entry_size reader must
prevent itself to read beyong the provded entry_size. I update the
correct the documentation.

Also, I realize tha, after checking the base fields using offsetofend,
for any following new feature fields, a entry_size should also be
compared against the readers offsetofend till this feature field for
required fields. Incase reader does not have that field and
kho_ser_validate passes, that means that field certainly is optional.

I can add this also part of the documentation.

~Tarun
