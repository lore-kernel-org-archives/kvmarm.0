From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 18/21] KVM: arm64: Handle RAS SErrors from EL1 on guest
 exit
Date: Tue, 31 Oct 2017 05:55:19 +0000
Message-ID: <867evb50ag.fsf@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-19-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE28549D14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 01:53:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id daHDIg4KTpQs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 01:53:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08B9041185
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 01:53:52 -0400 (EDT)
In-Reply-To: <20171019145807.23251-19-james.morse@arm.com> (James Morse's
 message of "Thu, 19 Oct 2017 15:58:04 +0100")
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
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 19 2017 at  4:58:04 pm BST, James Morse <james.morse@arm.com> wrote:
> We expect to have firmware-first handling of RAS SErrors, with errors
> notified via an APEI method. For systems without firmware-first, add
> some minimal handling to KVM.
>
> There are two ways KVM can take an SError due to a guest, either may be a
> RAS error: we exit the guest due to an SError routed to EL2 by HCR_EL2.AMO,
> or we take an SError from EL2 when we unmask PSTATE.A from __guest_exit.
>
> For SError that interrupt a guest and are routed to EL2 the existing
> behaviour is to inject an impdef SError into the guest.
>
> Add code to handle RAS SError based on the ESR. For uncontained errors
> arm64_is_blocking_ras_serror() will panic(), these errors compromise
> the host too. All other error types are contained: For the 'blocking'
> errors the vCPU can't make progress, so we inject a virtual SError.
> We ignore contained errors where we can make progress as if we're lucky,
> we may not hit them again.
>
> Signed-off-by: James Morse <james.morse@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
