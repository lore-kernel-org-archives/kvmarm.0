From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v4 19/21] KVM: arm64: Handle RAS SErrors from EL2 on guest
 exit
Date: Fri, 27 Oct 2017 14:26:14 +0800
Message-ID: <6c0eaa5b-32a5-5562-2322-7dffb698d27d@huawei.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-20-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E589D406BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 02:25:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQBAHOuo0C+p for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 02:25:12 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 836E040638
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 02:25:12 -0400 (EDT)
In-Reply-To: <20171019145807.23251-20-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2017/10/19 22:58, James Morse wrote:
> +alternative_if ARM64_HAS_RAS_EXTN
> +	// If we have the RAS extensions we can consume a pending error
> +	// without an unmask-SError and isb.
> +	esb
> +	mrs_s	x2, SYS_DISR_EL1
I do not think you can get the right value when esb produce a SError. when
SError happen, it will take to EL3 firmware immediately. so the disr_el1 will not record
the error and value is 0.

> +	str	x2, [x1, #(VCPU_FAULT_DISR - VCPU_CONTEXT)]
> +	cbz	x2, 1f
why will jump to 1, if there is not SError, also "ret"?

> +	msr_s	SYS_DISR_EL1, xzr
> +	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
> +1:	ret
> +alternative_else
