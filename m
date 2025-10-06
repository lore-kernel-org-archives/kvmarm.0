Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D9B220F36;
	Mon,  6 Oct 2025 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759745317; cv=none; b=IIm+7hLIVorVHIeaHOWvp6DOs3aCP6YG6FhI85fS9Yo6jLwnxOoWqCmLB9njH+p2s5Yis/ouR6yY8fI0T5At5LO2geqDmZMBu79UbCCuiD6XQ4g7r5c8cY4UQ1XE7elAr2LWC0pxqKVEOulQ9OYaWsA4gfwUHW9nhAnPYc3frZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759745317; c=relaxed/simple;
	bh=9l3H9m98dWuqVcEguJJCwW2d8nWAjAjRtMaaZIkr8e8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=majyPWY9jJsU8mY4ZMQtMI1Ydei9CjsaNnmqRM5dVDAJHt2Uz9sGlKGp2DMpJSogqYSeTJEMcesFn5wcuGS7VkUu+e0Fz3q7DOH0PvEDiLuq130+tynJOLCVhwgFYdQRvF4Mnx46OCvbhT0X/nMDdVguoY4b9Fd6HSwlGy56nHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzU5ayyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzU5ayyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39955C4CEF5;
	Mon,  6 Oct 2025 10:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759745316;
	bh=9l3H9m98dWuqVcEguJJCwW2d8nWAjAjRtMaaZIkr8e8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=lzU5ayyB3/nLpMp1mvbssfCh14ecYJQO9HvzGQiIlAjYYzTCxhWSqtJMt4Qvp+ze+
	 40NOSNBP6ewWIU7are/aX6kKsQ/Tlj7HjEM3tysG8DBxIzQa8tdpdfur/2cjSvV4wb
	 yrpDHtp29hMzwy8/IQ3O+5hfVrqgBdO4kA84bCmA=
Subject: Patch "KVM: arm64: Fix softirq masking in FPSIMD register saving sequence" has been added to the 6.6-stable tree
To: ardb@kernel.org,gregkh@linuxfoundation.org,kvanals@kvanals.org,kvmarm@lists.linux.dev,lee@kernel.org,linux-arm-kernel@lists.infradead.org,sashal@kernel.org,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Oct 2025 12:08:26 +0200
In-Reply-To: <20251003184054.4286-1-will@kernel.org>
Message-ID: <2025100626-tinderbox-captive-517f@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    KVM: arm64: Fix softirq masking in FPSIMD register saving sequence

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-fix-softirq-masking-in-fpsimd-register-saving-sequence.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From will@kernel.org  Mon Oct  6 11:58:17 2025
From: Will Deacon <will@kernel.org>
Date: Fri,  3 Oct 2025 19:40:54 +0100
Subject: KVM: arm64: Fix softirq masking in FPSIMD register saving sequence
To: stable@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kenneth Van Alstyne <kvanals@kvanals.org>
Message-ID: <20251003184054.4286-1-will@kernel.org>

From: Will Deacon <will@kernel.org>

Stable commit 28b82be094e2 ("KVM: arm64: Fix kernel BUG() due to bad
backport of FPSIMD/SVE/SME fix") fixed a kernel BUG() caused by a bad
backport of upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally
save+flush host FPSIMD/SVE/SME state") by ensuring that softirqs are
disabled/enabled across the fpsimd register save operation.

Unfortunately, although this fixes the original issue, it can now lead
to deadlock when re-enabling softirqs causes pending softirqs to be
handled with locks already held:

 | BUG: spinlock recursion on CPU#7, CPU 3/KVM/57616
 |  lock: 0xffff3045ef850240, .magic: dead4ead, .owner: CPU 3/KVM/57616, .owner_cpu: 7
 | CPU: 7 PID: 57616 Comm: CPU 3/KVM Tainted: G           O       6.1.152 #1
 | Hardware name: SoftIron SoftIron Platform Mainboard/SoftIron Platform Mainboard, BIOS 1.31 May 11 2023
 | Call trace:
 |  dump_backtrace+0xe4/0x110
 |  show_stack+0x20/0x30
 |  dump_stack_lvl+0x6c/0x88
 |  dump_stack+0x18/0x34
 |  spin_dump+0x98/0xac
 |  do_raw_spin_lock+0x70/0x128
 |  _raw_spin_lock+0x18/0x28
 |  raw_spin_rq_lock_nested+0x18/0x28
 |  update_blocked_averages+0x70/0x550
 |  run_rebalance_domains+0x50/0x70
 |  handle_softirqs+0x198/0x328
 |  __do_softirq+0x1c/0x28
 |  ____do_softirq+0x18/0x28
 |  call_on_irq_stack+0x30/0x48
 |  do_softirq_own_stack+0x24/0x30
 |  do_softirq+0x74/0x90
 |  __local_bh_enable_ip+0x64/0x80
 |  fpsimd_save_and_flush_cpu_state+0x5c/0x68
 |  kvm_arch_vcpu_put_fp+0x4c/0x88
 |  kvm_arch_vcpu_put+0x28/0x88
 |  kvm_sched_out+0x38/0x58
 |  __schedule+0x55c/0x6c8
 |  schedule+0x60/0xa8

Take a tiny step towards the upstream fix in 9b19700e623f ("arm64:
fpsimd: Drop unneeded 'busy' flag") by additionally disabling hardirqs
while saving the fpsimd registers.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # 6.6.y
Fixes: 28b82be094e2 ("KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix")
Reported-by: Kenneth Van Alstyne <kvanals@kvanals.org>
Link: https://lore.kernel.org/r/010001999bae0958-4d80d25d-8dda-4006-a6b9-798f3e774f6c-000000@email.amazonses.com
Signed-off-by: Will Deacon <will@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index d0d836448a76..83827384982e 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1873,13 +1873,17 @@ static void fpsimd_flush_cpu_state(void)
  */
 void fpsimd_save_and_flush_cpu_state(void)
 {
+	unsigned long flags;
+
 	if (!system_supports_fpsimd())
 		return;
 	WARN_ON(preemptible());
-	get_cpu_fpsimd_context();
+	local_irq_save(flags);
+	__get_cpu_fpsimd_context();
 	fpsimd_save();
 	fpsimd_flush_cpu_state();
-	put_cpu_fpsimd_context();
+	__put_cpu_fpsimd_context();
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
-- 
2.51.0.618.g983fd99d29-goog



Patches currently in stable-queue which might be from will@kernel.org are

queue-6.6/kvm-arm64-fix-softirq-masking-in-fpsimd-register-saving-sequence.patch
