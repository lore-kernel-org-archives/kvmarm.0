Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288EC2EB1D
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124401; cv=none; b=npZ6tZx0UuwsrpYGnDNcPlPrr6WyIY2r/LiRGyVf/HC+Rn242hsIa+wDPcrbD1NxAgsqeMBMMUWaHKWe3NG3CiYHNbvIXnzwH0yNt6j/c4Lk3KPn2DSG7oWDUq0F3KvjHX5LZPm//kRPOFb7vPqv9ZfshMhCTpvmFJV5bCfrPO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124401; c=relaxed/simple;
	bh=B5UaraPdxHpT8UjUOBrmqqlMDErnWldn9oIkLIIvGkg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lpT8eFtyGf5vivz/BQPNOhA5GZS+dN6k2IlqGn04CrtYsGN1MpM3pBPcJwcK44smyzdRbC0ff2ScDLtT8l8udl3rsrV4KWvew+XrWT2pBZsL/aq76Pea8gNFuKvfozo8j2l0PDWtbDhAi9eLEpgBaEkUdBJr7QqJpIhBMiius0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RHHOWRSV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RHHOWRSV"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a0a8ddcc4so1417352a91.3
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 11:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124399; x=1746729199; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OIbU+P+6LX7gXLQRg/LGs6gF16rvs92LA9pz4G+MTw=;
        b=RHHOWRSVV+ev5seSwbAxZ7GAgZBqC2M7QyYwCFD6C1mT9tuGILWKp2z/dECMuCDaef
         SpXvluKm4mW4Do8rxtHJaFT0KroY8vmqlJqEHsX3MavQCZbiTTHjyJCgUiRwp46p2Q+3
         lYcEtQwCpgRau/byeMYmZd+WjV/Tc16eEHtL49LDklYMK10A796GMe8XUSPUtlEkuzj4
         1X6k4AIYB2cZhJksryVfnZGBkeNAnsmiMypUJYsmaWspypGZkKn3Xe1DRXQjUqdt+GmT
         XZAi79PYS5WVSKb7r5xfEugJaG6PChta4AF18fWbNUB461cGQ04TA3OfdXcEObaBBWBb
         bqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124399; x=1746729199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6OIbU+P+6LX7gXLQRg/LGs6gF16rvs92LA9pz4G+MTw=;
        b=ntOz80C5JeNjyAXUabPAdZ71qGzdJksFOeWCbmk6BD0ya93UCSF4rgoHuuEdEdgEbg
         fpu9VFeCGPLtzXYYxbNblDXZ0+wQ4tZA+go6pFl+upCarDvs3SvQm/XAYcFbAhD8o2n6
         cpmvvE78uND0AuND06gWq4lJXWt0H6uHBnT+6aKGla1IyGVo+OYXx4FpTuy2vCBal+W6
         aOTRRrs0Rbmrv14uzaCvMiAEyJgB1aYZKQKk7Fxj4KQUEkZDhyziv6cnnVTbwHZM5+RJ
         ijH9lYrwETbGUvxP9CecIxHr4JVdJDsKaNNR3Po/2z58wu6w7ZYE0ZyW4V4YHzijoULT
         vO0A==
X-Forwarded-Encrypted: i=1; AJvYcCUu+efqhIshUDhuCmqLBtBVos4CdP7i2NRvt0+8Uy0k2f7CsKPnidluCHolzEFX5AbJldbkcc4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8zDl4aPdHIUxsDHPvQaYlxdTkbfb55pI7Tdz37ZO7hR1PSK3Q
	PubZ7EDHBGDi6BwSZqJU+FKfXhSNUGtqS0ipCd0Niqki8DtbNpvxyt0ZsXt4wtcK0fVWF8a3Onh
	BDn/NbEBYag==
X-Google-Smtp-Source: AGHT+IFt78ttcTKk2SPQ8BT1FrQ1uThUJelTODuNzJi0Vzk5E6Lu1cEhiJVjoBqjNinGr2mXNSf2Udc+HEafiQ==
X-Received: from pjuj6.prod.google.com ([2002:a17:90a:d006:b0:2fa:2661:76ac])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:520f:b0:308:637c:74f2 with SMTP id 98e67ed59e1d1-30a4e5bc6dbmr294105a91.17.1746124399047;
 Thu, 01 May 2025 11:33:19 -0700 (PDT)
Date: Thu,  1 May 2025 11:32:57 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-4-dmatlack@google.com>
Subject: [PATCH 03/10] KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
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
index 5cf19d96120d..b3847b5ea314 100644
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
index 865fdd8e4284..85c2948e5a79 100644
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
2.49.0.906.g1f30a19c02-goog

