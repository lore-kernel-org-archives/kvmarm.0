Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D951C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 00:13:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFEBD6103A
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 00:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFEBD6103A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2672449F5F;
	Tue, 17 Aug 2021 20:13:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aK1cZz0O2lyK; Tue, 17 Aug 2021 20:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CC949FB0;
	Tue, 17 Aug 2021 20:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DFEC400D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 20:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RgC2bpq8P7MP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 20:13:10 -0400 (EDT)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com
 [209.85.167.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C933C49FB0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 20:13:10 -0400 (EDT)
Received: by mail-oi1-f179.google.com with SMTP id w6so1843281oiv.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 17:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=++h8bUGhJWF7B6yyYyoh0nKkVdcF8eCL74y7f9GeZ4Y=;
 b=j+pwxsZY86cEa3sBW/eW4KXsX77y4Slc8aZR+xzxaGZCORWJI7O2BqQ/qQvB0ZtoSk
 6HJR3uChQRII4lzKc2jHhzF2EzPQ3uGR00LCYmTzDHa/CTv0Jw8EDuTz6RP3C2sq7sjE
 Q3rvZUeMzyomyxy0cFBZe3y/v1b/VBZV2+5vBp5Tx+q9jj42WI88Br9VrWILoUJxFa4K
 PRp4r3sJtae4ktXmlhOIei8CVUoLVYRj0k24wXX6/KZPbNMX/r5yvJrHclCRAcixxIlY
 LY7DnlQsKfvUpXPDU1zvN5CmxIw4+9QiYG8GNpw9iE55t+4UztQgiLV1KCc/+vh4Or8N
 7/Rg==
X-Gm-Message-State: AOAM533e9Ga34XWnBKyAiL0h7tbUQ58pdrtJ5rtn+cTdzDZ8qOZB4/1l
 8myyHldPBLjjJzok5aMsIQ==
X-Google-Smtp-Source: ABdhPJyJOifM/j6dYvgpX8URevK/gXq/UxE91n+1ytfa41bf6TcZ7UPHLnQ6y0p94fi4QGOLVqhW9w==
X-Received: by 2002:aca:b984:: with SMTP id j126mr4666629oif.32.1629245590250; 
 Tue, 17 Aug 2021 17:13:10 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net.
 [24.155.109.49])
 by smtp.gmail.com with ESMTPSA id k16sm738270oor.16.2021.08.17.17.13.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Aug 2021 17:13:09 -0700 (PDT)
Received: (nullmailer pid 1094241 invoked by uid 1000);
 Wed, 18 Aug 2021 00:13:07 -0000
Date: Tue, 17 Aug 2021 19:13:07 -0500
From: Rob Herring <robh@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v5] memblock: make memblock_find_in_range method private
Message-ID: <YRxQk0Cjj5yzmvBA@robh.at.kernel.org>
References: <20210816122622.30279-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210816122622.30279-1-rppt@kernel.org>
Cc: "Kirill A . Shutemov" <kirill.shtuemov@linux.intel.com>,
 "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
 Nick Kossifidis <mick@ics.forth.gr>, linux-riscv@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
 linux-acpi@vger.kernel.org, Marc Zyngier <maz@kernel.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, Mike Rapoport <rppt@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Guenter Roeck <linux@roeck-us.net>, Len Brown <lenb@kernel.org>,
 devicetree@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <robh+dt@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Mon, 16 Aug 2021 15:26:22 +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> There are a lot of uses of memblock_find_in_range() along with
> memblock_reserve() from the times memblock allocation APIs did not exist.
> 
> memblock_find_in_range() is the very core of memblock allocations, so any
> future changes to its internal behaviour would mandate updates of all the
> users outside memblock.
> 
> Replace the calls to memblock_find_in_range() with an equivalent calls to
> memblock_phys_alloc() and memblock_phys_alloc_range() and make
> memblock_find_in_range() private method of memblock.
> 
> This simplifies the callers, ensures that (unlikely) errors in
> memblock_reserve() are handled and improves maintainability of
> memblock_find_in_range().
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Acked-by: Kirill A. Shutemov <kirill.shtuemov@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	# ACPI
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Acked-by: Nick Kossifidis <mick@ics.forth.gr>			# riscv
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>		# arm64
> ---
> v5:
> * restore the original behaviour on x86 with addition of more elaborate
>   comment; I will address the issue in memory_map_top_down() in a separate
>   series.
> 
> v4: https://lore.kernel.org/lkml/20210812065907.20046-1-rppt@kernel.org
> * Add patch that prevents the crashes reported by Guenter Roeck on x86/i386
>   on QEMU with 256M or 512M of memory and EFI boot enabled.
> * Add Acked-by and Reviewed-by, thanks everybidy!
> 
> v3: https://lore.kernel.org/lkml/20210803064218.6611-1-rppt@kernel.org
> * simplify check for exact crash kerenl allocation on arm, per Rob
> * make crash_max unsigned long long on arm64, per Rob
> 
> v2: https://lore.kernel.org/lkml/20210802063737.22733-1-rppt@kernel.org
> * don't change error message in arm::reserve_crashkernel(), per Russell
> 
> v1: https://lore.kernel.org/lkml/20210730104039.7047-1-rppt@kernel.org
> 
> 
>  arch/arm/kernel/setup.c           | 20 +++++---------
>  arch/arm64/kvm/hyp/reserved_mem.c |  9 +++----
>  arch/arm64/mm/init.c              | 36 ++++++++-----------------
>  arch/mips/kernel/setup.c          | 14 +++++-----
>  arch/riscv/mm/init.c              | 44 ++++++++++---------------------
>  arch/s390/kernel/setup.c          | 10 ++++---
>  arch/x86/kernel/aperture_64.c     |  5 ++--
>  arch/x86/mm/init.c                | 23 ++++++++++------
>  arch/x86/mm/numa.c                |  5 ++--
>  arch/x86/mm/numa_emulation.c      |  5 ++--
>  arch/x86/realmode/init.c          |  2 +-
>  drivers/acpi/tables.c             |  5 ++--
>  drivers/base/arch_numa.c          |  5 +---
>  drivers/of/of_reserved_mem.c      | 12 ++++++---
>  include/linux/memblock.h          |  2 --
>  mm/memblock.c                     |  2 +-
>  16 files changed, 81 insertions(+), 118 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
