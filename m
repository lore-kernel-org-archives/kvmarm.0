Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300583B0AC6
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785518; cv=none; b=lAT4eQG8MNv9R4+C9z4i9ztBptNoe1n3NyDdXftusIyRrWse8XtCMDG5mMsYPKIxdutbB9uF1FsZRLfRkZcbWtLBuOVBsoeLgDYPJwzbn8vhBiV4O0DPHieoXOtlngPrT++hhRI14ONZOxX1sqKz5VMZ8vCK17RVId7XDkIZTsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785518; c=relaxed/simple;
	bh=bbwkNrWPELDGGOA1Zgqc6lm5Iyi+SZhGGDW/VfTBloA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bT/9m5u/M/WRFQcv3Dh8LlBPA5hq5XLCiJJlloNOczg5AOpwfoulCLDEeobe1nziX5AA4wO27faYkTCCVjj2VLLcSdzbZ9Ea0qN6V8Y7p+2J9nB5HMN6wZAIy9/KKVbiPryrpBuTAoyELWIPHlB6orRN5iu3rj24evXSBsQZGgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oa0K2BrP; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oa0K2BrP"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e375d9736so61996b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785515; x=1788390315; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q4+F4DrSTt+i0FxJ84+DMWU3o/oO2URpTpZf4B4dXhQ=;
        b=oa0K2BrPkhnPbTFzfZduHxlp6h2mpp0i1jzlPOFBHdaU7V+GebJxkQ7QREWARD5chc
         tsAVzFPPynRKmBcVm+2RLppD7l+0xf9jwqb68tmIta0x3612UY8cXul3UbTP7Hv3pyfa
         2UyUZDkQSFCQCQuJzKbt1ho+K1RF1tQv0b4tTfhGPaC7acvaEHD4BKrNwadavRzZ73G3
         651PGy1jSbCsOuBfVmg42g7F3vtytymGMKkbAcqKde/qGOgrBAeqdGrvy0OP8ushf22a
         /DdHepjNbq1/U1SD1XvboHXRiUHVu+AmNzTbQe0HTetLDnBAAVDYbx2FEqk4mJF9HjNr
         ixOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785515; x=1788390315;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q4+F4DrSTt+i0FxJ84+DMWU3o/oO2URpTpZf4B4dXhQ=;
        b=UDeriGo3DtJPysQQW5ouKM0H73kpu03hZCHQB0Va+KRE7F42DeJvXG32LhnWCaCnvc
         xn6cdCtJL7ggg070CYicmwvDhuOf61onMaAGuuvRFscIg9DTIAvL4Mxqyv636VfxI4KR
         lt6RHUvs+J6SdZJ0opQkPPMIXZ7X3Db3V03yqqb2gzcvGEtiqtKsldRs9oJ24SjrSjHL
         zt5QIVnDvn6CC5KbQx+Fk5mYvlcSHWH9Jhn4D6HBmcDJb6YMGM/Xp69u1JhBV2ZRzqt/
         nkJj7qs2mNKxwun0MNFMKodz08E6aq6MBuUbVSwf9Pd9cL3c6jDQOGAWP6Hwpiqk1q7N
         RDZQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqz9JzBkQzo7x6gfQu/LyZXIPrO35woxkoMY2Q5x/MHAuYSTT9gm/DdIejKWmUvio8mIQG59wI=@lists.linux.dev
X-Gm-Message-State: AFuF++mqY75tFgoGHwzbk4XwmB3aggaZaT+teXzg+EB1B7wowJfGeeu5
	8fWu5FMP1uXepaACy/Rl774aTVqj1w988rMVRJpQoBHboOQWaki9uPJgexwVOMPYuuI1ol+2wgC
	99TPuAQ==
X-Received: from pfpk15.prod.google.com ([2002:aa7:9d0f:0:b0:848:2e0e:62e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c96:b0:845:ce5f:c926
 with SMTP id d2e1a72fcca58-85372ea6666mr19057054b3a.1.1787785515178; Wed, 26
 Aug 2026 16:05:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:52 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-2-seanjc@google.com>
Subject: [PATCH 01/20] KVM: selftests: Use MEM_REGION_PT memslot instead of
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
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use MEM_REGION_PT to indirectly specify memslot '0' instead of hardcoding
the memslot in s390's virtual memory allocator, as a first step towards
taking the allocation type instead of the exact, raw memslot in the
physical memory allocator.

Note, the only tests that set MEM_REGION_PT to a memslot other than '0' are
arm64-only, i.e. s390 always uses memslot '0' for page tables.

No functional change intended.

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
2.55.0.887.g758fc8c411-goog

