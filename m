Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441921E097
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757712191; cv=none; b=N5kciFzirNmvcFylf4b5ZNC5h54z3wsTYRvP+IgTvUA2iY87LBVjfVE+6kmHDIxu0+trG8iZHeuFo3DOow0Pu7z1d8yBDS5ActH2HW2NQfl5LhJniahMAiyKE7ZdBmM8sT+KSDLdi19Z3zqiqfP+ksrOe8bpkyxI5VeDtq4G8+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757712191; c=relaxed/simple;
	bh=iJEa9Q3ELYbc31RZKl773wTH7GwP/VosxGzJse6p2IU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RgkpB8ZyS6nzoakSlZY2qu7wIMIC9R8Xno/8jDr0n07WQwKlll3DuKmLCj+XhMQkHpU+Yr4EoxsC/crtSG12NOsb/HSW/20R+FWmbvfMRxSTkilv5VfwSaitwmivz6LpWG0DIkGgrO1c6zA2L7+lvDphg4EcGKJjV9eVLvFS0Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hRZ+ZWKQ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hRZ+ZWKQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0cDUBemIjtQRmcp8EWPjh+NoTzh6rOxunRJSOu0sTRE=;
	b=hRZ+ZWKQBNeIu6zlwi9dYZSQ+CCtpZoNEG8L1a9m7acAhIXTKvsWcXDPpekeIzTV0xKGqL
	uz98lJshsHVC8bjSZqgYeL6xtix2ooZ68oDS8AkGoXkEBJRb6O1s+ciGCzVbR4wqUNMGDy
	kJEFA3+vQyFUHMiEXHWbNPIhAV7WYts=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 00/11] KVM: arm64: nv: Align feature limitations with current state of support
Date: Fri, 12 Sep 2025 14:22:47 -0700
Message-Id: <20250912212258.407350-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There's a mix of features we currently hide for NV VMs that we actually
can already support, either because they have no impact on our NV
implementation or the feature was already implemented and someone forgot
to update the mask...

On top of that, I decided to invert our masking for several registers to
have denylist behavior. This is a better way to express things, IMO, as
the features we do not support are explicitly listed. In so doing, I
found a bug relating to FEAT_DoubleLock where we accidentally claim
support where we shouldn't as the 0 value implies the feature is
implemented.

I've made each relaxation into its own patch to capture the rationale in
the changelog but I'm also fine squashing these based on the affected
register. Features that limit our MMU implementation are deliberately
left masked, e.g. FEAT_ETS* and FEAT_nTLBPA place constraints on the
behavior of our nested MMU. Although the latter is highly unlikely to
matter.

Applies to 6.17-rc4. **NOTE** this depends on Jinqian's series to make
ID_AA64MMFR1_EL1.TWED writable [*], that should be applied before this
series.

[*]: https://lore.kernel.org/kvmarm/20250911114621.3724469-1-yangjinqian1@huawei.com/

Oliver Upton (11):
  KVM: arm64: nv: Convert masks to denylists in limit_nv_id_reg()
  KVM: arm64: nv: Don't erroneously claim FEAT_DoubleLock for NV VMs
  KVM: arm64: nv: Expose FEAT_DF2 to NV-enabled VMs
  KVM: arm64: nv: Expose FEAT_RASv1p1 via RAS_frac
  KVM: arm64: nv: Expose FEAT_ECBHB to NV-enabled VMs
  KVM: arm64: nv: Expose FEAT_AFP to NV-enabled VMs
  KVM: arm64: nv: Exclude guest's TWED configuration when TWE isn't set
  KVM: arm64: nv: Expose FEAT_TWED to NV-enabled VMs
  KVM: arm64: nv: Advertise FEAT_SpecSEI to NV-enabled VMs
  KVM: arm64: nv: Advertise FEAT_TIDCP1 to NV-enabled VMs
  KVM: arm64: nv: Expose up to FEAT_Debugv8p8 to NV-enabled VMs

 arch/arm64/kvm/hyp/vhe/switch.c |  7 +++++
 arch/arm64/kvm/nested.c         | 48 +++++++++++++++++++++------------
 arch/arm64/kvm/sys_regs.c       | 25 +++++++++++++++++
 3 files changed, 63 insertions(+), 17 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.39.5

