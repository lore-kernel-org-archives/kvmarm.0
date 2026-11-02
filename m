Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652433;
	b=QrBKCXhrNIZQQA8gLk9UgVQjZktGszN12bo+DEir7ZT9KpqgbieMLUeh/9CjhfOCXJeJ
	 Qw/XAZcKAxbQCXy/PYl6tm6eNrd7CEIIVgJBrh6CfWFdZjMkwRIMIEALpzruq547o+BEF
	 bJrAIDbZ/RWyrJWqnnDLCVOSr1JX98A85wPqlRY+uyVfp4Aj7c1jsHbXxcnIPbEPEiQUt
	 MU9IZYnsMswj2rxQdcgIknwvcbuxA8zjK/mKCZRSd6IcI0pNv4sp9+YHz2GPBRpblL2mE
	 mlvYI6Pq7skQ3sQS3wUkhlknhpm9BfGOqhJYZvpv3LxSxPZNflKi6F4petzUJ45hAGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Z1KV9h17lcmSCanvum5IrLFJmwB9lWwA5/Uy28XQqAE=;
	b=WExJerWaSUT1xv45hYs6AfiittYqkrAKMNYY/vcmeLlWkWWRruKWHayNQnIKEBF8Asjl
	 +R0C1hZ2aIlPqiduWizSL1/nj4WIhDXqXsDglf+IMF3NQhLlBjj5ewi3SAymBH5MoYI4k
	 yPPbGH2feeYBss7YjMyVYknWYgzFl5R+J4HTrmWMCUqzg7A1X4MuTJkKLV7EUYjt71R8Z
	 PXiimtu7xSAJ6iuQzjO5zBABPqyvLVafldeO8MqGFwLexskFyCPrS6CapZDN43sWAJ2pd
	 JUmZiCkGIr9KEgAnEbGS+LhtApoXwsSGKcADnO01aSyZcegu8tpqATuio3w2r1hIQbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qTUWb4eK;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F13606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3F13606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qTUWb4eK
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49febef74e3so342525e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652431; x=1794257231; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z1KV9h17lcmSCanvum5IrLFJmwB9lWwA5/Uy28XQqAE=;
        b=qTUWb4eKQgZWr68284Lk5zDSabmI5w8kUFOhRnEJZA/yMGIAin0NLF8A3Q6FNwoY5u
         J8Cp9nbW33dVe5CdFuo7MPUEKjTlvKMitN+wszz+5Ie2sov/zYiFusWB+LOL3cG5Jque
         uRFFe5Nx2uqZftZy0l5Z438Fkey4rbTgcEIOv4Za6qBChb8nXO5zIDTOSZ4w4EBrDgsz
         vNZVGAd0y2ru6sC6uZsSofumXBV2wycAMycW5FPQ88O6WTPThOLsvbHheLxLQg1h7fiE
         JGvUdaxWUc4e9xMjC+UCxskId3IHb7qgw4qIg+vQVEigl4i4lz0M8sTlaHSPA3PVZtk0
         GQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652431; x=1794257231;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z1KV9h17lcmSCanvum5IrLFJmwB9lWwA5/Uy28XQqAE=;
        b=Ij5FehQe3J0Bxs4zE1RcwLO7dO4wcIkbrlCIrmahy0Y2cpv4i4IAN7bBH+ETgue4mp
         nfPOWHyPkFpvuJA8GmsmdlR0VMIDCHSovylpUL5BLf1bd5NVxLmy5dz6Ni7QfXvs37S4
         ENh0zGbBOMdFb27T3oG0uXAUpEp2aqx2+dhSE4m2YswBLZ6jM8fqiCnnXRZgmC3TydhE
         OhoEUcWBaN4Pl8xwSPtftipvkycO9rEHzSRaPFOm3IL1xdOebaLDjDu0HVS7ArcWWuUi
         n8SjPdcBeu9AdbX4mpeGXaagoNG+HSHYL7Nqso6yo8Or9nRkQXaXM67kEVzc0nlPeh6q
         JrhA==
X-Forwarded-Encrypted: i=1; AKwUvBy2WZDhM1HVhKXTX9WzH1sATh17q223EPcW4T3GLIOoVlsYl8erXApCB4+iIfz9cvC7EwBedGw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKKzW1nuU+ArCh97Pr0hTCvDB9OqG0ivOrtXkyPW3FsywnVVgfd
	UhOTI58RPCXSg8QOTC8L5GqMpKy7qONjwfmzAXcWU4EjOP8Pd14slY8EB9TxBGvSf+Cdoi5JSo3
	o2hso2mYnxZUcNRh7SjCOFw==
X-Received: from wmbgx21.prod.google.com ([2002:a05:600c:8595:b0:4a1:70b0:32e3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6285:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4ac180f07d1mr278917575e9.17.1793652430885;
 Mon, 02 Nov 2026 12:47:10 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:14 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-10-vdonnefort@google.com>
Subject: [PATCH v3 09/23] KVM: arm64: Add a range to hyp_poison_page()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
2.56.0.385.gac671c819a-goog

