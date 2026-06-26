Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507B83E558D
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459970; cv=none; b=AJOS6bSsXNogsBZSg9aBm1kIih/ea4YIx6LFO4+yGtpM9QyWt6vcIGfum3ejHaBRBTgZWT/VKSFLt7PZTFKYSVfxwzYbwDpSSMQWI4hXrxNWUyCXbP3h+UTdbFjJoKev1nTJu/L5rvHFJvteFXKr1h6ibCmN8PfKPspFg5rzVaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459970; c=relaxed/simple;
	bh=71oD1q4hx/jEjAFifRSA96kSwwA6DTkKHs5psdGF1cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RbLv3qE9w+dlWyMOZpWuXtVS+ccdMEpH3u5QLUh2wGfSE1jg+RAPZH3WqgYcwg9viFc0pB7E6hMYv9AboffpkHQCtgS0VCfQHh/C2nJB3dbyt9r9ouSMgbBHTIGZtfbU1XWC+/uvbDn68+MqgFjiT8aH+BOEz6q05Yq+H19l+BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WMCINKrp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WMCINKrp"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490c840efe6so18117455e9.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782459968; x=1783064768; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3D0xuQZnlofHgVx2W5KKpDjK2IflolNZaSZteTp/rM=;
        b=WMCINKrpY/8IkkQs7zaLybJSNEa673paIHD8IhZz3aHxiZ5McTribW7Wv9XJu8coNC
         teCxHOOe8TNzM1X28QEagO0/sIihI59p84iyBDToTHm9UucTA6d1jAeD5PzJg6HDssFy
         uL7aL4R0/6pE0MXj9egKW9ODybyUv6ikiFv96ao7MT75FSDpCB1SYB5BE4ozOPcM9R0z
         GeXEJUZrt85I7tiKLns3PfN9MLoD3nyGz4s3s5sJ3z4dBvaqkZ3OmLhKj5JqK6dhkoXQ
         vWQrKor6+ObuhO0Fj1wf9Ba+FqtLZ9kjFSQdKrVi/wHsmIXfuobI+z+PzYDdzzM58q+p
         TPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782459968; x=1783064768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3D0xuQZnlofHgVx2W5KKpDjK2IflolNZaSZteTp/rM=;
        b=AHT97Vk13knsevtbDQbpwo7TXUvPDUb+yLUdg4XnOX68S845WQeucC1HeFWn7qQDWB
         LoPduKVg8qR04mdJnJX5mTRMEX9FLooviK20pjsSB/arH1RbuWKZJyQTg8kO1o0IGl+h
         AvKupv8PMn3JJR+9UvV5UCe318J15pHQsBOkk5+H4lp097ZM09O9DAKIPhM4BEIKkzOE
         M0nTeAoNWkls8fCnXWmkxuY0KtjqQioNS5DOqXnSKZyotfZV5YKJB0gzHZcYu4KPkGKK
         s7ggHb1VSwSHmRKvS8m0dM5dlZjRwuoWlsLf0HBiNl0Ya0BFIfRlLH85y4X9yT0OeRY1
         gLdA==
X-Forwarded-Encrypted: i=1; AFNElJ9Tgg6wDNl2T6jB2Xo5QPWy3uGtE2Y8uXupRtIMXObWdTr2Ogsk2ikH2QP2F+aFlHBma7DR+mA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSKJGRoiCqMduV4btZXuQm4VV4B4FCbyy94zOJScOuss+OCIO4
	ZLtqmZsSkCOMUD+l2yzO4jFDnEuXp+LhlCEr16b0Oss6/OlXSx6A4G5VuyYLlMy3fjf9YNyn4K2
	TJeKPia01U94saDLEzouaucqvMsEK1A==
X-Received: from wmbc6.prod.google.com ([2002:a7b:c006:0:b0:48e:6f63:7624])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3587:b0:492:4871:7e21 with SMTP id 5b1f17b1804b1-4926641b4c3mr65384045e9.10.1782459966937;
 Fri, 26 Jun 2026 00:46:06 -0700 (PDT)
Date: Fri, 26 Jun 2026 07:45:43 +0000
In-Reply-To: <20260626074545.433234-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626074545.433234-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626074545.433234-6-sebastianene@google.com>
Subject: [PATCH v6 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
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
hypervisor to Trustzone and verify the arguments sent from the host
driver.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 2bb16aa414f9..c22fe4514741 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -938,6 +937,27 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
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
@@ -1009,6 +1029,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

