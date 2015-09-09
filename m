From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v4 2/3] vfio: platform: access device property as a
 list of strings
Date: Wed, 09 Sep 2015 14:48:44 -0600
Message-ID: <1441831724.20355.541.camel@redhat.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
	 <1441790231-22920-3-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441790231-22920-3-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, christoffer.dall@linaro.org, eric.auger@linaro.org, tech@virtualopensystems.com, Antonios Motakis <a.motakis@virtualopensystems.com>, "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-09-09 at 11:17 +0200, Baptiste Reynal wrote:
> From: Antonios Motakis <a.motakis@virtualopensystems.com>
> 
> Certain device properties (e.g. the device node name, the compatible
> string), are available as a list of strings (separated by the null
> terminating character). Let the VFIO user query this type of properties.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> 
> ---
> v3 -> v4:
>  - The list length is computed before strings copy. If the entire list
>    doesn't fit, no strings are copied to the user.
> ---
>  drivers/vfio/platform/properties.c | 43 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
> index 98754c2..8bf9c8f 100644
> --- a/drivers/vfio/platform/properties.c
> +++ b/drivers/vfio/platform/properties.c
> @@ -22,7 +22,48 @@ static int dev_property_get_strings(struct device *dev, uint32_t *flags,
>  				    char *name, unsigned *lenp,
>  				    void __user *datap, unsigned long datasz)
>  {
> -	return -EINVAL;
> +	const char **val;
> +	int n, i, ret;
> +
> +	if (lenp == NULL)
> +		return -EFAULT;

Paranoia?

> +
> +	*lenp = 0;
> +
> +	n = device_property_read_string_array(dev, name, NULL, 0);
> +	if (n < 0)
> +		return n;
> +
> +	val = kcalloc(n, sizeof(char *), GFP_KERNEL);
> +	if (!val)
> +		return -ENOMEM;
> +
> +	ret = device_property_read_string_array(dev, name, val, n);
> +	if (ret < 0)
> +		goto out;
> +
> +	for (i = 0; i < n; i++)
> +		*lenp += strlen(val[i]) + 1;
> +
> +	if (datasz < *lenp) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < n; i++) {
> +		size_t len = strlen(val[i]) + 1;
> +
> +		if (copy_to_user(datap, val[i], strlen(val[i]) + 1)) {

No need to call strlen() again here

> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		datap += len;
> +	}
> +
> +out:
> +	kfree(val);
> +	return ret;
>  }
>  
>  static int dev_property_get_uint(struct device *dev, uint32_t *flags,
