From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 2/5] VFIO: platform: add get_device callback
Date: Wed, 13 May 2015 12:32:23 -0600
Message-ID: <1431541943.3625.53.camel@redhat.com>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
	 <1431008843-28411-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1431008843-28411-3-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, b.reynal@virtualopensystems.com, linux-kernel@vger.kernel.org, patches@linaro.org, agraf@suse.de, Bharat.Bhushan@freescale.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
> It is needed to introduce a new callback enabling to retrieve the
> struct device* from the vfio_platform_device. Implementation depends
> on the underlying device, platform or amba. This will be used to retrieve
> the compatibility string of the device.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  drivers/vfio/platform/vfio_amba.c             |  9 +++++++++
>  drivers/vfio/platform/vfio_platform.c         | 10 ++++++++++
>  drivers/vfio/platform/vfio_platform_private.h |  1 +
>  3 files changed, 20 insertions(+)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index ff0331f..fd68115 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -48,6 +48,14 @@ static int get_amba_irq(struct vfio_platform_device *vdev, int i)
>  	return ret ? ret : -ENXIO;
>  }
>  
> +static struct device *vfio_amba_get_device(struct vfio_platform_device *vdev)
> +{
> +	struct amba_device *pdev = (struct amba_device *) vdev->opaque;
> +	struct device *dev = &pdev->dev;
> +
> +	return dev;
> +}

*get* device implies a increment in the reference count.  There's
nothing like that happening here.  Do you just want a to_device wrapper?
Why doesn't struct vfio_platform_device just cache a pointer to the
struct device?

> +
>  static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>  {
>  	struct vfio_platform_device *vdev;
> @@ -67,6 +75,7 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>  	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
>  	vdev->get_resource = get_amba_resource;
>  	vdev->get_irq = get_amba_irq;
> +	vdev->get_device = vfio_amba_get_device;
>  
>  	ret = vfio_platform_probe_common(vdev, &adev->dev);
>  	if (ret) {
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index cef645c..c025d76 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -51,6 +51,15 @@ static int get_platform_irq(struct vfio_platform_device *vdev, int i)
>  	return platform_get_irq(pdev, i);
>  }
>  
> +static struct device *vfio_platform_get_device(
> +				struct vfio_platform_device *vdev)
> +{
> +	struct platform_device *pdev = (struct platform_device *) vdev->opaque;
> +	struct device *dev = &pdev->dev;
> +
> +	return dev;
> +}
> +
>  static int vfio_platform_probe(struct platform_device *pdev)
>  {
>  	struct vfio_platform_device *vdev;
> @@ -65,6 +74,7 @@ static int vfio_platform_probe(struct platform_device *pdev)
>  	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
>  	vdev->get_resource = get_platform_resource;
>  	vdev->get_irq = get_platform_irq;
> +	vdev->get_device = vfio_platform_get_device;
>  
>  	ret = vfio_platform_probe_common(vdev, &pdev->dev);
>  	if (ret)
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index da2d60b..68909a4 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -67,6 +67,7 @@ struct vfio_platform_device {
>  	struct resource*
>  		(*get_resource)(struct vfio_platform_device *vdev, int i);
>  	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
> +	struct device *(*get_device)(struct vfio_platform_device *vdev);
>  };
>  
>  typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);



