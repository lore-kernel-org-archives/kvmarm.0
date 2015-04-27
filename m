From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Subject: Re: [Qemu-devel] [PATCH v2] sysbus: add irq_routing_notifier
Date: Sun, 26 Apr 2015 21:09:36 -0700
Message-ID: <CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C5364E8F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 00:01:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xW5fnZWXHykv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 00:01:14 -0400 (EDT)
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com
 [209.85.216.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DE784E8F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 00:01:13 -0400 (EDT)
Received: by qcyk17 with SMTP id k17so50135222qcy.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2015 21:09:36 -0700 (PDT)
In-Reply-To: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 24, 2015 at 5:39 AM, Eric Auger <eric.auger@linaro.org> wrote:
> Add a new irq_routing_notifier notifier in the SysBusDeviceClass. This
> notifier, if populated, is called after sysbus_connect_irq.
>
> This mechanism is used to setup VFIO signaling once VFIO platform
> devices get attached to their platform bus, on a machine init done
> notifier.
>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>
> ---
>
> v1 -> v2:
> - duly put the notifier in the class and not in the device
> ---
>  hw/core/sysbus.c    | 6 ++++++
>  include/hw/sysbus.h | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
> index b53c351..8553a6f 100644
> --- a/hw/core/sysbus.c
> +++ b/hw/core/sysbus.c
> @@ -109,7 +109,13 @@ qemu_irq sysbus_get_connected_irq(SysBusDevice *dev, int n)
>
>  void sysbus_connect_irq(SysBusDevice *dev, int n, qemu_irq irq)
>  {
> +    SysBusDeviceClass *sbd = SYS_BUS_DEVICE_GET_CLASS(dev);
> +
>      qdev_connect_gpio_out_named(DEVICE(dev), SYSBUS_DEVICE_GPIO_IRQ, n, irq);

One of my long term goals is to try and get rid of sysbus IRQ
abstraction completely in favor of just qdev gpios. This means
features that apply to GPIOs automatically apply to IRQs and vice
versa. Can your notifier hook be pushed up to the qdev GPIO level to
make it more globally usable and avoid a new feature to sysbus IRQs?

> +
> +    if (sbd->irq_routing_notifier) {
> +        sbd->irq_routing_notifier(dev, irq);
> +    }
>  }
>
>  /* Check whether an MMIO region exists */
> diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
> index d1f3f00..dbf3f0f 100644
> --- a/include/hw/sysbus.h
> +++ b/include/hw/sysbus.h
> @@ -41,6 +41,7 @@ typedef struct SysBusDeviceClass {
>      /*< public >*/
>
>      int (*init)(SysBusDevice *dev);
> +    void (*irq_routing_notifier)(SysBusDevice *dev, qemu_irq irq);

Is it better to make the name more matched to sysbus_connect_irq?
Perhaps connect_irq_notifier. But with the qdev approach this would be
connect_gpio_out_notifier or something along those lines.

Regards,
Peter

>  } SysBusDeviceClass;
>
>  struct SysBusDevice {
> --
> 1.8.3.2
>
>
