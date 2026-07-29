Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BEA47D94B
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327223; cv=none; b=NRYUrLZvQscHtZW7s68NBRhv5ANuBvJUcXpDO68RZLz2UmUxscjwj3NRGalfRm30dY4LbAI20UBSTew97fhauCzDShmbNirlsXtSg499L3r+DjjUy3yvOpO51NNzVb/6L16GPMx8XOwwq0mdUVTjBAMwSaSai9z4hQTJgrSPGrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327223; c=relaxed/simple;
	bh=be7b4ayvc+IDNiL8+f5NlNB1D6htnnrFNYow4uOvTs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LoS3vBuh+7PnvR5l7EMbltSFvLcSu5cJsOusAgy9sDbW29Y65GG73HI2/qPdQ4NY4wpEb+Y8RV67ug3hI7vr2icX862BttJ+AIEw/fwWG17WOQcVxFGP7WmgGHoYX3Y0MJsSnGW80eC9FqAu+dpJM7nKVw1B37D7TAyIsLY5k+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OunVVaoL; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OunVVaoL"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15d4bd2afeso80181266b.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 05:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785327220; x=1785932020; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bVYKMhOgYVvCC+zk5/t2FdOwyXguvLtb1E7ngjK3egQ=;
        b=OunVVaoLHPeoPB5ypFOQzXpm8aqFWqxXXp/ONJUFhkOK8badaHjiYyLLZVf2GALzFu
         xLX7tfJkYzoy3R+BEfqhru8CqHF0RuqHCDrFuYRDTOKlnnpxiTikRs+QlsmsyqB2vDnt
         6mqbaMy3m9Mg+oh3lfjD9FiG4MrJmUxo5X7bB4dU5KcQXJ1YvaXyNPQcnY++sV4B20uW
         /Azx8k2GAJsVDMKQoW2gI0hd3QllZmqN8IprBivj8Xa00AnwNkCc8RNE4d4SoRRZs6J2
         g4USv11hByZFL2L5UYg4xQ/o2pwtUha4m+pCBvfeRY72MBkzEQNQMRpfwygLvNIcKul0
         licg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327220; x=1785932020;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bVYKMhOgYVvCC+zk5/t2FdOwyXguvLtb1E7ngjK3egQ=;
        b=Atpk4PaeKUPe3uZEfro2siuis6+UcLOYynISTgjU6MQedcanZ48h4ehJue7IHnruvN
         n5HA8gVR2W4U9Y8VWuQByYDjnHsCTh6+MGENt6HM7GaImLKZePyQpLMNQtxK6b42hiDF
         auxoRwmc+AsasEVkHH/WwbTTyiqo3XWJ/BnExtPbwYA6te112d5CV73jo28Ad8lS34L/
         mRN2IXJaF/dXAayfqo3JPbIbUOTW4wi9oEDNsmCq6HlQt4lqpilXvHhhCWrxAARVFXdH
         al/XPQlIY/SO7oEo7hQnJ9BERhtxVY3Uw5tVzvhNLBFhrDJJvyzE1h5o/vEsiQgHYgpW
         qMkg==
X-Forwarded-Encrypted: i=1; AHgh+Rpk68V9YoXpFJc7fFBSLrT0zXp6um+raT7duxmme09rtkcp8fWDIrnx66eqvfmtakGJ3w2v6m8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1S0L1f5D3cElnb0kZ/F4hAUFhZSrPp8gTUcXBXhv+Ov0Nsesa
	SsPLB6mrGsabQPS8nW9Fe64qSae2YeCN0+XU3pjp0o0SJ5DCcQnqwxozIbwXgJSDlXUeltfVCU4
	vUq4mWElCpGtWKGbf1k8HRY9FUrZiig==
X-Received: from ejckk19.prod.google.com ([2002:a17:907:7673:b0:c12:533f:6b88])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c80e:b0:c12:34ed:da14 with SMTP id a640c23a62f3a-c1f72504745mr341409866b.64.1785327220002;
 Wed, 29 Jul 2026 05:13:40 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:13:04 +0000
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260729121306.1519473-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260729121306.1519473-6-sebastianene@google.com>
Subject: [PATCH v8 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
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
index d52d7c4d5e7f..2bb16aa414f9 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -43,6 +43,7 @@
 #define HOST_FFA_ID	0
 
 #define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
 
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
@@ -678,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -917,6 +917,27 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
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
 	struct arm_smccc_1_2_regs res;
@@ -985,6 +1006,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.487.gaf234c4eb3-goog

