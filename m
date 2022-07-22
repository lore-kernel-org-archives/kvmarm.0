Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC67C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 17:05:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5314D1A1;
	Fri, 22 Jul 2022 13:05:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UHf1I5q9XAfh; Fri, 22 Jul 2022 13:05:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2EDE4D156;
	Fri, 22 Jul 2022 13:05:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7644D133
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:05:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDkOFQKs1CbU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 13:05:12 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C02F4D03B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:05:12 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id
 v16-20020a17090abb9000b001f25244c65dso1318011pjr.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EIQBR56/tJcNBR6OGH/TjjSrDbmF7UtKhywW9Hj0CUY=;
 b=ll/TN7RHrz3zet8Hb5kr/a0vsvXTl01rS1ijTZRx2gc/6AX7XZlUe25dJ6dyifZAkn
 Vf+suc2mp2Mo7OU49OfAsxW+vzt+VLB/Lhh9jZPHlIOKu6rw5SPMA7lwqcPFOSix23E3
 xidaleqnYRsuyCOp0BBfofLrx0Wp2Js/csk6eMH+TEQ6i1btJRgPyQnM/sYt9CtFFiX0
 9evjlfYud7iuG5e94WVg8HHecjPuvNJTUmjMIxGyFSb6Inhmlbfw5D9ZoAvyRw8qTdiN
 yv0FzfY0EXkrrnsH4/IYTex0Y7BMikYCyw6oHvxJX4k1BdSI043dkl2mssfj9SP1XxAZ
 TP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EIQBR56/tJcNBR6OGH/TjjSrDbmF7UtKhywW9Hj0CUY=;
 b=g5iJPmOtULun8MATzdisEyGr3253CyyonsfrL5v32qHWJFfIIC61AEjUvq/FsS24Wj
 bdvN6NnztHGkd8Em9K+4WcYAvpkyYsYty2sMcnEAd6luPMJZi/xoPJjAMqAu7nVHtx4a
 rullAh5wXa3S5WnTrNFFkqxBVnKB5jpRXRxk8tImbxVOd9pq3xMMp6iyvYhjScMxk+WB
 TH/wIe1zOh4Xls5fQnZ/p9Egez7L2PVAtrAbexgY5DTKeWY5VQniFPTax6DeGk1Gb5O7
 0Ajau6Y/50sJ3A/g3p589vZQ0Dnw33ZP/CjKdDII4XEjgc3jVuIwth1cpirXbrXF3fRq
 WtVQ==
X-Gm-Message-State: AJIora9fooZPDl+LJY/AJ9WqiZIDkL8/CtPOCGMmXp7ebtOT2eWN7pb6
 KF9VFQNmWTk3hnU8e5rqeHS02A==
X-Google-Smtp-Source: AGRyM1vFlk9DkZd9UBK770fSURYjd+N7HQh0/nEt16WDmaIMu9aOsXfJxkshzokJ7v3u6ERX5w/m5A==
X-Received: by 2002:a17:902:da85:b0:16c:bf2e:fac7 with SMTP id
 j5-20020a170902da8500b0016cbf2efac7mr784455plx.166.1658509510994; 
 Fri, 22 Jul 2022 10:05:10 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:200:2571:bd04:907d:d32f])
 by smtp.gmail.com with ESMTPSA id
 f26-20020a631f1a000000b00415320bc31dsm3632484pgf.32.2022.07.22.10.05.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Jul 2022 10:05:10 -0700 (PDT)
Date: Fri, 22 Jul 2022 10:04:59 -0700
From: Peter Collingbourne <pcc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/7] mm: Add PG_arch_3 page flag
Message-ID: <YtrYu54WBHJa4YMP@google.com>
References: <20220722015034.809663-1-pcc@google.com>
 <20220722015034.809663-4-pcc@google.com>
 <87leslxmf1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87leslxmf1.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Fri, Jul 22, 2022 at 03:16:34PM +0100, Marc Zyngier wrote:
> On Fri, 22 Jul 2022 02:50:29 +0100,
> Peter Collingbourne <pcc@google.com> wrote:
> > 
> > As with PG_arch_2, this flag is only allowed on 64-bit architectures due
> > to the shortage of bits available. It will be used by the arm64 MTE code
> > in subsequent patches.
> > 
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Steven Price <steven.price@arm.com>
> > [catalin.marinas@arm.com: added flag preserving in __split_huge_page_tail()]
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  fs/proc/page.c                 | 1 +
> >  include/linux/page-flags.h     | 1 +
> >  include/trace/events/mmflags.h | 7 ++++---
> >  mm/huge_memory.c               | 1 +
> >  4 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/proc/page.c b/fs/proc/page.c
> > index a2873a617ae8..438b8aa7249d 100644
> > --- a/fs/proc/page.c
> > +++ b/fs/proc/page.c
> > @@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
> >  	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
> >  #ifdef CONFIG_64BIT
> >  	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
> > +	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_3);
> 
> Are PG_arch_2 and PG_arch_3 supposed to share the same user bit in
> /proc/kpageflags? This seems odd.

No, that was an oversight, thanks for the catch. I will fix it up like
so in v3.

Peter

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 438b8aa7249d..0129aa3cfb7a 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,7 +220,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_64BIT
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
-	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_3);
+	u |= kpf_copy_bit(k, KPF_ARCH_3,	PG_arch_3);
 #endif
 
 	return u;
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index eee1877a354e..859f4b0c1b2b 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -18,5 +18,6 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 381dcc00cb62..364373f5bba0 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -79,6 +79,7 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 /* [47-] take some arbitrary free slots for expanding overloaded flags
  * not part of kernel API
@@ -138,6 +139,7 @@ static const char * const page_flag_names[] = {
 	[KPF_UNCACHED]		= "c:uncached",
 	[KPF_SOFTDIRTY]		= "f:softdirty",
 	[KPF_ARCH_2]		= "H:arch_2",
+	[KPF_ARCH_3]		= "H:arch_3",
 
 	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
 	[KPF_READAHEAD]		= "I:readahead",
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
