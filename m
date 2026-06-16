Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2EA43635D
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607276; cv=none; b=BCsARZgVeJpuhxZ6y/3JdO8jLbyS9UqAmpcHsrcCLdkmDpzxzBcpXoT13aKiaahNP99QIneptRU9uBrPabdns77nBQJqslnJDIgIBT2hhL4bKMpPu/1h+drbC92qGCVHyFWq19SaPftk8kBkS7kJhPYmBR2YNwiIC3O4HHQMMk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607276; c=relaxed/simple;
	bh=l0mZkdTN2VV+fsd6+4jp+5sV/7mjSvNKmnLNFvXoifk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j8qWj4X+YNrOMNXPoZ/jmChnWGHE6jAINxuUgRHIK71mV8YlYFqO+v/kmC6pyYqxrnbonYcwX74nZRNgfq7K1seGFwh5DP7oqmlqYDrtsNQyORWeMoZ5V8319ETVZtOD5VKWC3LcFejcwSakHD2Qa8cYlazUwKQ+3Kxld9RmLTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tvLmormL; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tvLmormL"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490abeb7298so49669165e9.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607269; x=1782212069; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvZ7xBVFaIWlfxl/3gfs4VKaw5Sr61chB3pwbJcfuUs=;
        b=tvLmormL+OIZJ17XbMcob3GX0HgMgKrt7o/tSp+I2YfUOiMoRfhplJ+6FudphyjJaT
         nFqJ94nZHbrtFC0d+9r8zNiq7efTwjrpcqXJqUykNIkT79mewyTwRExZoOzedH7v5Ckn
         x91n26qpxOQqG/0UYGrcEpfffcIlUjSJR2UjNoCxthnL/JmWX57VNcGUqphN12no9X+B
         /buSdjRTtkTJy0r2/DRuF6SfTbSyoeTLO6lX80FQmbj77T3Iz/hZZyxa+a1l0IUAl3cd
         f3hXcEIHI2hyWr80XNnhYnhghMzlDyVAHCx9oc3+gvnWByahMCKkotWwQMFIAaZvJRL+
         rtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607269; x=1782212069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvZ7xBVFaIWlfxl/3gfs4VKaw5Sr61chB3pwbJcfuUs=;
        b=pJbmq8oQtk0oPDpknHF7Rw1IpANnA01S3BATIpMYRUj5MhDSKSi20BYoIUa/RpjubG
         hJoxiP821Afh2dDGcvIdVuD86lbxuwuuC60z8MvPSieBYt7HhSAEYaRchLM40VCvW3xv
         2ZwcB5Edt+4MYXWfRxKPDWWcSKPMUOLBqgDwLlx+gtcQ2J3NFGsgD0dvyeNsFHIb/OGD
         UCgb3als8OYMC7/2kGUMhIFTsVW9kp4EBBjeSW3cHtjc8L21XTu0Q6KlfcpNVZe2Zzae
         wi1yt7Hn53OfjT6QRMpeQY9G1rzvNLRAeE5HzqIIlknVg6avi5Dan+MCT3yRRMmc8/4e
         sxzA==
X-Forwarded-Encrypted: i=1; AFNElJ8al/mOHyLSNHmXthBrcjTMc7nO1GfHvdgPAVG803RjPaX3xyR7ZejEqup/Yyp/wlKRIBp3VQc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMB6nUhnd4kcJA9SbWiXOFlsEjkZT+Q2ayj52g7iooo8ENaXki
	fIm+xW0DAofZUFt5qRxs5niqNfc7WLfa3Ocsm3sjVQEU7Zos+Vb5DdX1vdZ32wKajjWZLlz3NwP
	JZkZCBidMdsR9Iu+NTMLXjpbdj0M1Vw==
X-Received: from wmbg25.prod.google.com ([2002:a05:600c:a419:b0:48a:6051:b5af])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3512:b0:491:9969:739d with SMTP id 5b1f17b1804b1-4922011393fmr209070225e9.29.1781607269137;
 Tue, 16 Jun 2026 03:54:29 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:12 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-6-sebastianene@google.com>
Subject: [PATCH v3 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
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
index dc7496ec295f..3d8ed829f558 100644
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
@@ -713,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -929,6 +930,32 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
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
+	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
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
@@ -991,6 +1018,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

