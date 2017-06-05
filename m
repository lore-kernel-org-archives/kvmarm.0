From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64: vgic: Fix the sequence principle about
 vgic save/restore.
Date: Mon, 5 Jun 2017 14:56:54 +0100
Message-ID: <e8c54af6-c774-a37e-a14f-04d422fe5234@arm.com>
References: <1496658604-20036-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E566D40C4C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 09:52:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EDWtu4FGO3ki for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 09:52:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F5340A69
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 09:52:53 -0400 (EDT)
In-Reply-To: <1496658604-20036-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>, cdall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/17 11:30, wanghaibin wrote:
> At present, take GICv3 as as an example, our implementation is that, the operation
> of the recovery ICH_HCR register is prior to the recovery of ICH_LRn registers in vgic
> state restore. Thus, the ICH_LRn registers are 0, and if ICH_HCR.UIE is configured to 1,
> a large number of unnecessary maintenance interrupts will be triggered.

Is that a theoretical problem? Or something you've actually observed?

At the point where we restore the vgic state, interrupts are disabled.
And by the time we enter the guest, we fully expect the HW to be in a
stable state, and no spurious interrupt would be delivered.

I also dispute the "large number of unnecessary maintenance interrupts".
This large number is at most *one*.

Or am I missing something obvious?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
