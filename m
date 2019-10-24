Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8425CA9EBC
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 08:08:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A06A20684
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 08:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A06A20684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kaod.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FB9C4A847;
	Thu, 24 Oct 2019 04:08:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2QXiYBwrT2fj; Thu, 24 Oct 2019 04:08:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7214A7D7;
	Thu, 24 Oct 2019 04:08:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11AE24A659
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 03:06:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N9SoSwAbGUbt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 03:06:18 -0400 (EDT)
Received: from 3.mo178.mail-out.ovh.net (3.mo178.mail-out.ovh.net
 [46.105.44.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6C6D4A555
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 03:06:17 -0400 (EDT)
Received: from player737.ha.ovh.net (unknown [10.108.35.27])
 by mo178.mail-out.ovh.net (Postfix) with ESMTP id C3D1D7C318
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 09:06:16 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net
 [82.253.208.248]) (Authenticated sender: groug@kaod.org)
 by player737.ha.ovh.net (Postfix) with ESMTPSA id DFAA11E5A0F5;
 Thu, 24 Oct 2019 07:05:28 +0000 (UTC)
Date: Thu, 24 Oct 2019 09:05:27 +0200
From: Greg Kurz <groug@kaod.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 02/45] KVM: PPC: Book3S PR: Free shared page if mmu
 initialization fails
Message-ID: <20191024090527.6b73a3bc@bahia.lan>
In-Reply-To: <20191022015925.31916-3-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
 <20191022015925.31916-3-sean.j.christopherson@intel.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Ovh-Tracer-Id: 5577708138938931537
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrledtgdduudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
X-Mailman-Approved-At: Thu, 24 Oct 2019 04:08:10 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 James Hogan <jhogan@kernel.org>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 21 Oct 2019 18:58:42 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Explicitly free the shared page if kvmppc_mmu_init() fails during
> kvmppc_core_vcpu_create(), as the page is freed only in
> kvmppc_core_vcpu_free(), which is not reached via kvm_vcpu_uninit().
> 
> Fixes: 96bc451a15329 ("KVM: PPC: Introduce shared page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_pr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index cc65af8fe6f7..3f6ad3f58628 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -1769,10 +1769,12 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
>  
>  	err = kvmppc_mmu_init(vcpu);
>  	if (err < 0)
> -		goto uninit_vcpu;
> +		goto free_shared_page;
>  
>  	return vcpu;
>  
> +free_shared_page:
> +	free_page((unsigned long)vcpu->arch.shared);
>  uninit_vcpu:
>  	kvm_vcpu_uninit(vcpu);
>  free_shadow_vcpu:

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
