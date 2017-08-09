From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 06/16] arm64: entry.S: convert elX_sync
Date: Wed, 9 Aug 2017 18:25:28 +0100
Message-ID: <20170809172527.yrkpthrrtqoxi4d7@armageddon.cambridge.arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-7-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5608940C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 13:24:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SuiYgo1n-y4b for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 13:24:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D06B40A86
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 13:24:01 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170728141019.9084-7-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Fri, Jul 28, 2017 at 03:10:09PM +0100, James Morse wrote:
> @@ -520,9 +514,16 @@ el1_preempt:
>  el0_sync:
>  	kernel_entry 0
>  	mrs	x25, esr_el1			// read the syndrome register
> +	mrs	x26, far_el1

Just checking, since we are going to access far_el1 even when we get a
syscall, have you noticed any overhead?

-- 
Catalin
