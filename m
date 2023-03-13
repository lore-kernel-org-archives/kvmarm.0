Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD22123B4
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 09:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700F8C433EF;
	Mon, 13 Mar 2023 09:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678698890;
	bh=Y0XLnrqcdiNHMLsFp+Z7PoEjpZ9/TLl3jHTZFQx/TeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=dImEaMhdnkFCElHYxdgTRzpHGc5sv3oktR3lcRF7Gd+lnzAR0/05//STbIteu2YnW
	 jnaRUopN+/NImNrVI9K9X0PDCsQuZ4xVnLtrv8o7GMaM5vV8cBS2dwwt6jNGnMEqa5
	 In1D4GgVR2UATTQqSM0dTuM4NfqsuCnJ2SLSoXC+CHq7i3JfT/pgsD7YLXuxZNCkhY
	 84cdqft7RNP2J3nPK95eDdYjkp5W36wCX93rALJ5U+uEN1j9rSHhpIQVm1uOrSDUv1
	 c7ca2xoVyv+nj9ABchE98hlNsGwWoy8AkfT+YQSkJNBG91FF4BSf3kqVinre96VBDP
	 N+D5VFIgE/YEQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pbeGW-00HAzq-2m;
	Mon, 13 Mar 2023 09:14:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 0/2] KVM: arm64: Plug a couple of MM races
Date: Mon, 13 Mar 2023 09:14:23 +0000
Message-Id: <20230313091425.1962708-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ardb@kernel.org, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Ard recently reported a really odd warning generated with KASAN, where
the page table walker we use to inspect the userspace page tables was
going into the weeds and accessing something that was looking totally
unrelated (and previously freed).

Will and I spent quite some time looking into it, and while we were
not able to reproduce the issue, we were able to spot at least a
couple of issues that could partially explain the issue.

The first course of action is to disable interrupts while walking the
userspace PTs. This prevents exit_mmap() from tearing down these PTs
by blocking the IPI. We also fail gracefully if the IPI won the race
and killed the page tables before we started the walk.

The second issue is to not use a VMA pointer that was obtained with
the mmap_read_lock held after that lock has been released. There is no
guarantee that it is still valid.

I've earmarked both for stable, though I expect backporting this to
older revisions of the kernel could be... interesting.

	M.

Marc Zyngier (2):
  KVM: arm64: Disable interrupts while walking userspace PTs
  KVM: arm64: Check for kvm_vma_mte_allowed in the critical section

 arch/arm64/kvm/mmu.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

-- 
2.34.1

