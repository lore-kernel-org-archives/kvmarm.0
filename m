Received: from out-49.mta1.migadu.com (out-49.mta1.migadu.com [95.215.58.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121FB2564
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 08:24:38 +0000 (UTC)
Date: Wed, 19 Apr 2023 01:24:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681892676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sEfqdMKlz2TKozXoLBDqAjWKdEh1bbbikAcQxojWcX8=;
	b=FilzkAJlzgCq3WzPDDVH05yefq9ntT9xMLu1n4lTIeNDDg3xWTRFJDwp9Rd2i3i1qe8BYg
	WygHZF713Ce8DoQPRcp1p8x6E6a9pvHPmqhfe6Zd8vRQ7ilvEhNZSJd1fUuYgE4foOe1ID
	cdjK2RRM2Ref3t0X0XXMtEnZuHfFZk4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] KVM/arm64 fixes for 6.3, part #4
Message-ID: <ZD+lOl+5tNywC5Vu@thinky-boi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Paolo,

I tempted fate with my prior pull stating that it was likely the last.
So here we are. A single, critical fix to protect vCPU flags updates
(which are non-atomic) against preemption, as that'd muck with the vCPU
flags.

If you're busy this week and unable to button this up in a pull to
Linus then please let me know, as we really want this to get in before
6.3 is wrapped up.

Please pull,

Oliver

The following changes since commit e81625218bf7986ba1351a98c43d346b15601d26:

  KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs (2023-04-04 15:52:06 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-4

for you to fetch changes up to 35dcb3ac663a16510afc27ba2725d70c15e012a5:

  KVM: arm64: Make vcpu flag updates non-preemptible (2023-04-18 17:08:09 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.3, part #4

 - Protect non-atomic RMW operations on vCPU flags against preemption,
   as an update to the flags by an intervening preemption could be lost.

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Make vcpu flag updates non-preemptible

 arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)
