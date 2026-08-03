Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FBA375AC6
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751879; cv=none; b=M/y3X8n/1JMyhGMzB14v7nAtxHwfGvCNEpPXLGLyn3abXZ3tV/Fo0mY/a0aZOSTA5b/KWuPeGwzqLlpJ87oyJy/qZeEtR6LF2f3bROLs5MgeHsMCR/qaB6DoYwntPLOzfseE14JQQW6fHPhYzd7YU4ay3Oy45L4Lkh1btBjlqlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751879; c=relaxed/simple;
	bh=23tyqAubVRrwgln6FGmFP/ejgQJWkB1L7yoxX4VR3UA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EygTJuv3Aw8TVzNNR09ZIUePsExKtuhAyR2Dcs2yf4sj3f/wVqA+ezxuMLoQCwyenOZsYJop1lR/ZoDAkOoPiXsPe1BiXEcnQGynDoROR++hFmSWdAbPq/YbrMnmM+w4nCVh48Fo/B4vMMgAU24sYZ6qbsp/UGmUqoV9WlGgx4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hLpOKBri; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hLpOKBri"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49554715277so17971755e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751876; x=1786356676; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=loeGi3dRMOkXqttIetgmg8f0p0nt/Zk8xK82xYk1AUg=;
        b=hLpOKBri3Te737NLIKsXXA8hydWKIOmNRiSsKje8H1TGMtpCzaMdOg2HcAmTXaW6DV
         JHpbnCNa8gzSRrraltvP94LUn/Ez8NckO08SEmCOinxL+iT6qpVkjm1179/8TImbHYjt
         45373ekfHVGGKqchS1sNhxvRy6AMNUynBZMrVRxNo2EyTMMrkH+nggHsabxRl6IJCCgs
         fBjb2Fpqp4X+vzCyX/PPqLgOoShdkqPJ59QZ4r3V2jcdM0SrD9mSMemYm8ap9W/i2bAC
         VdahVethkCNQFjtb+woJ2/MqTNgK95Grc7YBVM5xmREhCwtvB188ctVlmOvmmliMzSND
         sGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751876; x=1786356676;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=loeGi3dRMOkXqttIetgmg8f0p0nt/Zk8xK82xYk1AUg=;
        b=f1XuOswTpNKIkmto/iiv9qIOO5/XJ6dxlj41fnhBla5GD07ktCK7XvYo9zk8+iyjDz
         jHd5CahRqib5PqVulg9ziGU9uQ0jS2XSQ25h65a0km6WcP0UCt9nxvc/esEN8r1apPMv
         sJ/Rx+Eb7Db/wqVtlpuYbroAEN6VYeDgnGDpOie6SyYHRoINViltap3OTMxA8j0D4+Kx
         laRX1wHBak5RrcsXq5NzyTN4Voo3O/VecQN8iVbD21IzIJuRnvZo/3RdMDZoOhYaDWD0
         Pv1fIjtY6IPfd5kqIIsIcYXE52MRq+WpxdJVXwelKiJ3e/YP1/fg2TDgZjLfmFECKze+
         BQMA==
X-Forwarded-Encrypted: i=1; AHgh+RqDl+3g9ovaPpyyLqrS49NNBSnpVRjOHIwAgr+NaKAyRcJniIcSIDob5WFpvPb4xOStsKwnqOM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPy3jFLKbZC0VjpNischnwgmfrWEn4YhYuW7ccoanmDc71oXfz
	wjLWhBQhQbFnQFW+jKnAS8F21Vt4dT45JA0ZspOQ4PiX31qoR2rOejcT1pW5blnhbYEb228Z3sS
	dMSQkOlpGaXE/VeVCdXLnHw==
X-Received: from wmoy21.prod.google.com ([2002:a05:600c:17d5:b0:494:133:ddd3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c25:b0:499:48be:3189 with SMTP id 5b1f17b1804b1-49948be327bmr4977335e9.0.1785751875217;
 Mon, 03 Aug 2026 03:11:15 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:09:01 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-18-vdonnefort@google.com>
Subject: [PATCH 17/20] KVM: arm64: Extend pKVM page ownership selftests to
 cover guest block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend the pKVM page ownership selftests to test the split of a guest
stage-2 block and the per-page reclaim of that same block.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 71ebd1856cb0..e22a7991f8ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -2070,6 +2070,38 @@ int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
 
+	if (size == PMD_SIZE) {
+		/* [gfn, gfn + nr_pages) was poisoned. Skip it */
+		gfn += nr_pages;
+
+		selftest_state.host = PKVM_NOPAGE;
+		selftest_state.guest[1] = PKVM_PAGE_OWNED;
+		assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+		assert_transition_res(0,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+
+		assert_transition_res(-E2BIG, __pkvm_host_split_guest, gfn, nr_pages, vcpu);
+		assert_transition_res(-E2BIG, __pkvm_host_reclaim_page_guest, gfn, nr_pages, vm);
+
+		for (int i = 0; i < nr_pages; i++)
+			WARN_ON(__pkvm_host_reclaim_page_guest(gfn + i, 1, vm));
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
2.55.0.508.g3f0d502094-goog

