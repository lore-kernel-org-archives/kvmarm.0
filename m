Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18AD134CC2
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884809; cv=none; b=nx4/Lq3e6OYyJ25VOpg/XsZjhV85IyaZq6gNlO5f6ATgVYi471t+xI9w2o+KEQ+VZ+NrPKrO2md3P3RZBu0kO3WxfisOSgN7JccSk3ddAykFglCo39cTdywEqXgXDszNRbC9UuzkiT7g0rJpR//PmyiOQUrL9+CwBficyLHmPj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884809; c=relaxed/simple;
	bh=xfinIn7GfZqh0FrRsH5ADhAEctacyEU19N8oC/clLdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QVwCtXFPhbOCzo1D0z4Y1pw+eO6MZNbscV135sGZpxJXJ3BCKl6cvCs+uiENUgV0IrYOny7kGfJxWvyXSNa8oU4pmoDOM5Kbik5bVdBbT0WGqlf5Pn/I94uCJIB5WlAeqPWezmmgbpgRG/19IHgzQmuO/eR21SeVdjvQi8zZF9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tC0jJuWO; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tC0jJuWO"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-346b8ef7e10so3651670f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884805; x=1714489605; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vgA5LePQE3eks+outqSgqSNC3FBP1l1l+3uPuOms5h8=;
        b=tC0jJuWOgsE3La2wxkd4TRlFclWGv3DkpNTFt8tWT+145QXHcU912vqOdwil0it/wj
         lVKBpVJpkSak7aFnnl1DBHct8O7xAW38seTmfglMv3LRqWPXFTUgqUd3c3m9OcCss/tf
         2oZNyE1JRB9KLUJMH2nIWM8aQ6UFQHR4PT+Nzy6ZY/2AV5cczRA5kYk9Cz1qnsfhUV+1
         cRqy0NtL1x9iOPFW3fIyvhbkQbLZqNRg2IhoZ2fNnlP8FfnEgxTCksTe3mlijyOR9kX3
         WXk47DFkmvLtfBULOhF6wFuouduPKufsgYspylXhBL5Uh4xRTdW5eRCW1H6AX+KYvI29
         lSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884805; x=1714489605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vgA5LePQE3eks+outqSgqSNC3FBP1l1l+3uPuOms5h8=;
        b=bgjBHDO+llLsxOy6ObBKQBm8f+QSthZscyZZmxvS9nXul0V5tEA5/QT5AxbQEJ1xyh
         dDTlFUzZeQ+AQx8YeedaVMTf3rZbOvhGXPvGLWktNs+yZEogd6ZfkJgX64N0rBXT8ok1
         piDO/wjExutV64gtTBSnkjlahw3UNulTEXRywSp7eQOoR+5SaQF+5vGdlF87P9Z7eHbG
         caRMKvVkHhR0OnqVkLLfO879xrn8HXwyDLIwIG0FgG7hzGpuVI5/3nvpedPwnPApOJWG
         YlPxtnMYSAu9oCkTGSp0fuE1nI0B7OpQgr93dPfnQGw7JVs7YOK7seCXhvF19wLc7bHS
         82Fw==
X-Gm-Message-State: AOJu0YyCfdVui5aHUj/lsiMDlVXDSOFyuwyjJ2owTCQ3jtPEiYepSOxx
	zwtHchka/maMN88kDgthSRSUMfrAvEjOUMATh5KNDz7ESD/a7ZsHcFpd0SP/UGaiUXv+GzXG4Oi
	CTgYp8IBJKkg2mB58kRuOeyKdrnAiomhsxDbu2qfSG2JpFqNdWDncz1raTtx+KD1Xv/eR3a4zjV
	aNgdkmAl4nD8rN9Mc3PMZorZnz3/w=
X-Google-Smtp-Source: AGHT+IEvixZydBn7CoNTVoj8GBECUr7KD921wn+HvyTegra27k0g/PLuMSGfi2Z3MQfnjcrAzWCU7xzkwA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:b4f:b0:343:c41b:3e37 with SMTP id
 dk15-20020a0560000b4f00b00343c41b3e37mr33330wrb.10.1713884805173; Tue, 23 Apr
 2024 08:06:45 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:36 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-29-tabba@google.com>
Subject: [PATCH v4 28/30] KVM: arm64: Refactor setting the return value in kvm_vm_ioctl_enable_cap()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Initialize r = -EINVAL to get rid of the error-path
initializations in kvm_vm_ioctl_enable_cap().

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e1003c782792..647c81ebdb1b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -73,8 +73,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
-	u64 new_cap;
+	int r = -EINVAL;
 
 	if (cap->flags)
 		return -EINVAL;
@@ -87,9 +86,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
-			r = -EINVAL;
-		} else {
+		if (system_supports_mte() && !kvm->created_vcpus) {
 			r = 0;
 			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		}
@@ -100,25 +97,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
 	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
-		new_cap = cap->args[0];
-
 		mutex_lock(&kvm->slots_lock);
 		/*
 		 * To keep things simple, allow changing the chunk
 		 * size only when no memory slots have been created.
 		 */
-		if (!kvm_are_all_memslots_empty(kvm)) {
-			r = -EINVAL;
-		} else if (new_cap && !kvm_is_block_size_supported(new_cap)) {
-			r = -EINVAL;
-		} else {
-			r = 0;
-			kvm->arch.mmu.split_page_chunk_size = new_cap;
+		if (kvm_are_all_memslots_empty(kvm)) {
+			u64 new_cap = cap->args[0];
+
+			if (!new_cap || kvm_is_block_size_supported(new_cap)) {
+				r = 0;
+				kvm->arch.mmu.split_page_chunk_size = new_cap;
+			}
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
 	default:
-		r = -EINVAL;
 		break;
 	}
 
-- 
2.44.0.769.g3c40516874-goog

