From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 3/4] arm64: Use __tlbi() macros in KVM code
Date: Wed, 1 Feb 2017 17:08:52 +0000
Message-ID: <20170201170852.GI8177@arm.com>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-3-cov@codeaurora.org>
 <20170125193943.GW15850@cbox> <20170127135306.GK21144@arm.com>
 <87lgtprgi4.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0EE4092C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:08:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VlyZlSQhGKWq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 12:08:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD16408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:08:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87lgtprgi4.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Neil Leeder <nleeder@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 05:02:43PM +0000, Punit Agrawal wrote:
> Will Deacon <will.deacon@arm.com> writes:
> 
> > On Wed, Jan 25, 2017 at 08:39:43PM +0100, Christoffer Dall wrote:
> >> On Wed, Jan 25, 2017 at 10:52:31AM -0500, Christopher Covington wrote:
> >> > Refactor the KVM code to use the __tlbi macros, which will allow an errata
> >> > workaround that repeats tlbi dsb sequences to only change one location.
> >> > This is not intended to change the generated assembly and comparing before
> >> > and after vmlinux objdump shows no functional changes.
> >> > 
> >> > Signed-off-by: Christopher Covington <cov@codeaurora.org>
> >> 
> >> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> >
> > Thanks, I'll queue this one via arm64.
> 
> I just noticed this patch but there's been a similar patch from Mark
> that I've been carrying as part of the KVM TLB monitoring series[0].
> 
> [0] http://www.mail-archive.com/kvmarm@lists.cs.columbia.edu/msg09359.html

Well I've already queued the one from Christopher. It's weird that Mark's
version appears to miss the local VMID case (but it does have the
flush_icache_all I wanted :).

Anyway, I'm not reverting anything, so you'll need to rebase when this
lot lands in mainline.

Will
