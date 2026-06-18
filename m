Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D992D0C64
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797838; cv=none; b=VRA6o3x4/Nd7825BNr8PGGDlrQoOLR+b+HoewA2URYZ9pOrAnwrSVMxqC77mWiBong4TfwqPOSL3VkpnJHfg6zbaGdfP9bDg/NQAEWg5OdM9ZU4dxET5i61Q31YufJYmXQ4EnO++Hy4UYU1X6fHq6uRbROQ2vmRcxUrNeYljv08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797838; c=relaxed/simple;
	bh=bic77GReQxo7E8WOqH1A1QlKgiA3xgkp3/JZUNBdvt4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=agpPT1f49OyIPIGPrfwx6yAH7ZC4BjIoZgINEGS662qf8a7rhx9gVnODS+eXZ6cYge4MqATXnrcL94CRzZpuZ72vvJH1mYT5M4SM8VzJzMOuTsaSvK8+4CaK+QWXd7s53d6qXFUte8jt9RmtULeDPet/tICa1g3hlKu9BN2B6Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D6QgHgmf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D6QgHgmf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DCAB48FF;
	Thu, 18 Jun 2026 08:50:30 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E04273F62B;
	Thu, 18 Jun 2026 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797835; bh=bic77GReQxo7E8WOqH1A1QlKgiA3xgkp3/JZUNBdvt4=;
	h=From:To:Subject:Date:From;
	b=D6QgHgmflPf/2IE+9MJn435CWxfs5XvlbKZuH6kIWNk0/4ovz1pG871jJ+rWBYam/
	 kNIOKrpO4793CBV1QSHnjbv321Yd1fCaKOYg+/A3ekvcISxRU4FHcSeunERpFI/hTB
	 J3au9AIiErjt7l1hHpQv2VAu9KPxV4aZtsjkH7SA=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool v2 0/7] x86 compilation fixes and arm64 PMU improvements
Date: Thu, 18 Jun 2026 16:49:54 +0100
Message-ID: <20260618155001.226266-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

v1 here [1].

v1 was sent to fix this compilation error:

disk/core.c: In function ‘disk_img_name_parser’:
disk/core.c:27:21: error: assignment discards ‘const’ qualifier from pointer target type [-Werror=discarded-qualifiers]
   27 |                 sep = strstr(arg, ":");
      |                     ^

fixed in patches #2 and #3.

Working on v2 found another one:

x86/include/kvm/bios.h:91:43: error: ‘regparm’ attribute ignored [-Werror=attributes]
   91 | extern bioscall void int10_handler(struct biosregs *regs);
      |                                           ^~~~~~~~

which is fixed in patch #1.

The remaining of the patches are there to improve PMU initialisation and
error reporting.

Tested on arm64, with and without hugetlbfs, with and without a PMU. Also
tested on arm64 using scsi-virtio (got it working in v2, I couldn't get
scsi-virtio working for v1, most likely user error).

Tested on x86_64 by booting a VM. Don't have an x86_32 machine to do the
same, but I did cross-compile for x86_32.

Changes in v2:

- Patch #1 ("x86: Define bioscall only in 32-bit mode") is new. The bug
  that it fixes was probably triggered when I updated the gcc compiler.

- pmu__init() is now called from gic__init_gic() (Will).

- die_perror() prints the original errno is vsnprintf() fails (Will).

[1] https://lore.kernel.org/kvm/20260323150221.49256-1-alexandru.elisei@arm.com/

Alexandru Elisei (7):
  x86: Define bioscall only in 32-bit mode
  virtio: Do not modify const strings in virtio_9p_rootdir_parser()
  disk/core: Do not modify const strings in disk_img_name_parser()
  arm64: Initialise the PMU after the GIC
  util: Set exit status to errno in die_perror()
  util: Allow die_perror() to take a variable list of argument
  arm64: Improve KVM_ARM_VCPU_PMU_V3_CTRL diagnostics

 arm64/gic.c              |  9 +++++-
 arm64/include/asm/pmu.h  |  3 ++
 arm64/pmu.c              | 59 ++++++++++++++++++++++++++++------------
 disk/core.c              | 44 ++++++++++++++++++++----------
 include/kvm/disk-image.h |  6 ++--
 include/kvm/util.h       |  2 +-
 util/util.c              | 21 ++++++++++++--
 virtio/9p.c              | 21 +++++++++-----
 x86/include/kvm/bios.h   |  4 +++
 9 files changed, 123 insertions(+), 46 deletions(-)


base-commit: 6c2de8d9531c7e9aad7ac6701e848bedb3f1d3a4
-- 
2.54.0

