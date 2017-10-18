From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 01/20] arm64: explicitly mask all exceptions
Date: Wed, 18 Oct 2017 15:25:46 +0100
Message-ID: <20171018142545.fgwihep2hptr44zb@armageddon.cambridge.arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
 <20171005191812.5678-2-james.morse@arm.com>
 <20171018142315.vt44zeuke5po3tf7@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E36EB40D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 10:24:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wpq4loaVqE1v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 10:24:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A775240795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 10:24:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171018142315.vt44zeuke5po3tf7@armageddon.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18, 2017 at 03:23:16PM +0100, Catalin Marinas wrote:
> On Thu, Oct 05, 2017 at 08:17:53PM +0100, James Morse wrote:
> > diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
> > new file mode 100644
> > index 000000000000..fb40da8e1457
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/daifflags.h
> > @@ -0,0 +1,59 @@
> > +/*
> > + * Copyright (C) 2017 ARM Ltd.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +#ifndef __ASM_DAIFFLAGS_H
> > +#define __ASM_DAIFFLAGS_H
> > +
> > +#include <asm/irqflags.h>
> > +#include <linux/irqflags.h>
> 
> Nitpick: linux/irqflags.h already includes asm/irqflags.h.
> 
> We currently have local_dbg_save in asm/irqflags.h. Shall we keep all of
> them in the same file (either asm/irqflags.h or the new asm/daifflags.h;
> slight preference for irqflags.h unless you are worried about drivers
> abusing these).

Ah, you removed local_dbg_* in the following patch, so please ignore
this.

-- 
Catalin
