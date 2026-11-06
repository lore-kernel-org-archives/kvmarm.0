Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989921;
	b=tD7cXptQHy1EaHK+tNaPgXJDHz8xApFnrEhcD3OLdeA792a7lI2dyeAoTJxDNdjbjotV
	 WwY1aYDTAuWjPkK0CoG7onbaxhe5i2pQeVxDtg5gAuA8wWyp0W2sxzOBcdsfnXDtFNEkJ
	 7RAkWl73WNmKZOt4CwfkaFDCXkSr2OwMOIye7LYYJB9+EinX/TQnNLJ1ZzcS612oOj+UH
	 OrMx9x8EkoJfpFcRryxSstHCm5pEm0FvoV/vjV7lDcXRnU6CmlP8KmX/tkWHKpQi7cwf9
	 vGmNjZ3ubmAY6N1Kt2zpAol4ioNt0a30X1XSTdnE8c3+cjWqOoY0Ep+u/nNHmrLOrsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EzT1XsVW9gldsDj1ffZhA3Y0D2xOHO4mend7oOoMQCc=;
	b=mH+krNwUh9BdS3JhQ/ZDa+147qyENsTAkIDDNrc2sV0/A/BS2t3kbOsjVbpmK+B/+Z5O
	 efHKGB64R1Y2QqaZMMkoVmwIFMsOdD348rPAk7L1fu7fnmbvQcK3lC980E72uJ+AtLPps
	 Gz5VoRnstXRzjiRZpuGcqls5phaK1CxeaMAt5XBwrNFfVtLU3R9Y8cZNGqZzTkuz/8naU
	 2tQKCzZU8c+HVe28EUrXLkmOEUHE7TZXnCR2y7v5FykPIYAvlyR8/9tmJZxRXd+02p2Da
	 CTBMvuTIMkw9LFV51vNaQXlt6uyYFfo2ayitOpUKdkFMZErTWypWFmXzCDIbYJuCpqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OYGg8y7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520A606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OYGg8y7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AFD1F0089F;
	Fri,  6 Nov 2026 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989920;
	bh=EzT1XsVW9gldsDj1ffZhA3Y0D2xOHO4mend7oOoMQCc=;
	h=From:To:Cc:Subject:Date;
	b=OYGg8y7tzXsCOIq7kkaT61BWqljSprd8CNs14RpLv4p5S81+NTxuLG+q0eUTNQajo
	 56hx3+N+1pLgcd2T7XvEneirPm9yHy/YuXPYepS0fG1c4mcQ6ie2WJWywZGz/bXB8A
	 2mmBR5Gek/I5K2Xrbc1oS0wwTSHh4/f6YkpGF+BFdoYWL+gR3QWXLHeTCMuRANrLJp
	 JpWmJ5H5q5Fj7ox15Z4aRm5f/J8XPVNxm/hpxM/f5pFuuoY7HNPoB8zLLSOw7ZOJSt
	 Sm1ggPJ6/yrBCqvJO3r8jazIuMg8tmUGdBCCWSB02DG31g+B8SSUcIjUWnKp2XfREa
	 csj8ZW4m1rPaw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 0/8] KVM: arm64: Prefix of fixes from HAFDBS series (for 7.4)
Date: Fri,  6 Nov 2026 10:31:46 -0800
Message-ID: <20261106183154.3590825-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1: https://lore.kernel.org/kvmarm/20261104192124.3932743-1-oupton@kernel.org/

v1 -> v2:
 - Hide KVM_CAP_ARM_EL2 when provided a VM with MTE enabled (Sashiko)
 - Document MTE and EL2 as mutually exclusive
 - Pick up Leo's R-b (thanks!)

Oliver Upton (8):
  KVM: arm64: nv: Disallow KVM_CAP_ARM_MTE + FEAT_EL2
  KVM: arm64: nv: Add CGT description for FEAT_PoPS instructions
  KVM: arm64: Separate user / guest visibility flags
  KVM: arm64: nv: Treat the VNCR GICv3 registers as hidden from user
  KVM: arm64: Use ->visibility() to filter MTE CMO instructions
  KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions
  KVM: arm64: nv: Enforce sysreg visibility before evaulating guest
    traps
  KVM: arm64: Stop leaning on __kvm_inject_sea() for abort injection

 Documentation/virt/kvm/api.rst   |   1 +
 arch/arm64/kvm/arm.c             |  16 ++--
 arch/arm64/kvm/emulate-nested.c  |  26 +++++-
 arch/arm64/kvm/inject_fault.c    | 133 ++++++++++++++++++-------------
 arch/arm64/kvm/sys_regs.c        |  84 +++++++++++--------
 arch/arm64/kvm/sys_regs.h        |  27 +++++--
 arch/arm64/kvm/vgic-sys-reg-v3.c |   2 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c |   2 +-
 8 files changed, 183 insertions(+), 108 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

