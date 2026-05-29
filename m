Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C7F255F2D;
	Fri, 29 May 2026 10:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780052051; cv=none; b=aowoguTT3mwzrpS/p6egFAw6uye2HdDX6AwQ8eL/7nYtoRK4wnfpwsfyoJVHmZZwx7UIEa0vqt4eriPQvGkzCYShliXQptlDfuicg5o2xx7DEzl0nS1+FRX289cqmxhfS39olJ9PwNZkK9WIIoUTGkCduS68z0JyC+EGxBKaGYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780052051; c=relaxed/simple;
	bh=17nmjc6CY7b3hu380nH6u+TlTeWp+NMARXHFMPLBdwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NvZnRUr3+fmHO6Z/Kb1cVnzJCstuE6M0+PVNA4QdtOizTqMo/54awpoFlWt7F7HU7jPtAddSkvLD6doMXTnxjC4kNMqhyx/ekl3B57j3HBtQCiaR+9mzq59+ACi3swFqbScWQiBWbi/cL31yXZKukPm+NP4KpEQVP/7RWb15h/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1mQG6jh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1mQG6jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAFD1F00893;
	Fri, 29 May 2026 10:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780052050;
	bh=KIHsSApk6kpDUVJxzRZqO9dpY8FfkxUF/l4px39fU+o=;
	h=From:To:Cc:Subject:Date;
	b=m1mQG6jhOXDhTzI4B8SmFplAzzrbvWY4M9n0NthbuUmH7BaBkkvIn3iMJEsssoavo
	 o5JtyScp/w5Nf+eigpIDFF6aN/0/xb0/17NoLOffJMlakKNnisG6M9Su45Hl6uib/d
	 z8kvST01etrOqrFX54/Ni4E0XtUZWsYKN8Yd4Kx5f/yxYonxlqr6Dmeew0oEOKWUuR
	 JOVlczv9cX3wxZkKzCjNGMz3G6FfPZ5q4ZiyloHN1BA5qUvcVQkapMCUueRaOayYKQ
	 ejlOS/U7og1/hsUYrZUcXSJ8N7Gm9QrgiT0TOeokBRjXFn2iWYf5VG9dUigWXegU9D
	 4MDUT3FO80Q/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSuqu-00000007NGX-1CoU;
	Fri, 29 May 2026 10:54:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Brown <broonie@kernel.org>,
	Qiang Ma <maqianga@uniontech.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.1, take #4
Date: Fri, 29 May 2026 11:54:05 +0100
Message-ID: <20260529105405.1839362-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, broonie@kernel.org, maqianga@uniontech.com, vdonnefort@google.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

This is hopefully the last round of fixes for 7.1 on the KVM/arm64
front.

We have yet another batch of fixes for the newly introduced tracing
code (memory leaks), a fix for a config symbol misspelled in the
source code (therefore being permanently disabled), a fix for an
embarrassing bug in the PMU emulation (write any value as long as it
is zero), and an SVE sanitisation bug in nested virt resulting in a
guest being able to access more than it really should.

I've purposely refrained from adding another lot of fixes for more
benign issues since His Majesty has announced he'd be picky about
that. Fear not, they'll be in the 7.2 pull request.

Please pull,

	M.

The following changes since commit 1702da76e017ae0fbe1a92b07bc332972c293e89:

  KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc (2026-05-20 08:08:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.1-4

for you to fetch changes up to 83726330748981372bde86ed5411d7b306612991:

  KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor (2026-05-29 10:04:00 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.1, take #4

- Restore CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC to its former glory by
  making sure the config symbol is correctly spelled out in the code

- Don't reset the AArch32 view of the PMU counters to zero when the
  guest is writing to them

- Fix an assorted collection of memory leaks in the newly added tracing
  code

- Fix the capping of ZCR_EL2 which could be used in an unsanitised way
  by an L2 guest

----------------------------------------------------------------
Mark Brown (1):
      KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor

Qiang Ma (1):
      KVM: arm64: PMU: Preserve AArch32 counter low bits

Vincent Donnefort (4):
      KVM: arm64: Fix CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC
      KVM: arm64: Fix meta-page unsharing in pKVM hyp tracing
      KVM: arm64: Fix rollback in hyp_trace_buffer_share_hyp()
      KVM: arm64: Fix memory leak in hyp_trace_unload()

 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++++------
 arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
 arch/arm64/kvm/hyp_trace.c              |  9 ++++++---
 arch/arm64/kvm/nested.c                 |  5 +++++
 arch/arm64/kvm/pmu-emul.c               |  4 ++--
 arch/arm64/kvm/sys_regs.c               | 11 +++--------
 7 files changed, 28 insertions(+), 21 deletions(-)
