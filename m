Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F17CA9EAF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 12:25:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A92320679
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 12:25:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A92320679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A58AC4A94A;
	Thu, 24 Oct 2019 08:25:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9C5veRw6QFlA; Thu, 24 Oct 2019 08:25:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A97E4A874;
	Thu, 24 Oct 2019 08:25:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC3D04A5D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 06:27:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xcGe9U6w8gul for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 06:27:31 -0400 (EDT)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 448564A53F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 06:27:31 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
 FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e07417; MF=shannon.zhao@linux.alibaba.com;
 NM=1; PH=DS; RN=8; SR=0; TI=SMTPD_---0Tg33X4V_1571912836; 
Received: from localhost(mailfrom:shannon.zhao@linux.alibaba.com
 fp:SMTPD_---0Tg33X4V_1571912836) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 24 Oct 2019 18:27:27 +0800
From: Shannon Zhao <shannon.zhao@linux.alibaba.com>
To: kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, christoffer.dall@arm.com
Subject: [PATCH RFC 0/7] Support KVM being compiled as a kernel module on arm64
Date: Thu, 24 Oct 2019 18:27:43 +0800
Message-Id: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Mailman-Approved-At: Thu, 24 Oct 2019 08:25:09 -0400
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Curently KVM ARM64 doesn't support to compile as a kernel module. It's
useful to compile KVM as a module. For example, it could reload kvm
without rebooting host machine.

This patchset support this feature while there are some limitations
to be solved. But I just send it out as RFC to get more suggestion and
comments.

The patchset could be fetched from:
https://github.com/shannonz88/linux/tree/kvm_module

Curently it only supports for VHE system due to the hyp code section
address variables like __hyp_text_start. Also it can't call
kvm_update_va_mask when loading kvm module and kernel panic with below
errors. So I make kern_hyp_va into a nop funtion.

Unable to handle kernel read from unreadable memory at virtual address
ffff800008eda580
Mem abort info:
  ESR = 0x8600000f
  EC = 0x21: IABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000000ca1000
[ffff800008eda580] pgd=00002057fffff003, pud=00002057ffffe003,
pmd=0000003799c63003, pte=00e800575140f713
Internal error: Oops: 8600000f [#1] SMP
CPU: 25 PID: 9307 Comm: insmod Tainted: G            E     5.4.0-rc4+ #39
pstate: 60400009 (nZCv daif +PAN -UAO)
pc : 0xffff800008eda580
lr : __apply_alternatives+0x130/0x26c
sp : ffff800022fdbb00
x29: ffff800022fdbb00 x28: ffff800008f105bc
x27: 0000000000000005 x26: ffff800008f105bc
x25: ffff800010b67dd0 x24: ffff800008eda580
x23: ffff800010f21eff x22: ffff800022fdbba8
x21: 0000000000000001 x20: ffff800022fdbba0
x19: ffff800008f232bc x18: ffff00379b437d90
x17: 0000000000000000 x16: 0000000000009000
x15: 0000000000000008 x14: 0000000000000a00
x13: 0000000000000001 x12: ffff205768d18010
x11: 00000000ffffffff x10: 0000000000aaaaaa
x9 : ffff8000109b0cc8 x8 : 0000000000000001
x7 : ffff00579f9391a8 x6 : 0000000000000001
x5 : 0000000000000000 x4 : 0000000000000000
x3 : 0000000000000005 x2 : ffff800008f105bc
x1 : ffff800008f105bc x0 : ffff800008f232bc
Call trace:
 0xffff800008eda580
 apply_alternatives_module+0x64/0x84
 module_finalize+0xa8/0xd0
 load_module+0xf88/0x1b34
 __do_sys_finit_module+0xd0/0xfc
 __arm64_sys_finit_module+0x28/0x34
 el0_svc_handler+0x120/0x1d4
 el0_svc+0x8/0xc
Code: d34b2c00 17ffffea d4000002 d65f03c0 (a9ba7bfd)
---[ end trace 6de8ebc787a78157 ]---
Kernel panic - not syncing: Fatal exception
SMP: stopping secondary CPUs

Shannon Zhao (7):
  KVM: ARM: call hyp_cpu_pm_exit on correct fail and exit path
  KVM: arch_timer: Fix resource leak on error path
  KVM: vgic: make vgic parameters work well for module
  KVM: vgic: Add hyp uninitialize function
  KVM: arch_timer: Add hyp uninitialize function
  KVM: arm/arm64: Move target table register into register table init
    function
  KVM: ARM: Support KVM being compiled as a kernel module

 arch/arm/kvm/coproc.c                |  3 ++
 arch/arm/kvm/coproc.h                |  3 ++
 arch/arm/kvm/coproc_a15.c            |  4 +--
 arch/arm/kvm/coproc_a7.c             |  4 +--
 arch/arm64/include/asm/cache.h       | 16 ++---------
 arch/arm64/include/asm/cpufeature.h  | 11 +-------
 arch/arm64/include/asm/fpsimd.h      |  6 +---
 arch/arm64/include/asm/kvm_host.h    |  3 --
 arch/arm64/include/asm/kvm_mmu.h     |  4 +++
 arch/arm64/include/asm/perf_event.h  |  2 ++
 arch/arm64/kernel/acpi.c             |  1 +
 arch/arm64/kernel/asm-offsets.c      |  2 +-
 arch/arm64/kernel/cpu_errata.c       | 15 +++++++++-
 arch/arm64/kernel/cpufeature.c       |  2 ++
 arch/arm64/kernel/cpuinfo.c          | 16 +++++++++++
 arch/arm64/kernel/entry-fpsimd.S     |  2 ++
 arch/arm64/kernel/entry.S            |  1 +
 arch/arm64/kernel/fpsimd.c           | 11 ++++++++
 arch/arm64/kernel/head.S             |  1 +
 arch/arm64/kernel/hibernate.c        |  6 ++++
 arch/arm64/kernel/hyp-stub.S         |  1 +
 arch/arm64/kernel/insn.c             |  2 ++
 arch/arm64/kernel/perf_event.c       | 19 +++++++++++--
 arch/arm64/kernel/probes/kprobes.c   |  2 ++
 arch/arm64/kernel/smp.c              |  1 +
 arch/arm64/kernel/traps.c            |  2 ++
 arch/arm64/kvm/Kconfig               | 19 ++++++++++---
 arch/arm64/kvm/Makefile              | 53 ++++++++++++++++++++----------------
 arch/arm64/kvm/hyp/Makefile          | 22 +++++++--------
 arch/arm64/kvm/sys_regs.c            |  1 +
 arch/arm64/kvm/sys_regs.h            |  2 ++
 arch/arm64/kvm/sys_regs_generic_v8.c |  5 +---
 arch/arm64/kvm/va_layout.c           |  7 ++++-
 arch/arm64/mm/cache.S                |  2 ++
 arch/arm64/mm/hugetlbpage.c          |  2 ++
 arch/arm64/mm/mmu.c                  |  4 +++
 drivers/clocksource/arm_arch_timer.c |  1 +
 drivers/irqchip/irq-gic-common.c     |  1 +
 drivers/irqchip/irq-gic-v4.c         |  8 ++++++
 include/kvm/arm_arch_timer.h         |  1 +
 include/kvm/arm_vgic.h               |  1 +
 include/linux/interrupt.h            |  6 +---
 kernel/irq/manage.c                  |  6 ++++
 mm/pgtable-generic.c                 |  1 +
 virt/kvm/arm/arch_timer.c            | 19 +++++++++++--
 virt/kvm/arm/arm.c                   | 41 ++++++++++++++++++++++++++--
 virt/kvm/arm/mmu.c                   |  4 +++
 virt/kvm/arm/vgic/vgic-init.c        |  7 +++++
 virt/kvm/arm/vgic/vgic-v3.c          |  7 +++++
 49 files changed, 264 insertions(+), 96 deletions(-)

-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
