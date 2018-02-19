From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 03/40] KVM: arm64: Avoid storing the vcpu pointer on
 the stack
Date: Mon, 19 Feb 2018 15:50:20 +0000
Message-ID: <d00629e8-da68-a536-dc22-b8c26e962b85@arm.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1120149DE1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 10:44:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xze0dCEZnj0a for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Feb 2018 10:43:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4144030D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 10:43:56 -0500 (EST)
In-Reply-To: <20180215210332.8648-4-christoffer.dall@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 15/02/18 21:02, Christoffer Dall wrote:
> We already have the percpu area for the host cpu state, which points to
> the VCPU, so there's no need to store the VCPU pointer on the stack on
> every context switch.  We can be a little more clever and just use
> tpidr_el2 for the percpu offset and load the VCPU pointer from the host
> context.
> 
> This does require us to calculate the percpu offset without including
> the offset from the kernel mapping of the percpu array to the linear
> mapping of the array (which is what we store in tpidr_el1), because a
> PC-relative generated address in EL2 is already giving us the hyp alias
> of the linear mapping of a kernel address.  We do this in
> __cpu_init_hyp_mode() by using kvm_ksym_ref().
> 
> This change also requires us to have a scratch register, so we take the
> chance to rearrange some of the el1_sync code to only look at the
> vttbr_el2 to determine if this is a trap from the guest or an HVC from
> the host.  We do add an extra check to call the panic code if the kernel
> is configured with debugging enabled and we saw a trap from the host
> which wasn't an HVC, indicating that we left some EL2 trap configured by
> mistake.

You might want to remove this paragraph as you don't seem to have rework 
that part of the code in this version.

Cheers,

-- 
Julien Grall
