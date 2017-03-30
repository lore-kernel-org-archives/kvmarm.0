From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 0/8] arm64: acpi: apei: handle SEI notification type for
 ARMv8
Date: Thu, 30 Mar 2017 18:31:09 +0800
Message-ID: <1490869877-118713-10-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41B2B40C4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3GV9dHzkfv5P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 06:32:51 -0400 (EDT)
Received: from dggrg01-dlp.huawei.com (unknown [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 246C340AE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:46 -0400 (EDT)
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

ARM APEI extension proposal added SEI (asynchronous SError interrupt)
notification type for ARMv8.

Add a new GHES error source handling function for SEI. In firmware
first mode, if an error source's notification type is SEI. Then GHES
could parse and report the detail error information.

In firmware first mode, we could assume:
1) The ghes for sei is a global table, firmware should report one sei at a time.
2) SEI is masked while exception is processing
3) SEI may interrupt while irq handler is running 
4) SEA may interrupt while SEI handler is running

So, the memory area used to transfer hardware error information from
BIOS to Linux can be determined only in NMI, SEI(arm64), IRQ or timer
handler. We add a virtual page for SEI context.

Error Synchronization Barrier (ESB; part of the ARMv8.2 Extensions)
is used to synchronize Unrecoverable errors. That is, containable errors
architecturally consumed by the PE and not silently propagated.

With ESB it is generally possible to isolate an unrecoverable error
between two ESB instructions. So, it's possible to recovery from
unrecoverable errors reported by asynchronous SError interrupt.

Since SEI is asynchronous, a SEI generated on user process may propagate
to another user process via shared memory, which may cause unrecoverable.
We have a idea which only recover sei from user process which has no
writable shared memory.

The idea is still in the discussion, any comments is welcome.

This series is based on Tyler's series "[PATCH V13 00/10] Add UEFI 2.6 and ACPI 6.1 updates
for RAS on ARM64" and the latest mainline.

v3: add ARM processor error information trace event
    add a per-cpu variable to indecate sei is processing
    remove nmi_{enter/exit} protection for ghes_notify_sei()
    reserve a virtual page for processing ghes table in SEI context
    don't always inject vabt for sei
    serprate do_sei from bad_mode
    add esb which make recovery from sei possible
    add an idea to recovery from sei for shared memory process

v2: add kvm guest SEI notification support
    add nmi_{entry, exit} to protect ghes_notify_sei

https://lkml.org/lkml/2017/3/7/962
https://lkml.org/lkml/2017/3/3/189

Wang Xiongfeng (1):
  arm64: exception: check shared writable page in SEI handler

Xie XiuQi (7):
  trace: ras: add ARM processor error information trace event
  acpi: apei: handle SEI notification type for ARMv8
  arm64: apei: add a per-cpu variable to indecate sei is processing
  APEI: GHES: reserve a virtual page for SEI context
  arm64: KVM: add guest SEI support
  arm64: RAS: add ras extension runtime detection
  arm64: exception: handle asynchronous SError interrupt

 arch/arm64/Kconfig                   |  16 +++
 arch/arm64/include/asm/cpucaps.h     |   3 +-
 arch/arm64/include/asm/esr.h         |  14 +++
 arch/arm64/include/asm/sysreg.h      |   2 +
 arch/arm64/include/asm/system_misc.h |   1 +
 arch/arm64/kernel/cpufeature.c       |  11 ++
 arch/arm64/kernel/entry.S            |  70 ++++++++++-
 arch/arm64/kernel/traps.c            | 217 +++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c         |  22 +++-
 drivers/acpi/apei/Kconfig            |  14 +++
 drivers/acpi/apei/ghes.c             | 166 +++++++++++++++++++--------
 include/acpi/ghes.h                  |   3 +
 include/linux/cper.h                 |   5 +
 include/ras/ras_event.h              |  87 ++++++++++++++
 14 files changed, 575 insertions(+), 56 deletions(-)

-- 
1.8.3.1
