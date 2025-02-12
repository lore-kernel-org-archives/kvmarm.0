Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8825221D8B
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739381719; cv=none; b=jVcpz6MmS5CQdVqoYm7UcQ+KoaGpJV5hh3eHy/ciS3S8h6iBSuFmRt3iYf4qHr/vfqB0dkxSu2s8pd6GrOMMQV6bncONlq529Gag+82qi7lNfPLs1PNeg6ojbB0qBBMamZ4VNQ5ssXT3isETlRvxJQ7xEoqRF6KdtAAdDcOxfZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739381719; c=relaxed/simple;
	bh=Yb5Rglb0R+uczXoNPpb0G/nXu7u+4umVbrJjc/A3mRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QjJrEGm1latKcYrJ+S7btxp8D0t9LPehWcHlFSKA0hsvI96Ssuj29KQC1mGiZ8rcT46K8hy4Ndw1C1bNS8uFav9WxQ/nQdRPORT9EUXZG+hNAU6bRulUEoJRu8oK8y3SWtMJJaXh18/wGl+RFV+c/LPptCNoQH0hQnU68WblGb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbbolCVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbbolCVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49718C4CEDF;
	Wed, 12 Feb 2025 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739381719;
	bh=Yb5Rglb0R+uczXoNPpb0G/nXu7u+4umVbrJjc/A3mRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=GbbolCVvKzF/wLtwxiBZi1vOuyS5wkhAOo53LkJNo817Tsuc+MW62LGm33i/WzTeR
	 e+Ty9cL9d9+a/2qOV3YmVbgsZxIUgezSaD1e9MUEF7KSL3LIxiJE06tjjHiwJl4yV7
	 KOA7/DHdHShGrEiKsQ3jh6J9a2sE9ypeTFt8GEc0MFlCAo+m1qOZwX8dn3Cz1UWtRS
	 kXxrXkUOwwj3vaVadraIUA0hwno7zIo0uD8titPm5mQeUnlfm8DqDY+gDlZ1boMsjm
	 di9UyJY7TlOS+HIHWbwrMLxHu5/ELx9G1ibEqztsP8ifiqM+jdnrR3Rx2MbtN13hQ8
	 CdEe0cuVo7/YQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tiGdo-003QTv-Va;
	Wed, 12 Feb 2025 17:35:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH] KVM: arm64: Convert timer offset VA when accessed in HYP code
Date: Wed, 12 Feb 2025 17:34:54 +0000
Message-Id: <20250212173454.2864462-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, lkft@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that EL2 has gained some early timer emulation, it accesses
the offsets pointed to by the timer structure, both of which
live in the KVM structure.

Of course, these are *kernel* pointers, so the dereferencing
of these pointers in non-kernel code must be itself be offset.

Given switch.h its own version of timer_get_offset() and use that
instead.

Fixes: b86fc215dc26d ("KVM: arm64: Handle counter access early in non-HYP context")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f5e882a358e2d..23bbe28eaaf95 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -581,9 +581,22 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+/* Open-coded version of timer_get_offset() to allow for kern_hyp_va() */
+static inline u64 hyp_timer_get_offset(struct arch_timer_context *ctxt)
+{
+	u64 offset = 0;
+
+	if (ctxt->offset.vm_offset)
+		offset += *kern_hyp_va(ctxt->offset.vm_offset);
+	if (ctxt->offset.vcpu_offset)
+		offset += *kern_hyp_va(ctxt->offset.vcpu_offset);
+
+	return offset;
+}
+
 static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
 {
-	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
+	return arch_timer_read_cntpct_el0() - hyp_timer_get_offset(ctxt);
 }
 
 static bool kvm_handle_cntxct(struct kvm_vcpu *vcpu)
-- 
2.39.2

