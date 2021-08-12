Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E606BC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 14:40:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C2D3610A3
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 14:40:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C2D3610A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0DE04A023;
	Thu, 12 Aug 2021 10:40:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mpq2MwFiH7O8; Thu, 12 Aug 2021 10:40:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8214A1A7;
	Thu, 12 Aug 2021 10:40:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E8749FE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 10:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R1qNNzmrCN1J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 10:40:04 -0400 (EDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com
 [209.85.210.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3E044A19E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 10:40:03 -0400 (EDT)
Received: by mail-ot1-f42.google.com with SMTP id
 r19-20020a0568301353b029050aa53c3801so8020053otq.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 07:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=r138FzswfhiqMSzF9Mi1WWzMp+D+joCtNzgqzk4y5zs=;
 b=qUAxoMOetfP3go+Pm8QClXPFF5RzIrn7qtAZ9qauL8nIaP/Erk+Phvb2oG/bvXPt1b
 bJ3pDkVLZuF+lvj1ulDabRXqFnEZiMWsVgvnISgCTOwv6/pjaywQpBQP/vUsZZOnLm79
 2ZGtUBj+cchU22Q/Ru1j1RP4YD/RYNcIw/EfbYXE5/Tzq0MHhFeP+zM0m6BoGeKMKx77
 ciuid8kGmNgDXSmSvS3B7AlEUOUb+Dzh0vKAGHkIw+ntXaTXpjZVhb0Ie0U/wExZfY4K
 xQlSQqKvKjUPjKTek6cplbxx+UxClNK1EDuClcBqnLPaiRC7MwxW91auK+62FcEif+Wt
 fWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to;
 bh=r138FzswfhiqMSzF9Mi1WWzMp+D+joCtNzgqzk4y5zs=;
 b=hhhpl11Ube/EcDo0cuk7NOWBVUhw4861Kdpa+/lyyHE5XNMpWjOzoj+y79Cp9R17UR
 sWXE/gTfcgeWaS0k90DHvjSLtVYaqr7FvmDPw/qtl1iIWgIBcph3f3QyHMN+KtTseKOg
 5wuZBXy31wMB1g0nVB2ESCx1IhgKwtilGfirYA0fU6xJ+KkSEdxrfuXQRGBGTFesmRNu
 6xMvcCSksftBZnL1jWwi5rbuCc/S2Eu9q2PGuf1xEWHI1VU1rbFEV4xHhL5XoJf3TSfY
 WFCc6F4iOx3wEx313/swY5ilgjGdOxFoHOybOLiE1gEvwGBxzRmH0q/pvsfE6QSmYz/J
 r8tQ==
X-Gm-Message-State: AOAM530UAhSRDg1QhUso3pa/ns/MfAaaJ5ZAQk+La4dKrbCjH6SbT8KM
 3OCbjWhf3NhBsEihMsQosTA=
X-Google-Smtp-Source: ABdhPJzdfdyM1MefYYvc0HYsJrDSHnoFTdzkqqkrevwUl6yHDgKmyrC/e58SVcjQmI8u1ozMKAL/Fw==
X-Received: by 2002:a05:6830:25c4:: with SMTP id
 d4mr3574250otu.270.1628779203271; 
 Thu, 12 Aug 2021 07:40:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id n73sm99075oig.9.2021.08.12.07.40.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 12 Aug 2021 07:40:02 -0700 (PDT)
Date: Thu, 12 Aug 2021 07:40:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v4 0/2] memblock: make memblock_find_in_range method
 private
Message-ID: <20210812144001.GA837928@roeck-us.net>
References: <20210812065907.20046-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210812065907.20046-1-rppt@kernel.org>
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
 Len Brown <lenb@kernel.org>, devicetree@vger.kernel.org,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Rob Herring <robh+dt@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
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

Mike,

On Thu, Aug 12, 2021 at 09:59:05AM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Hi,
> 
> This is v4 of "memblock: make memblock_find_in_range method private" patch
> that essentially replaces memblock_find_in_range() + memblock_reserve()
> calls with equivalent calls to memblock_phys_alloc() and prevents usage of
> memblock_find_in_range() outside memblock itself.
> 
> The patch uncovered an issue with top down memory mapping on x86 and this
> version has a preparation patch that addresses this issue.
> 
> Guenter, I didn't add your Tested-by because the patch that addresses the
> crashes differs from the one you've tested.
> 

Unfortunately I am still seeing crashes.

1G of memory, x86_64:

[    0.000000] efi: EFI v2.70 by EDK II
[    0.000000] efi: SMBIOS=0x3fbcc000 ACPI=0x3fbfa000 ACPI 2.0=0x3fbfa014 MEMATTR=0x3f229018 
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3792.807 MHz processor
[    0.001816] last_pfn = 0x3ff50 max_arch_pfn = 0x400000000
[    0.002595] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.022989] Using GB pages for direct mapping
[    0.025601] Kernel panic - not syncing: alloc_low_pages: can not alloc memory
[    0.025910] CPU: 0 PID: 0 Comm: swapper Not tainted 5.14.0-rc5+ #1
[    0.026133] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.026462] Call Trace:
[    0.026942]  ? dump_stack_lvl+0x57/0x7d
[    0.027475]  ? panic+0x10a/0x2de
[    0.027600]  ? alloc_low_pages+0x117/0x156
[    0.027704]  ? phys_pmd_init+0x234/0x342
[    0.027817]  ? phys_pud_init+0x171/0x337
[    0.027926]  ? __kernel_physical_mapping_init+0xec/0x276
[    0.028062]  ? init_memory_mapping+0x1ea/0x2ca
[    0.028199]  ? init_range_memory_mapping+0xdf/0x12e
[    0.028326]  ? init_mem_mapping+0x1e9/0x261
[    0.028432]  ? setup_arch+0x5ff/0xb6d
[    0.028535]  ? start_kernel+0x71/0x6b4
[    0.028636]  ? secondary_startup_64_no_verify+0xc2/0xcb
[    0.029479] ---[ end Kernel panic - not syncing: alloc_low_pages: can not alloc memory ]---

Complete log:
https://kerneltests.org/builders/qemu-x86_64-testing/builds/67/steps/qemubuildcommand/logs/stdio

x86, default memory size, all efi boots affected:

[    0.025676] BUG: unable to handle page fault for address: cf3c1000
[    0.025932] #PF: supervisor write access in kernel mode
[    0.026022] #PF: error_code(0x0002) - not-present page
[    0.026122] *pde = 00000000
[    0.026308] Oops: 0002 [#1] SMP
[    0.026468] CPU: 0 PID: 0 Comm: swapper Not tainted 5.14.0-rc5+ #1
[    0.026616] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.026848] EIP: alloc_low_pages+0xa0/0x13f
[    0.027355] Code: 00 74 77 a3 cc ba 62 ca 8b 45 f0 8d 90 00 00 0c 00 31 c0 c1 e2 0c 85 f6 74 16 89 d7 b9 00 04 00 00 83 c3 01 81 c2 00 10 00 00 <f3> ab 39 f3 75 ea 8b 45 f0 8d 65 f4 5b 5e c1 e0 0c 5f 5d 2d 00 00
[    0.027802] EAX: 00000000 EBX: 00000001 ECX: 00000400 EDX: cf3c2000
[    0.027903] ESI: 00000001 EDI: cf3c1000 EBP: ca389e28 ESP: ca389e18
[    0.028006] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00200086
[    0.028125] CR0: 80050033 CR2: cf3c1000 CR3: 0a69f000 CR4: 00040690
[    0.028287] Call Trace:
[    0.028603]  one_page_table_init+0x15/0x6d
[    0.028751]  kernel_physical_mapping_init+0xdd/0x19b
[    0.028839]  init_memory_mapping+0x146/0x1f1
[    0.028921]  init_range_memory_mapping+0xfe/0x144
[    0.029001]  init_mem_mapping+0x145/0x185
[    0.029066]  setup_arch+0x5ff/0xa75
[    0.029128]  ? vprintk+0x4c/0x100
[    0.029187]  start_kernel+0x66/0x5ba
[    0.029246]  ? set_intr_gate+0x42/0x55
[    0.029306]  ? early_idt_handler_common+0x44/0x44
[    0.029380]  i386_start_kernel+0x43/0x45
[    0.029441]  startup_32_smp+0x161/0x164
[    0.029567] Modules linked in:
[    0.029776] CR2: 00000000cf3c1000
[    0.030406] random: get_random_bytes called from oops_exit+0x35/0x60 with crng_init=0
[    0.031121] ---[ end trace 544692cd05e387e2 ]---
[    0.031357] EIP: alloc_low_pages+0xa0/0x13f
[    0.031427] Code: 00 74 77 a3 cc ba 62 ca 8b 45 f0 8d 90 00 00 0c 00 31 c0 c1 e2 0c 85 f6 74 16 89 d7 b9 00 04 00 00 83 c3 01 81 c2 00 10 00 00 <f3> ab 39 f3 75 ea 8b 45 f0 8d 65 f4 5b 5e c1 e0 0c 5f 5d 2d 00 00
[    0.031698] EAX: 00000000 EBX: 00000001 ECX: 00000400 EDX: cf3c2000
[    0.031787] ESI: 00000001 EDI: cf3c1000 EBP: ca389e28 ESP: ca389e18
[    0.031876] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00200086
[    0.031972] CR0: 80050033 CR2: cf3c1000 CR3: 0a69f000 CR4: 00040690
[    0.032198] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.032521] ---[ end Kernel panic - not syncing: Attempted to kill the idle
task! ]--

Complete log: 
https://kerneltests.org/builders/qemu-x86-testing/builds/65/steps/qemubuildcommand/logs/stdio

Guenter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
