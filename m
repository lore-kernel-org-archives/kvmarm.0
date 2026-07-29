Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8386247D46F
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327221; cv=none; b=JvA1ym38WMXuoZIWzy+tXXONxYaDKd9PxTURwmpSVIgX/WJZtV++buodrqWLHHny0NHwRY1UQNo+FWdf/O6zMhGr6Sg/HLWzEDRJLCrrPF5fi7rvb0cobS5dgpoXlSMZVE6P4Vj7O0MUPYLZGNBvllGVnqgGrlz0FSPxdW/Dm1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327221; c=relaxed/simple;
	bh=Jkw47WRh/Cipe9xC+lqagrk1iJneUP0l20wKcgRJvZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XqibWIxmv+PvHT/Hawp2X3TclPg76JFpKBbPOJSbT/n9TEaG2qeQi7bRtMdfB9vEs1aNqhXnNTB3IIFgbULk68WoHT+XFHANd0GeRdaaVsnFqluSZkIPSIVhA0ae2eD8xn4N2thtdDsElxVkrEWaHv1UCCWEB/xtSXyrTH0O76k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PiB6SJfp; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PiB6SJfp"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f8f8fde2dso656938f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327218; x=1785932018; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ZPPlW5g4w1AsF53iFpKYDXkhl/izo/iIyII9m7u4XM=;
        b=PiB6SJfpIsjpDafjLNPCRgv+6Co/8wvxElYI7FGjY1TfnyXCcb+QIfoTWSu/QbEdd0
         go2twBMd+NbLbX44uEfYQH36qVET9Pehli4tmLNmfGJvsUG5pKARSbUEcaXP9SiCLicX
         +ba3Od1SbUMdwQzOn9a5YvOjjLpRIKTyqOOlYb9vWGl6jKrB5ysLZmiw0Ru/v1cga52L
         GICwOIWFtMQ+zG6d7xUz2WbqEGtAP7KIg+Zq/Xufoxim3QS3dU41tW1pl4XFpQIuhLxv
         gsTFDxYsPuYuvrvsOSXLaTBjE+oeFpXr9pRUR2wHxwssDz7YUBcbTrXo4c98MTUwwT0i
         vnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327218; x=1785932018;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ZPPlW5g4w1AsF53iFpKYDXkhl/izo/iIyII9m7u4XM=;
        b=XNVPyvptwymjRcZoM0dMmB0zWe7kOUsirtyCth8UYcmCw3NyTDPkquRU35dFtMnmG7
         axxR9KBBwWcJTb75zWDVQQT34l6SAzC1sNN4hwc2eTz/HWxihx9yv3hkZCmOrn+rSPyA
         HXVgO2zSNGnZAjvxC+clMokFNXr18C9mMGv+bkpsWdCY7dS4R49q4glu8nqhIek1yrdY
         68RBOdvmxq12oSth7ZtFhTISlqLE1205qHTHFn1qi8UbjH6dldAohnvxTQn0o2AuuVmA
         JwKbqEOHwyiuGtwe7y7TDyO0Rl2xat5hL0Zwsahyl4zozSH7TjfCQWZHVzqXfljQO8RI
         SJeg==
X-Forwarded-Encrypted: i=1; AHgh+RqEM2Kk2hqT9T/7tIIRy5+5nifNoeeVrb9NLaZwdPBIjaCrvPbza0flmNGibSHfGbj+UzHBNLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGVickQ93Psj6ySh5/MKvk1holgApN7T5kPLZTZUoyLLQeTG/g
	n3+yG+oly1qZVjNG55+vC1G9vyR7guUOKvZzOL3G5MWd/qJnHIpp+SuMplPI7FO3KmxeBi/qg3N
	78Bex/69kWe0GDFTDQ/mphhwr8/XCyg==
X-Received: from wmoi21.prod.google.com ([2002:a05:600c:4815:b0:495:5890:8f69])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:b85:b0:496:c0f6:78d6 with SMTP id 5b1f17b1804b1-496c653e5e2mr81145145e9.2.1785327217395;
 Wed, 29 Jul 2026 05:13:37 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:03 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-5-sebastianene@google.com>
Subject: [PATCH v8 3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	fuad.tabba@linux.dev, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Verify the arguments of the FF-A notification unbind call and forward
the message to Trustzone.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 331d9d0d8287..d52d7c4d5e7f 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -678,7 +678,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
@@ -897,6 +896,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, endp_id, ctxt, 1);
+	DECLARE_REG(u32, reserved, ctxt, 2);
+	struct arm_smccc_1_2_regs *args;
+
+	if (reserved) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
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
@@ -962,6 +982,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BIND:
 		do_ffa_notif_bind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_UNBIND:
+		do_ffa_notif_unbind(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.487.gaf234c4eb3-goog

