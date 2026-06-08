Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B073D5671
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937762; cv=none; b=dJBA1/2r3Giq+0+jim29y96bs84eNz2Q0MBEO42uwNAZ1srpIlPyV5tmPW6Ta17h2Hn/2MwQhcROLahCvpU1DeEjggv/VoCDYqIMwwVebvtEpuFS3ZGY1FuknIOhag5NZVr+GOjL3mrngvPkjAv2TduLPuodJqCok+XOzD7+yLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937762; c=relaxed/simple;
	bh=JUY2tMPcrSkadAgPjQ5ofJ5fMEmTSaz7neQPA28b8YE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lOqtocb3Ur9b2thrzlb8ICD3AvkJUcBXH//aEFD0VmZncHfirIVtKwsi5WL1Cj38zE2kdQxXf8UT/Bf0E3/8yZK8QvRSQaC3p6bdCGbg2p9fuKd23SVkBcbUHMy1EV7V552eQopjbuK/o/9jqVELSrWufXwi5JeGa+KMDR5yWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXkWShSh; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXkWShSh"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ae4d89e2so45702705e9.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937759; x=1781542559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOOiG7cLZKBESZTZeStp41m8GGWKdLGa2fPTwW93Dnw=;
        b=CXkWShShDb+AhSewNnPhG6ncBZbx1RY+7vwZgvo27BXpEGN5QxV5TQ6aVR9vPVUIoE
         aYPumtcxaDwzN4Hjl6H2g5Ik7/HfZQZd9FGmkR7mGCd6zl7O8CrZyOZwtd4TdkuIVbz8
         GyAsPaE+okptGFssIdsMl22tC0oOAN+SVo0gq7aR21vV3QCXHIadOGGH3281PdZ1/7Ej
         NuU9SgxG9uuH+os6QdGg6A3Eslk2fw+HsZXOlx9RxOWXtHQBlYsYoM458XwB00ZAtrUL
         2bQ4QphcopBVM9gyZ7aqSLD/1ZzQMk5bFDqymtezDvc6oQl9m8Yjqtd9rCHQE5Agw6QT
         Hq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937759; x=1781542559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WOOiG7cLZKBESZTZeStp41m8GGWKdLGa2fPTwW93Dnw=;
        b=tVB1ktqHzoCWjDnfHIgOQN5oGNyjjfdRvMtfT2mOWkkBSU9sbDo1NGsP19/d+RvYVW
         Matyb7ChDTCb6+iolHSjemBvFePaRaZedLd9N/8V14VhrJmmNgUeEXiOoxTEREG2LuQt
         LSCX7JBG/NxZ93sBhCOIRr/Q8ItOTO868gV1No3t6BKUL0/lwC6NQ+2qkZunHygnWK41
         fex/gkxECvgSFc+1oRHjKU0j/5Kw5SLwxwPl98+FZGaJoHigY4MWJ+r9dmPUmXf4Iw7f
         TctcAhff9Dvdvhxnl0asi0y2eyf69n1vf+AhD7e6/Ns+ugNv1bt344EaDbR4c4oRw3qz
         5yyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Yzb+7bMN4135xVdz54cKtG+3AFmyfLXaJWJgRDTOlsmLr1K1HVQ3Iv3mpAXBrDvCBGUSJ8wg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfTcAToc+zRKZmidhYGMRLH0cOBbyr6aVl+5D9r0ogbASLBKGl
	yTog7Bg2m0vqzZmiyqNCRpARNfIMW6w5jybCRMfGdu6dm63FlSyu8hHyfTCuSUdWFKP4/v64mWc
	KrhgW0MZ/4nFoVcyeUcPndpMyMg2KwA==
X-Received: from wmjv24.prod.google.com ([2002:a7b:cb58:0:b0:490:aeab:32d1])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8518:b0:490:a298:3859 with SMTP id 5b1f17b1804b1-490c4993bdbmr293970365e9.24.1780937758833;
 Mon, 08 Jun 2026 09:55:58 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:45 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-4-sebastianene@google.com>
Subject: [PATCH v2 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification bind call and forward the
message to Trustzone.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 91e89d889c44..eedb01955a45 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -42,6 +42,8 @@
  */
 #define HOST_FFA_ID	0
 
+#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
+
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
  * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
@@ -688,7 +690,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -912,6 +913,32 @@ static void do_ffa_notif_bitmap_destroy(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 5)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags & GENMASK(31, 1)) {
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
@@ -976,6 +1003,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap_destroy(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

