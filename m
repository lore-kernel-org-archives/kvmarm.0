Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B95274FF4
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137921; cv=none; b=SGX/bWDgZY0rFxV+0PjLgT/d8QKDtjfqt5V6rlS7jHFQDDwsmAVN4pBvDoEX9uWl14VqxM3wVhAaWL/9Ii2XFCbSgmJc0+Mmc5wKDuQzrUf+92o0W0K2qqnbnTgHfTlT15Tg5U6OOiLTqjqMOBehw0GMgPP6+rwM/r7NmZoOA4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137921; c=relaxed/simple;
	bh=np1bN13wn9C90KK+H+wwEHyvF3CFjYVZDRFxiem/Bw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BKIOH6nnW2UZvyL0/ixL6VLrYaRCcyXzSfaSmBBbfBuL7MXy7IJLyhDByw6G2pewHEGB2gsOuLkneO8taJTve65QCfsDEx4/A1mJcny8O/eej1VD2hrHRxytOymmynPrGIakB0DLeR1vFTotNEiTnXYpa/wGehLNcfe/L2TFnxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eL6zrhPm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eL6zrhPm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-450d57a0641so8042685e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137918; x=1749742718; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9CTszacuPAxWQTwzIU0nGotfU9vxy8BL3CP9EQLh798=;
        b=eL6zrhPm/TJBCiUTm7YfV3GltjIT2HZy9ZCv8xI4GrpOzj0QwTJNVNUacoa7GuIItt
         WtjzY5bJM+SEg/DcVCxSVRMx4y6hC1tSZSg7aclj7t7Rr+Hc6RW7JG98Ydm4I+D+vKMY
         Ig1+ZyrEhqpWZ4sTmRF8pKcFuI8y60APyTZTlnUYMhkmr9jygBz/P2a9EG6sg4KFQsnF
         XZvbJpk0kwi3d1mODwzbN2Wrf2S3OQxnMANcxYDWPAe16zwaUhTaax1DEoNoINunpxsR
         7f3ukSfByxxfHTVnSE8ujj39cJRlKRwN8ZWDKZG/kVugEzVAQZ45MZP6EpgI8qRLieo8
         XmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137918; x=1749742718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9CTszacuPAxWQTwzIU0nGotfU9vxy8BL3CP9EQLh798=;
        b=qSSMJ0SMZx1r7R2ByYrkgwTs5+RlfG/DPtD9OZuFZZZKl0llxkxeKgJRzEobaVwCSJ
         RqEZJBNC0RMPBQvJFmfJpKLO7UJv59dj6JhF7vyfGvkGaXSovXfHMcmNCjlGcRwp3fGr
         VHAX+CmNsLerED8TiFlwDkXcL3sYvWTtpwZZkHjmBPb07He6eu2LvvZ65TYGn4MMk47V
         65vukns7Ev2zNyjRzDUBF8eGPd4UKHgdFm71+yXvKgZUP4rVvOeZSb8JwpLjH7HH1aOT
         kDgl+fOu30NErQH9z5CGoWMBggs5EWdOXLA17oEkiuSXVltHhjAkYsExImky2Sfdspno
         JxXw==
X-Forwarded-Encrypted: i=1; AJvYcCVPYBkugE8vD5rs+iD92yHRQz+Af7gv3w3sclDaXb1VPyXTxmmk9Cu5wSFt6HTVclDQpsspTxs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlhoQtArqhL1cQLlocmCRvfmJ5hfFx/yVIEToRmH5JE/7YVmn+
	wDCynHPGn1Ev+8ehoXe778jUZ7phCBaiNcng4DIBTsuC6kWwb+LoKlGq+Lfw7g7Kx8KF9f8pDOE
	2Aw==
X-Google-Smtp-Source: AGHT+IGIOvyaIq+arYR+kGxlz5MLXMzKAjfF3gerPhhAkuJUuarivw68VGg1S5URm28toMXSQIBmwPWvzg==
X-Received: from wmbhj26.prod.google.com ([2002:a05:600c:529a:b0:451:edc8:7816])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:828f:b0:43d:ac5:11e8
 with SMTP id 5b1f17b1804b1-451f0b26621mr61939045e9.21.1749137917744; Thu, 05
 Jun 2025 08:38:37 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:59 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-18-tabba@google.com>
Subject: [PATCH v11 17/18] KVM: selftests: Don't use hardcoded page sizes in
 guest_memfd test
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Using hardcoded page size values could cause the test to fail on systems
that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
instead.

Also, build the guest_memfd selftest for arm64.

Suggested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f62b0a5aba35..845fcaf8b6c9 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -164,6 +164,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
 TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
 TEST_GEN_PROGS_arm64 += get-reg-list
+TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
 TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..341ba616cf55 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -146,24 +146,25 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
 	int fd1, fd2, ret;
 	struct stat st1, st2;
+	size_t page_size = getpagesize();
 
-	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
+	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
 
-	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
+	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
 	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd2, &st2);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
+	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
 	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
 
 	close(fd2);
-- 
2.49.0.1266.g31b7d2e469-goog

