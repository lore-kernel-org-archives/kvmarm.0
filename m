Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7963A8FE9
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 08:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954089; cv=none; b=VwpxPmYiUs7G67kuFI/7sfvjkOvpmdQCHQCzDLWe8RFmac2FVyRgsm3aFJ1puoKdJn+0CngmrByN4XTTW6lvy5yiNLtQKKRyLracsatcFrJux7Z/lqSISkGkjPGnO/OWGr7pYWkd9Hb8dBoQzGo42VVFjn9Lq38vYF071qHaCHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954089; c=relaxed/simple;
	bh=J9oJgrAIUCZn9JbeqjQpmyapZg23D3IIgDBuYE4EdQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hQDaDIFO7fNJCWiQ57iGwsGorHHNA5xTIDk3Ijn7zPdlgmIpjnIo8F9V4D75L7gNxIJ7zr4MeYiOrn76rxxeAeM5mLV+KXrQUlQFK1IclOoJkB43gEE6FRIom59vqX+FYtBI6Mcrh/s75KKoEHFD+tXzsJDIvgj6vd/KT3xi0x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=azX5NFTl; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="azX5NFTl"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848743155bcso863505b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 01:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786954085; x=1787558885; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/dRMPyHnGOaQMCEefUKS16OLUTw2HWkBp1hAitPH6SY=;
        b=azX5NFTlLNuLLSOnWBYWaeUJq4UxEBnxC7OUJaR3Ah4QNKMAtMDUFi1GsHE1BvrPNy
         kzebPH8jZ2ZkXCx9TF3jqrpMh9/OcQLDgvpArVaNmwIuzX9vQs3XV8xCz4z8MiOWWRa7
         LC9m0ydtUv5CArJLkMRBFkZx4vhqOEbIXs31YGlkTd4ppFE06mjukaUMHixl2v6F8wdt
         DCmy2CgqRpeXH5sfp6UmoK7MtNa1h0Yf0c/DrLAsshDxkP20ztB+19gat1nTFzpTm7qx
         GZGRUwUkV6fH34OaWHyrwmJVKM3FC70NPN3rnGu12bGkZp23XCHnwN/QBRNffKNVdzfM
         sBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786954085; x=1787558885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/dRMPyHnGOaQMCEefUKS16OLUTw2HWkBp1hAitPH6SY=;
        b=IAmwto4VpKXSAcMthl8vr1rFnVjGJ7HtnoU9Boe6+fmCUSM2tfARlfP35l2qEkdx5I
         lw2zQasfrhQNCQA3SnKRJmW+VTkiJRZ/arxqa+50v4Yf4Sy9u2lleCJLk5pNJ8X/M3In
         0IVnIQaiyjDve/2ATEIzn8xo+PkJVkjeFnXEAg1HjgMrVIc42abCG8J4VJc210kbaRAl
         sycNSv8YM7IG0Qd0I8NU7iRXn3Nrk92OdLH58rR1F8+6A+srk+oCKOzYsYt9uQiGizaG
         U/PhwLlU1k2GOPl3h6YloFd/+iefbdfMR1o4WO5psGmhdrvs6AbPcUXAIoe1qfi5tRff
         HWPA==
X-Gm-Message-State: AOJu0Yy4G/JKOnUk7P7bbW1oJNOg39I3+lrRPgf2Yh6cOupbHyhLI4LW
	0OSQRMqveAMjnmge+mxSdjV0VX0mEK1F6kXjTtmYA3MwSsv2L07aVoIn
X-Gm-Gg: AR+sD10+5H8ibsjgYyLHTPHUSdox6p2QMvXfKu/qvDTYBBmSv/XLeK94x6EZNKFku4E
	/SDtLd43ZuKjM/R3m9/OS4x9tgBrSbWjxGyUYqLM3XkDdJ89Xyrq1pP1bo8sGfMWZlf2AIx8p64
	C/KZsdTPAlo2voQUniNz8TWBl78Ciuu5G6vNPUWATRTRtXhMH0MAvLWxbMv4NmyReU7u+/C6FxE
	M374usKFAK864yL5xjPPeC8zEg7K4RewP+qqlg4RKTiUiLR5kTQ5Na3o8b0sLIjfoawfIADfK+o
	cY3K2ixkj2iADCdKJXo9O2fs8DEfGaUfM5BelQpaMgJJa0FzZEn2og0SFqMDV2rpjh3a97Q94d1
	F76SoSDjI2QjVBdD/aU6XczR3JmI0EayzuWZOLLhi2sngZZcrmKghEeebZy7P0pqzvanq5FG86n
	0RHMcG07s2nbyn5l4VzfnkqPXSuKX0bwMCgXOObGwWlYjtzkUVmEq18xwud4yZr26jPyQc1n6TI
	8KoDw==
X-Received: by 2002:a05:6a00:3cca:b0:848:2c5e:305e with SMTP id d2e1a72fcca58-84fddfbf1a9mr23134966b3a.6.1786954085292;
        Mon, 17 Aug 2026 01:08:05 -0700 (PDT)
Received: from LIKEXU-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d223fcasm2442328b3a.34.2026.08.17.01.08.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 17 Aug 2026 01:08:04 -0700 (PDT)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
Date: Mon, 17 Aug 2026 16:07:59 +0800
Message-ID: <20260817080759.25601-1-likexu@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sea_to_user backs guest memory with 1GB hugepages but never checks any
are reserved, aborting instead of skipping when the host has none:

  kvm_syscalls.h:68: mem != MAP_FAILED, errno=12 (ENOMEM)
  not ok 1 selftests: kvm: sea_to_user # exit=254

Check for enough free hugepages up front so the test skips cleanly.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/arm64/sea_to_user.c |  6 ++++++
 tools/testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c     | 15 +++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index e96d8982c28b8..fc4f81702d0b6 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -260,6 +260,12 @@ static struct kvm_vm *vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
 	alignment = max(backing_page_size, guest_page_size);
 	num_guest_pages = VM_MEM_SIZE / guest_page_size;
 
+	/*
+	 * The region is backed by 1GB hugepages; skip gracefully rather than
+	 * failing with mmap() -ENOMEM if the host has none reserved.
+	 */
+	TEST_REQUIRE(get_free_hugepages(backing_page_size) >= VM_MEM_SIZE);
+
 	vm = __vm_create_with_one_vcpu(vcpu, num_guest_pages, guest_code);
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(*vcpu);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a56271c237ae9..0624922c2735d 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -168,6 +168,7 @@ struct vm_mem_backing_src_alias {
 bool thp_configured(void);
 size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
+size_t get_free_hugepages(size_t page_size);
 const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(u32 i);
 size_t get_backing_src_pagesz(u32 i);
 bool is_backing_src_hugetlb(u32 i);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index bab1bd2b775b6..29f9c1d60b1b7 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -222,6 +222,21 @@ size_t get_def_hugetlb_pagesz(void)
 	TEST_FAIL("Error in reading /proc/meminfo");
 }
 
+size_t get_free_hugepages(size_t page_size)
+{
+	char path[128];
+	size_t free;
+
+	snprintf(path, sizeof(path),
+		 "/sys/kernel/mm/hugepages/hugepages-%zukB/free_hugepages",
+		 page_size >> 10);
+	if (!test_sysfs_path(path))
+		return 0;
+
+	free = get_sysfs_val(path);
+	return free * page_size;
+}
+
 #define ANON_FLAGS	(MAP_PRIVATE | MAP_ANONYMOUS)
 #define ANON_HUGE_FLAGS	(ANON_FLAGS | MAP_HUGETLB)
 
-- 
2.43.7

