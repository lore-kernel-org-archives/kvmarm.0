From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 17/26] KVM: arm64: Reject ioctl access to FPSIMD
 V-regs on SVE vcpus
Date: Tue, 26 Feb 2019 12:13:28 +0000
Message-ID: <20190226121328.GR3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-18-git-send-email-Dave.Martin@arm.com>
 <696ae744-c016-9cc2-d393-fd321d341df4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC334A2E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6-109D9--p6A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:13:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C619649E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:13:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <696ae744-c016-9cc2-d393-fd321d341df4@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 21, 2019 at 12:06:23PM +0000, Julien Thierry wrote:
> 
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> > In order to avoid the pointless complexity of maintaining two ioctl
> > register access views of the same data, this patch blocks ioctl
> > access to the FPSIMD V-registers on vcpus that support SVE.
> > 
> > This will make it more straightforward to add SVE register access
> > support.
> > 
> > Since SVE is an opt-in feature for userspace, this will not affect
> > existing users.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks
---Dave
