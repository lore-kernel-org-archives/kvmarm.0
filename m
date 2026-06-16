Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD53466B75
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624539; cv=none; b=VeybJ0HC3WRiJM4BRlx0fpsmFD2sUIu7qM+Gl9TtHqG49SbDdd+BBLYxDoZ7pzy3XqiuXoUP9IwlBXERrlQ/+0SrlF32rydKKdgkW7/SjhBOkIIEvWhwsMGIMNPGQq6E/QdTNQFbwx5fqg/kqni/8PWFq4kDumdioBztAx0Io3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624539; c=relaxed/simple;
	bh=lA/h6XsMWZh0DggBMdLI+bQY/FwTAx2utdxY8hELFlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pR4njsCp+nSixn9bdq4SF7uVVXAcT7O5ZTpCj3PFhjz8oF4D3B2nfHz7UFi9p4/Ig4MtGqvLaAwJ4ev1TrwCxH7bm6iQmOFFkK8GMKMF+jLtojl94YmjQpf/nSOiBNohzf8NGggO5g3r5iW9HNJqReKFyFre1lrBTKO9+oqnuq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NN6Xgq12; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NN6Xgq12"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490bae3a39bso46581795e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624537; x=1782229337; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCFbezIeGawe2Un5+cxPY6PY3SKM8v7J2hVjyNVIFYQ=;
        b=NN6Xgq12nUqvrJSa+MwJNwRRmdx/2Xfyb7eVXu/Fhmih/ukRVKiXRX+b8KrAA5lus1
         vYrZ5Bf74EICabMvqv6T5/VKvRd2Ss6QozBko/R5PW7nZQXkwNeS4cg/W4UL3sApjLGF
         GoG/VbuP5zuuGZW0mR7HjzaD3g3bOy8yTfRlQLkGl5RDA3xbhM8gJybn9FKbx+MNP/am
         umByc9OiOZFjrIztr0DzpDjafzfSGYRH593L4eHdeX/3xPZKHxzWIoqiHFg054PO5Yl3
         AY73SzA5n0GFVzwDNrqHO0lg4c31PFRYxWqlz4oDCYYoFLFtRt7rkdT8b4CRaKxe2e02
         v/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624537; x=1782229337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCFbezIeGawe2Un5+cxPY6PY3SKM8v7J2hVjyNVIFYQ=;
        b=j4FSwCg8/X8wVNgLDBBmwL9tdzJ7vYQVYNb4JOv7CD3kMmlfXqjWs6H8twduSNgY4k
         nUEDEWzQqR034UafRSGpMLD8oPJ0A92RarXVbaj2r+lAO33jw07IqBmAT0qZ44BF7uk2
         lB/8S2NX8mW6CaW1DnzIRK9jy5aRgEk5GB0Pvu0EDt+1ge67FkVMOOQoQvpDaxsYaNB7
         nZ2Rc5nb5HKbyaz6NO3Mlu+RbDZ9cnPx4Qhmzp6ouQeoNBcHE0ce85NxGKNBAj09hwXH
         H1zdnKaI8psBXi8q7CD7i+VuNhmkshCg1U1NLi9ogTUsBVz5WbrGK0E6GMYFk6MONvNi
         tcVw==
X-Forwarded-Encrypted: i=1; AFNElJ9mUZvHB2HBp9YIJZYdNEWyDHZxR3cJo0CfArxUBED81+MVm8wP7sizYKIhANSy4ScKGhfMnnk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRXxylj7t2V8RuWyvE5HRNb5E3+gGfIGCTKoaWevn1hCnT4EiR
	v8PN64VLVBcK0p/x4Q8JdvGLkeYYll1nGiB27zxD24oDgIu9wQN7qt5GFJs+K/1mcd6yEnvzc2r
	qnUPOCxOBaV+Sq9vwLq/zVlH9xPG47A==
X-Received: from wmf9.prod.google.com ([2002:a05:600c:2289:b0:490:3def:63b9])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c08b:b0:490:bb20:de64 with SMTP id 5b1f17b1804b1-4923339fd46mr929915e9.5.1781624536623;
 Tue, 16 Jun 2026 08:42:16 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:47 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-6-sebastianene@google.com>
Subject: [PATCH v4 5/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
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
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index adf8680f3266..fdf1e5fb6726 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -43,6 +43,7 @@
 #define HOST_FFA_ID	0
 
 #define FFA_NOTIF_RECEIVER_ENDP_MASK	GENMASK(15, 0)
+#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
 
 /*
  * A buffer to hold the maximum descriptor size we can see from the host,
@@ -715,7 +716,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
@@ -975,6 +975,32 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
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
@@ -1043,6 +1069,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_UNBIND:
 		do_ffa_notif_unbind(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_SET:
+		do_ffa_notif_set(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

