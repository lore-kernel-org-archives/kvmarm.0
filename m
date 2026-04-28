Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21B13EFD24
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372221; cv=none; b=q5t0tppMFjKNXmKriU3Z2T/Tjbb2Byr6FmrAbQDvw2VFXQuVKUQJyON59GYmb4Hr9q+Uz1jwHfwsrwKeHpqQZk2hTt6+l1c66wfwhoUtqtzE/mUFBgoPj0V0FxJ5L3SNpizuYdYUVrHsGBXUWsY+ab1OCmA1zSY25yBxhTNkSUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372221; c=relaxed/simple;
	bh=W+xyFXpoTcAVO81+t0rS/9kkHRryS/Ehmc0XpyAYi18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tYuvS8karqT4TZ/T4Dt6ajx/Nbkxb/qmk35wbfO4kJbKmRWu7Mw/g/iECc4o92j6PV+7ARHjqAvj0wO2j3JuV84YdwpAq8nK2X/FVxrQEtY5VEozsRb93YbbP6pUKp7vVrGBRn7VhOVxLYTcCXaNCIaJx/rVIpuAoY66RLDZkbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rb3ba+r5; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rb3ba+r5"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-441243ba35fso6324788f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372217; x=1777977017; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WeB2s/TMGphof+D0QG47UlxNIiB+La++tp7fDFhGihQ=;
        b=Rb3ba+r5TSsx2zLkjHcviGqKr47vFrz9XaeYnw5vpVhfnySj5+9ruMFvkJBVjYHjw9
         UgURTnge9z59tjSSd4f2Q+Y4WTXrAwVIXvcdpFL/Ab9r2NobTxbDK37WbsnJz8qjGcVK
         0VwHN+vyEPKvVUKoHb/z+LQZS963uv16PAYIIB3XUn2aSeGmH+I/CIkZL27EL8W5tqEC
         fwQROJ/NUx9FNPn+iuk7mNvDKvZmQGCt2saKGHIrBve2yRqod/Qj1+St/mA7CpbXk7Uh
         x2GCOxuEl4zfqwtM8zAucFC4usfg+Df/s7/6vS1WB9KAWEn+lij0qn7ElUrb8QpR8TlQ
         AeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372217; x=1777977017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WeB2s/TMGphof+D0QG47UlxNIiB+La++tp7fDFhGihQ=;
        b=pj+u1FfuP8IWqrwZyUZe4AWte/bKm7k2gJV+VHxQaHMsYql4MXnPtVGhz9fF3oYse1
         jKgVu7BbO16ooBKGkCOYwk7/dtitmQd4fnxOEPEQlWkVA0dhG0SlYSYwZlE+XVBw+hjt
         eCNGiAFJRNrK/QZ1ch0zwINDC0EMTnXKx7wlmL0qvOjSbxzKDE/fon7EOICUoDa8L+0/
         jymX+FrLmVYZ2QYoSukNXM1wA1wFT8Vu6QU6nAkdW2JkzOtaG+bKasHrmbofD2JZPSE9
         Bi9h/jxPT0h3cEv6iuzezSxgLTvzd3xEaoTssBiET50lMrBEvysPYTMfU4jZoypMqvbv
         kjGw==
X-Forwarded-Encrypted: i=1; AFNElJ+aKgZaHMP4GnggOKwSjuceBueE7/EpiEWLv7fWE9cArPxLRQXeYY6VQyLLIX6PJmLDpLs4rU0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoNvxnEtEr/uts3SL5yr5kgLADx1EYP/xzGYrWtH/9HlNA24qo
	AQtpr1KITRdv1jFZHx6jJBb2AbxPMDWZHfbNIvia3OqAVZPtNs15dX5j5s93Bg9G3vdOTfA7Rw0
	phw==
X-Received: from wrdf9.prod.google.com ([2002:a5d:58e9:0:b0:43f:e626:ada7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1865:b0:43d:6e0:9458
 with SMTP id ffacd0b85a97d-4464aa09351mr4498102f8f.39.1777372217076; Tue, 28
 Apr 2026 03:30:17 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:07 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-8-tabba@google.com>
Subject: [PATCH 7/8] KVM: arm64: Propagate stage-2 map failure on guest->host share
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

__pkvm_guest_share_host() updates the guest stage-2 PTE for a
guest-OWNED page to PKVM_PAGE_SHARED_OWNED via
kvm_pgtable_stage2_map() and then transitions the host vmemmap and
stage-2 PTE to PKVM_PAGE_SHARED_BORROWED. The map's return value was
wrapped in WARN_ON() and otherwise discarded.

At EL2 in nVHE/pKVM, WARN_ON() is not warn-and-continue: it expands
to a BRK that enters the invalid-host-el2 vector and branches to
hyp_panic(), declared __noreturn.

__pkvm_guest_share_host() calls get_valid_guest_pte() before the
map, which verifies that a valid last-level (PAGE_SIZE) leaf PTE
already exists for the IPA. Because the leaf and all intermediate
tables are in place, the subsequent kvm_pgtable_stage2_map()
replacing it cannot fail via -ENOMEM: no block to split, no new
tables to install. The failure path is not currently reachable.

Nevertheless, WARN_ON() on any fallible call is the wrong pattern at
EL2: if the get_valid_guest_pte() precondition were ever relaxed, or
the walker gained a new failure mode, the WARN_ON would convert a
recoverable error into a fatal hyp panic. Capture the return value
and propagate it. The unmap() is kept as a defensive guard for the
currently unreachable failure path; no host-side unwinding is needed
since the host vmemmap and stage-2 update is the next step and is
correctly skipped on error.

Fixes: 03313efed5e2 ("KVM: arm64: Implement the MEM_SHARE hypercall for protected VMs")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index b8c57a95e9bf..6fb546af699f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -979,10 +979,23 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE))
 		goto unlock;
 
-	ret = 0;
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
-				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+	ret = kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+				     pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
+				     &vcpu->vcpu.arch.pkvm_memcache, 0);
+	if (ret) {
+		/*
+		 * Stage-2 map can fail mid-walk (e.g. -ENOMEM from the
+		 * memcache), leaving partial leaf entries in the guest
+		 * stage-2 transitioned to PKVM_PAGE_SHARED_OWNED. Tear
+		 * them down so the host does not see a partially-shared
+		 * mapping it has not yet acknowledged via the host
+		 * stage-2 update below. No host bookkeeping needs
+		 * unwinding here: the only mutation prior to the failed
+		 * map is the (now-discarded) guest stage-2 update itself.
+		 */
+		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
+		goto unlock;
+	}
 	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
 unlock:
 	guest_unlock_component(vm);
-- 
2.54.0.545.g6539524ca2-goog

