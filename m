From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 5/8] arm64/sve: Switch sve_pffr() argument from task
 to thread
Date: Wed, 25 Apr 2018 19:06:57 +0100
Message-ID: <20180425180657.uz7xnz36gjqikqep@armageddon.cambridge.arm.com>
References: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
 <1524242802-21163-6-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C231749FDE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 13:57:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fZMuffWpqLxE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 13:57:36 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2E749FD3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 13:57:36 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1524242802-21163-6-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 20, 2018 at 05:46:39PM +0100, Dave P Martin wrote:
> sve_pffr(), which is used to derive the base address used for
> low-level SVE save/restore routines, currently takes the relevant
> task_struct as an argument.
> 
> The only accessed fields are actually part of thread_struct, so
> this patch changes the argument type accordingly.  This is done in
> preparation for moving this function to a header, where we do not
> want to have to include <linux/sched.h> due to the consequent
> circular #include problems.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
