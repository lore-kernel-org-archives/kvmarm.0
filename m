From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Wed, 20 Feb 2019 15:47:13 +0000
Message-ID: <20190220154711.GS3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6452D4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 10:47:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id juDbya4HEyxh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 10:47:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5508B4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 10:47:18 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 18, 2019 at 07:52:13PM +0000, Dave Martin wrote:

[...]

> AArch32 host testing is pending.  I will ping this series with a reply
> to the cover letter when that testing has been completed.

AArch32 host testing now done on Arm TC2: 15 guests were able to boot
and execute "find /" concurrently without error.

Due to the trivial nature of the changes in the common code, this is
probably sufficient testing, but if anyone thinks I should run
something else (or wants to give it a try), let me know.

Cheers
---Dave
