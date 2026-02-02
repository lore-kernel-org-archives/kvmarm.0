Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A282DCF58
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 09:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026238; cv=none; b=i6SIdMoDlwfroIm4rW9rcNF4pduAWrHx2f8SfpUfum53o/hBx6L4Ah5U3aqYSaVsWVHynC028p/4lqXgHCvh2jBihBekwSehL3k3PvgROMJyCC3tU+0tMYOu+aThKH1/ky4r57n8S3vRxQldo+VH4hMqh/EKnYSDGO9ABw+nQjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026238; c=relaxed/simple;
	bh=McpcEFSPeqGeTz+B+AL6xVCJrRgiZy4Kf/HoS29sO+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PJ49SkkvSkCap6s6118u6DpgSBhjq3LjcZSD2y+gOzZvHhgIgpYpGfVsls4IUAq61IKzWZ/6Op48lXSVzdQRArRJVUNvDdElPFM9H8Ryb8QO/3XhyzGhNRAHBeZJ2G2PTM/vqyL92QUMYWzwa09oxCTGmw0Tjq8DfGhHMnJiVTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GlPzwBz3; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GlPzwBz3"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4806fce5ab1so25593195e9.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 01:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770026235; x=1770631035; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENzMwMoZWO8vLhCKa/do6yK+Nqm+qfwsFu4e8Q1TWrM=;
        b=GlPzwBz3hiDojyE67BPN9wyQhSyEFA+ZZAXilt+cQiv1zxTDni4SV4krdGUp8KPH7J
         +Wl3nePrwziIqdK9V7nnYoHqcVoVurjBlMLc8HWAb9mQC9RN5U4rSgddYAHW8EhP71Un
         MhB41vJaWv289Mj9ybDGsh86590klwtJLJRMJVFeK7D3aatVuh9es72Nnk7eA6wLn3rZ
         C1vZh4rAIXjEazkeFHt3R8cKkVfJYZ/2XNaEYOUbY8X56yrFMjmd9/DxZ8zutEl5qmPu
         Z35aT30r/pwPQfVveBnAAjvOqgzsCV7a5vYieR834myq9A7oE5G2lfnr+nbzrG+g3/TF
         MSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770026235; x=1770631035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENzMwMoZWO8vLhCKa/do6yK+Nqm+qfwsFu4e8Q1TWrM=;
        b=LgJiVz/5C8lAXigtqGeGSIQ+y5qcoxXRUjEUpmkywfbwbkZiuwIjjHRvr6dBW/E6Q1
         mt0gcv5aEpml65UUYUns2TH2b6tO55Bf7H9KVYT7ZPs/vFaTkixSjk4CBfB7PqdY5jkf
         QmVLHKKpkYOLbPJa3mGawqDj9FUqhxcTr7bvJeB6blzkk4zv0DHeFJ1jwGxvYdPfq/d9
         HvP7WNebdvkAwmUOKYrhqcMAlUhv78WEbUvGg8IpHSG9kgiowOGCmP+gsEl0rWe1L60L
         PANSfgCb7PVd/tu44u02vOPAQkkHD+uukLtDBEr9Vi3MfHKecxmEBKZbB6rS8F+f2BpP
         babA==
X-Gm-Message-State: AOJu0YzIN5rgjByT1SNXp289ZjVggdrDq8xzvoEo9AbXhBSN2j5IuqBn
	8WnG/D7rpXtjfm6PlOpKRciRv+GvqPt8TWaJIcBLdOpn6A1r4nwQVFQurGf8NHqYRRJUGGXoHJL
	vew==
X-Received: from wmbdn5.prod.google.com ([2002:a05:600c:6545:b0:480:69c2:3949])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:82cd:b0:482:ef72:5787
 with SMTP id 5b1f17b1804b1-482ef725dc0mr51293805e9.1.1770026235054; Mon, 02
 Feb 2026 01:57:15 -0800 (PST)
Date: Mon,  2 Feb 2026 09:57:14 +0000
In-Reply-To: <86wm0va4ni.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <86wm0va4ni.wl-maz@kernel.org>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202095714.4038391-1-tabba@google.com>
Subject: Re: [PATCH 20/20] KVM: arm64: Add debugfs file dumping computed RESx values
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

...

>
> Yes please. We might as well do the right thing, and I can fold that
> into my current series with you as a co-author.
>
> Thanks,

Here you go.

Cheers,
/fuad

---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/sys_regs.c         | 42 +++++--------------------------
 2 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 54072f6ec9d4..c82b071ade2a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,7 +375,6 @@ struct kvm_arch {
 
 	/* Iterator for idreg debugfs */
 	u8	idreg_debugfs_iter;
-	u16	sr_resx_iter;
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f3f92b489b58..d33c39ea8fad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5090,7 +5090,7 @@ static const struct seq_operations idregs_debug_sops = {
 
 DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
-static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
+static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, loff_t pos)
 {
 	unsigned long i, sr_idx = 0;
 
@@ -5100,10 +5100,8 @@ static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
 		if (r->reg < __SANITISED_REG_START__)
 			continue;
 
-		if (sr_idx == pos)
+		if (sr_idx++ == pos)
 			return r;
-
-		sr_idx++;
 	}
 
 	return NULL;
@@ -5112,22 +5110,11 @@ static const struct sys_reg_desc *sr_resx_find(struct kvm *kvm, u16 pos)
 static void *sr_resx_start(struct seq_file *s, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
-	u16 *iter;
-
-	guard(mutex)(&kvm->arch.config_lock);
 
 	if (!kvm->arch.sysreg_masks)
 		return NULL;
 
-	iter = &kvm->arch.sr_resx_iter;
-	if (*iter != (u16)~0)
-		return ERR_PTR(-EBUSY);
-
-	*iter = *pos;
-	if (!sr_resx_find(kvm, *iter))
-		iter = NULL;
-
-	return iter;
+	return (void *)sr_resx_find(kvm, *pos);
 }
 
 static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
@@ -5136,36 +5123,20 @@ static void *sr_resx_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	if (sr_resx_find(kvm, kvm->arch.sr_resx_iter + 1)) {
-		kvm->arch.sr_resx_iter++;
-
-		return &kvm->arch.sr_resx_iter;
-	}
-
-	return NULL;
+	return (void *)sr_resx_find(kvm, *pos);
 }
 
 static void sr_resx_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
-
-	if (IS_ERR(v))
-		return;
-
-	guard(mutex)(&kvm->arch.config_lock);
-
-	kvm->arch.sr_resx_iter = ~0;
 }
 
 static int sr_resx_show(struct seq_file *s, void *v)
 {
-	const struct sys_reg_desc *desc;
+	const struct sys_reg_desc *desc = v;
 	struct kvm *kvm = s->private;
 	struct resx resx;
 
-	desc = sr_resx_find(kvm, kvm->arch.sr_resx_iter);
-
-	if (!desc->name)
+	if (!desc)
 		return 0;
 
 	resx = kvm_get_sysreg_resx(kvm, desc->reg);
@@ -5188,7 +5159,6 @@ DEFINE_SEQ_ATTRIBUTE(sr_resx);
 void kvm_sys_regs_create_debugfs(struct kvm *kvm)
 {
 	kvm->arch.idreg_debugfs_iter = ~0;
-	kvm->arch.sr_resx_iter = ~0;
 
 	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
 			    &idregs_debug_fops);
-- 
2.53.0.rc1.225.gd81095ad13-goog

