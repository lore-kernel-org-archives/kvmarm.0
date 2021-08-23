Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B85C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 16:48:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07EA0613B1
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 16:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07EA0613B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B93E4B154;
	Mon, 23 Aug 2021 12:48:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SY7M9HbJ970X; Mon, 23 Aug 2021 12:48:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C55E4B15A;
	Mon, 23 Aug 2021 12:48:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFBB34B15A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 12:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GbPC13O6pNyB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 12:48:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 007D34B154
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 12:48:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 434E011D4;
 Mon, 23 Aug 2021 09:48:44 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29AD53F5A1;
 Mon, 23 Aug 2021 09:48:43 -0700 (PDT)
Date: Mon, 23 Aug 2021 17:48:33 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH][kvmtool] virtio/pci: Correctly handle MSI-X masking
 while MSI-X is disabled
Message-ID: <20210823174833.05adee5d@slackpad.fritz.box>
In-Reply-To: <20210821120742.855712-1-maz@kernel.org>
References: <20210821120742.855712-1-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Sat, 21 Aug 2021 13:07:42 +0100
Marc Zyngier <maz@kernel.org> wrote:

Hi Marc,

> Since Linux commit 7d5ec3d36123 ("PCI/MSI: Mask all unused MSI-X
> entries"), kvmtool segfaults when the guest boots and tries to
> disable all the MSI-X entries of a virtio device while MSI-X itself
> is disabled.
> 
> What Linux does is seems perfectly correct. However, kvmtool uses
> a different decoding depending on whether MSI-X is enabled for
> this device or not. Which seems pretty wrong.

While I really wish this would be wrong, I think this is
indeed how this is supposed to work: The Virtio legacy spec makes the
existence of those two virtio config fields dependent on the
(dynamic!) enablement status of MSI-X. This is reflected in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/virtio_pci.h#n72
and explicitly mentioned as a footnote in the virtio 0.9.5 spec[1]:
"3) ie. once you enable MSI-X on the device, the other fields move. If
you turn it off again, they move back!"

I agree that this looks like a bad idea, but I am afraid we are stuck
with this. It looks like the Linux driver is at fault here, it should
not issue the config access when MSIs are disabled. Something like this
(untested):

--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -103,6 +103,9 @@ static void vp_reset(struct virtio_device *vdev)
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 {
+       if (!vp_dev->msix_enabled)
+               return VIRTIO_MSI_NO_VECTOR;
+
        /* Setup the vector used for configuration events */
        iowrite16(vector, vp_dev->ioaddr + VIRTIO_MSI_CONFIG_VECTOR);
        /* Verify we had enough resources to assign the vector */

This is just my first idea after looking at this, happy to stand
corrected or hear about a better solution.

Cheers,
Andre

[1] https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf

> Cure the problem by removing the check against MSI-X being enabled,
> and simplify the whole logic which looked a bit odd. With this,
> Linux is back booting as a kvmtool guest with MSI-X.
> 
> Cc: Andre Przywara <Andre.Przywara@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/kvm/virtio.h |  2 +-
>  virtio/core.c        | 12 ++++--------
>  virtio/pci.c         |  7 ++-----
>  3 files changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 3a311f54..7047d36f 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -166,7 +166,7 @@ u16 virt_queue__get_head_iov(struct virt_queue *vq, struct iovec iov[],
>  u16 virt_queue__get_inout_iov(struct kvm *kvm, struct virt_queue *queue,
>  			      struct iovec in_iov[], struct iovec out_iov[],
>  			      u16 *in, u16 *out);
> -int virtio__get_dev_specific_field(int offset, bool msix, u32 *config_off);
> +int virtio__get_dev_specific_field(int offset, u32 *config_off);
>  
>  enum virtio_trans {
>  	VIRTIO_PCI,
> diff --git a/virtio/core.c b/virtio/core.c
> index 90a661d1..afb09e90 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -169,16 +169,12 @@ void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
>  	memset(vq, 0, sizeof(*vq));
>  }
>  
> -int virtio__get_dev_specific_field(int offset, bool msix, u32 *config_off)
> +int virtio__get_dev_specific_field(int offset, u32 *config_off)
>  {
> -	if (msix) {
> -		if (offset < 4)
> -			return VIRTIO_PCI_O_MSIX;
> -		else
> -			offset -= 4;
> -	}
> +	if (offset < 24)
> +		return VIRTIO_PCI_O_MSIX;
>  
> -	*config_off = offset;
> +	*config_off = offset - 24;
>  
>  	return VIRTIO_PCI_O_CONFIG;
>  }
> diff --git a/virtio/pci.c b/virtio/pci.c
> index eb91f512..2a6e41f1 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -112,9 +112,7 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
>  {
>  	u32 config_offset;
>  	struct virtio_pci *vpci = vdev->virtio;
> -	int type = virtio__get_dev_specific_field(offset - 20,
> -							virtio_pci__msix_enabled(vpci),
> -							&config_offset);
> +	int type = virtio__get_dev_specific_field(offset, &config_offset);
>  	if (type == VIRTIO_PCI_O_MSIX) {
>  		switch (offset) {
>  		case VIRTIO_MSI_CONFIG_VECTOR:
> @@ -208,8 +206,7 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
>  	struct virtio_pci *vpci = vdev->virtio;
>  	u32 config_offset, vec;
>  	int gsi;
> -	int type = virtio__get_dev_specific_field(offset - 20, virtio_pci__msix_enabled(vpci),
> -							&config_offset);
> +	int type = virtio__get_dev_specific_field(offset, &config_offset);
>  	if (type == VIRTIO_PCI_O_MSIX) {
>  		switch (offset) {
>  		case VIRTIO_MSI_CONFIG_VECTOR:

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
