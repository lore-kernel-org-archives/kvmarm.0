Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6B743DA38
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 23:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599897; cv=none; b=rsBw00JQxwDkuQxrFq25fORW8WGQ0/kNNUT0kliYR5C0aZqT4uzh1/xvSqT7xB/oMOtThx1ZOjRDaJ8btgR6sMsgbWwbPe1MYRoJhPEPdOGZlED290E1rVi01PMrt7K6CUewQoshetmC9GDyx81M39LSBi9fUuVUaWngEWWEpnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599897; c=relaxed/simple;
	bh=wkNpSDNZfRTYlKzv+KDudj0npKw1I5FMQNwmEMqYQ0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pMqVFx9N8AzItQRI5IKLo1FeSkhf9WDB6qVroJH8cOtAxrkI7xGYGfUYnjRH4EJCp/FXy52sXP9C3me/edvq1cDYQYSe0JzIVPV+wtVYzIlJJf3V9lGmEebTHRp22r8W3QHfFiG2A1GcPietIHuRKxvLhJM2bSDYOu0DhxzW96I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKTwVo/A; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKTwVo/A"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 654061476;
	Wed, 16 Sep 2026 16:04:51 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02F613F7B4;
	Wed, 16 Sep 2026 16:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789599895; bh=wkNpSDNZfRTYlKzv+KDudj0npKw1I5FMQNwmEMqYQ0k=;
	h=From:To:Cc:Subject:Date:From;
	b=OKTwVo/AQtdupYUE7FDpC+F6hT5YJ8C57ltsT+Id1mdnhxzjsPryo26VDsUaJeZ/8
	 tnZokvPCEo8M4rz3l1d0MnAe+p1lRLygmQvfQ1KNs6pWQdalxTzGGt18yIS/0UWIqU
	 bhIEYllbYnrKDdwak8rnkifXwsENxkBdO6ElIi0g=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 0/2] KVM: arm64: ptdump: Shadow ptdump fixes
Date: Thu, 17 Sep 2026 00:03:35 +0100
Message-ID: <20260916230337.4162485-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is v3 of fixing the sleep-in-atomic problem of the shadow ptdump.
The approach taken this time is simply creating a file for each nested
mmu.

The ptdump files are created alongside the nested mmus in
kvm_vcpu_init_nested(), in a sleepable context, and removed when the VM
is destroyed (kvm_destroy_vm_debugfs(), before the nested mmus are freed
in kvm_destroy_nested()). This allows us to store the kvm_s2_mmu pointers
in the ptdump code, after Marc's nested mmu lifecycle fixes [1].

For the shadow ptdump, for valid nested mmus the first line will show
the nested context's VTTBR and VTCR values, and whether s2 is enabled or
not. The ptdump then follows.

The first patch fixes mmu->pgt accesses after the VM MMU teardown in
ptdump.c, the second patch switches from per nested context ptdumps to
per nested mmu ptdumps.

Tested with CONFIG_PROVE_LOCKING, CONFIG_DEBUG_ATOMIC_SLEEP, and
CONFIG_KASAN.

Series based on kvmarm/fixes.

* Changes from v2 [2]:

  - Changed from creating a file that contains all nested mmus to
    creating one file for each nested mmu.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260911162203.1919330-1-maz@kernel.org/
[2]: https://lore.kernel.org/kvmarm/20260630121005.1130996-1-weilin.chang@arm.com/

Wei-Lin Chang (2):
  KVM: arm64: ptdump: Check the page tables aren't freed when accessing
  KVM: arm64: ptdump: Fix shadow ptdump sleep-in-atomic-context problem

 arch/arm64/include/asm/kvm_host.h |  4 --
 arch/arm64/include/asm/kvm_mmu.h  |  6 +--
 arch/arm64/kvm/nested.c           |  9 ++--
 arch/arm64/kvm/ptdump.c           | 75 ++++++++++++++++++++-----------
 4 files changed, 54 insertions(+), 40 deletions(-)

-- 
2.43.0

