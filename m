From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 0/2] arm64/kvm: use SYS_REG_DESC() for VGIC-v3
Date: Tue, 6 Jun 2017 15:46:34 +0200
Message-ID: <20170606134634.GE9464@cbox>
References: <1496668801-16064-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A1D040A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:42:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L+DnSMh4b4OI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 09:42:42 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D50240A66
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:42:42 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id d73so49321286wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 06:46:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1496668801-16064-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On Mon, Jun 05, 2017 at 02:19:59PM +0100, Mark Rutland wrote:
> While looking around, I spotted that the VGIC-v3 code still uses open-coded SYS
> encodings. These patches migrate said code to use common <asm/sysreg.h>
> mnemonics, as we do for the rest of the AArch64 sysregs.
> 
> This is based on Marc's kvm-arm64/gicv3-cpuif-mediated-access branch [1].

Patches look good to me.  I can apply them after we apply [1] if
Catalin/Will are ok with this.

Thanks,
-Christoffer

> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/gicv3-cpuif-mediated-access
> 
> Mark Rutland (2):
>   arm64/kvm: sysreg: fix typo'd SYS_ICC_IGRPEN*_EL1
>   arm64/kvm: vgic: use SYS_DESC()
> 
>  arch/arm64/include/asm/arch_gicv3.h |  2 +-
>  arch/arm64/include/asm/sysreg.h     | 12 ++++++++--
>  arch/arm64/kvm/vgic-sys-reg-v3.c    | 45 +++++++++++++------------------------
>  virt/kvm/arm/hyp/vgic-v3-sr.c       |  4 ++--
>  4 files changed, 28 insertions(+), 35 deletions(-)
> 
> -- 
> 1.9.1
> 
