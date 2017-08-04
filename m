From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH][RESEND] arm64: kvm: reuse existing cache type/info
 related macros
Date: Fri, 4 Aug 2017 14:17:50 +0100
Message-ID: <17464d78-829a-49d6-5ace-8c316e9baa0c@arm.com>
References: <1501851237-13017-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A37949C36
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 09:16:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CpjFFJOi9DG8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Aug 2017 09:16:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04D8449C34
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 09:16:31 -0400 (EDT)
In-Reply-To: <1501851237-13017-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/08/17 13:53, Sudeep Holla wrote:
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
>  arch/arm64/include/asm/cache.h |  7 +++++++
>  arch/arm64/kernel/cacheinfo.c  |  7 -------
>  arch/arm64/kvm/sys_regs.c      | 29 +++++++++++++++--------------
>  3 files changed, 22 insertions(+), 21 deletions(-)
> 
> Hi,
> 
> I dropped the support for 64bit format CCSIDR after Will's commit a8d4636f96ad
> ("arm64: cacheinfo: Remove CCSIDR-based cache information probing"). However
> I forgot to follow up on this patch which can be still applied. So just
> reposting again rebasing on v4.13-rc3 as mentioned by Will as it was too
> late for last cycle. Christoffer was fine with the changes but has not
> given an official ACK.

Hi Sudeep,

I've queued it for the next cycles.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
