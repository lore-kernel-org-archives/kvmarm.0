Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A323C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Apr 2022 17:12:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A784B2C7;
	Mon, 11 Apr 2022 13:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3O+uaR8r1DOk; Mon, 11 Apr 2022 13:12:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F7284B2CC;
	Mon, 11 Apr 2022 13:12:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF424B2C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 13:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fWoif4MmUCKV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2022 13:12:46 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F0614B2C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 13:12:46 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id v12so1449148plv.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 10:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=n3oNrdTxKJ+MoxW65YrXbYK4rkoPX/tBKkcS7/m4AZo=;
 b=Q/wB0ykLqrefjuK5NgTh9FijOKcyQr6sSho/2gt7q5lJEpIRBcsi2KNDdbDxP4CIAy
 /CaznMcwJHRKFtz52MOuzi4LJv+ANXRibnwbiYAUR/210tI+sha1IKB3CKS6iaVinjss
 tF9St7u2e2/msj/pRGJkeKUws6xvNPIU9KSvoAlEXgOixxkAK1fnID8RL3919gMyD4EM
 UDaXah64aS8bBq1xsDXQfsSMA3xigwOf6OvHlru3IFgglxLw7i4banTgHx1jU+V+sWyw
 vIzXenkw34B+2PcbwXoKol2GEZf+s2bA5zuk7K3KfsDLyqGRpyfD/5JFCWFN83ZDYmzj
 ZWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=n3oNrdTxKJ+MoxW65YrXbYK4rkoPX/tBKkcS7/m4AZo=;
 b=n5rhl0cg8X8ASVK+suCZuupWGUbV5AXaVLeQKXKsVw61lZKCJA1sGeb08pGaMI4EcH
 wh4vTPOdXNh1fRdrrPxaCTOpvZvLV1URjf07itBjDme9OvVrfHmSpBdfmZvcEzSYTeCD
 PGMavksGiV0s0C4od7N+qtXwElvxfzv7DmDVeC9D5gJrTr66HayAI0TAtzTBfZgETvvc
 R0nmFNLd+fooH8nzZ+ArykuRGJ/cuLfgcDP/fmm77HLz4FEfKiW2F7pxHCR4oO39UZus
 JdSnfRRPgCEGG4XA1XajIsRsL8TSFz9cQbzctPhtTEHKOrtUX5hSyciBLci99nlygnzc
 5tow==
X-Gm-Message-State: AOAM533ONfSVYUnfb9+iae0qgN7eEKRvhkoRuxWswnXgi86lXVh1mPbz
 v3Uc+gL2/zdycs7n5xFP0MNCwg==
X-Google-Smtp-Source: ABdhPJysztOiNeuzOBqJTTEDK51v1XDCo8Ke61TQgShgEeV4D3ONCQibBTntQNmoN3dGlosPcrn1gQ==
X-Received: by 2002:a17:902:7298:b0:158:3a08:3163 with SMTP id
 d24-20020a170902729800b001583a083163mr11703844pll.133.1649697165171; 
 Mon, 11 Apr 2022 10:12:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 ng17-20020a17090b1a9100b001c9f79927bfsm68698pjb.25.2022.04.11.10.12.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Apr 2022 10:12:44 -0700 (PDT)
Date: Mon, 11 Apr 2022 17:12:40 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlRhiF1O71TWQr5r@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Fri, Apr 01, 2022, David Matlack wrote:
> This series extends KVM's Eager Page Splitting to also split huge pages
> mapped by the shadow MMU, i.e. huge pages present in the memslot rmaps.
> This will be useful for configurations that use Nested Virtualization,
> disable the TDP MMU, or disable/lack TDP hardware support.
> 
> For background on Eager Page Splitting, see:
>  - Proposal: https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/
>  - TDP MMU support: https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
> 
> Splitting huge pages mapped by the shadow MMU is more complicated than
> the TDP MMU, but it is also more important for performance as the shadow
> MMU handles huge page write-protection faults under the write lock.  See
> the Performance section for more details.
> 
> The extra complexity of splitting huge pages mapped by the shadow MMU
> comes from a few places:

I think we should restrict eager page splitting to the TDP MMU being enabled,
i.e. restrict shadow MMU support to nested MMUs.

A decent chunk of the churn and complexity in this series comes from having to
deal with the intersection of things no one cares about in practice (!TDP shadow
paging), and/or things we should be putting into maintenance-only mode (legacy MMU
with TDP enabled).  I see zero reason to support this for legacy shadow paging
without a very concrete, very performance sensitive use case, and the legacy MMU
with TDP should be a hard "no".

With those out of the way, unsync support can also be jettisoned, because barring
use cases I don't know about, hypervisors don't modify TDP entries in the same way
that kernels modify native page tables, i.e. don't benefit from allowing SPTEs to
go unsync.

The other feature that I think we should deprecate (which I'm pretty sure someone on
our team, maybe even you, is planning on proposing upstream) is support for zapping
KVM shadow pages for the shrinker.  In hindsight, we should have done that a few
years ago instead of fixing the bug that made KVM's support meaningful (see commit
ebdb292dac79 ("KVM: x86/mmu: Batch zap MMU pages when shrinking the slab").  Doing
that for nested MMUs only (or at least first) should be less controversial.

The other thing we want to do sooner than later is improve the scalability of the
nested MMU.  A relatively simple way to pick some juicy low hanging fruit, if we
drop the aforementioned features we don't actually need for nested MMUs, would be
to turn all of the tracking structures needed for handling a page fault into
per-root lists/structures, e.g. active_mmu_pages and mmu_page_hash.  Unless L1 is
doing something funky, there is unlikely to be overlap between nested TDP page
tables, i.e. per-root tracking shouldn't cause a memory explosion.

At that point, as a first step/stopgap toward a more scalable nested MMU implementation,
nested TDP page faults, zapping of obsolete pages (memslot updates), and eager page
splitting (I think) can take mmu_lock for read and then take a per-root spinlock.

At a bare minimum, taking mmu_lock for read would prevent a nested vCPU from blocking
the TDP MMU, which in itself should be a big win.  Zapping after a memslot updates
would not interfere at all with re-faulting memory since zapping the obsolete roots
would never get a lock conflict.  And for use cases that spin up a large number of small
L2 VMs, per-root locking will allow KVM to handle page faults for each L2 in parallel,
which could be a huge performance boost for select use cases.

Circling back to eager page splitting, this series could be reworked to take the
first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
order to provide the necessary path for reworking nested MMU page faults.  Then it
can remove unsync and shrinker support for nested MMUs.  With those gone,
dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
some of the complexity/churn.

> Performance
> -----------
> 
> To measure the performance impact of Eager Page Splitting I ran
> dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> vCPU, and backed by 1GiB HugeTLB memory. The amount of memory that was
> written to versus read was controlled with the -f option.
> 
> To measure the imapct of customer performance, we can look at the time
> it takes all vCPUs to dirty memory after dirty logging has been enabled.
> Without Eager Page Splitting enabled, such dirtying must take faults to
> split huge pages and bottleneck on the MMU lock.
> 
>              | Config: ept=Y, tdp_mmu=N, 100% writes                   |
>              | Config: ept=Y, tdp_mmu=N, 100% writes                   |
>              | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
>              | Config: ept=Y, tdp_mmu=N, 100% writes initially-all-set |
>              | Config: ept=N, tdp_mmu=Y, 100% writes                   |
>              | Config: ept=N, tdp_mmu=Y, 50% writes                    |
>              | Config: ept=N, tdp_mmu=Y, 5% writes                     |

IMO, to justify this there needs to be performance numbers for ept=Y, tdp_mmu=Y,
i.e. for the use case we actually care about.  I don't expect the outcome to be
any different, but it really should be explicitly tested.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
