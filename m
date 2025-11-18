Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD912F1FC8
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462294; cv=none; b=VhBrKF0xXrRpCdzNZs78GWp5WFhVLht3twSsgF/zGIvkqhrlekbNrCJGVeSbB37uGyC/CLgQttSsWQaCLoms05TVioom/BLsEGWyTvavYS+lQuOWNQLgvpFJQ5ZM62NTWuE+3ZxVeyq8Je/y3gPcwfT+odAxB8v6F4Nl53ajU30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462294; c=relaxed/simple;
	bh=XxcaqtxRwjgEK16l/DsZ7uDaN5ZiLwPXtkAsmryi7SA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V/EEL86AeNiULjPkXh5DJZnuH9ilvCcIUGuZ3ERxDapPNBGSqyRS5K9t92dVxDPNS9BCy2a5eE4SSCIzM0PWjWfDxj4YirKDyEGdj9V8+FZYxNlJ3RstU03FbD0Er3h8B62Ed9dNlDUjfcaJMJa9W8VU1cF1fk0NYIGZB4wW3VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qFEnAVT8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qFEnAVT8"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477a95586f1so6190955e9.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462291; x=1764067091; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=unbOsFC7lC3Sk0k9z+89bFoeZWRx+lQUDVvLvg7/a5E=;
        b=qFEnAVT8/ZxCqARdkhdZbc3oJ2qi+d8695JH+7E/Kji9RGedLmHHv4ikaZ5PXuJ58h
         tx3zUrRsVqcIUpn3W48Sj6GxKOZJgCD2NqUt+pSjZVcFUjZZu+UWfHIvy1TRp+ZcycUD
         RisL2e1eM3Wx6aiClQUJ346CRjXsU2pZHCv+oo6hpmWjW0JXUQB1J9EAq+U5qmBPeJ3+
         RXijDsHxXL18aNMvVlA/riNoYQQnMdq01mLsCsyII9ypLdCExhxsA2jDxOKYm/1yYryD
         56z2OS3jDwKh/q3BLXo50Ez+5TfXcu6S76o0qgx3Mbp1vUowm5Cj0uvMTOjN/45+X22o
         RXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462291; x=1764067091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=unbOsFC7lC3Sk0k9z+89bFoeZWRx+lQUDVvLvg7/a5E=;
        b=jpns6jVCFL0liSURacbn0NUi6ecKa4dpTwvS/YM1vlj+2BBJqhoHNPlLPM7sZ/2DgC
         j/Xy4o0AHa9aOgxRaKpV76/Gbx0utqiTYsqKbSs8xhgdV8Ka+DbO8lI6OCgENKz3KaBr
         c2oG9fI0jen4z5K9qHmPBE+SemPFHbJvTgJwZASE+geNfYiULWMAgjOdapUuGV8rD7EL
         NIKDDJGR5ZQbX2tsWhVEE3/JEwyJ8D2jPZpkEDgaO31eL9OTs+AWziZwdoJOJvscnKMJ
         0gFtsnVDrsfl3K3xV5FvKf+AKgBJtBzkCmDqb3+NYUmHv18hTIbTLzUt19ogLr06w75O
         iXFQ==
X-Gm-Message-State: AOJu0YzLryyloGDz6y3yZxe+ytRzQcCxwbCdWLZyWxdZ2t6y7QSDS+7t
	e6FSim41Se8kFH0ieqgnDakJCoBSQlPIMFgpcSupbYDQ0P5yuH1/ndH8Kx/LvpCIWJti9Fb95Es
	6LPecKdEUpOwnPMEHv4IRoOZdOpYNhLMR+vx8B4yQ/Vw2y/obMcNn1BlZv2oem1Y+Ha0jLsHa3x
	pv2Hfta8sSsaS5JjnVt4O9LzU5zl3gpDU=
X-Google-Smtp-Source: AGHT+IE2uOWsWwOg/aSoJt/gaeh0LSFNR1KpaQMIFtZB7pbK2RWRU0iQCTfCVOINqILp4jWHmtPCHIlOyQ==
X-Received: from wmbjt22.prod.google.com ([2002:a05:600c:5696:b0:477:98de:d8aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3105:b0:477:6374:6347
 with SMTP id 5b1f17b1804b1-4778fe96b70mr150339635e9.22.1763462290724; Tue, 18
 Nov 2025 02:38:10 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:00 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-4-tabba@google.com>
Subject: [PATCH v5 3/9] KVM: arm64: Fix MTE flag initialization for protected VMs
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
2.52.0.rc1.455.g30608eb744-goog

