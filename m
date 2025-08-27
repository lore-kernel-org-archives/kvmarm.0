Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86242D6E67
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756289996; cv=none; b=C+9DZSDWaSAI2GAEQFQOUSB+dd5tt2qpcKvxPEOBsLcaQkQSFlWsJHZnqdwg3GdIoVun+HGEcIaysdfwIdfplnZq/LE15yXPg+rZI+eXuVTl6/DzpAQXqSJ2chNwe3SKQjTo3d7ENhuK9zkOy1P2V27Gk3SlJPbq5PdQzwAEvcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756289996; c=relaxed/simple;
	bh=/hLY/ypvSNurBTH8wmmVEqq/h4NIrOLWxA1rr0MDXwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iwD6r3lk7/EjvS+67MPwG+7pVTJ6jql2AiWnJdH5SudrvJAS+Nuw9WB7OcXd2hw0toYAYqj7yUqRBhAH2w7XtRHB0r6GX+nJX74J+T66wzUGEZC8ZJ7obF2FhprMQXMGePb4MpE73eX5eSfq5FnocAU4rWXFjxAFGktdbOOcXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=veie5GEd; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="veie5GEd"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b71eef08eso2668795e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289993; x=1756894793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=El5T7YDofdY2oxL2jCvDRau4w0+KfiOKmcQ3rCTkH2Q=;
        b=veie5GEdMj56iWK9h0EF4HjDJXJQ2oiS853id3UtageS52SCT3DfPJ9K645YmaJCHP
         sO9cSlbHMCmhFjo/UqngYihx7XJFWyzNT0upNp90lYZpMpNhoElxpADUnvU3+e2pvNkV
         RuHrZQExxGfF5KPQq5gTL6gzNa6fjM7j8p6pwGmsZ4cu7iecaHh0ED02I6BFrfX44+/j
         KJPPIZrqsK3Ldwd+GdoTT8aHDgzq055Iu6SNx/3CRd6DIZMrsrPQkK2eygD4ZdRtbOYT
         jErDEKLdQ19dPKe/NjF2wZs8hIy/Pt0eMDqpCqgiuiZODUP6KvP167ASejqxysrEDHPg
         BDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289993; x=1756894793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=El5T7YDofdY2oxL2jCvDRau4w0+KfiOKmcQ3rCTkH2Q=;
        b=gEKyKAthtiqa+HjV9GsG01l3/Zu0e1722kKCzlTb8M9ML/7I5j77DIPF00/c3BnS53
         TCSwdcxFNrQ4zTMpQuF/3EYaKctRfkxr35xSO4tjB0kXIkpWrK0K/W0VuFyERIyCVomb
         qPx9venvv0a1gjJeYe5T4bwmUXiQFen5dx6CClkiywWJhaUspDiUCN0A/kxO481jHbX9
         AhlGWwUKK2JRJAzS4NAT6uSgwYP/ohN8/ekltrqIFAnLlTXFo4n3+sGvHOdvut8Wv/jw
         nEY/p8YIn3kTf3o62kRRf48qwIJc/97gks85zXLlhO8hkTkSFWuI4Rb4RenhvDrKQk85
         /paw==
X-Gm-Message-State: AOJu0Yx3BZIGU1Ixn9jJdu22CT2tR0ONW4NnkwE2lbxwlFqvwuL+hZh/
	BxrcT/8ShIZT/THqkcjY4EdwnJsYhy1rgPPqT4DHz5HqsE3NXio7AVr4jtV6rXcfrVREyQoV4oJ
	JisHKpvVzIULN4l8WSchM94Uq5pyuPOGKePMcYxosAMdP04rJEkyUwfFwnwplivQCUNDZ2mfvmN
	K5QlyWytb7a0ApIfph7YJSPBKsBWYsppA=
X-Google-Smtp-Source: AGHT+IF5cUPVetsmWfFly/EvAcRj6qwSYa5775m956gdBFEdvtZGfSwsFmHU9STnt5zjg0/yqs7MsoVc1A==
X-Received: from wmth7.prod.google.com ([2002:a05:600c:8b67:b0:458:b662:fbc4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1388:b0:459:d451:3364
 with SMTP id 5b1f17b1804b1-45b517d40f2mr185527105e9.24.1756289993104; Wed, 27
 Aug 2025 03:19:53 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:42 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-3-tabba@google.com>
Subject: [PATCH v3 2/9] KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly
named. Its purpose is to indicate whether a VM is a _protected_ VM under
pKVM, and not whether the VM itself is enabled or running.

For a non-protected VM, the VM can be fully active and running, yet this
field would be false. This ambiguity can lead to incorrect assumptions
about the VM's operational state and makes the code harder to reason
about.

Rename the field to 'is_protected' to make it unambiguous that the flag
tracks the protected status of the VM.

No functional change intended.

Reviewed-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2f2394cce24e..a4289c2f13f5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -252,7 +252,7 @@ struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
-	bool enabled;
+	bool is_protected;
 };
 
 struct kvm_mpidr_data {
@@ -1548,7 +1548,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
+#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
 
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 338505cb0171..6198c1d27b5b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -406,7 +406,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
-	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
+	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 }
-- 
2.51.0.261.g7ce5a0a67e-goog

