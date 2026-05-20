Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46492370D56;
	Wed, 20 May 2026 07:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779261939; cv=none; b=kT+YCl1AbY06Wh1Vrnmt6EJo7eRNLcfeuMx8T4PI+HDQie5NHuyQm1k06Uz38bG5VqqbrgGaeFP5p55q/TeYnG4J6rOG6giw/NloMxr28qOgVQbUlON22UBIuddJPZKwMq8a3/lXMmUNWf8vwYq+UOKtAmtd73+cSBDbXXTYCIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779261939; c=relaxed/simple;
	bh=GwIP/dWcC7PPaAozm6r+PIZUly49RpKkMaUyxW5gBC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dhf3xMSHO40Cb4MHiCeD1OUUyzhN0zjiztM1Lt7wZSsBH7rPsf8o9sqqmoWh68xemvHCF4Ruy0LrsEm6L7UzKNDnGgXX0U3V3doFcEie02RRMk852+3SkTczPZmLy5QSeXaKZk3h60Yf00qTpjx5LOmMb7h6DdH+dATQo1wedUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SS9dAaIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SS9dAaIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2242A1F000E9;
	Wed, 20 May 2026 07:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779261938;
	bh=1ZTWmcfWcBrA6asMVKYTryHIgkiaWDb98CfxFaa4OIE=;
	h=From:To:Cc:Subject:Date;
	b=SS9dAaIqeG7mtcm2GEXgu+qdkW6PkS0MxthmRj1KgDVKu74fkj4Tc7Nt0vrt/ZzT3
	 vvvQTV30s3BqNNNGlQocs2ApQK3Y0oXiv4EnRU6mBqksH/NGCODbkCTBwqm6ZgC781
	 iNYXVcO9+EUwwB6Y5GYHyEjSss4Ob4a3elHlCTTZgkIoInJ53ytYObSrntu54WUTS6
	 IuN//gDrTcxV+98ceFu5+4kqzvrcl7ijB2OEj7Br5Hr8DQyoDYj7pSVtRfZveeQZJI
	 zVt8YTiQoYZ9L68ma7SBKG1tIeaGsdxBZEBO/PqDv34rG++aVQWnwFibcM00uqcwdl
	 /7lhB+AaaXoxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPbJ9-00000004Foi-3hWZ;
	Wed, 20 May 2026 07:25:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.1, take #3
Date: Wed, 20 May 2026 08:25:18 +0100
Message-ID: <20260520072518.504865-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, michael.bommarito@gmail.com, vdonnefort@google.com, will@kernel.org, yaoyuan@linux.alibaba.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the next set of KVM/arm64 fixes for 7.1. Continuing the trend,
we have two AI-fuelled fixes, both of which are stable candidates.
Additionally, a minor tidying-up of the hypervisor tracing descriptor
validation.

Please pull,

	M.

The following changes since commit effc0a39b8e0f30670fe24f51e44329d4324e566:

  KVM: arm64: Pre-check vcpu memcache for host->guest donate (2026-05-07 14:12:42 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.1-3

for you to fetch changes up to 1702da76e017ae0fbe1a92b07bc332972c293e89:

  KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc (2026-05-20 08:08:37 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.1, take #3

- Fix ITS EventID sanitisation when restoring an interrupt translation
  table.

- Fix PPI memory leak when failing to initialise a vcpu.

- Correctly return an error when the validation of a hypervisor trace
  descriptor fails, and limit this validation to protected mode only.

----------------------------------------------------------------
Michael Bommarito (2):
      KVM: arm64: vgic-its: Reject restored DTE with out-of-range num_eventid_bits
      KVM: arm64: vgic: Free private_irqs when init fails after allocation

Vincent Donnefort (1):
      KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc

 arch/arm64/kvm/arm.c            | 4 +++-
 arch/arm64/kvm/hyp/nvhe/trace.c | 9 +++++++--
 arch/arm64/kvm/vgic/vgic-its.c  | 4 ++++
 3 files changed, 14 insertions(+), 3 deletions(-)
