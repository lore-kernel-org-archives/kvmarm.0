Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24537311979;
	Fri, 22 Aug 2025 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755872754; cv=none; b=N4IgrdLpPmiWqsvgc9OYrrpYdOMt/VmprBhDMyNwK22ZEnDciYukVkW8GZCQa2Nu5iwNtdtr4yaAuIvFFIsswqhbSZWqYbBZsrig/j+saHcHCyW/o6aoHB1tQX4dNbQM5WK1B1ErnD7mFz+KfBVYCXbUyKfb5XGthuHCgYjm/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755872754; c=relaxed/simple;
	bh=76Gtx921lfkYOv/RLmr58xDncs7LI7vNa6RkrmqUAU0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=t5W1HZq0vaD7LHtMMUtvWAeE/f6vkoOOpfUkWgnDapTawmxbhhshEzFHlgRDrs+4FRMTh8WTCI6S5OmwwrH8In9V9JRBmPnWYc1btNXtBq1WkaLQL1tcvwaWpSH+JTGZY11DzxXthmy1ME9Z/Wbq7uNnl5FvuVYEzzgb10MZkpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3UV70MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3UV70MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72747C4CEED;
	Fri, 22 Aug 2025 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755872754;
	bh=76Gtx921lfkYOv/RLmr58xDncs7LI7vNa6RkrmqUAU0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=t3UV70MM2rvMkNEQtuhMOh1GMQq5uD3TY8m+B+7jjX7jM6spSefLPztxfvA3kAHV5
	 xkeMP5+wNJxo7I1TSnAdvxVL5xKZTS59HC4oPEAz72aYPP5wVPG9BR3I+ACIvcAq23
	 oPsMsQxcgCnrizwyRy/dPLSOtn9OsasEs6YG31Ik=
Subject: Patch "KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix" has been added to the 6.6-stable tree
To: ardb@kernel.org,gregkh@linuxfoundation.org,kvmarm@lists.linux.dev,lee@kernel.org,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,sashal@kernel.org,tabba@google.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 16:25:51 +0200
In-Reply-To: <20250822140402.2688-1-will@kernel.org>
Message-ID: <2025082250-occultist-shingle-27f9@gregkh>
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

    KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-fix-kernel-bug-due-to-bad-backport-of-fpsimd-sve-sme-fix.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From will@kernel.org  Fri Aug 22 16:24:21 2025
From: Will Deacon <will@kernel.org>
Date: Fri, 22 Aug 2025 15:04:02 +0100
Subject: KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix
To: stable@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>
Message-ID: <20250822140402.2688-1-will@kernel.org>

From: Will Deacon <will@kernel.org>

Upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally save+flush
host FPSIMD/SVE/SME state") relies on interrupts being disabled during
fpsimd_save_and_flush_cpu_state() so that a softirq cannot be taken
while the host floating point context is being saved and potentially try
to use kernel-mode NEON.

Unfortunately, stable kernels without 9b19700e623f ("arm64: fpsimd: Drop
unneeded 'busy' flag") leave interrupts enabled in
fpsimd_save_and_flush_cpu_state() and so the BUG_ON(!may_use_simd()) in
kernel_neon_begin() has been observed to trigger in real-world usage:

 |  kernel BUG at arch/arm64/kernel/fpsimd.c:1904!
 |  Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
 |
 |  Call trace:
 |   kernel_neon_begin+0xdc/0x12c
 |   ...
 |   crypto_aead_decrypt+0x5c/0x6c
 |   seqiv_aead_decrypt+0x88/0x9c
 |   crypto_aead_decrypt+0x5c/0x6c
 |   esp_input+0x280/0x364
 |   xfrm_input+0x6ac/0x16f8
 |   ...
 |   net_rx_action+0x13c/0x31c
 |   handle_softirqs+0x124/0x3d0
 |   __do_softirq+0x14/0x20
 |   ____do_softirq+0x10/0x20
 |   call_on_irq_stack+0x3c/0x74
 |   do_softirq_own_stack+0x1c/0x2c
 |   __irq_exit_rcu+0x54/0xb4
 |   irq_exit_rcu+0x10/0x1c
 |   el1_interrupt+0x38/0x58
 |   el1h_64_irq_handler+0x18/0x24
 |   el1h_64_irq+0x68/0x6c
 |   fpsimd_save+0xe4/0x130
 |   kvm_arch_vcpu_load_fp+0x2c/0x58
 |   kvm_arch_vcpu_load+0x88/0x26c
 |   kvm_sched_in+0x2c/0x3c

Given that 9b19700e623f ("arm64: fpsimd: Drop unneeded 'busy' flag") is
not a fix in its own right, has non-trivial dependencies and is a
reasonably invasive change to the in-kernel use of fpsimd, opt instead
for a simple fix to use the softirq-safe {get,put}_cpu_fpsimd_context()
helpers in fpsimd_save_and_flush_cpu_state().

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.y, 6.1.y and 6.6.y
Fixes: 806d5c1e1d2e ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state") # 6.6.y
Fixes: 04c50cc23a49 ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state") # 6.1.y
Fixes: 5289ac43b69c ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state") # 5.15.y
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1876,10 +1876,10 @@ void fpsimd_save_and_flush_cpu_state(voi
 	if (!system_supports_fpsimd())
 		return;
 	WARN_ON(preemptible());
-	__get_cpu_fpsimd_context();
+	get_cpu_fpsimd_context();
 	fpsimd_save();
 	fpsimd_flush_cpu_state();
-	__put_cpu_fpsimd_context();
+	put_cpu_fpsimd_context();
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON


Patches currently in stable-queue which might be from will@kernel.org are

queue-6.6/vsock-virtio-resize-receive-buffers-so-that-each-skb.patch
queue-6.6/kvm-arm64-fix-kernel-bug-due-to-bad-backport-of-fpsimd-sve-sme-fix.patch
queue-6.6/arm64-mark-kernel-as-tainted-on-sae-and-serror-panic.patch
queue-6.6/vsock-virtio-validate-length-in-packet-header-before-skb_put.patch
queue-6.6/perf-cxlpmu-remove-unintended-newline-from-irq-name-.patch
queue-6.6/iommu-arm-smmu-qcom-add-sm6115-mdss-compatible.patch
queue-6.6/arm64-amu-use-capacity_ref_freq-to-set-amu-ratio.patch
queue-6.6/mm-ptdump-take-the-memory-hotplug-lock-inside-ptdump_walk_pgd.patch
queue-6.6/vhost-vsock-avoid-allocating-arbitrarily-sized-skbs.patch
