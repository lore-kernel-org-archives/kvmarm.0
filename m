Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937468;
	b=Ucwtvm9xc0y7x5VEbxXmCnC+JU/8svcCnau4Yk7DipZgjNgfmhf5aWgU2It0z6HwDNpR
	 gYGzh3FVUI5F6x33JaE73OSk9VzolqQnO2AJP1bR7CTXEcqGIPJFKDARylDEHWXGoz23I
	 xxojhUAiRdouHXtphl0mvs3oz6AG8BMZc3xC+d7cuWJmna4R+ThbcEgNz7f69VxQ7FVxH
	 1PspbW/2GytaJxbufl0IXV+9Jx7IuHL9d9+WDH/AZvZxN+arsFzN/ZnY+2i6039nJIBHj
	 st9SjKMlEYAJFLPTjzHLLub2qLweuzOj8myjww6FwySyMhLGSuKFoPYvNxjhLh+xJyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937468;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=qC8LcM+3/L/7M3Ds4+6XPqLCUpbVU9jut2tvypbX9gU=;
	b=lXUsWp2EgGGTRr27k75ztWCvY4HFiWEgq24IYVf1Du8w/Jv35RjipuVpxsCDh7tzHwEC
	 KlvUrutKMpsfRS8p/xsO8z0TufbmkD0wETTRwpseel/lmtHIIpfdNYlIxW6sRSoVFMp+k
	 PxeLl6/dlA6Mg0fTYjVLkZPo+vS9Yg6EeUwocbtVTgRW0rlWDTXbAVHY68cJqeKH88mzK
	 VRajg71YCPItPYkgBK5n6MIcyXe37hUU9H39EUXeUh1Daxdik3pSwnnmo1cpCHQeTTcx5
	 bf2VMMPtLzWKGFfj1cpBHvjuRjEM+1c2/v0GZ4rNvfVtZItIaMwk5njzih64OrOlNjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nwjlU6DW;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191AF606A33A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 191AF606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nwjlU6DW
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a70b42bab0so11165945e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937466; x=1795542266; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qC8LcM+3/L/7M3Ds4+6XPqLCUpbVU9jut2tvypbX9gU=;
        b=nwjlU6DW3+t8j5PURteSeeJcvW1le4KJ8YZtGcyW1iMgTiMqTQ1dRwD4L5EVy6DLT6
         8fI8E02yAm+w32MQzVmtBt8rxyvs8UJPg+gkTZM322aFtD3P1vYIimk6ev1FhPvRB4e0
         nJfXRj71lxjHZVY4Qi42GX3F9lE7XRFVuJ7rx6BfOkRXRdnK5Xs+ECOaEbgRTI7fVO2K
         kOdG9Yxsqr3XF6TEaKhZ/m/PBRdySMZE7pN82TWK+kuvIQgPFG8oJC4iBELEcWAStLOg
         PKEM0xJVOz/4U4nJ+xpzsntSm+uHmrx2vypfWqhtoTQB+G3oPMxg1orNOFqIlPasfwzu
         NbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937466; x=1795542266;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qC8LcM+3/L/7M3Ds4+6XPqLCUpbVU9jut2tvypbX9gU=;
        b=KFdV1OBuA3mimPRQkw6ZtETjxc8edjGrimq6ZCHN0EWAUaFOJ81+vI7f80/zAs9ZQg
         hErSDpPGLKS0hgyRX+qw3ruUt4lUphv8Iu3hSA4t6M+RwbC7O767/BAShjwoPp87c8ud
         wFcCEanfV8SZPCGAoRTL0y2wbTuR90hy+MET1jDhTFWPOsroNKHPv2t0mMrVBhqbiiTQ
         QZB803xhEGdjZyypl+NM/fZtYHAj04tpKAQbYDyOvcdPxTlWUbtPktCjcKuDITqzMSJ2
         A9DO8g6XhI++OyDLRTd3byK2v9mEieOrX0Ppg52sRUi7Dyr+8V7KS4Cr/yUrzowMRcMe
         Wfqg==
X-Forwarded-Encrypted: i=1; AL+hErEXoVV1CPvGT+A2/ILbVz8IUJWOwzYl1LYBmnRjcdOFuQOB2/N4DnjDLcSG2ye+GmRhKb0pPdQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z/Cua8mZkSmzEBK1jf0U19ECoLW04lQ3zwakOUO2Ofi3fJyeJrf
	4t2pgLJhHJD5SquUh45ABs4riK4VAmobT5IgW9Fjg2UZdcVsHvTgkAg3bxjd1DQOk0M1EVG8r9Q
	7RaGqz+SLhlau/OMTBfAGlA==
X-Received: from wmbeb10.prod.google.com ([2002:a05:600c:678a:b0:4a2:826:6d11])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d97:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-4bb78372629mr78331265e9.2.1794937466306;
 Tue, 17 Nov 2026 09:44:26 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:48 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-10-vdonnefort@google.com>
Subject: [PATCH v4 09/23] KVM: arm64: Add a range to hyp_poison_page()
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
index ed82cbe973ad..f2a9af6bda77 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1299,11 +1299,9 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
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
@@ -1311,8 +1309,12 @@ static void hyp_poison_page(phys_addr_t phys)
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
@@ -1384,7 +1386,7 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	if (ret)
 		goto unlock_guest;
 
-	hyp_poison_page(phys);
+	hyp_poison_range(phys, PAGE_SIZE);
 	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
 unlock_guest:
 	guest_unlock_component(vm);
@@ -1412,7 +1414,7 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 	switch (guest_get_page_state(pte, ipa)) {
 	case PKVM_PAGE_OWNED:
 		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE));
-		hyp_poison_page(phys);
+		hyp_poison_range(phys, PAGE_SIZE);
 		break;
 	case PKVM_PAGE_SHARED_OWNED:
 		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
-- 
2.56.1.708.g77570a6a1d-goog

