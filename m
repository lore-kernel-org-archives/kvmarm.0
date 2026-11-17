Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937480;
	b=OaFNAmLwUsFYCnAChoLhPqb8KFb/VCh6sqxKmvpMGWJbpSXlFdFev9UGIjgMa5ohjOgz
	 8V7AFVjX43Je9pIuFhevFZnYinxLYxXeGwFpU5yLbgU+zf+f6tv4hkXzGCE3o6IZcD4Wz
	 88Jhw+CtiIOpS7TagNrXUYTEO8rjbG8O1lBY+xOHdc1KjGB/xDndOLefVyOy4wVwgmCQn
	 M1sD/pI93x8AymD+7slcKKuv+80xchdj0HrjqKDB1olRZpSopuVFXJG36W7W/48w3iZz1
	 JEEAyL6fT/NZW+ulPQA03juzYbE49NSQDM7s3UAKYYI8fmIHSlKAgbhRk0CjKSxsCCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JO9s6pbhLt9HaIOtsyrhB78uzZkMKh5talCGkStqaQ0=;
	b=vrk+KR+A7Lc2ZqB2xTHb7lQ7O6RqcHiuhEBh7fFyVZnZpO0U/7/ZniLT0Btb4FQYnNrv
	 un1OMAwpD+ZRRRC7y86L9x8qUrE9QgxOlznf+XWHKsx5KDhltl2VE2WrNw2dC4Pxm4OdK
	 1t0sn4Eu4680W29I77FzQwXK+5goizFW9jCZ4q4MLcxz5AUvi0II5v4LXO4mXTzOsUAAx
	 4cOOcGET0yVMNxjwhrqF5XlSaR8Bw0KASYl/0LurBdp1/Sn/NKBSwm1UJWZZ4r4PYc2xu
	 PxSF9HNebOuwGA/Z+k82qmfjiWTrv/zwrzeghicfm5In0XNCsNg9swDzvF76DjAtr8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EOd7Jauo;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FC0606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86FC0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EOd7Jauo
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c505eecba6cso316791066b.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937479; x=1795542279; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JO9s6pbhLt9HaIOtsyrhB78uzZkMKh5talCGkStqaQ0=;
        b=EOd7Jauok5qvhl3UDFsl66O1R8+BoJqMu3qY+LOczrAE6Gmei99GCuEwVi7ElLGUqw
         FneYw4b7JjrCXXYXyma4Wds3Pbh5hkaowr6ajWunthSa18rwUSg3DsAt1o/CN3rykQRG
         oz8kiptqoOQciIa/N+eumFF5k/YhspIUR5bbuX5ze/xzin38GcXCgC4RXBPQiXLikNOD
         h+tVca/O/PFT8KwZGWvV1d/zXJchroalaqBWu9BJxQNvco3BiPu6QOGpNvzT9YNjYUVG
         4S5uI0xGU7HBTZA/V/AgxoOYcsyIc6IvK9AlRvu5le/DLDz4B2JmM++a+KVx5Kmsp5sk
         v3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937479; x=1795542279;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JO9s6pbhLt9HaIOtsyrhB78uzZkMKh5talCGkStqaQ0=;
        b=sdXDEWA45aqlXzdkAT6my0WtT+Pg90YOiLUXSyWlrC9W/Hskxp+Uex+Ajh08KAjRQR
         vQbQOseAwd3HJp57HAzQ/sfVTvWYHeY39u0EQWmUU+qJ8JaOIPlYu4REUZcEzYS7eNwF
         pXp2hU7WnyGJmpkRU/lRBaM9ncR70AmMCy7SroyMk4Jv+law0dYqhaVcwmTTMr2mxT/w
         fe7UtheHMW1s2fIX0fYitzSovLUHXjG4cGDFImB0TkQftxxxb3nV9+kMjYYfHsO7H/74
         WLENBcaxQU76CYUfIL7oO5tDyfxs2TZM9U+d9wjqVz1ZOGIXV4ZaDplGLnPMPq1DeNNA
         wHhg==
X-Forwarded-Encrypted: i=1; AL+hErHWbrIwXFd7da9NjVlTpmPPZvELumZi+l+F/Yb546MGroZ+myt1HfCwcHQU3Tu5RKPZ9dX953Q=@lists.linux.dev
X-Gm-Message-State: APuU4Z+5hhxjBRrI+R4hGxrVt7b+Yoeb8oJsb28z48UxhVzLMVq2I6da
	M8tSDwzBr68lC9rTXAYGlJdZePJ20B0Y0gZfTXRAgMty51tkuVGWJF+TQ1lUSAQBOvxCJxO9RYf
	Pa/iakOmqUNbsf5QCsq3NtQ==
X-Received: from ejblh4.prod.google.com ([2002:a17:906:f8c4:b0:c50:51f0:a2ab])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94d3:b0:c2e:6a4f:a88b with SMTP id a640c23a62f3a-c510dc7e08bmr8772666b.0.1794937478719;
 Tue, 17 Nov 2026 09:44:38 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:59 +0000
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
Message-ID: <20261117174403.58762-21-vdonnefort@google.com>
Subject: [PATCH v4 20/23] KVM: arm64: Extend pKVM page ownership selftests to
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
index e264cfd41e0c..28fc89725666 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -2128,6 +2128,47 @@ int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
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
2.56.1.708.g77570a6a1d-goog

