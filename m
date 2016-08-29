From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH] arm64: KVM: Save two instructions in __guest_enter()
Date: Mon, 29 Aug 2016 10:22:06 -0500
Message-ID: <daa6aa0c-27d0-25bd-02fd-4e87e9a908fe@codeaurora.org>
References: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
 <20160825133122.GA8016@lvm>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3644D40B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 11:14:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UOtXnmbOgnjQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Aug 2016 11:14:10 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B923407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 11:14:09 -0400 (EDT)
In-Reply-To: <20160825133122.GA8016@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

This is change may not provide the measurable performance improvement, 
but still we can
save a few cpu cycles on vCPU context switch and also improves the code 
readability.


On 08/25/2016 08:31 AM, Christoffer Dall wrote:
> Hi Shanker,
>
> On Tue, Aug 09, 2016 at 08:15:36PM -0500, Shanker Donthineni wrote:
>> We are doing an unnecessary stack push/pop operation when restoring
>> the guest registers x0-x18 in __guest_enter(). This patch saves the
>> two instructions by using x18 as a base register. No need to store
>> the vcpu context pointer in stack because it is redundant and not
>> being used anywhere, the same information is available in tpidr_el2.
> Does this have any measureable benefit?
>
> Thanks,
> -Christoffer

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
