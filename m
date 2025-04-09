Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF951CDFD4
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214482; cv=none; b=DXYnNmRKbIAoB7CRiNI5Dw7/j5iyM0HUi5JucvqJMUaahZwLQzecskQBtqQKBJmi/QN9ecVVGoa8SfH2CNaNVbP1o87KipQYKEvpS1yooTlbdc+mOQPZqmfKJ0YGbcVP9ilWL+G38/iHn9Tj1mTraViqz2Z5ysBtQz/4TFyHFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214482; c=relaxed/simple;
	bh=zE7v3woldsAMp5t8tth/aBX09I084DJo6S8fLNtF7O0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=awxnAJ4QrwHv2ufLOWbDlX2zFwuM0jJ4IYDp9qDQOol49Bb8bBgQN0gByNcjkNhtxwBfk3g/c+qxagc9VhE8a3o+cOQl1Ll87togyQ8sfKPSn4r+Kn/EEBXL997ROXwG/29IUoHdQy9Dy+EdyPEdKqXYWq9e/5ObZ3VBlCBi5eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKHj/ihL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKHj/ihL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B82C4CEEC;
	Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214482;
	bh=zE7v3woldsAMp5t8tth/aBX09I084DJo6S8fLNtF7O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKHj/ihLzaVxsx9LYPSFuiDXKhLQsvp6KqIvU2nkc/yIvaYy+EiEPFQxX3Ms57jfm
	 Z940FggY4/aox71fBytDCLb90Qye4YDUur+tEHuPBhM7fG8Cl92RxP75tGta9Ib1//
	 f0HKW2q5ldVsq6Sc1hYTRD1dXqCXpWOZqRvXkN9TIcQ73PpzbsNknRjLg4laaj0vZR
	 jGb28sog+VVhYm/ofQxn0A/wkZSjFSRoNj3uAQQQ2SbuC69rN7df3h9SiweEwEAx5b
	 fPKL05UETM0J8LHOLV1G5+YqvL451CMZl+go3zVhiGhVt1ptJdWjqd40fQ5UV0y9K4
	 Mr4hnx0CM/1OA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u2Xrc-003vQT-QO;
	Wed, 09 Apr 2025 17:01:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 4/6] KVM: arm64: Don't let userspace write to PMCR_EL0.N when the vcpu has EL2
Date: Wed,  9 Apr 2025 17:01:04 +0100
Message-Id: <20250409160106.6445-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250409160106.6445-1-maz@kernel.org>
References: <20250409160106.6445-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that userspace can provide its limit for hte maximum number of
counters, prevent it from writing to PMCR_EL0.N, as the value should
be derived from MDCR_EL2.HPMN in that case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 73d68ea37ac21..00b5396492d51 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1216,6 +1216,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 * with the existing KVM behavior.
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
+	    !vcpu_has_nv(vcpu)	      &&
 	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
 		kvm->arch.pmcr_n = new_n;
 
-- 
2.39.2

