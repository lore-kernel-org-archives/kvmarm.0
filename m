Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF2BC28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ACBD4A014;
	Wed, 26 Jan 2022 12:30:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8DlSj7byfcdd; Wed, 26 Jan 2022 12:30:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F6049EF0;
	Wed, 26 Jan 2022 12:30:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5960440B80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K28t6eq6wp4r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:23 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0951840B78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:22 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9584DB81F83;
 Wed, 26 Jan 2022 17:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A640C340E3;
 Wed, 26 Jan 2022 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218220;
 bh=pWY8dXRqISyPMpXIUIg/1ZSCdi0mhgFpF9BPw5qS6og=;
 h=From:To:Cc:Subject:Date:From;
 b=U1XnwyrLyXDPT//AZt9PCThDvtK2xGE9oqOh1MiLmFcGnYPllVj5Xc4Z2/ujXaTT7
 4fvNlp5YxPKIzJf+FMaZVsA5jyERhYVHV0JMx4n+ecAY+dirGzPXDb5zoPOdU52sen
 kzRqa49W7pPW86Rm+IB/QEg5xZqU11Q+S/w4aBe+PRAvC9ZgqeisClk2xyvzrmv7N1
 Jg+vo+UIpo0/p5RySXDMr3PwT7iJnnECKgtYrbnqEErAgTSpqAa8G3+viq6bOU3seC
 74/c75jF5U/mMQoBMz/+Hms6jXUl5HbyXmkhgGGExuNXv7DvftLuodf+vf0uLTNf+S
 a1tut6N0407dA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 00/12] arm64: implement read-only page tables
Date: Wed, 26 Jan 2022 18:29:59 +0100
Message-Id: <20220126173011.3476262-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3236; h=from:subject;
 bh=pWY8dXRqISyPMpXIUIg/1ZSCdi0mhgFpF9BPw5qS6og=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YULht9E74L+zZTJTFFoCawdjRMmCdtZ4IAnm71U
 fV10y1eJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFCwAKCRDDTyI5ktmPJNFTC/
 0V/JLHp/pLWgfXzMdscielk702MIPXv5P67aangziUlBHvgp/05Wxx65qFDbqXB2/vPOqNzVgFfWab
 cWNhO6fAjUINbg9T/5fPfaobv41zpQJD59prgP700vizYNi7XaqnVmXbwO1rIEsuREl841ib/7XeHK
 5MLh7Hqp/40l6m7tWYP8C7rZDOUTD34KKwZGHiy3VNPLXTdluOIBhUJUVr9YXN+BhslSPbH1//lfWH
 EMsqGI+9u3JyJfEFt2d5lPksfcxMT8GoPnc5wSPK7ZZKC+fNvmob3Kr9pVpJC8eK2s5nYlC+B4oHbr
 PcVbo9dEFc1jY3RX4mtrOGQkafyGm6j1Fnvv3fwg5p6US+L0wv3fKUQ9/w62z7UzavpXf/K+t4X0tt
 i1tT4IwDC2w9j+u+INppZJv7qJjEgBfwPwcJ/MsKJLGcKrK5j17WnQk1XJXJGhg0Ip225B7crFlziW
 NqsamI68x3zHZPXaZuG7LeOVLCW2CIVg9jgyfYlCjJT/w=
X-Developer-Key: i=ardb@kernel.org; a=openpgp;
 fpr=F43D03328115A198C90016883D200E9CA6329909
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-hardening@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

This RFC series implements support for mapping all user and kernel page
tables read-only in the linear map, and using a special fixmap slot to
make any modifications.

The purpose is to prevent page tables from being manipulated
inadvertently, which is becoming more and more important on arm64, as
many new hardening features such as BTI and MTE are controlled via
attributes in the page tables.

This series is only half of the work that is underway to implement this
in terms of hypervisor services rather than fixmap pokes, as this will
allow the hypervisor to remove all write permissions from pages used as
page tables. This work is being done in the context of the pKVM project,
which defines a clear boundary between the hypervisor executing at EL2,
and the [untrusted] host running at EL1. In this context, managing the
host's page tables at HYP level should increase the robustness of the
entire system substantially.

This series is posted separately for discussion, as it introduces the
changes that are necessary to route all page table updates via a small
set of helpers, allowing us to choose between unprotected, fixmap or HYP
protection straight-forwardly.

The pKVM specific changes will be posted as a followup series.

Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>

Ard Biesheuvel (12):
  asm-generic/pgalloc: allow arch to override PMD alloc/free routines
  arm64: mm: add helpers to remap page tables read-only/read-write
  arm64: mm: use a fixmap slot for user page table modifications
  arm64: mm: remap PGD pages r/o in the linear region after allocation
  arm64: mm: remap PUD pages r/o in linear region
  arm64: mm: remap PMD pages r/o in linear region
  arm64: mm: remap PTE level user page tables r/o in the linear region
  arm64: mm: remap kernel PTE level page tables r/o in the linear region
  arm64: mm: remap kernel page tables read-only at end of init
  mm: add default definition of p4d_index()
  arm64: efi: use set_pte_at() not set_pte() in order to pass mm pointer
  arm64: hugetlb: use set_pte_at() not set_pte() to provide mm pointer

 arch/arm64/Kconfig               |  11 ++
 arch/arm64/include/asm/fixmap.h  |   1 +
 arch/arm64/include/asm/pgalloc.h |  49 ++++++++-
 arch/arm64/include/asm/pgtable.h |  82 +++++++++++---
 arch/arm64/include/asm/tlb.h     |   6 +
 arch/arm64/kernel/efi.c          |   2 +-
 arch/arm64/mm/Makefile           |   2 +
 arch/arm64/mm/fault.c            |   8 +-
 arch/arm64/mm/hugetlbpage.c      |   4 +-
 arch/arm64/mm/mmu.c              | 115 +++++++++++++++++++-
 arch/arm64/mm/pageattr.c         |  14 +++
 arch/arm64/mm/pgd.c              |  25 +++--
 arch/arm64/mm/ro_page_tables.c   | 100 +++++++++++++++++
 include/asm-generic/pgalloc.h    |  13 ++-
 include/linux/pgtable.h          |   8 ++
 15 files changed, 405 insertions(+), 35 deletions(-)
 create mode 100644 arch/arm64/mm/ro_page_tables.c


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
