From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 11/16] arm64: kernel: Handle deferred SError on kernel
 entry
Date: Thu, 03 Aug 2017 18:03:52 +0100
Message-ID: <59835778.80702@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EFD149C19
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Aug 2017 13:03:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RElBzKWxrtih for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Aug 2017 13:03:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56F8E40D1D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Aug 2017 13:03:41 -0400 (EDT)
In-Reply-To: <20170728141019.9084-12-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hello!

On 28/07/17 15:10, James Morse wrote:
> Before we can enable Implicit ESB on exception level change, we need to
> handle deferred SErrors that may appear on exception entry.

Christoffer has pointed out on patch 16 that I've miss-understood IESB's behaviour:
> The implicit form of Error Synchronization Barrier: [...] Has no effect on
> DISR_EL1

Turns out the ARM-ARM psuedocode means subtly different things by 'ESB' and
'ErrorSynchronizationBarrier'.

Patches 11->16 will need rethinking, but it looks like they can be simplified.


Thanks,

James
