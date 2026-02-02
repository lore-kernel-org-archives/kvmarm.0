Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92C2C3768
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022646; cv=none; b=hTL9K+IjHsFCKVsfMpaOzaHmub/7owBzyIrL8pTSw1MQsj66XTU7QuDBbW2oDMeTQCKSHsPu31K6aPNflla3j2m1RGRt8k1+YGySI+4ICGj6FnfGZ0Zlq76x+t6k/0r/5LtSfX10SZtgLUennD9TkZubTAMTxc2YYTukqULL0ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022646; c=relaxed/simple;
	bh=tcJKOrH2xCkEPHgXML6NiVu02FrkqYy3aC9ijl0I5cE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PoDkFi0tuZ4smNXFn+ooGQfe1oPMHkFzgQuq/kn2hUOyn4DO41ago0MTCzi2acTbV5ZNXmdOgH0bGNLAcmgo8AmcMHRj574bonsf77QmBrdzUyA06AZKXZChkgJSgEVTmVwqJLqahBvEGOwDb9ANTNxaJgKSRzpzNv2ry/XJQ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oBh3pkmb; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oBh3pkmb"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d4029340aso73819935e9.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 00:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022643; x=1770627443; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OoMXA35bVdlKlGkNfp2fyYW/VHkakTsU1N9xkHjNqUY=;
        b=oBh3pkmbU0t+q/E7qIzTEZx/0+a5HqBy3Em7LQLzWOKy3IoHjZ7Vk5tM8Tyd6e40wK
         hUw0LoWj1KXrI01L+ntRUBRUSoP53znn5AGsHSuUpHaVNU5AHZq8jTp8ghD2jNT2kfhy
         BNADe9kswgl0qbKH/NJQ7BsD9t9AIEB0rXidgmIWhP9ANEW5qyHeK/cmn1npRaiwwGqT
         mgXvpbdtr2mm3qTAK8H6RNn01bCkOGZbiy4r6kCxzbtmNv2gz9HcEazbstHAhKW4TqBC
         CY0y96xPN/HT0Rn+/ErRadxq6t73vI1IepgzyE8xJ2SM85P9HJaOirkJRtRocsGTxkJ6
         Ueiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022643; x=1770627443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OoMXA35bVdlKlGkNfp2fyYW/VHkakTsU1N9xkHjNqUY=;
        b=qxbuWxFBYd2L0X7FzYdDzJ54JppHzM+Sg2lPgA+KAP7v3IJ+umEUs1BgzFVnfpknik
         M3hJbAomKwznb2xsBJccFGuAf8Bwyjueh4ilIPmUyzyXqLjA0bKEjsRESafRrEbaEySI
         FEYDYHjf/t3wWsvL5Kx1e34ViEj6in1tdPFduuCCCZ+crmZ6luPwnWCvIZrkbCLNDowf
         JFp/59UnaznntNQdc5HHDEK0YaZRIfrEH37mZwfHyUwcpm3FfkHIKmbpjpKuyl0RznWP
         V8ICtK3j5qi0qlz5ai0LuVP84iJNl8YTPhrYYZwFR6vGY+B/YDPlsaBPV3lL+FmiPsIg
         Fq3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxEg5i8H4oR2RUMeos9zjwAqA86x7DJs45rXIFQ98CvdP9mCUcfCrwOgaC56MelH/A3G7IdQ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtdWXbAQHWdX+Wzn//tpJMK9NS4p0rKl8Qt2guR5q2H5CIkjWp
	ms7qQuNHzUJKVasI3WK3bnl9pxFQtJ5kxfFS0ll4CSOv8SoAxy1wfc6rM+TAGReQa1OJE6pq1+7
	khA==
X-Received: from wmpd26.prod.google.com ([2002:a05:600c:4c1a:b0:480:4a03:7b7d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6214:b0:480:1c53:208b
 with SMTP id 5b1f17b1804b1-482db49da0bmr129922045e9.36.1770022643392; Mon, 02
 Feb 2026 00:57:23 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:19 +0000
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260202085721.3954942-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-2-tabba@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Use standard seq_file iterator for idregs debugfs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The current implementation uses `idreg_debugfs_iter` in `struct
kvm_arch` to track the sequence position. This effectively makes the
iterator shared across all open file descriptors for the VM.

This approach has significant drawbacks:
- It enforces mutual exclusion, preventing concurrent reads of the
  debugfs file (returning -EBUSY).
- It relies on storing transient iterator state in the long-lived VM
  structure (`kvm_arch`).
- The use of `u8` for the iterator index imposes an implicit limit of
  255 registers. While not currently exceeded, this is fragile against
  future architectural growth. Switching to `loff_t` eliminates this
  overflow risk.

Refactor the implementation to use the standard `seq_file` iterator.
Instead of storing state in `kvm_arch`, rely on the `pos` argument
passed to the `start` and `next` callbacks, which tracks the logical
index specific to the file descriptor.

This change enables concurrent access and eliminates the
`idreg_debugfs_iter` field from `struct kvm_arch`.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 --
 arch/arm64/kvm/sys_regs.c         | 50 +++++--------------------------
 2 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..643a199f6e9e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,9 +373,6 @@ struct kvm_arch {
 	/* Maximum number of counters for the guest */
 	u8 nr_pmu_counters;
 
-	/* Iterator for idreg debugfs */
-	u8	idreg_debugfs_iter;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96..035bf049e2e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4995,7 +4995,7 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
+static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, loff_t pos)
 {
 	unsigned long i, idreg_idx = 0;
 
@@ -5005,10 +5005,8 @@ static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
 		if (!is_vm_ftr_id_reg(reg_to_encoding(r)))
 			continue;
 
-		if (idreg_idx == pos)
+		if (idreg_idx++ == pos)
 			return r;
-
-		idreg_idx++;
 	}
 
 	return NULL;
@@ -5017,23 +5015,11 @@ static const struct sys_reg_desc *idregs_debug_find(struct kvm *kvm, u8 pos)
 static void *idregs_debug_start(struct seq_file *s, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
-	u8 *iter;
 
-	mutex_lock(&kvm->arch.config_lock);
+	if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return NULL;
 
-	iter = &kvm->arch.idreg_debugfs_iter;
-	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags) &&
-	    *iter == (u8)~0) {
-		*iter = *pos;
-		if (!idregs_debug_find(kvm, *iter))
-			iter = NULL;
-	} else {
-		iter = ERR_PTR(-EBUSY);
-	}
-
-	mutex_unlock(&kvm->arch.config_lock);
-
-	return iter;
+	return (void *)idregs_debug_find(kvm, *pos);
 }
 
 static void *idregs_debug_next(struct seq_file *s, void *v, loff_t *pos)
@@ -5042,37 +5028,19 @@ static void *idregs_debug_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	if (idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter + 1)) {
-		kvm->arch.idreg_debugfs_iter++;
-
-		return &kvm->arch.idreg_debugfs_iter;
-	}
-
-	return NULL;
+	return (void *)idregs_debug_find(kvm, *pos);
 }
 
 static void idregs_debug_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
-
-	if (IS_ERR(v))
-		return;
-
-	mutex_lock(&kvm->arch.config_lock);
-
-	kvm->arch.idreg_debugfs_iter = ~0;
-
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 static int idregs_debug_show(struct seq_file *s, void *v)
 {
-	const struct sys_reg_desc *desc;
+	const struct sys_reg_desc *desc = v;
 	struct kvm *kvm = s->private;
 
-	desc = idregs_debug_find(kvm, kvm->arch.idreg_debugfs_iter);
-
-	if (!desc->name)
+	if (!desc)
 		return 0;
 
 	seq_printf(s, "%20s:\t%016llx\n",
@@ -5092,8 +5060,6 @@ DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
 void kvm_sys_regs_create_debugfs(struct kvm *kvm)
 {
-	kvm->arch.idreg_debugfs_iter = ~0;
-
 	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
 			    &idregs_debug_fops);
 }
-- 
2.53.0.rc1.225.gd81095ad13-goog

