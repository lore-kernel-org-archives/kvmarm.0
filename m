Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176B21EB35
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713164067; cv=none; b=tDzhBRTeZUdiIr/VuVRy5Hz8sxJ9GuaEIfwlScbK1wFOaPspalxeW4Axj/ZcVCENSbcUbV31bKRXQtn8l66gqE/iWoUh8b6h5SwJ11cGhKq/nKqIPIV3x21apjXYCgV0aeFSq2Zp2Vyz2Hot+K29Xze7/mWRepgylyxUXarghPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713164067; c=relaxed/simple;
	bh=0RnzDr/VZ8xCydjZEczq565X/Ecb9JlD2VkomYimNoU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l/b3ognQ5/wNwS3cLY5pP6V81bEyFC6FrIzjF8giKymxXvgkZcuQpCQ9057roEMmes6HZainMtqnytj33enRY7iB8ztkpnoVu4QmfyOiIYZsR41bOtzdwz8qTq7Gsbf7ON4c1kcnafF8DhYDS29bPHR+9kHKXyd5p2gDT9eOgtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VHyVw32NlzXlJt;
	Mon, 15 Apr 2024 14:51:04 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id F33521400CD;
	Mon, 15 Apr 2024 14:54:19 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 15 Apr
 2024 14:54:18 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <mark.rutland@arm.com>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>, <ericchancf@google.com>,
	<kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <akpm@linux-foundation.org>,
	<bhe@redhat.com>, <horms@kernel.org>, <mhiramat@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <shahuang@redhat.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <reijiw@google.com>,
	<akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v3 0/8] Rework the DAIF mask, unmask and track API
Date: Mon, 15 Apr 2024 06:47:50 +0000
Message-ID: <20240415064758.3250209-1-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

[1] https://lore.kernel.org/all/20240407081733.3231820-1-ruanjinjie@huawei.com/
[2] https://lore.kernel.org/linux-arm-kernel/Y4sH5qX5bK9xfEBp@lpieralisi/

v3->v2:
1. Squash two commits that address two minor issues into Mark Brown's
   origin patch for detecting FEAT_NMI.
2. Add one patch resolves the kprobe reenter panic while testing
   FEAT_NMI on QEMU.

v2->v1:
Add SoB tags following the origin author's SoBs.

Liao Chang (5):
  arm64: daifflags: Add logical exception masks covering DAIF + PMR +
    ALLINT
  arm64: Unify exception masking at entry and exit of exception
  arm64: Deprecate old local_daif_{mask,save,restore}
  irqchip/gic-v3: Improve the maintainability of NMI masking in GIC
    driver
  arm64: kprobe: Keep NMI maskabled while kprobe is stepping xol

Mark Brown (3):
  arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
  arm64/cpufeature: Detect PE support for FEAT_NMI
  arm64/nmi: Add Kconfig for NMI

 arch/arm64/Kconfig                   |  17 ++
 arch/arm64/include/asm/cpufeature.h  |   6 +
 arch/arm64/include/asm/daifflags.h   | 298 ++++++++++++++++++++++-----
 arch/arm64/include/asm/nmi.h         |  27 +++
 arch/arm64/include/asm/sysreg.h      |   2 +
 arch/arm64/include/uapi/asm/ptrace.h |   1 +
 arch/arm64/kernel/acpi.c             |  10 +-
 arch/arm64/kernel/cpufeature.c       |  58 +++++-
 arch/arm64/kernel/debug-monitors.c   |   7 +-
 arch/arm64/kernel/entry-common.c     |  96 +++++----
 arch/arm64/kernel/entry.S            |   2 -
 arch/arm64/kernel/hibernate.c        |   6 +-
 arch/arm64/kernel/irq.c              |   2 +-
 arch/arm64/kernel/machine_kexec.c    |   2 +-
 arch/arm64/kernel/probes/kprobes.c   |   4 +-
 arch/arm64/kernel/setup.c            |   2 +-
 arch/arm64/kernel/smp.c              |   6 +-
 arch/arm64/kernel/suspend.c          |   6 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c      |   4 +-
 arch/arm64/mm/mmu.c                  |   6 +-
 arch/arm64/tools/cpucaps             |   2 +
 drivers/irqchip/irq-gic-v3.c         |   6 +-
 23 files changed, 442 insertions(+), 134 deletions(-)
 create mode 100644 arch/arm64/include/asm/nmi.h

-- 
2.34.1

