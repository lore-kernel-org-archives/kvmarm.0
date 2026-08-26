Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDFE3C4542
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785539; cv=none; b=aMcTELFtEXLHQVzUYDjs6c7s6dzeeLMRUPM5muaYpDIsv/jwjZAKwhEeNKyoQ/JFTjNpxzxDq3t9wdi1nAvDZNrsCIVvLJf/ytxJ9fJf0RPKB+2rYQtxGIa254liP1fcZI2VGTG9vFAT5Kj//9KHRebgjCGYbibFHxzu6z+s8mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785539; c=relaxed/simple;
	bh=3EDupCSd227h2crKQg33vyihGNO4uU9jZfUf3CJAc4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnB4jdhEuWQDQ6bFMVGWDJEi5LeVZ8GA8w0tN0iOpENZF3nwZYJJvwhBXfTETbFJfESmX81piXv4AcuBzflUyy6O4qrVQaHYU66CTa9nm8Y8mi+5kp9J1bTtRaCXHI+LwkfpEblExMFcMR7LWjpXaMzKQJMcEvJ7oqaR7HrKeqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FsqT6H/v; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FsqT6H/v"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1c2f1acebso175076a12.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785534; x=1788390334; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=x6dP/JlGXbpMmzJiAs51wjG9zHvCLsaGeW9+h1tHon4=;
        b=FsqT6H/vT2wMQp1KMhhT4822h34V+c/XiwpEbtEA2CYvHzhEZ0RwmtN2MAYyBEyIDt
         Zdy6h+qxQr5zuRxxjHM9QMAVyMezKFzu6Weo0Md/h0J8obYEBwkj5jqKgfmWUE7uazzz
         kBSg9Mc47GjPjG2pE27D3PHiC2APXq8PcMe44vkpM3kKOTab3t/VdHstdF1Uzg33cgCB
         Fx4nWkhqbLzjuPCt8ghYTR3qhHd1D/zv46Om6VMv/M6o7dxpUT6eCyhB07vwpNefJP03
         RdxST5+nfnaYdHCtANcvgPvcX2AZBC3pxOP17K1tehwNfHN25JDezSm9dWiMX9LwXgxu
         YLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785534; x=1788390334;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x6dP/JlGXbpMmzJiAs51wjG9zHvCLsaGeW9+h1tHon4=;
        b=l9GeQIhIvL9LEOMW0R67zR4ztujJiaf0VsquL074g4YhGkoAy6PcIKLA8Q40Cw8x0F
         T14VFXcyQX6SvFVaL6UKR51mDW1Chonl9AUOEa+kPzFxp/FAd35Y/5UX7hqXqhEmRzu+
         3ihBVSv5DVQynRMRL0rPRCI15AiQlgan0EuxMv6WNpVwAIaSAET/t7Hka4n81pfWWkfB
         rvjgDTQ4z21xFStTSAY6nDTq7/sVJRiubo3bpaNkmTcrBSPYk50RkPg+1P65OpOhI3fW
         O1yQ0sQ2BLsPqrZgEsKgWt9LMfpU1DbU8wzt27vBKtqqap1jEjpdGPMVdeuHYMt+T5p8
         PQWQ==
X-Forwarded-Encrypted: i=1; AHgh+RrWwFFUpEEA3VNATlp26HWhugGg956KQZghI56J6awgUD5ZSSlTZwv7ijtL/+XLMEL3RYt7dtY=@lists.linux.dev
X-Gm-Message-State: AFuF++mHaBSAd/A8J8NpDcDk46ejSnCmYO1oiV0w0cIOzE9LqTZ35Wx5
	bzCVlR2YYX4GHX2svR0BtMqyuUfc6k5iVdVs7FmtnE5/ajd+CF0ZX+k/vbRMp0oZ7IJhc/aA5sp
	MM58ihw==
X-Received: from pgcv20.prod.google.com ([2002:a05:6a02:5314:b0:cc1:c423:3804])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cfa8:b0:3cc:8f53:26c0
 with SMTP id adf61e73a8af0-3cf86dd6053mr21955403637.17.1787785533546; Wed, 26
 Aug 2026 16:05:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:05 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-15-seanjc@google.com>
Subject: [PATCH 14/20] KVM: selftests: Use TEST_EXTRA region in arm64's vGIC
 LPI stress test
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

Use the TEST_EXTRA region/memslot for arm64's vGIC LPI stress test instead
of a custom memslot, so that the primary vm_phy_pages_alloc() APIs can be
reworked to take a region type instead of a raw memslot.

For all intents and purposes, no functional change intended, as
vm_override_mem_region() is barely more than a wrapper for
vm_userspace_mem_region_add().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 9a69c439a0f8..9865b204fdeb 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -164,8 +164,8 @@ static void setup_memslot(void)
 
 	pages = sz / vm->page_size;
 	gpa_base = ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa_base,
-				    TEST_MEMSLOT_INDEX, pages, 0);
+	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS,
+			       gpa_base, TEST_MEMSLOT_INDEX, pages);
 }
 
 #define LPI_PROP_DEFAULT_PRIO	0xa0
-- 
2.55.0.887.g758fc8c411-goog

