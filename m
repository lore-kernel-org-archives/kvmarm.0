Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D54931E85D
	for <kvmarm@lists.linux.dev>; Sat, 28 Mar 2026 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774709714; cv=none; b=uEOwMTdZsXRZ6DOWJN7ThSF8sfVv+fpOfIm4J7CGOlZhU0OLycC066IfZECCvEDrxclaeOBfXK7a251kzF3fGIiNYAPiSOUDcw4uNChihmvcPLuhYY6xkbg9BM06NA3zsLA58o4uJ1aVPpWgzlkg2ZZ0HhSYWFl2f+MFe4eFvAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774709714; c=relaxed/simple;
	bh=NlRVE9bGVP4eixMrI2DD5OnHRc2Xeq2aI5b+GYpyI5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RoBT50WDoNTnh1jafnHv6QMc+ikftLMSdX98F+g/5mds6QPLkLdVLWvwHKDLJPHorNwxYHP4h6l6TGADnq8NDHYCE37sDR7Nm8zxgyiqCF4mKPxVYTXxLVCkGIJDgoVexl+WBtLnj7K9ZpoKvoffZDYz0fdT4quuu2awaERjUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gVU0WhUY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gVU0WhUY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23DB245E5;
	Sat, 28 Mar 2026 07:55:00 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E0703F905;
	Sat, 28 Mar 2026 07:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774709706; bh=NlRVE9bGVP4eixMrI2DD5OnHRc2Xeq2aI5b+GYpyI5k=;
	h=From:To:Cc:Subject:Date:From;
	b=gVU0WhUYJMW/vcdwGy7FEfLuWn1hZ3aHJhSuxVVTYns1BOif447samFyHFhf/73M5
	 gylXRRysltdeUE2RGyRWdSwCStwwYg9P7PnFOuENQbAH37DJ7JubGRo3oz+fcl3g1J
	 bz4ec9NxrWnZKqNPHseiM6PSoMR4RreD7Xubi9jU=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/2] KVM: arm64: Small cleanups for stage-2 mmu teardown
Date: Sat, 28 Mar 2026 14:54:37 +0000
Message-ID: <20260328145439.2501562-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

While reading the code I found the uninitialization paths of the s2 mmus
a bit confusing, so I did a small cleanup. It includes renaming a
function and a small refactor. Please see the commit messages for the
details.

Thanks!

Wei-Lin Chang (2):
  KVM: arm64: Rename kvm_free_stage2_pgd()
  KVM: arm64: Refactor stage2 mmu tear down functions

 arch/arm64/include/asm/kvm_mmu.h |  4 ++--
 arch/arm64/kvm/mmu.c             | 10 ++++++----
 arch/arm64/kvm/nested.c          |  6 +++---
 3 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.43.0

