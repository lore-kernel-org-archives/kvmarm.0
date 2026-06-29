Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FB03FD946
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 09:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725781; cv=none; b=Oo4wqiLPJfuMbMVxqaiOhHyZIAUe9F3G+2Rm836/loKHyfUnhWbwveyp4y/uXEO5I+Dz8cHD9geMIqBFKiYH7XMhJ2zTilrRTe1pIUeHlqtr7GLEocfsD133XI8u0M5Wq+ZEqqc0Lgxuxe4B7ur82KnsDtjEzYrWCtoNq1pFKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725781; c=relaxed/simple;
	bh=A9iEB7RoLYR7o3b9JIWmxzrK9nW9JHyaFAr0Gs34LmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JvnF+KH5cP8tRkpOY+v4lLA7MW4Iux2qTrSU4dyoyx69wE2gUFqJGtGOt9b4q0lKa34lyK7cvPgdc5+R0ssWuvH6tyl6eD8FJbL9SRlz6hCd2N11aAR+uPFgEWRK4bZhOt3oZjqrnas2HnTeByt2aUu7G3y07sRHcJeNOXLcuSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kjEywdTS; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kjEywdTS"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-695c0775f8aso2462931a12.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 02:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782725776; x=1783330576; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mgEdqVZzkg8EdfvsvaTXXYI6aDMdt2t7UIchiBP7OMQ=;
        b=kjEywdTSg1VD4O33pG2/BCbub5FK3+4qZTRLpIOJ8MmO/sI4NOGzXRpgvy9Jl5xnwC
         nRwjZigc6dZmTC6xjkuoMZVg5ApndRWh8obTLIa8HHWQaPfoVX3HixrzRAYl5QYubXdn
         Q4tGkojBsULs844M3iNGPjTPkKvlVYnxZYL8fQ1lHLymuQjXC7osb2EJ8Iuvwjh135W/
         gcSeAWQC+zi4gRQGJPImyoCPauwp2Wo/JnBWsOtIrJHe8bzK/Jy5cIIU7j57cFN03Icn
         xFfbKKuOai1FgYZ4JuX1AtigrxngQfcgfoar6AQV4Q4WBsQW+UsgJfs5XUfeWkdQ6xQN
         G7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782725776; x=1783330576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgEdqVZzkg8EdfvsvaTXXYI6aDMdt2t7UIchiBP7OMQ=;
        b=TagJT+aYnt36C4Wz3aCb+7nunHbVAVBgZFjm8tvxRUbdcz5jOjpjMidSH/UYm4IAkq
         UMT5r4m/aE3t274x40b8pUTGgxbxJzbYSS4SifyQSkX/XCe6jb4iWkmcTTTotVe9Cqfy
         CAedQIZtr6xoY3PuQdmXJQpHTocMZ91jtZHMlwVtIIEN/zARSbfAmf6T4lY2+SetxfGp
         saFQvcv1eyRIt/7Io3SnJUOv2dCFF67MGa1o23B+mT3aULcUVBB8Ql0DXtZjYV4LJMe3
         5IkOkJbUiDlRGaNMJAGxQcCSMBV30ne9qARm4QakhwFm92lqQ61N5FipbvppE1kBcciv
         ZnUg==
X-Forwarded-Encrypted: i=1; AHgh+RpBQSZ77mb9REbIJEBcIXySdvJ4oOy4o6W7kCnPhQY+YmI0p6I86nYZWR0g/q4m39y4B3nu6B8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVrcWmjeW4KP530SKmiGX5H7Rcoi4hI38PkXIxsjFWZJIpiHht
	dZPBhguCmM1U7N/bloE0Qx/XmkJokNlC8lH9TjDwzzQajZ+WIbTYlCnRNVlxj4zhpBQL53D9Jip
	CnPV/uzvNOvMghG75WsIUTbq/ROaqhQ==
X-Received: from edyb2.prod.google.com ([2002:aa7:df82:0:b0:697:8356:d9d4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5249:b0:698:62b7:a4cc with SMTP id 4fb4d7f45d1cf-69862b7a909mr1588559a12.5.1782725775494;
 Mon, 29 Jun 2026 02:36:15 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:35:55 +0000
In-Reply-To: <20260629093558.2425257-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260629093558.2425257-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629093558.2425257-5-sebastianene@google.com>
Subject: [PATCH v7 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
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
hypervisor to Trustzone and verify the arguments.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
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
2.55.0.rc0.799.gd6f94ed593-goog

