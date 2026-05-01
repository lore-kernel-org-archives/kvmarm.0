Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7F53A256E
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634521; cv=none; b=clNxqOKn2y7IRKK/CYRsRvd51irIWOXLcXZOATF+Y6GFsrPS3Ekr1YDJ6PsbyOPjWiHs9DUCf6N3do6JhU4wnjVdRYVg54Wng8rR+Fagf6k7yOAXiIVIvGHSmhADRwZN18hZq6qpS+SkVNDSr54TnNvVAu4kEOXPHtUKHegScP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634521; c=relaxed/simple;
	bh=WNOrRSdjW6v3MCflD6MesgXjVe7HTEIv6WOiAqLeuXs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IXii39858MoZ7lh6j/ctkf3Df30cV2KrfmQE9T/dlr/KRBqOHtno02Aj1NvPo5l7lb5voqA2YDvitnz7n6aiMTSD41qYNfiz/sMvnvWJE79guyFbZVGtlhXV2OY/nftG//iTp04AtZs8q+MznVv/pdmsh3UMJZ/ikgqH3fIhsuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y7ELY+mp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y7ELY+mp"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488c2aa6becso13798325e9.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634516; x=1778239316; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aYwcKF+O9BRV6I0nh/EUmrDeLL0Ut6fk04SddS0PCXg=;
        b=Y7ELY+mp0NMB7XA7IM582NenRiWLGjO07cbyANafCdN8zBp1BtwPQ9MBTzQ67zgre9
         aV4GiAAqEnpMdEi3vSzI8nIpFhp6g6WaU7RPFmJcoXkNK4dudlZqSjGclppH/iZ3E9mw
         CBIDKEHg3+jnubKIHqkfkR1XxY4W77dV1wt07mbfsZK7KsUA4FiEQT13Dxixubo2+vNG
         D1JIK8LATR79xWxrDGTiyLbQrbNdm/44jfVruF9+xbQOGJG2E2OT0Uj5bCxqq+YmZgLr
         LYUuqkPrhkT2hJmLJaUk82acIqMSwQUydlavqe/GY/TcSlxj0JC5nBQPGz7tzxoc0hG/
         tMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634516; x=1778239316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYwcKF+O9BRV6I0nh/EUmrDeLL0Ut6fk04SddS0PCXg=;
        b=TupCQIO/sGgu8gxHICYuysIN9uWDh3DF8c0JnerNM9G/+HqqP5QYd1XjDROfBrnJdz
         MKq+XSk653o5h04y6ZFJEkyN6nmcN62DBFj+028MQxwAbLFitShbdvDpbdKxudWayIq9
         rWzVYP+D2Z7qVOkoE0nEmMXKYBAg10+uYqhQZv7LB5tiDISYrqea1cliJDrdYpqCYhY9
         7O+8Oj68XY+/yYRlIi2vEs8z02qQ+ehvbbW9jeEZKNk6osm/j6YGU9Wv92OwsZvG5+L+
         odLMeM5p2/gXhfeeDnwH4boY1xdCWXGJnC+/hXPDQLqRaPtnQxcEDhPFCsOxT/5bgx6e
         RocQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Crmtn/zj4+BtCNQGz4n3RsNYB+o5VmjeYUDR0ez8ITTlqFa3DLxF6zFSw+3aRA+jkYIDl2V4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnt7EbQISCab/hb4oMosqflOA2xLuFDWQs4HHQjQDrGin3ibkw
	+cgh7GPMMqOSb6WTSsQWDMsmQE3dJUBP+z4hxL238FYS/1F2kEIG5pxVliq6rSi3d01dZdRbkL1
	hbg==
X-Received: from wmog7.prod.google.com ([2002:a05:600c:3107:b0:488:a71c:cf48])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4594:b0:48a:52f2:a0f1
 with SMTP id 5b1f17b1804b1-48a8444fac4mr110930795e9.18.1777634515632; Fri, 01
 May 2026 04:21:55 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:47 +0100
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-5-tabba@google.com>
Subject: [PATCH v2 4/6] KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The hypercall handlers call pkvm_refill_memcache() to top up the
hyp_vcpu memcache before invoking __pkvm_host_{share,donate}_guest().
pkvm_ownership_selftest invokes those functions directly with a
static selftest_vcpu that has an empty memcache.

Seed selftest_vcpu's memcache from the prepopulated selftest
pages, leaving the remainder for selftest_vm.pool. Required by
the memcache-sufficiency pre-check added in the following
patches.

Assisted-by: Gemini:gemini-3.1-pro review-prompts
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 7ed96d64d611..deee7947d694 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -751,16 +751,30 @@ static struct pkvm_hyp_vcpu selftest_vcpu = {
 struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 {
 	struct hyp_page *p = hyp_virt_to_page(virt);
+	unsigned long min_pages, seeded = 0;
 	int i;
 
 	selftest_vm.kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
 	WARN_ON(kvm_guest_prepare_stage2(&selftest_vm, virt));
 
+	/*
+	 * Mirror pkvm_refill_memcache() for the share/donate pre-checks;
+	 * the selftest invokes those functions directly and would
+	 * otherwise see an empty memcache.
+	 */
+	min_pages = kvm_mmu_cache_min_pages(&selftest_vm.kvm.arch.mmu);
+
 	for (i = 0; i < pkvm_selftest_pages(); i++) {
 		if (p[i].refcount)
 			continue;
 		p[i].refcount = 1;
-		hyp_put_page(&selftest_vm.pool, hyp_page_to_virt(&p[i]));
+		if (seeded < min_pages) {
+			push_hyp_memcache(&selftest_vcpu.vcpu.arch.pkvm_memcache,
+					  hyp_page_to_virt(&p[i]), hyp_virt_to_phys);
+			seeded++;
+		} else {
+			hyp_put_page(&selftest_vm.pool, hyp_page_to_virt(&p[i]));
+		}
 	}
 
 	selftest_vm.kvm.arch.pkvm.handle = __pkvm_reserve_vm();
-- 
2.54.0.545.g6539524ca2-goog

