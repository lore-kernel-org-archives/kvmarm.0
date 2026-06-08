Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CD3D9DA5
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937766; cv=none; b=RGfG7mg8UR8wpaQBBOWbDFz+s1IL3UtIh2/1a//ihqNvJWZkcxGjqxQMb2mGhV3YgrJGDhxomtLKJRKvrq9HIm3fI/bP6KeIWo0uJYSVMQK3uM6goE9GGozzcbURt5HvPFGYCruh31xyBNSuz3G5XwztpIcwiCXoh3oNw64CxRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937766; c=relaxed/simple;
	bh=WvNUZlQdSlrhUEvbk/wqJOmQ5kxvYTykZDwVGfpau8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q/vJNdmGltts5G1B0QjKeI6UeuDlb2KrTQHJ2D6Y91Dhl6WfAicyekFF8oI/M7EKlcLKDtjxAoAcVm338HkjhPwDY6td6C+0CTxmeHlx3dqK72gyiXRe3RrVuG5dxJxguGvMfDmYAcnYQVuqtucP1HNZ8yDtHV5OhK62u+UgAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EunO4g2+; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EunO4g2+"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45eec2ba533so3111184f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937762; x=1781542562; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fkWcCN/UbsW6dNVoLGt/rV/ZPDLec4SNUxgFyMxD3Hs=;
        b=EunO4g2+YgUknP7WmTHpGo0aUzlJbP9RvZI5s/0QjWNL/ugcQ8WfKwhWvpfA7c2sXT
         zVpMhEh2wON17nDGOxt/bewexrxKSoDsf72jqcCUGYgMDtVoFPONWeVj5qrTFVATO0By
         9TdV1OK4AAcuV+ST4So3IiUy71oCgI0zBl/iB1JpXWuGdlOHXjOkM9kfiOWpIWqILyVq
         U+82xOE8uGl0UW6JteuXTKlpRnlykHCPY2PQ34ySY88t5s2+mZXloI8FgtqfBhs+0oF9
         34CRYnKZldBL6KG28MU0UU7/62duUmSzp8sB5BIpvDYVGYQHV+BRsAkxjtphOyq5HAZk
         bpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937762; x=1781542562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkWcCN/UbsW6dNVoLGt/rV/ZPDLec4SNUxgFyMxD3Hs=;
        b=CGz0Q0OoSWd3/b6aq8TMr7TqRfmCVYdBbozM78JRTWoCcnaqrFE1bOxAst9/JteCer
         9wwA+a3l40uvbLf51JusR1x+uc7+xWbzt2OV5o0TIm/cQukMnWzTcX6pFTgSkS2P7UsE
         zeKDEe4pgTF3teMhzf2OEWKEQ2A+IKy5KK3WQNpQug7/sWvoOC2wqeWC82YJH5H5mdWD
         ErZboATibHP9hnHLN0Kb1RDugH73mIfmscNwXIdd28pqp5sW37fMt3JKsDib4L7QLvZB
         2TABAmnB7CGHC32U4RIJ3SeJhkKMEXj6cN3ob1XABS16zzedLqBe44LfOBsXsfrqJ6B+
         r0dQ==
X-Forwarded-Encrypted: i=1; AFNElJ+9u2FMHZKJSQ29r0Ui6ReRB9UxsD46YEBvG+YgUXxnB5FGOyfdi1v1wsy68Kk6KyUxs2lXp1w=@lists.linux.dev
X-Gm-Message-State: AOJu0YymP8rFLRJS3FHX62lP1YC79Y2IpRkSmo0cjgWQoYGBNYDJa24i
	hZgOd4rel1W/KuzxQrbBL7DFAibmW7u7IK2IF/N4JSLTayDh1pdj2Q+I98bYTwVmrZQ18g+mIN2
	4DYrnRwniBN8nsiA5kh8UVFZEjsiqJg==
X-Received: from wroz2.prod.google.com ([2002:adf:f1c2:0:b0:45e:8fa3:14f7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4697:b0:45e:739b:3e43 with SMTP id ffacd0b85a97d-46030186d90mr16953340f8f.0.1780937762410;
 Mon, 08 Jun 2026 09:56:02 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:48 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-7-sebastianene@google.com>
Subject: [PATCH v2 6/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
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
hypervisor to Trustzone and enforce MBZ/SBZ fields.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 3270381679b4..28b6cb0e14c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -690,7 +690,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -984,6 +983,26 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
+			     struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, flags, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 3)) {
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
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1057,6 +1076,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

