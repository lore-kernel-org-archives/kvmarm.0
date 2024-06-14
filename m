Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A23146A68
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 03:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337146; cv=none; b=CwDeMqGZfwuedAjBJbVug6Bymkz+xqho3NfCvxqAQtAhU1/bmKJTmzSoaXAkpZyHvT+olZ0Yz8AanArnZtODpD05nKIQ7Lk9pcx9rKY6y0NBTFJjwZxlN3at9uDouUVhXJ6/IgfaxMfOGxwqByBLNbSFOIJIsj/UCMdjP2rrK2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337146; c=relaxed/simple;
	bh=c6BiaAOIwgmRfsq/BqFyHr8xtrIVVqtpqRSJvgrqVgI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b8nO8tb+60H7+3lROsgCXlN+jATd0p5439ACFU1P17sC1PVNhLdxVjGqPO0uWvHZZGRbYtMeCsJ/549OsBB2WYtpFoFvwvrPdRA/ch/cN2aR5nqJ+NhoqCGTIvVI5ZXO/uDxCq48i0Kiid3swA6vX/ddZrFBhH3AK3XvZKl7BDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W0lcG3JDfzwSLw;
	Fri, 14 Jun 2024 11:48:14 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 8297B1402C8;
	Fri, 14 Jun 2024 11:52:22 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 14 Jun
 2024 11:52:20 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <ryabinin.a.a@gmail.com>,
	<glider@google.com>, <andreyknvl@gmail.com>, <dvyukov@google.com>,
	<vincenzo.frascino@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<mark.rutland@arm.com>, <lpieralisi@kernel.org>, <tglx@linutronix.de>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<steven.price@arm.com>, <ryan.roberts@arm.com>, <pcc@google.com>,
	<anshuman.khandual@arm.com>, <eric.auger@redhat.com>,
	<miguel.luis@oracle.com>, <shiqiliu@hust.edu.cn>, <quic_jiles@quicinc.com>,
	<rafael@kernel.org>, <sudeep.holla@arm.com>, <dwmw@amazon.co.uk>,
	<joey.gouly@arm.com>, <jeremy.linton@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<swboyd@chromium.org>, <dianders@chromium.org>,
	<shijie@os.amperecomputing.com>, <bhe@redhat.com>,
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <mhiramat@kernel.org>,
	<mcgrof@kernel.org>, <rmk+kernel@armlinux.org.uk>,
	<Jonathan.Cameron@huawei.com>, <takakura@valinux.co.jp>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <tabba@google.com>,
	<kristina.martsenko@arm.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <kvmarm@lists.linux.dev>
Subject: [PATCH v4 00/10] Rework the DAIF mask, unmask and track API
Date: Fri, 14 Jun 2024 03:44:23 +0000
Message-ID: <20240614034433.602622-1-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)

This patch series reworks the DAIF mask, unmask, and track API for the
upcoming FEAT_NMI extension added in Armv8.8.

As platform and virtualization[1] supports for FEAT_NMI is emerging, and
Mark Brown's FEAT_NMI patch series[2] highlighted the need for clean up
the existing hacking style approach about DAIF management code before
adding NMI functionality, furthermore, we discover some subtle bugs
during 'perf' and 'ipi_backtrace' transition from PSEUDO_NMI to
FEAT_NMI, in summary, all of these emphasize the importance of rework.

This series of reworking patches follows the suggestion from Mark
Rutland mentioned in Mark Brown's patchset. In summary, he think the
better way for DAIF manangement look likes as following:

(a) Adding entry-specific helpers to manipulate abstract exception masks
    covering DAIF + PMR + ALLINT. Those need unmask-at-entry and
    mask-at-exit behaviour, and today only need to manage DAIF + PMR.

    It should be possible to do this ahead of ALLINT / NMI support.

(b) Adding new "logical exception mask" helpers that treat DAIF + PMR +
    ALLINT as separate elements. 

This patches cherry-pick a part of Mark Brown' FEAT_NMI series, in order
to pass compilation and basic testing, includes perf and ipi_backtrace.

v4->v3:
General Enhancements
--------------------
Commit messages of [PATCH 04/05/06] have been enriched to outline the
implementation details, motivations and potential effects. This might
improve develper understanding and review efficiency.

Specific Changes
----------------
1. [PATCH 01] new utilize the existing helper maco in sysregs.h to
   generate the "MSR ALLLINT, #Imm1" instruction. Additionally, helper
   names have been renamed to start with msr_pstate_ for better
   discoverability (as suggested by Mark Brown).

2. For [PATCH 04], due to the barrier side-effect of writing to PSTATE
   fields, it is unnecessary to call pmr_sync() in
   __pmr_local_allint_restore(). Add a table in comments to depict the
   relationship between the type of interrupt masking and hardware
   register configuration.

3. For [PATCH 05/06], function names have been revised to better reflect
   their purpose:

   local_errint_enable()       -> local_irq_serror_enable()
   local_errint_disable()      -> local_nmi_serror_disable()
   local_allint_mark_enabled() -> local_irq_mark_enabled()
   local_allint_disable()      -> local_nmi_disable()
   local_errnmi_enable()       -> local_nmi_serror_enable()

4. For [PATCH 07], A bug in local_nmi_enable() has been fixed. The v3
   version is overly complex and included an unnecessary write operation
   to PSTATE.DAIF.

5. [PATCH 09] introduce a slight optimization for NMI handling. Since
   the intermediate step of marking IRQ TO-BE enabled is no longer
   required, dropping PMR before acknowledge PSEUDO_NMI is also
   unnecessary.

6. [PATCH 10] migrates CPU idle contex save/restore operation to the
   newly introduced logical interrupt masking helper functions.

v3->v2:
1. Squash two commits that address two minor issues into Mark Brown's
   origin patch for detecting FEAT_NMI.
2. Add one patch resolves the kprobe reenter panic while testing
   FEAT_NMI on QEMU.

v2->v1:
Add SoB tags following the origin author's SoBs.

[1] https://lore.kernel.org/all/20240407081733.3231820-1-ruanjinjie@huawei.com/
[2] https://lore.kernel.org/linux-arm-kernel/Y4sH5qX5bK9xfEBp@lpieralisi/

Liao Chang (8):
  arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
  arm64: daifflags: Introduce logical interrupt masking
  arm64: Sipmlify exception masking during exception entry and exit
  arm64: Deprecate old local_daif_{mask,save,restore} helper functions
  irqchip/gic-v3: Improve the maintainability of NMI masking in GIC
    driver
  arm64: kprobe: Keep NMI maskabled while kprobe is stepping xol
  arm64: irqchip/gic-v3: Simplify NMI handling in IRQs disabled context
  arm64: Migrate idle context save/restore to logical interrupt masking

Mark Brown (2):
  arm64/cpufeature: Detect PE support for FEAT_NMI
  arm64/nmi: Add Kconfig for NMI

 arch/arm64/Kconfig                   |  17 ++
 arch/arm64/include/asm/cpufeature.h  |   6 +
 arch/arm64/include/asm/cpuidle.h     |  24 +-
 arch/arm64/include/asm/daifflags.h   | 376 +++++++++++++++++++++------
 arch/arm64/include/asm/mte-kasan.h   |   4 +-
 arch/arm64/include/asm/mte.h         |   2 +-
 arch/arm64/include/asm/sysreg.h      |  27 +-
 arch/arm64/include/asm/uaccess.h     |   4 +-
 arch/arm64/include/uapi/asm/ptrace.h |   1 +
 arch/arm64/kernel/acpi.c             |  10 +-
 arch/arm64/kernel/cpufeature.c       |  61 ++++-
 arch/arm64/kernel/debug-monitors.c   |   6 +-
 arch/arm64/kernel/entry-common.c     |  94 +++----
 arch/arm64/kernel/entry.S            |   4 +-
 arch/arm64/kernel/hibernate.c        |   6 +-
 arch/arm64/kernel/idle.c             |   2 +-
 arch/arm64/kernel/irq.c              |   2 +-
 arch/arm64/kernel/machine_kexec.c    |   2 +-
 arch/arm64/kernel/probes/kprobes.c   |   4 +-
 arch/arm64/kernel/proton-pack.c      |   4 +-
 arch/arm64/kernel/setup.c            |   2 +-
 arch/arm64/kernel/smp.c              |   6 +-
 arch/arm64/kernel/suspend.c          |  10 +-
 arch/arm64/kvm/hyp/entry.S           |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c      |   4 +-
 arch/arm64/mm/mmu.c                  |   6 +-
 arch/arm64/tools/cpucaps             |   2 +
 drivers/firmware/psci/psci.c         |   2 +-
 drivers/irqchip/irq-gic-v3.c         |  29 +--
 30 files changed, 490 insertions(+), 235 deletions(-)

-- 
2.34.1

