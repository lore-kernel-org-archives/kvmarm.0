Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D74340D565
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215663; cv=none; b=Vk0EjxslOtQrzrTofudVcDr530iNv3/SFB1UXTM6WHstXFB9LUOlp0mTLfy+A+Xj5V9rr1WxpHAo270KkJ5p1qPYa9tIAWbTIf94k7int2OJAR7EjQ8E49/A/qx66BEN3SFeXQSFZf33bO8vnjobxGbohYtEzMivHX7CDD+Czoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215663; c=relaxed/simple;
	bh=NN5RVa487CMwqouLW6s4MweF3d/Y67/BacNU3KkxAU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XLcYL/vOXGEnh/MYEOWyx79b/cJmi4QtluaTTuMEFCdbcQsVCf9w9Tqv3EocZIvqJsbODec+A3ujvkYmjqsxiND/39ijE5Kvc9tvsa2Rm40HhfszUBrNwGWvBToopTF9W0a6JBZ1QcztkPw75WPiu5Tm4C+bI6ftZZkwUKSLy/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DFTsGfSs; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DFTsGfSs"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4923d323a83so19769995e9.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215661; x=1782820461; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gM0gY06Xu5IO976P3K6XmNc5FNoYV9i9exHGc/fednc=;
        b=DFTsGfSsXlcIyPSi5SFZuKYsjIfhwYy3Y+iQ3c6yoIJUYTGFEW0u8qr1Z597Ms+NkM
         zU6rxi878uVOpC/mEpnFvztZINM1PgcMeJu/kP8fgAUelmFOuEmWbZV3lcC+75lwD97G
         vi3cPlsnCm6RTe82DQkRwE8D9+PN/KUQ8LObRHcipIz84uP6ukEpX5dK/D7q3B0GYFNC
         MABwTG5G8W/YFgO+xBVP3ISvZCy5HNniehRiosq6/eK72WV48uNSfc61kb1u9j5ZSPR8
         kLYPPsRZyCCPCMEnZUINE6c6Omo4FHowVgObUMY3kB3cest2HEDyyVnaYN34N8p4n4fp
         AuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215661; x=1782820461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gM0gY06Xu5IO976P3K6XmNc5FNoYV9i9exHGc/fednc=;
        b=oIa61mGe6/x76MKhSEp5Qh6SXu4L4YjtAONEHhOypC/49auP96t+NW4k8hJmpCcKNh
         Se92FrKRaPswyFMTfC8WYiEuGzGDB8LCg/o21+jiYkFzdeB/4d3WHUnovciW0Tom+qFg
         iXDpbZ+IMNDwapi5BoaMVg+3G+hm7Zacg32mrelDu3Xhsx2UHtifDzc3YdJ/IPvv5Wa1
         ccLzFj8EOLliwd9wfU+AlX14fo00xwdwfSZ+JATz+txvhXShsmujzBs3BtpUda83RZvN
         wqjJp9WuDIqU7w2Ufe0hw3VzK1yZ4qXDUnHdXdGiiCZ2oe24lmbFbUtDLWyBIoScGUGY
         RoSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DMjg8zHOKRNY+zwSznwapF5ZnPSOrUHiZQIa7jU7d1vTuO1g1S58qGUDxI3PyCNnt4rT5Brg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMs8mpYc437Qu2FXOaquHmgNwNFKvD+9Vo5v7mK5vPH//VjV78
	q4w361JSe3LnQIUlzxCiL82R9D8F30CI+5pwK1kfMgkaHF1uKiRAINAgtNk4oSad8t0r0e8eIds
	oAt8USHJZnbJTZ6Hv6s3ofcdraUbHNA==
X-Received: from wmim8.prod.google.com ([2002:a7b:cb88:0:b0:492:2b56:8534])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a51:b0:492:379c:32ee with SMTP id 5b1f17b1804b1-49249083c09mr240289965e9.6.1782215660598;
 Tue, 23 Jun 2026 04:54:20 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:54 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-8-sebastianene@google.com>
Subject: [PATCH v5 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow the host to query the FF-A notifiction status and proxy the info
get message to Trustzone. Make sure that the SBZ fields are enforced.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 053efd99bf11..5539fb0d246e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -717,8 +717,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
@@ -1028,6 +1026,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_info_get(struct arm_smccc_1_2_regs *res,
+				  struct kvm_cpu_context *ctxt)
+{
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 1)) {
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
@@ -1107,6 +1119,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_GET:
 		do_ffa_notif_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_INFO_GET:
+	case FFA_FN64_NOTIFICATION_INFO_GET:
+		do_ffa_notif_info_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.786.g65d90a0328-goog

