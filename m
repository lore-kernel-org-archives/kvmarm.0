Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A334AC150
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367289; cv=none; b=PDyxFDRZe51OYi7owSMLafOF9KSM4eUOyajD7PUgURFNtB3XS2H4EO67LcFanzjobmFjKbtVsOwlcEgOemHBZpE0d2LVQp+FGmJfr9nKggPIkHmXxh9Gbn0mrLyjA+vjDbD0LbVmRY+Ph9yLWlD2KpglUReNOGi/51MtJSJc+fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367289; c=relaxed/simple;
	bh=HSDUOoQrDrmlHFwLRcHbs3L5ZjzaqYAkiuTkthsWXI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MY/2b8Z6BRFV6EwVDZCURaImkd8+9zk2SiS1KQgYMKVkhmtrp5Q2gQgdpw+OFVsKoIJr/05nBCgXqvnlJVDlDHjkGGlwNMOcDwBWdql7Cm9Ikjy/LIX7OsGGS9R9MgnSFdFUG8eYhTaHDng/RCOfbo3OnTu5grAA4v9CpcRj68Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PikTP7ow; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PikTP7ow"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6df0a1e18so23623445ad.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367286; x=1788972086; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=377f8tXnWvaciY/JLF+PS/DOVpUUGqN5+0rwp4hwx/U=;
        b=PikTP7ow9kxQ1YX9QZIfTd25oPPd8cyqRtvlgxAB9GbYk+BuZPFfGo/SBcHHB16vO8
         bg03lVUEjISHdif7RqltE1zxORGvCXozHumLAGzSFVjETNkME2QlLykO81e5kfiBpOmk
         hyGV2FGD0SdvQh20U/1aHSxJuFc3xdANRZwrOLmPcL1uJDcKp1z+y6HYBeMFxPNRnkRc
         Vx/0e51C9dKqWx75EADM8xeoJaDyhJxQmpizxbZ43Q7IY9fI194rEvlTHNiC7f/zQZBh
         LBeGMqj4c8jx62faI6ZMwEsdzWTmDiPUATLHdJE9JgHSW2eFg61kRfaIbB8jfAjnzezp
         kYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367286; x=1788972086;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=377f8tXnWvaciY/JLF+PS/DOVpUUGqN5+0rwp4hwx/U=;
        b=P9MfsicAChFbwNU7dB++vLKWlklwskImIgZIXyNKLhTQltitQ2xtk4UElF1NlzG3x1
         rdJ6tbauDDp/bSYFaic5TqenhpLXaFwu4fdyrR5aAmyGzxlUgT+H/MMqIRE4FvaU6xP+
         kexmNbg913fNXub6wOTjWNwtzmPzdFVTrfpyOXI7IRU4KqGywhPk7+w+suH7NpFenD8K
         CbqKVPPyqjLz9GqPcs5rUSUCfOCtuUUwqAhuhecP17/ICHQEWPdQcd0Yj/sPx7Owc9tD
         8IG5/1NjubFt/2wgJmyDaa3TAGWVu54flPZd9VGmKk22C51zN1jFMgZpxapAwiYbiz+t
         onPw==
X-Forwarded-Encrypted: i=1; AKwUvBz4t4/zrKzPY6I016uL5ZwnUsavbQiIc9ei5dygb3GFdAu4jnhC86dP8MC+IuFDPg8MWf8dvKY=@lists.linux.dev
X-Gm-Message-State: AFuF++kjKkaPv24h0MmhUO1kk3cdu18KA9AWcUMoMsIVhbIsDMvKYYM5
	j6cZeRU0pzIu5BJlrSM0uxxL27Peh/mKa2HDa1RuLZ8xpKfLQQMLnDikg9GamcXq8Krrl4IjRtA
	rNb9J3w==
X-Received: from plru4.prod.google.com ([2002:a17:902:b284:b0:2cc:e407:8fef])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf0d:b0:2cf:4339:aaa
 with SMTP id d9443c01a7336-2daec6d8a20mr100626665ad.12.1788367285568; Wed, 02
 Sep 2026 09:41:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:04 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-2-seanjc@google.com>
Subject: [PATCH v2 01/20] KVM: selftests: Use MEM_REGION_PT memslot instead of
 '0' for s390 regions/segments
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use MEM_REGION_PT to indirectly specify memslot '0' instead of hardcoding
the memslot in s390's virtual memory allocator, as a first step towards
taking the allocation type instead of the exact, raw memslot in the
physical memory allocator.

Note, the only tests that set MEM_REGION_PT to a memslot other than '0' are
arm64-only, i.e. s390 always uses memslot '0' for page tables.

No functional change intended.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/s390/processor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index a9adb3782b35..fb9dab92d4d1 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -39,7 +39,8 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
 	u64 taddr;
 
 	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				   vm->memslots[MEM_REGION_PT]);
 	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	return (taddr & REGION_ENTRY_ORIGIN)
-- 
2.55.0.966.g6673acef38-goog

