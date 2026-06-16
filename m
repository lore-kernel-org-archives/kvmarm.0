Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9846AF10
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624544; cv=none; b=V+TPPdhUsyNsWq6vVa8HHXT8G4M8qDovh1DR99AiyRsaSBRe0t33paHGsgMN8d7M+q51Wix6ueejLVxCIT2YFhKRpp9iMaFjPVgWxiNtKxswDV4ACHVwdm8htRtefTaWCEWvNC0dA3kFwnFmAyuMzutP7+hYvag0L0/nPWXLgfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624544; c=relaxed/simple;
	bh=CFhOdFUCwLNs8cLZxgMkjlbDmUmznFvMU9YSNUAy6Js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p8DS+w7t1T/FmaHa+ocNmtTcZW9pUgD1xKP2KkNlw8vW+vzWLZOCHrbm5VFjKV8W4Op5gDF3udenQ6fWL2KfuLpzILP20gmG1OSctAbkESM6bh4VZSIoTz98L3YDK9HeKZlZ+3mAv/n4sf4c2xg42TNXz4XdBfKJ5w7Q5CoiMls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VzGpTi43; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VzGpTi43"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68d233bf9easo4775361a12.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781624542; x=1782229342; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ougsD+RhXFLaa2VDqlr9/ENvAMMCUbH7DpXmssZWL6k=;
        b=VzGpTi43bQQKreZtUCVNWh895kDOwS+Jxcp3e3BwObSIimpnUX5gzr2WTxNjRYWqJT
         XxjRhnSsR0l3+eya6KT2IBxHAmS9Km5HdJ8VxJp3CiUr+dRamtsDBFk2KOh1CvjqUPwO
         lcnqBhm5m8Pz9FfVyzUoHUPgS+4vnnC3Y9dPNQer5mEWGKU/HP6cCWgoM0w2YNwySEEC
         FJOKGVnkMiHW/kfIZnDNZyIoeBobcZ7tRQgrGQQrz54L0VxU62QD/wSmDDjpLpeWSu5w
         nKvA/k6dcpsbDzSQt7Cr7bElqQXLwdJ03pEA+cRPhZY+OSFI3z6rVWgmEpI873IvmSea
         V0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624542; x=1782229342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ougsD+RhXFLaa2VDqlr9/ENvAMMCUbH7DpXmssZWL6k=;
        b=OGkee6YkLgGBKPilSWQ6jcjM5EQborAkXuEWAIjpmV8echrBWI6IqSHTCuN0c8KauB
         pG320MfojTSSPZwWCYsDByHMECQwl7+ay1xUFsCjc9qGmKHpKYZIgd7QyR7G9RKzT7AF
         Je4QQGxR+VkP6NKsSE1luSmp4n412GR9FhUBuM+L23Q0FT/Ye/G68ZfESuQiSEbVwEJY
         uy8CO241KPIG7Dnh9Fidqn7XGYpnSDLYi1Wd9pQ/Dux8y/KCawnzeIVBJn3HceVGoJHx
         WlRI3prjm0Ecm3Phtm+cyVWDWjnWOkBexIzy57gamWAqEH7dWUuCYYxtzRRlu9e1/1l3
         YB4w==
X-Forwarded-Encrypted: i=1; AFNElJ+New7CgUuHjjzHEMadFOr0/kJ84zEul92fr2nGWgIFx+zT/PBWnLp9ULojfZrqg9kVW5UR1Eg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzptcQYmSlJe611jpQDXUeaR8dQ06XdM9VPmFIZe4owiP6TDtk+
	9pq+2xQkP3vVN36qK9nnGce4zeCuALkAnVgbM2vAanoQxA9TDj6YkhF1z4vBR+p49NfEeHcUBV0
	nYo6PhBmCjI0xicp79PtajhE9X+JBEQ==
X-Received: from edxf19.prod.google.com ([2002:a05:6402:14d3:b0:695:4685:bee5])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5202:b0:689:816a:5367 with SMTP id 4fb4d7f45d1cf-693c696b2e2mr7055459a12.0.1781624541532;
 Tue, 16 Jun 2026 08:42:21 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:41:49 +0000
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616154149.2763214-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616154149.2763214-8-sebastianene@google.com>
Subject: [PATCH v4 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow the host to query the FF-A notifiction status and proxy the info
get message to Trustzone. Make sure that the SBZ fields are enforced.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index de4794338388..ffb6d44b5010 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -715,8 +715,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
@@ -1026,6 +1024,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
 	hyp_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_info_get(struct arm_smccc_1_2_regs *res,
+				  struct kvm_cpu_context *ctxt)
+{
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 1)) {
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
@@ -1100,6 +1112,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_GET:
 		do_ffa_notif_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_INFO_GET:
+		do_ffa_notif_info_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

