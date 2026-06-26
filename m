Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ED33E5567
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459967; cv=none; b=EgP2/NjvNDPrNxu0tLBkyOFV9ohTJ03CVccjCyVYSQ3zAqwzXigPEIZhSfzhVsJ3ChGKNqlgLkdNV1cCQdswy6nnMSa0dC+dpEZn62bTJ+qPtaz38P9kLAsNHUiYvzDqv/iuO3si2LU5XVdFLBNz0Z8hRjIepXe+WPYXf9BtoTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459967; c=relaxed/simple;
	bh=A9iEB7RoLYR7o3b9JIWmxzrK9nW9JHyaFAr0Gs34LmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=unBYz3IE+8wP6g8K3JkpWgOCU2FIiMDaG2E95+xgabvBCHk/y0R5e0BGdAo+raS21K8QKmLHxCYfiCm0OVxiTBau002cLLUKkVuRsV6C0xg1OycAYlMvyDWE4AUUb9jVzBEyGAcB5ivz9KYeXwc+EhT9xqljysaLlUsdLPrxwOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DppuBNMN; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DppuBNMN"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-695bbac451bso774100a12.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459965; x=1783064765; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mgEdqVZzkg8EdfvsvaTXXYI6aDMdt2t7UIchiBP7OMQ=;
        b=DppuBNMNc72sLj23LQbsf9zOmbR2czDFcjM1U8ERLcFOoTaczfep5U9ki3TNiKASXX
         /uFB654qKim+NKeoXcT8e3Prrn8xlJFydQWrqDsYx50ZGLXc0PoFMHk1ol/mDBWBxu2V
         TJJcBbNuzm/zhl93pXqRearXhYVcin6N5hAmE7E2+fVAVtMoyDJibwvHrb8XrcQ7Laiv
         1snuKW906BRcUtb6rbwmrFwKgKHwn9BzOaXfydTles6310Y7ME4NNfwvrXKuD93b+eKa
         w3OTVcvZBLrDyiu3Y2VNx+jFaGm509KcotjQAJt/xD8QLF7i1pQ1x0KZQiosWaos2GGs
         nhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459965; x=1783064765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgEdqVZzkg8EdfvsvaTXXYI6aDMdt2t7UIchiBP7OMQ=;
        b=SxMkw1Va+JF/u7OBGmfIlFamEPy40qREzWxeOiN+d4Idp43QTpj5gZeOJLiVRossNO
         UTcuLRBcGJWjBYbZYg0gT5r/B6SoDYeRAJQRqG8JTdlBLLeHGrNhcRHuuXGyS906kQcu
         KEyM1X+dzZqqaCLpjzT6cuXkMhvkT3SJnMplpXkLTLTXgvjCn6pvKhy/+8WKLtYYjekw
         +qfu4X6QiufG8K2zh35Je3j1dHUPoRsIiV7dbGtzAejMy1ExMjkKYKiihORjX8M8lfqg
         df6r3xC7smWIqDDMWTdDtqadXtQzl2YFya7ojX/ljt7ZBxE5SDwYhb3Gv9RfNECw9zAH
         5upg==
X-Forwarded-Encrypted: i=1; AHgh+Rq+CBWceCMOrCdYroK5BZQpNaWVO/qufbN1b1j7OiTQnW2L4ixsPDvdZgVHOhO2LmZ/+og/Xfg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGmdjlWOds1RU1HYUyQxZvXit1DUotx4izjmIm5OLaczmGTVYC
	HoIDvk+VMy3O1VQzpQy9SbCGOSMh2NfD+t4jig0phWMzDhsrAmlhPIX3KRZ5Ckm//NXxqRxIk9r
	OWPZJtof8IOu2opj2Yikvn8kI0yO5GA==
X-Received: from ejeb22.prod.google.com ([2002:a17:906:1956:b0:bef:4b4a:fd4c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:702:b0:c12:1651:17b2 with SMTP id a640c23a62f3a-c1216511edamr222936566b.9.1782459964269;
 Fri, 26 Jun 2026 00:46:04 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:42 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-5-sebastianene@google.com>
Subject: [PATCH v6 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification SET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index d52d7c4d5e7f..2bb16aa414f9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -43,6 +43,7 @@
 #define HOST_FFA_ID	0
 
 #define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
 
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
@@ -678,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -917,6 +917,27 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
+			     struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags & GENMASK(15, 2)) {
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
@@ -985,6 +1006,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

