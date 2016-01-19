From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Obey RES0/1 reserved bits when setting
 CPTR_EL2
Date: Tue, 19 Jan 2016 16:32:43 +0000
Message-ID: <569E652B.8040202@arm.com>
References: <1453220418-24744-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87517496F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2016 11:28:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zX8lHkDF5++3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jan 2016 11:28:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6496F49680
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2016 11:28:17 -0500 (EST)
In-Reply-To: <1453220418-24744-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Geoff Levand <geoff@infradead.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 19/01/16 16:20, Dave Martin wrote:
> Some bits in CPTR are defined as RES1 in the architecture.  Setting
> these bits to zero may unintentionally enable future architecture
> extensions, allowing guests to use them without supervision by the host.
> 
> This would be bad: for forwards compatibility, this patch makes
> sure the affected bits are always written with 1, not 0.
> 
> This patch only addresses CPTR_EL2.  Initialisation of other system
> registers may still need review.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Thanks for putting this together:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Unless someone has an objection, I plan to queue this post -rc1.

	M.
-- 
Jazz is not dead. It just smells funny...
