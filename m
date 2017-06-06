From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] arm64/kvm: use SYS_REG_DESC() for VGIC-v3
Date: Tue, 6 Jun 2017 15:46:20 +0100
Message-ID: <20170606144620.GE4789@arm.com>
References: <1496668801-16064-1-git-send-email-mark.rutland@arm.com>
 <20170606134634.GE9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3E5E40A74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 10:42:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CopVnEv+jKbR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 10:42:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B1840962
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 10:42:07 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170606134634.GE9464@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 06, 2017 at 03:46:34PM +0200, Christoffer Dall wrote:
> Hi Mark,
> 
> On Mon, Jun 05, 2017 at 02:19:59PM +0100, Mark Rutland wrote:
> > While looking around, I spotted that the VGIC-v3 code still uses open-coded SYS
> > encodings. These patches migrate said code to use common <asm/sysreg.h>
> > mnemonics, as we do for the rest of the AArch64 sysregs.
> > 
> > This is based on Marc's kvm-arm64/gicv3-cpuif-mediated-access branch [1].
> 
> Patches look good to me.  I can apply them after we apply [1] if
> Catalin/Will are ok with this.

Fine by me.

Acked-by: Will Deacon <will.deacon@arm.com>

if you need it.

Will
