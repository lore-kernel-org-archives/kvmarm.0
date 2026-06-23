Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C02388869
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 14:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224734; cv=none; b=tCOq86CXbaZvn8Ws+vxex4tWLVh5l214+7Ni4bxOXbxRQtCzPuxXMdOn3T8sdWJsNnoqx+2eZ3ySzL8nvb8oLPC4/70sLbGJukYzDCD+zc7Rec+SA4G8MgBjXpKQJhm4SXztlTwoCDOORk59JcEoMcTXoSBZawtICDJgwDrvXSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224734; c=relaxed/simple;
	bh=LBWa5Jp4DhEhEVDG8ihtH0XxusDpbA3AA6OlXqWyKho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gT+vZpfQBEj/0731qqvhXEpqzNQqeeqjsDvlDY261MoQiCTIkf6ua6VK/Xx7m8KQ7UIoImxm5Cd8nGUnqIKBDXSoHq8tFIOdLp6wYzSDAtm2kSVv+HzrVPx8TmDRVsEu3JswHOWAiZLx+ZMVPW7/++mKk355czpLFLlNBnvVJQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SJmQEgLH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SJmQEgLH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3618F1A25;
	Tue, 23 Jun 2026 07:25:24 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA1DC3F632;
	Tue, 23 Jun 2026 07:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782224728; bh=LBWa5Jp4DhEhEVDG8ihtH0XxusDpbA3AA6OlXqWyKho=;
	h=From:To:Cc:Subject:Date:From;
	b=SJmQEgLH5U9RQdbJYCkovfhbzDasHaRE9FsbntJMNcwgvQCky5e7VUgq1d+hPK2HZ
	 3NcVyZNGijG/IQEMwZeUwdEYyuh4fzVraPbgTZDvYI7w3G+4YsijwVpDbVgYOEfn3T
	 w5QAYDNzAIp/QSFqwjk8GogU3EXv+bjMc2wBKDFE=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/3] KVM: arm64: nv: Shadow ptdump fixes
Date: Tue, 23 Jun 2026 15:24:40 +0100
Message-ID: <20260623142443.648972-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes two bugs regarding the shadow ptdump debugfs files.
It is based on kvmarm/fixes + [1] ("KVM: arm64: Reassign nested_mmus
array behind mmu_lock").

The first is a UAF. A nested mmu can still be accessed when the debugfs
file is being closed, after the nested mmus are freed. I can observe
this by turning on CONFIG_KASAN and closing the file after the VM is
destroyed. To fix this, mmu access is avoided in the .release()
callback.

The second is sleeping in atomic context, found by Itaru [2] (thanks).
Originally the code creates a debugfs file whenever a context gets bound
to an s2 mmu instance, and deletes it when it gets unbound. Problem is
the bind/unbind is done with the mmu_lock held, and debugfs file
creation and deletion can sleep. This is observable by using
CONFIG_DEBUG_ATOMIC_SLEEP. The new approach is just have one debugfs
file for each s2 mmu instance, and show their state + information when
requested, which can be invalid, or VTCR + VTTBR + whether s2 enabled +
ptdump.

The fixes are tested with CONFIG_PROVE_LOCKING,
CONFIG_DEBUG_ATOMIC_SLEEP, and CONFIG_KASAN.

Thanks!
Wei-Lin Chang

[1]: https://lore.kernel.org/kvmarm/aiKIVVeIr1aAB1yp@v4bel/
[2]: https://lore.kernel.org/kvmarm/aiuF0KSvvv-ZozI1@sm-arm-grace07/

Wei-Lin Chang (3):
  KVM: arm64: nv: Print nested mmu info in kvm_ptdump_guest_show()
  KVM: arm64: ptdump: Store both mmu and kvm pointers in
    kvm_ptdump_guest_state
  KVM: arm64: nv: Move to per nested mmu ptdump files

 arch/arm64/kvm/nested.c | 16 +++++++++++-----
 arch/arm64/kvm/ptdump.c | 29 +++++++++++++++++++----------
 2 files changed, 30 insertions(+), 15 deletions(-)

-- 
2.43.0

