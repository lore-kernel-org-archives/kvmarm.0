From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/3] irq: move IRQ routing into irq.c
Date: Wed, 2 Mar 2016 00:37:02 +0000
Message-ID: <20160302003702.GD14022@arm.com>
References: <1456850978-14091-1-git-send-email-andre.przywara@arm.com>
 <1456850978-14091-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBE9941145
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 19:29:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9HKqJ5dS4gGK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 19:29:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69913410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 19:29:44 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1456850978-14091-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <sasha.levin@oracle.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On Tue, Mar 01, 2016 at 04:49:36PM +0000, Andre Przywara wrote:
> The current IRQ routing code in x86/irq.c is mostly implementing a
> generic KVM interface which other architectures may use too.
> Move the code to set up an MSI route into the generic irq.c file and
> guard it with the KVM_CAP_IRQ_ROUTING capability to return an error
> if the kernel does not support interrupt routing.
> This also removes the dummy implementations for all other
> architectures and only leaves the x86 specific code in x86/irq.c.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Makefile          |  4 +--
>  arm/irq.c         |  9 ------
>  hw/pci-shmem.c    |  2 ++
>  include/kvm/irq.h |  5 ++++
>  irq.c             | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mips/irq.c        | 10 -------
>  powerpc/irq.c     | 31 ---------------------
>  virtio/pci.c      | 18 ++++++++----
>  x86/irq.c         | 45 ++++--------------------------
>  9 files changed, 108 insertions(+), 99 deletions(-)
>  delete mode 100644 arm/irq.c
>  delete mode 100644 mips/irq.c
>  delete mode 100644 powerpc/irq.c

[...]

> diff --git a/x86/irq.c b/x86/irq.c
> index 72177e7..49b2e90 100644
> --- a/x86/irq.c
> +++ b/x86/irq.c
> @@ -11,20 +11,15 @@
>  #include <stddef.h>
>  #include <stdlib.h>
>  
> -#define IRQ_MAX_GSI			64
>  #define IRQCHIP_MASTER			0
>  #define IRQCHIP_SLAVE			1
>  #define IRQCHIP_IOAPIC			2
>  
> -/* First 24 GSIs are routed between IRQCHIPs and IOAPICs */
> -static u32 gsi = 24;
> -
> -struct kvm_irq_routing *irq_routing;
> -
>  static int irq__add_routing(u32 gsi, u32 type, u32 irqchip, u32 pin)
>  {
> -	if (gsi >= IRQ_MAX_GSI)
> -		return -ENOSPC;
> +	int r = irq__allocate_routing_entry();
> +	if (r)
> +		return r;
>  
>  	irq_routing->entries[irq_routing->nr++] =
>  		(struct kvm_irq_routing_entry) {
> @@ -41,11 +36,6 @@ int irq__init(struct kvm *kvm)
>  {
>  	int i, r;
>  
> -	irq_routing = calloc(sizeof(struct kvm_irq_routing) +
> -			IRQ_MAX_GSI * sizeof(struct kvm_irq_routing_entry), 1);
> -	if (irq_routing == NULL)
> -		return -ENOMEM;
> -
>  	/* Hook first 8 GSIs to master IRQCHIP */
>  	for (i = 0; i < 8; i++)
>  		if (i != 2)
> @@ -69,33 +59,8 @@ int irq__init(struct kvm *kvm)
>  		return errno;
>  	}
>  
> -	return 0;
> -}
> -dev_base_init(irq__init);
> +	next_gsi = 24;

Can we not just have an arch-specific initialiser that defaults to zero,
like we do for wired interrupts? (e.g. KVM_MSI_OFFSET). That way, we can
keep next_gsi private to the common irq routing code.

Will
