Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286928;
	b=fK9lfr3KIqKmMUTVQmu+zJjzqPgIzULZOgbI0Z+PDTsUwwEiJOvMlLZuEumj/ci2+kXR
	 oIeIpwTcdlfrhye5S/tfH6WvPDubE6tU9Kq387LCeBYrQwgm5bbl8cV975DwhBU4Hzq8J
	 c6yajNR2hpeLaHztsi9GHUVxQb49CjaAio+Q5619Qr/HBCTEDtFmFUMDfo+E+Hva52dcg
	 sYvrcmez7iC3mdtwDgShaiSuOGeSyevOWPXd/ahJy81WDIvX1qCYsqAZIav44tncEYim0
	 uA81D/89G0AzouiTK8ZTWsGNdfuw+L+xwKmz9nU1Mf3qbnkIfzy3s3lkfsc8Nu8WgBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=c0rc/quhwxN60DpjROoJEjycH9qA4Mz3L7opctQFNIY=;
	b=MooRgIpkW0FVBv/GeuR9Bij8U+bhyF4aiWZW/dRYdkzb9uByKyahBz0cMZ0d0bHRztXc
	 uXWiIQWyTTX49zzfQJidU96atgebL5zyEG19K+28hh4en+eiQj/PCYy0BKutZTcik2G0w
	 lv6+4rOkoFQSKANrHNRrlhV7cQwgKFXJBE3Aw/vKCjuTVKKE2L/gbYO/Y9jjfAKHg2a/t
	 7/cCYiGQkiZmV0BRG7wj/Oq7DJTYKska8s3gepNszYEB+Sq69p3XBbZ3uInfGnrZA856R
	 OtuDZ5w6Hw2y2MmRN+TRA+VBgcz0JBzHVtpklWPtuWpwTQWDKwapQgrBw8cIc+IfhgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i1JhkL6N;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E477606A31C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 05:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E477606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i1JhkL6N
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c4048584447so134541466b.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 21:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286926; x=1794891726; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c0rc/quhwxN60DpjROoJEjycH9qA4Mz3L7opctQFNIY=;
        b=i1JhkL6N0sGZy1OzqrAJ6/d9TFZC4fZKPh3qx7neDlMDSQep0sLYUR0u/nMYXPHnVf
         r9h6dKGkd/2VkflKrsfV23IyEUqsbhNAK0hZhUz6e97phb9dK1t4+orrpqx0f2Sy/EVK
         p9r9BR+IaiYN/SPi9XPXfemCt3ADQBuST0VeR1YKHYTot4ri82ht3tl4uUj6gdaPJr3W
         79AvgCcxuxrKqNjgnUhL/yxFnzYnZG2MEIfKHZbVU9r3XXu0MjyyRlI/WdHEhLyF854Q
         JBQ12XNxSuAqpxxIY19ukAIe5ifXshlr2THtNQQS0ktLD/2LTAnSUFVgo2th1EaIPm/C
         we9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286926; x=1794891726;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c0rc/quhwxN60DpjROoJEjycH9qA4Mz3L7opctQFNIY=;
        b=0hNkWGNgr6fMY1S98T+M29jUJkIYn1IAhWEjuLpL4XcEXPMmr5KWPrBMumBuD235MY
         fj9p4nJPw3xCEhvTVBYCaTtKxDcQuRQuX4Ri2AVu7lv7fBnPQb8ml6cTfX7HkLK0opSf
         GtWfI1a9Z09/tF9gBn2vsBoscBSppaoeaZPgWYnuED/Dk+P2pixeWbj+9LvO+g4bYFMo
         sYnppfzQXQS6phTEOI9LC1mRF1JcPvugV7QctG74SrHvU8Q0hQF4VYmdnzr42PvwSDoI
         lNcpnDtOxoqcS2mmO8JrG5puh44R+LDuWPWSeqBD0omVOJpkckU4FxbfvIkkpnJfHCR9
         +ZeQ==
X-Gm-Message-State: APuU4Z/nrMVQIeaBWAhj35QEKViB1E7+/yTjfnSwzrCjYBpOOp720wiK
	caT3Gkyvtlt4I/OXY5fopJ8gOtoO5gr+8U2f7C3D/EgBtddRbLd4OYxrlJmCiqRde3tvM1jLWER
	XRQGifjJfVLolc5OpYA==
X-Received: from ejai3.prod.google.com ([2002:a17:906:1143:b0:c3f:6b4b:bcf8])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f58d:b0:c41:7e99:c6c2 with SMTP id a640c23a62f3a-c5049656cbamr129203766b.44.1794286925434;
 Mon, 09 Nov 2026 21:02:05 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:43 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-1-tarunsahu@google.com>
Subject: [PATCH v4 00/19] kho, liveupdate: Add feature header for fine-grained
 ABI compatibility
From: Tarun Sahu <tarunsahu@google.com>
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
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

This v4 of feature flags support for LUO and KHO is no longer an RFC.
This has gone through multiple design changes over the past few months,
and I thank everyone for providing their suggestions and reviewing it
promptly. Below I talk briefly about the evolution of this series to set
context and try to make it easy for everyone to review.

Initially, Logan proposed the feature flags in RFC v1 [1], which tried
to solve the problem of dependency on the compatible string. Feature
flags introduced finer-grained compatibility. This series had three
fields: active, supported, and required. The number of flags was limited
and didn't have flexibility, which reduced the complexity of the patch,
but put a limitation on the extensibility of the features.

After LPC and a few design discussions, I proposed RFC v2 [2], which
changed the flags to optional and required and converted the encoding to
2 bits per feature instead of having two separate variables. But This still
has the number of flags limited and fixed the feature header size to
128 bytes. Though each serialized structure is being allocated in
multiples of PAGE_SIZE (folio order = 0, 1, 2...), where 128 bytes is
not a problem, it still carries two fundamental issues: limited feature
flags, and a fixed 128-byte memory overhead for each preserved file. In
the future, as there are plans for moving to KHO slab, the allocation
for serialized structures can be significantly reduced and this 128-byte
size will be a problem again.

Based on the RFC v2 discussion, this v4 (v3 [3] was intentionally ignored)
moves to extensible feature flags with a variable-length flags[] array,
avoiding the fixed 128-byte overhead and feature-count limit.

Along with this, as discussed on RFC v2, v4 uses separate bit ranges for
required and optional flags (1 bit per feature). It builds on the
consideration that a feature in its lifetime will either be required or
optional; it can't be toggled into the other. In the future, if such a
need arises, a new feature flag can be introduced to replicate the
feature as optional or required, opposite to its ancestor flag.

This new layout and encoding in memory is as follows:

struct kho_ser_hdr {
	u32 size;
	u16 nr_required;
	u16 nr_optional;
	u64 flags[];
}

where,
	flags[i] = (BIT_MAP(optional_features) << nr_required) |
		   BIT_MAP(required_features)

This series introduces the feature header in the KHO subsystem, and it
is used by serialized structures across KHO and LUO. A few of the
serialized structures embed other serialized structures directly. To
keep the relative offsets of fields to be same across kernels, we cannot
have an embedded serialized structure's size changed; otherwise, direct
casting will not be possible. To solve this, this series converts those
embedded structures to KHOSER_PTR, which points to the memory just after
the parent serialized structure, and allocation and preservation happen
for the total memory (parent_ser_size + embedded_ser_size).

<Iamparent>_ser {
	u64 a;
	u64 b;
	struct <Iamembedded>_ser e_ser;
	u64 d;
}
	CONVERTS TO ===>

<Iamparent>_ser {
	u64 a;
	u64 b;
	DECLARE_KHOSER_PTR(e_ser, <Iamembedded>_ser);
	u64 d;
}

There are only two such instances: kho_vmalloc and luo_file_set_ser.

This series introduces kho_ser_hdr for the following structures:

  - struct kho_kexec_metadata
  - struct kho_vmalloc
  - struct kho_block_header_ser
  - struct luo_ser
  - struct luo_session_ser
  - struct luo_file_set_ser
  - struct luo_file_ser
  - struct luo_flb_header_ser
  - struct luo_flb_ser
  - struct pci_ser
  - struct pci_dev_ser
  - struct memfd_luo_ser
  - struct memfd_luo_folio_ser

If you notice, this also includes the PCI ser structures. PCI LUO
support is merged in liveupdate/next, and this series is developed on
top of it.

Each serialized structure is preceded in memory by struct kho_ser_hdr
and registered via DECLARE_KHO_SER(name, payload_size, nr_required,
nr_optional). Both struct kho_kexec_metadata and struct pci_dev_ser are
explicitly marked with __aligned(8) because their largest member is a
32-bit integer, and 8-byte alignment is required by DECLARE_KHO_SER() so
trailing feature payloads remain 8-byte aligned across 32-bit and 64-bit
kernels.

Also, Introduce DECLARE_KHO_SER_HDR(ser_name, fhdr) which is just the
wrapper for struct kho_ser_hdr fhdr, This makes it clear
To which ser_name, this fhdr belongs to.


Series structure:
  - Patch 1 removes __packed from KHO, LUO, and memfd ABI structures and
    asserts their natural size and 8-byte alignment under CONFIG_64BIT.
  - Patch 2 records entry_size in struct kho_block_header_ser so the
    incoming kernel derives the entry stride from the block header.
  - Patch 3 converts callers that embedded struct kho_vmalloc by value
    (memfd_luo and test_kho) to reference it via DECLARE_KHOSER_PTR so
    struct kho_vmalloc can grow independently.
  - Patch 4 converts struct luo_session_ser to reference
    struct luo_file_set_ser via DECLARE_KHOSER_PTR instead of embedding
    it by value so both structures can grow independently.
  - Patch 5 introduces struct kho_ser_hdr, DECLARE_KHO_SER(),
    DECLARE_KHO_SER_HDR(), and the serialization/validation helpers in
    include/linux/kho/abi/feature.h.
  - Patches 6-18 add the feature header to each of the 13 KHO, LUO, PCI,
    and memfd serialized structures in independent patches.
  - Patch 19 adds a KUnit test suite (kho_feature) covering the feature
    header helpers.

[1] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google.com/
[2] https://lore.kernel.org/all/20261021152527.375070-1-tarunsahu@google.com/
[3] https://lore.kernel.org/all/20261026174217.603114-1-tarunsahu@google.com/

Tarun Sahu (19):
  liveupdate, kho: Remove __packed from KHO, LUO and memfd ABI
    structures
  kho: block: Record the entry size in the block header
  kho, memfd_luo: Reference struct kho_vmalloc via serialized pointer
  liveupdate: Reference struct luo_file_set_ser via serialized pointer
  kho: Add feature header for fine-grained ABI compatibility
  kho: kexec_metadata: Add the feature header
  kho: vmalloc: Add the feature header
  kho: block: Add the feature header to blocks
  liveupdate: Add feature header to struct luo_ser
  liveupdate: Add feature header to struct luo_session_ser
  liveupdate: Add feature header to struct luo_file_set_ser
  liveupdate: Add feature header to struct luo_file_ser
  liveupdate: Add feature header to struct luo_flb_header_ser
  liveupdate: Add feature header to struct luo_flb_ser
  PCI: liveupdate: Add feature header to struct pci_ser
  PCI: liveupdate: Add feature header to struct pci_dev_ser
  mm: memfd_luo: Add feature header to struct memfd_luo_ser
  mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser
  kho: Add KUnit test for the feature header helpers

 MAINTAINERS                            |   1 +
 drivers/pci/liveupdate.c               |  99 +++----
 include/linux/kexec_handover.h         |  15 +-
 include/linux/kho/abi/block.h          |  21 +-
 include/linux/kho/abi/feature.h        | 372 +++++++++++++++++++++++++
 include/linux/kho/abi/kexec_handover.h |  11 +-
 include/linux/kho/abi/kexec_metadata.h |  17 +-
 include/linux/kho/abi/luo.h            | 102 ++++---
 include/linux/kho/abi/memfd.h          |  27 +-
 include/linux/kho/abi/pci.h            |  66 ++---
 include/linux/kho_block.h              |   8 +-
 kernel/liveupdate/kexec_handover.c     |  98 ++++---
 kernel/liveupdate/kho_block.c          | 172 +++++++++---
 kernel/liveupdate/luo_core.c           |  43 +--
 kernel/liveupdate/luo_file.c           |  58 ++--
 kernel/liveupdate/luo_flb.c            |  69 +++--
 kernel/liveupdate/luo_internal.h       |   9 +-
 kernel/liveupdate/luo_session.c        |  55 +++-
 lib/Kconfig.debug                      |  13 +
 lib/test_kho.c                         |  38 ++-
 lib/tests/Makefile                     |   1 +
 lib/tests/kho_feature_kunit.c          | 184 ++++++++++++
 mm/memfd_luo.c                         | 183 ++++++++----
 23 files changed, 1271 insertions(+), 391 deletions(-)
 create mode 100644 include/linux/kho/abi/feature.h
 create mode 100644 lib/tests/kho_feature_kunit.c

-- 
2.56.0.506.g506a7eabc5-goog

