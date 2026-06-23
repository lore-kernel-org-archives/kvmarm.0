Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C633D45CF
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215662; cv=none; b=YFZz0ZpUO8CRDSkz4rS0xhP67OrdirB6v8ykDQugoUXRpI8hK8egybsFMpxxkNc++RV397nnxFtcgoAVj15b2Cl6y304g6Z65/ZV2XvjQv97VFeVI+DbMZjKf6y2gMopvL+eYHAVawR0RtSRnKma03eksJa6+XCpHIer8BvKsRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215662; c=relaxed/simple;
	bh=eezDZdSoLXchtG7urkrTj3OWBvGJU0WnikLEqxWzfoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gv08MmVQnOx5/MEwSGPqyO6VbyFLbTVnRDVXSX2TQMvvefXbYDlfvBglNn+PTl8yXNOyk11zgaZQu60C84QKvg2QUloFDZ454VYczB+aquaWnA1ics70NSf4OaPqeXzNeEzij38j8VpOwKL4tNDbvfVpxUGIojunSJ3iBD8UWQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IV2W7LbP; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IV2W7LbP"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-becd1c46294so489475566b.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215659; x=1782820459; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ruH570qazxtSF3aFB7lL9Qp3QXgfyQrybu1/V/Yxmg=;
        b=IV2W7LbPoCl7Tmp/3ccQZZfUn/Y2JyqPQGfs9etd0Igb5kVlgq7C23XBIbT7z19dxT
         T7EynQoXIFfMQ5N3o3JosZTtjsTnQ9aE2BadkHjP5hMRYYabHVf/Fi1/cjoD8e05Bhw8
         fRq14zGyZ1mbBTNGslwhS0JU0DtjQ6pxwIouvMSAAfxoYd1TT2roSWwDvWoOZ4vTNtGf
         7mQSJsoLJR4ERLqcDuhIeHeUn+5qfJOaKsY4Ci0ugzni7AOzCpGacMi9RtWzzV4dntFt
         2iXBHx5BTEHOU32TPmFFGTkjK4f0paenV1armtvOnQA6ueJG/ibo8Zom7TTV5y/4sMFw
         cbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215659; x=1782820459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ruH570qazxtSF3aFB7lL9Qp3QXgfyQrybu1/V/Yxmg=;
        b=qvexHiglA6DXo1YdSrFeLAkJ+pJbAjM+N/Rda7et1EKT741ugzkGOZUqYnz+L5odc0
         vA3rF5tIL9S8f3c6Vf6REJH9tfliRnt7PBtxrrbyz/vUCUuTq88tIHjPw0wzjWy/2Yz7
         byqY1ce7nIzZ4oYVnHa8y7V2YLKMScXc5d6ijegIvvIXzeX7VPaKKYIQtUQWuPlW6Mhc
         m6eod6twaAgwvkTtqmCcBLq6x3096WpVaKKOB4advJPzHsbtrYvtwcknYAS9NLKlkwU0
         B+Zhg8mDExEMMaskzfSrETxIk+b2HJU2fzUxSjN+2JG5qdQ8p+yPmCbSB3suw1dgsDan
         CXkg==
X-Forwarded-Encrypted: i=1; AFNElJ+3vOoe/4wjuo+/kIGyLDuolbzu5lqTTxy5eyeLXTWO6UHS0gb2lpnWK0QNks9wXP6OirqNwss=@lists.linux.dev
X-Gm-Message-State: AOJu0YwETkHF4+1EwExfE8Z4+Cmy8ZDg4DS38GddaXCbejUjpLPkgUnq
	YcggCcu41JkGASFWvs9cPFwyLgHzCJJKotmOVqU61A7zZTL+XpoAhpWcx4SFuAnxd+vUvYs7Heu
	gmLUd6NDdhvekoFlTxLIv2+wZX6FH3Q==
X-Received: from ejbmf19.prod.google.com ([2002:a17:906:cb93:b0:beb:c090:4709])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f585:b0:bed:7f50:c724 with SMTP id a640c23a62f3a-c0c660cedaemr680222866b.37.1782215658302;
 Tue, 23 Jun 2026 04:54:18 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:53 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-7-sebastianene@google.com>
Subject: [PATCH v5 6/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
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
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b30dfc192d09..053efd99bf11 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -718,7 +718,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -1003,6 +1002,32 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
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
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1079,6 +1104,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.786.g65d90a0328-goog

