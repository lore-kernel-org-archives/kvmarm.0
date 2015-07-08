From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/18] ARM64: Move PMU register related defines to
 asm/pmu.h
Date: Wed, 8 Jul 2015 18:18:28 +0100
Message-ID: <20150708171828.GD6348@arm.com>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-2-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6E858175
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:07:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w-+YXQdBfch1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 13:06:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF2358172
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:06:59 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1436149068-3784-2-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "shannon.zhao@linaro.org" <shannon.zhao@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 03:17:31AM +0100, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> To use the ARMv8 PMU related register defines from the KVM code,
> we move the relevant definitions to asm/pmu.h header file.
> 
> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/pmu.h   | 45 ++++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/perf_event.c | 35 --------------------------------
>  2 files changed, 45 insertions(+), 35 deletions(-)

Whilst I'm ok with the idea, we're currently in the process of moving the
ARM and arm64 PMU drivers out into drivers/perf/, so this is likely to
conflict horribly with that work.

Christoffer/Marc: if you end up wanting to queue this for 4.3, give me a
shout and I'll try to create a stable branch you can use as a base (but
it's likely to contain a whole heap of stuff you don't want...).

Will
