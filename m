Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0CD3D5237
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215661; cv=none; b=A0B6aqDoeWv6vd7smn+MBhZbkXK/eT0E1JMad8Qgwh3RDr53GiPPwz0dP2NtAGHpRZlidjX21AuRdOUotmGEX21lWMyVfECmtu9eFhMN/AUAZC6MrhYn7C9rSHv3JdTuST7/Qfz+rwU2C1MxwG0LeSp11IWf0uRRdYNzxT1z0t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215661; c=relaxed/simple;
	bh=gBUuV2mlGdMKuSeayu20eiObPVeJvZ100LSrcjuMx1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m3T2eylLFkZ8LORqrajRxWPRyBn/KGj617clJ3wxXzI0tYHbHEccajrQk4QFrMU7OdsgvWy9la7o6CVMqXdmcHC3Q32AHoFMLN9SKkK3OfW10jkVaqHyzi+UZluGPFHsGEqciR8RmSUoROSv0E/L54A/W43Frv7jz5VmCEBjM2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZRe7coX9; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZRe7coX9"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4694c8b44d9so1672322f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215655; x=1782820455; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8rDVjRX05LswWm3CoIhO4tKCfKLIFEXEGSybtuh+IOM=;
        b=ZRe7coX96WOykeyLw5eEy4ZBpDuCncLG5MR4k2OoYvaJILco81mPhrH3jT8LqePV6U
         yq/HiOlEMHlaGqcI7Bw5oSfz7sLqvoamt3zXalnw2wq53uEKQu/bs0pFTfhsp6Ea8SSH
         1PR4aP17okh5G/gOnzrXX+uEZerXhIEkOCIGZuIBJdDtxA1RmZZL0pERzCXNgUrzZT6y
         rzNu3n4aasl/kVJ3dPgs++7+HQfT8m0t/M7Amh9Pcy+37gAATRJ/IG7qcZWA2yyEKER8
         ETDuAZ6cq8HrEi7mto+9K2xSLhigHJawkiC68yMcRflq1M69dg8SG6KrM27H31mBbZef
         I+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215655; x=1782820455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rDVjRX05LswWm3CoIhO4tKCfKLIFEXEGSybtuh+IOM=;
        b=FYHCoUFgfyY1Qf0OuZ7SyrKPrCZsf3WnvEPEJywaYL8xN6sr+YVvHGvRzJlc60IuXc
         LagkGh4WZfUzxcb0coF5raHFkV65tjEwwlngxS7Xipv+dxal3c7QodKXzy2aNGAA0K/g
         mWl+DAeqx+dXhd4pXKIqRtNUPCSz0VDrgbfbHR6gnEGk7mL8njdXxXApKOV3Rt5eR2XS
         fVmKWZVoi4Jp1qurCfEpuU4dH5AlVdCHjhleP+2XbOUUI9L0qwZo8x9Wltj7CX88+cQO
         DT6oCvldomWBKZZSbjVYz1HHaGmP2e1eJ5HUbROrexOHPLlETX5v2fTPKF3kTL0KMhEH
         Sjqg==
X-Forwarded-Encrypted: i=1; AFNElJ/MOz4FQuUsOMxXUehjCITKB5ot6yNXJYQje2rfBtWJLYW4ViICe+eK69l/r/QbgZmpAwnf6GM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNREzfkMP1FBpsMXBiuGUX24W+Hw1POuYG/OB+foaUWkh/N1xJ
	4Edd1ISlEP2CeYWiYtaLkPFt7wJF6fZb9bRmoXzUYaHg9VJ8wb6VJMW6Gv5iD92Ja3X1q2/NC9v
	/hUYHb1CgeFCao527nxRC1LlVuXeEbQ==
X-Received: from wrus3.prod.google.com ([2002:a5d:6a83:0:b0:462:fc9c:4a7a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3acb:b0:490:44eb:c1dd with SMTP id 5b1f17b1804b1-4925b38682emr29908865e9.29.1782215654493;
 Tue, 23 Jun 2026 04:54:14 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:51 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-5-sebastianene@google.com>
Subject: [PATCH v5 4/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
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
index c7910ee4000d..4b9e2b6b7143 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -717,7 +717,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -957,6 +956,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
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
@@ -1027,6 +1047,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.786.g65d90a0328-goog

