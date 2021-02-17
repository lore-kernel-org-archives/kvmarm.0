Return-Path: <SRS0=BQox=HT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0413BC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 16:47:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E45864E45
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 16:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E45864E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 091F54B36B;
	Wed, 17 Feb 2021 11:47:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iKBv49dhAsVg; Wed, 17 Feb 2021 11:47:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A1D4B2FB;
	Wed, 17 Feb 2021 11:47:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FAD4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 11:47:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ij2TFlqXz9hy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2021 11:47:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A5914B2C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 11:47:52 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C986DED1;
 Wed, 17 Feb 2021 08:47:51 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B1E53F73B;
 Wed, 17 Feb 2021 08:47:50 -0800 (PST)
Date: Wed, 17 Feb 2021 16:46:47 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 01/21] ioport: Remove ioport__setup_arch()
Message-ID: <20210217155459.3a4bc991@slackpad.fritz.box>
In-Reply-To: <111b6cd6-ddf3-ec67-b782-67120be97943@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-2-andre.przywara@arm.com>
 <814e0cd9-5e54-fade-f05c-80ea2b4a9039@arm.com>
 <20210211171648.36000cce@slackpad.fritz.box>
 <111b6cd6-ddf3-ec67-b782-67120be97943@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, 11 Feb 2021 17:32:01 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> On 2/11/21 5:16 PM, Andre Przywara wrote:
> > On Wed, 10 Feb 2021 17:44:59 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > Hi Alex,
> >  
> >> On 12/10/20 2:28 PM, Andre Przywara wrote:  
> >>> Since x86 had a special need for registering tons of special I/O ports,
> >>> we had an ioport__setup_arch() callback, to allow each architecture
> >>> to do the same. As it turns out no one uses it beside x86, so we remove
> >>> that unnecessary abstraction.
> >>>
> >>> The generic function was registered via a device_base_init() call, so
> >>> we just do the same for the x86 specific function only, and can remove
> >>> the unneeded ioport__setup_arch().
> >>>
> >>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>> ---
> >>>  arm/ioport.c         |  5 -----
> >>>  include/kvm/ioport.h |  1 -
> >>>  ioport.c             | 28 ----------------------------
> >>>  mips/kvm.c           |  5 -----
> >>>  powerpc/ioport.c     |  6 ------
> >>>  x86/ioport.c         | 25 ++++++++++++++++++++++++-
> >>>  6 files changed, 24 insertions(+), 46 deletions(-)
> >>>
> >>> diff --git a/arm/ioport.c b/arm/ioport.c
> >>> index 2f0feb9a..24092c9d 100644
> >>> --- a/arm/ioport.c
> >>> +++ b/arm/ioport.c
> >>> @@ -1,11 +1,6 @@
> >>>  #include "kvm/ioport.h"
> >>>  #include "kvm/irq.h"
> >>>  
> >>> -int ioport__setup_arch(struct kvm *kvm)
> >>> -{
> >>> -	return 0;
> >>> -}
> >>> -
> >>>  void ioport__map_irq(u8 *irq)
> >>>  {
> >>>  	*irq = irq__alloc_line();
> >>> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
> >>> index 039633f7..d0213541 100644
> >>> --- a/include/kvm/ioport.h
> >>> +++ b/include/kvm/ioport.h
> >>> @@ -35,7 +35,6 @@ struct ioport_operations {
> >>>  							    enum irq_type));
> >>>  };
> >>>  
> >>> -int ioport__setup_arch(struct kvm *kvm);
> >>>  void ioport__map_irq(u8 *irq);
> >>>  
> >>>  int __must_check ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops,
> >>> diff --git a/ioport.c b/ioport.c
> >>> index 844a832d..667e8386 100644
> >>> --- a/ioport.c
> >>> +++ b/ioport.c
> >>> @@ -158,21 +158,6 @@ int ioport__unregister(struct kvm *kvm, u16 port)
> >>>  	return 0;
> >>>  }
> >>>  
> >>> -static void ioport__unregister_all(void)
> >>> -{
> >>> -	struct ioport *entry;
> >>> -	struct rb_node *rb;
> >>> -	struct rb_int_node *rb_node;
> >>> -
> >>> -	rb = rb_first(&ioport_tree);
> >>> -	while (rb) {
> >>> -		rb_node = rb_int(rb);
> >>> -		entry = ioport_node(rb_node);
> >>> -		ioport_unregister(&ioport_tree, entry);
> >>> -		rb = rb_first(&ioport_tree);
> >>> -	}
> >>> -}    
> >> I get the impression this is a rebasing artifact. The commit message doesn't
> >> mention anything about removing ioport__exit() -> ioport__unregister_all(), and as
> >> far as I can tell it's still needed because there are places other than
> >> ioport__setup_arch() from where ioport__register() is called.  
> > I agree that the commit message is a bit thin on this fact, but the
> > functionality of ioport__unregister_all() is now in
> > x86/ioport.c:ioport__remove_arch(). I think removing ioport__init()
> > without removing ioport__exit() as well would look very weird, if not
> > hackish.  
> 
> Not necessarily. ioport__unregister_all() removes the ioports added by
> x86/ioport.c::ioport__setup_arch(), *plus* ioports added by different devices,
> like serial, rtc, virtio-pci and vfio-pci (which are used by arm/arm64).

Right, indeed. Not that it really matters, since we are about to exit
anyway, but it looks indeed I need to move this to a generic teardown
method, or actually just keep that part here in this file.

Will give this a try.

Thanks!
Andre

> >
> > I can amend the commit message to mention this, or is there anything
> > else I missed?
> >
> > Cheers,
> > Andre
> >  
> >>> -
> >>>  static const char *to_direction(int direction)
> >>>  {
> >>>  	if (direction == KVM_EXIT_IO_IN)
> >>> @@ -220,16 +205,3 @@ out:
> >>>  
> >>>  	return !kvm->cfg.ioport_debug;
> >>>  }
> >>> -
> >>> -int ioport__init(struct kvm *kvm)
> >>> -{
> >>> -	return ioport__setup_arch(kvm);
> >>> -}
> >>> -dev_base_init(ioport__init);
> >>> -
> >>> -int ioport__exit(struct kvm *kvm)
> >>> -{
> >>> -	ioport__unregister_all();
> >>> -	return 0;
> >>> -}
> >>> -dev_base_exit(ioport__exit);
> >>> diff --git a/mips/kvm.c b/mips/kvm.c
> >>> index 26355930..e110e5d5 100644
> >>> --- a/mips/kvm.c
> >>> +++ b/mips/kvm.c
> >>> @@ -100,11 +100,6 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
> >>>  		die_perror("KVM_IRQ_LINE ioctl");
> >>>  }
> >>>  
> >>> -int ioport__setup_arch(struct kvm *kvm)
> >>> -{
> >>> -	return 0;
> >>> -}
> >>> -
> >>>  bool kvm__arch_cpu_supports_vm(void)
> >>>  {
> >>>  	return true;
> >>> diff --git a/powerpc/ioport.c b/powerpc/ioport.c
> >>> index 0c188b61..a5cff4ee 100644
> >>> --- a/powerpc/ioport.c
> >>> +++ b/powerpc/ioport.c
> >>> @@ -12,12 +12,6 @@
> >>>  
> >>>  #include <stdlib.h>
> >>>  
> >>> -int ioport__setup_arch(struct kvm *kvm)
> >>> -{
> >>> -	/* PPC has no legacy ioports to set up */
> >>> -	return 0;
> >>> -}
> >>> -
> >>>  void ioport__map_irq(u8 *irq)
> >>>  {
> >>>  }
> >>> diff --git a/x86/ioport.c b/x86/ioport.c
> >>> index 7ad7b8f3..8c5c7699 100644
> >>> --- a/x86/ioport.c
> >>> +++ b/x86/ioport.c
> >>> @@ -69,7 +69,7 @@ void ioport__map_irq(u8 *irq)
> >>>  {
> >>>  }
> >>>  
> >>> -int ioport__setup_arch(struct kvm *kvm)
> >>> +static int ioport__setup_arch(struct kvm *kvm)
> >>>  {
> >>>  	int r;
> >>>  
> >>> @@ -150,3 +150,26 @@ int ioport__setup_arch(struct kvm *kvm)
> >>>  
> >>>  	return 0;
> >>>  }
> >>> +dev_base_init(ioport__setup_arch);
> >>> +
> >>> +static int ioport__remove_arch(struct kvm *kvm)
> >>> +{
> >>> +	ioport__unregister(kvm, 0x510);
> >>> +	ioport__unregister(kvm, 0x402);
> >>> +	ioport__unregister(kvm, 0x03D5);
> >>> +	ioport__unregister(kvm, 0x03D4);
> >>> +	ioport__unregister(kvm, 0x0378);
> >>> +	ioport__unregister(kvm, 0x0278);
> >>> +	ioport__unregister(kvm, 0x00F0);
> >>> +	ioport__unregister(kvm, 0x00ED);
> >>> +	ioport__unregister(kvm, IOPORT_DBG);
> >>> +	ioport__unregister(kvm, 0x00C0);
> >>> +	ioport__unregister(kvm, 0x00A0);
> >>> +	ioport__unregister(kvm, 0x0092);
> >>> +	ioport__unregister(kvm, 0x0040);
> >>> +	ioport__unregister(kvm, 0x0020);
> >>> +	ioport__unregister(kvm, 0x0000);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +dev_base_exit(ioport__remove_arch);    

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
