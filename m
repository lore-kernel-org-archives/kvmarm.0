From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4/7] arm64: tlbflush.h: add __tlbi() macro
Date: Fri, 23 Sep 2016 17:07:11 +0100
Message-ID: <20160923160710.GF6397@arm.com>
References: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
 <1473761769-30572-5-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5AF548531
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 11:57:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ai-x4ccUj0Xo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 11:57:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCFD2411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 11:57:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1473761769-30572-5-git-send-email-punit.agrawal@arm.com>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 13, 2016 at 11:16:06AM +0100, Punit Agrawal wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> As with dsb() and isb(), add a __tlbi() helper so that we can avoid
> distracting asm boilerplate every time we want a TLBI. As some TLBI
> operations take an argument while others do not, some pre-processor is
> used to handle these two cases with different assembly blocks.
> 
> The existing tlbflush.h code is moved over to use the helper.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> [ rename helper to __tlbi, update comment and commit log ]
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/tlbflush.h | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)

Given that this series seems to have stalled, I'm inclined to pick this
patch (and only this patch) up in the arm64 tree. It's a standalone tidy
up and means one fewer dependency next time round.

Will
