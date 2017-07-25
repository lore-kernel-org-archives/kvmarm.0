From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix guest external abort matching
Date: Tue, 25 Jul 2017 14:36:14 +0100
Message-ID: <b884d460-2e01-5db9-123b-58a88c03e388@arm.com>
References: <20170718123741.11537-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D527340D68
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jul 2017 09:35:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DJKpvByEoXNl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jul 2017 09:35:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2C8A40CE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jul 2017 09:35:14 -0400 (EDT)
In-Reply-To: <20170718123741.11537-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Tyler Baicar <tbaicar@codeaurora.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/07/17 13:37, James Morse wrote:
> The ARM-ARM has two bits in the ESR/HSR relevant to external aborts.
> A range of {I,D}FSC values (of which bit 5 is always set) and bit 9 'EA'
> which provides:
>> an IMPLEMENTATION DEFINED classification of External Aborts.
> 
> This bit is in addition to the {I,D}FSC range, and has an implementation
> defined meaning. KVM should always ignore this bit when handling external
> aborts from a guest.
> 
> Remove the ESR_ELx_EA definition and rewrite its helper
> kvm_vcpu_dabt_isextabt() to check the {I,D}FSC range. This merges
> kvm_vcpu_dabt_isextabt() and the recently added is_abort_sea() helper.
> 
> Reported-by: gengdongjiu <gengdj.1984@gmail.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> CC: gengdongjiu <gengdj.1984@gmail.com>
> CC: Tyler Baicar <tbaicar@codeaurora.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
