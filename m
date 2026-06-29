Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B563FDC14
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725783; cv=none; b=cElTbfs/7jWGY9dfktR0bYm7dSQPC5UYUdtV28JjBrg1L/Stza3PZ0CW5ZvDnuAh2jqZGXrKEThzTS7rdIkg41x8MLqXGRLQNXma3ojtGB/i84g+as+CZ7q7K0SngguMR24DMQigavzzaiinCO5Kg+oZxYuu3Zdy9pZFT4RT53U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725783; c=relaxed/simple;
	bh=71oD1q4hx/jEjAFifRSA96kSwwA6DTkKHs5psdGF1cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RkBJ/GOAu3pGJ2uyB+obwvdnByCihczwRbGp08qesWr3ZEkzlyw164euGcl7c+YX2KlO/hBcNu4a1jlW5ZdtnCM9tQkH4RmUBlBlio+G6xaoqFKPxbUI6WhuYQNZX7Kttq/elKgiouO5kmL8g0x49CwtvFUySYw7qkdcnt0VlyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YahZ2rY/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YahZ2rY/"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490bae3a39bso22659725e9.1
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725778; x=1783330578; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3D0xuQZnlofHgVx2W5KKpDjK2IflolNZaSZteTp/rM=;
        b=YahZ2rY/ldsMYO4WGk+yftAFsSiqkKBHHbuxCCZ4I2/xSIu5KhXc9Zzq6W9mcXBLcx
         FgH2/TfXIkxR0K0W3y/bhYmH61hbuWxbUuU4GkUKNr9zSMkTergHRBhjzI028y8PAXem
         gtc1ZLsF/KfQmOkEVl9aeoLXDMwAuYlZhGgr9BUTJZOIHqN2UCCBAT4dwWWKXjqA4YiI
         5lLdAVik2Gkl/a0aYqy0EECvLEzRdLdfhu2kU5VH5PoEP8wGmxbJNcXIXSKswzATai7H
         CddzS6z/laS0EoK+2+Qg99Vff8g7A5pIek/MlpgxoYE/dUqJVNribwUH7yEplqKoaqU6
         DO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725778; x=1783330578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3D0xuQZnlofHgVx2W5KKpDjK2IflolNZaSZteTp/rM=;
        b=EHX+/5CD6zDun3CSFsolIteKU92XDMnQGGAymNe4JTB3TenTgOLoq/+Zn2V9edghkA
         ZTx/63qpPw1s6S/j5e+loyYPJauojgkKp8sWN4OkuSSltMFSEgs/GMeBovuV/+h1tv6w
         /ygqs/Z72OSZfHb8SrMiLRdc1OHKEiBAwA4/eQTCkI0vFRf1JIeGzGzT/UT3dzRmBvtW
         A1/RyGFt6DM442pRZD6Pq8OS3KcQreaay0wldDt6z8fwQFMyVXZDPrj9BMDleqpzuZJG
         c4fSjXZJ/3BlVmMDXQEn7PWM7615HkfcvX0vd62Ode7pCp3PuVcWzt9n+v07hAMSJ0Kz
         fr6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/RgVdOT22jZFIEXOyazSzJPTDb2zhi3VyD3zHjHynx5RA8idnSTSiKI6EXSQ0Y4t6ixMHJlX8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJN8f9LMDqmIuI4sx+y+aPuG+EOxH1NsqgQnbSIA1iDUfhr+K8
	D/u9gLKUQEIcUqwqAvLe/JV7+k4LtRLJ5GPF0qVPMrxwV2jiN+nLksT1AY8LQReKc61Ja9R1hqO
	IoaXBAqfCzkCo5SbdJTSUnbruMvFPqQ==
X-Received: from wmnk7.prod.google.com ([2002:a05:600c:1687:b0:493:b0fe:519e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3552:b0:492:700b:deea with SMTP id 5b1f17b1804b1-492700bdef5mr174973385e9.13.1782725777696;
 Mon, 29 Jun 2026 02:36:17 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:56 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-6-sebastianene@google.com>
Subject: [PATCH v7 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification GET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments sent from the host
driver.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
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
2.55.0.rc0.799.gd6f94ed593-goog

