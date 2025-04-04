Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E81721A455
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785593; cv=none; b=cf3MkYvqRvxTEsU9z30Z5kmlqcyJ5lMjXCP4itMvJYoS9NSN0VM7l1LgweVHbhMQr3p5hPliYxSQh0DXxG8Gl1d87FrbeE2l/KPhm2vqm0n7DjsiY+k+rwA/oaWv/sqLbfIWdOl19PlU+9Irara/RcS7ui4JPmjVkZ/hsUW4Q2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785593; c=relaxed/simple;
	bh=uylS2fH8HOVWEiMejNDgXahFJMwVFoQ8VEqCmtDQjp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V6rQc0YnMQLVHZEE9LQ2nh5xGJh3Un5WHfQIEuXAUX5Dxk/lz7Ow21IkLXuLa2YyvlcVApr4OAzm9Opy5UM7OvKw7a8R3kfoQhkkbDKdMVInKsDhxbSsMDbpEwxX0PTDvmW7v/Ftpo0INYrPWK31Qd9E9nJPd3tb5IJMZx6SyH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xs3yS0XA; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xs3yS0XA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVLygIQ8gQ31JvfSPdyVIbUnMl1rHte2lGTyT296jas=;
	b=xs3yS0XAEaWLBZVmsRkGOgfM6OagCr6K7k2vfNWhHiNe2ebTHfm+pOG+0d1LwSgvqkv6UU
	mWtWj6wwumCSbjQoaonBQo0rYCh9DNsEeTHqQc7pn1Hh9YDud6YmhuovLNlgVKMf7TBPgI
	PLiR1TVt3HQsRfrBeQsnposKOe7RqdI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 00/19] KVM: arm64: Debug cleanups
Date: Fri,  4 Apr 2025 09:52:33 -0700
Message-Id: <20250404165233.3205127-11-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hopefully the last round.

v3 -> v4:
 - Collect Tested-by from James (thanks!)
 - Delete stray if condition (Marc)
 - Write mdcr_el2 from kvm_arm_setup_mdcr_el2() on VHE
 - Purge DBGxVR/DBGxCR accessors since it isn't nice to look at

Oliver Upton (19):
  KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU
  KVM: arm64: Move host SME/SVE tracking flags to host data
  KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
  KVM: arm64: Evaluate debug owner at vcpu_load()
  KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
  KVM: arm64: Select debug state to save/restore based on debug owner
  KVM: arm64: Remove debug tracepoints
  KVM: arm64: Remove vestiges of debug_ptr
  KVM: arm64: Use debug_owner to track if debug regs need save/restore
  KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
  KVM: arm64: Compute MDCR_EL2 at vcpu_load()
  KVM: arm64: Don't hijack guest context MDSCR_EL1
  KVM: arm64: Manage software step state at load/put
  KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
  KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
  KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
  KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads

 arch/arm64/include/asm/kvm_asm.h           |   5 +-
 arch/arm64/include/asm/kvm_host.h          |  94 ++---
 arch/arm64/include/asm/kvm_nested.h        |   1 +
 arch/arm64/kvm/arm.c                       |  14 +-
 arch/arm64/kvm/debug.c                     | 384 +++++++--------------
 arch/arm64/kvm/emulate-nested.c            |  23 +-
 arch/arm64/kvm/fpsimd.c                    |  12 +-
 arch/arm64/kvm/guest.c                     |  31 +-
 arch/arm64/kvm/handle_exit.c               |   5 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 ++-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
 arch/arm64/kvm/sys_regs.c                  | 245 ++++---------
 arch/arm64/kvm/trace_handle_exit.h         |  75 ----
 16 files changed, 353 insertions(+), 647 deletions(-)


base-commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
-- 
2.39.5

