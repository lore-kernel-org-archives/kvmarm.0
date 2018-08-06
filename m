From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Mon, 6 Aug 2018 15:05:00 +0200
Message-ID: <20180806130500.GB5985@e113682-lin.lund.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A5749EA2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Aug 2018 09:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hobAb+gEA7GG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Aug 2018 09:05:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA5B40672
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Aug 2018 09:05:03 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 03:57:24PM +0100, Dave Martin wrote:
> This series implements basic support for allowing KVM guests to use the
> Arm Scalable Vector Extension (SVE).
> 
> The patches is based on torvalds/master f5b7769e (Revert "debugfs:
> inode: debugfs_create_dir uses mode permission from parent") plus the
> patches from [1].

Given the effort required to go fetch another patch set from the list to
apply to a specific commit, and the size of this patch set, it would be
helpful to have a pointer to a branch with everything in it.

Thanks,
-Christoffer
