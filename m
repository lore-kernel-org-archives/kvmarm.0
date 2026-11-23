Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430113;
	b=147YDmDetbchujt9lCS/doaWC6Hv2oKIPYU3Lh7ISxhZ7MOWgS5khAPjm11u7zvaurxY
	 0kqmNZp6WK6NEB6ull+8hUOKLfLj/dYqKF8JyGYI6sCAT4p5GJ/1XUESWsktF2nVLJ/Wo
	 +HpGpUjjlPCckFTAh5njB8ozmniaeoKkjtYGwXjRIEhRfhTc4i3cLl/VBHsAihADVcJmq
	 fJ0CYbGY8pTsu7uKik6P6+xhd/YnjipbIDCzC/KV5/0EK90ajcj8hF07MjwhcilsWa85i
	 MT0RVhGAzQjeSKVgWldhA7eAJ0fglOO4nVGuhC3q1McsNGKJ0WQypfglSVZ8ICK5slQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430113;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cIh+Iax7BM1D9H5+u/MnfHAua0Cwb6nfRtbILLfMpJ4=;
	b=Uk3FVyydojUsccsunTK+RQZkgXji373G+to4SY92SwAORxx94yl5cUvlVzfElCh22nsP
	 FppsdFw1K0zXFOduoSqLTozCHtywCKNCDH5cTa+VgtPDXYOVbaqUtZKeUwaPkSqJcDrmt
	 3mIqpxUuzmOxlaGmrxxJWxzv+GOw1FW3uNCm48YoyilOv/NLYnkDjFrxZ4TkHz1lUhW7O
	 s5b9VssU/tOhNmAhTzk1FsJz819FW2YoMEhBdxj6YG0WRt3aD2XygrmhaGf8Zqx+GAnkz
	 dpsiMj3/kD8Xe3TSlM2sS/MxnqaWyZsvSWC7WS7+IcrJh3aKiOrEmQnt+u2ht79l2AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ichrSp5e;
	arc=none smtp.remote-ip=95.215.58.80
Received: from mta1.migadu.com (out-80.mta1.migadu.com [95.215.58.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F869606A31F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 10:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F869606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ichrSp5e
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=80DSeNgLr4gsI8o+Z1IuJ6m5ooSb7Rnaj6ZFYHuYkyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795430109; v=1; x=1796034909;
 b=ichrSp5eI9c1OKZOfLGfFaplpOPqtzhHb9q5SW/TjfWss5IvKBL3JOHVRSULJEnUDOlh3F0b
 yAFyvGqkHogv338vC1UzKnh5blDikP+Svu5+1S3CN/XF7BosW3WdJFjNTX0skNfRFvu3f/mS9k5
 vEKAoSFlNIr42V2rBxdrNiHI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f6937f6a9f32d691;
	Mon, 23 Nov 2026 10:35:08 +0000
X-Mizu-Trace-ID: f6937f6a9f32d691
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Fix THP block mapping when the PMD level is folded
Date: Mon, 23 Nov 2026 10:35:04 +0000
Message-ID: <20261123103505.1006067-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123103505.1006067-1-fuad.tabba@linux.dev>
References: <20261123103505.1006067-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a THP backs guest memory, transparent_hugepage_adjust() rounds the
faulting gfn and pfn down to the THP's first page, and KVM maps the
whole THP with a PMD_SIZE block. However, the rounding uses a mask of
PTRS_PER_PMD - 1, and PTRS_PER_PMD is 1 when the PMD level is folded
(64K pages with a 42-bit VA, or 16K pages with a 36-bit VA). KVM then
maps PMD_SIZE worth of pages starting at the faulting page, and the
guest gets the host memory that follows the THP. With pKVM, the
hypervisor rejects the unaligned block, so the guest doesn't get that
memory.

Before the conversion to the generic page-table API, the unrounded pfn
went into a block descriptor, where the address bits below the block
size aren't part of the output address, so only the THP was mapped.

Round to PMD_SIZE >> PAGE_SHIFT pages instead.

Fixes: 6f745f1bb5bf2 ("KVM: arm64: Convert user_mem_abort() to generic page-table API")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db73..bab44021654a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1573,9 +1573,9 @@ transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd, kvm_pfn_t *pfn
 		if (sz < PMD_SIZE)
 			return PAGE_SIZE;
 
-		gfn &= ~(PTRS_PER_PMD - 1);
+		gfn = ALIGN_DOWN(gfn, PMD_SIZE >> PAGE_SHIFT);
 		*gfnp = gfn;
-		pfn &= ~(PTRS_PER_PMD - 1);
+		pfn = ALIGN_DOWN(pfn, PMD_SIZE >> PAGE_SHIFT);
 		*pfnp = pfn;
 
 		return PMD_SIZE;
-- 
2.47.3

