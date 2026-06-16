Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5042A438FEF
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607277; cv=none; b=S2KEzgAeqcZSCIIhkMDBMQS2susX9BIhc980hEXKRjMq4PG7OTRytbanMq1n0qz1bnMbfxm6TVYhKLp9UZZmSmLbfrFjMmIzwW6qU0bTxRajsFgp+pr7G2AWCUH/MmK6w0rpWnkcAYIukvlZ5Z9o+zSyMipXujUX0AvyUs6fxjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607277; c=relaxed/simple;
	bh=Agm+Ctlat4H+3Nw+TepLaz7IWysNnstjoNGy/xNkUgc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PBhXMTzpWsgCaVffdj5G0WBJydE7CmeR8DpIlyw+eqs2oMZuxPIJYayz4/tv9um5oP9rorH/uhEv73uh+gvT5C/SbTTosfRx84eZUhmYD0CUugrDeoMaps/dO93TeUzjdNFGELAcpT60UhrLQ1/sSlrRGFPKqFaSHm2TnYUcuOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qf/2g2rO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qf/2g2rO"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490bae3a39bso43565825e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607272; x=1782212072; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rOHLtsQ7Dkg79lD0jO5Fo0V8aU+vyRvk3bi+qkulMVA=;
        b=Qf/2g2rOFahoXon7oxutqln1TYWP7YEuR3Q8/u1uDlDL8cB3XgY4+0LKeyYuFzpqGT
         R6/KAKtX2oK3SI1oE6zIbZNNWtqoJovwcSiz/YOmNN3+eVom7QqxBR5oiJOcML+aE5VY
         RHilauB335Z2VkIuEfh6cmJDF7w0/AiJv868DZK8brV/iSbL3dAyaF4YU2Rsl37hl+nf
         pQoZ+sTlz/BkuqGutECkN7/bUJluB5YMh0Glck4nx09UOfPgv1qkqfGRZZSNO/IeMLpM
         n+gDW+pndjN4U51degtNDJ6/3sM93Bxe33p5iFXrTc5lQTQKNG8nW79xBtXPxuM3OV0E
         rSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607272; x=1782212072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOHLtsQ7Dkg79lD0jO5Fo0V8aU+vyRvk3bi+qkulMVA=;
        b=StFV5TGH6BQi96x2NrxVgsZ1amQyioTnYc1pJnRnTD30FlS2fXpXe68gBnkzQSujDz
         tcKIW/fVDIhFxWO2+4gYMsKoqBmuRTBONH/BgdDGsN5ZXUkOG1dMPhnQiIn6fQwL/czM
         GnP5J4KKbMTskgfqpdv2upeSLxYDJJ2ptsIIr4UVczbjwXDs9cjgZTu6pLvX3NeS267Y
         R6HbQ3pE4G/IMFHRc569L2v8y2+SI8JGebSgnpWB8kFw5NjidSjYrfH8JpTTpTdu4eKF
         CxQQvOsVYOTLNc9RGMWmrhzvhU7U7wiJZgNd85Lyz8h+o1I3c2N5NTE9StsvQBFQHBc1
         rBvw==
X-Forwarded-Encrypted: i=1; AFNElJ/JXuxITzmPrpO9XwOR98uYsJLE5iljwdRNs+zV4x+vIRHSzxM8hktIQQ5ahkob3JOdIvszs8M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzmjv7KhSMitJIPttrtaNjuMRvMUUZVGKShI9pH1fxPcQFgzG57
	EkCCJugGp/s13yivbigUjn6NmRnjMkyuU5pYVcvQjj+Jkq5XqeioxqFnTxNqb8D1fKFlJPK/OjS
	eXbQLT0Y+GN/Nz8yO5vJl/eCPqubRgQ==
X-Received: from wmjq15.prod.google.com ([2002:a7b:ce8f:0:b0:490:7e29:9cea])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d08:b0:492:2e93:1199 with SMTP id 5b1f17b1804b1-4922e9311a5mr65735675e9.15.1781607271681;
 Tue, 16 Jun 2026 03:54:31 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:14 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-8-sebastianene@google.com>
Subject: [PATCH v3 5/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
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
hypervisor to Trustzone and enforce MBZ/SBZ fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 9ec9bc9a8622..fcfaa441770d 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -715,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -976,6 +975,32 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
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
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
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
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1044,6 +1069,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

