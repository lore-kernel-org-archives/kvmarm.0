Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794813203;
	b=iFiTw1StR55NAs8af2VX2hIqOXs8+jyIFbfyRtEP9+jA7f7oVn3MeVbWyCD2/yQPjPy9
	 YHpKUa/XZpz72Q8qn+lc9FecTPFzswpsxXki5z8ksbhZQ+jp+Fit3E2qn7LB+WLaVlfUp
	 xTAwV+XmEa5/xH/5SEccheBVwI7xXrvcG3uzf+RQ8lHERKYPktwv7ill8Vw9sg6g6cklt
	 vLG0wiZzbylKjST83luVISkCc7zPetIpDoCIY5nBl/ppVvGWnF/Yt5365MRnHCbDX6Lti
	 Obc1EA4nFZA2z/k40wQFGT9RShX9XRgamlQedTyI9x3EO5QG9HqVnANo58oNG/4AfQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794813203;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=51h+wZNa35FD1EC1X1bdOrgyM+/7WSD6oz6H64NzSRs=;
	b=zRoC2okfL/GtNwRexWpCisO/GIuVHLUenEhtVFDbjwjzfLQ3rmKTSPRwXGpub0++1Mjo
	 ks9e3jpVi2fIvXb70LK6/A1tDe+zBZu9s85RqmagrJLeNabL39ddgTJyscWgu5CpJNQ1g
	 HvUqU/fuah2sOadWn9PLqwKz9UL2s6FImSN+VXYlDicI9wBkG52qRM1gcGLsAV0PTDncg
	 U2EVmOLmh94UedGqOL0Jb8hI4CZjV1UGCZeWJtqZ01+1+QHINne/2TrPddJRI8AU4NG2L
	 fWGvX8fkGMpg3lDTrlDCJepSWDyjMbc1FQpHyZwBcgycGZj7rdHwIX2t5bQs/n/hmfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="BlyO/E4n";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A162606A329;
	Mon, 16 Nov 2026 07:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A162606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BlyO/E4n
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 676231476;
	Sun, 15 Nov 2026 23:13:19 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8B7D93F673;
	Sun, 15 Nov 2026 23:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794813202; bh=a1hWSo6rMM5vS16uc45frAdAoXhN/qdOo7VriKqajX4=;
	h=From:To:Cc:Subject:Date:From;
	b=BlyO/E4nt8iq9lAYlE026ZI86/KRvlSlPukz/xkGD1JqsEhSEyJ5YKGVhOmvgvoRI
	 UmdcPTv0obqztZbi0g3L/061EbgR8F3xQUygRH+y8CDBKrWbyYWJcmLndlLsmHRVyj
	 pRcLDoqOQOISTPx2EUpaZeVHlmf+C/JsQSx2CQms=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	bigeasy@linutronix.de,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Jia He <justin.he@arm.com>
Subject: [PATCH 0/2] KVM: arm64: gic-v5: Fix irq_desc locks taken under the runqueue lock
Date: Mon, 16 Nov 2026 07:13:02 +0000
Message-Id: <20261116071304.2037895-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With a GICv5 guest, kvm_sched_out() takes irq_desc locks with the
runqueue lock held in two places. Lockdep reports both as a circular
dependency with any interrupt that queues affinity notifier work under
its own descriptor lock:

- kvm_timer_vcpu_put() clears the active state of the host timer
  interrupts. These are per-CPU and never threaded, so this one is a
  false positive. Patch 1 gives them a separate lockdep class, as
  commit 7100185bdc11 ("irqchip/gic-v4: Use a separate lockdep class for
  vPE doorbell IRQs") in kvmarm/fixes does for the GICv4 vPE doorbells.

- vgic_v5_put() can move the vPE doorbell with irq_set_affinity() when
  the vcpu thread is scheduled out in the middle of WFI. This came up in
  the review of "KVM: arm64: gic-v5: Request doorbells when VPEs enter
  WFI", where the resident check was expected to make it unreachable.
  It is reachable, because vgic_v5_load() makes the vPE resident again
  when the halting vcpu thread is scheduled back in. As the doorbell can
  be force-threaded, this can wake its irq thread under the runqueue
  lock, so patch 2 stops moving the doorbell from kvm_sched_out()
  rather than hiding it from lockdep.

Tested on the Arm FVP Base RevC AEMvA GICv5 model (11.31.28, 8 CPUs,
VHE) with PROVE_LOCKING, on top of eedaa7d61f1e.

Lockdep reproduction: to provide the other half of the cycle, a test
module registers an affinity notifier on the UART interrupt and changes
its affinity a few times.

- Patch 1: the vgic_v5 selftest pinned to CPU0 next to a busy loop.
  Without the patch, lockdep reports the cycle through
  kvm_timer_vcpu_put(). With it there is no report, and &rq->__lock
  depends on the new class instead of &irq_desc_lock_class.

- Patch 2: a vcpu executing WFI in a loop, woken by an SPI every 5ms,
  with halt_poll_ns at 50ms and the vcpu thread moved to another CPU
  every 1ms. A kprobe on irq_set_affinity() saw 11 calls from
  kvm_sched_out() without the patch, together with the lockdep report
  quoted in the commit message, and none with it. The doorbell is still
  moved from kvm_vcpu_wfi() itself (51 and 61 calls).

PREEMPT_RT reproduction: PREEMPT_RT force-threads the vPE doorbell, so
patch 2 also fixes a real inversion. Without the patch, and without the
test module, the same WFI test makes lockdep report the cycle closed by
the doorbell's own irq thread: irq_set_affinity() from kvm_vcpu_wfi()
wakes the thread under the descriptor lock, while kvm_sched_out() takes
the descriptor lock under the runqueue lock. The model stops making
progress right after the report. With patch 2 there is no report and the
test completes. (Booting PREEMPT_RT on the GICv5 model also needs
"arm64: smp: Don't force-thread the GICv5 IPIs", posted separately.)

Jia He (2):
  KVM: arm64: Give the host timer interrupts a separate lockdep class
  KVM: arm64: gic-v5: Don't move the vPE doorbell from kvm_sched_out()

 arch/arm64/kvm/arch_timer.c   | 15 +++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c |  8 +++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)


base-commit: eedaa7d61f1ec8ae053a9ece0d553785350ac486
-- 
2.34.1

