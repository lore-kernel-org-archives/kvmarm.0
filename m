From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH] vfio-pci: Fix MSI IRQ forwarding for without per-vector
 masking
Date: Mon, 8 Apr 2019 09:34:42 +0800
Message-ID: <20190408013442.GA10011@leoy-ThinkPad-X240s>
References: <20190322052308.28254-1-leo.yan@linaro.org>
 <20190322052924.GB31904@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CF7C4A331
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:34:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NOtrsePlpeYV for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:34:50 -0400 (EDT)
Received: from mail-yw1-f65.google.com (mail-yw1-f65.google.com
 [209.85.161.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 393AF4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:34:50 -0400 (EDT)
Received: by mail-yw1-f65.google.com with SMTP id j66so4360651ywc.10
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:34:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190322052924.GB31904@leoy-ThinkPad-X240s>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <robin.murphy@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On Fri, Mar 22, 2019 at 01:29:24PM +0800, Leo Yan wrote:
> On Fri, Mar 22, 2019 at 01:23:08PM +0800, Leo Yan wrote:
> > If MSI doesn't support per-vector masking capability and
> > PCI_MSI_FLAGS_MASKBIT isn't set in message control field, the function
> > vfio_pci_msi_vector_write() will directly bail out for this case and
> > every vector's 'virt_state' keeps setting bit VFIO_PCI_MSI_STATE_MASKED.
> > 
> > This results in the state maintained in 'virt_state' cannot really
> > reflect the MSI hardware state; finally it will mislead the function
> > vfio_pci_update_msi_entry() to skip IRQ forwarding with below flow:
> > 
> > vfio_pci_update_msi_entry() {
> > 
> >   [...]
> > 
> >   if (msi_is_masked(entry->virt_state) == msi_is_masked(entry->phys_state))
> >       return 0;  ==> skip IRQ forwarding
> > 
> >   [...]
> > }
> > 
> > To fix this issue, when detect PCI_MSI_FLAGS_MASKBIT is not set in the
> > message control field, this patch simply clears bit
> > VFIO_PCI_MSI_STATE_MASKED for all vectors 'virt_state'; at the end
> > vfio_pci_update_msi_entry() can forward MSI IRQ successfully.
> 
> Just remind, this patch is for kvmtool but not for kernel.  Sorry I
> forget to add it in subject.

Gentle ping.  Not sure if this patch is reasonable, could you help to
give a review?

[...]

Thanks,
Leo Yan
