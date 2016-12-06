From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/1] arm64: Correcting format specifier for printing 64
 bit addresses
Date: Tue, 6 Dec 2016 15:28:38 +0000
Message-ID: <20161206152837.GM2498@arm.com>
References: <1480925393-8386-1-git-send-email-maninder1.s@samsung.com>
 <20161205112421.GB14058@arm.com>
 <20161206152637.GC16701@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D34D402A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 10:27:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WzJpAQxLrBeD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 10:27:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7A9640187
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 10:27:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161206152637.GC16701@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, panand@redhat.com, cpgs@samsung.com, shijie.huang@arm.com, labbott@redhat.com, Vaneet Narang <v.narang@samsung.com>, cmetcalf@mellanox.com, marc.zyngier@arm.com, ajeet.y@samsung.com, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, pankaj.m@samsung.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, Maninder Singh <maninder1.s@samsung.com>, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 06, 2016 at 03:26:37PM +0000, Catalin Marinas wrote:
> On Mon, Dec 05, 2016 at 11:24:21AM +0000, Will Deacon wrote:
> > On Mon, Dec 05, 2016 at 01:39:53PM +0530, Maninder Singh wrote:
> > > This patch corrects format specifier for printing 64 bit addresses.
> > > 
> > > Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> > > Signed-off-by: Vaneet Narang <v.narang@samsung.com>
> > > ---
> > >  arch/arm64/kernel/signal.c |  2 +-
> > >  arch/arm64/kvm/sys_regs.c  |  8 ++++++--
> > >  arch/arm64/mm/fault.c      | 15 ++++++++++-----
> > >  arch/arm64/mm/mmu.c        |  4 ++--
> > >  4 files changed, 19 insertions(+), 10 deletions(-)
> > 
> > Any reason not to fix kvm/trace.h too?
> 
> If the KVM guys are ok, I can fold the hunk below into this patch:
> 
> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
> index 7fb0008c4fa3..e117123d414b 100644
> --- a/arch/arm64/kvm/trace.h
> +++ b/arch/arm64/kvm/trace.h
> @@ -20,7 +20,7 @@ TRACE_EVENT(kvm_wfx_arm64,
>  		__entry->is_wfe  = is_wfe;
>  	),
>  
> -	TP_printk("guest executed wf%c at: 0x%08lx",
> +	TP_printk("guest executed wf%c at: 0x%016lx",
>  		  __entry->is_wfe ? 'e' : 'i', __entry->vcpu_pc)
>  );
>  
> @@ -40,7 +40,7 @@ TRACE_EVENT(kvm_hvc_arm64,
>  		__entry->imm = imm;
>  	),
>  
> -	TP_printk("HVC at 0x%08lx (r0: 0x%08lx, imm: 0x%lx)",
> +	TP_printk("HVC at 0x%016lx (r0: 0x%016lx, imm: 0x%lx)",

Not sure we need the 016 prefix for r0.

Will
