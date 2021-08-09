Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89640C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 19:06:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF23461040
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 19:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF23461040
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC8849DE7;
	Mon,  9 Aug 2021 15:06:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MBuKXBsLHfoQ; Mon,  9 Aug 2021 15:06:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A33D4B0D6;
	Mon,  9 Aug 2021 15:06:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9F6449F6C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 15:06:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0eAlXusZ75AL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 15:06:44 -0400 (EDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com
 [209.85.210.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93CBC49DE7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 15:06:44 -0400 (EDT)
Received: by mail-ot1-f45.google.com with SMTP id
 d10-20020a9d4f0a0000b02904f51c5004e3so14780462otl.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 12:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cpWtdrg0Pds7qmeMB9y3OlMrvJ16ctKZqCW37RmKfMg=;
 b=lwHvyTKVOPwrS8cZe0zzXXK67hgOLK/AZZuO980UcdbVuZJ18j9rNLCJh3yj4cGBNg
 VYtO1NG5n2C+tA+URW3LJCSxr1Be50oIFR54bqyCuyPwSgCQsXJTmpwjchulTCkHj2q/
 CiENbdhDANNeHSMs+zKn0v/5IAPN1ZMPLzRi4btIuH4XLvKc+2Dj2qAWIFlgCTbjG8dK
 ZumfTSen0MVhXfEyU7glmAZng0YuitppixTN04WkOipG2qpwIwY319FPXi37+J5L170y
 94bRfvbC66KgAvr+pJb7KKDHSBxLm42bQlS1p/jUJJJewfD2ULzDGE2sCReFCnhlI7GB
 sVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to;
 bh=cpWtdrg0Pds7qmeMB9y3OlMrvJ16ctKZqCW37RmKfMg=;
 b=Vo+KyS+EyNI5LvmEdsfRBi7hyVR8rxjxP0QWI8rfh7pcS81H+MjnzRyWLf8kAIfVbi
 CP70cJ/akCuEHqb6/nQ3jGLm/64gXc8Xk59cYwATSgKZkLOU2naOiYC7hvNYmOCf5pmh
 g60A1CXLPKIsH0vg/DJchKXjvRBO5cT21RJrMwIZRl0Q5BgDKJNzXn9GnJ8c9d1dWnV3
 GIbc1rTQxdN/dWNkoIVeijvydMad0OVya0aHPt1nBN8MZ2MsfoeM1vsEY2hViec5G4+F
 kw7KDc/2LBEXpp7fzr8Cx53r0YIlOwpoeMjGmQxk2B2gqjeIezhX7fsjgNbQcs/i8kZ5
 CFoA==
X-Gm-Message-State: AOAM5339jKOKCokZCld21pLSOdoUKcBjfPWrUnEQlecfmsr+Hj/EtsRC
 k6kJ66eajRreuxe4gPEDyKw=
X-Google-Smtp-Source: ABdhPJw51Q8sQoLTe3KKK8sm3DKSF8kf3hu75pVBEYkMMXwbqFHQuKE5VwtKRwWjLFH1mriDS5/pzg==
X-Received: by 2002:a05:6830:1f59:: with SMTP id
 u25mr18262623oth.321.1628536003855; 
 Mon, 09 Aug 2021 12:06:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 be15sm3464317oib.18.2021.08.09.12.06.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Aug 2021 12:06:43 -0700 (PDT)
Date: Mon, 9 Aug 2021 12:06:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v3] memblock: make memblock_find_in_range method private
Message-ID: <20210809190641.GA1176508@roeck-us.net>
References: <20210803064218.6611-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210803064218.6611-1-rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-riscv@lists.infradead.org, Frank Rowand <frowand.list@gmail.com>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 x86@kernel.org, Russell King <linux@armlinux.org.uk>,
 Mike Rapoport <rppt@linux.ibm.com>, linux-acpi@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 devicetree@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
 Will Deacon <will@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Rob Herring <robh+dt@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Andy Lutomirski <luto@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
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

On Tue, Aug 03, 2021 at 09:42:18AM +0300, Mike Rapoport wrote:
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

I see a number of crashes in next-20210806 when booting x86 images from efi.

[    0.000000] efi: EFI v2.70 by EDK II
[    0.000000] efi: SMBIOS=0x1fbcc000 ACPI=0x1fbfa000 ACPI 2.0=0x1fbfa014 MEMATTR=0x1f25f018
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.000000] last_pfn = 0x1ff50 max_arch_pfn = 0x400000000
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.000000] Kernel panic - not syncing: alloc_low_pages: can not alloc memory
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.14.0-rc4-next-20210806 #1
[    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.000000] Call Trace:
[    0.000000]  ? dump_stack_lvl+0x57/0x7d
[    0.000000]  ? panic+0xfc/0x2c6
[    0.000000]  ? alloc_low_pages+0x117/0x156
[    0.000000]  ? phys_pmd_init+0x234/0x342
[    0.000000]  ? phys_pud_init+0x171/0x337
[    0.000000]  ? __kernel_physical_mapping_init+0xec/0x276
[    0.000000]  ? init_memory_mapping+0x1ea/0x2aa
[    0.000000]  ? init_range_memory_mapping+0xdf/0x12e
[    0.000000]  ? init_mem_mapping+0x1e9/0x26f
[    0.000000]  ? setup_arch+0x5ff/0xb6d
[    0.000000]  ? start_kernel+0x71/0x6b4
[    0.000000]  ? secondary_startup_64_no_verify+0xc2/0xcb

Bisect points to this patch. Reverting it fixes the problem. Key seems to
be the amount of memory configured in qemu; the problem is not seen if
there is 1G or more of memory, but it is seen with all test boots with
512M or 256M of memory. It is also seen with almost all 32-bit efi boots.

The problem is not seen when booting without efi.

Guenter

---
Bisect log:

# bad: [da454ebf578f6c542ba9f5b3ddb98db3ede109c1] Add linux-next specific files for 20210809
# good: [36a21d51725af2ce0700c6ebcb6b9594aac658a6] Linux 5.14-rc5
git bisect start 'HEAD' 'v5.14-rc5'
# good: [d22fda64bea5f33000e31e5b7e4ba876bca37436] Merge remote-tracking branch 'crypto/master'
git bisect good d22fda64bea5f33000e31e5b7e4ba876bca37436
# good: [b084da3a98fad27a39ed5ca64106b86df0417851] Merge remote-tracking branch 'irqchip/irq/irqchip-next'
git bisect good b084da3a98fad27a39ed5ca64106b86df0417851
# good: [a5383d1f57190a33c6afc25c62b9907d84ba2bc6] Merge remote-tracking branch 'staging/staging-next'
git bisect good a5383d1f57190a33c6afc25c62b9907d84ba2bc6
# good: [a439da3e6abeb054f4e6b0d37814e762b7340196] Merge remote-tracking branch 'seccomp/for-next/seccomp'
git bisect good a439da3e6abeb054f4e6b0d37814e762b7340196
# bad: [9801f3c0890c7b992b45a5c2afcb16c5cdc8388e] mm/idle_page_tracking: Make PG_idle reusable
git bisect bad 9801f3c0890c7b992b45a5c2afcb16c5cdc8388e
# good: [b4f7f4a9b542836683308d48ffdd18471c6f3e76] lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix
git bisect good b4f7f4a9b542836683308d48ffdd18471c6f3e76
# good: [e30842a48c36f094271eea0984bb861b49c49c87] mm/vmscan: add 'else' to remove check_pending label
git bisect good e30842a48c36f094271eea0984bb861b49c49c87
# bad: [65300b20a21214fb2043419d4e5da1d9947c6e15] mm/madvise: add MADV_WILLNEED to process_madvise()
git bisect bad 65300b20a21214fb2043419d4e5da1d9947c6e15
# bad: [7348da7a8c244d1a755bc5838b04cb9b1b6ee06c] memblock: make memblock_find_in_range method private
git bisect bad 7348da7a8c244d1a755bc5838b04cb9b1b6ee06c
# good: [98f8c467fe2ba8e553b450b2a3294d69f1f2027f] mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix
git bisect good 98f8c467fe2ba8e553b450b2a3294d69f1f2027f
# good: [760ded422ebe4f8899905b752d8378c44f2a78f3] mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy
git bisect good 760ded422ebe4f8899905b752d8378c44f2a78f3
# good: [fbfa0492d9639b67119d3d94b7a6a3f85e064260] mm/mempolicy: advertise new MPOL_PREFERRED_MANY
git bisect good fbfa0492d9639b67119d3d94b7a6a3f85e064260
# good: [ff6d5759a871883aeea38309fb16d91666179328] mm/mempolicy: unify the create() func for bind/interleave/prefer-many policies
git bisect good ff6d5759a871883aeea38309fb16d91666179328
# first bad commit: [7348da7a8c244d1a755bc5838b04cb9b1b6ee06c] memblock: make memblock_find_in_range method private
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
