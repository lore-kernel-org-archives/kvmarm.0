Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFB27B
	for <kvmarm@lists.linux.dev>; Sat, 11 Mar 2023 21:41:17 +0000 (UTC)
Date: Sat, 11 Mar 2023 13:41:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678570875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=OIfr38RQbr2XXVcmEhQx3zmzDnnSyVR94dBmvVhONCc=;
	b=IFX7soddA5zpXP8JmmrAoXVD3b+xKHeGFDkDD1KN32IDgVOF4LS54rCLqB9jFaVaTTgJ5K
	MaAyiPc80JdWLup/UL3P70fZd94rAk2vTXLaZIoEu5MecqYooAO6lf9r7I81VYQBfVRZaY
	xCSwv4P48PTogn9UHZVaqtHE1HLrrC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: pbonzini@redhat.com
Cc: maz@kernel.org, reijiw@google.com, joey.gouly@arm.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.3, part #1
Message-ID: <ZAz1duOOOTu+5LW5@thinky-boi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT


Hi Paolo,

First shot at sending a pull request to you, please let me know if anything
is screwed up :)

A single, important fix for guest timers addressing a bug from the nested
virtualization prefix that went in 6.3. 

Please pull,

--
Oliver

The following changes since commit fe15c26ee26efa11741a7b632e9f23b01aca4cc6:

  Linux 6.3-rc1 (2023-03-05 14:52:03 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-1

for you to fetch changes up to 47053904e18282af4525a02e3e0f519f014fc7f9:

  KVM: arm64: timers: Convert per-vcpu virtual offset to a global value (2023-03-11 02:00:40 -0800)

----------------------------------------------------------------
KVM/arm64 fixes for 6.3, part #1

A single patch to address a rather annoying bug w.r.t. guest timer
offsetting. Effectively the synchronization of timer offsets between
vCPUs was broken, leading to inconsistent timer reads within the VM.

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: timers: Convert per-vcpu virtual offset to a global value

 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arch_timer.c       | 45 +++++++++------------------------------
 arch/arm64/kvm/hypercalls.c       |  2 +-
 include/kvm/arm_arch_timer.h      | 15 +++++++++++++
 4 files changed, 29 insertions(+), 36 deletions(-)
