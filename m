Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C403D16E5
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790674602; cv=none; b=BGNAHE7uqTj5G64OIjGHg2T2p+zQeS2EM2WPh0K+VXGrgfxePFvvZd4GKn31WNMEARfiwuUa4WGcz3FL1uFsdNg8P/yXMZa6X/zdNfZZUdAMKkwEh4Kl6Y6GRXobcxDeGSVGhPo6ta5zSMSL5SrQtYprE8bkCF9lWtLtdOG4gP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790674602; c=relaxed/simple;
	bh=Bq3RlDkwfEKc5FMginwcfSHI+0+nd/OXq3ZVouyOlpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RC14zdDLzx16vbO/80oC/r8vWkdkk5bIqyc7uqMl1nDVWmX0K67yBski7RQSTJHzJmEpHcgyKRqcRJvk6VjGfbGkRg1W5xcBtPmFoBGecRuoUHbP8A/ZqMOJ6arhJxZlaQZdwGSuEfCW1x/LtyUGGPv5q/Cr8GhIMAGCk9VIgOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwcryUnm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwcryUnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01501F00898;
	Tue, 29 Sep 2026 09:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790674600;
	bh=LeiFWtNEfQIlCLdk5VOMusPM6Xa81QyDO89KQ0cDxT8=;
	h=From:To:Cc:Subject:Date;
	b=fwcryUnmOjuhztjAj/w700YKC/W5Bi2U2gx2HEFvbH26pS5uTNgdyfV6lLgFPIeZn
	 5+j5ajnsrjCcjxT1HQPEEpgb6RzEIVAQ1FMDxWAkCarlDrKE+w9zB/JTULDnVd7mji
	 +o38seElYNEQUDwZLnaUzZL8AgxKEbwSByEy8bqv1bz4HA71Z96IVh7gwv2uLys5OA
	 5PYMDVc6AgUngxmSjdh+n4y1Bf2eeCP6MiwxA8xNCUNRScuFo7DEnUj1nC4R9XbaBK
	 qEiTONKucDBCYV01S3CFkkZU8a6F+r09ZPbZizbLswblohan/tJfnqNVL1eV7qF75C
	 J25fHJkOyXlnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xBUGM-0000000ElEa-1S5Q;
	Tue, 29 Sep 2026 09:36:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH v2 0/7] KVM: arm64: vgic-v3: Make LPI disabling robust (and more)
Date: Tue, 29 Sep 2026 10:35:41 +0100
Message-ID: <20260929093548.3598547-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, ndaugoing@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is v2 of this series addressing shortcomings of LPIs being
disabled on one CPU from another. It has now expanded into some more
common areas.

Yuchao Zhang reported that disabling LPIs on one CPU from another
could result in UAFs and other horrors.

There are two reasons for this:

- the last_lr_irq pointer does not contribute to LPI refcount, and
  that LPI being removed results in a dangling pointer

- LPIs can be deleted from a remote vcpu by disabling them while that
  vcpu is actually running, and has LPIs in its LRs.

Address the two issues in one go, by actively taking a refcount on all
IRQs referenced by last_lr_irq, and making sure that disabling LPIs
force all vcpus to be paused, making it safe.

Review of the initial version pointed out two more general issues:

- OUTSIDE_GUEST_MODE is published too early, when the guest state is
  not yet visible to other threads, resulting in the wrong state being
  evaluated from another CPU.

- kvm_{halt,resume}_guest() can be called without holding a global
  lock, and therefore can nest. This can result in a vcpu being
  restarted too early.

This is addressed by the first two patches.

Finally, MOVALL suffers from similar issues as LPI disabling, but also
appears to be broken (the filtering on the source RD was accidentally
removed a while ago). Fix the filtering and move MOVALL to a "stop the
world" approach.

* From v1 [1]:

  - Fix OUTSIDE_GUEST_MODE publication to occur after the saving of
    the guest state

  - Turn vcpu->arch.pause into an atomic counter, allowing nesting

  - Fix MOVALL to filter by source RD

  - Make MOVALL a "stop the world" command

[1] https://lore.kernel.org/r/20260922214212.3327146-1-maz@kernel.org

Marc Zyngier (7):
  KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being
    saved
  KVM: arm64: Turn vcpu->arch.pause into a counter
  KVM: arm64: vgic: Allow last_lr_irq to be NULL when LRs are not
    overflowing
  KVM: arm64: vgic: Take a refcount on IRQs referenced by last_lr_irq
  KVM: arm64: vgic: Stop the VM when disabling LPIs
  KVM: arm64: vgic-its: Fix MOVALL handling of source redistributor
  KVM: arm64: vgic-its: Stop the VM when handling MOVALL

 arch/arm64/include/asm/kvm_host.h  |  7 +++----
 arch/arm64/kvm/arm.c               | 28 ++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-its.c     | 23 +++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 ++++++++++
 arch/arm64/kvm/vgic/vgic-v2.c      |  6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c      |  6 ++++--
 arch/arm64/kvm/vgic/vgic.c         | 21 ++++++++++++++++-----
 7 files changed, 74 insertions(+), 27 deletions(-)

-- 
2.47.3

