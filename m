From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: Work around Falkor erratum 1009
Date: Thu, 8 Dec 2016 13:27:46 +0000
Message-ID: <20161208132746.GB15141@e104818-lin.cambridge.arm.com>
References: <20161207200028.4420-1-cov@codeaurora.org>
 <20161207200431.4587-1-cov@codeaurora.org>
 <20161208114511.GC9768@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BCF340423
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 08:26:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sFjUrSYId3P7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 08:26:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6537440354
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 08:26:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161208114511.GC9768@leverpostej>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 08, 2016 at 11:45:12AM +0000, Mark Rutland wrote:
> On Wed, Dec 07, 2016 at 03:04:31PM -0500, Christopher Covington wrote:
> > +	asm volatile(ALTERNATIVE(
> > +		     "nop \n"
> > +		     "nop \n",
> > +		     "tlbi vmalle1is \n"
> > +		     "dsb ish \n",
> 
> As a general note, perhaps we want a C compatible NOP_ALTERNATIVE() so
> that the nop case can be implicitly generated for sequences like this.

It's also worth checking what cpus_have_const_cap() would generate for
the default (no workaround required) case.

-- 
Catalin
