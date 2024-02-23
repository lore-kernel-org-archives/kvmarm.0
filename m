Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E05168A4
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708649005; cv=none; b=kwHgQDYzg/ih9mumTyUIj4O3NXHtE7Ouh4X5Baa39+XhX480JWatK1ekb4pQf+LdxX6j/Z4A/VRRI1SvPVe9te++d9KIY3kSzLjjKkICEWDLYLwPfmeRadqgpeXk3Xewlw/k+LiPaK/2YVyk38LcKsMX6ngzQq4BoRuKjYuQbtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708649005; c=relaxed/simple;
	bh=IcmW1JJZ2UeOOxj+K1S4spEtX6G5KVw3+hJZz8Cf1dQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I9djLDgeiqEyZDOUVYgbEfsMjy3SwzGTMg9bShpNVGInfvTbVN5u6a3ww4l/aPEdel2bBOxd+p5p6USuIT/8xh3KetheuxzrZUJ1QPWaowmJmHcZsUUAwwAEkd4CDvckos1xpmgdK6J/3UW/4FQMcl6SQcIF0VUA9yhjwyOmPGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OgpKWXKg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OgpKWXKg"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e476b2010cso171138b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708649003; x=1709253803; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Gc43wBFyEWO0ZO0dpPNQ+d7W+GksBMsxe3wuyqOBBYI=;
        b=OgpKWXKgHaVAeY2gOgzdEsM+jc0TvWInQDF3t7I3rOj2Hah+tERPZd0Xo7aS+poaPe
         ABG2iooXLbSFNlQncN3QLFEAcGngCZN9jnOZZnrRq+aDZduqYoTfSQlJ0NAOX6UzqD36
         rTADHrcm5bfzfYWHrLoJzaI9nWyD++x5MbPfC4j0/fBnSSP9tFpl8HJp1kEwVJZFqlHf
         TVNbty0sInPSvbLr3IClxbtPXO6zoqXocMnMYsI84Px8pLgHXt4+k+rudSDgabf6HqdY
         iVqTLP5J1jWxioS15RDd5+F0Zl63vVLqH6ayf6oqQECWRHOJ+TQZ6md5x7kbhQ/EROzP
         zfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708649003; x=1709253803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gc43wBFyEWO0ZO0dpPNQ+d7W+GksBMsxe3wuyqOBBYI=;
        b=NguD1Q5HniMLtxL+94RwGnVxKpUviFR+Bnl2ZioLR2TBNt3XjOurh7FBGrI57QdSlw
         VrezGqhwsFLm7FHJx85CBcaBuCfSxkhlnEybZb8aF88P/D+MCxR6K1f+mWmejoCVMHEI
         2pIqR3LGBxwq85vOjxcl4l7XfiC/aRU405Kbz/xN+fE9IMabRvxYNSNVbWks0fsqMRfr
         RFDHJjX99eid8jVAQBlxyjroiXAEEhpTpKt96ykVutD3cYoOFWrn4LbDDC2GlSp+pEi9
         3DtujPBt8bfWcrailJ85aglDEhzxHVMHzaJnr6/ilLulMjJRcQ3RXUVtGAgl/JR2mNy7
         A+nQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH2FJsGBJpzUijVsZLUSeJ0MDYEakJ1hDoBSvVjLSLBgHthAkZp253iDycHEONbq668ynOEBbx0n0kaMixPbzW7zRO8+UQ
X-Gm-Message-State: AOJu0YwFgsLFbUnNzeH3BRRB+gd7vJ7ESKJ8E2s+Hw0jRyisWyTR4tJg
	cCiK0J6HtfNioH6KPlEnfMgJV9jNsjIUaxUQDbkfEzFKzSA5dOkC7Iptz1MrqJGvjtdEXKWX/Mx
	7fA==
X-Google-Smtp-Source: AGHT+IH8J8hOUDN/iwRypevdW7KRyW+a1uJn7645jMv/ZgZVJ0iWo7rJ7snpuFhqmTRKnqRT0U6drKpAx6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:188b:b0:6e4:8b79:f5be with SMTP id
 x11-20020a056a00188b00b006e48b79f5bemr32117pfh.3.1708649003443; Thu, 22 Feb
 2024 16:43:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:58 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-12-seanjc@google.com>
Subject: [PATCH v9 11/11] KVM: selftests: Add a basic SEV-ES smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Extend sev_smoke_test to also run a minimal SEV-ES smoke test so that it's
possible to test KVM's unique VMRUN=>#VMEXIT path for SEV-ES guests
without needing a full blown SEV-ES capable VM, which requires a rather
absurd amount of properly configured collateral.

Punt on proper GHCB and ucall support, and instead use the GHCB MSR
protocol to signal test completion.  The most important thing at this
point is to have _any_ kind of testing of KVM's __svm_sev_es_vcpu_run().

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/sev.h        |  2 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  2 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  |  6 +++-
 .../selftests/kvm/x86_64/sev_smoke_test.c     | 30 +++++++++++++++++++
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
index de5283bef752..8a1bf88474c9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/sev.h
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -25,6 +25,8 @@ enum sev_guest_state {
 #define SEV_POLICY_NO_DBG	(1UL << 0)
 #define SEV_POLICY_ES		(1UL << 2)
 
+#define GHCB_MSR_TERM_REQ	0x100
+
 void sev_vm_launch(struct kvm_vm *vm, uint32_t policy);
 void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement);
 void sev_vm_launch_finish(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index aa92220bf5da..a33289a5b89a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1074,7 +1074,7 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 
 void kvm_init_vm_address_properties(struct kvm_vm *vm)
 {
-	if (vm->subtype == VM_SUBTYPE_SEV) {
+	if (vm->subtype == VM_SUBTYPE_SEV || vm->subtype == VM_SUBTYPE_SEV_ES) {
 		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
 		vm->gpa_tag_mask = vm->arch.c_bit;
 	}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
index 9f5a3dbb5e65..e248d3364b9c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -53,6 +53,9 @@ void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
 	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node)
 		encrypt_region(vm, region);
 
+	if (policy & SEV_POLICY_ES)
+		vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
+
 	vm->arch.is_pt_protected = true;
 }
 
@@ -90,7 +93,8 @@ struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
 	struct vm_shape shape = {
 		.type = VM_TYPE_DEFAULT,
 		.mode = VM_MODE_DEFAULT,
-		.subtype = VM_SUBTYPE_SEV,
+		.subtype = policy & SEV_POLICY_ES ? VM_SUBTYPE_SEV_ES :
+						    VM_SUBTYPE_SEV,
 	};
 	struct kvm_vm *vm;
 	struct kvm_vcpu *cpus[1];
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 54d72efd9b4d..026779f3ed06 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -12,6 +12,21 @@
 #include "linux/psp-sev.h"
 #include "sev.h"
 
+
+static void guest_sev_es_code(void)
+{
+	/* TODO: Check CPUID after GHCB-based hypercall support is added. */
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ES_ENABLED);
+
+	/*
+	 * TODO: Add GHCB and ucall support for SEV-ES guests.  For now, simply
+	 * force "termination" to signal "done" via the GHCB MSR protocol.
+	 */
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_TERM_REQ);
+	__asm__ __volatile__("rep; vmmcall");
+}
+
 static void guest_sev_code(void)
 {
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
@@ -31,6 +46,16 @@ static void test_sev(void *guest_code, uint64_t policy)
 	for (;;) {
 		vcpu_run(vcpu);
 
+		if (policy & SEV_POLICY_ES) {
+			TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+				    "Wanted SYSTEM_EVENT, got %s",
+				    exit_reason_str(vcpu->run->exit_reason));
+			TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+			TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
+			TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+			break;
+		}
+
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
 			continue;
@@ -54,5 +79,10 @@ int main(int argc, char *argv[])
 	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
 	test_sev(guest_sev_code, 0);
 
+	if (kvm_cpu_has(X86_FEATURE_SEV_ES)) {
+		test_sev(guest_sev_es_code, SEV_POLICY_ES | SEV_POLICY_NO_DBG);
+		test_sev(guest_sev_es_code, SEV_POLICY_ES);
+	}
+
 	return 0;
 }
-- 
2.44.0.rc0.258.g7320e95886-goog

