Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E80DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 16:11:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE63D4B22A;
	Thu, 16 Jun 2022 12:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CZ1Tm3Z-8ot1; Thu, 16 Jun 2022 12:11:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DAF4B25D;
	Thu, 16 Jun 2022 12:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E224B22A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 12:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-Xyu14irSda for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 12:11:50 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D2944B1C4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 12:11:50 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 v7-20020a056402348700b004351fb80abaso1557956edc.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 09:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=53//JyvI45ZhwbUaM5uI0kPNiTUxNDMI3+JeoQXZ8o4=;
 b=YgpKtggqxPMZqdyyNy5TZOKq4v/ZgAECTvJ9MUecexDW7VvvT/w53ZVEE1L8h1ljgA
 rF8olp37wfa9wFih1WFnBZ+HI8k6qsV9QtM1zFqWO3fBuZJlzjg8ZeDcS7Jwk7KKFaxr
 tDvZ5SBedshvVjQaM7oU+wvmyR7dkRmB/QEv25Kzy6Y+rq6LTQcmP8wLISO8rL3ZPbJI
 L3ILQ6/mB3poFIegOBnB9wehUIGiEb6OU5/TRDQMCn+r9I4AoNOwcwYhiYz+D1uYCkME
 HyB/56mgBp1v1JZ5bxZUgyX4IgUMrqHgDuWztE2VIsjq3Xfqig80uGG0Pkubud9kzSKT
 z/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=53//JyvI45ZhwbUaM5uI0kPNiTUxNDMI3+JeoQXZ8o4=;
 b=Zcy8bK+l3r7LOhSfeF9ND89q/GccE1TuggnTu0bE3ydr3rXb9yBVPR7mAWnBKFFKmf
 /vjgENOYja3YAZziJqu8CEG5BP/jn3Pe1CJFYKESaeNf8Pm5f2oLeOb5Ais0w1WsmRKr
 /aeXu+Z2RcJp9F7RqAs8MfY1q5TjMHU42sKbU0ZZ4X9OAd/m0crlQx8c7lh0Bg+LWLlV
 lJ+0v9LhcAj8iuyZ8tt2FA9K1zmXXUQdKrvUgmafp/0/kNL1qcUqpKNtOPOG8svIghLg
 YF6+XBLIJB/RE1C/YAG6Co587RbSIdxtt6Y/zlMM5OMAc60C47orcyjRJ8ACwK6QLl14
 sobA==
X-Gm-Message-State: AJIora8+UuLuxquArrUKwV68MQ78t5uftbzLzCEy/Y7kLFwN+V/On3uX
 bn7sPo8EXO+rWuCf9kkn/L2y6zObMLzS
X-Google-Smtp-Source: AGRyM1shbif9S6Mz6+yjtQNX+yEPvvRmNV8IC5CdS/u7h9fH5JA9mbef03f62M/UBtxMzozBWEg/+vCZQHch
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:5d08:b0:6ff:8ed:db63 with SMTP id
 g8-20020a1709065d0800b006ff08eddb63mr5100969ejt.408.1655395908950; Thu, 16
 Jun 2022 09:11:48 -0700 (PDT)
Date: Thu, 16 Jun 2022 16:11:34 +0000
Message-Id: <20220616161135.3997786-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] KVM: arm64: Prevent kmemleak from accessing pKVM memory
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
 linux-kernel@vger.kernel.org
Cc: kernel-team@android.com, Mike Rapoport <rppt@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Commit a7259df76702 ("memblock: make memblock_find_in_range method
private") changed the API using which memory is reserved for the pKVM
hypervisor. However, it seems that memblock_phys_alloc() differs
from the original API in terms of kmemleak semantics -- the old one
excluded the reserved regions from kmemleak scans when the new one
doesn't seem to. Unfortunately, when protected KVM is enabled, all
kernel accesses to pKVM-private memory result in a fatal exception,
which can now happen because of kmemleak scans:

$ echo scan > /sys/kernel/debug/kmemleak
[   34.991354] kvm [304]: nVHE hyp BUG at: [<ffff800008fa3750>] __kvm_nvhe_handle_host_mem_abort+0x270/0x290!
[   34.991580] kvm [304]: Hyp Offset: 0xfffe8be807e00000
[   34.991813] Kernel panic - not syncing: HYP panic:
[   34.991813] PS:600003c9 PC:0000f418011a3750 ESR:00000000f2000800
[   34.991813] FAR:ffff000439200000 HPFAR:0000000004792000 PAR:0000000000000000
[   34.991813] VCPU:0000000000000000
[   34.993660] CPU: 0 PID: 304 Comm: bash Not tainted 5.19.0-rc2 #102
[   34.994059] Hardware name: linux,dummy-virt (DT)
[   34.994452] Call trace:
[   34.994641]  dump_backtrace.part.0+0xcc/0xe0
[   34.994932]  show_stack+0x18/0x6c
[   34.995094]  dump_stack_lvl+0x68/0x84
[   34.995276]  dump_stack+0x18/0x34
[   34.995484]  panic+0x16c/0x354
[   34.995673]  __hyp_pgtable_total_pages+0x0/0x60
[   34.995933]  scan_block+0x74/0x12c
[   34.996129]  scan_gray_list+0xd8/0x19c
[   34.996332]  kmemleak_scan+0x2c8/0x580
[   34.996535]  kmemleak_write+0x340/0x4a0
[   34.996744]  full_proxy_write+0x60/0xbc
[   34.996967]  vfs_write+0xc4/0x2b0
[   34.997136]  ksys_write+0x68/0xf4
[   34.997311]  __arm64_sys_write+0x20/0x2c
[   34.997532]  invoke_syscall+0x48/0x114
[   34.997779]  el0_svc_common.constprop.0+0x44/0xec
[   34.998029]  do_el0_svc+0x2c/0xc0
[   34.998205]  el0_svc+0x2c/0x84
[   34.998421]  el0t_64_sync_handler+0xf4/0x100
[   34.998653]  el0t_64_sync+0x18c/0x190
[   34.999252] SMP: stopping secondary CPUs
[   35.000034] Kernel Offset: disabled
[   35.000261] CPU features: 0x800,00007831,00001086
[   35.000642] Memory Limit: none
[   35.001329] ---[ end Kernel panic - not syncing: HYP panic:
[   35.001329] PS:600003c9 PC:0000f418011a3750 ESR:00000000f2000800
[   35.001329] FAR:ffff000439200000 HPFAR:0000000004792000 PAR:0000000000000000
[   35.001329] VCPU:0000000000000000 ]---

Fix this by explicitly excluding the hypervisor's memory pool from
kmemleak like we already do for the hyp BSS.

Cc: Mike Rapoport <rppt@kernel.org>
Fixes: a7259df76702 ("memblock: make memblock_find_in_range method private")
Signed-off-by: Quentin Perret <qperret@google.com>
---
An alternative could be to actually exclude memory allocated using
memblock_phys_alloc_range() from kmemleak scans to revert back to the
old behaviour. But nobody else has complained about this AFAIK, so I'd
be inclined to keep this local to pKVM. No strong opinion.
---
 arch/arm64/kvm/arm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 400bb0fe2745..28765bd22efb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2110,11 +2110,11 @@ static int finalize_hyp_mode(void)
 		return 0;
 
 	/*
-	 * Exclude HYP BSS from kmemleak so that it doesn't get peeked
-	 * at, which would end badly once the section is inaccessible.
-	 * None of other sections should ever be introspected.
+	 * Exclude HYP sections from kmemleak so that they don't get peeked
+	 * at, which would end badly once inaccessible.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
+	kmemleak_free_part(__va(hyp_mem_base), hyp_mem_size);
 	return pkvm_drop_host_privileges();
 }
 
-- 
2.36.1.476.g0c4daa206d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
