Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827154;
	b=HKlGTNaDRkwHNZxQZOWliW5/yrGAVD98+3Wl9MpHOyOP7T2ISZk6TMYKZFuYBRchduIF
	 dQ8TfTMcqlbgVLN8k8p130QMjTz0umoCGoxgGxTK8k+7tIhLnFFL6h5dJepKUEW9ASQ1A
	 la+iXe6wvG48kn7bmESW4BcthNBbjUgbQ3GbdjYBQQMvz0qQfnTBQoFCqwisko44p5kqq
	 3D/sVf4fGXbOQrXzvkLXnFr+7FiFaxWkUPxm3SW+7Rs4329arnlwU+vWuiQODTxWi7VYh
	 E69uX0o0j7amGKD9KhcjhwD3DHGDYtA6wbhEWxOoGa+bSddVayJKjU69OHP6WAPPqYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827154;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ac3f7pvozHRMKcmrspffsdFebWreOCTqfsZg8CNjtpQ=;
	b=3oPt3W9Q/2E02z94AnLNSoupwvLJohC7LBSw55iaE/k0l+Sb2haddmMuKRBTOGoq6ZV6
	 ZFU7+KL7km/cPJrsBzZJCULXCufIrZvOe9NnQbSZVrqm3GQtIXX4PGubX6fFA+Es8Oypb
	 yN5iBEeEE0/LMjSc2+RtLh9ijWaQ+ZmFvs2HvsXO1dhv2H/nekl6HrcCLE7QwjKB7n9ah
	 kXc6SpjR3X+6mR01Du4+1/qImAyAqQbnlFT0mbtLMSa2xgEHXjU4ZqsNrOyP66gi/0Zcg
	 O6kZf6gGdZXtmjWGdGJ9znpgKYtuuHUt5cNGpBtm/ZRR7+gNFpM2Ye7Dcj6jT6aIrAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s7eg7tKp;
	arc=none smtp.remote-ip=95.215.58.1
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7276606A88A
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 11:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7276606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s7eg7tKp
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=m5wyWpf9Hx87dvxO36yhwoD+oIhUOyMmO/fTyfd0zBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794827150; v=1; x=1795431950;
 b=s7eg7tKp8SgVGREdI8d9hMMs261snyawQh9XWPSsGFIfBNIe+oyueARCZ4H5JOi/ssjyfL6U
 I6WfcTh0ENqkM9OQWau+pXN5UuEJiF4z+JXdtwbzSn9w4Yz3ozz6YieHeWdX3R+3MLpcRGYkcvY
 cYR8NLiXdQDDz/4aOHy1gbK4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 099d0d4b73867140;
	Mon, 16 Nov 2026 11:05:49 +0000
X-Mizu-Trace-ID: 099d0d4b73867140
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing it with the host
Date: Mon, 16 Nov 2026 11:05:49 +0000
Message-ID: <20261116110549.1863653-1-fuad.tabba@linux.dev>
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

From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>

On pKVM, set_memory_decrypted() shares pages with the host in place and
without cache maintenance. The atomic pool, dma-direct and dynamic
SWIOTLB pools zero their memory only after sharing it, so unless the
page allocator has zeroed it, the host can read whatever the guest last
left in it. Zeroing first isn't enough on its own, as the zeroes may not
have been written back to memory, and a host that maps the pages
Non-cacheable then reads the old contents.

Zero the range and clean it to the PoC before sharing it, so that no
caller can hand the host stale data.

Fixes: ebc59b120c588 ("drivers/virt: pkvm: Hook up mem_encrypt API using pKVM hypercalls")
Fixes: e62decaf98e7c ("arm64/coco: Add pKVM as a CC platform")
Link: https://lore.kernel.org/r/20261116091137.94252-3-aneesh.kumar@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
[fuad: take the pKVM hunk of v10 patch 2 as a standalone fix, add the clean to the PoC]
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    This is the pKVM hunk of patch 2 of Aneesh's v10 [1] plus a clean to
    the PoC, taken on its own because it fixes a bug that has exposed
    guest memory to the host since v6.12.
    
    Based on Linux 7.4-rc3 (aebb727447640).
    
    [1] https://lore.kernel.org/r/20261116091137.94252-3-aneesh.kumar@kernel.org

 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 26fe9c3f22e36..81d1cd24a2eff 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -9,10 +9,12 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/array_size.h>
+#include <linux/cacheflush.h>
 #include <linux/io.h>
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
 #include <linux/pgtable.h>
+#include <linux/string.h>
 
 #include <asm/hypervisor.h>
 
@@ -61,6 +63,15 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
 
 static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
 {
+	size_t size = numpages * PAGE_SIZE;
+
+	/*
+	 * The host can read the pages as soon as they are shared, possibly
+	 * through a Non-cacheable mapping. No caller relies on their contents.
+	 */
+	memset((void *)addr, 0, size);
+	dcache_clean_poc(addr, addr + size);
+
 	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
 				  addr, numpages);
 }

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.47.3

