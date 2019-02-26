From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 05/26] KVM: arm64: Add missing #include of
 <linux/bitmap.h> to kvm_host.h
Date: Tue, 26 Feb 2019 12:06:16 +0000
Message-ID: <20190226120616.GG3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
 <20190220152349.GE4763@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7806E4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:06:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GBUocqxgPPIX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:06:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7C94A36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:06:21 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190220152349.GE4763@lakrids.cambridge.arm.com>
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

On Wed, Feb 20, 2019 at 03:23:50PM +0000, Mark Rutland wrote:
> On Mon, Feb 18, 2019 at 07:52:18PM +0000, Dave Martin wrote:
> > kvm_host.h uses DECLARE_BITMAP() to declare the features member of
> > struct vcpu_arch, but the corresponding #include for this is
> > missing.
> > =

> > This patch adds a suitable #include for <linux/bitmap.h>.  Although
> > the header builds without it today, this should help to avoid
> > future surprises.
> > =

> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  1 file changed, 1 insertion(+)
> > =

> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 7732d0b..84056a4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -22,6 +22,7 @@
> >  #ifndef __ARM64_KVM_HOST_H__
> >  #define __ARM64_KVM_HOST_H__
> >  =

> > +#include <linux/bitmap.h>
> >  #include <linux/types.h>
> >  #include <linux/kvm_types.h>
> >  #include <asm/cpufeature.h>
> =

> From a quick scan of the file, we're also missing:
> =

> #include <asm/barrier.h>

[...]

> #include <linux/jump_label.h>
> #include <linux/percpu.h>

Done for those three.


> #include <linux/thread_info.h>

Since commit e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to
reduce guest/host thrashing", we do have <asm/thread_info.h>.

Since this header is not generic, this seems reasonable.  Is there
something from <linux/thread_info.h> used here that I'm missing?

Cheers
---Dave
