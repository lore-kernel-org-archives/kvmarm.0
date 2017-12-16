From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v5 04/13] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Sat, 16 Dec 2017 12:08:45 +0800
Message-ID: <79ccc7df-802b-e25c-05cf-b1ecc7c05569@huawei.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C0849D28
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 23:05:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R5hv1QdJnlJz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 23:05:30 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15FB349D27
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 23:05:30 -0500 (EST)
In-Reply-To: <20171215155101.23505-5-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/12/15 23:50, James Morse wrote:
> +	case ESR_ELx_AET_UER:	/* Uncorrected Recoverable */
> +		/*
> +		 * The CPU can't make progress. The exception may have
> +		 * been imprecise.
> +		 */
> +		return true;
        For Recoverable error (UER), the error has not been  silently propagated,
        and has not been architecturally consumed by the PE, and
        The exception is precise and PE can recover execution from the preferred return address of the exception.
        so I do not think it should be panic here if the SError come from user space instead of coming from kernel space.
> +
