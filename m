Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B6070830
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999475; cv=none; b=bFhf2PWi9j5I7vBlpgtMWKXbSRlK7mnqHIWxO6vCYC7YdczpRbgbI4N5u2w16LgSk4+qBAnUEKaMXYSD31+9e1PqPYuTMdgUk4EeJ2ZyInsm86KlXvfew50vEYRG/1MN2N6DoZdTysVP4vGNDPbKwEya7SZRG6W23G5iAiYlt/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999475; c=relaxed/simple;
	bh=kGLTqSDqNKduog1GOtZuGMpqVSeUXQY7T0QuU7Ou3ok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZZNFv2LSGIDUPOvkHJpbyjwLkFKD1GOt7JCnPs5L6Orvhuceqsn21UwzITGAHRj8U6Lkpx4cfhID38/kyj64phgio5BA6XkBmUeHru8gph0Yz8r4WIr3GPOCBdtacq7sA+ZnVtwAkRT6o7S8eeTxwdsTizp/eEbv2Ey4hfExQYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m84gf694; arc=none smtp.client-ip=95.215.58.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m84gf694"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kGLTqSDqNKduog1GOtZuGMpqVSeUXQY7T0QuU7Ou3ok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789999469; v=1; x=1790604269;
 b=m84gf6949J/twwPJ0E+UKYO/7oeugphoJlkbeXcQdW4hXy86TmR0OJ3+NxeSqf0vBD5ZOMOx
 74SSHIDqz1ybKEWbIIGVt2bs29z2MM7q/hz/utnPaiwgY6EBEy1MfiE++8hTJJON5i22pCRfuuf
 VU/0gbErvR2ah/6DQ6PdO9Sk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 295205c3151231b2;
	Mon, 21 Sep 2026 14:04:29 +0000
X-Mizu-Trace-ID: 295205c3151231b2
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: timers: Program CVAL from the current count when the hardware won't apply the offset
Date: Mon, 21 Sep 2026 15:04:24 +0100
Message-Id: <20260921140427.2211373-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

A guest timer can fail to fire, or fire early, once the guest's counter
is far enough from the host's. Where the hardware won't apply the
offset itself (the physical timer without CNTPOFF_EL2, a CNTPOFF_EL2
host while TGE is set, the virtual timer on x1e), KVM adds it to CVAL
and lets the hardware compare the sum against the raw counter. The
timer condition is an unsigned compare, and adding the offset to both
sides of it preserves it only while both sums wrap or neither does: a
guest whose counter is ahead of the host's by more than CVAL has an
expired timer that never fires, and one behind it can have a far-future
timer fire at once.

Patch 1 computes the programmed value from the current count instead,
and returns a guest hypervisor's own physical CVAL from memory where it
used to subtract the offset from the hardware value. Patch 2 does the
same for the virtual CVAL read on x1e, which has returned CVAL + offset
since the workaround landed. Patch 3 adds the second case, a guest
behind the host with a far-future timer, to arch_timer_edge_cases.

So far it has only shown up in the selftest, which moves the guest
counter half its range away from the host's. On a VHE host without
CNTPOFF_EL2 arch_timer_edge_cases hangs in its physical cval = 0 cases
until the vCPU is next loaded, which is what Zenghui saw on a
Kunpeng920 [1]. On a CNTPOFF_EL2 host (QEMU, here) the same cases
livelock instead. Both go away with patch 1. The arithmetic is wrong
for any offset once one sum wraps and the other doesn't, and the fix
for the selftest's case should be the fix for all of them.

Tested with arch_timer_edge_cases on QEMU with [2] applied, under VHE,
nVHE and pKVM, and under VHE with CNTPOFF_EL2 removed by
id_aa64mmfr0.ecv=1, the host class Zenghui hit. Under VHE with patch 1
reverted the new case fails. QEMU's TCG has a separate bug with the
same offsets, which [2] fixes. Without it the test stalls under nVHE
and pKVM as well, where KVM emulates the physical timer and patch 1
changes nothing. Not exercised here: patch 1's x1e paths in
timer_save_state() and timer_restore_state() and all of patch 2, since
nothing here runs on an x1e, and patch 1's CNTP_CVAL_EL0 read in
kvm_hyp_handle_timer(), which only a guest hypervisor with a physical
offset on a host without CNTPOFF_EL2 reaches.

Patch 1 carries Cc: stable for the hang and the livelock.

Based on Linux 7.3-rc3 (fd73f4a665989).

Cheers,
/fuad

[1] https://lore.kernel.org/r/460258be-0102-e922-c342-4e87cd94b9e5@huawei.com
[2] https://lore.kernel.org/qemu-devel/20260921074451.3158645-1-fuad.tabba@linux.dev/

Fuad Tabba (3):
  KVM: arm64: timers: Compute an offset-applied CVAL from the current
    count
  KVM: arm64: nv: Read a guest hypervisor's CNTV_CVAL_EL0 from memory on
    x1e
  KVM: arm64: selftests: Test a timer set past the counter's wrap

 arch/arm64/kvm/arch_timer.c                   | 27 +++++++++----------
 arch/arm64/kvm/hyp/vhe/switch.c               | 21 +++++++++------
 include/kvm/arm_arch_timer.h                  | 15 +++++++++++
 .../kvm/arm64/arch_timer_edge_cases.c         | 25 +++++++++++++++++
 4 files changed, 65 insertions(+), 23 deletions(-)

-- 
2.39.5

