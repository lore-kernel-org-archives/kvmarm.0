Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095D01F5825
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 00:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548162; cv=none; b=u+cimSo7GuONaPugxJFKpUYijTLae+iFnzBh3+Ru6CUZNf6OJfZLTPgUrEyOZ4Bx3ZuBo5+CRvpekWZxars3NMaPn9ouU7hGMswgvqwQw2UhqBPAGRhCWIcE7hCrUkMYmpwLGsW/DYMn8HqMUDRqc0+prI0MP/XSw996WonNSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548162; c=relaxed/simple;
	bh=oO/Mstnb/hv6xOZAhuRkyWPUemNHokmZU13swYe0ZWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LsgqLevWECzGKQ0avOk8Kpf1SbQUy5ceaxW8YKwM6hIMOtaIGQUMYnbgXz2PyPAXDlDjInZy0QzxN9A8TlUBKEvdPE2QvxtxnpWPyyftnEnmM6RkhX5LiqR8mVJNky88iZyBd8XRDKWH76eZDfoLwwidmrmPC7qxlMN7YnEmApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C97RoL3P; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C97RoL3P"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a76f2d7744so15721105ad.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 16:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548159; x=1772152959; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sQBtHoV4k6KEICmmP/ngOD0EM850XDOZaHNBuV2LJiQ=;
        b=C97RoL3PEWX3oLiZvDNoWC/7P5MfVZJ+0sda1ORpsmyYvQOPPqe54Lak4nY/VGr6mR
         pLzBLMbOYfiUBQFqIPJEDN9AqWmgCj7KZ9PYpIFRkcMnzAvhXGi43jrrU+6hAe3mNjrs
         s3cDvLL3pNPdbfQigLSW6lGCYCeJ2lvI7MbHRQtJyrt8BLfDLBOivEFZih5eTvEKKKLe
         TR2JgnZG0tEZs+UdNNEdnkkSi/DVsOy6BEwsCB6qDJAbInMvpLrU7N4ShI8WMd5lYBTa
         M/NdA2v3vyyk6IZNtKvzfUFiE3LW5D0UI5nNZeutTRIDJgj/4ejc0e86iJAKfZhehSFh
         sQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548159; x=1772152959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQBtHoV4k6KEICmmP/ngOD0EM850XDOZaHNBuV2LJiQ=;
        b=gazfMJYKEWb+SFN4d/tzBduYUAyv3f79BAccVd8zGRXEPbi7EF1Y4ugro2aNCPWfYT
         9HcWN2CEhffA65RfZSeDIGkDI47zQuq7pap5RggFWRit7/8TG+ip/nRiMMJLZLDlF+Bi
         CG7oY0Ngh92KrY2XbPO5cIzNgXoHCn/XuTyPkb2p64HdLnNLpWTqvrGWDeqbjPpZZ2TW
         XCwm0dfK1fM2Fe0cRqY6pG1pkGTHLt2+nEgVeZRLR9+nbw+YPTFCXATkNaPLkFil1toB
         NJhcr1Z2xy/KkjQa/D6Oh6i0Rlxf1Bkdt08hTBH05+bkGrjE3KeNkbaq4EMjpUodD3gl
         0N7g==
X-Forwarded-Encrypted: i=1; AJvYcCUs8bV+lfDQl+ChIcQtGfo/y1mSxRi9ZC3Q9ev1wgophLiVhUG2oWbIdJrXL5FxzWOK/LnWScU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx63AjL5lldWcsj9it5L+4Dw0gZHBs+DCG6DuJTA8b1m5dnx5oQ
	DYe71FnTnPiNmoCN5fyH8/9nR3+wcgIMHBdFV2IFomuDQA5G0gU3vMopP/f0qsJ7+d05mN2TuKx
	06O7207DqZEUtvA==
X-Received: from pllk12.prod.google.com ([2002:a17:902:760c:b0:2a9:8200:4985])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:41c7:b0:2aa:dee9:dcf4 with SMTP id d9443c01a7336-2ad50ecdb29mr69263015ad.25.1771548159168;
 Thu, 19 Feb 2026 16:42:39 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:16 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-4-dmatlack@google.com>
Subject: [PATCH v2 03/10] KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Fix various Hyper-V selftests to use gpa_t for variables that contain
guest physical addresses, rather than gva_t.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/x86/hyperv_evmcs.c    | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_features.c | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c      | 6 +++---
 tools/testing/selftests/kvm/x86/hyperv_svm_test.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 58f27dcc3d5f..9fa91b0f168a 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -76,7 +76,7 @@ void l2_guest_code(void)
 }
 
 void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
-		gva_t hv_hcall_page_gpa)
+		gpa_t hv_hcall_page_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 3fe5f52e404b..fde6682c49eb 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -82,7 +82,7 @@ static void guest_msr(struct msr_data *msr)
 	GUEST_DONE();
 }
 
-static void guest_hcall(gva_t pgs_gpa, struct hcall_data *hcall)
+static void guest_hcall(gpa_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
 	uint8_t vector;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index f6385346dd10..f239923e232d 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -45,13 +45,13 @@ struct hv_send_ipi_ex {
 	struct hv_vpset vp_set;
 };
 
-static inline void hv_init(gva_t pgs_gpa)
+static inline void hv_init(gpa_t pgs_gpa)
 {
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 }
 
-static void receiver_code(void *hcall_page, gva_t pgs_gpa)
+static void receiver_code(void *hcall_page, gpa_t pgs_gpa)
 {
 	u32 vcpu_id;
 
@@ -85,7 +85,7 @@ static inline void nop_loop(void)
 		asm volatile("nop");
 }
 
-static void sender_guest_code(void *hcall_page, gva_t pgs_gpa)
+static void sender_guest_code(void *hcall_page, gpa_t pgs_gpa)
 {
 	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
 	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 436c16460fe0..b7f35424c838 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -67,7 +67,7 @@ void l2_guest_code(void)
 
 static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 						    struct hyperv_test_pages *hv_pages,
-						    gva_t pgs_gpa)
+						    gpa_t pgs_gpa)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-- 
2.53.0.414.gf7e9f6c205-goog

