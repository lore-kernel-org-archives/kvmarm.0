Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792672258;
	b=WCJ4HNuZCjTC836vpAn3yZ2KVRrhTJesQRQCuAp4BVpAd7ac0f070Y2bfKYlx4VYbXRM
	 P2ZSx5z0T70I6UROFuSgn3DXwXyZh8yV3qyo79qMCTkbdCHz3Yh3qzrkfMLP/KPJx2NIl
	 j2sHnBzXh7mbyvHwc55NtKa8Uux7qSVq9/A7M6WjiwutbgGhrjkbLmTHF/albT17itn2J
	 aQMos1pnEZAs2e9AbV90uxdLmSP5ElwmkgYzWOvzBnQU/UwHh0FNXb6FQ8GLmLpo+d62q
	 /Jb4Pil30nLXhgWHd5JrRWuHCSObrpr1b+1iJTMQz6eRgtcLDgvIARbTmIp49T6JtDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792672258;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=R1+QFn5NnYJLRrxfa1xiHyuj6P1mZ5EIMR+tXbGhrSo=;
	b=3VBe1o188lg/WfE3x+WGLMIdpvRXUPIOgfOxSvmo9olNa1PLyW/duUOl8+F18INQjTHA
	 DVagKc7kDx7pS4XYgqKVYPzQKwzoyu4uwgJnIy/4cy7MWEWnhU/A3fHYS4HBVUmHANjN5
	 yw+ojiPjbQDHdaVV4ObybdTJYWlfezTAh+I7zdrq0n2u/hZYcIqFqTf6NkKjhyBVxL6hm
	 g90oLdpssWVTFmFi73PoM3L+HF34hcqRrxcKzR3foRtVAy3/adgr4PIhoq9OEkpEtYWAM
	 lsNQV61oU4d3sNM7S5UhiEvAib51z7twXLgedZ4MXEwc4erZijzOtt5sfDs92NPsmnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RibjKLMp;
	arc=none smtp.remote-ip=91.218.175.47
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4607B606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 12:30:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4607B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RibjKLMp
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=bcEFyXLNNN2YEegylVTbpISQSLNIpIMitdaFQngWC1c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792672255; v=1; x=1793277055;
 b=RibjKLMp1n3ImBy3u6tyijm3geFzYvJ5rk0k8oclP0bj76BxzncTVzWxtaUScOqFBlvBoXUL
 c8EzmRaZOrjOdUVHMKE6LxC1sp71MJ6uGO13JW6XXuKjcXHaq2fOFbtiFveS74ySqhve0uBxgV1
 qyUJHoTqGYF7SGlcgNl2BGno=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 679f88ca96f9b2a8;
	Thu, 22 Oct 2026 12:30:55 +0000
X-Mizu-Trace-ID: 679f88ca96f9b2a8
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH] KVM: arm64: Return on kvm_gmem_get_pfn() failure in gmem_abort()
Date: Thu, 22 Oct 2026 13:30:54 +0100
Message-ID: <20261022123054.31729-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

The kvm-arm64/mmu-fixes-7.4 merge dropped the return from the
kvm_gmem_get_pfn() error path in gmem_abort(). Both parents of the
merge keep that return. On a failed kvm_gmem_get_pfn(), gmem_abort()
then carries on with a zero pfn, and on a nested stage-2 it uses the
mapping it has just freed.

Restore the return.

Fixes: 65f95b2874a15 ("Merge branch kvm-arm64/mmu-fixes-7.4 into kvmarm-master/next")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    I went through the rest of the merge's conflict resolution with
    git show --remerge-diff, and this is the only line it dropped.

 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a48f3f531e827..ba4fe58222ad5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1802,6 +1802,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 						      s2vi.vma_pagesize, write_fault, exec_fault,
 						      false);
 		kfree(mapping);
+		return ret;
 	}
 
 	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
-- 
2.47.3

