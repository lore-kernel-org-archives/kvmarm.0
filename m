Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7810B4657C8
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624530; cv=none; b=tj14AR1VaRX6XDukzTk6TeFSDz7jeswpbu4OPOURHqa6zFirjwALVaJaYLBJeKN4xePE19vafVpRl9wJ73mpIza1kRnRuwb0KVa8ZLiB4GhyZcs/NSqqbtC3taCKTIhPNfJLDJOUhrE4thvgmerIhCrk5KnwtqlIhAw1ac5y31w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624530; c=relaxed/simple;
	bh=0hMGdSg0LxWwUQvbPAP4+IuVhVENpwMcOzxYp4w0soI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7C4ug7qnrgzoJAVDWnHn0If3V68KGM6grZtB1UFIpBHd3b5tV3NKRfFxcL0zyzb6KNvtRSLdG3sHjEyEoU++0MzRttddhgyfwPwkEFUL8/O9NQ+JCmFFC6aIKdpSZOe8ikkGr4EzMoV5wiIIA9Sqa8yclHLekf1Mr2o0XD/7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ClX/HL7s; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ClX/HL7s"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490c840efe6so49808425e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624528; x=1782229328; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HDCvszfTGrfPrRQcbamAtNu8DMm5bIYeuf9FwhpYcNM=;
        b=ClX/HL7sYw9onhKBl2TS5quWA196juhdebk0iz8AsA6zSJr4CRraijpDf36dq2FDlA
         MgEx2uLXeJUedjGPFis/VZvRqYzLJaNiVWU+B4KPaj9Fn2du/zKtxU3qQb0gmH1AQ20S
         X2yWi/6nHb40ZcGz5cFtZ6sfXXjiMi73NzHOdThCAAPXWXmJ02znnLcuaLp8uxk6Hdav
         c8D85WJvkmRuWZQgnfakfAxqv1mavALRZ/aYVJBEgYstNy/kRZ9DabZbLN1HTHd8Nvrf
         8SKfe/ReRBASLbxcCGkdtar8Gr0W1ElZ6VB4FTZOTJGprWu6ktvf1uQnTqdu0t1prObm
         ThzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624528; x=1782229328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDCvszfTGrfPrRQcbamAtNu8DMm5bIYeuf9FwhpYcNM=;
        b=Gim2iQ+x04m2h4cLyPlTI4fKUOD+eyKBKIOYALwmZDXXFSKVyn26AA2v0LhCBy0AWk
         C5kakLaIGKiL/MlhdDvLwZsTRZLacozwmulkvFxyeUzuh6hudw6c9M6ObT6s3jmrB7cB
         8K8gNjdzgmzYsBV0lHW/33n2WQLMt2//Z8n/JKqyuawWoHUi5AkzsAOUu2bhN62sjPGH
         /qWFWjqeHAZLDOpblrFeKZuuTdAj1PZsAKYIqA9Iymj8cEcd7ZANFF6A+bOsq96SSuAU
         YcoPmGwoTkXaug49QPhzQTcqgIi3n8zbSruCWisJFlNA5DMZR0kVNg+B4RI7nRqnBTny
         SPaQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2BpRlhdb1UxkUdUFoMG87MEhAorZo96CuxPYMvHkSk3Ify4PkS0rHqtnQwt1oCviRov0bDqs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiVnChvgZrWtcrfpGJ1BGgYKc2VgUd1kUpH5HHVYOWffvYffFi
	gsoT3l0j1XKRWHq789vvI9wpycOFU5x57o6+JyQ7eAoAbxAU2UAX5Plu3HkqJDz3l8ujLeib8ua
	b8MTeifYD7+lKKQC6kwTzwCSTTFhgyQ==
X-Received: from wmpt39.prod.google.com ([2002:a05:600c:32a7:b0:490:b8a9:c86])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5248:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-492332d2c22mr2868755e9.6.1781624527303;
 Tue, 16 Jun 2026 08:42:07 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:44 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-3-sebastianene@google.com>
Subject: [PATCH v4 2/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap messages to be forwarded to
Trustzone from the host kernel driver enforce checking for
SBZ fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index c64c704f22f8..a72f6d4b62f0 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -713,8 +713,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_CREATE:
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -909,6 +907,27 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, func_id, ctxt, 0);
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (vmid != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -967,6 +986,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BITMAP_CREATE:
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
+		do_ffa_notif_bitmap(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

