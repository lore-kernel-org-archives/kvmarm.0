Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313456;
	b=R/L2sppQuIVXqA1qKXVo6Xh34ZzBoygv84e92+T46TkxfqE3ywyBAc/8p51gD5BGQbn8
	 MZShKBSV7OC1/2Mz6lQnLL9/KPafzniK6C8q4Uqbdg8OObKGc/ZwH3GKkpWhAml9D6Wmz
	 C6Jhj/mWHAKoxzxsvswUu7weYK6LYYpgxVc998mMnEryzelD6BpO95hUZu4fD0Pvh/Alf
	 6A22LnruGufsLtrwCB67Qh39zIEzjHk6msv089YGf5MSP/sWRTRiJSVtT54UXVaiz48V0
	 CVF3ju/E21KX1jcjyaxM6V8hRqxfneZPY8UEtsp9OB+YiM0VbiV0ne6lYaQ3/2f63YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKrWZCN7bhp2Kvdl8I4kjDYiCBb+949tmswQO8VAvTA=;
	b=tibZQ0ERJ01qGYBnU9v5xzOCxfF1EZBCVToXut9AN7V8y6wYQSOFYg9qk5HG5j6TNfRd
	 btj9qzTyG68KvX8SqfS3t42blXhng5/2a9NQYgjynCF0ySzDyqcrL5FLJHp4c1fL3WSBS
	 jNcrPp/CPnvHUF+Y9PcVpnvRHsgEp9MJqiIw710fqupNxRPRiMfbXfqpaL3ToD64UXnbK
	 eeeLhYxBSjpTweAuW4mpS2yI+kgzjS/MoQ1Dixo3+WiFveP3YR0f05IbQzpMJWqq4FLgE
	 ur95M1GIje161lZtXBcpuTVTceN7xSYEWxf9nvQBHLlKE7MxLSE4dNCT3RH/FFuizpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXmsSlpj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEE5606A32D
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXmsSlpj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFE81F031EA;
	Thu, 29 Oct 2026 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793313455;
	bh=mKrWZCN7bhp2Kvdl8I4kjDYiCBb+949tmswQO8VAvTA=;
	h=From:To:Cc:Subject:Date;
	b=nXmsSlpjH7E+65z9L7TqoP/9cU8rX0dkYF9YC5KnTz/qOvjECeM0AYRPpj1dKRzib
	 iCPbBeb1igfDNqS7Ic3UKL2aWRAkjp9oCiUAsznc6K3i7H2PBWvVg2QfYMwKcvMS5g
	 y1odxhP+PHrNqPch89zIAazAjCKGWBICyI97IsaH1xlzXIv5SQUdC/hfD3+7jUX1M+
	 LT4N+geN62RvwfiDloPc4+a6s/bW3zfV3UHIsGUcdIr7MMM1fj2SshuMGTySlYEChs
	 v/t6jYcwxLMFe/S/o0xPdULIYCrB9/+Q5fBDj91hjNIcVFt0p/eXc+a0wpV9xo3vYw
	 bQ7KWPe9uFJnw==
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
Subject: [PATCH v3 0/5] KVM: arm64: TCR_EL2 fixes, FEAT_LPA2=NI for NV
Date: Thu, 29 Oct 2026 15:37:27 -0700
Message-ID: <20261029223732.103785-1-oupton@kernel.org>
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

I went ahead and grabbed Wei-Lin's series [1] that added TCR_EL2
sanitisation since it makes life quite a bit easier for computing an
effective TCR_EL1.

Tested on Neoverse-V2 running a guest with FEAT_E2H0.

v2 -> v3:
 - Collect R-b's from Joey
 - Add patch "KVM: arm64: nv: Correctly compute the effective TCR_EL1
   for nVHE TCR_EL2", itself picking up fixes for forwarding missing
   fields into the effective TCR_EL1 value (Fuad)

[*]: https://lore.kernel.org/all/20260917214215.74135-1-weilin.chang@arm.com/

Marc Zyngier (1):
  KVM: arm64: Reset TCR_EL2 according to guest's E2H mode

Oliver Upton (1):
  KVM: arm64: nv: Correctly compute the effective TCR_EL1 for nVHE
    TCR_EL2

Wei-Lin Chang (3):
  KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
  arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
  KVM: arm64: Convert TCR_EL2 to config-driven sanitisation

 arch/arm64/include/asm/kvm_arm.h    |  13 ---
 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/arm64/include/asm/kvm_nested.h |  38 +++++++--
 arch/arm64/include/asm/sysreg.h     |   1 -
 arch/arm64/kvm/config.c             | 112 +++++++++++++++++++++++++
 arch/arm64/kvm/nested.c             |  15 ++++
 arch/arm64/kvm/sys_regs.c           |  10 ++-
 arch/arm64/tools/sysreg             | 125 ++++++++++++++++++++++++++++
 8 files changed, 291 insertions(+), 25 deletions(-)


base-commit: 9e9283e4c941e806d2735f09b66763487bc48b50
-- 
2.47.3

