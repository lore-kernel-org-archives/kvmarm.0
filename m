Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9657851FCCE
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801584; cv=none; b=WhQTVqQ0I3vH8UhFZ7BCCVi7nw3nZ5mV9UeqU1AyFaPkebxErTlubEjHOA080O4wOqVCKgjotUBtPDZi55MAjR0sevXWyGtqbkOB7Qs3/PwGouUzzyHdF//qWzjmFwTaxHkqBJtTtCrPgqT6PWwW53dCSzk8vG4OUHOjC9vT4jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801584; c=relaxed/simple;
	bh=AWCUXF43ysfgI41lpMKTvK41BHIZRzQWcWHwmf2PRAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ubEcsARS0i2cjHaZ6MjCSjBofcmZQ/jR4mD84lRe3pZCgUVQ0yoBWMl2Xc/DxneOdUI0dktGpOS0o3xSEq7Ot4lJxBo9THoQzV74hMEc64BvmXanYVSsM5LuV2u4ucuVGSnpn7cj7PW9aNFo3ozSUA/Bo3+FAAqOldRjh600DHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IxixeWnB; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IxixeWnB"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4994aebe932so48238135e9.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801581; x=1789406381; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pNLhfgvrYwznedAczU/yoh7OJ0T71JIKxZfqgfryA8Y=;
        b=IxixeWnBKPIlrOcR/qKWk2uwiqLFduSilKJ+6TFLdBCimOvV3BzWDHeJ7Hu7oqgo3X
         hlzhRvK/K5NrhUz9t6afHfOyKxr2haMNNwoCfKQlQwxXT4lFp/WFpqmX27FeJKW7CISG
         XOcmncX3v6dgNbIY9qz+f0XXnpR6yZi36MyU/ZQrCMnv/sWN4dqXRxlduykOmTnBD2iW
         9lKob69rmIfxFE5GBnKQbUBzV0KVS9bdrLqrgN0uu/Fxvc8hBFRz/qx8GKNB7VWpMjqo
         nQuZFTobHAs4ASNmi6aJA+lZD+LSTYMJmSG2aJ7hTraLUMp4PpQg9lKxmrClFHfm1gDZ
         i8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801581; x=1789406381;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pNLhfgvrYwznedAczU/yoh7OJ0T71JIKxZfqgfryA8Y=;
        b=LXhQugTKbTGNGr1mHktsrRx/1MyDDcSHg4gzl84aymxkkX5m8xUvmxYnfcq9Vy53v2
         WmUb3MD3sIcMgdQH2sPyHiCKEVwUIWYIgteVvsToZMCqBi2hCzbnPVLGiKK+IoDyBOIQ
         tU7OflDLqRdNJgbxDraRh7I54Y2003/yrs7Eej3m3G1ftbcMtmSWVvAEz8iz8E/KQfwn
         9f84NojqPCkoEXS4aHSc733EOsCgvfmkQEbImz0TROMMqu2x2v4yd+r9iOpsHmE16mnK
         x642f63bADie/y+q0GXnIKzA5pBRszqzGgnE/UwfUbBJ3+ReAtreA9N3fVsfHzfMmAK9
         4qkg==
X-Forwarded-Encrypted: i=1; AKwUvBx9hfOTEFypFUCoI88r0EsPOw1LENzSoTrU2OBcsl6ne3AmjSUR75jTUMGFWZa7GyLhy6L+R7E=@lists.linux.dev
X-Gm-Message-State: AFuF++msNdGbiKHSDdOovocSp8XEqt1vTQ+4yMCdH9GlX2rZM9+4uDJs
	DWIwkvr+ArCaUISRwc+X5iOCtE2UPuVkj0tLFGjOB5MeYKGOzhpbL+9eevcN84wUplvJ7E+zUm5
	WLd1BqiuMjrKx6qfhmS2jFUmLycUtvQ==
X-Received: from wmco24.prod.google.com ([2002:a05:600c:a318:b0:49c:caed:426c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6306:b0:49c:f5c0:aa76 with SMTP id 5b1f17b1804b1-49cf81e366amr589515835e9.5.1788801580595;
 Mon, 07 Sep 2026 10:19:40 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:25 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-4-sebastianene@google.com>
Subject: [PATCH v9 3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification unbind call and forward
the message to Trustzone.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 89872e12f9d4..a1ba4463d1ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -694,7 +694,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -913,6 +912,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
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
 	struct arm_smccc_1_2_regs res = {0};
@@ -978,6 +998,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.979.g7e5102b832-goog

