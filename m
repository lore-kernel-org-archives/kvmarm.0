Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14749366FCC;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839366; cv=none; b=IRoeMVzMOoMB1DTwBC7RRZOwchV6PDfmPtOOrxjNc5XWdmeN/SjbYCCp8aaY7ucu6X+P8O5sntfS3ExdzfRExyfDWmuyy4xzVUzF60gU98rnF2mUkI9zvJOffVr+KvKqm7WMtuMn6Tqfx4puC3vOlVFnNb6stSDZcjq/nbgiKs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839366; c=relaxed/simple;
	bh=CwOIisKHYvAmRG+wWlhNJEzBcAlffhoo6ItwxUKDQVM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m8JBUBmHX7WY5vQWSukwMzJD49Ig+LdSD9H5vSI8Rh5hKO1htmjI/ftaOTxhibSNCCVvM+eK4w0065dek0Up++076f/q/mWiMps43iysLbOnTzTzOBluFGe9TE4ivPWA6IBV5I1r+vjGTq1fzCNAzElwBfS7OuLqIPiycWq4sNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qih5DTbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qih5DTbs"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B048CC4CEFF;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761839365;
	bh=CwOIisKHYvAmRG+wWlhNJEzBcAlffhoo6ItwxUKDQVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Qih5DTbs1bmHHQPQGQ/MG61Vcp2HIcGTLEUARlS/AaBvCE8HBt5R4c9ml7aNGj8OV
	 RWFUZKCm1mCNGX04MHtazot94u3ZtiT6vfHMOSzHvUefk98ZcbYArIII1MODFxIRzb
	 jOzVAleuo7WFckrLOX+EOX6dLYUS1t0sSEktiiKhvcyo/oM4Dr/A1QECAdhSJem+Ha
	 mXMbKjX4EoPzEoFtTZJKJ5N0Im9aCN5LtyDqSRT2j729O8DGfXznSOVLcoGyQTsfCn
	 RWgLne2qJQHlQxfbPHHzSJ35EsXpJPlBWbXz+RM6GRipkT9MKNrd+WzOLV0ZIWCWQU
	 xoQYw5VaSQDRA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A644DCCF9E3;
	Thu, 30 Oct 2025 15:49:25 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 30 Oct 2025 15:49:16 +0000
Subject: [PATCH v2 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host
 handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251030-host-direct-messages-v2-1-9f27cef36730@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761839364; l=1403;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=0LYGXDdF4rmG4qPqoYjpVqiYwow3EdKdfM03tgJvlB8=;
 b=98ShcxNmKo+TYyhHfNO6sEe4kutfeS5ubK1MWanjdr47EqL8e72h8ydRgWSNEFMlqezCsPBO9
 gQxfzEzc+yRB6NQGIqnuuGjJdqC1lk/wC4Dw7WTINrm0H3gWSPOvvH7
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Sebastian Ene <sebastianene@google.com>

Allow direct messages to be forwarded from the host.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 4e16f9b96f637599873b16148c6e40cf1210aa3e..bb38ee7c86bad1646c16c562127eb3bef6297a84 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -857,6 +857,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt,
+			      u64 vm_handle)
+{
+	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
+
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -915,6 +924,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ:
+	case FFA_FN64_MSG_SEND_DIRECT_REQ:
+		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))

-- 
2.51.1.851.g4ebd6896fd-goog


