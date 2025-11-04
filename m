Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C272EC57B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261156; cv=none; b=hq8qjYKFI6wN+QQIQzMkPJsYAQ8tcwexJMi3CLWWaKLraNQKZ5Lk1NylXCWRJ7ZmY0qN1xEcc6LRaHvBc66H+hiHr/107rFaYGIgv+x6t9xkzD+an24vnlsxeYHLbsqHaj0kzCScY+vm/xaJ2FoG19gXoCohz+7/ehEDXHKt5g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261156; c=relaxed/simple;
	bh=uzb2jkrlzdzY9h/FBQFLzVpzr1ZKu9vZ3UM4L5iMj9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yit8R5Gkwkee/++C91lXnW6xF2sUNe16Y2mGgtHgZgCnYGVYC7889wHHiQnHUeOWjDXmeX6/R5sxyJvNUyQJq760IW+tIFV8iBPVERRQbXaKuoFjR+eBeyM72QMMrmgd+JyO82gYGcNcFtNfmdyI2undIQ5Y0htPdHhjyDGAaFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SRvEXBJs; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SRvEXBJs"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477563a0c75so3687295e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261153; x=1762865953; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4BR5h4rv9IbD76eW/W7JHUUha6GHsVyE9JD4/DnaUVM=;
        b=SRvEXBJsfp8A9uEC6ydM3LjkVLbthCR9Ec6YVdjsokrO3W+Ku0qwQMWP7PJbYq5xzw
         3RM01AoQY8z0Z03N9HDg4RkfLhQlkZ/doiY1xsmVraOUgX5czzY7dsqJRXqLZ5dEnuaL
         ME9xdjwcOwmdUjwrTzlbU1tAFMKSJdzD519SDXDcfol+qg4xhwucQmH4o4DtqJLwUe+q
         T3PM4irXrMe4a99hkO5ONYQGPs0cMmyMUY85hNmeSj6pJWUbzeI4RmP6aBfLutJ08Vh0
         O37Fc5v7QxD4LByNhJx5PxIfGCw5KCM9nwGllB9mV/AumD9cSKT/b9FFUn/GWlevftas
         8v7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261153; x=1762865953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4BR5h4rv9IbD76eW/W7JHUUha6GHsVyE9JD4/DnaUVM=;
        b=ZBApXDXS5vmZrjYHSTiwPTFyDOQz+9P9uHu5LkYgjZG7EQeAg1JC/vLsGa8E8beLj6
         gq96sGGj8bhkQ1l66x8YEVRTSYcE7trKfjjKjATWkpaUbuDlEObdaiQfFPd3Q3zPuT3q
         qdRWJcCfeFFtOFN9PuRBvYB5/XnHLnoYkzceK2cAtLzyKbZnFfGHSBYNOS6M/X6S//Gz
         1k9P+f2Q3pZEY50w7LjjgAbXTYzWKQDPckExRhbr1GCzE7oaWwGrpyLm7oYFzdxEqMQ6
         tJP+T1aLWoJCAgmYparuIYLTKBDB9/Q/Yzn6OUD2iHnXJwfP9bJxzHJNl07FAGc5DcrR
         3kcg==
X-Gm-Message-State: AOJu0Yxy0snvTTW7GnMRrTFL+PJ5Zqo0cvlQE5JoGu0Ayr3czSrQec1W
	HqldaORlfOEO+U0HmYlOLO9sZAkAp/fJBbMY5B4OvyRsKPF37g4D0dHeDxewT3md0CjsvYv1OxF
	aMesiBWCR2/z2Niy5Tdo1Vk7FRh49YR5A7+/cmsGWFTJI1glYA1LHY2lZCv+w/nBpVURaQ1r+2K
	QW/i8lV4xf8NqrOt1MQnAI4+6ba8FJnrg=
X-Google-Smtp-Source: AGHT+IHl6ePYvtMGFmBbMfWw54avkTlJ99i1th7vS7xvpsh0YXj+5bwujqI3mK986VA/yTsKBNzoJS8MFQ==
X-Received: from wmd16.prod.google.com ([2002:a05:600c:6050:b0:46e:37d6:c1a6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3149:b0:477:942:7521
 with SMTP id 5b1f17b1804b1-477307e285dmr143199215e9.14.1762261152816; Tue, 04
 Nov 2025 04:59:12 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:04 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-7-tabba@google.com>
Subject: [PATCH v1 6/8] KVM: arm64: Fix MTE flag initialization for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The function pkvm_init_features_from_host() initializes guest
features, propagating them from the host. The logic to propagate
KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
has a couple of issues.

First, the check was in the common path, before the divergence for
protected and non-protected VMs. For non-protected VMs, this was
unnecessary, as 'kvm->arch.flags' is completely overwritten by
host_arch_flags immediately after, which already contains the MTE flag.
For protected VMs, this was setting the flag even if the feature is not
allowed.

Second, the check was reading 'host_kvm->arch.flags' instead of using
the local 'host_arch_flags', which is read once from the host flags.

This patch fixes these issues by moving the MTE flag check to be inside
the protected-VM-only path, checking if the feature is allowed, and
changing it to use the correct host_arch_flags local variable. This
ensures non-protected VMs get the flag via the bulk copy, and protected
VMs get it via an explicit check.

Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index df0c59a29b35..b64f278ac8cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -337,9 +337,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* CTR_EL0 is always under host control, even for protected VMs. */
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 
-	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
-		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
-
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
@@ -372,6 +369,11 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
 	}
 
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE)) {
+		set_bit(KVM_CAP_ARM_MTE, allowed_features);
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
+	}
+
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 }
-- 
2.51.2.997.g839fc31de9-goog

