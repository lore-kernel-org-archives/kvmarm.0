Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFC1366FBF;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839366; cv=none; b=htawwGWumrkPxcdhU4Xn/Ewpn9XnUAC5x5I+/gHyDqr/onv5M3ZJtpZ1Mg8YxUt0qBd6VWRjKD9Rv1c89bylRxlLD5z5EqE9ZhPeqwanroj4S+uWoNrctVeE3uAXfI15xQw8dtR+O6wEL+RdLIt7hvGOja9zo6MJRE7BhqqrEvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839366; c=relaxed/simple;
	bh=6VTZriykcZHnTH6rfuXOTxqsQqszWH20OmuuGXfj3bI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RWc+GRRR5/K8g5zSOC5ug8DLhRwGEgSd9TrpDrAW9MPqWFKgTw1kbln23lHTzCrV6L97kvkmHYw2BylEU+5B0hxtLu1dbfILfq9xqMYFqSEMKdXq4mEPOfvT7WUiyE5SabTfoX4D7s4tUUkIxY2CY7z9EZalqMJXsvA0JA8o6KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEY1+hS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEY1+hS+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2210C4CEFB;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761839365;
	bh=6VTZriykcZHnTH6rfuXOTxqsQqszWH20OmuuGXfj3bI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IEY1+hS+f3/WSLl1N4RfDsSMOedND8SWchXioRQ46n+P+4rZR90PNVP2pAhu91XxN
	 sIXl28oIksTFT/KrJYHGm7lYMF0QIUTWvkS5KiWnoq2M2NJCtvYQwHb5fubO69Um8h
	 b1cOiiCNdoJXtlyvY9ejGeRfvIT00tAgwxsJfaE3V94gQcirCXboEUUvCpeyhVetLI
	 YJYL6Q3p/+OaC3T4HCMYdl/Gy72lSD7eR+m3NYMSoA1vZcS73Odgy2B/4iCVo9CzGc
	 L3BMhfq3Pr2T3tDjnupkpm1wsbLaZjouISpgg5ozuNpJjECKoFlMf069GdzwPlVCqz
	 jxEPlQxVJYCgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B526CCCF9FE;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 30 Oct 2025 15:49:17 +0000
Subject: [PATCH v2 2/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251030-host-direct-messages-v2-2-9f27cef36730@google.com>
References: <20251030-host-direct-messages-v2-0-9f27cef36730@google.com>
In-Reply-To: <20251030-host-direct-messages-v2-0-9f27cef36730@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>
Cc: Armelle Laine <armellel@google.com>, 
 Sebastien Ene <sebastianene@google.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761839365; l=1929;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=9bdBd6zR/vrzbrRhnFCq/xFlDZJ4V6WRjWnGzzMGAW0=;
 b=fG8i5Y3uwvHySl80k0XI5clMqz5JSg7rKU3ajXxZfswA/pf/+18oowHhiWp9GDxpEj81j2R12
 FXSlsvmovVXBV1SqfaJrQPEUeDiy1M2myGl0aMx/64ORRnQZPWX/1fG
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

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index bb38ee7c86bad1646c16c562127eb3bef6297a84..956c408bdae45b087286d9d35348ef599b83e392 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -678,8 +678,10 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_SET:
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
+		return false;
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
+		return hyp_ffa_version >= FFA_VERSION_1_2;
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
 	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
 	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
@@ -924,6 +926,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ2:
+		if (!ffa_call_supported(func_id))
+			goto out_not_supported;
+		fallthrough;
 	case FFA_MSG_SEND_DIRECT_REQ:
 	case FFA_FN64_MSG_SEND_DIRECT_REQ:
 		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
@@ -933,6 +939,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
 	ffa_set_retval(host_ctxt, &res);

-- 
2.51.1.851.g4ebd6896fd-goog


