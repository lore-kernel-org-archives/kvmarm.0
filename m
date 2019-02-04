From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Mon, 4 Feb 2019 16:15:58 +0100
Message-ID: <20190204151558.44tkfko3xh36ojbf@kamzik.brq.redhat.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-2-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5382E4A39F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 10:16:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0l2XwimyfxVn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 10:16:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8985D4A2BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 10:16:03 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190125094656.5026-2-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 25, 2019 at 10:46:52AM +0100, Christoffer Dall wrote:
> Resetting the VCPU state modifies the system register state in memory,
> but this may interact with vcpu_load/vcpu_put if running with preemption
> disabled, which in turn may lead to corrupted system register state.
> 
> Address this by disabling preemption and doing put/load if required
> around the reset logic.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/reset.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>

I believe this should come after the next patch, but anyway

Reviewed-by: Andrew Jones <drjones@redhat.com>
