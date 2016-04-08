From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 00/17] kvm-arm: Add stage2 page table walker
Date: Fri, 8 Apr 2016 17:15:01 +0200
Message-ID: <20160408151501.GB8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7AFB40F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 11:13:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id abrPwmW4w5kJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 11:13:22 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9131407A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 11:13:21 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id l6so68618778wml.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 08:14:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Mon, Apr 04, 2016 at 05:26:00PM +0100, Suzuki K Poulose wrote:
> This series adds support for stage2 page table helpers and makes
> the core kvm-arm MMU code make use of it. At the moment we assume
> that the host/hyp and the stage2 page tables have same number of
> levels and hence use the host level accessors (except for some
> hooks, e.g kvm_p.d_addr_end) and shares the routines for unmapping
> the page table ranges.
> 
> On arm32, the only change w.r.t the page tables is dealing
> with > 32bit physical addresses.
> 
> However on arm64, the hardware supports concatenation of tables (upto 16)
> at the entry level, which could affect :
>  1) number of entries in the PGD table (upto 16 * PTRS_PER_PTE)
>  2) number of page table levels (reduced number of page table levels).
> 
> Also depending on the VA_BITS for the host kernel, the number of page table
> levels for both host and stage2(40bit IPA) could differ. At present, we insert
> (upto) one fake software page table(as the hardware is not aware of it and is
> only used by the OS to walk the table) level to bring the number of levels to
> that of the host/hyp table. However, with 16K + 48bit, and 40bit IPA, we could
> end up in 2 fake levels, which complicates the code.
> 
> This series introduces explicit stage2 page table helpers and also defines
> separate set of routines for unmapping hyp and stage2 tables.
> 
> On arm64 stage2 page table helpers are defined based on the number of levels
> required to map the IPA bits. See patch 15 for more details.
> 
> Tested on TC2 (arm32), Fast models(with VHE) and real hardwares.
> 

This looks pretty good overall.  Could you rebase it on kvmarm/master
where Marc addressed the 36 bits PA size of the foundation model and
have a look at the interactions there?

If we can solve that bit and address the cosmetic issues I had in this
series, then I think we can queue this real soon.

Thanks a lot for going the extra mile on this with rewriting the whole
KVM page table handling!

Best,
-Christoffer
