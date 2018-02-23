From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: rename the function arm64_is_ras_serror() to avoid
 confusion
Date: Fri, 23 Feb 2018 17:58:22 +0000
Message-ID: <5A90563E.4020608@arm.com>
References: <1519322552-7374-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C374249D36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 12:55:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o06NvsgBOQbL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Feb 2018 12:54:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4C140332
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 12:54:11 -0500 (EST)
In-Reply-To: <1519322552-7374-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 22/02/18 18:02, Dongjiu Geng wrote:
> The RAS SError Syndrome can be Implementation-Defined,
> arm64_is_ras_serror() is used to judge whether it is RAS SError,
> but arm64_is_ras_serror() does not include this judgement. In order
> to avoid function name confusion, we rename the arm64_is_ras_serror()
> to arm64_is_categorized_ras_serror(), this function is used to
> judge whether it is categorized RAS Serror.

I don't see how 'categorized' is relevant. The most significant ISS bit is used
to determine if this is an IMP-DEF ESR, or one that uses the architected layout.

DFSC of zero means uncategorised. What should we do with an uncategorised SError?

>From 2.4.3 "ESB and other physical errors" of [0]
| It is IMPLEMENTATION DEFINED whether [..]uncategorized SError interrupts
| are containable or Uncontainable, and whether they can be synchronized by an
| Error Synchronization Barrier.

We treat uncategorized as uncontainable as that's the worst thing it could be.

On aarch32 uncontainable and uncategorized even share an encoding.
(AET:00 in G7.2.43 "DFSR, Data Fault Status Register", 'state of the PE after
taking the SError interrupt exception')


> Change some code notes, unrecoverable RAS errors is imprecise, but
> Recoverable RAS errors is precise.

Unrecoverable and Recoverable (but we don't know where it is) are both grouped
into 'can't make progress'. The comment says:
| The exception may have been imprecise.
because one of those two is imprecise.

If anyone cares which one is which, they can read the spec.

I expect this code will one day be replaced with proper kernel-first support,
its only here to avoid panic()ing due to corrected errors.


Thanks,

James

[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
