Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A2A1D5AC6
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759222372; cv=none; b=g+1tTn87AfzYiR74m7LHumeNyv9/Wuqf7nw9z/U+NRBYTi/ziHPLJ+BwcbnrVTM941o3N6fquAeCQpi8hbWRKauWjep536CdHy0aGwkWoXncoFxz12j6GcXrQSW/2fef1K+0Z226nfXPstZ7KgigEY5bQed+yo19O07dx+ABehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759222372; c=relaxed/simple;
	bh=RolK84d4YEmZDJGqxxFUWjVWiZW2624dVKeGrayET1A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mPGrkx9KaCrB+UqWO0g3MNFxbhLtpqqaI79DjITHZOFh5nIPNvcV2VxOW+W2IP1eIzwaH0++Ipogv8bV94ZEdsu2rLiZNiiyUGt1L8TbTNCnWwa9yYjKcLan3SFcAkRY9ePYweg330fxxPWhc8wAjEDMuogDgtoeGbHkmw5S1DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C3gpJDXO; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C3gpJDXO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759222367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fO4H831Gj0XcQXa/CBJ4KpYimoBucD9IAyXJi5ODctk=;
	b=C3gpJDXOACHAQEnoMAoBwnVQZs5KRLvQ4499eGhI1TEpqdUAotKSeTQQQ+7J5rLE/r9j0p
	U1EY9/gNKh1gWXuzn/tZB0FM/oN0wIeiFV97Q0M8NapuFHLOwDpz3/t6rsdToDRWgauqVr
	wGZlNgkLEtx+vb0xmF3F4J6v/7b29VE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Prevent access to vCPU events before init
Date: Tue, 30 Sep 2025 01:52:37 -0700
Message-Id: <20250930085237.108326-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Another day, another syzkaller bug. KVM erroneously allows userspace to
pend vCPU events for a vCPU that hasn't been initialized yet, leading to
KVM interpreting a bunch of uninitialized garbage for routing /
injecting the exception.

In one case the injection code and the hyp disagree on whether the vCPU
has a 32bit EL1 and put the vCPU into an illegal mode for AArch64,
tripping the BUG() in exception_target_el() during the next injection:

  kernel BUG at arch/arm64/kvm/inject_fault.c:40!
  Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
  CPU: 3 UID: 0 PID: 318 Comm: repro Not tainted 6.17.0-rc4-00104-g10fd0285305d #6 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : exception_target_el+0x88/0x8c
  lr : pend_serror_exception+0x18/0x13c
  sp : ffff800082f03a10
  x29: ffff800082f03a10 x28: ffff0000cb132280 x27: 0000000000000000
  x26: 0000000000000000 x25: ffff0000c2a99c20 x24: 0000000000000000
  x23: 0000000000008000 x22: 0000000000000002 x21: 0000000000000004
  x20: 0000000000008000 x19: ffff0000c2a99c20 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 00000000200000c0
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
  x8 : ffff800082f03af8 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : ffff800080f621f0 x4 : 0000000000000000 x3 : 0000000000000000
  x2 : 000000000040009b x1 : 0000000000000003 x0 : ffff0000c2a99c20
  Call trace:
   exception_target_el+0x88/0x8c (P)
   kvm_inject_serror_esr+0x40/0x3b4
   __kvm_arm_vcpu_set_events+0xf0/0x100
   kvm_arch_vcpu_ioctl+0x180/0x9d4
   kvm_vcpu_ioctl+0x60c/0x9f4
   __arm64_sys_ioctl+0xac/0x104
   invoke_syscall+0x48/0x110
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x34/0xf0
   el0t_64_sync_handler+0xa0/0xe4
   el0t_64_sync+0x198/0x19c
  Code: f946bc01 b4fffe61 9101e020 17fffff2 (d4210000)

Reject the ioctls outright as no sane VMM would call these before
KVM_ARM_VCPU_INIT anyway. Even if it did the exception would've been
thrown away by the eventual reset of the vCPU's state.

Cc: stable@vger.kernel.org # 6.17
Fixes: b7b27facc7b5 ("arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

While the blamed commit is indeed broken, only 6.17+ kernels actually
hit the BUG() due to commit efa1368ba9f4 ("KVM: arm64: Commit exceptions
from KVM_SET_VCPU_EVENTS immediately).

 arch/arm64/kvm/arm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a59b4046617c..c44357d26ee8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1795,6 +1795,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
 		if (kvm_arm_vcpu_get_events(vcpu, &events))
 			return -EINVAL;
 
@@ -1806,6 +1809,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_VCPU_EVENTS: {
 		struct kvm_vcpu_events events;
 
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
 		if (copy_from_user(&events, argp, sizeof(events)))
 			return -EFAULT;
 

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.39.5

