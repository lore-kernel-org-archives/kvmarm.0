From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6 0/4] arm64: Support perf event modifiers :G and :H
Date: Mon, 10 Dec 2018 18:19:33 +0000
Message-ID: <20181210181933.GA11796@edgewater-inn.cambridge.arm.com>
References: <1544435159-54781-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA0A4A341
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 13:19:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rm83GvO-Jg7J for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 13:19:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA0374A2BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 13:19:11 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1544435159-54781-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On Mon, Dec 10, 2018 at 09:45:55AM +0000, Andrew Murray wrote:
> This patchset provides support for perf event modifiers :G and :H which
> allows for filtering of PMU events between host and guests when used
> with KVM.
> 
> As the underlying hardware cannot distinguish between guest and host
> context, the performance counters must be stopped and started upon
> entry/exit to the guest. This is performed at EL2 in a way that
> minimizes overhead and improves accuracy of recording events that only
> occur in the requested context.
> 
> This has been tested with VHE and non-VHE kernels with a KVM guest.
> 
> Changes from v5:
> 
>  - Tweak logic in use of kvm_set_pmu_events

This looks good to me, but I'll need Acks from the KVM folks on patches 2
and 4 before I can take it (and Christoffer has some questions on patch 2
as well).

Also, please be aware that I'm planning to close the arm64 tree later this
week so we don't have to deal with late issues going into the holidays. Last
Christmas was ruined by specdown and meltre, so I think many of us are due a
proper break this year :)

Cheers,

Will
