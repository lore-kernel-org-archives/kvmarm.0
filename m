From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v4 3/3] vfio: platform: return device properties as
 arrays of unsigned integers
Date: Wed, 09 Sep 2015 14:48:58 -0600
Message-ID: <1441831738.20355.542.camel@redhat.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
	 <1441790231-22920-4-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441790231-22920-4-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, christoffer.dall@linaro.org, eric.auger@linaro.org, tech@virtualopensystems.com, Antonios Motakis <a.motakis@virtualopensystems.com>, "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-09-09 at 11:17 +0200, Baptiste Reynal wrote:
> From: Antonios Motakis <a.motakis@virtualopensystems.com>
> 
> Certain properties of a device are accessible as an array of unsigned
> integers, either u64, u32, u16, or u8. Let the VFIO user query this
> type of device properties.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> ---
>  drivers/vfio/platform/properties.c | 62 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
> index 8bf9c8f..625e2d3 100644
> --- a/drivers/vfio/platform/properties.c
> +++ b/drivers/vfio/platform/properties.c
> @@ -70,7 +70,67 @@ static int dev_property_get_uint(struct device *dev, uint32_t *flags,
>  				 char *name, uint32_t type, unsigned *lenp,
>  				 void __user *datap, unsigned long datasz)
>  {
> -	return -EINVAL;
> +	int ret, n;
> +	u8 *out;
> +	size_t sz;
> +	int (*func)(const struct device *, const char *, void *, size_t)
> +		= NULL;
> +
> +	switch (type) {
> +	case VFIO_DEV_PROPERTY_TYPE_U64:
> +		sz = sizeof(u64);
> +		func = (int (*)(const struct device *,
> +				const char *, void *, size_t))
> +			device_property_read_u64_array;
> +		break;
> +	case VFIO_DEV_PROPERTY_TYPE_U32:
> +		sz = sizeof(u32);
> +		func = (int (*)(const struct device *,
> +				const char *, void *, size_t))
> +			device_property_read_u32_array;
> +		break;
> +	case VFIO_DEV_PROPERTY_TYPE_U16:
> +		sz = sizeof(u16);
> +		func = (int (*)(const struct device *,
> +				const char *, void *, size_t))
> +			device_property_read_u16_array;
> +		break;
> +	case VFIO_DEV_PROPERTY_TYPE_U8:
> +		sz = sizeof(u8);
> +		func = (int (*)(const struct device *,
> +				const char *, void *, size_t))
> +			device_property_read_u8_array;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* get size of array */
> +	n = func(dev, name, NULL, 0);
> +	if (n < 0)
> +		return n;
> +
> +	if (lenp)
> +		*lenp = n * sz;

Why is this conditional?

> +
> +	if (n * sz > datasz)
> +		return -EOVERFLOW;

Ugh, this isn't E2BIG or ENOSPC...

> +
> +	out = kcalloc(n, sz, GFP_KERNEL);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	ret = func(dev, name, out, n);
> +	if (ret)
> +		goto out;
> +
> +	if (copy_to_user(datap, out, n * sz))
> +		ret = -EFAULT;
> +
> +out:
> +	kfree(out);
> +	return ret;
>  }
>  
>  int vfio_platform_dev_properties(struct device *dev, uint32_t *flags,
