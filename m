Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6F2DB7BC;
	Wed, 21 Jan 2026 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984039; cv=none; b=u2GkORUHXAogbR+szvGnqzXpje6lSc2RAC341Rv2DHRTlbJq7qi5GLDq6cveGWfy9bZphOA4Ltd7aBcEbOcWQTLDbYTgqFpolwVed/IRa6tiP5Faj7bY9FoWe40A6u06e4izO82y+JzSGC8qVnnwHCVOyR3D5YZjZ4ti4vT5eq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984039; c=relaxed/simple;
	bh=SyPIZsMlIG61Kq8puZHgC7hUljf3iDtaeBjcPyeq3lo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r4rztlSibHx0u/ufoWI+ta6GenKemt69AOL8F8MgJdFelU2uSV/yRqBY1G/I8oTk7nyHf6yflZAztgRjOMO8EShTJ+T0tk4GiiF23/j7y5HZ53609cLaEHYcaO+oeWx8ZEnXoWH3pYHjA9ddNOTMnBeSgKmROgtPKrbsJugB55A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4+z7JZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4+z7JZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EDC2C19422;
	Wed, 21 Jan 2026 08:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768984039;
	bh=SyPIZsMlIG61Kq8puZHgC7hUljf3iDtaeBjcPyeq3lo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=T4+z7JZ8lvI3woyZCK4hKlG+bHCN3C+hbl7PRqR5O3JWg3Ggz2gWwYOJLEyZNSIpC
	 8X6LRj45AUU/glSIi3UMQOnHNxu0/EnJvle4geCZYZL+9DYbD0/NJK5u/8WX4WzrDq
	 hhJBfaG5zVPnHh07gHR09AuePhm3VYt36fIWrcbOVJ205nUn7ym4XKjoKp9T3i6oqA
	 s/ZpItBQUOFacEyDf2RyTCBLyC3kvkrQILJABsIjNIb+sBo30iSQURWPNHpvGfB0RI
	 4RgAwy8ApFx5M3gAqh9e3MnhqBv9vAzvfzc3k3HCLqVGuM8a/9AUgk3356lsl9RO0x
	 WeY+0yadIlrFQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF1BC44501;
	Wed, 21 Jan 2026 08:27:19 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 21 Jan 2026 08:27:12 +0000
Subject: [PATCH v5 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host
 handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-host-direct-messages-v5-1-2c1614c94e80@google.com>
References: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
In-Reply-To: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768984038; l=1851;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=eT388oj4q47iBalR34kwWW4hk/+jGEm9EnHSMKSH2ow=;
 b=U49TOQbINLF9oXJRhX9PpPo8EDPsthDmeyQ1Q1g83aFJQ3ymtU/VfEG43VzgNVg01UFtKVdnC
 sylkLKwmb7eAP49QtQVgmKTLtuRU6yPW6FLKE4sK+L1QQ0Utqn1wevC
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Sebastian Ene <sebastianene@google.com>

Allow direct messages to be forwarded from the host. The host should
not be sending framework messages so they are filtered out.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index f731cc4c3f280a32acccca0de92b9ac6c8e05602..9967916278a7ca051500946ef2fcfe7bb40e0e8d 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -862,6 +862,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
+			      struct kvm_cpu_context *ctxt,
+			      u64 vm_handle)
+{
+	DECLARE_REG(u32, flags, ctxt, 2);
+
+	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
+
+	if (vm_handle != HOST_FFA_ID) {
+		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	/* filter out framework messages and validate SBZ/MBZ bits */
+	if (flags) {
+		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -920,6 +942,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
2.52.0.457.g6b5491de43-goog


