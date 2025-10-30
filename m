Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4376331B111;
	Thu, 30 Oct 2025 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827391; cv=none; b=YzHnB9i5R2OMAUR53aLbxXx+LvSOtsove0pT2mN4VACUC6YaPEoZnJkaDs53pkeBbYb2+QwJGjQw7khHZ+NJB1vS5sMHpJuNiaqUjyLPlv2xPZlso8qt/qqctl5XC/l6iLpsu6Xw/VwCHZPGmt1xA+CcyoARJGssvOHCyQ1SJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827391; c=relaxed/simple;
	bh=fgOOLeUvZ6glaF46GxRT1Aj1x+Jvm0R3Q7R1TSXPqfQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H1DypyMzgqtPY8az8ky3xPg0OiLwbPifojL8yP3UhrrZAQFBXVxnQHW0Kt309riiF09bmnh8ezDMr7WepTfLTYj7FtBNKeVyjJKh9vrxlEo2GCin+XejAZ8CMc62y2rcj/g085bCJzXm5y/ajIoyJFHpHOWCD2z+MmP7PClV0No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clIe9lb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clIe9lb+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E57E6C4CEF8;
	Thu, 30 Oct 2025 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827391;
	bh=fgOOLeUvZ6glaF46GxRT1Aj1x+Jvm0R3Q7R1TSXPqfQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=clIe9lb+orxwVdXVhS9vqanTMJN7PdSNCpo9u10JlBFFvS4SK8dPa/3po69D+jaGT
	 Gs6xNS0itz00LimV82eT/RU5LgguhVuGMyJztF8o7/UD+fxyK1i4Pzv7MNLNZ+XHPx
	 EPgczMWVvQbS14+BVB/bhMD2cpdEnOutzmLLXiBTz3Szllqta2E4S6QCZnJNrtw2Mr
	 cuIIhlgutXNomCZ+hu3DmOdcWKtJMe7gTqzlE/ndaIegc6L6YI4guRuHG9dosVnHg4
	 3AtEu8OqisIUzV8q/hgIs8v1OwA7lOv5agOrRAfdEPsB8PmGI38Z+wsCpnXoWPendb
	 zQP+EzR7EDL+w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58FFCCF9FE;
	Thu, 30 Oct 2025 12:29:50 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 30 Oct 2025 12:29:40 +0000
Subject: [PATCH 2/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host
 handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251030-host-direct-messages-v1-2-463e57871c8f@google.com>
References: <20251030-host-direct-messages-v1-0-463e57871c8f@google.com>
In-Reply-To: <20251030-host-direct-messages-v1-0-463e57871c8f@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761827390; l=1942;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=QxZkKMqi/Ka/Bt8dEMac3ymGIIZGsPQ1NfjGo7wQEis=;
 b=8ywtiCGB8mwprQrthoWa0O24bMcir1Z+Rys+iIdKk3OinyjZdaGqelVpLnYljjaZxQ0pRmQc1
 ewIm3YUglCmBIqfRVA4Hde/e8HWuzXQ7TIS2E1RKeB5DniGk315YOZS
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
index 191dcb301cca3986758fb6a49f15f1799de9f1d1..0d91411fd1d0d3fc48d725c51a7f3c77372374be 100644
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
@@ -927,6 +929,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_ID_GET:
 		ffa_to_smccc_res_prop(&res, FFA_RET_SUCCESS, HOST_FFA_ID);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ2:
+		if (!ffa_call_supported(func_id))
+			goto out_not_supported;
+		fallthrough;
 	case FFA_MSG_SEND_DIRECT_REQ:
 	case FFA_FN64_MSG_SEND_DIRECT_REQ:
 		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
@@ -936,6 +942,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
 	ffa_set_retval(host_ctxt, &res);

-- 
2.51.1.851.g4ebd6896fd-goog


