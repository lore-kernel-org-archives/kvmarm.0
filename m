Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB94F237164
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790422; cv=none; b=rdhZf843OFPMYtVZIqOzklCjw843/IOy0EpUiYFpGkQwhVqwiuhmGz9ZmpTKncr0gE9XjZvVUUSQlDAvYZQPRK79dHwjABJ62IQv9KgSBbpX6Rz4zDc0QSUjkW+YvfTOnZ7RPnFnBbZAg1WjTNYDGdZiDayJpOSfzUG9NI1CHgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790422; c=relaxed/simple;
	bh=9CiKq3Xa+wrpgNBTTn5M5u/4Ry1x8g71Pj7gb8dnXy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r5vWyqt8ZzrGvaQ8riIocr73uaww0JN5AhSjJX7LQfQPoCHXdkk2ntLhJiqqVEITFZM41foxOcwjg13NTtYGp0GaTuPiEfC/m4OFp2VrtFxIhnzTOcLNmy89+ybdBrwUpRO0c8QfdvYAfa0vVix9e2VM+lrM8qcMfI4XbNn+jtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wszFp1bg; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wszFp1bg"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7806a620cso1396324f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790416; x=1754395216; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WkUQXWRsg/hj2cUnIOQ3CPsmYSv39SsVW0PkY7cjuos=;
        b=wszFp1bgZR48dziUgI+R8Rz/7flhfO0pci2mKuqlbUEPVUJEw+WGvgsCPOqaU4mG5j
         kdx0Rwf8mSBP3IVw43iKv+EzhWqAUBksbYeOnqzSRuggf72k9oAIa0rxla1ofFs6LhrE
         6kN14PdFV8MemGc6WIbIT3p/8NiEALG1wgqyer8RlJG9lwWv9a/dDF6mBBlei5wURtgN
         fD8nyMamddDZ0gy4ZnpcfZJ6JSj9t8reqWz1fvi2E6jfvt9v1YGxGSbP105etuwfPilF
         Zl8/lWaOJF+ZBad/d87pMLczX6fEZcdTeGvIaR1LXttE+xZ+/36zv4foIQ52+foATDQm
         P3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790416; x=1754395216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WkUQXWRsg/hj2cUnIOQ3CPsmYSv39SsVW0PkY7cjuos=;
        b=car76lQfS//cIsT7fAO51biLogshbzLDPWS+nZa+kW+OIX58mV1sGX+xc0Bd80hOVv
         8WQJ7eMDSPlDhij3VAGd1mq2LYFT7AcXvOvoc2zwJ+3KISIK4LhB8yJbtAiLU20Jmx6P
         t53Ix4TCT9dxupCaRnD2jHnbHNy6gDLTbWdoBQ4fWCj4Un2ckFUsgAH8rqR9vL6R6T5D
         U5eBbKWcwzlGzD+KARwehUmENx+D/v7bp8UNA7cHApkR+NHYRl8dlETS5W6bTQjgoJ4k
         IluuZobHCgGeaHHVtMYbMtPnx3IyK+WmTCg0QTVwhd2Cq8UVSJ5kz7kz04tcg4dMG1KM
         UBVw==
X-Gm-Message-State: AOJu0YzWz5duz8msz1/6UYYguLk/mJpxRuVD9LbrvisymIR8yspti2KP
	g/s/idPny+4pGTLQ2Hg7F7WC1QlB2iHklGzVBlbwcahUi9qIWcNFAco+fIgwvCw9ZQ1H+6iIv6m
	cnrQouzRJ/2pzl2/5oVAOJ4QUwJQRdcRv/GQWFupAkAHzM3k8Ynkdda/BvRomxJGfMs0GobUQPG
	f8Uq+UgeQj0lcz0IJt0j9Hqe4Z5LsaJp8=
X-Google-Smtp-Source: AGHT+IFK+h6V0iKGcdXFeEkcJRc+B2xhFU7NeOBM4sPEr+OvNorrq6EQfBL3mvvXROKHMZwSy2cgZ9e3Kg==
X-Received: from wmsp14.prod.google.com ([2002:a05:600c:1d8e:b0:456:c7c:3165])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:a115:0:b0:3b7:942c:5450
 with SMTP id ffacd0b85a97d-3b7942c574bmr358163f8f.9.1753790415805; Tue, 29
 Jul 2025 05:00:15 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:06 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-2-tabba@google.com>
Subject: [PATCH v1 1/8] KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly named.
Its purpose is to indicate whether a VM is a pKVM protected VM, not
whether the VM itself is enabled or running.

For a non-protected VM, the VM can be fully active, yet this field would
be false. This ambiguity can lead to incorrect assumptions about the VM's
operational state and makes the code harder to reason about.

Rename the field to 'is_protected' to make it unambiguous that the flag
tracks the protected status of the VM.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e41a880b062..55dc7cd83e40 100644
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
@@ -1522,7 +1522,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 
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
2.50.1.487.gc89ff58d15-goog

