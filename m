Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFB77A13A
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 00:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616406; cv=none; b=GV0ZEFE3kABFAKBtlMHDL1SGoL/elJWKJ0jV0Ob0gRlYMJFxXEo8bfQZsZQd5gQNHJe6sbwyAwRf5sVKGHbfYG5zrFdS10WRX18OLg2hkeIGr7ZNHJhhp0a6vDRur36onfdBZUVvL5CAvB7MG0EHQVNM01zmVJTy3ED41PnZziI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616406; c=relaxed/simple;
	bh=ytI77feCh85Kuzlfp0vkiYSCReLiPQumaOtjnCZz+Lw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Eqq27rOOEVDyQfBlcte4eOy0p9FZKfXZnEmTO3LkXix3QIbiA9xt5i1zae39AGBEc1DjACsW/iGiswLo8mEzyxoVWVNWMt1PQ5szdHsMJ2bZsSbD90B3AmUUOSZVnfHlQy+1I7EsNy3MqR5Uz/mIm3kt66GLEtjhpCs/TWMBjEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bAV4r+QL; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bAV4r+QL"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e496b51f38so282190a12.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 16:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740616403; x=1741221203; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGmJYM3ZdXjed+VdIIVOBszfWrx1X1fG4+VBkIzQ0l4=;
        b=bAV4r+QLYDhD+W1e94nWxd5TffDVRyhMOU3anzIOgvc9UIevZEw0KStik1sc9EO3Y/
         3vGRrT804GaQOQjrwiUxfklDoKqgbaHYciAC5xh46M22R12Bn2790FrialZXOiiflY/o
         BX9kkbNShngZheRP/ugbYQo5BA0iDVG5qrFFDB+U3HvaH4D6XgOIA0QmkEjxN5W0gGSs
         r1vYB+44Z8wK7PCQ3OkSAxeebiKa8ma22Vce+b40bpGpxmdyh//bX7Z/D28SObWyLjm5
         wynyV9aRU3/lVbt3zsMndCSN6NFCJ6796A77ouumCiPkIGXgVTrdZhlmeiDPn6eJs8Li
         B7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740616403; x=1741221203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGmJYM3ZdXjed+VdIIVOBszfWrx1X1fG4+VBkIzQ0l4=;
        b=jaiCviaaYsFwj4SahyHQu4wVpT8THHrIrf3d+6YfCTYE1blV+HX4IlVYp8ccIl1LCV
         qnSzeem2lv2DExECQ3If5fOJFcEUTMQaHxaqpjNQQNTAOJsg42Wo8NFYep4/t1ZO8CQi
         Z8X43UIjSyj7vG+PdDWmIUF8h9Fc+9KT4LBxWeEmJ3l/oK8ZhFGKBhM1tH/hLBAz+HeG
         EuCW5v1b5KfbzwDLSuTrg089N21UGpTVPIZA18Jcycps+k32/SN9Fup2ahcdiuRCNpM4
         cckff2jJT+ctjl8xelOjoW9+vWk5T0lKndZpUO7FNT5RJ2eIe9vRRFRxGvaYHN2eiRE4
         27KQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgqIwobxWa3K/O308yTy7AAg1bj4NYHVThRCgfBw4tgPJ+DMyoyIzYn3uy2VXq6aFDZJfc4DY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwogY4EeafF6JsoFUl9xHZkDGNgx/KfLcyGA8LvTLzGVY97pmjU
	Y3Vz9N6cdNT0YJ8FXU6l4VLxgyOJjgEz5BswyfRjJ7RoipXLp4HFAW5D5XqmCjV2BY/TyApdMYG
	Frw2krg==
X-Google-Smtp-Source: AGHT+IG/8xxJ0edTLXImN+8foUCiY3IiLHVItOY++3PsS94AT277t67Spxy60uaWfxFei8RcZX4NGH7I/+gI
X-Received: from edbeo13.prod.google.com ([2002:a05:6402:530d:b0:5e4:befa:4847])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:280d:b0:5dc:7725:a0c7
 with SMTP id 4fb4d7f45d1cf-5e44448139dmr11904494a12.3.1740616403358; Wed, 26
 Feb 2025 16:33:23 -0800 (PST)
Date: Thu, 27 Feb 2025 00:33:09 +0000
In-Reply-To: <20250227003310.367350-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227003310.367350-1-qperret@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250227003310.367350-6-qperret@google.com>
Subject: [PATCH 5/6] KVM: arm64: Defer EL2 stage-1 mapping on share
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We currently blindly map into EL2 stage-1 *any* page passed to the
__pkvm_host_share_hyp() HVC. This is less than ideal from a security
perspective as it makes exploitation of potential hypervisor gadgets
easier than it should be. But interestingly, pKVM should never need to
access pages that it hasn't previously pinned, so there is no need to
map the page before that.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3ab8c81500c2..ae39d74be1f2 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -686,7 +686,6 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	void *virt = __hyp_va(phys);
 	u64 size = PAGE_SIZE;
 	int ret;
 
@@ -703,7 +702,6 @@ int __pkvm_host_share_hyp(u64 pfn)
 	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
-	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
 
 unlock:
@@ -735,7 +733,6 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
-	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
 
 unlock:
@@ -811,6 +808,7 @@ int hyp_pin_shared_mem(void *from, void *to)
 	u64 end = PAGE_ALIGN((u64)to);
 	u64 phys = __hyp_pa(start);
 	u64 size = end - start;
+	struct hyp_page *p;
 	int ret;
 
 	host_lock_component();
@@ -824,8 +822,14 @@ int hyp_pin_shared_mem(void *from, void *to)
 	if (ret)
 		goto unlock;
 
-	for (cur = start; cur < end; cur += PAGE_SIZE)
-		hyp_page_ref_inc(hyp_virt_to_page(cur));
+	for (cur = start; cur < end; cur += PAGE_SIZE) {
+		p = hyp_virt_to_page(cur);
+		hyp_page_ref_inc(p);
+		if (p->refcount == 1)
+			WARN_ON(pkvm_create_mappings_locked((void *)cur,
+							    (void *)cur + PAGE_SIZE,
+							    PAGE_HYP));
+	}
 
 unlock:
 	hyp_unlock_component();
@@ -838,12 +842,17 @@ void hyp_unpin_shared_mem(void *from, void *to)
 {
 	u64 cur, start = ALIGN_DOWN((u64)from, PAGE_SIZE);
 	u64 end = PAGE_ALIGN((u64)to);
+	struct hyp_page *p;
 
 	host_lock_component();
 	hyp_lock_component();
 
-	for (cur = start; cur < end; cur += PAGE_SIZE)
-		hyp_page_ref_dec(hyp_virt_to_page(cur));
+	for (cur = start; cur < end; cur += PAGE_SIZE) {
+		p = hyp_virt_to_page(cur);
+		if (p->refcount == 1)
+			WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, cur, PAGE_SIZE) != PAGE_SIZE);
+		hyp_page_ref_dec(p);
+	}
 
 	hyp_unlock_component();
 	host_unlock_component();
-- 
2.48.1.658.g4767266eb4-goog

