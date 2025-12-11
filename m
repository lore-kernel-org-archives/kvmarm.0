Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00343303C8A
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450037; cv=none; b=s608b3GHjns1c9KJVsgWRvoPg64vjD7Bcscpha6bK1jh4mKFZ4f6v/uhO+tjp9uCg/jJrT9R6V0dqYth1a0rI1o91dEift7FLM2h55JcZKecJ/PElnWXc9XAmfwGzHEtg4YG0FBEFXyOVvXXutaaUXqAqlhrjmFrfz+V3CnvPAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450037; c=relaxed/simple;
	bh=NTk2TBKR3NFQM3CU6lHdM6R7KQdGzetpmIRNgurSRbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fiZCSJZYEmv+SErFuMp8l5qmg74S2GmGy7b/Ab2ZfVWcFS3Nm7W/SnlkNGb48wdI/x99+sW6Hore1PVPZW7Jm+/M6jopoDEGPiJcgZev4cpGqCIoy6kQ8kJeJLBN+Igukcb/59QFooKm4hjwCXGrzSwYLdVqn0OrSBp7h2oYuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vwCbzJoB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vwCbzJoB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477771366cbso5462545e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450033; x=1766054833; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mValPcwACRy95uuY5pnqFzrcPHP+hh6+YUkltCWOAGw=;
        b=vwCbzJoBtOPfKFFDq5HnZGRrVkwnA55cbRQfXxDCFKrN6IqdcPFbod5RBB302CJN1o
         7FQcP3rwgma8CTMsmUw7yIGjqdteXBhHoGNyYuXgdCf+aUuSod1w73xDpgspUfZx2qwE
         eLAZ6WaDUfAXE9/Yu2eep7xywXWKPW/a3LVJ+e34kxChPL8Li5Sd4xNhIyMWZlQBXbBD
         3J98+5p/wE8SKbwK//LpRBTNxRhSdvMHaAyKeAubdqwuREUBaebfSr1CJcY1vFAiLtuN
         Yfyl3xrEjSL0yB2e3I8wqhPspvgr9BrwrysTz4xFfRasARmAO1K4JsRkx7g+SCikVZOw
         yH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450033; x=1766054833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mValPcwACRy95uuY5pnqFzrcPHP+hh6+YUkltCWOAGw=;
        b=SBugSfSqY7pIFDmnF736jofUo2bcCE1pWRohDur3nGRUPx+ate0W99GKagYlh4fDNg
         hVzZU0sGdm/DwKvKZxKLUu8gvfR4k5y3OSuYJnMTORQlYN9CTD0kL8vO89aK0HkbmUpf
         6/M+xS7jTqlt6jc5o3NwuMyZ02YAMDkrazdP/DExWHeVpviOpjAReVGKvXk8+u/JcukJ
         ykuYDJiN7HvxSoaUXgqqHWxDrmdqZWRTGXHOEW0aSqBSxSzJKjLm1swGhtsCZtjXyviw
         ZKOS9HOI8DKlBJmYGe6Vk7hovERokFVXLnMTdswtFd4ngGCos1597qIOIglDlw2gKI74
         BDNg==
X-Gm-Message-State: AOJu0YzqQc6/wN2aHBMznzVBlVtQQPsZxjMAbtf4XSFV1qlPMz9jMMjG
	rf/qMvrRoU1iP7uzTu1rpujNbVpWgq3mDIFlZHWmToOPuX5JW4eFuO3334+iowWexYsVHa1PoTN
	oj0PulpLRYZz+UBb0YA+URI472LTBz+lxe+1eDqqQVlCFcXSlTpC7VUzzEeKGRkS29w9oSxp50R
	0RelrPftbeug0Kgbw4530iGj/dinsQ98s=
X-Google-Smtp-Source: AGHT+IErJSD7jfhvgVk4mxext/rgabq/pIMU+ilqufVoZdB7wi8Jy+hGMcGmwSn39so/sLY/KAYqJoxz0g==
X-Received: from wmej11.prod.google.com ([2002:a05:600c:42cb:b0:479:35f9:3b87])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8889:10b0:477:3e0b:c0e3
 with SMTP id 5b1f17b1804b1-47a83e0fbe1mr38543215e9.32.1765450033601; Thu, 11
 Dec 2025 02:47:13 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:03 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-4-tabba@google.com>
Subject: [PATCH v6 3/9] KVM: arm64: Fix MTE flag initialization for protected VMs
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

Fix these by moving the MTE flag check inside the protected-VM-only
path, checking if the feature is allowed, and changing it to use the
correct host_arch_flags local variable. This ensures non-protected VMs
get the flag via the bulk copy, and protected VMs get it via an explicit
check.

Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index f6f8996c4f97..16d7bf493c18 100644
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
@@ -354,6 +351,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		return;
 	}
 
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE))
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
+
 	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
-- 
2.52.0.223.gf5cc29aaa4-goog

