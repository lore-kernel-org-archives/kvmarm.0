Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702F221C9E5;
	Fri, 27 Jun 2025 07:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751008381; cv=none; b=VcFkuWY6DSVJxx37haabm25WCkC1RJVYGM0rpdt8S5Oq/c1hC9Ma2fG00DcI/qvDav0K9j+bY4QajMvXdMOAOHlVFgeb/2ZI5ISaJR6n2jDR5+atzguvhAxISdv8nZShOWQKdOzKFqwjBSMl9ZUiqJetBTSxJfWHh3wAqlVaRGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751008381; c=relaxed/simple;
	bh=klh+xDRcULbooF8MFi5xLowZY/xbmuqnM1SLK8gC+H0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V9MURxLzNjgxBDO9jclaD/v5IAWBDM4GoEEUcDGuUcHtoclSdS86F+cnS+LiEIokb+cejh3MzFDZLnU5kOI/9BIAFIPWOcea2FFNIkUyMX91sgX+ZWIxpNs2vuHe+1mzpOX0WYRWpqiX1Adx21G4x91VLwaqNoC7JiYT6aFkwAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfAJPJ8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfAJPJ8S"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E310FC4CEF4;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751008380;
	bh=klh+xDRcULbooF8MFi5xLowZY/xbmuqnM1SLK8gC+H0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IfAJPJ8SMCtd/QKuPwxsR3R5mn/1SvpH24+BqWVziK5kvI/Pj7RGNmR9dxxc7qWFS
	 6PFbbuI5I9xyJWEZbz7hh1MFR1Wm7NOr+nswUf8r3VobmXEdh8eIGYerwl53u3PEVg
	 +AcVQasenUj4lJn048F3+adGJHeaI6fz2+J+DwtEwkdtKi+sCpmaaDBoQ2brQ54xQO
	 F4k7ijn+8/uL1+SW/cgH3RNqLIsJPQAEOouIym/cusccU+5VbGMOZFV41UrOTt50gR
	 pIRO4vN5gwzqsri57CETDLfhYlMS3bZpJNz30gJpuXXPOZMpwb3usVAHdUASO8jK5C
	 67TQXt8c8Tagg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CBCC77B7F;
	Fri, 27 Jun 2025 07:13:00 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Fri, 27 Jun 2025 07:12:29 +0000
Subject: [PATCH v6 5/5] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250627-virtio-msg-ffa-v6-5-8c02fd94edac@google.com>
References: <20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com>
In-Reply-To: <20250627-virtio-msg-ffa-v6-0-8c02fd94edac@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1751008380; l=2999;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=Hltr6esYXys/fifuX4LJaE69K+4zBEQKpm9B+c1zcxQ=;
 b=3eyayw173eIS/U1YOT+pKH7Ed66MiRS9vDdxdwYsb5K9W5IEqrqub9hlfkRlkmLBHCm4nZ49W
 oCXO/uYF60hCMYXVCEeNHIw3tJZYAAeamsu38z42BsD5auTmlovJ35E
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
in the host ffa handler.

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
 include/linux/arm_ffa.h       |  2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index d543d1f5ddd62fb15f8d39f4ff7d5bb0006da4a1..348c5aa93ab8ade2b26fc86ed2169d801784a892 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_NOTIFICATION_GET:
 	case FFA_NOTIFICATION_INFO_GET:
 	/* Unimplemented interfaces added in FF-A 1.2 */
-	case FFA_MSG_SEND_DIRECT_REQ2:
 	case FFA_MSG_SEND_DIRECT_RESP2:
 	case FFA_CONSOLE_LOG:
 	case FFA_PARTITION_INFO_GET_REGS:
@@ -858,6 +857,22 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
+			       struct kvm_cpu_context *ctxt,
+			       u64 vm_handle)
+{
+	DECLARE_REG(u32, endp, ctxt, 1);
+
+	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
+
+	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
+		ffa_to_smccc_error(regs, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	arm_smccc_1_2_smc(args, regs);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -916,11 +931,18 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_PARTITION_INFO_GET:
 		do_ffa_part_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MSG_SEND_DIRECT_REQ2:
+		if (hyp_ffa_version >= FFA_VERSION_1_2) {
+			do_ffa_direct_msg2(&res, host_ctxt, HOST_FFA_ID);
+			goto out_handled;
+		}
+		goto out_not_supported;
 	}
 
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
+out_not_supported:
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
 out_handled:
 	ffa_set_retval(host_ctxt, &res);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index c0dd6183d956043192114a522b7eef465e7078ac..82a35a3b22de426f7e9a8894e76fdf1e933b3d6b 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -269,6 +269,8 @@ bool ffa_partition_check_property(struct ffa_device *dev, u32 property)
 	(ffa_partition_check_property(dev, FFA_PARTITION_DIRECT_REQ2_RECV) && \
 	 !dev->mode_32bit)
 
+#define FFA_SRC_ENDPOINT_MASK	GENMASK(31, 16)
+
 /* For use with FFA_MSG_SEND_DIRECT_{REQ,RESP} which pass data via registers */
 struct ffa_send_direct_data {
 	unsigned long data0; /* w3/x3 */

-- 
2.50.0.727.gbf7dc18ff4-goog


