Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D50342CB0;
	Fri,  1 May 2026 05:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777613682; cv=none; b=vEcqGPt5mVDOsWrjl2dzpPTPl+5Mht93RS3S0BdsuJsqwgJph/+pRhNkX0f0YzrW1k3aE+maK5kL36Xw4WQLcO7elmDMVMEUdnl2VbLXsh+pSQPkKttud57RvxuuuirgSbJEpsPFoTfA8sNvgpBjVt1Wv1JZv5MZq+yWCtSmZWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777613682; c=relaxed/simple;
	bh=02hritkuRia/NUsILyAl+fwkSTtmm8nIN99AHP1vLTE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UWKMR2r/PjTABMnBOIj/wXavELssoNRyFlTnshaeD5cYU28gNZuaFeEijU1t15/TOq0KaFjLQ/It/vrNpBRjla7enM5GSqCZeTRgAkzRj5dreE/OurmFI6jaVA9D8ON7W0nFsR9yriI5KJBQ5e8Deb5BRiGJXKtEIZpTRuECO2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxIKvIzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxIKvIzw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F347C2BCF4;
	Fri,  1 May 2026 05:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777613682;
	bh=02hritkuRia/NUsILyAl+fwkSTtmm8nIN99AHP1vLTE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LxIKvIzwuPld8RUi9+MCpj3Gpfi7CH9jql5Lc0Y9H4aZf5A0hAhyaAPwm3nHyIRoa
	 TC3VgZwM21LA+8exLBg7jRDBo8+4usx7DnXZ02aFbRU/voSW9ZRdOgDMpeLDVBtNp8
	 z2zcybNEfyP7R7MCrG3HlOGvlanAS02HIDmqedpS8B/TIc7abNLc29xTpW1Pz1RWSV
	 f3dNVWCm7zkzuzliO49VuvBbuDqr/ZDlAkoigIAaw7FddjytCje9P6P5xooEh6SVBT
	 dR0lue9CCekQnKMSxqPQRQpwOtzwN6/1jnxM2lGr1Wy/n+ilbUfaNzgU+1AbM8ez8r
	 8I3lCwliMZaLw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F149CD3423;
	Fri,  1 May 2026 05:34:42 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 01 May 2026 05:34:33 +0000
Subject: [PATCH v6 2/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260501-host-direct-messages-v6-2-3f4af727ed85@google.com>
References: <20260501-host-direct-messages-v6-0-3f4af727ed85@google.com>
In-Reply-To: <20260501-host-direct-messages-v6-0-3f4af727ed85@google.com>
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
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777613681; l=2811;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=D52fxn/RTqq+qOlfiavgPL69WPcwS2YzoibHOHlzoKs=;
 b=lZWOdEHB5Rvp2EAxkToend0R76LiDEzi0pu+a914eZw/0wOL0GKZPr8ZeUugB8DouPbhrCPgq
 3OUwR3WhkavBg2JcAvGO0GOoP4wgmMJlNBGuwFwhcX1i1UKb8CnzcDg
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
index 3a58e01d255f..e5718c0f1c31 100644
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
@@ -865,6 +866,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
 			      struct kvm_cpu_context *ctxt)
 {
+	DECLARE_REG(u64, func_id, ctxt, 0);
 	DECLARE_REG(u32, endp, ctxt, 1);
 	DECLARE_REG(u32, flags, ctxt, 2);
 
@@ -875,8 +877,12 @@ static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
 		return;
 	}
 
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
@@ -942,6 +948,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
@@ -951,6 +961,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
 	ffa_set_retval(host_ctxt, &res);

-- 
2.54.0.545.g6539524ca2-goog


