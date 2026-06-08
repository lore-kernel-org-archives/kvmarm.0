Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A1C3DA7EE
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937765; cv=none; b=fu7/roejYoiH6w2B2oNGDLbdEImZMJP1r7nk7myXPW3T8Qf2hrx3D2T1wxpBQEf1V8Hj2xCNZrxeNrlJiUZoDuf/Hw8vZmPCk55TUeDwGSovJytyWfXkuZk+2ONvIjtlN91UhDVptq/BZQHH0u456nuV0wAkkgWxvveLUNqLHB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937765; c=relaxed/simple;
	bh=qq+RsWTJKd/YlKZQUHiTIrR6T6HfsiopDJCN8sVjqW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlIYY3OYZ6LkE8cAMFmC0qQ7A/oNJ4+1Ua3wSW2OHQn2OOf5lgTzXhjy68D9fGNL9814P+YWdWibOfjwUJSBVfqQ4HEzX1zjYy8yB2sqRkhGR8dT2naEvv1FqsK12lixmhDihxfIchOpWavpqXgcOIYgd+hoTVhOSIal65TKPrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oJVvlqqy; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oJVvlqqy"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490aadb1386so25795195e9.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937761; x=1781542561; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNn/w8nYqQgrzocdn7kSQyhyTudAsTnVKcbXP36Ndz4=;
        b=oJVvlqqyY1R5rWNuaHXtpURje8Q+/u/VpNIwULxDyCRcGfy3K6JM2cXXhH0NZ4E+Gp
         Jv36sOW1AaWd77MGc94j0u+26NcC50dcKp2fmH3Jd1XjJucnn0/slpRXJDMaQ7b2zB2F
         kzFaAL5SxF+EreGHapW31Uyn7MLWC76NBbnP8D4JO2rzpEgInaO8B77f9pzeD4qHBSO+
         1qXRDyLhe4QM1oZ7sWD4M2z5Cm2g1bQjqtG/K2QZIDs34D2ir41vDrJJQcN7al81Q4mf
         61BKmwagiFBtlMO3XmNPm5einBKo66oKOVqTCV18dCAyjrk4k4wNZ/+g9erzwNPMnZcC
         +dbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937761; x=1781542561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNn/w8nYqQgrzocdn7kSQyhyTudAsTnVKcbXP36Ndz4=;
        b=DsIo5HJmducFmfpZRlAowrqVcghq3CuZB/aA3OhSCkdpTLTIxT+gf5CDVdtdWAB8ko
         B8btFLmy5GtJSbHhD3O5YoImB6//DChLSV/CSM8YA44skM7c0OsjMeDzANvyuMgCc821
         fbrKvChNuF7D0L6Mfz9suPUOuAXINvE6wLh1a91mz5Q2XiUWFQgGRN3uIQfOuHDpHse4
         z4y/pGn5Pzo0avwHE6lI45uTBsdjiXEJJYokGY92lhZlsnwzuunn9kKh3Dn4PEXgcteE
         TB7WsO0xlxHMyB91em/XpY6ZI84l6CyVskrVOz5YCDwi6gPHTY5w4tTvSl7a4qUG/qR+
         zfBw==
X-Forwarded-Encrypted: i=1; AFNElJ/0gJJkv7sErWZYLkAX3vM/nDFWTSqiL0RitfeYB4H0Su1VE/XdxJo+j8GLP5DNQhGvq8X0cjY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxP4mEJi8XjPtgpMCzX1qzwgzQWTX+r8/udkzZQPxiKN6+C38Y5
	cvGMohBajN6MIPwvSwSgcPXQcx4EKrWqNvQJtJTBKoeqGsLTUPFMQomM/N64HoocdwTJFZ/rRkF
	/CTdNzAv5Rk8vI4fZm2kq32jSerTI/w==
X-Received: from wmpg21.prod.google.com ([2002:a05:600c:4c95:b0:490:aefa:cdf])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c29:b0:490:7df7:9190 with SMTP id 5b1f17b1804b1-490c2ceb6f6mr241823035e9.8.1780937761024;
 Mon, 08 Jun 2026 09:56:01 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:47 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-6-sebastianene@google.com>
Subject: [PATCH v2 5/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
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
index ca285e89516e..3270381679b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -690,7 +690,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -959,6 +958,32 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
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
@@ -1029,6 +1054,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

