From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 05/26] KVM: arm64: Add missing #include of
 <linux/bitmap.h> to kvm_host.h
Date: Tue, 26 Feb 2019 12:33:22 +0000
Message-ID: <20190226123320.GW3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
 <20190220152349.GE4763@lakrids.cambridge.arm.com>
 <20190226120616.GG3567@e103592.cambridge.arm.com>
 <20190226123145.GB17422@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 043864A3B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:33:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2xPm0aGBVJS9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:33:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D91444A382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:33:26 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190226123145.GB17422@lakrids.cambridge.arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 26, 2019 at 12:31:45PM +0000, Mark Rutland wrote:
> On Tue, Feb 26, 2019 at 12:06:16PM +0000, Dave Martin wrote:
> > On Wed, Feb 20, 2019 at 03:23:50PM +0000, Mark Rutland wrote:

[...]

> > > #include <asm/barrier.h>
> > 
> > [...]
> > 
> > > #include <linux/jump_label.h>
> > > #include <linux/percpu.h>
> > 
> > Done for those three.
> 
> Great.
> 
> > > #include <linux/thread_info.h>
> > 
> > Since commit e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to
> > reduce guest/host thrashing", we do have <asm/thread_info.h>.
> > 
> > Since this header is not generic, this seems reasonable.  Is there
> > something from <linux/thread_info.h> used here that I'm missing?
> 
> I think I just confused myself; <asm/thread_info.h> seems sufficient.

OK, I shan't worry about that one, then.

Cheers
---Dave
