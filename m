Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F81C19F35
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 08:26:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B29F961103
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 08:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B29F961103
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A844B080;
	Mon,  2 Aug 2021 04:26:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@shutemov-name.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dy6z5OzFW8Gq; Mon,  2 Aug 2021 04:26:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B834A523;
	Mon,  2 Aug 2021 04:26:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D15154A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 04:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uc5AVi+XGEAk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 04:26:20 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B3724A126
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 04:26:20 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id x8so18938344lfe.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 01:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=shutemov-name.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kz70ZSfw0gF/+Eh/YJkSF3/zSs7YIozU2Kk7aShS8/8=;
 b=J5xAHujnzexFvkkaoEUTfQIY3kAfoX3t0epqE64o+NeLDaqffL2McvcjUUxw2ktQY7
 hq1E6o9GZ/ylYc3n6snTUXx8AnF+RKXZ9lAKxmM5HDmf83z/7B6YEyTs//qYuxKAa6dZ
 bEJH6KNuLOf1wy7fYK22finBSH/SV7Ds+XeVfwiJJACQJHs4ERQg3gYHwNRm9X+mRL6Y
 /0tozTp22V26v4/JQKKeDj8ZFY+Pb4bX1pYHZVSE3r8Ok43kmkwDlsDXUrYG7jwC4Uba
 JzJUSDBcpFT+S/hNuHDbo/L8+V7thyZzJPIdqFsRp3PCMt71hTrIDtdQNTjKXjZFvyvp
 a0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kz70ZSfw0gF/+Eh/YJkSF3/zSs7YIozU2Kk7aShS8/8=;
 b=j1slaQgTKHhUvDhQKYj2X6cjt8mKHf+y+wEBuJBMpeKnDH8f46w8OFmvmq4r/Z2QJ1
 exY5/cTrgwp3uWc9BLu6WTagEV/fTxorNB6OO6wYWd1A2St1xTdjLgZWmHMXKHPkTM50
 KF7vTnFiVSu494GcE2O3PzZWwBNKUooWP0dRmwW9307ynkvtC6TadfDSwxDsfMlyMV9m
 6CFDRRGQN5uDgyS/q1S5aJE3nVnfLoRuTa3CCZ23HLuP3YLhptRG/aLQfZVJMLcPRGAi
 pgfKpLnT8seRHp93nlnjPCDz5Wt0ngH4GzqOjH2c9ZuRD+b5bMVn68AV36fc672icqfo
 x6HQ==
X-Gm-Message-State: AOAM530El3IwGUrs4E6PCUjGJ8B2ZY4jNKpnu0z4EX733aGcs2/g2lst
 J9yqcrxhgh849kgYfNB4RudXfA==
X-Google-Smtp-Source: ABdhPJw4L1rfWJyd67FPpqtde+HLzdTeW90cWbvOk2oF2MTjUInXvrFZCt9sc56KfGp6ReXUQE5Rzw==
X-Received: by 2002:a05:6512:1689:: with SMTP id
 bu9mr4154164lfb.147.1627892779032; 
 Mon, 02 Aug 2021 01:26:19 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
 by smtp.gmail.com with ESMTPSA id r11sm840514ljp.135.2021.08.02.01.26.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 Aug 2021 01:26:18 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
 id 067C3102B6D; Mon,  2 Aug 2021 11:26:22 +0300 (+03)
Date: Mon, 2 Aug 2021 11:26:21 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v2] memblock: make memblock_find_in_range method private
Message-ID: <20210802082621.xfbrdg2c6glwz3oq@box.shutemov.name>
References: <20210802063737.22733-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210802063737.22733-1-rppt@kernel.org>
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
 Paul Walmsley <paul.walmsley@sifive.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
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

On Mon, Aug 02, 2021 at 09:37:37AM +0300, Mike Rapoport wrote:
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

Looks good to me:

Acked-by: Kirill A. Shutemov <kirill.shtuemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
