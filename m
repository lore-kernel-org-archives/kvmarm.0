From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4.1] arm64: hw_breakpoint: Allow EL2 breakpoints if
 running in HYP
Date: Fri, 19 Feb 2016 14:30:45 +0000
Message-ID: <20160219143045.GJ27062@arm.com>
References: <1455216004-19499-23-git-send-email-marc.zyngier@arm.com>
 <1455731923-26768-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C86497BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 09:24:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KJBkdxQgDdaU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2016 09:24:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9401E49794
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 09:24:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1455731923-26768-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 05:58:43PM +0000, Marc Zyngier wrote:
> With VHE, we place kernel {watch,break}-points at EL2 to get things
> like kgdb and "perf -e mem:..." working.
> 
> This requires a bit of repainting in the low-level encore/decode,
> but is otherwise pretty simple.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/hw_breakpoint.h | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Will
