Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE513E51DB
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459966; cv=none; b=KjVxp8OIVfPLCsAWLwoz/Tgwe8nm9uMxfJUXGVd5fg6qcTVUQDvDXfTWlY7HbBF7UaktwZrs7DPeQSxls6F307bttrZFEv7kVA4uGC52X7eg2z6HfOiTZXOagqDhtF0jHrgUnYyfac8CJMk8GjK/o7zVsxJpjOKpncnae5z9JEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459966; c=relaxed/simple;
	bh=tKYP+GZEflyKSlmPC4K0hHDZmwBpOjHjHt0haihLqJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZLHsKrSbba/lG9LfMSJFdi7Hxhjd4Re3h3m5UW9OBXWOcBa1k5ny4Llkk3dv3aGrZ61SPpdTmrplsfVTUTkiortZPhk4VatkWZ+ymbYVMUm9KUXLFtH8qNP0NAOvDnmlXauHdsR0lrZvR51n0CaRyKYg2NqLEW3Zgot5U/I4NRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALQ2qDHB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALQ2qDHB"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-460153ce644so338016f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459962; x=1783064762; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Nwcle4m1xhjtWQ5cG6kqMRZxeBIvD7DoAMnMMXwmNs=;
        b=ALQ2qDHBUtxebTHwcEKLWOn87WvOolQGPcnhloRbOXhrKAvKr/ElUzSdO6C987pSYR
         +G4R1vd3sIpC3boXT+rrBwD60+wIRlhoJffTrOOkRN9NMT0d+HuYGatul4z6Gc6OSu4z
         NHIL+uV50UN0suPiIApe/dc1uffDPBbyvZkGlg65dL5lJlhnlpoSTpemJY4r/33ZOmHh
         7bVmuDhqwRFrKxpOrcQGrNY78bhDYM5M0/NebiNbmpUkJ1JiCZa/edOe3JccN+3HnwU7
         Qk+teZLygJmmJAEAIUpDNMMeu2FP9KvTkoFb/zwG8fKgczdqn/BWEq4MqpvQc/qn+7fe
         ZSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459962; x=1783064762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Nwcle4m1xhjtWQ5cG6kqMRZxeBIvD7DoAMnMMXwmNs=;
        b=QexK/K6pbpt9cVAZzkivNNy+C/ZAQNo5Jc5u/D9qeZ171ViGehxNgtvBrjxecSAZj+
         9iGBFe/Aw0VOQ1PxbSnjiJEeZqw5Gr5emxdqtLnrW5ha/DBMD3T7FgrWGJrP0vY0Ok4d
         Fn7Mw6aJBT1ypxIbPXsVxT2j8dIwMhyVFvfG2ur1q8w0cU8IHebrQhQDWu5M9oiZMUb3
         JP1rr5u+eWEfuYh8FhJUfQL561xbdO/ZZSLcp+NhJWKEdjU4WYu9KuFBzZATW45/179H
         U2YUhOaDdR33H41jvnj2htJ/me9eN5Sf8BHGjc2/LuLmUwnFSo8tlGcrFZMLKZ+Ca+SV
         SSkA==
X-Forwarded-Encrypted: i=1; AHgh+Rr2legZzbmsZZS2qc9QFJA6lfXtgQOrNmQMVSlMyk95mw+PodWYc/J7EYl1LcPNNBm2QNVTciY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCgFr/+Iwfvr3nts68EKJcw3IBrDXiRvPHe/NWYXBKQJoc6Qub
	kF56/Hiw3EkITdSKrcUWwqwIcHsKZqQlZZ7uhwPv06TJnt13joGsheb7w6bufWAUFIO4BN8fII0
	sll9jA29ZneylCkQMN9/EtSe04K52zw==
X-Received: from wrbfy3.prod.google.com ([2002:a05:6000:2d83:b0:468:50b5:41e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1acb:b0:462:6aa1:4393 with SMTP id ffacd0b85a97d-46dbfe8cd41mr9176038f8f.4.1782459961593;
 Fri, 26 Jun 2026 00:46:01 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:41 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-4-sebastianene@google.com>
Subject: [PATCH v6 3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
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
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 331d9d0d8287..d52d7c4d5e7f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -678,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -897,6 +896,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, reserved, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (reserved) {
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
@@ -962,6 +982,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

