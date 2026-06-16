Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D24C436355
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607275; cv=none; b=KDnOUu/4RJaWdOCfWSYeX0S0qcbK47pVG12hsgke3JfY1mTMTe4mHfUwxOasZ6pEAzww+qI780WRwia12x7XOP4RZoM7JSg1/n5GdIp9PkTdQJle+etS031ot1CLk8P03eCXkX3fAuDnfWuFCC9xcID4M3yOTWDyNRXjjZ042hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607275; c=relaxed/simple;
	bh=soqXRg7Xq6tEXhPI7rau7QKV1ExiKRib212yAMeripw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=okXU23JS7d71cigZweUcR2sH3JxjFHU/75s/DUMuyURhnQ247VPP7HQsm6AoVEVLFIhtJwyWd1bvF22oU88qfUhWMWWxVLOuRfibrXML1uO9SvcXWDrdgpQoWcvpF0hpkbpUGqzt8TGtpqG5zoaXyH8AdDlTn4SY3H85JchKDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tWBlezMu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tWBlezMu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490c840efe6so47217625e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607271; x=1782212071; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YDR37+e/e3c1wPMzPsYmqv2c5CPvU7koE8nHI68hmNM=;
        b=tWBlezMuqQQPrWSwFaE2XW7XPmWUqDit8wLmTCbyJF9MANWaQZVwFj0wrpZmTRciY8
         1Bsh3c1IY7i+MdUBGm+VNUfh3YFIr3VeiSDENE6ksREMiJJ1pZYtMcekP40jLsb+QmYK
         ld6f4RdUm/NHAm5kY08B1PoJLH0T4Nwaa0/FBQFez8KZbsGbC6OmJ7Euo8rhsQ96mVej
         uMYfXntVw5guZU43BfFyx27z/CVGfSYFMyTNkRNiLhNSXvtkK9vAlwPrOvjC7plxj/PV
         0178WUHjvctws0DicLbu6BwCqWZmS9dWbcb6drDky0QUhS2SlPopDqp5MQOHGh+KwpLX
         /hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607271; x=1782212071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YDR37+e/e3c1wPMzPsYmqv2c5CPvU7koE8nHI68hmNM=;
        b=jV5rPHlbnwabR4tlVcPUy17D7HuBeCXPJpbOGbUpcI0/lvAQ3QgU6TR9aRvcnLg87w
         WE5CuVhXZV4LiMIh/HbCF1FziAFncdHROyueGRyzJWbN5Hw3jiNZXGfO5XCfMoIBxzob
         zW9PDQWssqaUX7CB01kaAHmWj6ypLEp8KjLa/67bPTqts+/Kp2fs2TvyBaPscqnmY6c/
         AWQzlYd/QJX4Ue5WNLcPQA03p6nlN8kIXtYWT1KvBBFRhQwJmEwf8V0QOeD/tnW5GFxj
         tZhO8TcCXfgy1c6WZ1eZuTnkRpuzZR97Fb9X17gq/H1+V2cQAGu5v3lnwEtz5Amkkoa5
         JOJQ==
X-Forwarded-Encrypted: i=1; AFNElJ//onUGSDHwEdMxUfrAYulZsFdR993Ch2LOeHq8ecunuQY2A+yON0Y1krB/dx/80Dn22b8Q3/c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyF9lpm4SME/CLZoz8TEeqTLIu3CqBflnnOIKD2N0vNjtjlCcW/
	DuChE08RATl/rwdczjhBVZ95Zx9i+xe0vSsmG7u2ZlXPZ9sEQwGKqjfCilkwyaA7z8vp5t1ijB/
	iHhGDXU0Gc9EkRdrK/qnKKHCZcjAgsg==
X-Received: from wmkg1.prod.google.com ([2002:a7b:c4c1:0:b0:490:d981:b3df])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:821a:b0:490:3cf0:8d81 with SMTP id 5b1f17b1804b1-4922faf12edmr43932515e9.13.1781607270458;
 Tue, 16 Jun 2026 03:54:30 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:13 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-7-sebastianene@google.com>
Subject: [PATCH v3 4/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
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
index 3d8ed829f558..9ec9bc9a8622 100644
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
@@ -956,6 +955,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
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
@@ -1021,6 +1041,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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

