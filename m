From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] vfio: platform: add capability to register a reset function
Date: Thu, 22 Oct 2015 12:06:02 +0200
Message-ID: <4039449.LR9NiiaAaC@wuerfel>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org> <1445506922-6005-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445506922-6005-2-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 22 October 2015 11:41:57 Eric Auger wrote:
> In preparation for subsequent changes in reset function lookup,
> lets introduce a dynamic list of reset combos (compat string,
> reset module, reset function). The list can be populated/voided with
> two new functions, vfio_platform_register/unregister_reset. Those are
> not yet used in this patch.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

Looks correct to me now, just a little style comments.

>  drivers/vfio/platform/vfio_platform_common.c  | 77 +++++++++++++++++++++++++++
>  drivers/vfio/platform/vfio_platform_private.h |  7 +++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index e43efb5..52a4c7b 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -23,6 +23,15 @@
>  
>  #include "vfio_platform_private.h"
>  
> +struct vfio_platform_reset_node {
> +	struct list_head link;
> +	char *compat;
> +	struct module *owner;
> +	vfio_platform_reset_fn_t reset;
> +};
> +
> +static LIST_HEAD(reset_list);
> +static DEFINE_MUTEX(reset_lock);
>  static DEFINE_MUTEX(driver_lock);

I wonder if having a single mutex here would be enough. If you don't expect
drivers to register/unregister a lot, you could just use driver_lock here
as well.

>  static const struct vfio_platform_reset_combo reset_lookup_table[] = {
> @@ -573,3 +582,71 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
>  	return vdev;
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
> +
> +int vfio_platform_register_reset(struct module *reset_owner,
> +				 const char *compat,
> +				 vfio_platform_reset_fn_t reset)
> +{
> +	struct vfio_platform_reset_node *node, *iter;
> +	bool found = false;
> +
> +	mutex_lock(&reset_lock);
> +	list_for_each_entry(iter, &reset_list, link) {
> +		if (!strcmp(iter->compat, compat)) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (found) {
> +		mutex_unlock(&reset_lock);
> +		return -EINVAL;
> +	}

This seems to be an unnecesssary safeguard. I would not bother
with the search, or otherwise do a WARN_ON here.

> +	node = kmalloc(sizeof(*node), GFP_KERNEL);
> +	if (!node) {
> +		mutex_unlock(&reset_lock);
> +		return -ENOMEM;
> +	}
> +
> +	node->compat = kstrdup(compat, GFP_KERNEL);
> +	if (!node->compat) {
> +		kfree(node);
> +		mutex_unlock(&reset_lock);
> +		return -ENOMEM;
> +	}

If you hold a lock, it's better to use a goto for handling errors
and put the unlock and kfree there. I think it can be avoided
entirely here though:

It should be safe to define the interface as keeping a reference
on the string and not do a kstrdup here. I would expect users to
pass a string literal.

We could even go as far as defining the entire interface as a shim,
like

#define vfio_platform_register_reset(__compat, __reset)	\
static struct vfio_platform_reset_node __reset ## _node = {	\
	.owner = THIS_MODULE,					\
	.compat = __compat,					\
	.reset = __reset,					\
};								\
__vfio_platform_register_reset(&__reset ## node);

to make the function really simple.

	Arnd
