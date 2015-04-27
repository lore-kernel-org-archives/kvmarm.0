From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2] sysbus: add irq_routing_notifier
Date: Mon, 27 Apr 2015 14:20:15 +0200
Message-ID: <553E297F.4020706@linaro.org>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
	<CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>
	<553DF2AA.2070102@linaro.org> <553E11E7.7070704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <553E11E7.7070704@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, eric.auger@st.com, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Patch Tracking <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/27/2015 12:39 PM, Paolo Bonzini wrote:
> 
> 
> On 27/04/2015 10:26, Eric Auger wrote:
>>>> One of my long term goals is to try and get rid of sysbus IRQ
>>>> abstraction completely in favor of just qdev gpios. This means
>>>> features that apply to GPIOs automatically apply to IRQs and vice
>>>> versa. Can your notifier hook be pushed up to the qdev GPIO level to
>>>> make it more globally usable and avoid a new feature to sysbus IRQs?
>> Yes sure, I am going to put the notifier in DeviceClass then.
> 
> I've thought too about this, and I'm not sure about it.
> 
> It would mean you have to pass the gpio name (e.g.
> SYSBUS_DEVICE_GPIO_IRQ) to the hook, and in the case of sysbus IRQs this
> would leak the SYSBUS_DEVICE_GPIO_IRQ abstraction to the implementors of
> the hook.
Hi Paolo,

Currently my notifier has the following proto:
    void (*connect_gpio_out_notifier)(DeviceState *dev, qemu_irq irq);

It is sufficient for my need.

is it really mandated to pass other qdev_connect_gpio_out_named args,
ie. name & n?

Best Regards

Eric
> 
> Paolo
> 
