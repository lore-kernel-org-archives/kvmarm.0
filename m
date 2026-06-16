Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195C46AEE2
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624542; cv=none; b=LOS6KlC6YyEHYHGxsOr/Hv+5JJXkzEox+6H+4Qly9+YrFmX+0sr7wSi9FU8FIRqq56vrBcU5nO3WMLq0dKVwtMZdBtWI55Y2KVnynDseG6zf5w+dn4I9/ZqjuSdGhT2Y4P5z7WX6gWrLfNxch2bAMGd5cgETV+yI7FhduvN3DKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624542; c=relaxed/simple;
	bh=13Ul7XISNDju5zRITjTtjr87pKIgUC6qrEq8vBeAHK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nI8hzyuWlP/xIpY0zbK2JKudoeLsHlO4B/WrYgCNTB5KEJuPQScLmPL5K1Pmt933mUQ20JUTr2E2sO9EKbtwMG52k/DKF5UVyCyV17lYASwadz804TalqD0vX4HDE1iV4IoMKYhqRqhKw6LGq4jov/h0kFJwsdSPlmzGv4ybwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a61Qheiu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a61Qheiu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso30492055e9.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624539; x=1782229339; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OOaGjTb4ag+IPG6k0DLB6nE7+R/nX4tnydOkOxde2U4=;
        b=a61Qheiu4YPWgICXMi0TafLYUXuJo3NFMbkMTKrKsdAhXduKZWxSnPXZnSKufKG2Pe
         yn/vljqDIUHyx4SnQoDREwrZNdRG9SzXzk/5vl30Iuwhc6bzKht9Dl3NkXUi2ea5I5Yh
         RFdOx3h9JKzrzQSZW9j62FKQhdJrEHZPs4xet4PmTLBuNwxKRDSmia7tkPSdJCWfpqZR
         SHs9sE+CrlZcxYF2flyPe/UhdL8CUrEQZvDtsE8nkbn/mOUYn5yhzDiblqL1n3tXuGpz
         138PkNEPke40pQx9CcYxhxwQWMvzHl421P+1uQ8AG6mxi+617tYtU41mYYCbd2oxMiM5
         rz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624539; x=1782229339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOaGjTb4ag+IPG6k0DLB6nE7+R/nX4tnydOkOxde2U4=;
        b=beAsku1TZd9R9XE6QMjqJVMkHw/O88YfctMIxiffmHjBzH6lhL3//5B7oEO5xMugT7
         ZSSN5hvEcEOaxXVCcOzJHUF6MAwqLMTFPJ5UFBb1iHjYmt8dGwX13b6D95h57WM6g78c
         b9OuRSudC5zcNZSSPC58QVORargjT6HZ/vm7TVyANe0JbTZqkeYTgAMCa2gs4V8pKL4/
         d4JysIeGYV/B3eIlrPo7DrmY6X3id65KdNWDguOQcICfXDZPhczFYMeoWvgHMtUTD2B6
         lLctdEajP1w+Apk9evqeoc49vy32+J3aqql35W14ioTSz5Wcyrm+1whJCEt3XJF8fNmf
         BPqQ==
X-Forwarded-Encrypted: i=1; AFNElJ/JZt4vuSzIfTzBm701446A6OA3JSZdDbyMo20K0CDu5c34Fry2I9nK+BbYS9mbq1OoccTgkZU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMUA4GIEAOG7ED+E50hsILIh6EYCZKKvQzt8p7Q20TU4Bm7Leg
	xT1qDdBKzfK2yYQl/AiLBAOv0Hts+5iZAnFsJB31B5TUswJoNRu6Eed32be7sGulbfg9sNtpc/M
	y/mPRWBPsITB+rQGpp2ULySTZ7+p/zg==
X-Received: from wmxb4-n2.prod.google.com ([2002:a05:600d:8444:20b0:490:4477:50d3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:628c:b0:48e:6db3:ff2e with SMTP id 5b1f17b1804b1-492333a8f49mr1025675e9.15.1781624538850;
 Tue, 16 Jun 2026 08:42:18 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:48 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-7-sebastianene@google.com>
Subject: [PATCH v4 6/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
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
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index fdf1e5fb6726..de4794338388 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -716,7 +716,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
@@ -1001,6 +1000,32 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
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
@@ -1072,6 +1097,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_SET:
 		do_ffa_notif_set(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_GET:
+		do_ffa_notif_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

