Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2783D523F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215661; cv=none; b=PAmOSRVccZPQmNxJPA6VP6fok3xs1WN5fB59luru+B1Q9moYXPIC1BJLlkG08Z2vXtR1NqOx9DQwksqaIsBj0XcYOmRM4YXOuSQXeNb3DOlMCELRQqee/pSvoFnuPeuEBIv776pKYbRtd/LjOwGN6E6FqVpbsD1IC6NJBUNCjmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215661; c=relaxed/simple;
	bh=d84murYs4PPbnQ3O8oPYOzZyYgNqic239iULT8jIX4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mv+HWuz/pvf8ctBBirOwz8VSt23KgpS3dH+3ZnGj9mYxwVnpuiS3izio4iQQKYYoJ94U8CQLZt0krMqB/GAMm9kPUhnwcJuq/tsWcu8sWsA3QFo677krHOYumNpPrFzPm6/yWtzDw+dQQE+4QAcykk4r0BWnSGV9tHs3N6nmlRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sVpchMZL; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sVpchMZL"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-460129ef947so3714010f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782215657; x=1782820457; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SGR+TN4xuVGCrc6fFlK/aC8+eZFM94myNXts5JflryA=;
        b=sVpchMZLBRMs+X+saLW5W26wkpnT5d/sxxVIShixn1LAFmKM/++qq2eZ1OCKWeLZtU
         yCdDXcfGOZkLTtG5EKTXJ6PetRD0Jzlj5RgOZ8TQ1x9g5jQ6SkFMpq9CQIzt8QxiR3Xf
         5iOWP05zY/Fk/lDgFmJEy3pLVzqntLfpP75cffRfIQ0x8YfbLkhjgQVLB8awi8QPebEq
         0hviGyi78jTfGMfxVpm38b/3pyYXuLOAypH/1i06wezbzOVvo43lccxDI75nYuRPN9QT
         JFbE5+S0zL+UAdBmQAA0h0EO0X/rQroeH3sDorYIYSXOj3Mbh6UhNwzoRhFQTpiBstj/
         Cnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215657; x=1782820457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SGR+TN4xuVGCrc6fFlK/aC8+eZFM94myNXts5JflryA=;
        b=SCtdXFAO2mYFDi4w+DxeQH1J9l7JNCAFytq9gUr4Y6OPbySeRRt07TmghlAW7YoaGU
         0UEQnzqR5chD34FzBQUhobR52wZo1JF9FypKeTej3jvTbwA7sUtNryFEfnJ0uRpv0JEl
         b7ZjDwzLM0wMMZMd15YVs3DY1dHlmHehNpEPfsy8RXoalJri+LoM5mZdOqgNJjXcRJ1h
         2rG3YHIIuSHs/v4it+bBvACXMAhbc8lIw/ijtd6CFp4KFktcFCV8mHKAjcvUGuQFFe0l
         E886PdlZmhgwdEfCRu60eJi00zW7EBduSzEFhzZ0BRyrMMBi8upvvdCPqQ5CL7tIVktU
         q2tg==
X-Forwarded-Encrypted: i=1; AHgh+RqZZDOB1PTiTN2z0OhwjQ8m2fXUsQCAdcgi+m9IV9QGrLQGJvX42giLVdCXu16jAfVuIfGqqoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJKmhqdYmOeKEzX81+EVHJ+W6XXTJAqEHxV+awVaE6o1p0I6j2
	f06jwvFYDX0uPUFbY9G6v/t37Ih4tn1CUvZPAaHD0KJFxWnv2IWtFvBHwlgtpprM6/ArKxfEJvQ
	u3et2BsHLCFNFyke2So+EnOtITDu2sA==
X-Received: from wrsx9.prod.google.com ([2002:adf:ffc9:0:b0:449:2f8e:2b32])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1448:b0:45e:ea65:d329 with SMTP id ffacd0b85a97d-46506385549mr31804863f8f.7.1782215656453;
 Tue, 23 Jun 2026 04:54:16 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:53:52 +0000
In-Reply-To: <20260623115354.632361-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260623115354.632361-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623115354.632361-6-sebastianene@google.com>
Subject: [PATCH v5 5/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
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
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 4b9e2b6b7143..b30dfc192d09 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -43,6 +43,7 @@
 #define HOST_FFA_ID	0
 
 #define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
 
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
@@ -717,7 +718,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -977,6 +977,32 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
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
+	hyp_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1050,6 +1076,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.786.g65d90a0328-goog

