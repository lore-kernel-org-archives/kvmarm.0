Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FF817FD
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 00:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727741844; cv=none; b=e5/5XYBcJand3MmrNoM+33ZoDCVQLOwRe64lN5HJx8R3rAVqBmjmkzilBCtLT9fAvflFXIYvSXhgrXrACiL6qGx+oYnOu1BUFaGYZDxqkkh4KchbfniaP3H+6yBtdt//RB4F2LToOkHt9CXwWb6vZfgtmo/hrmr3qLNqMgXIZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727741844; c=relaxed/simple;
	bh=5Bz9dgHhouk7+tz38w40svcPnL+5UFAu5yG0fk8HamU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iwp1Cu8n8mPdDQRQg49Epy4NN8kpbfJpWZo6brk3iPa2sSi5ATkzpTHv4QEI7yQDWA1ROyUj6fR32iBW9f7IPl54q05wkgmWYjBSp79N8CXUX6cOQ6JudAqVdR/il4tzy0ja+kZp7gLqecEFFC7OcWkUP/+HYuQvAmSqvI56+/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tAvQuiTQ; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tAvQuiTQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727741840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OiqfawkVybEAWYXosbyKsbArOAvcQie4DPU9y6Mk8Og=;
	b=tAvQuiTQCIaOFd2zKdY6urW5fokni+JAaxHiBJITcyCm9F5Z1lJRRhC6rGwqGP6F5lV+Yt
	bJVpV3sDutXgX+TI4HUoLHy9kJBUrO0eWBX+P2qo+MU6pSi2lLX4mIMlhbMKGTcKzS71e0
	d+WCKYycXNhkGBuYEusHRDOEQmrhESc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: nv: Fixes for stage-2 MMU recycling
Date: Tue,  1 Oct 2024 00:17:06 +0000
Message-ID: <20241001001709.1303668-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I recently found that the path for reclaiming stage-2 MMUs is a bit
dodgy. We call kvm_stage2_unmap_range() from vcpu_load() when
repurposing a valid MMU, which itself is allowed to block. We repeat
this silliness on the next vcpu_load(), eventually leading to a stack
overflow.

It also looks like the nested hooks into the MMU notifiers are similarly
screwed up, ignoring the @may_block parameter and allowing the page
table walk to block unconditionally.

In addition to that, we are not handling vcpu->arch.hw_mmu safely in
preemptible code, i.e. we could be using a stale pointer on the loaded
hardware MMU.

Set of fixes to address all of the above, by:

1) Allowing vCPUs to 'pin' the loaded stage-2 MMU, guaranteeing that
   vcpu->arch.hw_mmu is stable when used in preemptible code

2) Preventing unmap walks from blocking when disallowed by the calling
   context.

   This is the correct fix for the MMU notifiers, and a "fix" for the
   reclaim case. Unmapping a whole MMU behind the write lock w/o periodically
   releasing the lock hurts vCPU scheduling, especially on larger VMs.

3) Push the cleanup of reclaimed MMUs into a vCPU request, allowing the
   walk to release the lock + CPU as needed.

Applies to 6.12-rc1, tested on M2. An easy way to force the reclaim case
is to constantly rerun a KVM selftest inside the L1 guest, which is how
I found this in the first place.

Oliver Upton (3):
  KVM: arm64: Treat stage-2 MMUs as refcounted generally
  KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
  KVM: arm64: nv: Punt stage-2 recycling to a vCPU request

 arch/arm64/include/asm/kvm_host.h   | 13 ++++++++--
 arch/arm64/include/asm/kvm_mmu.h    | 40 ++++++++++++++++++++++++++++-
 arch/arm64/include/asm/kvm_nested.h |  4 ++-
 arch/arm64/kvm/arm.c                | 12 +++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c    |  2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c       |  4 +--
 arch/arm64/kvm/hyp/vhe/switch.c     |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c        |  4 +--
 arch/arm64/kvm/mmu.c                | 34 +++++++++++++-----------
 arch/arm64/kvm/nested.c             | 39 ++++++++++++++++++++--------
 arch/arm64/kvm/sys_regs.c           |  6 ++---
 13 files changed, 119 insertions(+), 45 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.46.1.824.gd892dcdcdd-goog

