From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Subject: Re: [PATCH 0/3] Extend check callback usability for
 irq connect notifier
Date: Tue, 28 Apr 2015 11:21:45 -0700
Message-ID: <CAEgOgz7TE7Chb+ZT2OnN6cwCsA6j_BS1E1_=7v5bL7KA27iyAw@mail.gmail.com>
References: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 28, 2015 at 2:18 AM, Eric Auger <eric.auger@linaro.org> wrote:
> The VFIO platform device gets connected to the platform bus
> on a machine init done notifier. Only at that point irqfd can be
> setup. An irq connect notifier would be helpful to do that job.
> Instead of adding a new callback at sysbus or qdev level, this
> series proposes to use the property check() callback (credit to
> Paolo).
>
> - the callback is passed to qdev_init_gpio_out_named
> - sysbus class now holds a irq_set_hook method usable as check
>   callback
> - sysbus_init_irq initializes the callback to the class method
> - object_set_link_property is modified so that
>   * the target object is populated before the check
>   * check takes an Object ** enabling to access the object
>     container.
>
> Then The VFIO platform device would override the irq_set_hook
> method in a separate patch.
>
> Please let me know if those modifications are acceptable. Else
> I will follow Peter's proposal.
>
> Best Regards
>
> Eric
>
> Eric Auger (3):
>   qdev: pass the check callback to qdev_init_gpio_out_named
>   qdev: check callback takes Object **target as third argument
>   sysbus: add irq_set_hook
>
>  hw/core/qdev-properties.c    |  2 +-
>  hw/core/qdev.c               |  8 +++++---
>  hw/core/sysbus.c             |  8 +++++++-
>  include/hw/qdev-core.h       |  3 ++-
>  include/hw/qdev-properties.h |  2 +-
>  include/hw/sysbus.h          |  1 +
>  include/qom/object.h         |  8 +++++---
>  qom/object.c                 | 15 +++++++++------

I think following the latest reply, Paolo is ok for my proposal but it
is higher effort and to be done as follow up work. This means we
should just merge the sysbus variant of your patch and fix it all
later.

This avoids these temporary changes to the QOM core.

Sorry for the back and forth. Ill have a look at the RYO link approach
later this week.

Regards,
Peter

>  8 files changed, 31 insertions(+), 16 deletions(-)
>
> --
> 1.8.3.2
>
>
