Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F4B3D8122
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937765; cv=none; b=p6JGsm48XlRBPVaWE1G0JRWfIuLzmyG/EKqGgREeFZv/OEYEmDBv5V+RrYdaIYTBIqMq/yEdjC9ZR/F1UAnRtRV9Xj9NGgMQ6fTNS/TVTNN/PrtLn0Q/HL2trtD6yLwK34PhL6eaoRw3QRGAu/iAHiX/ANA92zEqfGVAKk2ZlCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937765; c=relaxed/simple;
	bh=yyMo/IUPF6pLA2eoZ9AGkDfP9o0FQsa5VxDHxpU7Xgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=amIbqTjtK6NGMUJQjLM4X/U/O7Ih5LtXB6PZyYOBVpKbbiA1hXa3DVczQP+/FFo2WI/YDsBwx7RzqIvael4J0pWafqDuFsEJA0DOOuNjf2YPN1HEJFza5m7RPv6zMbe4//nvM7KcfARfo6jYnTGx/vkPXIOBS9j20tEr8zgdTQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G+SvNJAX; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G+SvNJAX"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b5d2e394so33347325e9.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937760; x=1781542560; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2857N0FYewLMeBt8Nj5klxJIE+MPtxOFSZN9bVePZ7w=;
        b=G+SvNJAXH+ydg+JEmd1C/s4tUTAV28EV4qJEHFc65YaQ6cJAGmQ7R2K/I0tZK1cM3b
         NUU9WR2pbFU7gxDxmWamn9pwNyP1oWASvvZrLvnqThyZb5MIu88s7kaxgXUYFssGTfQj
         GLWmZYbGqRt7JdVtJ38dghAsjJ503nzV6JiVka09qYSTu0ZaelJTFoVKxsJ6uc+NZT6I
         7czsVV46+pwMaM1V1f6zJfL4eN6h8X2GaphceCKgj6DhO61LwKXqs3Bu1bX+8XtfyPZ9
         A3k6SvLUbk/eilCCTmIarLgP6TJ5z4tQ4UL02hiYAz2oHsFGCVgvDZyypOnqqi3rcHv/
         5v4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937760; x=1781542560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2857N0FYewLMeBt8Nj5klxJIE+MPtxOFSZN9bVePZ7w=;
        b=LlnA9ePcv/S661h7WEw4wCkQLrO0ed729aANlxRCG6kRIu0gk/ICKEEEaLNQL3Slkk
         oSPDVC6ij+F7XJSi+xNjlGeq38Eee5vQjGBqro87XAurHSGYjFAiWDdEq3foP1O0NqOZ
         11jROarzn6b+Vj1uBVCFCcpHfyhBzrF1lrJhxuOXl8aKQ6IlrfIVg0VOrPpruPVJZL1O
         fsJVNNO4iu0Y3qULsTbTM0cfe562zu/8y3x6gGsqwbUdzGKEZ4tV4b0sLw9cKVcIjmMO
         mGdTHdm+BocdLYi48/MqwYlprgz2oyBxuV5uu8xfjI5R2sUz69U1O21oC4yNdGMn0IVY
         9Arw==
X-Forwarded-Encrypted: i=1; AFNElJ/HfArbh8+QNOiABt/moRpLK+Yz4HTrSuWjf6fvrT5w7lRa/c2s3n1TIKB+BolyOIuCIagWcv4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw14LOlnxzygKqsrCD3IW7kKRL3UzJhzcLhDTZgftvtNtr5gvn8
	Bk52K5xnObGnsVIsfS5Kx7RXPya2fQpmjOct6z0dltRtmLMC8ihqIIKb27W5TilAnPT6W3DtUDY
	vbZemDEJNNgjpuvLRyjXugKSRJjMozA==
X-Received: from wmqi7.prod.google.com ([2002:a05:600c:3547:b0:490:5e18:ff1c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34d2:b0:490:bbc4:76a6 with SMTP id 5b1f17b1804b1-490c25eea30mr291402965e9.21.1780937759935;
 Mon, 08 Jun 2026 09:55:59 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:46 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-5-sebastianene@google.com>
Subject: [PATCH v2 4/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
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
index eedb01955a45..ca285e89516e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -690,7 +690,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -939,6 +938,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
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
+	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
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
@@ -1006,6 +1026,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

