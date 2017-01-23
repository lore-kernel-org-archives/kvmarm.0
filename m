From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] arm64: kvm: reuse existing cache type/info related
 macros
Date: Mon, 23 Jan 2017 18:17:28 +0000
Message-ID: <20170123181727.GJ28914@arm.com>
References: <1484909410-11673-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D5D4097B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 13:17:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kqvmKlT+1XJd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 13:17:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754E34096F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 13:17:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1484909410-11673-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 20, 2017 at 10:50:09AM +0000, Sudeep Holla wrote:
> We already have various macros related to cache type and bitfields in
> CLIDR system register. We can replace some of the hardcoded values
> here using those existing macros.
> 
> This patch reuses those existing cache type/info related macros and
> replaces the hardcorded values. It also removes some of the comments
> that become trivial with the macro names.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/include/asm/cachetype.h |  7 +++++++
>  arch/arm64/kernel/cacheinfo.c      |  7 -------
>  arch/arm64/kvm/sys_regs.c          | 27 +++++++++++++--------------
>  3 files changed, 20 insertions(+), 21 deletions(-)

I assume both of these will go via kvm-arm.

Will
