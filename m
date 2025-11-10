Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFDB15A86D
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782334; cv=none; b=DoQBrQXhJRy+oM5085j0KhK8wVpyKPswozYcy7Mx+13wt381ddqQLZq5exKCLss1Yo/UXQz3ZzDG/sl+eM5WP9/kgp08oCMTEj1hjwxHCWz4gOnVwANDlwYhi0IbGuRg575IV62dqoCxDhXVJVr8Stl/ToFQhYVPDDcKEQqWrG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782334; c=relaxed/simple;
	bh=LtZ+xy+6GAqz2pgyTJ4UpXKdPo18TXRgRiZB+6Y5GrY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LMfOcRap/7FEzKkw+t8z3k/9EI/u4q9Q6oiHivy6/RYHy367aLdra+0jQ0qEPaQakZuV94bDhhMmXfJw9LD6C3PmARZsW9uE7gwY2V0y475oFLcjWchAExeu/f/CT0/D6by+fCgVAMxDJw/UfY1pw5r1YakCMjHcqj45cg/xGx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HuW6n2SF; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HuW6n2SF"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b70b1778687so291679166b.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782330; x=1763387130; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bnvq1QIttg+jEVzyus+aeQRnJPtIx7MHL8/OhLal3DI=;
        b=HuW6n2SFm7cjBjIdYrJPGYH9xmdMp1E34ecoackL90cQA3kdpdtLLHqR2oQ540FuIl
         YfAssfJ27klxtM8CrRiHyxSWrsz+5jX/fi+450n6yt7cF9E9WwrQVMyXCwdigQ1Dw5oe
         /WFmbmRlY9DqdDFLZ5GLzqdWoIw8oMRN/DbAc5lrcNKe9ez8nG/+qWaZ65W6R8Dsjpgh
         kqonx92E/jIchap7wXvsSLfjXQHe3CcqoUcG8bjhIAKeAtna18mskUdh5upb8PwhAyf1
         a59wwU9pZTu+AyRd5SMt5Vn656DjWa4MxKVP9C/g/3ekzBZQ+NKgf7rEDoJ7xJtjK9vk
         s1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782330; x=1763387130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bnvq1QIttg+jEVzyus+aeQRnJPtIx7MHL8/OhLal3DI=;
        b=V7cjtumkOiJA5p8aArfXLnGD8YXgdIQKpK4PRhblpydvRjulW/3bBLS1kbdQh71L9l
         M6IHp1oqyigvFM6bKyn44CRwoz57b9l2X678Vz1h6lZ9L0BfMAmDus8Tbj21a36TvJ6r
         nIh7uw+VSLsztEYwObkzP/QO+LXglGFq6GPT/OraVwmutPu3eIgf7mzBjeYWVPbaWOdR
         osLS5ko7zruNdOU/l71plQZw7Tr/VGH6GhFhlThCMzKsd3q779OxhwDvo25QLlpMFKNF
         o+fDS2PJlofsO+d8X63G8HJURauWtuqYq26PPRc+109RmndzIxMLt1M2RpFbedjH4Zcy
         wHwQ==
X-Gm-Message-State: AOJu0YyBZPsy4QGSA9AKUlkGZZ9A6M6PKGc3LgdEio4vO/7l24AMRNjW
	3zCnmOwHrn9N0nA3dvOYiC6xDNSOvThSMGcNE9xLqzcsec69aPd6gLhQau2MtU1ZI9LquseimWW
	rAJLVRGmQgjZ/y06kWWnZ35+OXMlNIv2mDguLOmRDLR6H76XvovREQCmJr9AA5r8Wy13E7lG95h
	mscP1BEL9re5lE81TsImhFN8V4dhdtdxM=
X-Google-Smtp-Source: AGHT+IHBjjL408OQ3kUNaY91Wy8G4uCCbmn4Vyrmppc2YqMZNLLoI2tXfPCB9UVbKq0+7zW77SJ6n9+EYA==
X-Received: from ejctb24.prod.google.com ([2002:a17:907:8b98:b0:b72:d021:e2de])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:2da3:b0:b72:7601:a321
 with SMTP id a640c23a62f3a-b72e05be4f5mr836051366b.57.1762782329966; Mon, 10
 Nov 2025 05:45:29 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:20 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-4-tabba@google.com>
Subject: [PATCH v3 3/8] KVM: arm64: Fix MTE flag initialization for protected VMs
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
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index f6f8996c4f97..7e370e31260d 100644
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
2.51.2.1041.gc1ab5b90ca-goog

