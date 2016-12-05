From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/1] arm64: Correcting format specifier for printing 64
 bit addresses
Date: Mon, 5 Dec 2016 11:24:21 +0000
Message-ID: <20161205112421.GB14058@arm.com>
References: <1480925393-8386-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DA4402A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 06:23:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rzFNiEpaw9c for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 06:23:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C4D40296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 06:23:24 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1480925393-8386-1-git-send-email-maninder1.s@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Maninder Singh <maninder1.s@samsung.com>
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, panand@redhat.com, cpgs@samsung.com, shijie.huang@arm.com, labbott@redhat.com, Vaneet Narang <v.narang@samsung.com>, cmetcalf@mellanox.com, marc.zyngier@arm.com, ajeet.y@samsung.com, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, pankaj.m@samsung.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 05, 2016 at 01:39:53PM +0530, Maninder Singh wrote:
> This patch corrects format specifier for printing 64 bit addresses.
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Signed-off-by: Vaneet Narang <v.narang@samsung.com>
> ---
>  arch/arm64/kernel/signal.c |  2 +-
>  arch/arm64/kvm/sys_regs.c  |  8 ++++++--
>  arch/arm64/mm/fault.c      | 15 ++++++++++-----
>  arch/arm64/mm/mmu.c        |  4 ++--
>  4 files changed, 19 insertions(+), 10 deletions(-)

Any reason not to fix kvm/trace.h too?

Anyway, rest of this looks fine:

Acked-by: Will Deacon <will.deacon@arm.com>

Will
