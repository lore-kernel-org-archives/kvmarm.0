Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D53361972
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204252; cv=none; b=TCCEdFuGw9kUEcTDSrNye2WiCTIUTMXklkbVlxzOS3HNJisWKDzECnyZXKIDJ50YOiU99NEkho2O6iQKPJbuyCJL2Df0vaALlhsh4CY0ZVpkw0q3ydkPhK2FjW2AlsNiC5luiu7ERxynhNlIojVt+dtJcuc5E0UBZ4GBzx4HHfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204252; c=relaxed/simple;
	bh=DrKqvPN9dcIUKE5GULTEUmn87/y2ID4zJ4wY5XNZeJE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=atYNMm8TfyZTpqCCH7kWpMxkyicAOOy7POBkBqp+7pq18UxOmQgJsc929jZ6U2R/SNCHWFtfzIIdVazDlB7eomddhoqO1zG6rReJJI8yevFukaMMRaRmwtAHQZT/QrtusCpMQkufzRwVcfZE8GuygkhWV3QtTv4zW+h76vyQD5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nvydepUY; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nvydepUY"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DrKqvPN9dcIUKE5GULTEUmn87/y2ID4zJ4wY5XNZeJE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204247; v=1; x=1788809047;
 b=nvydepUY4asrjBfjwWubvhvNegtpn2l8kLrKqVRhLhsBgIp56raWNsatwm9IwLnLtJ2GP8XW
 xCwcWy8xiGrT7cQmn18CTkrrDMFFhWKeCFZxyCKZS7VJ/lIaE5NvpfLsTzogIBPZgQtYpq3qIHj
 Kk7Qv499O6yfEIIG8weIYpPM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 89b251068cf902bc;
	Mon, 31 Aug 2026 19:24:07 +0000
X-Mizu-Trace-ID: 89b251068cf902bc
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool 0/5] Fix diagnostics and capability probes for protected VMs
Date: Mon, 31 Aug 2026 20:24:01 +0100
Message-Id: <20260831192406.1341841-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

These are the kvmtool changes that go with the pKVM series confining a
protected VM's vCPU state to EL2 [1].

That series stops the host reading a protected vCPU's registers once it
has run, and stops it setting the PVTIME attribute. kvmtool dies on
both. Its arm64 register-dump helpers call die() when KVM_GET_ONE_REG
fails, which turns a diagnostic into a VMM abort.
kvm_cpu__setup_pvtime() runs into the new -EPERM and fails vCPU init.

The PVTIME failure is a probe on the wrong fd. kvmtool asks the global
/dev/kvm fd whether steal-time is available, and that fd advertises it
for a protected VM, which cannot use it.
The last patch fixes the same wrong-fd probe for the counter offset,
where "lkvm run --protected --counter-offset" already fails on Linux
7.3-rc1, without the kernel series.
The same conversion went in for the vCPU feature probes in July [2].

Patches 2 and 3 are not specific to protected VMs. They fix the
exit-reason table on the same panic path as patch 1. The lookup ran off
the end of it, and the table had stopped naming anything KVM added after
KVM_EXIT_INTERNAL_ERROR, which on arm64 includes KVM_EXIT_SYSTEM_EVENT
and KVM_EXIT_ARM_NISV.

Patch 1's path needs a protected VM that is already running: "lkvm debug
-d" against one kills the VMM without this series, and prints the errno
with it.

Based on kvmtool master (f67bc0b).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260831163421.272420-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260714110329.12113-1-fuad.tabba@linux.dev/

Fuad Tabba (5):
  arm64: Do not abort on register-dump failures
  kvm: Bound-check the exit-reason string lookup
  kvm: Name every exit reason the UAPI header defines
  arm64: Query steal-time support on the VM fd
  arm64: Query counter-offset support on the VM fd

 arm64/kvm-cpu.c   | 36 ++++++++++++++++++++++++------------
 arm64/kvm.c       |  2 +-
 arm64/pvtime.c    |  4 ++--
 builtin-run.c     |  2 +-
 include/kvm/kvm.h |  2 +-
 kvm.c             | 37 ++++++++++++++++++++++++++++++++++---
 6 files changed, 63 insertions(+), 20 deletions(-)


base-commit: f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9
-- 
2.39.5

