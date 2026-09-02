Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2956F4ACC7C
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367300; cv=none; b=cg/ZROSNu+38HTInuMPYItzizKvzgf98kITQTPSnWAvyZg9rgTqFbMApiyGEwfCSv+U/zVjh/ebr7jOdVuDC0tVg0TH6W5MJOduPaOW0Y8OH56nCOSfypsoT7hyFmLPB+lF1xC4iBJJhGN8qfVPrRkI2hNDWuDuyG4KxRPeuko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367300; c=relaxed/simple;
	bh=WDeJfGuz/+J1eB10aOiEcQza2SsiAbDgMT/21OjsgZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u8QJtH0cA89ep89S008816zaOFJkNWLjDFwPYVHstOvQVRRFxmfx99i7OMXVDtT4UOofIv20/sO81xTkalSrPaxYtHIJ0O2PEd1JD9/JMge7EveRknB6R9IFxIzC/amQaYLtx+MyoyS5zx/vz7Ag6nT2b8TGK3sRXM8QMpx6IxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rdoul7Lb; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rdoul7Lb"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d932ef41c4so895705ad.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367295; x=1788972095; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gLFvTuC7gXbjk/rOLKK/p7bC02ttHAq/6LyCTsnQIyk=;
        b=rdoul7LbAIbzvpIM4lL39svixFBTP6Evdy8kMHLg/gtxRl72G6ciE7+p93dzNQK/Va
         +jYuQpm04oRcaFlCqFkDjbMTY8N9mTEGW/PL7kFY1wzLHI2ATAyMW2kX1Zvdoh1Hwpx0
         3kF+YxM2QuG5w2GZMBKFF6X+aEyCO1A4sH6mZzqeHyJ7r2M1SidhbLvHcBskPhOGPC3s
         kxEvSIGiJU93BARNwMeGvup0fuFZCOid8sX1u2q/zWGmHbvsFEUcjI+rZc+IFuOQu4/a
         ZObaZJq2mql92ONuL+ztrpuPKG/TyLhzPsJbs777oMS1bzY3sMpkffJUBRdNsdN+KkRr
         IlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367295; x=1788972095;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gLFvTuC7gXbjk/rOLKK/p7bC02ttHAq/6LyCTsnQIyk=;
        b=IAWfh5/JsCQsCp+jY48MEVBbujJsl+r2+I41cDw3EKjfSlg1rpJK0c7ZIacniGEr9p
         b9Y+NHoFmBQ31DFrcqMv5AyVEkKFKXSQjdpIxSJIbZcXCkJjmAvgKOstVMAZS/7AAKVq
         uEiP53vUEOy12aABcSoe2BkdcCC4BpUDjXtT3gOWtfOjSSqZN7EBlAjCUm2AK5HvJQ7L
         NE3XW/1QVuphInC9ZnnGjcT+byZ78ph6FajqyxQvY1iYtkrLj2qBptK5YkdDeRVt/fvn
         0OePWdHyl9YwacGpFDzvzHc0E8zYwGQPmcp/jCZ1GjLH01z394NMJab3YhJ2InXNCFsh
         U40g==
X-Forwarded-Encrypted: i=1; AKwUvByJXTy/x6ya7oaJFWc7rXGUwwjNeuYV3mh1WLch4aHHHBnNiyHfh3hkJVeGUrWjC/hgc0rC1OI=@lists.linux.dev
X-Gm-Message-State: AFuF++maGp63i17A/vKotZkliC82CNQdSM0X1U5rYMtNQdV4CR1k3dUo
	7Pt2DV04UkChrtRJURGBcCGIe6x8J3q1SUMp6nITFZW8cD5ERy8/iDKTgTPglop4RvyGUxJ37uR
	mw8ku0A==
X-Received: from plpf12.prod.google.com ([2002:a17:903:3c4c:b0:2ce:9b49:d497])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:946:b0:2da:fa62:4aee
 with SMTP id d9443c01a7336-2dafaef6574mr4292355ad.1.1788367294564; Wed, 02
 Sep 2026 09:41:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:11 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-9-seanjc@google.com>
Subject: [PATCH v2 08/20] KVM: selftests: Use the innermost page allocator API
 in the memslot perf test
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

Use the quad-underscores physical page allocator API in the memslot perf
test in anticipation of converting the outer versions to take the memory
region type instead of the raw memslot.  Stating the obvious, the memslot
perf test creates and allocates from multiple memslots, and so can't use
MEM_REGION_TEST_DATA to communicate which region/slot to allocate from.

No functional change intended.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e1299611be32..844ea9b7bb41 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -339,7 +339,8 @@ static bool prepare_vm(struct vm_data *data, int nslots, u64 *maxslots,
 		if (slot == data->nslots)
 			npages += rempages;
 
-		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr, slot);
+		gpa = ____vm_phy_pages_alloc(data->vm, npages, guest_addr, slot,
+					     false, false);
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed");
 
-- 
2.55.0.966.g6673acef38-goog

