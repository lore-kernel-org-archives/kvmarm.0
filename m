From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 08/16] arm/pci: Do not use first PCI IO space
 bytes for devices
Date: Fri, 5 Apr 2019 16:31:27 +0100
Message-ID: <20190405163127.4b10a581@donnerap.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-9-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6069E4A331
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 11:31:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bGdSG8352ke9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 11:31:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3754A332
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 11:31:33 -0400 (EDT)
In-Reply-To: <1551947777-13044-9-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 7 Mar 2019 08:36:09 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

Hi,

> Linux has this convention that the lower 0x1000 bytes of the IO space
> should not be used. (cf PCIBIOS_MIN_IO).
> 
> Just allocate those bytes to prevent future allocation assigning it to
> devices.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> ---
>  arm/pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/pci.c b/arm/pci.c
> index 83238ca..559e0cf 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -37,6 +37,9 @@ void pci__arm_init(struct kvm *kvm)
>  
>  	/* Make PCI port allocation start at a properly aligned address */
>  	pci_get_io_space_block(align_pad);
> +
> +	/* Convention, don't allocate first 0x1000 bytes of PCI IO */
> +	pci_get_io_space_block(0x1000);

Is this the same problem with mixing up I/O and MMIO space as in the other patch?
io_space means MMIO, right?

Cheers,
Andre.

>  }
>  
>  void pci__generate_fdt_nodes(void *fdt)
