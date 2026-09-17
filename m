Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C30A4DDB5E
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660200; cv=none; b=AvcW3I51i0lovfJdQ1A6kADXoc/1KVIpOGKnlATAvbZBANPtefXZuz6lpfHC2B+ykCXDbaOsqir5xb9SlwJcCckj/zRQb9ESOWDKPgNY9SL0vU9k5ZFXVt1ztCI3OQ2HpAhQ2FmwBv6ynwsPVh1vf+XKHMeNI/zb1/ytfb5jrQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660200; c=relaxed/simple;
	bh=RJzKdDo+REX/VlAsX42GpLBJ8XTELLDjR7TtOlDY7IQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hzZBoouZKajCUX0Dl3o7a211oU/+gl7WFDt0sCOLvZ4glnSUwR7lIPN/zIPHTTogwmORfw6C2D2F/KsuG70xp813NK+wl14RDGYbOw+IowsBpkYS4hTZuruJymK+WfxAIbyPbWX6JFUnbIBB3JxPRXZimJ7tEe7DIaIvkUbAE2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F0IPwOCm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F0IPwOCm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CC2C1476;
	Thu, 17 Sep 2026 08:49:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 328DA3F7B4;
	Thu, 17 Sep 2026 08:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660191; bh=RJzKdDo+REX/VlAsX42GpLBJ8XTELLDjR7TtOlDY7IQ=;
	h=From:To:Subject:Date:From;
	b=F0IPwOCmHpw5v1mc5QunUDRw1xCBe9gpk8MYh7Ami6aYqjBvmdxNpaaP4i0GZhxY2
	 YsbHuVNWhFjQhqBlL0qk+Y0BcqrXDpdu32nEJilOnoZMpTPd0PHz2u791ky1LnuOgy
	 ijFqCb1FJHhJIOXaqI9kbT2TTBHOOotZE3Mo0WeA=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool 0/7] Fix --vcpu-affinity
Date: Thu, 17 Sep 2026 16:49:25 +0100
Message-ID: <20260917154932.193943-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is my attempt at fixing --vcpu-affinity, which I introduced. Patches #1-#4
are straightforward fixes, and they don't modify the current (broken) behaviour
in any way. Patch #5 fixes is most of the fix: with it, the VCPU threads run on
the physical CPUs passed to --vcpu-affinity, and most of the kvmtool threads,
except the virtio threads, use the main thread affinity.

The virtio threads are special because they are spawned from the VCPU threads,
and they inherit the VCPU thread affinity. Note that there might be other cases
where this happens.

Patches #6-#7 attempt to fix the remaining issue: #6 switch the entire codebase
to kvm_create_thread() instead of pthread_create(). In #7, kvm_create_thread()
will use the main thread affinity when creating new threads. These two patches
are RFC because they cause a lot of churn and I would like some feedback if it's
worth it.

Why is it useful to run the VCPUs on different physical CPUs than the other
threads? I can think of two situations:

1. Testing heterogenous hardware configurations, where the VM creation and setup
happens on a set of physical CPUs, and the VCPUs are run on a different set. I
used these patches for the KVM SPE series.

2. I/O testing. Maybe?

Tested on an Orion board and a x86 machine. On the x86 machine, there's was this
one thread called 'kvm-nx-lpage-re' which had affinity of the VCPUs, but I
couldn't figure out where it was created. I grep'ed for each part of the name in
the source node, no luck. I used strace, and couldn't see a clone call that
returned the corresponding pid. Any clues would be appreciated.

Alexandru Elisei (7):
  arm64: Pass the number of elements as the first argument to calloc()
  arm64: Consistently treat vcpu_affinity_cpuset as dynamically
    allocated
  arm64: Free the temporary cpumask in vcpu_affinity_parser()
  arm64/pmu: Consider kvmtool's affinity when searching for a PMU
  Correctly apply --vcpu-affinity to the VCPU threads
  Introduce kvm_create_thread()
  Don't apply --vcpu-affinity to threads spawned from VCPUs

 arm64/include/kvm/kvm-arch.h        |  2 --
 arm64/include/kvm/kvm-config-arch.h |  5 ----
 arm64/kvm-cpu.c                     |  9 ------
 arm64/kvm.c                         | 31 --------------------
 arm64/pmu.c                         | 31 +++++++++++---------
 builtin-run.c                       | 41 +++++++++++++++++++++++++--
 disk/aio.c                          |  3 +-
 disk/blk.c                          | 12 ++++++--
 disk/core.c                         | 29 ++++++++++---------
 disk/qcow.c                         | 44 ++++++++++++++++++++---------
 disk/raw.c                          | 21 +++++++++++---
 epoll.c                             |  2 +-
 include/kvm/disk-image.h            | 28 ++++++++++++------
 include/kvm/kvm-config.h            |  1 +
 include/kvm/kvm.h                   |  2 ++
 include/kvm/qcow.h                  |  3 +-
 include/kvm/uip.h                   |  2 ++
 include/kvm/util.h                  |  6 ++++
 kvm.c                               | 18 ++++++++++++
 net/uip/tcp.c                       |  7 ++---
 net/uip/udp.c                       |  5 ++--
 term.c                              |  4 +--
 ui/gtk3.c                           |  2 +-
 ui/sdl.c                            |  2 +-
 ui/vnc.c                            |  2 +-
 util/threadpool.c                   |  9 +++---
 util/util.c                         | 42 +++++++++++++++++++++++++++
 virtio/blk.c                        |  2 +-
 virtio/net.c                        | 26 +++++++++++------
 29 files changed, 258 insertions(+), 133 deletions(-)


base-commit: f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9
-- 
2.55.0

