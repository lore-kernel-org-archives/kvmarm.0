From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] arm/arm64: KVM: Allow a VCPU to fully reset itself
Date: Mon, 4 Feb 2019 16:15:01 +0100
Message-ID: <20190204151501.mebefojnm6rhyg6v@kamzik.brq.redhat.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-3-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F205A4A39E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 10:15:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id itU7exPxmyWL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 10:15:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 314A74A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 10:15:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190125094656.5026-3-christoffer.dall@arm.com>
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

On Fri, Jan 25, 2019 at 10:46:53AM +0100, Christoffer Dall wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> The current kvm_psci_vcpu_on implementation will directly try to
> manipulate the state of the VCPU to reset it.  However, since this is
> not done on the thread that runs the VCPU, we can end up in a strangely
> corrupted state when the source and target VCPUs are running at the same
> time.
> 
> Fix this by factoring out all reset logic from the PSCI implementation
> and forwarding the required information along with a request to the
> target VCPU.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 10 +++++++++
>  arch/arm/kvm/reset.c              | 24 +++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++++
>  arch/arm64/kvm/reset.c            | 24 +++++++++++++++++++++
>  virt/kvm/arm/arm.c                | 10 +++++++++
>  virt/kvm/arm/psci.c               | 36 ++++++++++++++-----------------
>  6 files changed, 95 insertions(+), 20 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>
