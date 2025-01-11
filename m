Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3202A13957E
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556660; cv=none; b=GJaNSOf2hWKqPjNjN1c7HNQ2DjyIPepbAlDhgieOMbdUtnhogiUgR1pkVwtnatA3JH8pnJkvhCQBdBr+a4axh9xj8gsXIvb9LMDes9K59P1x7gUwBmr0vagGbadpU71KD6VTfisUXYWXoMFHls5UhHg5Vf19r3foEbijgbL2LKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556660; c=relaxed/simple;
	bh=cdYoQmC1gHgaq22PDsiZGCRoGD7RLzRK9PeAtDWgW1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YtcnrQMRavAUt6h2X/S6asd8RIcj+4gqjAX7Kv82SSMvQJNg4EmdKPWZptEI2P5mFpnKeQC3hSa3CIlB9DfnQ6JDGENxnkJDrCQjuG/Ksh5b1IKeRg4InXKG6DXMdXMcKLnZbdeglvQGcNxBwes4m6UonrjSFD/qMeEJtjo0ADo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R8dNxrIz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8dNxrIz"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21632eacb31so32998445ad.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 16:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556658; x=1737161458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FOB7JN0OSt2j8FiVppNC5qzgljC2YrzarOO3DmltLC8=;
        b=R8dNxrIzY7/xBRgMMRCjGwuCXbdbVyoinHrMX6Hply0Lvs/iJJ25414HDDu8OlKl75
         Tgx+uPONcAqfL13RFZZnELCJjOFP3aQZtIquAVvMlejdGS5hO1JQGIBo82kNp77xUXva
         yydHV0NpZjHc3zPJu7zPxAjGuteuTsUa0LETAueCRwIMKrymoaQ/GpGA2zQtgSpdpIbB
         OZkGwCzGipJf+O3+T0HSLVNEzKtDO5hSd9c49Zkt6E+MVLk8+QrenO81VuPQNUZr4F9j
         lsi0BUcyoocrVQVAq83xZ2gGSJ8G1GYn42xzEbgsqOnLSaEWfzNbL4I1Dn0JobRlFMqr
         TCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556658; x=1737161458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOB7JN0OSt2j8FiVppNC5qzgljC2YrzarOO3DmltLC8=;
        b=CVUCB4+/zgQ5quXrOc5HYmuOgGjfIdiyzYYByVodYBsE/l0cbLV64h0vgu5bzK5/hN
         lvDKoTDtoVp5ABrln71KKpoRsLj7dJZxw6d2HGrV2CnqkszYyHO9l5jwp3bRgqX4yuXA
         MLJK1SqWPYMWEZAIFY0TNk9Y0h4Z7kksyZZlVG249WD0R9Eb6Np1LYS873GSHxi4KA5r
         dwEDYq57NcpL7eYHu9bzxg8O4A4JAbTsTuUa2Wm46SMHIXeHC4uwZ0TcprBXc6tVuOBX
         zhU7/a4AMKBhGdqD/B4HnTtDNb68WsnO183WWUkbp3QfEwCU38A3ty1+O55YbsWS9P+2
         gjsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy2txD+EbwywhoVse5+Y28eU9cS8T6lCuAifEABD1iPfxJ02RI6/4u0FVBdQg/QfZRU0pcLZ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLFi1myYAvNqLR6zoBCp/VE4pyGQ/U+0jwsLD2T1DFswjPApN+
	L6j4kBcXrTnZ5amahCmsmpJu8I03pDeWIKs2zXPcoKCvRpyUPQ2YojBcBuLPoe5mB0YT8Tlps+F
	Bcg==
X-Google-Smtp-Source: AGHT+IHw+facaWQOVSZ1pCK120eQYAoo8aTdmYyBocQEoqyBkRp7UviUm/cm4T86jySXDaDXKVoax9zRB1k=
X-Received: from pgqb5.prod.google.com ([2002:a65:41c5:0:b0:9a1:7139:ff84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:339b:b0:1e0:bf98:42dc
 with SMTP id adf61e73a8af0-1e88d0bfa04mr21140343637.28.1736556658420; Fri, 10
 Jan 2025 16:50:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:44 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-5-seanjc@google.com>
Subject: [PATCH v2 4/9] KVM: selftests: Macrofy vm_get_stat() to auto-generate
 stat name string
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn vm_get_stat() into a macro that generates a string for the stat name,
as opposed to taking a string.  This will allow hardening stat usage in
the future to generate errors on unknown stats at compile time.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     | 14 +++++++-------
 .../kvm/x86/dirty_log_page_splitting_test.c        |  6 +++---
 .../testing/selftests/kvm/x86/nx_huge_pages_test.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4c4e5a847f67..044c2231431e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -534,13 +534,13 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		   size_t max_elements);
 
-static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
-{
-	uint64_t data;
-
-	__vm_get_stat(vm, stat_name, &data, 1);
-	return data;
-}
+#define vm_get_stat(vm, stat)				\
+({							\
+	uint64_t data;					\
+							\
+	__vm_get_stat(vm, #stat, &data, 1);		\
+	data;						\
+})
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
index 2929c067c207..b0d2b04a7ff2 100644
--- a/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86/dirty_log_page_splitting_test.c
@@ -41,9 +41,9 @@ struct kvm_page_stats {
 
 static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
 {
-	stats->pages_4k = vm_get_stat(vm, "pages_4k");
-	stats->pages_2m = vm_get_stat(vm, "pages_2m");
-	stats->pages_1g = vm_get_stat(vm, "pages_1g");
+	stats->pages_4k = vm_get_stat(vm, pages_4k);
+	stats->pages_2m = vm_get_stat(vm, pages_2m);
+	stats->pages_1g = vm_get_stat(vm, pages_1g);
 	stats->hugepages = stats->pages_2m + stats->pages_1g;
 
 	pr_debug("\nPage stats after %s: 4K: %ld 2M: %ld 1G: %ld huge: %ld\n",
diff --git a/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
index e7efb2b35f8b..c0d84827f736 100644
--- a/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86/nx_huge_pages_test.c
@@ -73,7 +73,7 @@ static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
 {
 	int actual_pages_2m;
 
-	actual_pages_2m = vm_get_stat(vm, "pages_2m");
+	actual_pages_2m = vm_get_stat(vm, pages_2m);
 
 	TEST_ASSERT(actual_pages_2m == expected_pages_2m,
 		    "Unexpected 2m page count. Expected %d, got %d",
@@ -84,7 +84,7 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
 {
 	int actual_splits;
 
-	actual_splits = vm_get_stat(vm, "nx_lpage_splits");
+	actual_splits = vm_get_stat(vm, nx_lpage_splits);
 
 	TEST_ASSERT(actual_splits == expected_splits,
 		    "Unexpected NX huge page split count. Expected %d, got %d",
-- 
2.47.1.613.gc27f4b7a9f-goog

