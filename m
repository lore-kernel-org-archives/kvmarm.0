Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2172E8B67
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134674; cv=none; b=K/K/4inNIh6QLfcnHQbSb96ZQaGNE9+ykIerGltCNdiF5gwHXQ4Qzo1eIdMwvkIcSkJEzKN7DxpwsU711p/35IXkpj33RkC+4ao5I5oae5jb93tm2p0WbHAOOsyX4Tsxq+euIzEsIdY7vvAD64SAzIrQoGe1edKHITrS23xC+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134674; c=relaxed/simple;
	bh=c0O/aT5Gpl8+UCkMpvDctl3R2z7yRn0Zg/P5zNWRebg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lj22uAlJacc3fYeso2U0NeKJ0/Hwyc9DGl2DeJY56tfbtasp7UdGOPdaNrgQxKHJozVdLEyAGC1ihwTxwJBFnOscpHXdXnle6VSIllXSRcbVqDSyo3iNW8UxodRU50ml6sbqz00wEDKQ3O66Q0obd/WXl62XLyHmPjbFIGQHhIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a0wtCgV8; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a0wtCgV8"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4858f06e142so787314f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134671; x=1789739471; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+LydG6lpG7KGsYwDk/rwkNtgM8Oe883d29LLncn9eFg=;
        b=a0wtCgV8tszkB1lm35S9U8Btjq3IzbTj+kMbBJWt9rzkN99niwj3Bgj3rUmjnrQKY4
         9hgKTyALiPSw/1nU9Ii5ZqygcnTOLVysU/NuERKWfE4V/ZE2pmiOOA4rsyZjhRJvfVap
         wdwg/+OPdV35X+YU8DeavcdkxZSgmsoY+OHjFysQwrx4TUUt8Vmg4hWOdJpsJBMkWqzg
         PihGHGPaidFLQ2jKUdYYc+tUWkPFK1IBVaCOi9hkyVFdZauJdepVYlBq0QUBYi93zTKr
         cueWdc2WkpLW5eNnA8P5jkIaxEjoEj0rLIFFS2M+Mpe8OiSwTJ6Y9g1rrHquT5473Ztb
         dwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134671; x=1789739471;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+LydG6lpG7KGsYwDk/rwkNtgM8Oe883d29LLncn9eFg=;
        b=gNeg901EZN2WZjXWb0KJuV1KmUx/E5pP2HKSRPTdun4hfT0Wyq+Ux0e83r6MqjM7CF
         O2fPASY5hFw0iTJfwhCueWFNJoPfMc8JbceYRNwLvW7y52f33kWjSkhkU8cHNkW3ihiY
         DSULjgVNWcVHImbie3rY6s6ZrJar8VHlsgAV67LYTxJGbEmvWUSISEO6DF5dFO5yLt0w
         9XDl5pe41BOXm76Dj3Cn2Vl1dZmVyYqqbbW11wQzhFXNFpmkHKQ6EM3nR3bEWaTVT63M
         kicJd3RfJR3bhitPjW7uh3d2G6OPIkk+t5z79Okfu55/l7JN5u1Ittwjk9f7agBL76mr
         /isA==
X-Forwarded-Encrypted: i=1; AKwUvByRUYtMblsQtN3xwafx2kjhgTKkT8nB6oNWN54E9AWy2aR+LiH9+9vOhnZgKooe6Fono2eE7Hg=@lists.linux.dev
X-Gm-Message-State: AFuF++lY0rWSZXbh4LDLeTaBroYDHlf7LdES6N731vD8orEq/MR0h5DR
	kCSQvcK5hYzcR9i4M6UctEsNHfu7OCCMK6z1m/0G6uLxK+ohD2lebHRYlAUWgRMLAN525+hFZf6
	1wDP5MG2py+Zzy1z4uzXvTA==
X-Received: from wmpl24.prod.google.com ([2002:a05:600c:898:b0:49d:2641:2abf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e0e:b0:49d:7f5:4cdd with SMTP id 5b1f17b1804b1-49e619d4d30mr54210355e9.27.1789134671360;
 Fri, 11 Sep 2026 06:51:11 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:39 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-9-vdonnefort@google.com>
Subject: [PATCH v2 08/22] KVM: arm64: Add a range to hyp_poison_page()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
add a nr_pages argument to the memory poisoning mechanism. Use the
existing __apply_guest_page() helper which speeds up the process by
using a PMD_SIZE fixmap when possible.

Also, rename the function to hyp_poison_range() to reflect the new
capability.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 58ea0fa62226..642096b2e711 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1276,11 +1276,9 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
 	return 0;
 }
 
-static void hyp_poison_page(phys_addr_t phys)
+static void __hyp_poison_page(void *addr, size_t size)
 {
-	void *addr = hyp_fixmap_map(phys);
-
-	memset(addr, 0, PAGE_SIZE);
+	memset(addr, 0, size);
 	/*
 	 * Prefer kvm_flush_dcache_to_poc() over __clean_dcache_guest_page()
 	 * here as the latter may elide the CMO under the assumption that FWB
@@ -1288,8 +1286,12 @@ static void hyp_poison_page(phys_addr_t phys)
 	 * host stage-2 and would otherwise lead to a malicious host potentially
 	 * being able to read the contents of newly reclaimed guest pages.
 	 */
-	kvm_flush_dcache_to_poc(addr, PAGE_SIZE);
-	hyp_fixmap_unmap();
+	kvm_flush_dcache_to_poc(addr, size);
+}
+
+static void hyp_poison_range(phys_addr_t phys, u64 size)
+{
+	__apply_guest_page(__hyp_va(phys), size, __hyp_poison_page);
 }
 
 static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
@@ -1361,7 +1363,7 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	if (ret)
 		goto unlock_guest;
 
-	hyp_poison_page(phys);
+	hyp_poison_range(phys, PAGE_SIZE);
 	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
 unlock_guest:
 	guest_unlock_component(vm);
@@ -1389,7 +1391,7 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 	switch (guest_get_page_state(pte, ipa)) {
 	case PKVM_PAGE_OWNED:
 		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE));
-		hyp_poison_page(phys);
+		hyp_poison_range(phys, PAGE_SIZE);
 		break;
 	case PKVM_PAGE_SHARED_OWNED:
 		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
-- 
2.55.0.1007.g17ff1f9808-goog

