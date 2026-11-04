Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820087;
	b=APk7cTJEmO3kiY6STv9xE+b7x7NaB8R5yShGff0PCcXe8S0978hHv+zTEFDimxMJhREZ
	 xDxzDfZYiYuBAxs4dZlNfT/0xYaOLSYv1hO/yEleTQ19Rz0X+dQjBgvh+SVQdGUDZ0T8g
	 lGdxPyYkrPlpCCiDL74MlZVikF1QKbL/nRCHfUl7sjwRAF4JCXV8mGVyycqa5xIPy83fS
	 gXt+g8DX43GQ7ttqscQpZFpVNw44GFRzAOuybi1dSvdqmyB5/YEjEE/N5PvByBMQ+AqFa
	 Fa0jQu9cNZ3LAGC1Gb496zn1o/jvzpngAZdDQ97MVBn4RM/GqLStH1HyLYVyaEjj/sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WzrbKpK1OeL+7cK1V+1sSfr+2OheHfdnzSx93iKvSOQ=;
	b=iACY6hj7sGiT/gxzvBSCaq+I6JhaUyjlKiLdwkosdL6QKENtg0Paw5uSmpYqvyeYpQpU
	 BGyQUjsLbICKsJFPn7+BiR0gVJmg4IIlVXQfP7Wz/zzrbALD8MYYq9QPTVxYLxFQm4qbU
	 g7MNot+3QIlAhjTVFFm0RCg8/x38Iwt9nlV+UIxaIJE1NCOM9JNroGblU25FfI6AJI3Ei
	 VffX+N413HcvhW6qFeIKRhrlZgoexn3uQIUVEAai4u0pDwwby6ebO045/5CmvJ+sZ+QSh
	 wK+gImXGom5cD8KlvpPG+kYsRpjwxRm2vhw2xRFFK/H4IrqMOrBEOWYg/eJpAt6S9oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Hl92d/Nd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F2A606AB2A
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl92d/Nd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782681F00A17;
	Wed,  4 Nov 2026 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820086;
	bh=WzrbKpK1OeL+7cK1V+1sSfr+2OheHfdnzSx93iKvSOQ=;
	h=From:To:Cc:Subject:Date;
	b=Hl92d/Nd3eLnKBTNzJpqtIqGLBMdvCfoC599bHLlmGd81cVncYiZOfh/2306VWrs+
	 pXz140CwzxS7yvD2DmcjoQIxVUWLBmjXeIMoSLyrJ7BlihqYkCIz7o9vz6IWwueR2L
	 aKXZssBqWFY/mgfQxamoAvHNYGncFVG1fbVHoNv0DUduts5jTdY8ge99M+OUDNOK/R
	 NQh1kmGK34c2k5IJ0HjOSpUp1gBAqJQN53sEvSsa4IEfGMImlE9JFLaKfGgKDSYWsT
	 UreOPo1MOwwJBtIt2kKktsN/WCpoFxlhP93qmpjS9jiBVna4qafov3z6QKwt6Yh/yV
	 ROkTOpXIYxLZg==
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
Subject: [PATCH 0/8] KVM: arm64: Prefix of fixes from HAFDBS series (for 7.4)
Date: Wed,  4 Nov 2026 11:21:16 -0800
Message-ID: <20261104192124.3932743-1-oupton@kernel.org>
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

I kept on running into bugs as part of the HAFDBS series, especially in
dealing with emulated cache maintenance instructions. Everything seems
worthwhile for 7.4 so I've gone ahead and spun it off into a separate
series.

The bulk of the changes are addressing a subtle gap in KVM's handling of
coarse-grained traps. There could be instructions supported by the
hardware but unsupported for the VM which intersect with a CGT. When the
sysreg lacks an FGU description this has the effect of reinjecting
architecturally-invalid sysreg traps to the L1 hypervisor for the
visible feature set.

Besides that, abort injection has gotten a bit hairy, details found in
the last patch.

Tested on M2 and QEMU-TCG since the M2 lacks a lot of the necessary arch
features.

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

 arch/arm64/kvm/arm.c             |  10 ++-
 arch/arm64/kvm/emulate-nested.c  |  26 +++++-
 arch/arm64/kvm/inject_fault.c    | 133 ++++++++++++++++++-------------
 arch/arm64/kvm/sys_regs.c        |  84 +++++++++++--------
 arch/arm64/kvm/sys_regs.h        |  27 +++++--
 arch/arm64/kvm/vgic-sys-reg-v3.c |   2 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c |   2 +-
 7 files changed, 177 insertions(+), 107 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

