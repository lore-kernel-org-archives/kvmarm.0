Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B080A1E0DB3
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249311; cv=none; b=X833QYtgIdfQvilyeLxFVAt85mOGkkN5pB2BJUdKUqEWnRmD19XcuF5qFTKmgfZdB2bC93VlfcyNaZbHpA1MCpKu+eV0HkKgULq9o7NaSIH3yMiJb3PT0FCXSTiBHTI3CsULRfxlDN9eH8bsID35tR9jd7M4xq5VSaR8ESiDp5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249311; c=relaxed/simple;
	bh=rKeejWiSn3rS9WJieL9iNJ3hkzaerOqeXt7fqty4DZI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eSmb27zDs3J58+dQiUxEZ3hczdsWBoVkX0nAxV0BYp/py0WvO0wgSob6i1z2nU91qBl0u05rcLp8ZotQHSyTIqfNvMnRZF1bIcmgV65ibF/r083SVHELbuxlOv9HIVCQDXNcxWHplvWajypj9pbTBwC6Ajr99Sqr5+6myKjBZcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RoQQe+5n; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RoQQe+5n"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385ed79291eso7707011f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736249307; x=1736854107; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6RWe0aov1XUyPINE327G3Q+w+KMS4G74JxHKr2TJ/zY=;
        b=RoQQe+5n2sVkHHGQ4aLt0ix2XL2RAQOyyQGMMWWtBuucSRYmNAA+5qyikRD3wT9nJq
         EoO/lxUbcAyuW5t4Q45Hp/YbDQuox2eYs27Y7WE+5PHB4r5Er9oGw5sGs+h0gEBi/th8
         l5lBLYHh9s4rgKb9ln5AN5Nf2YAeFpdrsn3zdXtmWf2L3u5KXdmcGppE6Br1dXhjPhDB
         Vf85M58QtH4jwXj6fgEXiG00CPIFY12mbIRNaqpn9k9+IQ81pBwdwx1KtMs6tHnZCPFp
         ErN470xI9mXgGjuZQ4jV5KrLQSGvkKkFmuiLaa3nFq3B6bcQrQjHWBUehmm5bzjkaLiP
         zfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249307; x=1736854107;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6RWe0aov1XUyPINE327G3Q+w+KMS4G74JxHKr2TJ/zY=;
        b=LYn0GnBpKzRyCYp/CPG+4Ym7H5sXeWf6cx03jQ35eEMCu8KVhdwksgah4hdnyI7b02
         hJTXsiWeHeomLJP06HBr6tUOzsbLyiVWxrNB3dCE4NxZheE4iwzDP1iVGz3iPIe5vZ5R
         JvtT5udxiCnS81PsXOGXk39k1KXP/XHlDXkY3/zRLikSmJ4MoLqrLVE7ecclS49daNu/
         JKHex76pRzQWwLGPnZZY7OBZ7XJhK0qlHN/IzPEVbas/LVIxlY76vA1U7DePYobwbvZ7
         YQvmsDVCN/z9EVDeJGrstCpn6WNiJDmQ+GXjpFd7N+49MXWe+oc+LvijEwH7vM+GBVir
         yUxg==
X-Forwarded-Encrypted: i=1; AJvYcCUFFDOnknbmHqVSDdH+RWbNmhV8RtDuRQWH4J0ptApKOPCk1ALsLSbTH3jJYtbvwA1NkfbId4E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRmlXt7aVSVd6+q5d9TCHCokhZvr3bNF19xGtYeKpHz5y6xAh4
	1FgEdYKVXTVJUSPFjbf2PlBRNnScXYjqm1/6ZnO6zTW038e3ARqXJJ45G2luLOSE2rarTMZyh/i
	MosmR/IhqcHTtl95qAw==
X-Google-Smtp-Source: AGHT+IFaQ4XQ8bYbMRP59ehwt2favLhOBx+hmOWfdOiaSTTQVYQBJvmJGyD9CEXh9o9vauz+1OQ207ChACxpCbDs
X-Received: from wrbeh15.prod.google.com ([2002:a05:6000:410f:b0:386:33bc:1c9b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2c1:b0:385:e90a:b7de with SMTP id ffacd0b85a97d-38a7912c97emr2229999f8f.5.1736249307164;
 Tue, 07 Jan 2025 03:28:27 -0800 (PST)
Date: Tue,  7 Jan 2025 11:28:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250107112821.416591-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Fix nVHE stacktrace VA bits mask
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, zenghui.yu@linux.dev, 
	kvmarm@lists.linux.dev, kernel-team@android.com, 
	linux-arm-kernel@lists.infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor VA space size depends on both the ID map's
(IDMAP_VA_BITS) and the kernel stage-1 (VA_BITS). However, the
hypervisor stacktrace decoding is solely relying on VA_BITS. This is
especially an issue when VA_BITS < IDMAP_VA_BITS (i.e. VA_BITS is
39-bit): the hypervisor may have addresses bigger than the stacktrace is
masking.

Align this mask with hyp_va_bits.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 66d93e320ec8..2ddd98fd2df4 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -139,6 +139,8 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
+extern u32 __hyp_va_bits;
+
 /*
  * We currently support using a VM-specified IPA size. For backward
  * compatibility, the default IPA size is fixed to 40bits.
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..d36be6d2ac91 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -29,6 +29,8 @@ static unsigned long __ro_after_init hyp_idmap_start;
 static unsigned long __ro_after_init hyp_idmap_end;
 static phys_addr_t __ro_after_init hyp_idmap_vector;
 
+u32 __ro_after_init __hyp_va_bits;
+
 static unsigned long __ro_after_init io_map_base;
 
 static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
@@ -2056,6 +2058,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 		goto out_destroy_pgtable;
 
 	io_map_base = hyp_idmap_start;
+	__hyp_va_bits = *hyp_va_bits;
 	return 0;
 
 out_destroy_pgtable:
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 3ace5b75813b..fdedd8a3ed6f 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_mmu.h>
 #include <asm/stacktrace/nvhe.h>
 
 static struct stack_info stackinfo_get_overflow(void)
@@ -145,7 +146,7 @@ static void unwind(struct unwind_state *state,
  */
 static bool kvm_nvhe_dump_backtrace_entry(void *arg, unsigned long where)
 {
-	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+	unsigned long va_mask = GENMASK_ULL(__hyp_va_bits - 1, 0);
 	unsigned long hyp_offset = (unsigned long)arg;
 
 	/* Mask tags and convert to kern addr */

base-commit: 13563da6ffcf49b8b45772e40b35f96926a7ee1e
-- 
2.47.1.613.gc27f4b7a9f-goog

