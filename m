From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 0/8] Workaround for Cortex-A76 erratum 1165522
Date: Fri, 7 Dec 2018 11:09:40 +0000
Message-ID: <da3f6f5a-9d39-3b51-661e-723742727f35@arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6137C4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 06:09:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id btMAj8gimRBD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Dec 2018 06:09:44 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D844A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 06:09:44 -0500 (EST)
In-Reply-To: <20181206173126.139877-1-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 06/12/2018 17:31, Marc Zyngier wrote:
> Early Cortex-A76 suffer from an erratum that can result in invalid
> TLBs when the CPU speculatively executes an AT instruction in the
> middle of a guest world switch, while the guest virtual memory
> configuration is in an inconsistent state.
> 
> We handle this issue by mandating the use of VHE and making sure that
> the guest context is fully installed before switching HCR_EL2.TGE to
> zero. This ensures that a speculated AT instruction is either executed
> on the host context (TGE set) or the guest context (TGE clear), and
> that there is no intermediate state.
> 
> There is some additional complexity in the TLB invalidation code,
> where we most make sure that a speculated AT instruction cannot mess
> the stage-1 TLBs.

For the series:
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
