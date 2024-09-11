Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313E1A38E8
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065393; cv=none; b=MgXupUR2Bgu0zqjdixvjcf/CIjSl5zXeu+R31RKRkJrjddaimpIjKzj+/2QD/47LAne3+p1deU82F4X+9IkuDNjgDmFNNeWo99UwY+QN9wZ/WljJXBvG6m9BE9S/A4nP2z7iJfbBGyMxRhqbyVgLiDP9vR7Vw40StzkQ701u4bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065393; c=relaxed/simple;
	bh=P2Po9VCmI03gZ0twXQyW5372O49f3W9Nb89m5eShghU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r+WExVTrFoxH+qscQfQStqDDn+3tt7WvoPtpxL0nTKtPzZ9hSFWOKSdkD3yUoDlCBREQNHyyedf2B3W5y7HeL8ywsGUyxU7530cMVoXBiDkUMFls62pfx4dmKMU4sFnYQlVlwQ25q7lzk1wv43H/Cm9019sCMc0NtmCSimka4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=bdRSZxCq; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="bdRSZxCq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065392; x=1757601392;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OYjq6pbgVwn9b81T7cFK3VzB+SX95+WNYatfu9MFnys=;
  b=bdRSZxCqD0WYVsMCBvCUst/PgIwV5OapUhsHbaPkeH3FLXksXezY+dtm
   Q5UG4/YsHIpxn5rH0YmIzRgob1Ov6nHvq9itbnpsiqilYCrktUk4meH0P
   STjlAa0lOk2O21z/IMAoR6pUTUY8yUq+KfGM4wMug3/QIfP5CYo156JON
   s=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="329955903"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:35:20 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:6114]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.52:2525] with esmtp (Farcaster)
 id 509ab7d1-9dbf-4d4d-b643-5a7e7b0c884b; Wed, 11 Sep 2024 14:35:18 +0000 (UTC)
X-Farcaster-Flow-ID: 509ab7d1-9dbf-4d4d-b643-5a7e7b0c884b
Received: from EX19D007EUB001.ant.amazon.com (10.252.51.82) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:35:17 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUB001.ant.amazon.com (10.252.51.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:35:17 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:35:14 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, =?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=
	<ptosi@google.com>, Ard Biesheuvel <ardb@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Javier Martinez Canillas <javierm@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, Mark Brown
	<broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Kristina Martsenko
	<kristina.martsenko@arm.com>, Randy Dunlap <rdunlap@infradead.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, "David
 Hildenbrand" <david@redhat.com>, Roman Kagan <rkagan@amazon.de>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 0/7] support for mm-local memory allocations and use it
Date: Wed, 11 Sep 2024 14:33:59 +0000
Message-ID: <20240911143421.85612-1-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In a series posted a few years ago [1], a proposal was put forward to allow the
kernel to allocate memory local to a mm and thus push it out of reach for
current and future speculation-based cross-process attacks.  We still believe
this is a nice thing to have.

However, in the time passed since that post Linux mm has grown quite a few new
goodies, so we'd like to explore possibilities to implement this functionality
with less effort and churn leveraging the now available facilities.

An RFC was posted few months back [2] to show the proof of concept and a simple
test driver.

In this RFC, we're using the same approach of implementing mm-local allocations
piggy-backing on memfd_secret(), using regular user addresses but pinning the
pages and flipping the user/supervisor flag on the respective PTEs to make them
directly accessible from kernel.
In addition to that we are submitting 5 patches to use the secret memory to hide
the vCPU gp-regs and fp-regs on arm64 VHE systems.

The generic drawbacks of using user virtual addresses mentioned in the previous
RFC [2] still hold, in addition to a more specific one:

- While the user virtual addresses allocated for kernel secret memory are not
  directly accessible by userspace as the PTEs restrict that, copy_from_user()
  and copy_to_user() can operate on those ranges, so that e.g. the usermode can
  guess the address and pass it as the target buffer for read(), making the
  kernel overwrite it with the user-controlled content. Effectively making the
  secret memory in the current implementation missing confidentiality and
  integrity guarantees.

In the specific case of vCPU registers, this is fine because the owner process
can read and write to them using KVM IOCTLs anyway. But in the general case this
represents a security concern and needs to be addressed.

A possible way forward for the arch-agnostic implementation is to limit the user
virtual addresses used for kernel to specific range that can be checked against
in copy_from_user() and copy_to_user().

For arch specific implementation, using separate PGD is the way to go.

[1] https://lore.kernel.org/lkml/20190612170834.14855-1-mhillenb@amazon.de/
[2] https://lore.kernel.org/lkml/20240621201501.1059948-1-rkagan@amazon.de/

Fares Mehanna / Roman Kagan (2):
  mseal: expose interface to seal / unseal user memory ranges
  mm/secretmem: implement mm-local kernel allocations

Fares Mehanna (5):
  arm64: KVM: Refactor C-code to access vCPU gp-registers through macros
  KVM: Refactor Assembly-code to access vCPU gp-registers through a
    macro
  arm64: KVM: Allocate vCPU gp-regs dynamically on VHE and
    KERNEL_SECRETMEM enabled systems
  arm64: KVM: Refactor C-code to access vCPU fp-registers through macros
  arm64: KVM: Allocate vCPU fp-regs dynamically on VHE and
    KERNEL_SECRETMEM enabled systems

 arch/arm64/include/asm/kvm_asm.h              |  50 ++--
 arch/arm64/include/asm/kvm_emulate.h          |   2 +-
 arch/arm64/include/asm/kvm_host.h             |  41 +++-
 arch/arm64/kernel/asm-offsets.c               |   1 +
 arch/arm64/kernel/image-vars.h                |   2 +
 arch/arm64/kvm/arm.c                          |  90 +++++++-
 arch/arm64/kvm/fpsimd.c                       |   2 +-
 arch/arm64/kvm/guest.c                        |  14 +-
 arch/arm64/kvm/hyp/entry.S                    |  15 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   6 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |  10 +-
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                |  20 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   4 +-
 arch/arm64/kvm/reset.c                        |   2 +-
 arch/arm64/kvm/va_layout.c                    |  38 ++++
 include/linux/secretmem.h                     |  29 +++
 mm/Kconfig                                    |  10 +
 mm/gup.c                                      |   4 +-
 mm/internal.h                                 |   7 +
 mm/mseal.c                                    |  81 ++++---
 mm/secretmem.c                                | 213 ++++++++++++++++++
 22 files changed, 559 insertions(+), 84 deletions(-)

-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

