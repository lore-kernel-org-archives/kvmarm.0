From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 04/13] vfio-pci: use 32-bit comparisons for register
 address for gcc-4.5
Date: Fri, 16 Dec 2016 08:30:56 -0700
Message-ID: <20161216083056.33ea0fa9@t450s.home>
References: <20161216105634.235457-1-arnd@arndb.de>
        <20161216105634.235457-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20161216105634.235457-5-arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 16 Dec 2016 11:56:25 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> Using ancient compilers (gcc-4.5 or older) on ARM, we get a link
> failure with the vfio-pci driver:
> 
> ERROR: "__aeabi_lcmp" [drivers/vfio/pci/vfio-pci.ko] undefined!
> 
> The reason is that the compiler tries to do a comparison of
> a 64-bit range. This changes it to convert to a 32-bit number
> explicitly first, as newer compilers do for themselves.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 5ffd1d9ad4bd..357243d76f10 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -193,7 +193,10 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
>  	if (!vdev->has_vga)
>  		return -EINVAL;
>  
> -	switch (pos) {
> +	if (pos > 0xbfffful)
> +		return -EINVAL;
> +
> +	switch ((u32)pos) {
>  	case 0xa0000 ... 0xbffff:
>  		count = min(count, (size_t)(0xc0000 - pos));
>  		iomem = ioremap_nocache(0xa0000, 0xbffff - 0xa0000 + 1);

Acked-by: Alex Williamson <alex.williamson@redhat.com>

Would you like me to pull this one patch in through the vfio tree?
Thanks,

Alex
