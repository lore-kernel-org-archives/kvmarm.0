From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 0/8] Workaround for Cortex-A76 erratum 1165522
Date: Mon, 3 Dec 2018 19:22:43 +0000
Message-ID: <20181203192242.GE29028@arm.com>
References: <20181123184107.39334-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 702494A2BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 14:22:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68SB1ePRpSj3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 14:22:24 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D2C4A2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 14:22:24 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181123184107.39334-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Fri, Nov 23, 2018 at 06:40:59PM +0000, Marc Zyngier wrote:
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

With James' ISB comments addressed, this looks pretty good to me. What's
your plan for merging it? It's definitely going to conflict with the
arm64 patch queue and last time that happened Paolo got irritated with us.

Will
