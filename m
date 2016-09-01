From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Get rid of exported aliases to static
 functions
Date: Thu, 1 Sep 2016 13:11:54 +0100
Message-ID: <57C81B0A.2050003@arm.com>
References: <20160901111806.14972-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC19410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 08:03:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZSSuyXNvy9gN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 08:03:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B35040BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 08:03:46 -0400 (EDT)
In-Reply-To: <20160901111806.14972-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/09/16 12:18, Christoffer Dall wrote:
> When rewriting the assembly code to C code, it was useful to have
> exported aliases or static functions so that we could keep the existing
> common C code unmodified and at the same time rewrite arm64 from
> assembly to C code, and later do the arm part.
> 
> Now when both are done, we really don't need this level of indirection
> anymore, and it's time to save a few lines and brain cells.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
