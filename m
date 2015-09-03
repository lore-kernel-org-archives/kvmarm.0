From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH v3 2/3] vfio: platform: access device property as
 a list of strings
Date: Thu, 03 Sep 2015 18:49:08 +0200
Message-ID: <55E87A04.4020508@linaro.org>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
 <1419024032-1269-3-git-send-email-a.motakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EACD41978
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:49:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xqpVHgcOyHTM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2015 12:49:34 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53565412FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:49:34 -0400 (EDT)
Received: by wibz8 with SMTP id z8so105521929wib.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2015 09:49:57 -0700 (PDT)
In-Reply-To: <1419024032-1269-3-git-send-email-a.motakis@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Baptiste Reynal <b.reynal@virtualopensystems.com>, kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, alex.williamson@redhat.com
Cc: list@lists.cs.columbia.edu, VFIO DRIVER <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, open@lists.cs.columbia.edu, tech@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On 12/19/2014 10:20 PM, Antonios Motakis wrote:
> Certain device properties (e.g. the device node name, the compatible
> string), are available as a list of strings (separated by the null
> terminating character). Let the VFIO user query this type of properties.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/properties.c | 43 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
> index 8b90465..39c6342 100644
> --- a/drivers/vfio/platform/properties.c
> +++ b/drivers/vfio/platform/properties.c
> @@ -7,7 +7,48 @@ static int dev_property_get_strings(struct device *dev,
>  				    char *name, unsigned *lenp,
>  				    void __user *datap, unsigned long datasz)
>  {
> -	return -EINVAL;
> +	const char **val;
> +	int n, i, ret;
> +
> +	*lenp = 0;
> +
> +	n = device_property_read_string_array(dev, name, NULL, 0);
> +	if (n < 0)
don't know if n==0 can happen? property found but not value?
> +		return n;
> +
> +	val = kcalloc(n, sizeof(char*), GFP_KERNEL);
char *, checkpatch error.
> +	if (!val)
> +		return -ENOMEM;
> +
> +	ret = device_property_read_string_array(dev, name, val, n);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = 0;
why not initializing ret at declaration time?
> +
> +	for (i = 0; i < n; i++) {
> +		size_t len = strlen(val[i]) + 1;
> +
> +		if (datasz < len) {
> +			ret = -EOVERFLOW;
> +			while (i < n)
> +				*lenp += strlen(val[i++]) + 1;
why do you set *lenp to the length of all strings even if they can't be
copied?
> +			goto out;
> +		}
> +
> +		if (copy_to_user(datap, val[i], len)) {
> +			ret = -EFAULT;
so in that case *lenp is not incremented?
> +			goto out;
> +		}
Can't you have a similar implementation as for uxx, see next patch
comments. Can't you copy to user in one shot. Can't that code be simplified.
> +
> +		*lenp += len;
> +		datap += len;
> +		datasz -= len;
> +	}
> +
> +out:
> +	kfree(val);
> +	return ret;
>  }
>  
>  static int dev_property_get_uint(struct device *dev, char *name,
> 
