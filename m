From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: arm/arm64: Move to common kvm_mmu_memcache
 infrastructure
Date: Fri, 15 Mar 2019 18:36:19 +0100
Message-ID: <f33a09ad-0540-2557-a0bf-a14245656c82@redhat.com>
References: <20190131095244.7480-1-christoffer.dall@arm.com>
 <20190131095244.7480-4-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 203114A481
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 13:36:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h30OP4RUqWTU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 13:36:29 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47DF24A430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 13:36:29 -0400 (EDT)
In-Reply-To: <20190131095244.7480-4-christoffer.dall@arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Paul Mackerras <paulus@ozlabs.org>, Christian Borntraeger <borntraeger@de.ibm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 31/01/19 10:52, Christoffer Dall wrote:
> +#define KVM_MMU_CACHE_GFP	GFP_KERNEL
> +#define KVM_MMU_CACHE_PAGE_GFP	(GFP_KERNEL | __GFP_ZERO)

This should be GFP_KERNEL_ACCOUNT.  Can you leave GFP_KERNEL_ACCOUNT in
virt/kvm/kvm_main.c, and only use these #defines to add __GFP_ZERO?  I
don't think anyone should be using GFP_ATOMIC for instance.

Paolo
