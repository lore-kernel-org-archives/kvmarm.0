From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v6 14/21] KVM: ARM64: Add reset and access handlers for
 PMOVSSET and PMOVSCLR register
Date: Wed, 9 Dec 2015 16:47:52 +0800
Message-ID: <5667EAB8.9030502@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-15-git-send-email-zhaoshenglong@huawei.com>
 <56670C5D.3020407@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41444412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 03:46:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qpP5EiATickv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2015 03:46:42 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7224940C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 03:46:41 -0500 (EST)
In-Reply-To: <56670C5D.3020407@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/9 0:59, Marc Zyngier wrote:
>> > +	}
>> > +
>> > +	/* If all overflow bits are cleared, kick the vcpu to clear interrupt
>> > +	 * pending status.
>> > +	 */
>> > +	if (val == 0)
>> > +		kvm_vcpu_kick(vcpu);
> Do we really need to do so? This will be dropped on the next entry
> anyway, so i don't see the need to kick the vcpu again. Or am I missing
> something?
> 
I thought maybe it could not set the interrupt low immediately when all
the overflow bits are cleared for some reason, so add a kick to force it
to sync the interrupt. But as you said, I'll remove this.

Thanks,
-- 
Shannon
