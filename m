Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234F73F9287
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725776; cv=none; b=mAmZbf/9M1PjDfjdGkcOJl4QgbIUzLXuz/3XUxl0n/vMDjMbI9bEjQUDPmZx61Eg5cKF6oTEoszxaKND2CX2fOxY7tRBl30iHAv2it/XTPiauo6tSqUfgrIfkzFyWZQKK/0bJBjUcVez/8GVv84LqvboI4uvOa44pUQnIhE7hyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725776; c=relaxed/simple;
	bh=mw61qrEShLN4em+7Zp/Kc0hPkSUzR3I//jfz8mh5fjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WlqFKA0yh3KWt0Y0WVb6Hy1OmqmXj9rg42zA2Uilpjx238kg+QqOMj50Kw3Kr44htBBET0E1sTFBilxn+MNAfEmfYw3f5W3fOzJT1RVEAGb2wQEg0buKWQjuoi4sZzc5sGruVzrVWhAyr0TRhKZNbTFLCMezVoABOPUYYAetslQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ei/D1IIe; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ei/D1IIe"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-492714d002cso9528515e9.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725771; x=1783330571; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/ufGm0/gR8nHfEhXcbUb8L6QO2HXRkkGS5TfPgnqx4=;
        b=ei/D1IIedO1OdP/VO5XZesy01I/J5AQmzH01aSUGVNYzd3Mur/t72dChLL6cxK7gJd
         fRHvqaIT6zkz0VLThFr+16Zhcy4/NZNT5u3oSe7E+LmUck3U2rm4etNLZPVFeY+1ydP5
         69dCfV5OdtwKlPfHriC6RIMJvRXktFCBYQ3xMJIBnAN76jF9ZskpLDz3lCkGMk+2WLtV
         k4jjJfj7m5/ynr2u0yiBw4fIZYUEN1NDGtQS7TXDQ0CfoaesAl3sVoOCKu8f81/GeU36
         FUHd0XwoVEPQ2G3oG6sa3prgyrPhB8bJ9BRD9EjyD9SatiGfBQtd3jBNWkQMj2FHEJxA
         MSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725771; x=1783330571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/ufGm0/gR8nHfEhXcbUb8L6QO2HXRkkGS5TfPgnqx4=;
        b=YP61v2kTuk9S0IQeXepA/GJ84umwvbbNDQyeiU8RqwCyiAmMM6UmW5zJjTSiQEVCkn
         71MXgHTxV+HlIDp1QfnvFxAjm6Rw5HxdZ+d78B1P8Y7jgPJ9kajlQ0dcLBP4q6ooSjJv
         NV1VskKXP/7V/4+8SsumE0JWv1UL8u4e9ttvgy5fRBT7xed1Qffwbias4EndnlNj8uwi
         Vptx9ZBtll/jzyc3wZRe9ju37R2HkmCCwltzcO1aGyj7aAZXD6MdjasqphpyFD0uPXkh
         2Imwc6XTVOKFtuo/dX/ZUgByj6YNU3vZpaDW7mqNZpLJPa0eiAo0q8sbE6IJ3MqgLnrl
         bt9Q==
X-Forwarded-Encrypted: i=1; AFNElJ8+qvItTkFS1tBAjDqJX+iwnlr5dSP8rH0J8dygFmFlTgJHyroqoMdi5kCneu+GtKJOLj+zzOg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/y3+MhRQjyALnW94JfxPBnQ5wma+xmAdoz2CnXECa+tEdCLWG
	CXRfzUXvtIrjjPq05hN/E84E1aU08HRgLXL7MI8590SkzVne6lgYKi3VlvbdzE7mNyVIJ8/VoAA
	6PsV6VTwsXT3ah4cDcVt7078YXCP5Ig==
X-Received: from wmro8.prod.google.com ([2002:a05:600c:3788:b0:492:49e7:fff3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e4b:b0:492:7078:4ead with SMTP id 5b1f17b1804b1-49270784ee4mr134371805e9.25.1782725770867;
 Mon, 29 Jun 2026 02:36:10 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:53 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-3-sebastianene@google.com>
Subject: [PATCH v7 2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
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
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index ecc13b795f2c..331d9d0d8287 100644
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
@@ -676,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -875,6 +876,27 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt)
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
@@ -937,6 +959,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BIND:
+		do_ffa_notif_bind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

