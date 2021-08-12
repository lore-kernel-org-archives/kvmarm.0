Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B33C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 06:59:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA3286103E
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 06:59:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AA3286103E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FC6D4A19F;
	Thu, 12 Aug 2021 02:59:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KG7MJy+XE5yD; Thu, 12 Aug 2021 02:59:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2875749FB7;
	Thu, 12 Aug 2021 02:59:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C15E49F6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HeTcEs9ESeRo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 02:59:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02EA2407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:59:21 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F24AA601FD;
 Thu, 12 Aug 2021 06:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628751560;
 bh=YFMZTccB6r2mQUHMX3e0DwUnA6yRsuYhah5UQoES2qE=;
 h=From:To:Cc:Subject:Date:From;
 b=gqDKL6oFAWPfl+qrvP4ICkIiJuTj0zB5TnIo9v2jyftPMcesd9mebeUTOENH/WF4R
 PBfqCrnjEHgRHt0O1dyCISfhSxmredSB9XxmW1Ns603miZy037IV2h2edGI81ldDzY
 NqgDtvGktsfZul6wLbLg1Tgj9dX32EjsY3bdIRoj49WsQpGFdC5ZMg6zFcqteaJDkt
 0uruPXpJRVzqwUCwDkAf6p3Y7H3f580IbJRG6NdyUWhatq3Gxbuq0XxYssVS/sjhOA
 hChRFrKVbGxFTcFqXajSbSnyBDOxjDPh7zY8Sk+z4WzAiR3GMcSU98BQ+MjV7C6G/L
 np4VR2Z/7QAFw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 0/2] memblock: make memblock_find_in_range method private
Date: Thu, 12 Aug 2021 09:59:05 +0300
Message-Id: <20210812065907.20046-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, Mike Rapoport <rppt@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Guenter Roeck <linux@roeck-us.net>, Len Brown <lenb@kernel.org>,
 devicetree@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Rob Herring <robh+dt@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Andy Lutomirski <luto@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Mike Rapoport <rppt@kernel.org>
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

From: Mike Rapoport <rppt@linux.ibm.com>

Hi,

This is v4 of "memblock: make memblock_find_in_range method private" patch
that essentially replaces memblock_find_in_range() + memblock_reserve()
calls with equivalent calls to memblock_phys_alloc() and prevents usage of
memblock_find_in_range() outside memblock itself.

The patch uncovered an issue with top down memory mapping on x86 and this
version has a preparation patch that addresses this issue.

Guenter, I didn't add your Tested-by because the patch that addresses the
crashes differs from the one you've tested.

v4: 
* Add patch that prevents the crashes reported by Guenter Roeck on x86/i386
  on QEMU with 256M or 512M of memory and EFI boot enabled.
* Add Acked-by and Reviewed-by, thanks everybidy!

v3: https://lore.kernel.org/lkml/20210803064218.6611-1-rppt@kernel.org
* simplify check for exact crash kerenl allocation on arm, per Rob
* make crash_max unsigned long long on arm64, per Rob

v2: https://lore.kernel.org/lkml/20210802063737.22733-1-rppt@kernel.org
* don't change error message in arm::reserve_crashkernel(), per Russell

v1: https://lore.kernel.org/lkml/20210730104039.7047-1-rppt@kernel.org

Mike Rapoport (2):
  x86/mm: memory_map_top_down: remove spurious reservation of upper 2M
  memblock: make memblock_find_in_range method private

 arch/arm/kernel/setup.c           | 20 +++++---------
 arch/arm64/kvm/hyp/reserved_mem.c |  9 +++----
 arch/arm64/mm/init.c              | 36 ++++++++-----------------
 arch/mips/kernel/setup.c          | 14 +++++-----
 arch/riscv/mm/init.c              | 44 ++++++++++---------------------
 arch/s390/kernel/setup.c          | 10 ++++---
 arch/x86/kernel/aperture_64.c     |  5 ++--
 arch/x86/mm/init.c                | 27 +++++++------------
 arch/x86/mm/numa.c                |  5 ++--
 arch/x86/mm/numa_emulation.c      |  5 ++--
 arch/x86/realmode/init.c          |  2 +-
 drivers/acpi/tables.c             |  5 ++--
 drivers/base/arch_numa.c          |  5 +---
 drivers/of/of_reserved_mem.c      | 12 ++++++---
 include/linux/memblock.h          |  2 --
 mm/memblock.c                     |  2 +-
 16 files changed, 76 insertions(+), 127 deletions(-)


base-commit: ff1176468d368232b684f75e82563369208bc371
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
