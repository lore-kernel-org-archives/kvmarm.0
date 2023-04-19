Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2848123A2
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 15:54:08 +0000 (UTC)
Date: Wed, 19 Apr 2023 08:54:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681919646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fp8r9NiXX/VMrp288APhXd9/oxP1xKnWdF8hI7MtG2c=;
	b=TzrX8Pn2xmTtMiXyk1Fz/Ob1MiwfQfOGQbmyTqUIIjHP/3b+nJQ96gAYGFhqqe4TeU+Svi
	FDRbRcs870T5F7IJf2KAD5AD/eTaVJ//9FrIGoiYmlQRVNLF+e94TDBIvRAJmFUym4oXnX
	BNYxz3aHulHIMI0pxhYYA8Bh4aBZAAE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [GIT PULL v2] KVM/arm64 fixes for 6.3, part #4
Message-ID: <ZEAOmK52rgcZeDXg@thinky-boi>
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

Here is v2 of the last batch of fixes for 6.3 (for real this time!)

Details in the tag, but the noteworthy addition is Dan's fix for a
rather obvious buffer overflow when writing to a firmware register.

Please pull,

Oliver

The following changes since commit e81625218bf7986ba1351a98c43d346b15601d26:

  KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs (2023-04-04 15:52:06 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-4

for you to fetch changes up to a25bc8486f9c01c1af6b6c5657234b2eee2c39d6:

  KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg() (2023-04-19 15:22:37 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.3, part #4

 - Plug a buffer overflow due to the use of the user-provided register
   width for firmware regs. Outright reject accesses where the
   user register width does not match the kernel representation.

 - Protect non-atomic RMW operations on vCPU flags against preemption,
   as an update to the flags by an intervening preemption could be lost.

----------------------------------------------------------------
Dan Carpenter (1):
      KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()

Marc Zyngier (1):
      KVM: arm64: Make vcpu flag updates non-preemptible

 arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hypercalls.c       |  2 ++
 2 files changed, 20 insertions(+), 1 deletion(-)
