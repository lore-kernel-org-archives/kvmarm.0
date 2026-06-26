Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2DD3E4C87
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459962; cv=none; b=Vf/TV6l5Pznbh7QHbCgIedu3z5+rbAyrRfHiCY/Y2n9HuDf//P0UKIfjD4PUoVxb0Y7rTJKfRTQxlSbE2APqO+b2krIWdaGAI7rA1LGcQvaT+J8A6NSxlcblXgQKFmOUUnIHY06rQZLQaVQXa/rYjpAq15J1i6vzNF47p8U5MKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459962; c=relaxed/simple;
	bh=mw61qrEShLN4em+7Zp/Kc0hPkSUzR3I//jfz8mh5fjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U3e0V3TESL50mY8CGNjO4xEXmoIzL2L+lYrBgIHFse3e/tZtfvM7vzpkJrzZZPsuznNceREXfxLzq0FAXgYSe3ezk6idcBnjjyjGNmjXym1NJ5cGq4aUx+jF5ebwCr5UjxLzWdIvR5NxfUaVVUO2NYOmkoJK8y+zS488I8z7oE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNNG7DSP; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNNG7DSP"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46c90c8fd42so426431f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459960; x=1783064760; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/ufGm0/gR8nHfEhXcbUb8L6QO2HXRkkGS5TfPgnqx4=;
        b=TNNG7DSPnl95tOvQ3GxKLgZA+BJYxMkUUFOJbUNMxZT1GslO2OFoodQpV23taLLuDr
         T1VwUGhgKVZTqYdiWFqc3M4riuRrdLWoVjlP6CHSd8dGg4x9ED7rV3+K0xrTDg9nPBQB
         Wze5r9WVI98S4FfSkPD5UJ6RO8pstZHfJ7eI7+hsCHkMTU9xjoYg1dlD01B/E5wiv5gI
         xZwGVV9t4NTZGre+vE3GV8HqYbYJ80TJYK07woQlen0ABI4fHM+MJS3FFRHwT/5wz/qa
         JK0KtmY4/tHGy6Gorj21uZiZNCeKDScHT1ApeVTt0XpIgBcgshnqpdEPXiLHvLgJWTLJ
         Oqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459960; x=1783064760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/ufGm0/gR8nHfEhXcbUb8L6QO2HXRkkGS5TfPgnqx4=;
        b=Ygi+buyLkyXIaL1PLVKHZ1VicjFo4UBdHCjs6ntDAuJjkCMwoBCL0w1soBa11T3og8
         dcNG8cC4sc+t4uPEp921pLLZoHrs/ECMv/5qbpiqpZxwyWSYPhzVPxuB8TzR+vfrf9G7
         GKhBupCiXTZu4m1P8IcwNlNvqNbSZDQ4fJzgIxHiPeM5y1DCTcya+k2GmqlZ41MyNLlm
         2RlDKNcgkp7T1yASF2UaaJ/Gl/mb1xk9tjtelJNNIartYqUOQwCCjB2bmgJBpDSbnS5q
         iWaJ6g6dWUMGnumIduzbPR+5XKuD9euC7S1GKJrUXl9Wre1uLxcYm3F+jvnv311GP0ZX
         CBWg==
X-Forwarded-Encrypted: i=1; AFNElJ9c/su/jneId6hLXB/5pr1e98G1GGZ8HhHsafLPWuF99eCjlN62k75ZmdEYNubjMCNjwSwLkfg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9JkpnA52G2G7ZEdBldybjcoXsukxYVf87xLxHlTIk653A3Yg7
	RCYka76JeFkb2MD9ZFfx4M1BMSUAKgI60JqqgEScxHaJZat3+z/G+Sb3wI0EdxDcbOfNX2H5dtC
	iQCUMbaxDL+KXtbTv01RKrpOxWY44Ug==
X-Received: from wmbjp13.prod.google.com ([2002:a05:600c:558d:b0:492:48ca:10da])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c3:b0:492:699e:3113 with SMTP id 5b1f17b1804b1-492699e319cmr34534395e9.35.1782459959740;
 Fri, 26 Jun 2026 00:45:59 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:40 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-3-sebastianene@google.com>
Subject: [PATCH v6 2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification bind call and forward the
message to Trustzone.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index ecc13b795f2c..331d9d0d8287 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -42,6 +42,8 @@
  */
 #define HOST_FFA_ID	0
 
+#define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
  * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
@@ -676,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -875,6 +876,27 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags > 1) {
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
@@ -937,6 +959,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

