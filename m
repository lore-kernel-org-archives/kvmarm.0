Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C9644E040
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624537; cv=none; b=kQvtn67uvYYSS9+OusLbODk+e2br8qU22eKPXAeznoGl9Io8+hXL9rdeAG9h1NXISAT55Hhu8VL4PiOH19Du325SzLZ3wiTqBE+Y+jyxP/Rl3mYVMnjHbTIt4gRj6ijnD5IXOPsuwqy1HSYA4t1cWDgicv23dUWR5qiAyQw5Ku0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624537; c=relaxed/simple;
	bh=zptgevR25CiCiySQHvfLxICZuFBXFFtymGqkQC9bt6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlluWrXmHFam5lQadk8MmL9lqko3VPhp6TgzOxfVq9hnVxdGw8T766v8/EIGfwWdBcNm0CxcvePyTK0tdkjxna0Wdp/nnLl1RF03RB/QmJnrcnAcwMb3MzY8UgHnl63jXWc/BEbzcJtYF+t0tjvjoVEDJOvGxOYQFW26NTQk4Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YS3qJkfE; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YS3qJkfE"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45ef9437b7aso2707124f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624534; x=1782229334; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wKil37HAzALzonWw/7fqaOm1BrpCO8SF3FKst/evun4=;
        b=YS3qJkfEdAj0cSBF8sS0ax0DS4dn+BNvHgbko0ZFtYp0wCoiznThF6/051z33QHqiR
         Fohz/nQn5D7DfFILUNL9H1HFpk3fxBWEjyN6rr7tltNyc4UO5BHZWf/AG4rqhf+GIwYk
         /8i0knBHHvPKTkxgAtSpneKxQPRyfSLwEgK4+w1Z5vkJRA6iRYStf8oSMcGqhiWPZrPI
         01KILc3wg0lTueISQyveEGdNwUqNZ5o1xtjbicE3nuBSViUMVpW+Q0JSQhx4W68nDSOF
         kukTigtmFB1LDVMkcVpQC469QuIkKjXKMh9Oeolzmgwn1oDeMCFqy0hG+0MDW4YbOOHO
         h5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624534; x=1782229334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wKil37HAzALzonWw/7fqaOm1BrpCO8SF3FKst/evun4=;
        b=kBb7O3l4dPIvNxHioZ3PCRbKyQfPyBXjMTlw/WnySmzpwGSQsJ41SSYFjCSTI9UbxV
         uTWeI69m687s3ReCJXLnO0a+IyZ4ye5ZUr/4kI0yw5BK+SP/SRCghBGUmm68rdWAldc6
         A93sVrAIywKJXTNnWyeIyH7wGoX6Xh0pAfpy4u0fJDQEPb+l3fKq78nnIhEtiw6MbYEI
         yWBR+6F3cXssfuj4vLT3GhT/YLXSREqFutPK0m2qM0QeKzaoIG/YCVSRK1phJx99lGSa
         MeN6F20pX4IKCySb0KLIwqVEKCckgGrEr6yXi7WzaxTmFSmzXHEj2zWSSsMqz/1q6dAO
         HIsw==
X-Forwarded-Encrypted: i=1; AFNElJ+FXd1zVBDV258H3HCY5Oat5V/Y4foNEr22Q0nzTkdJz0yNoRnUf7PQdvyZEGoS6sMAB9oK3HY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQ7m8bQKnujFtluQwYYxphyoXsyXETiTrUhqINiAh9HkDLOvYo
	FzWEPlVY/n5jdU+h1Msik3NKS1IEELFNbAiO64cPhPAND7dMQQ9UrpoDYiGHCe/okmzopuFvZ+v
	EVC6/JNntgKLkKU58Yv9lMYlikGXULw==
X-Received: from wmxb10-n1.prod.google.com ([2002:a05:600d:844a:10b0:490:bb60:cdf4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c0c8:b0:490:b446:fb8 with SMTP id 5b1f17b1804b1-492333af102mr792995e9.11.1781624534173;
 Tue, 16 Jun 2026 08:42:14 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:46 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-5-sebastianene@google.com>
Subject: [PATCH v4 4/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification unbind call and forward
the message to Trustzone.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1f38ad008675..adf8680f3266 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -715,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -955,6 +954,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, reserved, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 5) || reserved) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
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
@@ -1020,6 +1040,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

