Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B0947AF68
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164157; cv=none; b=q7CGpSUUd0K5Zgeh+H9w3j3gxm5PnggkWy2C5htOoS/t89Yye+4ut//bE9BO/C49k3U92rqTbJU5/t6/WraZXPcqEejXV+LcFoeY/7HALaGjctZbLGny0hsCMHWQK4qq80yQaw43D2IzmKyNfGDHQJ0Z/GGL0RCmYVn865YxBHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164157; c=relaxed/simple;
	bh=P3h37LSCKhNtaAxQFwfpGwdq46uqp29wJsMeVnpY23w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bt2U2JpbLK+w7wBGMoDaK7dvsTx22lCGCYSzHi/W8GMcpdq811RXMIoVLYSsbnWK4/xY/bmlBoTAimEdHgH8WT6L7sIs4rmossa7s+WOqkeQApD4dKyG66npFh/ajuKP6hS72sX5TqOMpqo8Cj45PkH9AlpxxxvUbi4EUG1zLxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aSPQW6kE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aSPQW6kE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50CE1143D;
	Fri, 16 Oct 2026 08:22:30 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04EBE3F673;
	Fri, 16 Oct 2026 08:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792164153; bh=P3h37LSCKhNtaAxQFwfpGwdq46uqp29wJsMeVnpY23w=;
	h=From:To:Cc:Subject:Date:From;
	b=aSPQW6kEfeilzSWSstaYmBG3/uJS/q2st++JXuLqeHge+9GTdBgEyDWsg148ZdIpW
	 c/NwtOYOz+5vnuIAzD5iM2urVymgvLIJPQRZYmCAplJYysHtVJgwV3zqbGq1M2/NS1
	 76V4ItYZ8SOmE9QR+g3Qm/Jh/Vwiu5byvtLbJspQ=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: [PATCH 0/2] KVM: arm64: Reject mismatched GICv3 ITS/VGIC models
Date: Fri, 16 Oct 2026 16:22:22 +0100
Message-Id: <20261016152225.898761-1-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a GICv5 host with legacy GICv3 support, KVM exposes both VGIC
models to userspace. A VM can create a GICv3 ITS alongside a GICv5
VGIC, because neither creation path checks the model of the other
device. The ITS sets has_its, but a GICv5 VM cannot use a GICv3 ITS
for MSI translation. Creating the ITS before the VGIC also lets
userspace select an incompatible VGIC model later.

Record the VGIC model required by a GICv3 ITS and reject incompatible
device creation in either order. The second patch tests both orderings,
skipping the test if the host does not offer a GICv3 ITS.

This series is based on kvmarm/next-7.4+fixes-7.3-2.

Sascha

Sascha Bischoff (2):
  KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS
  KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC

 arch/arm64/kvm/vgic/vgic-init.c             |  5 ++++
 arch/arm64/kvm/vgic/vgic-its.c              |  9 ++++++
 include/kvm/arm_vgic.h                      |  2 ++
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 32 +++++++++++++++++++++
 4 files changed, 48 insertions(+)


base-commit: 678f16b6e4767096aa3e3e6eef60e981b3f61e12
-- 
2.34.1

