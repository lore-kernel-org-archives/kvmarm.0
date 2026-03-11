Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB131E85C;
	Wed, 11 Mar 2026 17:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773250748; cv=none; b=u0pYxEVj7aEzNGlKWjjgeiDGxB+QEaexfvIOSGikcYKdETVrWuxLrmFCLGYDt3N+YF9dUF8ExBX2jwVk6xqcWw8wuNrkzHRLgqYqtuI41ETCWIurYSUMJ6FLpAockRpbXrcjyHjTXwFGMnA6EwKllMF65Hqt8I0HRsrcK5uDlGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773250748; c=relaxed/simple;
	bh=fP9knvWB809mP95QO2qmeNhA8WW80ekwnk7WzqZ8LtU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nEUdK5FqPnu966eYSuz+2bQwl/QgOPMkk5LRQKuRUOyg3O3MxbvcGR3ECbgaR6oDplL7r4ZI7SJrFOALaG62Ioy+pXKj3Ta5QrFUjJyOuG3ufGdUI8SFoNdjOtDMK08dovLKkr8AWwiImJmDglBtj88YRchLIXVZvQm9J3eRW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUTiNV1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUTiNV1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BCBC4CEF7;
	Wed, 11 Mar 2026 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773250747;
	bh=fP9knvWB809mP95QO2qmeNhA8WW80ekwnk7WzqZ8LtU=;
	h=From:To:Cc:Subject:Date:From;
	b=HUTiNV1yR9BPpa9FYPJ75orhiMDMoTljqgdkwThDZKRRKhTn2V8Z2e7cterG3IR2B
	 s7BNvftfWlxiKIq7GyJeqjsGPU6KBXz86yfJBKnR0gW88sMPVG1eMTBiPUeXQXMCSD
	 EPJ/QyG2d4HAs+d0tJIWB0QV8tOtKml0w9W4zSkUVQlTF3vhoS74FZTYlVDYoLuSTQ
	 F3FcCE4Ov7jdOXUQjl7U8tekYhbAqrDp2d52k1/Uh48CijbYiZbtMSanYRqIDehN4l
	 5BsH/El1yj7xkhLHdQhGk1MmYnUdmL7PIOSKzjci1RdKgB64+7k1EUhY3wCoo2N47t
	 BpAdEDpBFy5Cg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w0NWT-00000000yNN-1L8K;
	Wed, 11 Mar 2026 17:39:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Valentine Burley <valentine.burley@collabora.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.0, take #3
Date: Wed, 11 Mar 2026 17:39:02 +0000
Message-ID: <20260311173902.329537-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, suzuki.poulose@arm.com, valentine.burley@collabora.com, vdonnefort@google.com, joey.gouly@arm.com, oupton@kernel.org, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the third set of fixes for 7.0. Two fixes, both related to the
pretty large vgic rewrite that went into 6.19. One is affecting
interrupt deactivation, and therefore leading to guests locking
up. The other is affecting CPU hotplug with pKVM, leading to the
onlined CPU not booting at all.

Please pull,

	M.

Marc Zyngier (2):
  KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
  KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug

 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kernel/cpufeature.c    |  9 +++++++++
 arch/arm64/kvm/vgic/vgic-v2.c     |  4 ++--
 arch/arm64/kvm/vgic/vgic-v3.c     | 12 ++++++------
 arch/arm64/kvm/vgic/vgic.c        |  6 ++++++
 5 files changed, 26 insertions(+), 8 deletions(-)

-- 
2.47.3

The following changes since commit 3599c714c08c324f0fcfa392bfb857c92c575400:

  KVM: arm64: Remove the redundant ISB in __kvm_at_s1e2() (2026-03-06 10:42:21 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.0-3

for you to fetch changes up to a79f7b4aeb8e7562cd6dbf9c223e2c2a04b1a85f:

  KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug (2026-03-10 09:48:45 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 7.0, take #3

- Correctly handle deeactivation of out-of-LRs interrupts by
  starting the EOIcount deactivation walk *after* the last irq
  that made it into an LR. This avoids deactivating irqs that
  are in the LRs and that the vcpu hasn't deactivated yet.

- Avoid calling into the stubs to probe for ICH_VTR_EL2.TDS when
  pKVM is already enabled -- not only thhis isn't possible (pKVM
  will reject the call), but it is also useless: this can only
  happen for a CPU that has already booted once, and the capability
  will not change.

----------------------------------------------------------------
Marc Zyngier (2):
      KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
      KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug

 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kernel/cpufeature.c    |  9 +++++++++
 arch/arm64/kvm/vgic/vgic-v2.c     |  4 ++--
 arch/arm64/kvm/vgic/vgic-v3.c     | 12 ++++++------
 arch/arm64/kvm/vgic/vgic.c        |  6 ++++++
 5 files changed, 26 insertions(+), 8 deletions(-)
