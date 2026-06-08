Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3451234572B
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915487; cv=none; b=RsAq77h0TVFWRwF8iD8BF1WolvelqkeET1bS0vS2lp9GxGWTmgnVY2zsakNc+gjeTAUlslq6zbhJvUS8Ts8nX0jXJp+cmQyPyh9ab9F+sjtNAXOm78l7wms8XRWhBc5vHnrSkjdFbQWGThvBIOwTjr+rH4N37esslc5KHhMxnhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915487; c=relaxed/simple;
	bh=juw9Ecq+Ww23l+6wnG1pvcFHirYf/iwxehFssvlnUdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VQeB3zSKc5j9h6Q6zSSDzmS2BSQp8eyAijG6NFh9BEZAWszpgPuHYh7QmXXl/YQJQUg8nwmyUTg3IsbglcX50GanoQxmHI7SsZAPLls3J4hq/Q/UUfDgCRcV0lPJ2ulp9FcYE0FHYpiIB2nM67dBQ1J6BTY6ljuU/L68/Bb1a0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZbUSTprR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZbUSTprR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEB1C1E2F;
	Mon,  8 Jun 2026 03:44:40 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5119F3F62B;
	Mon,  8 Jun 2026 03:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780915485; bh=juw9Ecq+Ww23l+6wnG1pvcFHirYf/iwxehFssvlnUdQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ZbUSTprRbmLSSuS0uttVUtUZT1SZGqlPF2Y1AJTGlssi1yrePrnT91uQPg9rboXe7
	 45v42GoGP2eDO5ROWq0TVav7o6lTwQpYu1/nBkn8UE5A4bkU2hQJ/sx04XCS9qd+U8
	 Djwqt7cmcqB4NjkEEdAAiuZdzPLE8o9+am24Wizg=
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH 0/1] KVM: arm64: Make kvm_s2_fault_pin_pfn() fault-in interruptible
Date: Mon,  8 Jun 2026 10:43:35 +0000
Message-Id: <20260608104336.2405384-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I hit this while looking at long vCPU hung-task stalls with nested
virtualization enabled.

The vCPU was blocked in the fault-in path on a userspace folio which was
under migration:

  __kvm_faultin_pfn()
    -> get_user_pages_unlocked()
      -> do_swap_page()              /* PTE is a migration entry */
        -> migration_entry_wait()
           set_current_state(TASK_UNINTERRUPTIBLE);
           io_schedule();            /* no timeout */

At this point the vCPU cannot observe a pending signal. If userspace is
trying to tear down the VM, the vCPU thread can still remain stuck until
migration finishes and the folio lock is released.

Nested virtualization makes this much easier to hit. The migration path
can hold the folio lock while the MMU notifier runs kvm_nested_s2_unmap(),
and that can be expensive today since it may walk all active shadow
stage-2s. So the long delay is really caused by the unmap/migration side;
the vCPU is just waiting for it to finish.

This patch does not try to make that unmap path cheaper. That is a
separate issue, and range-aware shadow stage-2 unmap work, such as
Wei-Lin Chang's "KVM: arm64: nv: Avoid full shadow s2 unmap" series,
is aimed at that problem.

What this patch does is narrower: use FOLL_INTERRUPTIBLE when faulting in
the userspace page for the arm64 stage-2 fault path. If the vCPU thread
has a pending signal, GUP can return and KVM can leave KVM_RUN through the
normal KVM_EXIT_INTR path. If there is no pending signal, the behaviour is
unchanged.

Jia He (1):
  KVM: arm64: Make kvm_s2_fault_pin_pfn() fault-in interruptible

 arch/arm64/kvm/mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.34.1

