Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6825334028F;
	Fri,  9 Jan 2026 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767998074; cv=none; b=RczKRZBLXq9W2yU9IBjTOifwO1aHatmUWRaK907t3OMC3ah7pn8yYYYmYrsOpR1VoAd7amPhe4vpsR/9TVe7s3EUBw2HnElwWuaJrIydjSN8gsRuBgy1P93DOZaRV49VpCdwSgyRG6lDLd/zJYJhYXXbZucY626PwVjApePgHgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767998074; c=relaxed/simple;
	bh=05F/pnq6jFjemspwANPBbd52Kjj0Z6y+VbVk7scofIk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hCqtBNXHLso8g5PE6tnZnFZC1Z/9qlzfzyEz24ojDgSVSlJWZ5Ocktshv2Du9YxnifQz/AtrY9ndoMfN/SV+Y9ms/Kps9JknTv9yDvflPHXCTlQxkbzPwNy/aAwZ+eGPbPqAFnj2/tFy9xHzDdp7iXTY8yXgTmlJdAyvIv1lOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sn55HArc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sn55HArc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51986C19423;
	Fri,  9 Jan 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767998073;
	bh=05F/pnq6jFjemspwANPBbd52Kjj0Z6y+VbVk7scofIk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sn55HArcIiOouKAeuh2OfyQA0m1S7IGtbEn8eNCdk3KbKfz3zPXCxyWRlTt+YHO3g
	 g26n754x/hKn/cKlbvw6Vosy3wnfo+fgynsGemdU2keob1jeKiTMK9V8EzwzHt6GLV
	 lFM5K1l+V0qtoXXoCu0p7F8n0gW/VLHfKK1NEgGl6yTUebxdLkXkIs/g0v9CsBkbk6
	 EL3rTedWTXSNHqe3z74uwCljlQKN9bcv64qmlEsEoeYDLOUSt0TW+FIO9p1xnLPHWQ
	 XaRLx1So2ErEtwJWj9vUW2rxh1gb246G6BDRJsNrTDSfofwHynpucFIJB/delo2Lsg
	 irHt5Z0iLlmEw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44381D277C4;
	Fri,  9 Jan 2026 22:34:33 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 09 Jan 2026 22:34:26 +0000
Subject: [PATCH v4 2/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260109-host-direct-messages-v4-2-95da4221d186@google.com>
References: <20260109-host-direct-messages-v4-0-95da4221d186@google.com>
In-Reply-To: <20260109-host-direct-messages-v4-0-95da4221d186@google.com>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Armelle Laine <armellel@google.com>, 
 Sebastien Ene <sebastianene@google.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767998072; l=2798;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=c3MrS/34znRranLZm10PrMUtpmE475TkuovXAS+5+MI=;
 b=qHkWu9EqF449Np1H2JAAHz8j+iE6gWLv7K5AeT7Nqhvh/p51nPW33PIWKuoOcTnK5KZwDHIEs
 JjBQG9RB8ywAGeU0DJkuPlT/wbrmuBR/4PtIVvslGM87mDE/w4w/B3w
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions and can use the
existing handler function. Add support for FFA_MSG_SEND_DIRECT_REQ2 in
the host ffa handler.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index fc84595007f310004def7d525371fa7c128f244a..bc4a6ee8f9c815d93e53024653f23a8c903a1b88 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -684,11 +684,12 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
-	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
 	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
 	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
 		return false;
+	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
+		return hyp_ffa_version >= FFA_VERSION_1_2;
 	}
 
 	return true;
@@ -865,12 +866,17 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
 			      struct kvm_cpu_context *ctxt)
 {
+	DECLARE_REG(u64, func_id, ctxt, 0);
 	DECLARE_REG(u32, flags, ctxt, 2);
 
 	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
 
-	/* filter out framework messages and validate SBZ/MBZ bits */
-	if (flags) {
+	/*
+	 * filter out framework messages and validate SBZ/MBZ flag bits.
+	 * FFA_MSG_SEND_DIRECT_REQ2 implies flag-less partition message.
+	 */
+	if ((func_id == FFA_MSG_SEND_DIRECT_REQ ||
+	     func_id == FFA_FN64_MSG_SEND_DIRECT_REQ) && flags) {
 		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
 		return;
 	}
@@ -936,6 +942,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ2:
+		if (!ffa_call_supported(func_id))
+			goto out_not_supported;
+		fallthrough;
 	case FFA_MSG_SEND_DIRECT_REQ:
 	case FFA_FN64_MSG_SEND_DIRECT_REQ:
 		do_ffa_direct_msg(&res, host_ctxt);
@@ -945,6 +955,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
 	ffa_set_retval(host_ctxt, &res);

-- 
2.52.0.457.g6b5491de43-goog


