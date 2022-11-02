Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E56CC43217
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:49:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4A94B992;
	Wed,  2 Nov 2022 12:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bW4+zolq4cGI; Wed,  2 Nov 2022 12:49:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66ED94B9A3;
	Wed,  2 Nov 2022 12:49:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0456A4B964
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5BsCiobdDQN3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:14:19 -0400 (EDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE5234B253
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:19 -0400 (EDT)
Received: by mail-wm1-f44.google.com with SMTP id
 l16-20020a05600c4f1000b003c6c0d2a445so1603037wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=BpDb3eA5T10BTKaEzNInMNBCCpx0zoiS14ubIM6NfnE=;
 b=gxlExpzzLGUfRn7vXJgTOm6x12MJszdK4eaWr1U0uyx/Ia3OEtiHhBV0CRsqZQuOf7
 8FyVMf41cOXuV4VEH6Hi7xAeFixEBeDAKVxMCLX48Dfa8Y78007LDZb3jotS41UMNcjg
 uZtFKHfHwrFm2IJWpnRwHmR82bSrSxiULmNT3HcjrCBIslON7u5tHL3xqB2u1cfO1m6p
 mL2ncoRZkdUOZ8f8T7pAdr7IzySCixciPSys5wcnTx6uAZO7f+IivY6HKrWpYFM29n9I
 wVX5GumCVuGQhmkbuC765tg/KvzRrp5PMZ2io7iWDs0E1uKUbb2DQb1HV59vUMZGAf+c
 j/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=BpDb3eA5T10BTKaEzNInMNBCCpx0zoiS14ubIM6NfnE=;
 b=R0Ij2KWpLkQV8bMHmtAJfzCYp3T2wYYDJCJnXrjSVoIsH4OIaJ+ZEKk98c6TDRgbd2
 hUXgwXblM9MOxiGeZqT0zCdkec290/7yApBm1ws2KrV4Y2i32kUiZwllBpDLATKmcZqJ
 PeA5RTOVZyvp6iUT0PiENZBJnhE294wsKClE30Cz+tNBl6sRhs1z71PcjxyA8ONisrDA
 fvDxFET6rOLLc/WR6loNjyvHwFR4Mo7tdNhunW+8OVf4+MyNiJfe7K4dZ+7dde6Jq2Wl
 oG9OEM0aPUDMqYeX9vuV004YlMj4eIAfCyGYgTKnZIUSlKsZRlipof8nxsa7K5uG1Spo
 95fQ==
X-Gm-Message-State: ACrzQf3UipRbNKzmxY2N/Ug5APxCmF+xlzoraH0U9lQX9tnAEm730qku
 QeDHfgs0Ek27ljWzrDZVyx9kxg==
X-Google-Smtp-Source: AMsMyM7HGMltrxCTrV7aqNFSsqNsIgzADe5S3oOs1MHc1WYnXT/2QUlJHefFW892SSjNmfT1q7IMoA==
X-Received: by 2002:a05:600c:a48:b0:3b9:af1f:1b38 with SMTP id
 c8-20020a05600c0a4800b003b9af1f1b38mr16514126wmq.185.1667405658449; 
 Wed, 02 Nov 2022 09:14:18 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:6a08:9b26:ab04:7065])
 by smtp.gmail.com with ESMTPSA id
 m17-20020a5d56d1000000b0022cc6b8df5esm13230923wrw.7.2022.11.02.09.14.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:14:17 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Subject: [RFC 0/6] KVM: arm64: implement vcpu_is_preempted check
Date: Wed,  2 Nov 2022 16:13:34 +0000
Message-Id: <20221102161340.2982090-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 02 Nov 2022 12:49:29 -0400
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

This patchset adds support for vcpu_is_preempted in arm64, which allows the guest
to check if a vcpu was scheduled out, which is useful to know incase it was
holding a lock. vcpu_is_preempted can be used to improve
performance in locking (see owner_on_cpu usage in mutex_spin_on_owner,
mutex_can_spin_on_owner, rtmutex_spin_on_owner and osq_lock) and scheduling
(see available_idle_cpu which is used in several places in kernel/sched/fair.c
for e.g. in wake_affine to determine which CPU can run soonest):

This patchset shows improvement on overcommitted hosts (vCPUs > pCPUS), as waiting
for preempted vCPUs reduces performance.

This patchset is inspired from the para_steal_clock implementation and from the
work originally done by Zengruan Ye:
https://lore.kernel.org/linux-arm-kernel/20191226135833.1052-1-yezengruan@huawei.com/.
(I have kept the original file author and patch sign-offs, hope thats ok).

All the results in the below experiments are done on an aws r6g.metal instance
which has 64 pCPUs.

The following table shows the index results of UnixBench running on a 128 vCPU VM
with (6.0.0+vcpu_is_preempted) and without (6.0.0 base) the patchset.
TestName                                6.0.0 base  6.0.0+vcpu_is_preempted    % improvement for vcpu_is_preempted
Dhrystone 2 using register variables    187761      191274.7                   1.871368389
Double-Precision Whetstone              96743.6     98414.4                    1.727039308
Execl Throughput                        689.3       10426                      1412.548963
File Copy 1024 bufsize 2000 maxblocks   549.5       3165                       475.978162
File Copy 256 bufsize 500 maxblocks     400.7       2084.7                     420.2645371
File Copy 4096 bufsize 8000 maxblocks   894.3       5003.2                     459.4543218
Pipe Throughput                         76819.5     78601.5                    2.319723508
Pipe-based Context Switching            3444.8      13414.5                    289.4130283
Process Creation                        301.1       293.4                      -2.557289937
Shell Scripts (1 concurrent)            1248.1      28300.6                    2167.494592
Shell Scripts (8 concurrent)            781.2       26222.3                    3256.669227
System Call Overhead                    3426        3729.4                     8.855808523

System Benchmarks Index Score           3053        11534                      277.7923354

This shows a 277% overall improvement using these patches.

The biggest improvement is in the shell scripts benchmark, which forks a lot of processes.
This acquires rwsem lock where a large chunk of time is spent in base 6.0.0 kernel.
This can be seen from one of the callstack of the perf output of the shell
scripts benchmark on 6.0.0 base (pseudo NMI enabled for perf numbers below):
- 33.79% el0_svc
   - 33.43% do_el0_svc
      - 33.43% el0_svc_common.constprop.3
         - 33.30% invoke_syscall
            - 17.27% __arm64_sys_clone
               - 17.27% __do_sys_clone
                  - 17.26% kernel_clone
                     - 16.73% copy_process
                        - 11.91% dup_mm
                           - 11.82% dup_mmap
                              - 9.15% down_write
                                 - 8.87% rwsem_down_write_slowpath
                                    - 8.48% osq_lock

Just under 50% of the total time in the shell script benchmarks ends up being
spent in osq_lock in the base 6.0.0 kernel:
  Children      Self  Command   Shared Object        Symbol
   17.19%    10.71%  sh      [kernel.kallsyms]  [k] osq_lock
    6.17%     4.04%  sort    [kernel.kallsyms]  [k] osq_lock
    4.20%     2.60%  multi.  [kernel.kallsyms]  [k] osq_lock
    3.77%     2.47%  grep    [kernel.kallsyms]  [k] osq_lock
    3.50%     2.24%  expr    [kernel.kallsyms]  [k] osq_lock
    3.41%     2.23%  od      [kernel.kallsyms]  [k] osq_lock
    3.36%     2.15%  rm      [kernel.kallsyms]  [k] osq_lock
    3.28%     2.12%  tee     [kernel.kallsyms]  [k] osq_lock
    3.16%     2.02%  wc      [kernel.kallsyms]  [k] osq_lock
    0.21%     0.13%  looper  [kernel.kallsyms]  [k] osq_lock
    0.01%     0.00%  Run     [kernel.kallsyms]  [k] osq_lock

and this comes down to less than 1% total with 6.0.0+vcpu_is_preempted kernel:
  Children      Self  Command   Shared Object        Symbol
     0.26%     0.21%  sh      [kernel.kallsyms]  [k] osq_lock
     0.10%     0.08%  multi.  [kernel.kallsyms]  [k] osq_lock
     0.04%     0.04%  sort    [kernel.kallsyms]  [k] osq_lock
     0.02%     0.01%  grep    [kernel.kallsyms]  [k] osq_lock
     0.02%     0.02%  od      [kernel.kallsyms]  [k] osq_lock
     0.01%     0.01%  tee     [kernel.kallsyms]  [k] osq_lock
     0.01%     0.00%  expr    [kernel.kallsyms]  [k] osq_lock
     0.01%     0.01%  looper  [kernel.kallsyms]  [k] osq_lock
     0.00%     0.00%  wc      [kernel.kallsyms]  [k] osq_lock
     0.00%     0.00%  rm      [kernel.kallsyms]  [k] osq_lock

To make sure, there is no change in performance when vCPUs < pCPUs, UnixBench
was run on a 32 CPU VM. The kernel with vcpu_is_preempted implemented
performed 0.9% better overall than base kernel, and the individual benchmarks
were within +/-2% improvement over 6.0.0 base.
Hence the patches have no negative affect when vCPUs < pCPUs.


The other method discussed in https://lore.kernel.org/linux-arm-kernel/20191226135833.1052-1-yezengruan@huawei.com/
was pv conditional yield by Marc Zyngier and Will Deacon to reduce vCPU reschedule
if the vCPU will exit immediately.
(https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy).
The patches were ported to 6.0.0 kernel and tested with UnixBench with a 128 vCPU VM:

TestName                                6.0.0 base  6.0.0+pvcy      % improvement for pvcy
Dhrystone 2 using register variables    187761      183128          -2.467498575
Double-Precision Whetstone              96743.6     96645           -0.101918887
Execl Throughput                        689.3       1019.8          47.9471928
File Copy 1024 bufsize 2000 maxblocks   549.5       2029.7          269.3721565
File Copy 256 bufsize 500 maxblocks     400.7       1439.4          259.2213626
File Copy 4096 bufsize 8000 maxblocks   894.3       3434.1          283.9986582
Pipe Throughput                         76819.5     74268.8         -3.320380893
Pipe-based Context Switching            3444.8      5963.3          73.11019508
Process Creation                        301.1       163.2           -45.79873796
Shell Scripts (1 concurrent)            1248.1      1859.7          49.00248378
Shell Scripts (8 concurrent)            781.2       1171            49.89759345
System Call Overhead                    3426        3194.4          -6.760070053

System Benchmarks Index Score           3053        4605            50.83524402

pvcy shows a smaller overall improvement (50%) compared to vcpu_is_preempted (277%).
Host side flamegraph analysis shows that ~60% of the host time when using pvcy
is spent in kvm_handle_wfx, compared with ~1.5% when using vcpu_is_preempted,
hence vcpu_is_preempted shows a larger improvement.

It might be that pvcy can be used in combination with vcpu_is_preempted, but this
series is to start a discussion on vcpu_is_preempted as it shows a much bigger
improvement in performance and its much easier to review vcpu_is_preempted standalone.

The respective QEMU change to test this is at
https://github.com/uarif1/qemu/commit/2da2c2927ae8de8f03f439804a0dad9cf68501b6,
if this patchset looks good to start review, I can send the QEMU change to the
qemu mailing list to start its review as well.

Looking forward to your response!
Thanks,
Usama
 
Usama Arif (6):
  KVM: arm64: Document PV-lock interface
  KVM: arm64: Add SMCCC paravirtualised lock calls
  KVM: arm64: Support pvlock preempted via shared structure
  KVM: arm64: Provide VCPU attributes for PV lock
  KVM: arm64: Support the VCPU preemption check
  KVM: selftests: add tests for PV time specific hypercalls

 Documentation/virt/kvm/arm/hypercalls.rst     |   3 +
 Documentation/virt/kvm/arm/pvlock.rst         |  64 +++++++++
 Documentation/virt/kvm/devices/vcpu.rst       |  23 ++++
 arch/arm64/include/asm/kvm_host.h             |  25 ++++
 arch/arm64/include/asm/paravirt.h             |   2 +
 arch/arm64/include/asm/pvlock-abi.h           |  17 +++
 arch/arm64/include/asm/spinlock.h             |  16 ++-
 arch/arm64/include/uapi/asm/kvm.h             |   3 +
 arch/arm64/kernel/paravirt.c                  | 126 ++++++++++++++++++
 arch/arm64/kernel/setup.c                     |   3 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |   8 ++
 arch/arm64/kvm/guest.c                        |   9 ++
 arch/arm64/kvm/hypercalls.c                   |  36 +++++
 arch/arm64/kvm/pvlock.c                       | 100 ++++++++++++++
 arch/arm64/kvm/pvtime.c                       |  16 ---
 include/linux/arm-smccc.h                     |  13 ++
 include/linux/cpuhotplug.h                    |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/linux/arm-smccc.h               |  13 ++
 .../selftests/kvm/aarch64/hypercalls.c        |   2 +
 22 files changed, 467 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
 create mode 100644 arch/arm64/include/asm/pvlock-abi.h
 create mode 100644 arch/arm64/kvm/pvlock.c

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
