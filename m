Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92093E16B7
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607272; cv=none; b=qgAG+IE7cai1vfHxLraJbSwZ6g9o8Rbpto/cfVRoNKPVD9uK1kzgtEeZoSq+0AKicQ785ynxMptcIkigaH3UGHGjy5oVlPvLs8GBsBtSuBFep76+rpq++GrLn6lw3i/SmwfKTyB9Dy2bOCUJnG2BmaCbX2ehRDxYM1bmMScMfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607272; c=relaxed/simple;
	bh=R78PneW8eGr8V9PUCzE0jTXVbxXu0DJEAiZhgQ/397g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FXPw7/i2/jjtbQnM/CrqOz94YVKnDfKdHb4gWTdWkrdPvpPW2fnD634gZUpH4+NYZg4CCgcWQ7RUtM24LicRFm66qscBNnWk/3lDmnJ/SESWaifdUEoY1YCKQZhmAT75iRElllAk0IhAQakdC0FeiMipvf9N2uzjR9+gmVi4u50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BmhbMnm+; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BmhbMnm+"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-beba94353acso440579166b.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607268; x=1782212068; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HynPX1bYuHPedGhayckv3uSerJnSLgHUWuE3kdOkpaY=;
        b=BmhbMnm+eo8PwkvkBNvcMqrpWZcOrxksj1E4fbrUYUoJMxVd2scbbqx6uJSIkhkpu8
         KEbULSIgS6Yu4d889W4X+7MBp7ehzGQkO/VZyMcn4hTgCKRMUBmz+KBaNoLv5a7jHCH+
         3nl6v1qX82UKMof8PH1ZCZkYTQDCZb8hCGgIsKHe9+1RJWbdUo2ipBItUL+nM2HY/ZsR
         hiG1+38TsPa4VC0mQpxrYvcznaeFS7I9p8pDPWMVNTHNZ3mAzAbUJZ87laqXD+FMMV6x
         MNvNHekPyGwQH9qmJt8L/9mRLbpVDrQiY3i9GDFEiRPDg8lKPmLvdt7jpirkapELVxkn
         pntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607268; x=1782212068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HynPX1bYuHPedGhayckv3uSerJnSLgHUWuE3kdOkpaY=;
        b=dU5KKiarujq7JqWEoS11JAnfqMGT8VNNhuCVN6PA3JSvcJ7lERIZ4BYU0faF3+k14U
         Nw46+kVcAX4EDo4r4yz2ap3jxJs9jamnr0SlSDpe/qavR/90As9tpNTaNokglBKeQC3r
         T0DgnqCvBpLroJQc6bdeOq513eL4ROf2Q5f96q+6cD5QNP+vWGwINZJeGy95uzYi9oBo
         jY2hzQg9FZgHpbUnxUou99hbFKOm3MQBywKJsx+VJk7rbKolc/q0oMjxzWJhrx1fOyUo
         0WG+ET5qtS98bEsFCGDRT8efoZo4NH7oyu0SZFDSwIJUb88eBdeZ8Gs6ub8mzmX52Rr8
         BbRw==
X-Forwarded-Encrypted: i=1; AFNElJ/Vb6tX4HBc7IDVaKHU2cWb614dDcyZiFx48UT49b6l+5a2FF2RV7Sa2jWcqqc+odLx0wzyWHE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIxZMz4viwV7w/HDFrajBnPqQXw8ITTNCA4DDmzzXyUuZeQqAD
	4JKVu8QrFXA6DKPupYc8rJSXQQxlDUyvIghvGwS40Cygp4PDY1hC7PPUsUS6vB9bJ1phRD3Bjba
	+E6EYHcCpi3ifFmjWrLhUpKcZPOltrA==
X-Received: from ejbgh12.prod.google.com ([2002:a17:906:e08c:b0:beb:4d35:6d00])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c78b:b0:bcb:8b03:9fc2 with SMTP id a640c23a62f3a-c04148ad606mr213039566b.15.1781607267865;
 Tue, 16 Jun 2026 03:54:27 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:11 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-5-sebastianene@google.com>
Subject: [PATCH v3 2/7] KVM: arm64: Support FFA_NOTIFICATION_BITMAP_DESTROY in
 host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow FF-A notification bitmap destruction messages to be forwarded to
Trustzone from the host.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b1e5f9ee86ef..49a43c38a931 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -688,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
        /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_BITMAP_DESTROY:
 	case FFA_NOTIFICATION_BIND:
 	case FFA_NOTIFICATION_UNBIND:
 	case FFA_NOTIFICATION_SET:
@@ -876,10 +875,12 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
 				struct kvm_cpu_context *ctxt)
 {
+	DECLARE_REG(u32, func_id, ctxt, 0);
 	DECLARE_REG(u32, vmid, ctxt, 1);
 	struct arm_smccc_1_2_regs *args;
+	u32 idx_unused_args = func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2;
 
-	if (ffa_check_unused_args_sbz(ctxt, 3)) {
+	if (ffa_check_unused_args_sbz(ctxt, idx_unused_args)) {
 		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
 		return;
 	}
@@ -952,6 +953,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
 	case FFA_NOTIFICATION_BITMAP_CREATE:
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
 		do_ffa_notif_bitmap(&res, host_ctxt);
 		goto out_handled;
 	}
-- 
2.54.0.1099.g489fc7bff1-goog

