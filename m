Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF77F46D547
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134691; cv=none; b=fTmsbPCzTMBuNAQq9UWjTq8HpwhARViYhfynpOJUBi3EaMzE04QHOUkxWSELuVZqQyVo+YnSmQfTeiCbWf1UAzdDpWnKJhi0e0Q2yM0LlknJa0tPnWkEuWe+9xKqW31qv2x9PHUZ22ELbhoF5WIvDp86nNVo1e5tjOLKmrOggtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134691; c=relaxed/simple;
	bh=8SY/hcDDyVKPPg/pEAr0s+JVGzy96kiCQipQkN4HaAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r/wi43WvlPDyXi5K08e4LrhvWSJ5Q3OHKhgHA5LQbsW9WwoaKBNn7yVkbBe5Yc6s9ZjtbM3RwU6w/vVyEzSbVKx4qbsh/HByegFnHi/6DLX5XZEMilVW4KZc+THmtObxnWBrWo/sM9IERl69FGVDjrvUxslWkSixmn9lnKAr2tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ar3uHJ8c; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ar3uHJ8c"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c295b027ee0so90182866b.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134685; x=1789739485; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q5DlL13uHjVP1z/ikzLAHoUvg+H32tBZp8pjB8Voqxw=;
        b=Ar3uHJ8c4h8HagHFU1mRuF0SeZemOiiJILb//sVeYfv8CDNe5J/ePzkUnvKLyOXK7m
         MyjFuWTCsJA3X6SdDXzMegiCLwi2catUAI2JY605SwZ50tcCc/pOSbBHRNyJeNcnLUAW
         3wBA3WYxr1jAfXmsB+U3qURB+u08Qj7/sTiHQ5xiUKpSDuzxLCCnQc6gvlKoYyd5G2lV
         aS5uxThK3vXCOSyfhPccwCaKsWGcAfrptj7/PZUOV8zsdoqSft5KtYxA7Dzc1Zb7s0vv
         bPSxiRUX7u3mTU9ozGxfpwcolSt70SaQyQavzXej4yxW9yByzhWCfbOfr27yJhkicyaY
         Pz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134685; x=1789739485;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q5DlL13uHjVP1z/ikzLAHoUvg+H32tBZp8pjB8Voqxw=;
        b=dwACB24uGCgGGadWIqmgiL9c3SwRpbmLres5ygI03jC5U2ZGG36QOlm1UDhuFFux8a
         rxi2obAidQvShz58iSkgCu0/pqCIwfEcKl064r0O+wrNb7JPJmTWo601NNLDJoC9EItE
         byrgEoIwFN2p64D/VRwqpGFLq3TIvtfNQRQbnUpvrKhdquy47NztooasfykVobVYGIfX
         51NO61QvGpXnnHl1veniocKJZeVTypBH4cqRMWY1ijPJmelwxjFGMKYRUxlLlgLTdXLq
         asOAnFdJ2RMipja3lvTIzfMwHcVHnaAT9VpFd4tJGmYjDoCHpw9Dy+BT6HGfhwPCmN0H
         KeNA==
X-Forwarded-Encrypted: i=1; AKwUvBw0ugf/5Lf4/TGUwjZe2ulDXnJMGU1rIF+khJaV+sotegIiy/n9X4vS9J6dALO0ZzVNyEPUDEc=@lists.linux.dev
X-Gm-Message-State: AFuF++kNvvzWcovqeWLZJgmZsDw3KHIaB+MXhA3030bT0fRDhZNinocW
	ZHZ3y1UutSTd/ozWf2qTe+4tqG4RCP2jFqSetR6MQ7Xoy17tpPAWx+sWsp392wpGwv4UBgG+rBF
	kEENR0bDA7YckDFLLiBGppw==
X-Received: from ejcey24.prod.google.com ([2002:a17:907:b98:b0:c1c:477d:16e8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c1a:b0:c15:e8c8:340 with SMTP id a640c23a62f3a-c296674a92cmr384345366b.23.1789134684966;
 Fri, 11 Sep 2026 06:51:24 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:50 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-20-vdonnefort@google.com>
Subject: [PATCH v2 19/22] KVM: arm64: Extend pKVM page ownership selftests to
 cover guest block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend the pKVM page ownership selftests to test the split of a guest
stage-2 block and the per-page reclaim of that same block.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 41 +++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f4943c2a237f..e318b5a3f600 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -2105,6 +2105,47 @@ int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
 
+	if (size == PMD_SIZE) {
+		/* [gfn, gfn + nr_pages) was poisoned. Skip it */
+		gfn += nr_pages;
+
+		selftest_state.host = PKVM_NOPAGE;
+		selftest_state.guest[1] = PKVM_PAGE_OWNED;
+		assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+		assert_transition_res(-E2BIG,	__pkvm_host_reclaim_guest, gfn, 1, vm);
+		assert_transition_res(-E2BIG,	__pkvm_guest_share_host, vcpu, gfn, 1);
+		assert_transition_res(0,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+
+		assert_transition_res(-E2BIG,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+		assert_transition_res(-E2BIG,	__pkvm_host_reclaim_guest, gfn, nr_pages, vm);
+		assert_transition_res(-E2BIG,	__pkvm_guest_share_host, vcpu, gfn, nr_pages);
+
+		for (int i = 0; i < nr_pages; i++) {
+			WARN_ON(__pkvm_guest_share_host(vcpu, gfn + i, 1));
+			WARN_ON(__pkvm_guest_unshare_host(vcpu, gfn + i, 1));
+		}
+		assert_page_state();
+
+		for (int i = 0; i < nr_pages; i++)
+			WARN_ON(__pkvm_host_reclaim_guest(gfn + i, 1, vm));
+
+		selftest_state.host = PKVM_PAGE_OWNED;
+		selftest_state.guest[1] = PKVM_NOPAGE;
+		assert_page_state();
+
+		selftest_state.host = PKVM_NOPAGE;
+		selftest_state.guest[1] = PKVM_PAGE_OWNED;
+		assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+		assert_transition_res(0,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+
+		for (int i = 0; i < nr_pages; i++)
+			WARN_ON(__pkvm_host_force_reclaim_page_guest(phys + i * PAGE_SIZE));
+
+		selftest_state.host = PKVM_PAGE_OWNED;
+		selftest_state.guest[1] = PKVM_POISON;
+		assert_page_state();
+	}
+
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, nr_pages);
-- 
2.55.0.1007.g17ff1f9808-goog

