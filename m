From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 08/26] arm64/sve: Enable SVE state tracking for
 non-task contexts
Date: Tue, 26 Feb 2019 16:03:20 +0000
Message-ID: <20190226160320.GA3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-9-git-send-email-Dave.Martin@arm.com>
 <dc379691-ab3a-79a6-b760-59a02aa40717@arm.com>
 <20190226120713.GL3567@e103592.cambridge.arm.com>
 <b1d64e84-1c59-d1a6-7893-212b5cd3a7ac@arm.com>
 <20190226155815.GZ3567@e103592.cambridge.arm.com>
 <1c665ce8-1334-6d74-fe93-eead9383970d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 701BF4A320
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 11:03:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZL+wTQtkP8xi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 11:03:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE0E4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 11:03:25 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1c665ce8-1334-6d74-fe93-eead9383970d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 26, 2019 at 03:59:40PM +0000, Julien Grall wrote:
> Hi Dave,
> 
> On 26/02/2019 15:58, Dave Martin wrote:
> >On Tue, Feb 26, 2019 at 03:49:00PM +0000, Julien Grall wrote:
> >>Hi Dave,
> >>
> >>On 26/02/2019 12:07, Dave Martin wrote:

[...]

> >>>Does the code look reasonable to you?  This interacts with FPSIMD/SVE
> >>>context switch in the host, so it would be good to have your view on it.
> >>
> >>I wanted to look at the rest before giving my reviewed-by tag.
> >>FWIW, this patch looks reasonable to me.
> >
> >OK, does that amount to a Reviewed-by, or do you have other comments?
> 
> I have no further comments on this patch.
> 
> Reviewed-by: Julien Grall <julien.grall@arm.com>

Thanks
---Dave
