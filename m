Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035E247DD64
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327225; cv=none; b=QLsYyjKmY6r3a1Ia4/q2gOn+aBkaNIqDWwfrEkGxLCeLS1WGvbZPorVwmYp8smR5Q4PUZwdzEDUzo+Wz+znrEwcbr7IW6gU97G9Ex568HCgwIJWEIy72KVMa8EFXVNowvni/jAufCnM1T/gNATP83HE1JqnAv3OoKa+bHGgWTxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327225; c=relaxed/simple;
	bh=3FzMbyoVgcn9kaVOFbhZbsOMdz9Y6Ef7VAmdCGaY4Qg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pUmYnqZ0tdbpCj2AiloZO3Ibw8mrlFExeGpA6C0pEDUb+XWRkSRB+Neju4ZoqGfNfUIcsFaPPOZVnkuOJ9TBLhM9/mDG2aTu4YUyye2pmDutHX+U4ejiaKiyvkFbczmU6+OuI8an7IyGRp1Xzjhyettjt5VVGuZLB5DptM+mF7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndW88LJT; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndW88LJT"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493a7fa8481so13606515e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327222; x=1785932022; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZrVadIZuKWV0X7sTw0kh2j8tsXk6grXgxs5xYjL8YJ8=;
        b=ndW88LJTAyFPXjYiiml0un9cVdPLIIeL6AoUsE8p8jH+u/3TSuL7RXAg+dAp3LBWsj
         RIMpPjrNLPJoxZZH/NUe1Pl5sw64dM4norgvP4LuDpN9TEk5REIYfVC7DwCoY5dQAUCH
         jfQB3QebFx3n0mQguA7U9f9uddJKvQFXBRfuIySMcqdlHGdpn2qWPzhrrPD2CYaxVB/2
         6/4+IFZ769RN9t+nTlMOBJHjUcWY7bTOpngzZ5qT9b+guDf1AMNvRUaP3WYyzx+Lum5e
         SDmls/aV2dmM35xw1USSGqsaurRMrBBOMPB1hq/PhDFw0B4wClJ929HCOtHfDpltpId/
         X4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327222; x=1785932022;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZrVadIZuKWV0X7sTw0kh2j8tsXk6grXgxs5xYjL8YJ8=;
        b=Ely5oSzXdk9b8k+8R5ymzz9idjJBW0zJ8/MftEfLeH82RnewJv/QNSoNrj0xrSvfH6
         ffZJCLnYU2bM2FI48IBp8OOBCpf50qsjcGm0njGbe6OmkQcN2dt4TdSoT9PGOPU1547F
         N5GbJ5wipJblTOi9f7ZSjsgDnW1Q/R5JqOq/i9SkPnRhR3ZkfMHiVZqXhAlO+hU7nCqE
         iWl3VKQy9JTX78zoWYUoCntn48/DPpqqC5dKd6/N5JNGST9QDHb9OFTJ0rjon/sgVWQm
         gIX6m80y2Rqhe7C6On1nNxUfi83QnFYjSkz19cul8KYZi4+NoimiI7ad7ZRzZVr08SMd
         0c4w==
X-Forwarded-Encrypted: i=1; AHgh+RqyQX6UtiFfxNTadQa6im6scPrU2tyopZOCwD7weYYBhai+/rsi4zVPAD0EJy1k1yfP3Dl2Q1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaytXPY7i0Uhtg+4F/wPs7QSlPqy1A/7A4x+HSzUGJa879rrET
	lPuqLAfUu1oO6BgYClETrmPTEjp0Yy6i1ok73BhAbRtIYFqltdGX88CJOYenMGX9wM6kH9iu+NU
	jHxNokM6BhVQKZN6QPdITK8UlqXynnw==
X-Received: from wmfq2.prod.google.com ([2002:a05:600c:2e42:b0:493:dccc:9e0c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e89:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-497fd2fa920mr22738175e9.6.1785327221965;
 Wed, 29 Jul 2026 05:13:41 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:05 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-7-sebastianene@google.com>
Subject: [PATCH v8 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification GET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments sent from the host
driver.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 2bb16aa414f9..c22fe4514741 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -938,6 +937,27 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
+			     struct kvm_cpu_context *ctxt)
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
+	if (flags & GENMASK(31, 4)) {
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
@@ -1009,6 +1029,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.487.gaf234c4eb3-goog

