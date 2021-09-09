Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2437C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 10:18:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 039186113A
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 10:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 039186113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F71B4B08B;
	Thu,  9 Sep 2021 06:18:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b8l15vFM8HnU; Thu,  9 Sep 2021 06:18:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3FF4B0BD;
	Thu,  9 Sep 2021 06:18:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2D64B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 06:18:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yOS17J5Pb27o for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 06:18:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C03B4B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 06:18:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BF7F31B;
 Thu,  9 Sep 2021 03:18:52 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 476013F73D;
 Thu,  9 Sep 2021 03:18:50 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 eric.auger@redhat.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
Date: Thu, 9 Sep 2021 11:20:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210908210320.1182303-2-ricarkol@google.com>
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Hi Ricardo,

On 9/8/21 10:03 PM, Ricardo Koller wrote:
> Extend vgic_v3_check_base() to verify that the redistributor regions
> don't go above the VM-specified IPA size (phys_size). This can happen
> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
>
>   base + size > phys_size AND base < phys_size
>
> vgic_v3_check_base() is used to check the redist regions bases when
> setting them (with the vcpus added so far) and when attempting the first
> vcpu-run.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 66004f61cd83..5afd9f6f68f6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>  			rdreg->base)
>  			return false;
> +
> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> +			kvm_phys_size(kvm))
> +			return false;

Looks to me like this same check (and the overflow one before it) is done when
adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
-> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
kvm_vgic_addr() handles both ways of setting the Redistributor address.

Without this patch, did you manage to set a base address such that base + size >
kvm_phys_size()?

Thanks,

Alex

>  	}
>  
>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
