From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 21/26] arm64: KVM: Reserve 4 additional instructions
 in the BPI template
Date: Thu, 15 Mar 2018 15:46:51 +0100
Message-ID: <20180315144651.w4egshvglf5jwrbi@kamzik.brq.redhat.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-22-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7454017F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 10:39:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mPkoXLGr5T08 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 10:39:20 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C14440458
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 10:39:20 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180314165049.30105-22-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 14, 2018 at 04:50:44PM +0000, Marc Zyngier wrote:
> So far, we only reserve a single instruction in the BPI template in
> order to branch to the vectors. As we're going to stuff a few more
> instructions there, let's reserve a total of 5 instructions, which
> we're going to patch later on as required.
> 
> We also introduce a small refactor of the vectors themselves, so that
> we stop carrying the target branch around.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/bpi.S | 39 +++++++++++++++------------------------
>  1 file changed, 15 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
