Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A02E566A
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 01:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658758; cv=none; b=rRKQAYevEwm6DKc9N3cqPeCz38zikung+37cvab1Y4/ghR3aWGZcMTj3nk6Gy5TeHgDiwYRAdLSR7VLy5442eHCRfLVP1B5faWqi/r3bkVpqROMrPAwBnVyFoFLZjxNFTNh0Z7CbL2+wUsFtMXYQjQx943rZsFpNJymdnCa6Ytk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658758; c=relaxed/simple;
	bh=cdYoQmC1gHgaq22PDsiZGCRoGD7RLzRK9PeAtDWgW1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=STMO3E9c9OZOGNXmWAUYlkKZGsVI5g0OJu3T+Y8xaOcdlZBehy9Cx7cpL2YF7TYgIU26o99pA+Kg7pSP3jw/ABgTQxksK5bBZvIFjaUzijCqZa/yxLbMUFOi4Yiytp/1Bo9ErWMtSilM/+K0y1nGBaLsokTRacKkjQeWMSZpstU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3a12RHDz; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3a12RHDz"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-801d5add29eso935643a12.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658755; x=1735263555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FOB7JN0OSt2j8FiVppNC5qzgljC2YrzarOO3DmltLC8=;
        b=3a12RHDzQdqGAyKaIgutLcD9zbb0L48ygf7SnGHEx5Cj/NfLdgRovh09E4WBQsffxc
         ZQMDDc2fmHIipRdrfUKy/gxf7sieb9Yt5dLnoe6TZe0/oV/IvYz24xSPal6TEagECahF
         r7XfrsbNoksYi2CJsRPBNUdpc19SBR7huySKlEzPYXVmnIwgc37ZzCDWvzA5V0ZDQCbp
         IHeRBWawOoqeuDfoj2bDZ2Rnzme3ymRT3fL0XzNlzBI0rFt1mij9pIuTekPKAKOFiKs2
         Hm8lfvmxNn3CUL2AOVgXSJ+Ms0J9EUEE/d8EvflLkiyrN7gZnwGKZB2ht3PtDJcPefbT
         uHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658755; x=1735263555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOB7JN0OSt2j8FiVppNC5qzgljC2YrzarOO3DmltLC8=;
        b=VaERsOXNNLcsPIuFE8R8CBruM/IwALTaOoKX1/T4xBvMzPP+ABp++7d8ENpBRFjuT3
         MaPBOIuOy1eeYoGOuj+GjJBnYj9rtoDUhTqnx4IdxoIrAmrSyQUIqst/+Fv5lZtIx6y5
         je6c6RoYa6Eb7IZspe+XPssG+fkIV8hUga47ur/uJI58r7iSvfP+dGv71CZLQP1GZbUt
         i/v8bT6/0PawFIKiGzh9smw5mOVRvvqC/kYb+InPmyeHf1G5CLwNbQUyaOAlF82C8YbE
         sKFGPIHtFmT6+075WdnO2zMqgXoandAYDUg66pOrDDK7cqhWfyHnqkIEgN+MfcwcC7Vb
         f3iQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdB/yPV3J5xtk2hj5rt7jhDg9kubUBdn+87Mezc92gcr5OD+OOL2GDNV1jISrMs8wB06puh1o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwabbaQcuYbJnYf19O421ZyNQo38JVu74J2TXGN8nDrsdKBDlNy
	2+5e2mX71XfQkVwKCiCrvjJ59dgiflAtwmrBLdeCJAFGnDND6HdoPbF9S+XDRlW3HBfMqpSCGYY
	X4Q==
X-Google-Smtp-Source: AGHT+IGgztxRUxTUpaMUvL86uRz7hYZyu/zAmCoVzo4yvg4Q5SlFHbLBFYN3ktm59BGI0bTCiW14R+y2ITQ=
X-Received: from pfbkt9.prod.google.com ([2002:a05:6a00:4ba9:b0:72a:bc54:8507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a6:b0:1e5:c43f:f36d
 with SMTP id adf61e73a8af0-1e5e046189cmr1878060637.18.1734658755535; Thu, 19
 Dec 2024 17:39:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:02 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-5-seanjc@google.com>
Subject: [PATCH 4/8] KVM: selftests: Macrofy vm_get_stat() to auto-generate
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

