Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A346A5F9
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052574; cv=none; b=AvdgMueWfm9RqVJcDGpl5bkSyb+AuNIn3nmEwdE3TjcPhrBvnWPVeupYBiG23Ebqtm6dNyzGyw1eqITx25yddjRZnLMtlLLeNq/UhL8Db3MYzFDGaYc9wpFzPuBw9NujakZ4Prd/2QSfVJ9yqXvjj3EwxSb9fbAzSkzom9Mf/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052574; c=relaxed/simple;
	bh=zgB3+8JK5YhFAdN3TgJqt08umXKZZZGiuhUx5GAOPx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUZLdRbAUYBjcRxQo6I6ZKB3TGHZI0vpU/EaM1q0pjQ8EcXCbuWOXs/e9QQHvaJ5xZh0DRwYcsz4Xj05Irm8QEV1Q3UuyKHuQ5gCxmPnL9WEHt6pk7Mw8bSYK7ljzVAqUj5106ki0OMTUj2SM6ymZooTSgL3yKoc7joH7/QfCvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rpxysRb9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rpxysRb9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so4563092a91.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 04:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787052570; x=1787657370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uzcibn+mdIhChgrhZtZVfO5SLMtBxjTCSvRPL8WbSo4=;
        b=rpxysRb9HDPoTawS1sNuhjtk9MNkxXvabYlkgsyUwyhigDRcN4bj37ThIxZYrGCLxD
         XjZ4NpliSOrMNH/6CW2b4yrfr0SJ/xHzTSuC9XocGAbfr5mBbg1s9hWQugse777mvduz
         8m/Bm2Q0zBMkYL4J96STS3+dpG+th52E5bA4rFpNRoHAHYsBSJIxx1DtDAhVuQn+4HIY
         THz5c/OjS/DP+OPsJb+apN1cjT8ubqFSQu/zHpE4J7GJeeC+JYFkqqnnf4TGEkL0ZWJm
         0Hn41hc4T13ls2nlbDmt+d27oFcWnDYGnEFeMcPMyAkz2YqOsA2vpYHnZ4HAyO6ouodj
         5A+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787052570; x=1787657370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uzcibn+mdIhChgrhZtZVfO5SLMtBxjTCSvRPL8WbSo4=;
        b=aG6MQV1WzavYQVTmOh6hE4LgjQmSwJJ9MyQ+MoTtAD4At/Oc2/Q6ybGWPvACvoKBiN
         735P1M9i6wQogSJH3YMv6xAkSxdsDwtkJNUsFzDYVCzFlLkPoxS/0vxdILeuro7NyoXL
         nPjQQFitLc5VemEk8YwssLyLCHLe8mAgCX95bqgBkbUNVxDYnFE2ugO7mS+NXBn7+lVb
         YLBsQWvBFE4PIwHZJ8EODbsM6EzcEAwh9yrfmrCHXat6T24JSVbHIwugnGXK5y4khBeU
         8HYh3VFXKZZ5gqP1PkctgRV6T4+FPaIYJHiuQgGa0dD6iGqlOxZfEboP5NOWDSQ/HTdh
         tuBw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4w87mYvcqr6HVns2MOp+SDUS35qNmg64MuqMtVh7UKGIRThKTDrRCBLANE7TPEtar4iYM5sM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdZT8r5yvQ4GFJkNoXY8q7P5wHlVFt1HhUuAwMj0AWU0MXfgfm
	x8EcAdQvMvSk+h8o8h3o+ms0wYG+OuZL3UCZkW8Bj1UL4sSNRtFw+vOD
X-Gm-Gg: AR+sD13srnL/Zh/kJTRxKWcgs5fedl553+i6x49MrKYnQGVMEAfYfqICgBOt2ESfujA
	rREaSvhH+BjSJI9qIgIDGnSnfdhF2vMybW+bLyhl8ucqAAxxQiK5wHQlisN8cPVaAczEtEEFmsB
	PM1K8C8S0/TLQ9uN2Ma3LcRIGkjKqL59H1/0etd2QdpqWfmYuoCOhhOABWnd4aCHWY93HOX9/vR
	sNEE9mLVy2igEuLYIA+7ov2C16MpxtblSmZ1Ga9jbVQk4WtEC7lw3+byjcFszmfUhuIiNhmqniC
	ZOjizbZ4Pa/PRaQv2C5uElYGBb6iK6ank1avXGYRZnziC68nrpOAHvcagQ01OI5aas4zm9YvSbT
	h7eHTnsvCJF0VQ7HBEkgwzjYyRjrIX3iNCzHbudTcRAFrDDV1RtI02Eks5vvQa+eayDsfGsLB0u
	L0jk69y2jzTLs7Plx0AWQjtvdwD18dSpGDP22eoQ8U9XLWzYA11kpgpwt6FI4z1cIUtbPimxNrv
	142
X-Received: by 2002:a17:90b:2802:b0:38e:9e9d:9209 with SMTP id 98e67ed59e1d1-3955aa42a2amr9926813a91.17.1787052570004;
        Tue, 18 Aug 2026 04:29:30 -0700 (PDT)
Received: from LIKEXU-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e31a9dsm8423420a91.4.2026.08.18.04.29.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Aug 2026 04:29:29 -0700 (PDT)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: jiaqiyan@google.com,
	kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
Date: Tue, 18 Aug 2026 19:29:19 +0800
Message-ID: <20260818112920.26252-3-likexu@tencent.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260818112920.26252-1-likexu@tencent.com>
References: <20260818112920.26252-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sea_to_user backs guest memory with 1GB hugepages but never checks that
any are reserved. On a host with an empty pool it aborts instead of
skipping:

  kvm_syscalls.h:68: mem != MAP_FAILED, errno=12 (ENOMEM)
  not ok 1 selftests: kvm: sea_to_user # exit=254

The mmap() of the hugetlb region fails with -ENOMEM because no 1GB pages
are available, and the test treats that as a hard failure even though it
simply cannot run without the backing pages. Check the free 1GB hugepage
count up front and skip cleanly when the host cannot satisfy the region.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/arm64/sea_to_user.c |  6 ++++++
 tools/testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c     | 15 +++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 1c2a743ca8e23..7cf95da8e594d 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -281,6 +281,12 @@ static struct kvm_vm *vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
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
2.50.1 (Apple Git-155)

