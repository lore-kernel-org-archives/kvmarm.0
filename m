Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794813214;
	b=fZf9A/TSewAbqWqn9kHqM609xYDdKOobLpf12vQpbxRLt6oIJD4wiaorh9eUnTYJ64nT
	 G9g03MfoZLhxwKFrr8+D5ioocgs8gUGUpX6xaMzE2PAKrcwkQyr8S6I4yXeO7bT7LdV/K
	 N1WGM/CVxpEBrflN9F0rCbR9L3D1FLssj1j2lHXoj8phH9d/ROISOaXqXIn+PfD+j6Wwc
	 kx4QKpIw0sRF71zHujh/MphrIpTkuy71a+Ej1t/5HfY1ZIkvJy6K41lYBA0H2HYsjAKY0
	 xvPqO/o9ngEUpaW3xpQdX7fIVPnjyWZ3MKK3gR7mGZYCTH+zyJ/q2kcYV4aCFureLBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794813214;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VpUJNN9+a/GlMSqz88huValOHytFq94955DZY1zfLec=;
	b=QzEFTayWeXUuZIGW7XdGmR0H+nVgg5k0LZ0M2J+/J9iUFYy89JWrch3sIyQaSVblwU23
	 S5gjh0yungyE+go7mGJDGZBUk8H3BMmIa/54gV/cxZxUwXpxtB5yq3TdoS510Z4ve3Ql0
	 17m+1I1ZA5bSw2wC+IZPh4bGNM6x+XdwR/IRerFeUwGgvl++YPuavi6wVqnzqK/i3a/Up
	 0R9DNosy+p/vt3UnF2IsqexUfClhmFZBmkIs92bUqREsVVlEGbqwFpKGmphZdzQAJU96Z
	 EgRdTS/xsQ/Xe/jjS3E20x2mFWzZYaBEc0LUYOCrg7FLOG73/MwWQ+bSQRi+y/CHRXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=al9ga3TH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9599606A329;
	Mon, 16 Nov 2026 07:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9599606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=al9ga3TH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6660C1A25;
	Sun, 15 Nov 2026 23:13:30 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 90D783F673;
	Sun, 15 Nov 2026 23:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794813213; bh=aOEovc4UUb37VOtU6pV8CsO4jvExxScmZMPfHabsAvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=al9ga3THmbqwes3lXSjI8QJHGWLTdacCLfEPjYv22PEW5d5lsXC7HYjpD/UIkzjg2
	 7Lq4siwviQLqmIcB0U3kxmcks+Q6x57tnNTsU7HNtnVZVMd3c53XjreEzhI923kFgt
	 doDB6nQ0fuZaon/Ve1Kln6Pk+MalGWEi8Eegynf8=
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
Subject: [PATCH 2/2] KVM: arm64: gic-v5: Don't move the vPE doorbell from kvm_sched_out()
Date: Mon, 16 Nov 2026 07:13:04 +0000
Message-Id: <20261116071304.2037895-3-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261116071304.2037895-1-justin.he@arm.com>
References: <20261116071304.2037895-1-justin.he@arm.com>
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

vgic_v5_put() makes the vPE doorbell affine to the current CPU when the
vcpu enters WFI. This is meant for the explicit put from kvm_vcpu_wfi(),
but the same code also runs from kvm_sched_out() whenever the vPE is
resident with IN_WFI set.

That happens when the vcpu thread is scheduled back in while halting:
unlike vgic_v4_load(), vgic_v5_load() does not bail out on IN_WFI and
makes the vPE resident again, so the next sched-out, from
kvm_vcpu_block() or from a preemption during halt polling, goes through
vgic_v5_put() with IN_WFI still set. If the thread moved to another
CPU in between, irq_set_affinity() is called with the runqueue lock
held:

  irq_set_affinity+0x38/0x88
  vgic_v5_put+0xf0/0x2b8
  kvm_vgic_put+0x64/0xb0
  vhe_vcpu_put+0x40/0xa0
  kvm_arch_vcpu_put+0x28/0x98
  kvm_sched_out+0x4c/0x70
  prepare_task_switch+0x1b0/0x388
  __schedule+0x234/0x958
  schedule+0x58/0x138
  kvm_vcpu_block+0x88/0x130
  kvm_vcpu_halt+0x120/0x468
  kvm_vcpu_wfi+0x80/0x190

irq_set_affinity() takes the doorbell's irq_desc lock and, when the
doorbell is force-threaded (threadirqs, PREEMPT_RT), wakes its irq
thread:

  &rq->__lock --> &irq_desc_lock_class --> &p->pi_lock --> &rq->__lock

Moving the doorbell is only an optimisation: the doorbell handler kicks
the vcpu from any CPU, and the next WFI entry moves it again. Skip it
when vcpu->scheduled_out is set, which kvm_vcpu_put_hw_mmu() also uses
to tell a sched-out from an explicit put.

Fixes: 2111261ac1c8 ("KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI")
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 91810fbd99af..5824b00bb50d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1248,8 +1248,14 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 			 * Make the doorbell affine to this CPU, if it isn't
 			 * already. Actively check the cpumask first as it is
 			 * cheaper than changing the affinity every time.
+			 *
+			 * Don't do it from kvm_sched_out(), which holds the
+			 * runqueue lock: irq_set_affinity() takes the
+			 * doorbell's irq_desc lock and may wake its irq
+			 * thread. The doorbell works from any CPU, and the
+			 * next WFI entry moves it.
 			 */
-			if (!cpumask_test_cpu(cpu, aff)) {
+			if (!vcpu->scheduled_out && !cpumask_test_cpu(cpu, aff)) {
 				int ret;
 
 				ret = irq_set_affinity(db_irq, cpumask_of(cpu));
-- 
2.34.1

