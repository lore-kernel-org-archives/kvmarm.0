From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: [PATCH 0/2] arm64: PMU: Sanitize usage of PMSELR_EL0.SEL
Date: Sat, 3 Dec 2016 06:28:07 +0900
Message-ID: <d27d50ad-c61e-28a6-c8e5-5714b1530c4d@riken.jp>
References: <1480693859-27249-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BF29405E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 16:27:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RgVODWwm0C84 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2016 16:27:17 -0500 (EST)
Received: from postman.riken.jp (postman3.riken.jp [134.160.33.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 597A64053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2016 16:27:17 -0500 (EST)
In-Reply-To: <1480693859-27249-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Hoan Tran <hotran@apm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Tai Tri Nguyen <ttnguyen@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Successfully verified them on a Rev B0 CPU. Thank you for quickly 
providing the fix.

On 2016/12/03 0:50, Marc Zyngier wrote:
> An ugly interaction between the use of PMSELR_EL0 in a host kernel and
> the use of PMXEVCNTR_EL0 in a guest has recently come to light [1],
> leading to the guest taking an UNDEF exception in EL1 when using the
> PMU.
>
> The fix is pretty simple ("don't do that!"), making the PMU useable on
> X-Gene, which seems to have a stricter (but nonetheless valid)
> interpretation of the architecture.
>
> Patches against 4.9-rc6.
>
> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-November/022545.html
>
> Marc Zyngier (2):
>   arm64: PMU: Do not use PMSELR_EL0 to access PMCCFILTR_EL0
>   arm64: PMU: Reset PMSELR_EL0 to a sane value at boot time
>
>  arch/arm64/kernel/perf_event.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
