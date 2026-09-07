Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C5351D51A
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801586; cv=none; b=XBXO1TiBIxS9iIXMmIhvBnDCdM12mohSNu3cReph8+4dqvFgQXw8jUq8qU9coiXFDwGKGOpf+bmDUHHqObZDh+HPzrbhw3ZetvYgCOafue9Pm0Y25RNrBQj1LZtzFRecGuXr+Pz6hoRM6msFLugxoN2/k/j0WEjeZd1h2C8/yTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801586; c=relaxed/simple;
	bh=63z8K3Bsh7HYRRQh3b9CFMk8m74jI/5sw5q37ngLLic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MXxnHQsTSmU2HMlV06i/NYN9HEGL/8RsvDCk9O2nbp2DJz1v7W38vog7yV4ozA001w072XYiIzC6YYcQbo1V5E607RahJZpvAMjqyK8eSEsJwAL/qLhAyVFcI3MM7TED6YF5cRr/DJBenEAytsNXNafolq09ynXNNjWTx/hBShQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XWp+7Jzb; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XWp+7Jzb"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49ccfbe060aso25630585e9.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 10:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788801582; x=1789406382; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=piiRWCJ1kku+wXo8orOGF6kurBcejDUkIGQIzstV9bA=;
        b=XWp+7Jzby7XwTGbg0+FyOX1L9tWnzbvnaxpj39VbAewyY9lt7pRTQur7dNY8R3SnbH
         vGyJjIPDuMm52H1rlx3O0rxM1flyBHYMKmV+jhKQOE7sVZaUMMTTIDQIdUEsLkMQKfWy
         z2ha4ElmG1BeIwraRAIYMM1YgyW4Nsymd8b+nrWvsXByOjDvrRBBoHsvkl1E+YoobyGN
         oa8DubV4XYGzk2u/xuhROh0PdMbWlEw9NNfzAcQ6zu2Y366giWNsQUsqsX2d91P1eREM
         2avuXrk/Tu/pCHHRgattq7QbWyz7ZaP8VJOBb6KVYPrEribNj2dAhbpKF42mvT4KH9ba
         2z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788801582; x=1789406382;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=piiRWCJ1kku+wXo8orOGF6kurBcejDUkIGQIzstV9bA=;
        b=GVv4zZiOlrVcF6dKVVquJS4rycu0MKdqDT84sunyPn3oDKtwP8+gQZ2n7lPiQWWpoO
         FGczi9jHxRE2aScQLGPb8mcTFqOqB4NqMy/3leq5sJktdyHsr08C7mQWiFZb7hArCxM6
         jDfzTpDemz+6bg89MDdH9yDz1LVYNTEJKY1unvbLg3OQ4jpvTKmALntSnyyXgOX1jAYv
         ACE63TJqXmDB3nxeW/iRL2w1OoZdBLD/tBzzHqB9kFORkDxVu8e/an1XZXA87CGOie2g
         5uBiAex91eMNAEqXtoYDem6pDh9Hh57udXCEBEjwKQZK/B/Cw/nkKfFRIzPsqxSMUJZh
         MS6Q==
X-Forwarded-Encrypted: i=1; AKwUvByNbvnUO2dP1d0UWAOAIXhINkJU0ZQBOX22iL7qbYKvI5LX9Ps7+9nT1h6deIipkGMMBrdvcUM=@lists.linux.dev
X-Gm-Message-State: AFuF++llC4dwhDooQRmDO2dnRnwiuCJIvlMzbfvZoouwkHT+C3Vwhz6n
	0OfqNf7JJ4y3ZD0vrHaLzvzEyeRqTcrcG/DqXjAEkq3w2dhCaC7TTAysDmanBZ7bKfhZ9fTShzo
	Ogj2WAS/jC3bd83HxbBktkFJpVYlb2A==
X-Received: from wmjx23.prod.google.com ([2002:a05:600c:21d7:b0:49b:96be:bdd])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c48f:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-49cf825d507mr246019025e9.9.1788801581830;
 Mon, 07 Sep 2026 10:19:41 -0700 (PDT)
Date: Mon,  7 Sep 2026 17:19:26 +0000
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260907171930.4037166-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907171930.4037166-5-sebastianene@google.com>
Subject: [PATCH v9 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification SET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a1ba4463d1ef..923f32caa04b 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -43,6 +43,7 @@
 #define HOST_FFA_ID	0
 
 #define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
 
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
@@ -694,7 +695,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -933,6 +933,27 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
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
+	if (flags & GENMASK(15, 2)) {
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
@@ -1001,6 +1022,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.979.g7e5102b832-goog

