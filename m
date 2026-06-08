Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4588C3D75B1
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937761; cv=none; b=D8SaujyUY//qfo7ri7P6TdDU83Qz5pHa6xJrX5AHStWIwGsv/FFR8YnaDT1faQZPqUQpu52OuY8c+pDKX9Qzlbw07N/VK3Z9c2XlUxgPwYxH4Nc6/i0/wtmTx4U+CwJwPTs13TMJXLZNflDZ9Tx+5diyQ8kvX21V+76DlKMazKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937761; c=relaxed/simple;
	bh=oAOA5EybKndmgBCuwAjcbu1eSQBnYactyGCVcpLbImI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f99p78mnDt/VhtdekDwZNyw2hTN3u1pIoK0PvI8B1fJgkD1HeS0xYJhPBjOt///pghwUDtql7ej1agyhAYcrEB+9lL/2qeUfRXpJdUDagYcg6WR78u0R/PDmRze54TFoumhGYU3wxGTj2kNhESDHU2kfbnqzXkxbGivTo8BDJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d5Lukuag; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d5Lukuag"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490bde3d239so35373765e9.1
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 09:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780937758; x=1781542558; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fiJTpHe0EoFyzEzrXyY6n13kVh9yVUaMFhDd94X4zOQ=;
        b=d5Lukuag55SmfcZzFxbIEHoI7wbExTpgKY1YRMCiPd7jcruvWaE7fDPjrTtP02Fsz/
         mgGOJRkpVTIKyfiKTUUWIA4BYByUN45D94k3I5Z0AUhShmSnZQ4ApVVfmU2nSG6KYszX
         RUei3+NmdPQrXTXaE2AiQKhu0t5Z6ijaWg0I9iTWC7LTIg6IpdEiuTAYsyNA0lkkCGyN
         PB+sbY6Bs2p6OJ7pOg+Jnz5P8rvkqWu1vT37N1D/H2RUPq9PYN5bYRACqrBqloLcIPKS
         xMpehoDbvlWoTna2nUpYhTYi9dFIvP7vICBJVtS4+vdwtiwavlNpHx7Gh6sV5zXuet9j
         hFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780937758; x=1781542558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fiJTpHe0EoFyzEzrXyY6n13kVh9yVUaMFhDd94X4zOQ=;
        b=HTe/Yy6dtEpZiBIjXyl4YguBnEc50/Gol0fAQlrIK25fTYyaopkTchODB3svRwApii
         /tmUqqLriGmy0FsYamZW+3dTtrF8jay9un/43IS3okxH0g/b1tNdrOvVnCZBBH6jZ4pn
         p6z/wDo3k9VW+KVCiS7AqzmV8nfNZKTdRxgYywj7AwhhW8L8XDXYaQ/qTAvDfj64S8m4
         KeHCsKRsslbXsWjzQpnjE93jcIOhU6mwflS8I6WJxtB6WnHO6NZveepAtzz5hseDUG4O
         aiSd72tinSSCotJjGgd9obI2fh+Uofvqncu+MPTvv+SxbGYS1A96nBHPgG5nQLDMpfJp
         WLmg==
X-Forwarded-Encrypted: i=1; AFNElJ9RlhYFKv/ZO56lTPM9lu3ZE1FXwVg/UwKVcaC7XwILTuk4TD616QzAgKenCn+AbQ+blsCVAug=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDJZ5gpp6g9lHQ9p51mhFGwFdDnNuYIHABOcFBBOMWX7WoTo0Y
	9J6RS5fcN/t8V7j5DAAD3STDDKHvP96juYq/a50R6SshD0AGhHq66NldbFqaJLVq/c1QvM5eT+H
	qtM1zdghUggNvDsCQQ5wqZiC258BeKQ==
X-Received: from wmot17.prod.google.com ([2002:a05:600c:4511:b0:490:b9f9:d4b8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f90:b0:490:c032:ae92 with SMTP id 5b1f17b1804b1-490c2610b21mr273574485e9.33.1780937757698;
 Mon, 08 Jun 2026 09:55:57 -0700 (PDT)
Date: Mon,  8 Jun 2026 16:55:44 +0000
In-Reply-To: <20260608165549.1479409-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260608165549.1479409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
Message-ID: <20260608165549.1479409-3-sebastianene@google.com>
Subject: [PATCH v2 2/7] KVM: arm64: Support FFA_NOTIFICATION_BITMAP_DESTROY in
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
 arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index c20d45191085..91e89d889c44 100644
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
@@ -893,6 +892,26 @@ static void do_ffa_notif_bitmap_create(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_bitmap_destroy(struct arm_smccc_1_2_regs *res,
+					struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, vmid, ctxt, 1);
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 2)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (vmid != HOST_FFA_ID) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -954,6 +973,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_BITMAP_CREATE:
 		do_ffa_notif_bitmap_create(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_BITMAP_DESTROY:
+		do_ffa_notif_bitmap_destroy(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1064.gd145956f57-goog

