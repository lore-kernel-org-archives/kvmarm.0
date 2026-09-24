Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A5D38CFFA
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243448; cv=none; b=MglUr8PU5TkLtm57vtGwauAfjctXEaE9SLlEYFaxofX5t7qNGR02EVFQXLAcmDXKjbYCqd4akTw95V9xbofrYJGtg/XJ/q0z7sASInMGytjIf/Cj4qGtVRVXNj4SSUqVhDgoNeTK1Vsk3oVYbgDsm+LdaiG1QompX0s5KWs5STs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243448; c=relaxed/simple;
	bh=mi5Wn3XblNBZBdzwFD0WPka+R8QrTCI4hMJ2QLpSJKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HGL4RDIBH86BvIoI8VvsUSJVWpSFGh9dI7BYclD/gKBrcWyLTG//haSHKxwMjatZAiyrG9gXIZo2As/BDiwrVEr8xU5HzCDRpH/0XMo14pq1ftfxBAcImUmwJIoSkyc+y+E2WqOKgAZWb+3hky7wgaPlwinZyxhcrsTJrZkUS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OrtdVcaA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OrtdVcaA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC9011516;
	Thu, 24 Sep 2026 02:50:26 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDA4B3F86F;
	Thu, 24 Sep 2026 02:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790243430; bh=mi5Wn3XblNBZBdzwFD0WPka+R8QrTCI4hMJ2QLpSJKc=;
	h=From:To:Cc:Subject:Date:From;
	b=OrtdVcaA0ELnCObfDLlNBy3QZD8DKR+WXofPdq4ZtXOxCsx9815P5JHazuM5gerAK
	 GLHDdNOBALmRZd0SmIxEdxxNKzAahbqhsCHopWavBXEwlqZAFQnQbO9Vr0zPVPyCig
	 xbigpkydr2nnNx8nht1izSUp0kbFW/1qpLr8PqxA=
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
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v4 0/2] KVM: arm64: ptdump: Shadow ptdump fixes
Date: Thu, 24 Sep 2026 10:49:49 +0100
Message-ID: <20260924094951.727352-1-weilin.chang@arm.com>
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

This is v4 of fixing the sleep-in-atomic problem of the shadow ptdump.
This version relaxes a few write_lock to read_lock, and collected tags.
Please see the details below.

* Changes from v3 [1]:

  - Take read_lock instead of write_lock when getting pgt metadata.
    (Vincent)

  - Collected Tested-bys and Reviewed-by from Vincent and Itaru.
    (Thanks!)

Below is mostly the same content from the v3 cover letter:

The approach taken now is simply creating a file for each nested mmu.

The ptdump files are created alongside the nested mmus in
kvm_vcpu_init_nested(), in a sleepable context, and removed when the VM
is destroyed (kvm_destroy_vm_debugfs(), before the nested mmus are freed
in kvm_destroy_nested()). This allows us to store the kvm_s2_mmu pointers
in the ptdump code, after Marc's nested mmu lifecycle fixes [2].

For the shadow ptdump, for valid nested mmus the first line will show
the nested context's VTTBR and VTCR values, and whether s2 is enabled or
not. The ptdump then follows.

The first patch fixes mmu->pgt accesses after the VM MMU teardown in
ptdump.c, the second patch switches from per nested context ptdumps to
per nested mmu ptdumps.

Tested with CONFIG_PROVE_LOCKING, CONFIG_DEBUG_ATOMIC_SLEEP, and
CONFIG_KASAN.

Series based on kvmarm/fixes.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260916230337.4162485-1-weilin.chang@arm.com/
[2]: https://lore.kernel.org/kvmarm/20260911162203.1919330-1-maz@kernel.org/

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

