Return-Path: <SRS0=4kLF=SM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA3EC10F14
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 12:43:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBD0A20818
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 12:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBD0A20818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 753E84A481;
	Wed, 10 Apr 2019 08:43:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bCLneqPzH7yc; Wed, 10 Apr 2019 08:43:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 167EC4A422;
	Wed, 10 Apr 2019 08:43:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 075254A422
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:42:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iY-q6K-q4M6B for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 08:42:57 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA2FF4A36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:42:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29532EBD;
 Wed, 10 Apr 2019 05:42:57 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E97403F59C;
 Wed, 10 Apr 2019 05:42:55 -0700 (PDT)
Subject: Re: [PATCH] vfio-pci: Fix MSI IRQ forwarding for without per-vector
 masking
To: Leo Yan <leo.yan@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Will Deacon <Will.Deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Robin Murphy <Robin.Murphy@arm.com>
References: <20190322052308.28254-1-leo.yan@linaro.org>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <f0ae4e4e-34f1-251e-093c-7950501d4866@arm.com>
Date: Wed, 10 Apr 2019 13:42:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190322052308.28254-1-leo.yan@linaro.org>
Content-Language: en-US
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190410124234.6FOU0-gWKcA3ejWgnar1VtdcfumrIzRQQ9J9K6xcvDk@z>

Hi Leo,

On 22/03/2019 05:23, Leo Yan wrote:
> If MSI doesn't support per-vector masking capability and
> PCI_MSI_FLAGS_MASKBIT isn't set in message control field, the function
> vfio_pci_msi_vector_write() will directly bail out for this case and
> every vector's 'virt_state' keeps setting bit VFIO_PCI_MSI_STATE_MASKED.
> 
> This results in the state maintained in 'virt_state' cannot really
> reflect the MSI hardware state; finally it will mislead the function
> vfio_pci_update_msi_entry() to skip IRQ forwarding with below flow:
> 
> vfio_pci_update_msi_entry() {
> 
>   [...]
> 
>   if (msi_is_masked(entry->virt_state) == msi_is_masked(entry->phys_state))
>       return 0;  ==> skip IRQ forwarding
> 
>   [...]
> }
> 
> To fix this issue, when detect PCI_MSI_FLAGS_MASKBIT is not set in the
> message control field, this patch simply clears bit
> VFIO_PCI_MSI_STATE_MASKED for all vectors 'virt_state'; at the end
> vfio_pci_update_msi_entry() can forward MSI IRQ successfully.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  vfio/pci.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index ba971eb..4fd24ac 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -363,8 +363,18 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
>  	struct vfio_pci_device *pdev = &vdev->pci;
>  	struct msi_cap_64 *msi_cap_64 = PCI_CAP(&pdev->hdr, pdev->msi.pos);
>  
> -	if (!(msi_cap_64->ctrl & PCI_MSI_FLAGS_MASKBIT))
> +	if (!(msi_cap_64->ctrl & PCI_MSI_FLAGS_MASKBIT)) {
> +		/*
> +		 * If MSI doesn't support per-vector masking capability,
> +		 * simply unmask for all vectors.
> +		 */
> +		for (i = 0; i < pdev->msi.nr_entries; i++) {
> +			entry = &pdev->msi.entries[i];
> +			msi_set_masked(entry->virt_state, false);
> +		}
> +

This seems like the wrong place for this fix.
vfio_pci_msi_vector_write() is called every time the guest pokes the MSI
capability, and checks whether the access was on the Mask Bits Register.
If the function doesn't support per-vector masking, then the register
isn't implemented and we shouldn't do anything here.

To fix the problem I think we need to set masked(virt_state) properly at
init time, instead of blindly setting it to true. In fact from the
guest's point of view, MSIs and MSI-X are unmasked (and disabled) at
boot, so you could always set masked(virt_state) to false, but it may be
safer to copy the actual state of the MSI's Mask Bits into virt_state,
since for MSI, it could be non zero. If per-vector masking isn't
supported, then the virt state should be false.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
