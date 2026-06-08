Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BC83D6CAB
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937767; cv=none; b=Yu8fvqGNGS1OwN+J4xuaYdVa8KNX3Yqud02yw97A1B4m/FuDCsHPqetzUvL4tYzByjH1NvtHGxLYt2gnBJzsuN/5KYtsJW8PCymr42DdToZPsuaHlRB/PjfHt54ogrOZJZJuTBTyhtM6dcn8ofYNErPJ0+j4OFoBOg7zTyTfDCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937767; c=relaxed/simple;
	bh=a/ghZ9f8piNkArvC2k+e2cwsOUE+3fRGTGXzL9vLPps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LqS4LP6hffxD1PyRcd68Gp+82sjvOUJviTWYsNCfKX19ighpNxPvm8D9j8A9I8o5GQ9hrenKgdgIadgqQMstre9giYFc305oSpC8jqKoZ7pz5sGto5E7VaXcBJuqm8at5WNlJZ6U1IaxgIVhvJ1g3QEA4C8ArLN/AHIcRt3BBDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=trxS1QuE; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="trxS1QuE"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45eec2ba533so3111199f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937764; x=1781542564; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zvv+an6xLDGNzBLnOXXROxXfLkjVhoP4StmbjGm4UyM=;
        b=trxS1QuELsA5r7Gqmb51T5xgOvrflgUISJGklZx6pY1nobIIf577u/YT6dMtNWO12p
         kliISCiZj1v3XznF2Gvr9EipdXjou8F5PZnAV3O5m4bKJzlwVUa5lcD0KDK6+DNqNMPz
         WGi7W1aYL92a32LQTvfLPnHRzPu9ebZ7+YmshaXWo0hWQ1TheYkHgV347QzVBLn2zyRE
         Mqp9ZT3q+XU1Fqi6wM44WRmREFAsttyERIM+PdKufNGiOJEcyKcc6IfFfpngNJNidS5l
         MoH3HlgngL6GmyNUXijCHz/fO3ItajNqJvRQAOf07cnI8mKY4O7U35vRlpV4GxLhjh/S
         K/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937764; x=1781542564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zvv+an6xLDGNzBLnOXXROxXfLkjVhoP4StmbjGm4UyM=;
        b=klZLpgU58MKZ5BdH9LHES7VjKW9kZmiap+e+1kGdpaWbuwBomZgoRgxa7HV79TVgtx
         T1cZoBO+1t3/FpRXYDj69aLHxf35NPa8eMCINfLB0byYPatFW3/asQhpKQZuU/rXENot
         xuRMHZJwN6DF6hClUMXQeQAUv066OtPsX+raaTuY6LatYI/lTqs24TuDkSZvZ3GPvkDF
         empmz6B4TmNFnbc5/6i8pGXr95u2lpAca3I1040Jnal5ylXGIwGBzArD1VKzJ3px3YFf
         g5QTZlEC75+tC1OtWtEXf9d3F+cmtExJVPs+vpr4cWT/43kBHhoF1Sdk674/QcFjEvCB
         q1+Q==
X-Forwarded-Encrypted: i=1; AFNElJ+0QV0LKmGNPS0+GsxX5gwXe1/IVyLuLECLP2dSoyiVwwI/totJQ5bJgqhMOdqQzAaMBFR/TaI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzidHvqP3pZh+L82vHF3yJh90glEBhL1KCylnjJWkWUSdAPICLe
	EyNImBvY2yb9Byttt/B0ikM1FcfK/KJs5zni8kLgPNGH2MGSwLtv8jQhMEnRKVLAwQEyj2K7WXZ
	xmyQwshfbspubuC/qwUkRuF3PkqSANA==
X-Received: from wrop15.prod.google.com ([2002:adf:f20f:0:b0:43b:4453:39d8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e906:0:b0:43d:77f4:7145 with SMTP id ffacd0b85a97d-46030506818mr19157420f8f.19.1780937763520;
 Mon, 08 Jun 2026 09:56:03 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:49 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-8-sebastianene@google.com>
Subject: [PATCH v2 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
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
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 28b6cb0e14c4..463a845557f9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -689,8 +689,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
@@ -1003,6 +1001,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
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
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1079,6 +1091,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_GET:
 		do_ffa_notif_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_INFO_GET:
+		do_ffa_notif_info_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

