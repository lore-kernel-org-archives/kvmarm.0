Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1101E466B4C
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624534; cv=none; b=MVo1kxEK20dUbOsVcXYe6Uch0pwm6ypbhWlURekJjZIFqrirb2bvurMIJ7x1DZDp84FInMoExTK12USCtBKBn0+GUh8F9BYjwy7YWutrwEwzhxKW6XdA80kGWpbwW9SnShNJKXm3GgqS+9VpAHgVJpSs9pAciK1uxHHOoEI3N64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624534; c=relaxed/simple;
	bh=wwyBxT7BxvbWIoa11wxvc9tE42KGmuMi8OH5wpEcHg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hf4aHLHqDRf9MUPZNw8LJoYaXweDlLMK0D7eCy/e0aPjY8KSW2fsCqWKoNFHHlPHKPF22qObdBNdE0YCMAuyD4w1MaeqN2xAbQ/vttaZbWYysvxVJYLLHVi/tpH7jHd425q1v+fRdBONHMXuBK38zFk+JdzzIef2swjyKo9FWE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uNjWRngv; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uNjWRngv"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46011aa5000so2222592f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624531; x=1782229331; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=edc7Ld3Q1CWSVNPfr5TXV9CytVBJ6mK62PgjuDOMsL0=;
        b=uNjWRngvV2jLueNlit1uBuYm3gMKCWTu3XSqINgJelAzaL4UuykD0EsulaUAgqOy/v
         axpcONOdDtb4/jbSxPjZ5bpfirp86jd5YiPoj9H+vMPfIp437znHKT8HBaUn3bPNxmGk
         VL/SWxuOCalbrWVqju4WnZaCRiQjyvU3vIE1A0tjtJOEfwrU1Vdf6/4MCHP8oIWm4Wdm
         i7O0JFRjIwv2G9nyBv5Zwr5KIivJTGcamW2xa8HJ3rvPkoYTWkqyzflaLY5Q8/xfGU/Q
         3595wE/n11sDPzGkj1pm7L0Q5LlmvMBozpvcMB1KoG9GYZCRUnZdjbPGvkEC1f6ohao3
         1Yow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624531; x=1782229331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=edc7Ld3Q1CWSVNPfr5TXV9CytVBJ6mK62PgjuDOMsL0=;
        b=CFleZ0OA/yn95HTrtSucHMbKy3w2vr4Z8bTAm+7NqxwOZHUMu1tBWhZt+EBL2ex0h+
         MOxC06zCcrgx4eix8F9oal5GEs6Nxizm2UbJ5as+CBoPqMni5K4te5wbqcCz/E28f0Ti
         ZA/PBkOXaM5IDiajFzUpvqIDm910RbsWQsvt8dztBv2rK3XxzvEECWKYBmeHb3NeoReZ
         lEE1P+Aorft7+ujMAaD8JtKmsqXqpDpjRRMMwvObc1W5VZ1hwGIuIN+KWYyTclNwbPqo
         cOmY4pD3T5OxfidTvgM4udG/aUx8m4bPOvQcHReSyYlyzcs5VxOoLBK3ABmLUV0GfWyQ
         szJA==
X-Forwarded-Encrypted: i=1; AFNElJ94S0ZKcvY4PUvoRdszvHXMdRt/Ir+B8VBIbitQ/03O/TRK1wJkKcDcHD5ykVPNMYrxtatQgdk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrgyebcFlhXxuliMwMqL1OtmzZN1wmPCTRqex1mGIXU20A5V5M
	bi9zNoBWOWpIv8Wpvqs7zqyPj180smxmYflyLjswIWCgTy34pWRn5x4tq1y8nOCA4Ab1lRc+dab
	iiKl1sQXSb87J56koOb4a8iLKTrNJpg==
X-Received: from wmv21.prod.google.com ([2002:a05:600c:26d5:b0:48a:79a9:335c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8a1b:20b0:48e:7854:1608 with SMTP id 5b1f17b1804b1-492333ecc7fmr75895e9.25.1781624531168;
 Tue, 16 Jun 2026 08:42:11 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:45 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-4-sebastianene@google.com>
Subject: [PATCH v4 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
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
index a72f6d4b62f0..1f38ad008675 100644
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
@@ -713,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
@@ -928,6 +929,32 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
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
@@ -990,6 +1017,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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

