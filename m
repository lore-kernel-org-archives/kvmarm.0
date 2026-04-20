Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20AD3890EF
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720014; cv=none; b=cMOho2CARy6Kt+BcAU+gP4kbJynHbFjnliIKgS35rWbhZyphVBUT3Uo84ftczJ4zwOpJpVJk9z/TuXxbQhRnDAAjEsrh+hpS11ypfx+GTlZ/1dgToalwcSm9kjSjWt5p1wozZyJ5nH+uPSHlFrDYzq2eshwEX3L/kOqaFjbzj80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720014; c=relaxed/simple;
	bh=nfE8K5Wu/vbugdCgGfmuXxSc4u8oMhTZAmH8cfZgOX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0CgQq8LLYiffwurZncxCuFNOHrTXRZU92hMLtN9NKFSKiVoC2yj0Kj0VTIObE6LJxujL8DHpokyHxxBpqd9UZZIxov39ISpRvjlqRwYxcj41af5qRJZYmNoSwXZogHrjdWiFRGWtJWE2cz/GI32aoDkkKEWnKWdJBMilgGJ6wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NQVvxWki; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NQVvxWki"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f543bae3cso1844057b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720012; x=1777324812; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sEgidxfCrHeWAn/iqKdfWB4mQGqG7JFMt/kzEyBGoSw=;
        b=NQVvxWkiihool/Ic+7KOiltEhEixzVbdng87B7yBoGmXIIH7k8RVPIUyL9m6z0hKVR
         h0sDQxMoJ3/hWS98nei6yxgkny4E2rl9Wv3A/gxQTvRCwXl4xCs76nOWNM2Pp3hEHOVN
         DNODk2oXFDX2Z2EjobBIMEqwOUBVLbor0t+mo/nKCDINf5P1CbP+4eB/MhrZylFlM0sL
         U8SkDXIDYMof+2v2ZfmO0qnWRjAre9RuAuC2b0f3owkkxrHOEgD7ZlymkqbAkwlCutlN
         jrVlTd0WVpyAt32ETsXfufoQa6hVNQdWISS6WegT6Vmxp+HYP9/q+AVI89iT+5/Ms+8T
         Nx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720012; x=1777324812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEgidxfCrHeWAn/iqKdfWB4mQGqG7JFMt/kzEyBGoSw=;
        b=J6uC6oBT4kgh9taCY9kNkuIY9GRw1M3Xe4qNMUjFxPma8n00Qf100ojMDDsHacN+ix
         Thhm7hb/8yRPemaA6ARZHSswxxAcYcYCtRd4DM1UABqyq+xTr2mBmlGeicjYaK6eEKgd
         l+EuWiRSihBGf5tL0/nGh0YELhGdqkNgaTG+ebu7yahYW+TTukGblmY4qWtSuuA6Oqon
         POUti73NOVdL3xcZ6dLC4yPsBasQym9c+bXxUEcDJnZxmrTdPK5t6DpLOp/duZiWPjxL
         tRzLx9VoOCm/rban5tSqiorhHdi3wdbKa80EcrsegoBqjSkWPUJJDYRY76LY5zfSLj0B
         CgMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/b5MJDXNS2l6zSQjdNU1WMp3y96DnUdWwiT9If39OA/2eo8GPVj6s5+BOahhHeT6aytGrOPDk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQupQ+Eyeay70imb96ptvl71lALcZG59RyanafE41GU4+TXysO
	kIpafQ/XXac4xsdf8AAIBKCzWDuboK71o2ETgU7rSTXb5wtfSam5xHleFdBHGcns1lwQG3Ufsiu
	78VUUBA==
X-Received: from pfbli8.prod.google.com ([2002:a05:6a00:7188:b0:82f:54e9:c13e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:27ab:b0:82f:6eca:563e
 with SMTP id d2e1a72fcca58-82f8b573171mr11858630b3a.34.1776720011915; Mon, 20
 Apr 2026 14:20:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:48 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-4-seanjc@google.com>
Subject: [PATCH v3 03/19] KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Fix various Hyper-V selftests to use gpa_t for variables that contain
guest physical addresses, rather than gva_t.  In practice, the bugs are
benign as both gva_t and gpa_t are u64 typedefs, i.e. gpa_t and gva_t are
interchangeable from a functional perspective, the code is just confusing.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
[sean: call out that both are u64 typedefs]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/hyperv_evmcs.c    | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_features.c | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c      | 6 +++---
 tools/testing/selftests/kvm/x86/hyperv_svm_test.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index c2de5ac799ee..2d1733f9303a 100644
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
index 1059fcc460e3..0360fa5915c0 100644
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
index 7d648219833c..5369867efac3 100644
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
index e0caf5ea14bd..54a1a6dad4d5 100644
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
2.54.0.rc1.555.g9c883467ad-goog

