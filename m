Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92B43538AE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972451; cv=none; b=fjmhhVkvUjunbTZT8hN7B3A0yiy+doyzE8YPmEW4Kk2PIwTvhgjgPMatVov7OCsMpV/dXTJaYAYj4Z2w+lbrfhMDjW9evXUeMjvfdUQI6BvealV5anzkX1NpckIUQeFcfl74gqAXVYQPL8WrmZCYfNH2YM/DiEX00ZvB6dQBZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972451; c=relaxed/simple;
	bh=FRqgu+EFqz02ePtaknEcKDASxY5EBt03ZV5dBoVUqX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnpdEh9RNyHHWBbLH8V7rAMlI53TJpUxyI0V6jQ+P5mN47XV2mN5IF9McuxpCTkI6p32JJMuhVpSi1ivTsdxqOUA0uAp9xkiQ9+AWjFd5xCH0Br1Av0RGsDrRPbqHAjBwVCa+bOrK2zM0UdIyda3Mn8Qu/uRGTfB8BYDqYOJ39s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmqfGZNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmqfGZNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C1BC4CEF8;
	Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972451;
	bh=FRqgu+EFqz02ePtaknEcKDASxY5EBt03ZV5dBoVUqX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmqfGZNAUWMngwaLIyvitpxzGggDihMFgMjXJjkywVCUIesFgFAZy4KZ/Nyx63VhM
	 R6/4Z34/Z1oBv8SVXNEcg1V2OfB0DIWAeb9m1OVJiaP3ytKBiYxV7dq5wtBdOPSXsm
	 TDev30vABkNaSeV82rAp1bIBHlrnRVgrAJftOl1WgGgQtZGFd1xC4PUzFJ9Y1Riwy/
	 JB4u/hWxjIOblTJByNzYmyYGeQ34/EyD/6CRIHJBBFlZoCDw93WvS5fpKyWH6K52sI
	 0i5G/mkbjfgvo34TKFlsI9v5Z8CiraFvEY/816sCnU+offtMRkGvuRPdvve1qYtrHT
	 14JIltNOMDg5g==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 05/12] KVM: arm64: nv: Advertise support for FEAT_XNX
Date: Wed, 12 Nov 2025 10:33:59 -0800
Message-ID: <20251112183406.2118981-6-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place to support FEAT_XNX, advertise support.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 92b2a69f0b89..08839a320a45 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1559,7 +1559,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
 			 ID_AA64MMFR1_EL1_ETS		|
-			 ID_AA64MMFR1_EL1_XNX		|
 			 ID_AA64MMFR1_EL1_HAFDBS);
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
-- 
2.47.3

