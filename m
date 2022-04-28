Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF44C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 17:45:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7359549EBE;
	Thu, 28 Apr 2022 13:45:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AAyIeSFjsT9n; Thu, 28 Apr 2022 13:45:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 660D24B10C;
	Thu, 28 Apr 2022 13:45:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D95BA49F28
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 13:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XA+GZAboTaFL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 13:45:52 -0400 (EDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7002949E1E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 13:45:52 -0400 (EDT)
Received: by mail-io1-f49.google.com with SMTP id 125so7261310iov.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 10:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rYkNgcXPFsN0AZS9Gdq00dTATV9XxHLGEv5CoQhxVgg=;
 b=hzMsoV3D0yJ0Unlop+rpTzklIYhRnWH7ICsyDlDVFdcLE9BIlkNP73Wm+4oXNVuiB8
 plJ8GuyyvEt6ZXQbKxd1muNdZzq09naSLXrKhBTeETybRl01LEoPVDN68ktaYn9l0zsi
 yoyQHHe1wradnURDVY6+HNGMMkWazXFQRLoTut+ycpEUb54hblTXLdMjgsITAqGXMdx5
 3Y8FH49L78ooub0KNRfiN5ke97caoBhhHNMCuuOQncS7BD/mI1wPI6p0qS0ilNo4Z01F
 oWlrVzL07peONZe79tOTcyd8YQZsNWlwpVd98T9TgcHmPXq0Kuzw5WruzgVtu+f1uIoR
 iH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rYkNgcXPFsN0AZS9Gdq00dTATV9XxHLGEv5CoQhxVgg=;
 b=NbsME7MI1xCtmjZsCFZ3Q2ziYyo0+zoyPpiJMpbA0+TqM702aZxnG8Ar00NC8bvQSe
 xjB5KLSQns/+QKCX+7Nsd1IitMmxkKDHuupOo7ONnnfwxSz75jbkyJRALzD+DriW7DBU
 yskoFdjfG/0/WJf0OumOdXbVr5S4t/pnqbmzn5mVvDohMFp9N95zwwihz+An0Y9+vF87
 80xqD6PaMTunhXTEhiAasCSOobrz1iCxlIVxXjsDdZ/rV0WJrpk+soxfPLvs162feomV
 wnJDUFbNoC9Y0ZS1a5NvQt45Fsthm8WB1dNSmnqBR5dm9ubO7G9jrbUDzlbttdRJlMyj
 fmsA==
X-Gm-Message-State: AOAM533sU75vR438qcqqtkIY4tgCbvER0jI6nTS9JU3AU0rMT5I6UVIE
 Z+c56TCoTnwknzO346XIPj43hQ==
X-Google-Smtp-Source: ABdhPJx/sYY/i7dOFt3+PaiV4KhSUz6X+tqTVPbVDr2OqPDCjEE/yaOau4YnhKo+v4gz0/SI7nAHRg==
X-Received: by 2002:a02:cc48:0:b0:32b:14:4186 with SMTP id
 i8-20020a02cc48000000b0032b00144186mr6761137jaq.189.1651167951414; 
 Thu, 28 Apr 2022 10:45:51 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f15-20020a056e020c6f00b002cbc9935527sm269640ilj.83.2022.04.28.10.45.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Apr 2022 10:45:50 -0700 (PDT)
Date: Thu, 28 Apr 2022 17:45:47 +0000
From: Oliver Upton <oupton@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Message-ID: <YmrSywSU1ezREvT6@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com>
 <YmegoB/fBkfwaE5z@google.com>
 <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>,
 Atish Patra <atishp@atishpatra.org>, cgroups@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, linux-mips@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvm-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Tue, Apr 26, 2022 at 12:27:57PM -0700, Yosry Ahmed wrote:
> > What page tables do we want to account? KVM on ARM manages several page
> > tables.
> >
> > For regular KVM, the host kernel manages allocations for the hyp stage 1
> > tables in addition to the stage 2 tables used for a particular VM. The
> > former is system overhead whereas the latter could be attributed to a
> > guest VM.
> 
> Honestly I would love to get your input on this. The main motivation
> here is to give users insights on the kernel memory usage on their
> system (or in a cgroup). We currently have NR_PAGETABLE stats for
> normal kernel page tables (allocated using
> __pte_alloc_one()/pte_free()), this shows up in /proc/meminfo,
> /path/to/cgroup/memory.stat, and node stats. The idea is to add
> NR_SECONDARY_PAGETABLE that should include the memory used for kvm
> pagetables, which should be a separate category (no overlap). What
> gets included or not depends on the semantics of KVM and what exactly
> falls under the category of secondary pagetables from the user's pov.
> 
> Currently it looks like s2 page table allocations get accounted to
> kmem of memory control groups (GFP_KERNEL_ACCOUNT), while hyp page
> table allocations do not (GFP_KERNEL). So we could either follow this
> and only account s2 page table allocations in the stats, or make hyp
> allocations use GFP_KERNEL_ACCOUNT as well and add them to the stats.
> Let me know what you think.

I think it is reasonable to just focus on stage 2 table allocations and
ignore all else. As Marc pointed out it isn't workable in other
contexts anyway (pKVM), and keeps the patch tidy too.

GFP_KERNEL_ACCOUNT for hyp allocations wouldn't make sense, as it is
done at init to build out the system page tables for EL2.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
