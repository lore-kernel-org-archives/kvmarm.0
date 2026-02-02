Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411BE32F763
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 08:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022648; cv=none; b=Lh0PK/qFhrlOTK11Lm0HucNFzKfzl90JK7q4ndqBk9ADjIst/cl3NQ/wCCCIqdgY7G6P9pceYFhRZxn8egID9j7XxI3zSOtJzyH4tI8YfTanSATtEKl1OHMIQUtUS06Ut2HGKKzpLCttCjgCIizJqabXygebTFL+1Q49T14ULeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022648; c=relaxed/simple;
	bh=mimq3Ea6QsBhqEZaawbP5tbHpUK8J8WuXfTEv/BkgmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aZWEzfrDN9mytSEgR34uenMlJZ138+SrY+LjATjAzJNyGD0OtUBxRidhBPZ/NKO0j7M6+axUz+ZhBUiTjiJm7lY4kHspF2LTXIuaHD/L7ospAoTLrq6wXD7/Ab1tZOhuVWBTpvMjswPtrwiu7dqstI+Z3ZfKkIcpj2UEKd6vN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VH8GtWFh; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VH8GtWFh"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64d251b8c5dso4047859a12.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 00:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022645; x=1770627445; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4bYzuIeTIcCNGWSl8VjsJtqLHBazJT084269tJJreU=;
        b=VH8GtWFhk0XJI9KIxuvltAMonEAqgOjpOi8Z5K3oQasryuihEUbRZWfrum+JpyfGkv
         dfDPpOj3sPiuso++DN4p6nWvfTkgqC347MPrYYFsepmem7T8F28qSnC5Fx6mLlgDR+FI
         9Uyd4FiQ6QGCVsvyjBohVMCh72san1tKeq1diB8Dc5bUALBeBkKpuA8aga08EYbZ5FmB
         mIRHLPQRBB6DgoSuD1EG7iFFu32KDBMAiNtlpL49/W/fZnr6hRkenlW4ORwWGNOKhuYF
         sZCtF7oc1+l1Vj9fpEBbixUr/FpEWxXzcH6DsA91EXo7BfNabahkDhejB6P6UH7/9cH4
         i3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022645; x=1770627445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e4bYzuIeTIcCNGWSl8VjsJtqLHBazJT084269tJJreU=;
        b=emqMp7M3QadWWE/iP4JJqICvXiu5Dupw9Y/k6e+XKCHyRZ0ny8tCqcX5zRIUt26gja
         CLSmXOyeQ1SDhGbpiHFY89FiAN7yDgJuzNZaMsk1yusW8FF3rwRBRgvaqfxtf5sHxty+
         wpIwRh9k5Wp6Nx7L7L9GvmD6SYyVzNoDOpo/O0e/2qZzRnOYFGsM/w2zlUgggzcxd+VO
         oTCBv0dVQLoapN2Y1a3MVmOq7e8EnX2lw6wqbP9T4gNWdDT6EgWYr0Q55fRUZiPj0XY9
         RJFQGULoaFDkBcd3iXzDoWoCCSULG46fvBfLxlTtxobs6YHeOe9mRvFicFyK8rkyKAh3
         pQbA==
X-Forwarded-Encrypted: i=1; AJvYcCX8hb5wm8dFxyi6ziFwP0ZOF/98IX1NNLjW2bcMtNwYTr6xvp2lgnLKwIon6sbfSvil3lWUIhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsCVHhXF5zLXbXQJLTi4RhkqDqZpNf/EqzGO7bjeyOjSvXIGNo
	eycj4A4H1uNC6EwXYmR3Dz1Fs+nZz7+/pSUtbOVD3LeUCY8YFnwsiGGP2ggAVJ1gz3FjoR3NjfZ
	yNA==
X-Received: from edzh14.prod.google.com ([2002:a05:6402:94e:b0:64b:a7f2:4991])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:254c:b0:658:b55d:2822
 with SMTP id 4fb4d7f45d1cf-658de58d9cfmr6382582a12.16.1770022645475; Mon, 02
 Feb 2026 00:57:25 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:21 +0000
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260202085721.3954942-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-4-tabba@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Use standard seq_file iterator for
 vgic-debug debugfs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The current implementation uses `vgic_state_iter` in `struct
vgic_dist` to track the sequence position. This effectively makes the
iterator shared across all open file descriptors for the VM.

This approach has significant drawbacks:
- It enforces mutual exclusion, preventing concurrent reads of the
  debugfs file (returning -EBUSY).
- It relies on storing transient iterator state in the long-lived
  VM structure (`vgic_dist`).

Refactor the implementation to use the standard `seq_file` iterator.
Instead of storing state in `kvm_arch`, rely on the `pos` argument
passed to the `start` and `next` callbacks, which tracks the logical
index specific to the file descriptor.

This change enables concurrent access and eliminates the
`vgic_state_iter` field from `struct vgic_dist`.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 40 ++++++++++----------------------
 include/kvm/arm_vgic.h           |  3 ---
 2 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index ec3d0c1fe703..2c6776a1779b 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -104,58 +104,42 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter;
 
-	mutex_lock(&kvm->arch.config_lock);
-	iter = kvm->arch.vgic.iter;
-	if (iter) {
-		iter = ERR_PTR(-EBUSY);
-		goto out;
-	}
-
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter) {
-		iter = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	if (!iter)
+		return ERR_PTR(-ENOMEM);
 
 	iter_init(kvm, iter, *pos);
-	kvm->arch.vgic.iter = iter;
 
-	if (end_of_vgic(iter))
+	if (end_of_vgic(iter)) {
+		kfree(iter);
 		iter = NULL;
-out:
-	mutex_unlock(&kvm->arch.config_lock);
+	}
+
 	return iter;
 }
 
 static void *vgic_debug_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
-	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
+	struct vgic_state_iter *iter = v;
 
 	++*pos;
 	iter_next(kvm, iter);
-	if (end_of_vgic(iter))
+	if (end_of_vgic(iter)) {
+		kfree(iter);
 		iter = NULL;
+	}
 	return iter;
 }
 
 static void vgic_debug_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
-	struct vgic_state_iter *iter;
+	struct vgic_state_iter *iter = v;
 
-	/*
-	 * If the seq file wasn't properly opened, there's nothing to clearn
-	 * up.
-	 */
-	if (IS_ERR(v))
+	if (IS_ERR_OR_NULL(v))
 		return;
 
-	mutex_lock(&kvm->arch.config_lock);
-	iter = kvm->arch.vgic.iter;
 	kfree(iter);
-	kvm->arch.vgic.iter = NULL;
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 static void print_dist_state(struct seq_file *s, struct vgic_dist *dist,
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d32fafbd2907..f2eafc65bbf4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -302,9 +302,6 @@ struct vgic_dist {
 
 	struct xarray		lpi_xa;
 
-	/* used by vgic-debug */
-	struct vgic_state_iter *iter;
-
 	/*
 	 * GICv4 ITS per-VM data, containing the IRQ domain, the VPE
 	 * array, the property table pointer as well as allocation
-- 
2.53.0.rc1.225.gd81095ad13-goog

