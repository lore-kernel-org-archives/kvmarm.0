Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38371DF982
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907592; cv=none; b=DDaCdtWfwgQMJbNjF7uCCnLAeGAaIszZJ0/R7Bf3YGUGsuw7Kqt99lfWaN0AniSpY/Qw0R0ucw+CmccDmVIfd3gW73wzkaqQSJcNoSdzYC49R8KA2AhpEz/yBad3NdEgtHJxAWQiNq7C/zEnjbpE7acTZ9Zr/uZMK1NIwdf4kiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907592; c=relaxed/simple;
	bh=zP5otxa//0zoite2Eu0ATDBm/FH7lY8QwxI6PuHxOvc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pk/FfluL2RTTbGj8raEK6kHfJvUuhzN2oCBiFjS0m82fZaflUlwmOH5KPyV7tx0jx949H3l0WG0kaS8HyNgnZzUmQ202RpP4WhqXAYcgZt944vi9HIspTn+nyqHw8/AXuY3Xk5E4EwqRa9Aas9VmTb6pGlaAjK4iw2rlLVPCP/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=umfTczwf; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="umfTczwf"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45526e19f43so13939265e9.3
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907589; x=1755512389; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mMMEW4m9zgxGaWpPF/szQjkmQKnYcw2JK1bAC39QMM=;
        b=umfTczwfiwHYCKirBRgxHcSmK16vHfPEkAulELqX2CG2kmwDBgl0eghEGHnI9v6562
         CDaE0Ss/jJ5nr8sZHuAI5xefPr19ROTcYAUSEFivugT7FXrjm0ZHF1h5BvPAKIa1nAQz
         v3r3jQ50kgPirKBbIUpYoE9xPEJ8hwxLdDRYSpdoC5x3gBUJnGSyqBXwQAOnF1JE2MVN
         mv8BkYFpxarid5Rpq8d6DJWxsCZp8rG6vnY05KKqittSH4IXzaBkPVxlHi6Fp6UB7ar4
         kbfg7lVIV4OmoRb3NyWYbZQMfNnejDMgSUZkpbthRj2+V33jEcLG7CZlVbSEdXMBPoUF
         Tdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907589; x=1755512389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7mMMEW4m9zgxGaWpPF/szQjkmQKnYcw2JK1bAC39QMM=;
        b=fcORDH+p/SXI69JQHGvVqX+nz4wPva7/KEyi1SecysiG2Xxw9d3jq13Bym0PBmbaFV
         tihDfW4GcrQiQ3f8oV6116uXp4C6vTA3wjyhBuZlghNhMYBFoIebyyMEoOZZWrHF0H5H
         fQjEe8M9XFBvOVaULI2hP8R3Pz+YTkkN2asP5HnPXz7uDtt9rqJdU0XnDaJe7mBQq6Ec
         a6Sh1tsS6sweAonEVdsMm2MOQb7r0gwhKba0WBhRHWD/k8XqNmW6Hh/eSOfHBiREUIKK
         fzkJh7bsgFEG5d7MihOwMlNXtk7WLZo+y44y3om1GiXtnxHjp713cvTIU1U3whGzccpM
         M9Jw==
X-Gm-Message-State: AOJu0Yz4fs302QC2jj8pgOBF5nj84RuGlJ0gqXDd7gdWkTWuwl9bQwZ+
	Mo12dmsq64NwDdoyiFK7IePIk1gMPQFw0Tq67UBI1HaGGRVtjYv4uEMhShauYOAfxSR/B3pURRI
	PJ53NIsCGUG19JqJlaRWvIoRB6Ex4M5Bdo/aIQIiBi2AjuR+xxgO+IZtAqEiI2lv6osChK0rWP7
	q6BOULX1TBEb0bDrYSpdS5xJ4C/er8/JQ=
X-Google-Smtp-Source: AGHT+IHjhS6ytMaXVNJ7Du5d3Tnuyl5IqlbWdUPN0Qe/yqUE5wuMU08eLueRWtToK/GsWuj6EncVLrrZ1A==
X-Received: from wmbei22.prod.google.com ([2002:a05:600c:3f16:b0:459:e0a8:599b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ec7:b0:458:a850:f857
 with SMTP id 5b1f17b1804b1-459f4f48b6amr119732475e9.31.1754907589158; Mon, 11
 Aug 2025 03:19:49 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:40 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-2-tabba@google.com>
Subject: [PATCH v2 1/8] KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
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
2.50.1.703.g449372360f-goog

