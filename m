From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Update MAINTAINERS entries
Date: Fri, 15 Feb 2019 17:26:13 +0000
Message-ID: <a3a433a9-0e28-08ed-c02f-7b241ebb9652@arm.com>
References: <20190212110648.177490-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B659D49E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 12:26:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lF7hLOgtPTzp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Feb 2019 12:26:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C14A40493
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 12:26:17 -0500 (EST)
In-Reply-To: <20190212110648.177490-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 12/02/2019 11:06, Marc Zyngier wrote:
> For historical reasons, KVM/arm and KVM/arm64 have had different
> entries in the MAINTAINER file. This makes little sense, as they are
> maintained together.
> 
> On top of that, we have a bunch of talented people helping with
> the reviewing, and they deserve to be mentionned in the consolidated

(mentioned)

> entry.


> diff --git a/MAINTAINERS b/MAINTAINERS
> index 51029a425dbe..91ec0682443b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8297,29 +8297,25 @@ S:	Maintained
>  F:	arch/x86/include/asm/svm.h
>  F:	arch/x86/kvm/svm.c
>  
> -KERNEL VIRTUAL MACHINE FOR ARM (KVM/arm)
> +KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
>  M:	Christoffer Dall <christoffer.dall@arm.com>
>  M:	Marc Zyngier <marc.zyngier@arm.com>
> +R:	James Morse <james.morse@arm.com>

Acked-by: James Morse <james.morse@arm.com>


Thanks,

James
