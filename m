From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 01/16] Makefile: Only compile vesa for archs
 that need it
Date: Thu, 4 Apr 2019 14:43:09 +0100
Message-ID: <20190404144309.0b801fbe@donnerap.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2E74A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:43:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PFg6nZvfmFON for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 09:43:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CABA4A332
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 09:43:15 -0400 (EDT)
In-Reply-To: <1551947777-13044-2-git-send-email-julien.thierry@arm.com>
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

On Thu, 7 Mar 2019 08:36:02 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

> The vesa framebuffer is only used by architectures that explicitly
> require it (i.e. x86). Compile it out for architectures not using it, as
> its current implementation might not work for them.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index c4faff6..288e467 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -94,7 +94,6 @@ OBJS	+= util/read-write.o
>  OBJS	+= util/util.o
>  OBJS	+= virtio/9p.o
>  OBJS	+= virtio/9p-pdu.o
> -OBJS	+= hw/vesa.o
>  OBJS	+= hw/pci-shmem.o
>  OBJS	+= kvm-ipc.o
>  OBJS	+= builtin-sandbox.o
> @@ -219,6 +218,8 @@ else
>  endif
>  
>  ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
> +	OBJS	+= hw/vesa.o
> +
>  	CFLAGS_GTK3 := $(shell pkg-config --cflags gtk+-3.0 2>/dev/null)
>  	LDFLAGS_GTK3 := $(shell pkg-config --libs gtk+-3.0 2>/dev/null)
>  	ifeq ($(call try-build,$(SOURCE_GTK3),$(CFLAGS) $(CFLAGS_GTK3),$(LDFLAGS) $(LDFLAGS_GTK3)),y)
