Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC6E31A546;
	Thu, 30 Oct 2025 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827391; cv=none; b=B+Hn1Hima+LJftR9OtxeQEgzclT2sYHRWLCUf8uobas0i41lzaIHAbAyf37p2hEaqcgskAQhWenb1ChEKalxmJ7ziRD9Y603xujaMfEtquljAOgsAT1aGNr6f/qoNwXztl8NmF2G/wdiS7PB1uwkr0j8Xf4T/x3xFCYzpLFoA2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827391; c=relaxed/simple;
	bh=Q+GOMdkG1FB3jSW88g07UsTgUWJQy2XQNljlWue4uuo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=on6eFC8OXJIgtn8vZ5M5Lm8oxjVlPOgfytjvRLyJKRM0F/2DQFlMQaGhedITV/EbeUgkTDsmfLqN/LJcyFZBCMhLKhYJ3fWsLTXNcG56n4XIuvq4cQa2uvjyv6yQ9z7vQZ4DOum/0GZoqmbqNt+l9WuXykhKdrmvq6yrGGpPn1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csODDuDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csODDuDk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6A4BC4CEFF;
	Thu, 30 Oct 2025 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827390;
	bh=Q+GOMdkG1FB3jSW88g07UsTgUWJQy2XQNljlWue4uuo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=csODDuDkn4xwKryMvn8GkT3ztdiBKr1W9e34IZ2RuCWPzBBEK/W7ZYZklmn/pPi9U
	 ftz7pyTqWZ4MKhFLS2cY+Z/IRUedQVqs+CVlbGU/4ZR6Lky2F7dknipx37vK4j3c4X
	 PK8PyCsQbHYFy2QBXKyew37nV87ow96rU2LJNIjXUaV9MsOsxwOadmXPFz9oJtioQS
	 GeBCGraveLRHeXDNNjsdFxMOfg98NCItOFaDZtNp2iDjnqShrkUMs0DeVIP9e0OMix
	 J20yY5zOhcjDvhZMKBUAVDGWXbiHKC9x9za72eT/Qb7S7DjoElTHp4hdG9b7KtzYVr
	 mdhFhllJHfsQQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ECECCF9F0;
	Thu, 30 Oct 2025 12:29:50 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Thu, 30 Oct 2025 12:29:39 +0000
Subject: [PATCH 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host
 handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251030-host-direct-messages-v1-1-463e57871c8f@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761827390; l=1511;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=BppMAkhVkyzCH/xZJ6azsBbY51/loFYz2Cn3TqCanQA=;
 b=AI5KD/hIn/k7xCivnA6GNaEoDO7W4H6pgzXhONdZ2MNgVT/57rQhIb/m43ttB8XKzxYgDa7iC
 WZU6vWuApYfCKlaHl+bg35iFoBh0WB3ipZm5MeYLxpBSmgEZkY6xfPN
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
 arch/arm64/kvm/hyp/nvhe/ffa.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 4e16f9b96f637599873b16148c6e40cf1210aa3e..191dcb301cca3986758fb6a49f15f1799de9f1d1 100644
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
@@ -915,6 +924,13 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_ID_GET:
+		ffa_to_smccc_res_prop(&res, FFA_RET_SUCCESS, HOST_FFA_ID);
+		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ:
+	case FFA_FN64_MSG_SEND_DIRECT_REQ:
+		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))

-- 
2.51.1.851.g4ebd6896fd-goog


