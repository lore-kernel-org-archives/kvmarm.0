From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6 08/13] arm64: expose user PAC bit positions via ptrace
Date: Mon, 10 Dec 2018 14:29:45 +0000
Message-ID: <20181210142944.GA13100@edgewater-inn.cambridge.arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-9-kristina.martsenko@arm.com>
 <a31ca10a-ee1a-71fb-2c3d-a6184e12b543@linaro.org>
 <20181210120330.GB4048@arrakis.emea.arm.com>
 <ba48e082-3e47-43bc-77d1-97d741c59284@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C47A4A2BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 09:29:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Aoes6W9NAjSt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 09:29:23 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 584774A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 09:29:23 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <ba48e082-3e47-43bc-77d1-97d741c59284@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Richard Henderson <richard.henderson@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Dave P Martin <dave.martin@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 08:22:06AM -0600, Richard Henderson wrote:
> On 12/10/18 6:03 AM, Catalin Marinas wrote:
> >> However, it won't be too long before someone implements support for
> >> ARMv8.2-LVA, at which point, without changes to mandatory pointer tagging, we
> >> will only have 3 authentication bits: [54:52].  This seems useless and easily
> >> brute-force-able.
> > 
> > Such support is already here (about to be queued):
> > 
> > https://lore.kernel.org/linux-arm-kernel/20181206225042.11548-1-steve.capper@arm.com/
> 
> Thanks for the pointer.
> 
> >> Unfortunately, there is no obvious path to making this optional that does not
> >> break compatibility with Documentation/arm64/tagged-pointers.txt.
> > 
> > There is also the ARMv8.5 MTE (memory tagging) which relies on tagged
> > pointers.
> 
> So it does.  I hadn't read through that extension completely before.
> 
> > An alternative would be to allow the opt-in to 52-bit VA, leaving it at
> > 48-bit by default. However, it has the problem of changing the PAC size
> > and not being able to return.
> 
> Perhaps the opt-in should be at exec time, with ELF flags (or equivalent) on
> the application.  Because, as you say, changing the shape of the PAC in the
> middle of execution is in general not possible.

I think we'd still have a potential performance problem with that approach,
since we'd end up having to context-switch TCR.T0SZ, which is permitted to
be cached in a TLB and would therefore force us to introduce TLB
invalidation when context-switching between tasks using 52-bit VAs and tasks
using 48-bit VAs.

There's a chance we could get the architecture tightened here, but it's
not something we've pushed for so far and it depends on what's already been
built.

Will
