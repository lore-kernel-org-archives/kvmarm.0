Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC0241FE
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 21:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7yuVPYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7C2C433C8;
	Fri, 13 Oct 2023 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697232662;
	bh=0Gum7gjOtfuDZit2/WIKU/1n82O1xs+XX0sCV0VvldI=;
	h=From:To:Cc:Subject:Date:From;
	b=J7yuVPYJzCR6NbD8abpueCRFe/CveVHC96cU21dUsnCAeQwShRM5AkO8xf/Sq4SWL
	 iDqRrdC0eto15WWFm924IklXgogVUqoOEkkKMqiNQhEFE8f96cYhkKEcriVvVas+Tm
	 5fUAOGsyHkH/vxJFK3qFz/VDGifHUw1F6pGvWVKTHEr+fNrakEtFtUFOsZavB6ZHtD
	 E/IN7DvDVKknRV3EW3jgGZuULcbjopABOSHImWjNI0tV6i1KWIOeOATZ60xqgq3/4T
	 NkZ3JPAAMZFeDvqtKoN9dhmHbXxTsSfWepENek3nk/xEf1tg55N2N8onFCVo6L2zc0
	 YfDmNdnX/0fqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qrPkJ-00403e-Oa;
	Fri, 13 Oct 2023 22:30:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.6, take #2
Date: Fri, 13 Oct 2023 22:30:53 +0100
Message-Id: <20231013213053.3947696-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, anshuman.khandual@arm.com, gankulkarni@os.amperecomputing.com, james.morse@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

 Paolo,

Here's a set of additional fixes for 6.6. The most important part is
the fix for a breakage of the Permission Indirection feature, which is
a regression. The other (less important) part is a fix for the physical
timer offset.

Please pull,

        M.

The following changes since commit 373beef00f7d781a000b12c31fb17a5a9c25969c:

  KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID (2023-09-12 13:07:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.6-2

for you to fetch changes up to 9404673293b065cbb16b8915530147cac7e80b4d:

  KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2 (2023-10-12 16:55:21 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.6, take #2

- Fix the handling of the phycal timer offset when FEAT_ECV
  and CNTPOFF_EL2 are implemented.

- Restore the functionnality of Permission Indirection that
  was broken by the Fine Grained Trapping rework

- Cleanup some PMU event sharing code

----------------------------------------------------------------
Anshuman Khandual (1):
      KVM: arm64: pmu: Drop redundant check for non-NULL kvm_pmu_events

Joey Gouly (2):
      KVM: arm64: Add nPIR{E0}_EL1 to HFG traps
      KVM: arm64: POR{E0}_EL1 do not need trap handlers

Marc Zyngier (1):
      KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2

 arch/arm64/include/asm/kvm_arm.h |  4 ++--
 arch/arm64/kvm/arch_timer.c      | 13 +++---------
 arch/arm64/kvm/emulate-nested.c  |  2 ++
 arch/arm64/kvm/hyp/vhe/switch.c  | 44 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c             |  4 ++--
 arch/arm64/kvm/sys_regs.c        |  4 ++--
 include/kvm/arm_arch_timer.h     |  7 +++++++
 7 files changed, 62 insertions(+), 16 deletions(-)
