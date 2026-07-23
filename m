Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9D547A861
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823625; cv=none; b=B2WZMuClaw6lZ2xa56jLj762AFtDJWeqmBDZyBoQz9WIlDYPmViA0qhSb82CXNzPWdqv/P5gX6ssp0FsKqAQf3I4xXsjjVB8sBd3/PRnZof5IFglb64lrIRblKMToWtN7UseQaguZj43pOm8/OO5JQ9NF7FOhjdI0FyCcAn623Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823625; c=relaxed/simple;
	bh=wjwRwP+aVnxjJIJeqwg1P5oX2bJlhP2+1TFOJTHitgs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=vEUgatmiRjbLY4m0PaOp4Ga8790ntEL89BcLfS93PsgIV5qYaw5K4WyHCSTla4lBEAU5YjBgHiUVCZkVgqTT42VRM86HjIIAXt6mJKTdKhkW0nS7lXgsegvbn+US56f6rRPPb/Dbs/3V/7S9+/wlrzvaju51Ejv+3xWLu4v1Unk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HgPN2BS8; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HgPN2BS8"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f753a0aa0so476198f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 09:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784823613; x=1785428413; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8fLZBrc7U0OaH9gD4/eAb175qJMFqjKMfWGNNQ6QKQA=;
        b=HgPN2BS8l20ht4PfBGzSNOc0sXSoU1lJDBQM91BsAa/ncnwUAA3jYrxfIkMCB6shiT
         NrWs7QRf01WapZDFB2Wkyd9BvQt42Ei8dn3NFV5k4Pl4NWrRDaS6Yh6OGuItEDFiaOqc
         uutyFko8Yix0wRmaXStf/S4xVCvdnmRi3Fk/vDiNiG/LUWxKOqPXzgiiRMkiJTee+maQ
         Uu5qEzxdTZdFBw7mfab2NTlg/zgrnryXzUXzTFHc3IC4Nf85V1bxdKeRLCvJCKSNmW54
         sztUtOQBGtbj7FU1CMBFdl7sJwRNVOoAxKd64qUp8EH853ShSXIs8Wm63ckIw5O+i4ub
         zCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784823613; x=1785428413;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8fLZBrc7U0OaH9gD4/eAb175qJMFqjKMfWGNNQ6QKQA=;
        b=N5vPxquLwEAtBpJmlPqz6neUHoEioj7E48XfABEpr9Q3q6hIGXeZzpJRBUQBni0MTK
         vyDE5xTbvDCj2q4+V85mAcM94On3ym5b2nsBbFwjv4idIxNCNDjEtXEnh3GLfdeYeXcU
         r2YPSKKeu48x1tAejJHZ91ce/K2saPljXy+JdVSs907Cx1ENAcwERtRxUZbAxK9NbOQv
         kKozFlK4gcKty3YpjBhZtQ9CpIzZZliDZjtwL99JhJlLA0YETEF3fMRIoMm44Dd9MsXV
         d8SqDGVkjijHQSu27fjq94UnZZtqn0eBJ/VUdS2T8F1b40SjtDNq08nMIix6uD5tESyd
         TrRA==
X-Forwarded-Encrypted: i=1; AHgh+RqIGCI6sTfqPL0BMNUBlrUS5jhN2WOJNlSevtQR2P1KTO5Or8b/lWac+K4HsQ11iPW4slYt0N0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5f1NvNCq1muHY7pDh3gBXugoz7gcrkz3zwPiUgZ1k89ukt4RJ
	gs8JEebec86NTFjjU4uOWbhGAIsnfjSg9r0qIWYt4L3jMbwo+idRjjI1dJdSfOs8cujQybcj0L0
	P5x7hkAhV5VLbJw==
X-Received: from wmnq10.prod.google.com ([2002:a05:600c:2eca:b0:495:5b4a:53f1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4685:b0:495:63e4:3a91 with SMTP id 5b1f17b1804b1-49573d132f3mr42321645e9.35.1784823612359;
 Thu, 23 Jul 2026 09:20:12 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:20:02 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723162002.3848054-1-smostafa@google.com>
Subject: [PATCH v3] KVM: arm64: Optimize protected mode with FWB and DIC
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM opportunistically enables FWB if supported by the system for guest
VMs, which allows it to elude cache maintenance for data as they are
forced to be cacheable from stage-2.
In that case, __clean_dcache_guest_page() will immediately return.
However in protected mode, before calling __clean_dcache_guest_page()
it loops over the range and fix_map/unmap it, issuing TLB
invalidations, dsb() and isb() unnecessarily.

This can be optimized by returning early if FWB is supported,
kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
functions issue dsb() for the unmap path.

Similarly for DIC, we can omit the call in
invalidate_icache_guest_page()

No isb() needed as ERET is context synchronization event.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4e329e39a695..39aa8911f62c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -261,11 +261,18 @@ static void __apply_guest_page(void *va, size_t size,
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
+	/* See comment in __clean_dcache_guest_page() */
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
 	__apply_guest_page(va, size, __clean_dcache_guest_page);
 }
 
 static void invalidate_icache_guest_page(void *va, size_t size)
 {
+	if (alternative_has_cap_unlikely(ARM64_HAS_CACHE_DIC))
+		return;
+
 	__apply_guest_page(va, size, __invalidate_icache_guest_page);
 }
 
-- 
2.55.0.229.g6434b31f56-goog

