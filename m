Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D6320E02A
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384763; cv=none; b=fyzi1iubNejk8nVPv6Uq9e0Yt8lyiOeTvQY0Ac8STqw9JCPcFPN3+4T3PuStNNT6o9lpal/Wjpy1t7s7cJqC9fpIavWXFeXxLXL3UEZn87pviVU2BRTRRpBm+eaQrQUgwi/H4jepA8jxSqiODRsQjUW1lTSCH5d73uXOyo4nsj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384763; c=relaxed/simple;
	bh=4cuh+Su6YOW/JDAtjxMJGrPPdb0h5qJVydq5yC+hOnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mSnVxT4N4AzQtXWHFywhslSHVigFIdhds2n8E4BFqluw0eNBigdDSHuRJcWAmYxREVebeykfBPWp+4e3usrMf6RKqHp2J34GrHnQwFoIfB0TqRVrZa2XnEHJxWp1+u7i3qR8uSANaCz8sN08uV2BdIwFHcI3sJwnffcZ0nCVof4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUM2Y6a9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUM2Y6a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D47C4CEDF;
	Wed, 12 Feb 2025 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739384763;
	bh=4cuh+Su6YOW/JDAtjxMJGrPPdb0h5qJVydq5yC+hOnc=;
	h=From:To:Cc:Subject:Date:From;
	b=rUM2Y6a9St+E2+MsrkLwReQO7EJfa4V+1Xz24l7jOuKvph0CvFUikBigRzjNqEze2
	 H+hQlxZJRc+kuEWGGxAmQIDne0xHqyv0PkR1GsesxRbykwahkaZdMBSc4CcTLZCLuI
	 p4c8qD24n29JzHS1ECVLNZ47GJ9bcbcrxReMbpVWsnSFUaiMVpUJu3ephA7qlqfyRD
	 /TsrIAhsbhARRdnzVbWAtm7B73Cp6kKV0UibE40wWh1GOWBL1SXBIS2nEnQMYhKEeu
	 vhn0pQkpoqQ7imWGkhdK6QkVcDeKdgFBldFK1P0JDiM4g9KC+1xFy3tF/P+tpUMFxs
	 lCqnEZI+xSF4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tiHQv-003RQt-Et;
	Wed, 12 Feb 2025 18:26:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/2] KVM: arm64: Assorted vgic fixes for 6.14
Date: Wed, 12 Feb 2025 18:25:56 +0000
Message-Id: <20250212182558.2865232-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Alexander, while fuzzing KVM/arm64, found an annoying set of problems,
all stemming from the fact that the vgic can be initialised or
destroyed in parallel with the rest of the guest still being live.

Yes, this is annoying.

This second version takes a different approach at the problem,
plugging the glaring hole we have between vgic creation and private
interrupt allocation.

Although this is more invasive, I'm more confident about this one than
the initial version I posted a week ago.

Alex, I'd very much appreciate your testing on this.

Marc Zyngier (2):
  KVM: arm64: timer: Drop warning on failed interrupt signalling
  KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to
    kvm_create_vgic()

 arch/arm64/kvm/arch_timer.c     | 16 ++++---
 arch/arm64/kvm/vgic/vgic-init.c | 74 ++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 46 deletions(-)

-- 
2.39.2

