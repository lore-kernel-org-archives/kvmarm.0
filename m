Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00854F5E0
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855276; cv=none; b=L3hRDPBVQBxDKJOt0sGYag0TTF/5J0qzi20Zztrb5Zjb6Jq4Nk12zRBpr4FGqGD7ZyuviSlSk+bn49tYdsj8abvFXomBzUszU5f71EiudIjVGbdVn1dW544KLUToG1nHGbB2cXSwZb7hV1iLveEB2Ozyb2+2hQ3iDtSZkV1tNJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855276; c=relaxed/simple;
	bh=FA5r9vVNn5Za/abXLyc0dZQCbgu8AwK0WPUB657F/R0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LKW/JjQx5Wn5QPaKgNe6L2uKUV4Y7V5pzmab1VLdNgnVxNh51Q6G8Ou1wr3vQw2uRVX7kzi5lwWnQ4zkQcWy378ujXeIttX/Ff/VlRN22MQImDMyhtof8meCw/iqcyh5l9MUVbhK1xCQS37tpmm6GpCBiz7JT+SjnbTZ3/MSbFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtvx5bfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtvx5bfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAE2C4CEDD;
	Thu,  6 Feb 2025 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738855274;
	bh=FA5r9vVNn5Za/abXLyc0dZQCbgu8AwK0WPUB657F/R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtvx5bfG+YzBIuNgI8MutaU6u4MEd+a5+k0FDYQPlfyJjS/w8VfJWz/2rDBwnmhHC
	 GTOSIQgxMTddh1inJiPR9eaU10ug3jfaiyk90/Z95UOc5kty8cnBhHAXNVXPCA1yNV
	 BePhIjh0pabLNtOMr3NFUcDzG+qEfxk2Oxn6W16FCF1T/HNY4IfGVr3CzuCgTot6pT
	 5zRX+aogXO7Y9f0OkYxgnSzKRzEaggryQEKA+qhlmJbgbRxNhL965qeh9SWLix+inV
	 lRyOS2A1bHVUr8p9/Ri3QfixSve/FTtoy7Ovfg0EYgdOnBhkFLPYxGLAA0RCPgKdac
	 bhS9eyD6kp+Ug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg3gm-001Axu-0W;
	Thu, 06 Feb 2025 15:21:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: vgic: Gracefully handle resetting an unallocated interrupt
Date: Thu,  6 Feb 2025 15:21:00 +0000
Message-Id: <20250206152100.1107909-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206152100.1107909-1-maz@kernel.org>
References: <20250206152100.1107909-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, glider@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Playing with racing vcpu reset and vgic teardown makes it relatively
easy to trigger a case where, by the time we try to reset a mapped
interrupt such as a timer's, the vgic is gone and there is no
interrupt to play with.

Check for NULL upfront to avoid further embarassement.

Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f454cef59e24b..2ea6d1d1d3091 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -542,6 +542,9 @@ void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid)
 	struct vgic_irq *irq = vgic_get_vcpu_irq(vcpu, vintid);
 	unsigned long flags;
 
+	if (!irq)
+		return;
+
 	if (!irq->hw)
 		goto out;
 
-- 
2.39.2

