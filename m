Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88A36683B
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 13:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770037517; cv=none; b=uHk2DCpompkYDzsl44IloYFPfal+samlwHfgj/w91Y4tpo619MfmMg9jCuLrwFSopqPqlTXzd2IYl6km7LAHpeRuBltcCoabbv8NXWNmCXo4e84T5oT7lM1q5+IO8MSyr0bqe9ICRTl+KuqIIVMeKTzDChMKFMSR2c9WSWpwG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770037517; c=relaxed/simple;
	bh=N5ZvmT0iIKACEc12ObQnujbtPmQ6zFf/rwBQv1kZPAc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BVRINMpgSk+ggiOwBWTD7kHM2lelHB7aDEYDgugYp+sZvh20JkbgeWoJk0DAEUvOvSc/kD/Fw7EnZb6NgTR/RjhNw3NhAGMx921L1e29qQBfcOsiz3G2jEAwSQYtqSRQvXP5vktgAdiN3VeX/3VstNVxZTUshEKWY7q3cojZK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Kc7jgVN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Kc7jgVN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4803e8b6007so34253325e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 05:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770037514; x=1770642314; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DaIRa8+hj7hUcUtCLpq5uVaY4q/WBE+WwNIl0Oyop/g=;
        b=4Kc7jgVNPWvcAg3u610YmJLHq7A8h9hBEgePHRqvI0jtDGo0jiVYhYlH92El8cMwSW
         Y6BSFve3Y6FoLAqEtFGoIBual42OGUnXxMnnRLuqay7Q54SF0tqj3fXHdN41Lan9Tdt3
         EKIbTTkb7vJA3SW+7dA30GgmpjcItbmRdN17F1w1emq+NaS3gCXCzLc88VTowhO31Y6m
         glVn1SzOke1tNt5wh/BvRva2XiqXO4Q/lsu4DgwnJB3OvGx19cV9W5VG0GBdi6q733+g
         Fel0aQ9ZiMx7VvsZjvDzi5fcVN8LXNpMWNfI8ZPiP/DGKtnFJKownOD9mUJsVyamaO2T
         tA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770037514; x=1770642314;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DaIRa8+hj7hUcUtCLpq5uVaY4q/WBE+WwNIl0Oyop/g=;
        b=pjPhED47ea/tsLzv8kvVd1mhkcH7vFXNMcPxPNecB/9tYiDaZfHX3SxklGZlzjYyDY
         eAp3a33OYnzrPe7mod/NljQheeLExn0dmZ9NZH7yrxf++lzsyXwJOnCB7sZdiAEj7JiK
         FQrGkOet7NzF8GyhsIXNuy77ASAe6Nj2Rp8n2zj4WBxxYLm2LhNYBnd2B+2SXpkss2l8
         +9TAIamhr8K+v1egEmFz4fgp3bK8n+/in/EZn4svUxq0iY60wvG05dtXfBaYHKc1L0r2
         mTihBSVF4EsvHXcX6UT05/KGzLBiNtK4OcnmwYZU8YA2INj51KCHlLShYZp4bxQP4q7G
         Esxw==
X-Forwarded-Encrypted: i=1; AJvYcCWYXUHxFrGNAI3Uj0I2j0bvfUK1J3rrlRns1kKjcC9UbsLqfQ+ABmxqdIMbeR3+g8diESCRJ/8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZNuAxUc+N2EX4UYe25eEgYw3BEdQCx8rZ0z4n/qANqKbh+6kT
	dLgB5dieRN/YA2uEh4jzBiVuFM7yrMQ8yO3sgCKMYuPSXaM3VaKTbnZqP+82P3CezUNiSVqUWLv
	P9g==
X-Received: from wmnv9.prod.google.com ([2002:a05:600c:4449:b0:477:9976:8214])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a00a:b0:480:69b6:dfed
 with SMTP id 5b1f17b1804b1-482db47d0d1mr157567225e9.24.1770037514308; Mon, 02
 Feb 2026 05:05:14 -0800 (PST)
Date: Mon,  2 Feb 2026 13:04:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202130513.49436-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: nv: Use kvm_phys_size() for VNCR invalidation range
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

KVM: arm64: nv: Use kvm_phys_size() for VNCR invalidation range

Protected mode uses `pkvm_mappings` of the union inside `struct kvm_pgtable`.
This aliases `ia_bits`, which is used in non-protected mode.

Attempting to use `pgt->ia_bits` in kvm_nested_s2_unmap() and
kvm_nested_s2_wp() results in reading mapping pointers or state as a
shift amount. This triggers a UBSAN shift-out-of-bounds error:

    UBSAN: shift-out-of-bounds in arch/arm64/kvm/nested.c:1127:34
    shift exponent 174565952 is too large for 64-bit type 'unsigned long'
    Call trace:
     __ubsan_handle_shift_out_of_bounds+0x28c/0x2c0
     kvm_nested_s2_unmap+0x228/0x248
     kvm_arch_flush_shadow_memslot+0x98/0xc0
     kvm_set_memslot+0x248/0xce0

Fix this by using kvm_phys_size() to determine the IPA size. This helper
is independent of the software page table representation and works
correctly for both protected and non-protected modes, as it derives the
size directly from VTCR_EL2.

Fixes: 7270cc9157f47 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on Linux 6.19-rc8
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e72..eb9666ba15b4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1108,7 +1108,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
 	}
 
-	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
+	kvm_invalidate_vncr_ipa(kvm, 0, kvm_phys_size(&kvm->arch.mmu));
 }
 
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
@@ -1124,7 +1124,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 	}
 
-	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
+	kvm_invalidate_vncr_ipa(kvm, 0, kvm_phys_size(&kvm->arch.mmu));
 }
 
 void kvm_nested_s2_flush(struct kvm *kvm)

base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.53.0.rc1.225.gd81095ad13-goog

