From: Julien Grall <Julien.Grall@arm.com>
Subject: Re: [PATCH 06/14] KVM: arm/arm64: Factor out VMID into struct kvm_vmid
Date: Thu, 21 Feb 2019 11:02:56 +0000
Message-ID: <1978ee57-c7bd-e55a-4e77-ad0b4b62d1d1@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-7-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 900D64A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Feb 2019 06:03:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0DK8auabTwnu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Feb 2019 06:03:00 -0500 (EST)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20049.outbound.protection.outlook.com [40.107.2.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4DB84A200
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Feb 2019 06:02:59 -0500 (EST)
In-Reply-To: <20190124140032.8588-7-christoffer.dall@arm.com>
Content-Language: en-US
Content-ID: <7E8DC60B4CA826488988D8D2B3C89E0B@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <Christoffer.Dall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, nd <nd@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 24/01/2019 14:00, Christoffer Dall wrote:
> Note that to avoid mapping the kvm_vmid_bits variable into hyp, we
> simply forego the masking of the vmid value in kvm_get_vttbr and rely on
> update_vmid to always assign a valid vmid value (within the supported
> range).

[...]

> -	kvm->arch.vmid = kvm_next_vmid;
> +	vmid->vmid = kvm_next_vmid;
>   	kvm_next_vmid++;
> -	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
> -
> -	/* update vttbr to be used with the new vmid */
> -	pgd_phys = virt_to_phys(kvm->arch.pgd);
> -	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));
> -	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
> -	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid | cnp;
> +	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;

The arm64 version of kvm_get_vmid_bits does not look cheap. Indeed it required 
to read the sanitized value of SYS_ID_AA64MMFR1_EL1 that is implemented using 
the function bsearch.

So wouldn't it be better to keep kvm_vmid_bits variable for use in update_vttbr()?

Cheers,

-- 
Julien Grall
