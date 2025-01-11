Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358E914AD0D
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558702; cv=none; b=QEmkhrqYPtzFpb67P0f0lWXO4fo413drKR3g3ec0cbhHerU17PMUTZbW607Wlzsrw6Pf3eGuxmwh8kLBCgKS4s+AVLejV7m/AK5+QJLbn0u0pi+0e33p2kqAteUD/jSXnuQSIbfRs68l92MvUUIUEgQXY+MUXOjAQsAH/G59Z54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558702; c=relaxed/simple;
	bh=Z8cG7o21aZj/wKnE6C162GYRcbSZevgDOGSsD/YNjgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nSJKUp1CS+n4RrB6nV0PS0qQNQhE/g1z41vxkn8Vo/FU4LusYOjZouyPZdYDAfn0Ht3WmwENJnVnoXlHT7uGKZzRCFkFc66sPNZ6gyIdfaEuBbVmKe9nHiMnZ5yqHNnO7tfo2xy3LF8FZtbmDPSn2L2je6MhSUu68vR0byPi9I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qE4KSnH4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qE4KSnH4"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21648c8601cso42875215ad.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 17:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558700; x=1737163500; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bnP9l4TBgZavFgl9ingoWbV7IQlMfBLutKO12YuuQSs=;
        b=qE4KSnH4PDDZdYeb46ZkmPS8LIU2oAuEqD6kBKesk9WYeegR7Xh46OVhEWrEZzHktY
         lmSa4mpYteBEycp+JI70WNkJESGo0qNGGplhTcNw9FNl7EwbW+7czwKDU7NOVVEHRvdI
         Bomv4N4a6E/WYD4iPiqPQSINuow9VvwlV8cFrk7wAQCqVgKyQ+NIaioZXuoAQryqXg+K
         YbiAUq5nfg+ZMA63TVVTEn6Jcg/GvxiQoeo78xNbJcGWoNumiVMQYKIFtQY0AL2YFpi4
         W7o5YCiE8FTanrBKYLFDXqxBzEdEREi+tNcI/8xcIuwxl6Z0bzmTqTd1jH3NKGR1IdlB
         Wmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558700; x=1737163500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bnP9l4TBgZavFgl9ingoWbV7IQlMfBLutKO12YuuQSs=;
        b=i68bRKEhevTKTlzH/tOrRXzGcFC1KfyBqrec+xfenL3FVswlvzzegF2nJdSe0j7YVr
         D+Ll43kn9wHDGWwH6OQzW667mUVnqHMvfgpRPbYzMR8aH93u23KTn9ttqe1j2Gnxgg25
         TbWXKKbfRo+xIlGxSRr/RLD2AUKK762GhX4b6cwVZQCsfFteHsw2OqJI44nZ7gjftksb
         o/paR1lHJnso2HLKlw0/gfUqkXax5y0u/a0KehBzrSKYd4p3bLgn8KeW3q9fX3JgPuNv
         oIlvKuFnPmpz6vr2Hmy1NHyxVvOKN62g8RowlmOATe6zzlbxB3N52MGaHvunF1LKKynD
         DeAw==
X-Forwarded-Encrypted: i=1; AJvYcCXq5RXRSc5X2PjeIgx9F4PNgb0mbhJgY9Z/x673LVeNXpg7FImr2/53D6ZLYTz4q0uKsWzz9oA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+AIRslGT+Ba0NCpg+hRCO9seiux6B4qpHENEw8QPoQc+3scjv
	fJfWpNTejJidfAi9sGZrXHofNGkRxLnJIwaOF6YWLw95WHBAh8xCt52Pkcq8vUD0GtsP+eBPdYN
	uJw==
X-Google-Smtp-Source: AGHT+IH1NdERQE8OQLjVGWXsUxxFzmL931Ova+zIR4kc3ay4XMIaQ3TzbpO5jT/NYBJvXHUAPCJZD+fSckk=
X-Received: from pfbfh41.prod.google.com ([2002:a05:6a00:3929:b0:72a:bc54:8507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4393:b0:1e1:ca91:b0e3
 with SMTP id adf61e73a8af0-1e88d09e17fmr21120449637.36.1736558700525; Fri, 10
 Jan 2025 17:25:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:50 -0800
In-Reply-To: <20250111012450.1262638-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Rely on KVM_RUN_NEEDS_COMPLETION to
 complete userspace exits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add selftests coverage for KVM_RUN_NEEDS_COMPLETION by redoing KVM_RUN if
and only if KVM states that completion is required.

Opportunistically rename the helper to replace "io" with "exit", as exits
that require completion are no longer limited to I/O.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h            | 8 ++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c                | 4 ++++
 tools/testing/selftests/kvm/lib/ucall_common.c            | 2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c           | 8 +-------
 tools/testing/selftests/kvm/x86/triple_fault_event_test.c | 3 +--
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 78fd597c1b60..86e1850e4e49 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -29,6 +29,8 @@
 
 #define NSEC_PER_SEC 1000000000L
 
+extern bool kvm_has_needs_completion;
+
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
@@ -634,9 +636,11 @@ static inline int __vcpu_run(struct kvm_vcpu *vcpu)
 
 void vcpu_run_immediate_exit(struct kvm_vcpu *vcpu);
 
-static inline void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
+static inline void vcpu_run_complete_exit(struct kvm_vcpu *vcpu)
 {
-	vcpu_run_immediate_exit(vcpu);
+	if (!kvm_has_needs_completion ||
+	    (vcpu->run->flags & KVM_RUN_NEEDS_COMPLETION))
+		vcpu_run_immediate_exit(vcpu);
 }
 
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c9a33766f673..95ac9b981049 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -19,6 +19,8 @@
 
 #define KVM_UTIL_MIN_PFN	2
 
+bool kvm_has_needs_completion;
+
 uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
 static uint32_t last_guest_seed;
@@ -2253,6 +2255,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	kvm_has_needs_completion = kvm_check_cap(KVM_CAP_NEEDS_COMPLETION);
+
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 42151e571953..125584a94ba8 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -154,7 +154,7 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 			    "Guest failed to allocate ucall struct");
 
 		memcpy(uc, addr, sizeof(*uc));
-		vcpu_run_complete_io(vcpu);
+		vcpu_run_complete_exit(vcpu);
 	} else {
 		memset(uc, 0, sizeof(*uc));
 	}
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bd5a802fa7a5..1db4764e413b 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1077,13 +1077,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vcpu *vcpu)
 			    nested_size, sizeof(state->nested_));
 	}
 
-	/*
-	 * When KVM exits to userspace with KVM_EXIT_IO, KVM guarantees
-	 * guest state is consistent only after userspace re-enters the
-	 * kernel with KVM_RUN.  Complete IO prior to migrating state
-	 * to a new VM.
-	 */
-	vcpu_run_complete_io(vcpu);
+	vcpu_run_complete_exit(vcpu);
 
 	state = malloc(sizeof(*state) + msr_list->nmsrs * sizeof(state->msrs.entries[0]));
 	TEST_ASSERT(state, "-ENOMEM when allocating kvm state");
diff --git a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
index 56306a19144a..82d732788bc1 100644
--- a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
@@ -97,8 +97,7 @@ int main(void)
 	events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
 	events.triple_fault.pending = true;
 	vcpu_events_set(vcpu, &events);
-	run->immediate_exit = true;
-	vcpu_run_complete_io(vcpu);
+	vcpu_run_complete_exit(vcpu);
 
 	vcpu_events_get(vcpu, &events);
 	TEST_ASSERT(events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT,
-- 
2.47.1.613.gc27f4b7a9f-goog

