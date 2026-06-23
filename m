Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DAC34BA50
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215657; cv=none; b=AhJNgkVRTbD02FoB5/83DbUb5F4yB4OCEEm/G3FxkMoi2x3jxd1dh5UrR9e3wUiPkB0WArO4+aoceZ9ZuUEDL2RIjssyTiLsw/da2Nc9JMzWxNriOoNa3VuX7uNuj52bxGtpmSEH/uwJ4M+XPndlSvOAGsbCr6jPr7tMY07IrOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215657; c=relaxed/simple;
	bh=ysFvg7iebw5Z16XwkjUn9DV2dfhJmVGoagNlDdtqO5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XVwsJZggYLEBtHiwUHryZ3QRgbDn0AuRC2iKVa6Y7HK4zmLTL5e91sbzhV4uZd/Z/o7ptwIQS90P3yryHEEH6M1H1tHVgESGAZCwdZ4c6q5fxS9ZjeQzfjnHoRGqSHo0L5j+db8JJ9bY7dE+DQHnfmpktA9xu7t0PdwKAJsh498=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s8wli9Op; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s8wli9Op"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46010bc0f1eso3368977f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215653; x=1782820453; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=46ZjMqvd2ZQFHV75B9sJuMZVM4j/Z6Yee1Bq8pCu1gk=;
        b=s8wli9Opy9MDUXSE5lGPAlPK4xnsuoKerF767aFM+8Zbc7cnyHNBVs+4MVAc6w2cYo
         aQhGoDdqSgjinVBmuzT1ovNNK6pb1IuElovF8xq6JA0XsdXWZNx3yQCfB9/gB26wnaov
         LQPbc5546G7Goo1N7Qb9g0RPidGmBM6B5/S5+SgE9Zh8IBfy0t8u0OkN/MS4ABQd4/iI
         Rl1KRzJFD2pb8bMGu75p7B3kbtLq2LlQoEnse9iL2OR4aB867vb7F5CPCOcFB4SJPbkE
         Ppbz/aq+o6g/UsfJoLPn8TW/YxtrTQ2oXLenW0CzEtEVPAKmSpCoKzY4Ar+sSZE1Gr/I
         JLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215653; x=1782820453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=46ZjMqvd2ZQFHV75B9sJuMZVM4j/Z6Yee1Bq8pCu1gk=;
        b=d3ALZP9z+qgZxg1zDyaYagjrISHftnE62imoarKY07UQjr2P/JfgCGHI/46sWElUHX
         3HJPX8f1oOJvtQkWYWmj5p5BxZdgp2NWGuY/z79Thj5wiiTZCikkm86R4LunzV6dpsWI
         3mYwbSLZuf646BJsHZ/W76z5bUN6HrM6Yz1eV9sxLSUFtE3RTwTbSnzPkvS9/3Go/rfP
         AJD3qPrJFmKStlyJF3ob45bmYxm2vPNXF1sIuQ/HRCacZUQt8q8J+DIqZCRcczQ/nnyH
         lCLf21crDoTuCBvgDg0IPnadEKjrwQ2N07/B6reaeynSi6f65cStsw3fpUQ0jnxLL3H0
         dYQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9jd7BqKfdq0PukcA61+Y4QQosN5d+dQgyGpmgJFZ1Vwo2S1t8/+QStLv9Mq3d2LDsAOcYJZJE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8eDgYcpBI63mxRALFGdeGLHO5sN+/fC/jVD/9wvBTksepcrQj
	cbJPqZoiG77s3zgdj5q+kfniJuSve0PqjsrCCNEMK1YaM0YvsE0aeMLNeR1SfwYn7bFJRw5N77s
	LLeG1yuNB+uyzcBDd6B/yVuhBD0NSHg==
X-Received: from wmoo9.prod.google.com ([2002:a05:600d:109:b0:490:ae4c:a69b])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:609a:b0:492:3fbc:556f with SMTP id 5b1f17b1804b1-49249083b99mr219423035e9.2.1782215652335;
 Tue, 23 Jun 2026 04:54:12 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:50 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-4-sebastianene@google.com>
Subject: [PATCH v5 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
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
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index cc10f48915fa..c7910ee4000d 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -42,6 +42,8 @@
  */
 #define HOST_FFA_ID	0
 
+#define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
  * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
@@ -715,7 +717,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -930,6 +931,32 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
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
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (flags > 1) {
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
@@ -997,6 +1024,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.786.g65d90a0328-goog

