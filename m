Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93B13EF645
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372219; cv=none; b=b0DYE+O0Hrvb1CP+fwvBJp46S/97Q5c/W+KfUALziGGN4LqGlR2jdabT2/HyygbXmYTQI0A24SI2R45n90SDx9+0D7yECBLLi2XqX3LKCmknyP/DdNRr37sXnyC6RbDdkpJILl3CmyAn0tuYzjz9SKq7OdpViyHFyZwEYQCOCDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372219; c=relaxed/simple;
	bh=7tTHLjAgEKGsBTyH0lVNois2KVPH84/6SrQTXYZUwfs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jBB/BM0H4zpNX5CcHGtQJ3Gn8fux2+zYt7wmofoIrpIkytt6CL3SNLj90WAWpXzml3ESr+gouJ0mcBjlT6/I/vYa+0zR9tD5DUBzE8WcY9I1STRuy2foEEaRrFEtZdOM0MhlilbHxKidpuLTT8oX6dupMmvfHlGB9I9d+ozZjGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aGB+DGsL; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aGB+DGsL"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4411a2c034fso6914707f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372215; x=1777977015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYUkAwnLJFRq1L2KWhPMCbl0fLNqeKRbzrqZSKodisQ=;
        b=aGB+DGsLgNejUJBnZ5chU5DbJ/s4hLGS/USNFFWDNRiWmhotlOa4YXpFmmDqID9/YE
         lpoyJxN2jORPFATkgGcSfTE3F7DPKv4lf4L2mTTyySukZGw6fhDNfIQjxF55aTaYGajN
         xZSIZoUKkJA4Jubm1l/dTgTYFyBFJ1V8sqhsUww/UIyqIpMPjVnmdNfEnLagGg8k87Vu
         muHYrTTyySO2vzjrAmYgJ1qdQM0dLVkdZfxb6ajDGtiOurKJ0ESSsOTcuNAp3eXFo1hQ
         fZ8rxPmTT4D2ZyrbjgsBbBoFP+FSNA+28z9qxr9AzljezHsvnYOvZqDx0YyqRECp+1DU
         n0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372215; x=1777977015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYUkAwnLJFRq1L2KWhPMCbl0fLNqeKRbzrqZSKodisQ=;
        b=o/VHeRL0WHOP5c2ibwJXlDTYuYMMl7UI93BGmpN3I8ZEGFngsnt6iZWuPNL2N7HJqn
         QOuID95ESV7lJrBMYauA8Qe15YB2VZzYgZr2pGMXm0Rda4SKer8zPXHxPERv/MwuZiVU
         Y5pGF2PaKzdNKV7/c9fhTct6Vh5I4qoercaFVFFqFaJ2zaYktGjfWHqi+pCgsU8TpOKQ
         tB8MnxHJHjTe+42CAveJxGl27JlBx+6ZZwudoBwyTGtFrpdyo3J4S242uvzlcWuz5fzn
         +Lk2vAWNA2MvbkYdGX886KF5pOQJlhXWO5Yt6uIxe4VHVwbXqIBDGog2IWgVGiyctW/J
         tDKA==
X-Forwarded-Encrypted: i=1; AFNElJ+P6OFFdCGp8XxKH5TR0yqttxjUyhJSarhRBWWv9+ORtinSCfkcGpa6Kph5fyoHfe5cKqUc+L8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzb0+LybzN7tSzkXW99+xATplPn85VEpAweHfFuvwt4fqihKSVZ
	Gf8RnkTgKeMt0q+x5ET9I/hL1Fiud51BSzh0XAIhjDMpXfYgGyh7sTKlSotePaW0N0vAiZeKZr8
	OZw==
X-Received: from wrou16.prod.google.com ([2002:adf:ed50:0:b0:445:adc5:751d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b15:b0:489:1f3e:5f6f
 with SMTP id 5b1f17b1804b1-48a77ae5502mr42869535e9.12.1777372215150; Tue, 28
 Apr 2026 03:30:15 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:05 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-6-tabba@google.com>
Subject: [PATCH 5/8] KVM: arm64: Propagate stage-2 map failure on host->guest share
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

__pkvm_host_share_guest() mutates the host vmemmap for every page in
the range (sets PKVM_PAGE_SHARED_OWNED and increments
host_share_guest_count) and then calls kvm_pgtable_stage2_map() to
install the guest stage-2 mapping. The stage-2 map's return value was
wrapped in WARN_ON() and otherwise discarded.

At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it expands
to a BRK that enters the invalid-host-el2 vector and branches to
hyp_panic(), declared __noreturn. WARN_ON of a reachable failure at
EL2 is a panic primitive, not a debug aid.

kvm_pgtable_stage2_map() can fail in reachable ways: the stage-2
walker requests fresh pages from the caller's memcache and returns
-ENOMEM when the memcache is exhausted mid-walk. The host controls
the vcpu memcache via the topup interface, so an under-provisioned
share request converts a recoverable error into a fatal hyp panic.

Capture the stage-2 map return value and propagate it. The walker
may have installed leaf entries for some pages in the IPA range
before failing, so unmap the range to clear any partial mappings;
otherwise the guest would retain stage-2 access to pages the host is
about to reclaim. Then roll back the host vmemmap mutations from the
forward pass: the forward pass increments the count by 1 on every
page, and the only forward state transition is OWNED -> SHARED_OWNED
(the count 0 -> 1 transition). The reverse pass decrements the count
and, if it drops back to zero, restores PKVM_PAGE_OWNED. Pages
already SHARED_OWNED with other sharers (count > 1 after the forward
pass) only need the count decremented.

Fixes: d0bd3e6570ae ("KVM: arm64: Introduce __pkvm_host_share_guest()")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 30 ++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 28a471d1927c..7044913a0758 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1458,9 +1458,33 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 		page->host_share_guest_count++;
 	}
 
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
-				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+	ret = kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
+				     pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
+				     &vcpu->vcpu.arch.pkvm_memcache, 0);
+	if (ret) {
+		/*
+		 * Stage-2 map can fail mid-walk (e.g. -ENOMEM from the
+		 * memcache), leaving partial leaf entries installed in the
+		 * guest stage-2. Tear them down before rolling back host
+		 * bookkeeping; otherwise the guest would retain access to
+		 * pages the host is about to reclaim as PKVM_PAGE_OWNED.
+		 */
+		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size);
+
+		/*
+		 * Roll back the host vmemmap mutations applied above. A page
+		 * whose host_share_guest_count is now 1 was PKVM_PAGE_OWNED
+		 * before this call (count 0->1, state OWNED->SHARED_OWNED);
+		 * undo both. A page with count > 1 was already
+		 * PKVM_PAGE_SHARED_OWNED with other sharers; only the count
+		 * needs to be decremented.
+		 */
+		for_each_hyp_page(page, phys, size) {
+			page->host_share_guest_count--;
+			if (!page->host_share_guest_count)
+				set_host_state(page, PKVM_PAGE_OWNED);
+		}
+	}
 
 unlock:
 	guest_unlock_component(vm);
-- 
2.54.0.545.g6539524ca2-goog

