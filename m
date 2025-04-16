Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C3B209F27
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817229; cv=none; b=XdTdZXtDPFRNmnIj15nEv4voAq1Ep1cHOssjN7GYUEYwp2ArWES7h/Lb58tpyPXG9r67n3DMfUv0h/A6/ao3pLEiIl6KuRdNQW5JJPDZCwWNAGsj5YwYXD6n7ZHo4baCVt2nXe4z7vbl5lmNVPQgRQ30gagcG/9H8/dEnqGn7bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817229; c=relaxed/simple;
	bh=mlPlfdc/NWwYqy2zjYwAzNRWIZhZ7ZZR38Y6Ldz2Cr0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O9OiNV16EKeWAyEwM+xAW2KORY4wPqpWmdDt+4prw8PTEPewzlK5ig82l/9ROQso7fgRzzCJVVLaY7dzDSEuX1AQjVrcghFFpMFvLTOMJ8yx5rx9L13roaVEF2KgdrM3N7V3FU2w5mDeGuYwfNdyNOd7hkrDxURJUwaaCVluyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F/gLYuX1; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F/gLYuX1"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ab68fbe53a4so90929366b.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817224; x=1745422024; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VYU32RrZwSVxBTFJfFZ/zcmulUROASDhu21QhFFvtpI=;
        b=F/gLYuX1Vz19luT/SSywVijNcErFnUCJDH/GScUp654of3bNjSQBHn3h9uC034aCtX
         eh72Xoprcqo+WDFDtmi5F//eMeRpb3S29puVWK5daS16huTWC9INYw0Lc7rlmxTsK3xK
         HdbmejO9zmBExfF/vHHaUr4Vc3GsiFOEKeq/IRqSWhNV8FfeoGoESv7rN32YvmZlvVZl
         DcGlFjqrosIlEfjLpDk3NNiz/tF0Htzrrb6DKR85mbnl5Dw0sKe1LxUbLKCrji+X3yEz
         qKpHEqLIzR5OTizfl+qHRseOkxHsrPVUIpKBu/kQzouVM8XEQwWSbLkFLPfevjcaM+MW
         enXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817224; x=1745422024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VYU32RrZwSVxBTFJfFZ/zcmulUROASDhu21QhFFvtpI=;
        b=Uk7N+ALJGqP6FzJpk4THggfTQgonSGxIkCN1AyqtKiFK1BX5Ziyn54yAy+LqH19VzP
         zdpbFO1cnv7FEPfAUelYOIDDrxg9+nZljBUYKkmVZ8+xr/hjM/NPMzQFk+mOM0hLfKUE
         Q/SlRBayIbgScbC5Nb0iBNDIZIJUGTTycjRDZ30DYWZm7v8xXvvBoMQ1kFyMLA5wINop
         jscl88xA9ugYfQRQeN3UllR3GX2Dc1vyCt9dJbzO0VjDdBIgDy+IwZZVXMxaZNgRURWW
         JH4pqZ1f4iaj3KTYiQMnkksRmEPDduX5iuhspuHlLE9UNUfFUBRifUlKHGRrMPo29eB2
         QrdA==
X-Forwarded-Encrypted: i=1; AJvYcCWMwANtbcIHmcsWbiLZnDB5WvKB0/e9OFsI6YN1iU5BH767ArlIMBJfI1PUnjq+TGEAt0eokbI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzY6M1yM1+QtImAdLVDTRTk/cIQN36ZC1OrO9DNm0vPnlDUO4ja
	1ztkZYfunIahVOUGsw0DqHC1vkDAEazi0Mk1vRHrnK3NkEZY87XqtMUvF0S5dioldXtAfkFBFXp
	IpfFwpA==
X-Google-Smtp-Source: AGHT+IFx/wZB15eiIdBs2Eh1Wi5DlZDuOgycITN7QmUrR/0Pho2JFdCK7PrHfR8mLm6W9F5WKdLs/Vk8CDxe
X-Received: from edyc19.prod.google.com ([2002:aa7:df13:0:b0:5ec:dada:a73e])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:478a:b0:ac7:cfe0:3014
 with SMTP id a640c23a62f3a-acb4296492fmr220940266b.25.1744817224502; Wed, 16
 Apr 2025 08:27:04 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:46 +0000
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416152648.2982950-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-7-qperret@google.com>
Subject: [PATCH v2 6/7] KVM: arm64: Defer EL2 stage-1 mapping on share
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We currently blindly map into EL2 stage-1 *any* page passed to the
__pkvm_host_share_hyp() HVC. This is less than ideal from a security
perspective as it makes exploitation of potential hypervisor gadgets
easier than it should be. But interestingly, pKVM should never need to
access SHARED_BORROWED pages that it hasn't previously pinned, so there
is no need to map the page before that.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 25ff84c053c1..91b757e3fb4c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -693,7 +693,6 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	void *virt = __hyp_va(phys);
 	u64 size = PAGE_SIZE;
 	int ret;
 
@@ -710,7 +709,6 @@ int __pkvm_host_share_hyp(u64 pfn)
 	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
-	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
 
 unlock:
@@ -742,7 +740,6 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
-	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
 
 unlock:
@@ -818,6 +815,7 @@ int hyp_pin_shared_mem(void *from, void *to)
 	u64 end = PAGE_ALIGN((u64)to);
 	u64 phys = __hyp_pa(start);
 	u64 size = end - start;
+	struct hyp_page *p;
 	int ret;
 
 	host_lock_component();
@@ -831,8 +829,14 @@ int hyp_pin_shared_mem(void *from, void *to)
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
@@ -845,12 +849,17 @@ void hyp_unpin_shared_mem(void *from, void *to)
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
2.49.0.604.gff1f9ca942-goog

