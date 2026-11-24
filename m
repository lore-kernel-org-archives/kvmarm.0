Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.82
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534130;
	b=4M6aKly1bTy6ON4lc81fhDOZQvEl+LIVV3B8bp+tHYTkFk6S5FhM9QJ7OOj8dY4SMl5f
	 wqrUsW7ibZ8+wFWjFAjRx9JSPjylRTXAI00Nj13tlJnpyu/bRcQznLGuiiknFZcQ+Ssqk
	 sExrok/JGrT5wngTw7fIGtR7hsP7L8PS7Im4o3+HuAvT5b13E9i0cpNCdZIquQ0TuwAYI
	 kOK47RhxSwoqsRrKrRszwvZKglNKB9SFU4+2ZoooiLaurgqPsHi5Ppre7zZWsXT6uu7Iv
	 9+dkc0cNCBkENR/Tf0XTpHf3p9DRuxvq/vqcww7mchxZxf8Jf265HorF5WeL8xaKq4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534130;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zvW5z7zfahFNFXi+Ssaf7DpYERKkjJt0YrEyUHja2pk=;
	b=qyCAZcTP1Qi9sjog4OKPpJhTqzsR12VI4Jj3n+ACLQj6qFOv1sFUb8VdKrLjKP8cdh06
	 mm4EYweIcL1sFUixNh2ALxpYftispxcQUKicw8smOoHDtGYuB6H5R8EAydiJv6n/0nT2D
	 izLsXl6Ea/AP4b5y/B7XjPcyxbRX3nWyj9D4kYLXyt3ybPEljGW+BEZGh6uevPx988Q71
	 qCTRI5NYMoCJjeRKOU97B3LHi8HGshFnX/3eoHQ/JNA7Oq9INRxWjYCvg/YW+mEPhsvEm
	 KsWxF4EgsGKdiNZMyOJZp3aZq3lgeFshIeRLDO3LFQwWrtO3TkwuJxs0FGkNZrW47Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rl5TBK3Q;
	arc=none smtp.remote-ip=95.215.58.82
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDF0606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 15:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEDF0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rl5TBK3Q
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZlYt6RHKpSvMzdObJH/W7hyfD0aXwfhI08mgyRDFJwI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795534126; v=1; x=1796138926;
 b=rl5TBK3QwdTeY1TK3uUsnIKSS4ENLNayfuJ6UfDk+O6b5px3VYGscxsXAKxN/aUgwpcCHM6O
 /hT7SJ+513ynvCXDaDybUTIm49KfFnPT4bIq1+zqi7PEOoDoEgVPUvSFAfzobUW4Vfwurxg4Afl
 0ygx21yKCVuBT7ig1OntiEGk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 1820b8d53bebf8b1;
	Tue, 24 Nov 2026 15:28:46 +0000
X-Mizu-Trace-ID: 1820b8d53bebf8b1
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	rkeilty@meta.com,
	atish.patra@linux.dev,
	dgreid@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Date: Tue, 24 Nov 2026 07:28:42 -0800
Message-ID: <20261124152842.2634495-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
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

When a stage-2 fault may need new page tables, KVM first tops up the
vCPU's page cache: if it holds fewer pages than the fault might need, it
is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
40. Unused pages stay in the cache until the vCPU is destroyed.

With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
used. Stage-2 has at most three levels and the root is preallocated, so
a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
table pages to map all of its memory, while its four vCPU caches get
filled with 160.

On a production host with 64 KiB pages running 101 VMs with four vCPUs
each, the caches were still 86% full. The memory used:

                        before      after
  per-vCPU capacity     2.5 MB     512 KB
  all 404 vCPUs         869 MB     <= 202 MB

Let's lower the capacity to 8 with 64 KiB pages, In the production
usecase above, it frees at least 667 MB. That still covers the two-page
minimum and leaves room for several table allocations per refill. 4 KB
and 16 KB pages keep 40.

The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
but it is topped up before every page it maps, so 8 is sufficient there
as well. The pKVM hypervisor memcache and the eager split cache don't
use this capacity.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/kvm_types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
index 9a126b9e2d7c99..28568da9ea4a7b 100644
--- a/arch/arm64/include/asm/kvm_types.h
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -2,7 +2,12 @@
 #ifndef _ASM_ARM64_KVM_TYPES_H
 #define _ASM_ARM64_KVM_TYPES_H
 
+/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
+#ifdef CONFIG_ARM64_64K_PAGES
+#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
+#else
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
+#endif
 
 #endif /* _ASM_ARM64_KVM_TYPES_H */
 
-- 
2.53.1-Meta

