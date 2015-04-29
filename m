From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [Qemu-devel] [PATCH 0/3] Extend check callback usability for
 irq connect notifier
Date: Wed, 29 Apr 2015 09:43:47 +0200
Message-ID: <55408BB3.5030203@linaro.org>
References: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
 <CAEgOgz7TE7Chb+ZT2OnN6cwCsA6j_BS1E1_=7v5bL7KA27iyAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12CF94EE18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 03:38:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R9yCFOSHrIiX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 03:37:59 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D78E64EDE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 03:37:58 -0400 (EDT)
Received: by wizk4 with SMTP id k4so169292501wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 00:46:26 -0700 (PDT)
In-Reply-To: <CAEgOgz7TE7Chb+ZT2OnN6cwCsA6j_BS1E1_=7v5bL7KA27iyAw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,
On 04/28/2015 08:21 PM, Peter Crosthwaite wrote:
> On Tue, Apr 28, 2015 at 2:18 AM, Eric Auger <eric.auger@linaro.org> wrote:
>> The VFIO platform device gets connected to the platform bus
>> on a machine init done notifier. Only at that point irqfd can be
>> setup. An irq connect notifier would be helpful to do that job.
>> Instead of adding a new callback at sysbus or qdev level, this
>> series proposes to use the property check() callback (credit to
>> Paolo).
>>
>> - the callback is passed to qdev_init_gpio_out_named
>> - sysbus class now holds a irq_set_hook method usable as check
>>   callback
>> - sysbus_init_irq initializes the callback to the class method
>> - object_set_link_property is modified so that
>>   * the target object is populated before the check
>>   * check takes an Object ** enabling to access the object
>>     container.
>>
>> Then The VFIO platform device would override the irq_set_hook
>> method in a separate patch.
>>
>> Please let me know if those modifications are acceptable. Else
>> I will follow Peter's proposal.
>>
>> Best Regards
>>
>> Eric
>>
>> Eric Auger (3):
>>   qdev: pass the check callback to qdev_init_gpio_out_named
>>   qdev: check callback takes Object **target as third argument
>>   sysbus: add irq_set_hook
>>
>>  hw/core/qdev-properties.c    |  2 +-
>>  hw/core/qdev.c               |  8 +++++---
>>  hw/core/sysbus.c             |  8 +++++++-
>>  include/hw/qdev-core.h       |  3 ++-
>>  include/hw/qdev-properties.h |  2 +-
>>  include/hw/sysbus.h          |  1 +
>>  include/qom/object.h         |  8 +++++---
>>  qom/object.c                 | 15 +++++++++------
> 
> I think following the latest reply, Paolo is ok for my proposal but it
> is higher effort and to be done as follow up work. This means we
> should just merge the sysbus variant of your patch and fix it all
> later.

Well Paolo did a 2d reply to this series saying he was OK with the
change with few modifications
(https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg03783.html)
which I posted yesterday included in my VFIO series v13
(https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg03943.html). I
thought it was OK, sorry.

Now I would not insist on pushing that series. Was is important for me
is to unlock my VFIO platform series for 2.4 application.

So if both of you say, let's use the temporary sysbus irq connect
notifier, I will repost the VFIO series with that single patch file.

Anyway for the VFIO platform device code this is not a big change.

Waiting for your confirmation.

Best Regards

Eric

> 
> This avoids these temporary changes to the QOM core.
> 
> Sorry for the back and forth. Ill have a look at the RYO link approach
> later this week.
> 
> Regards,
> Peter
> 
>>  8 files changed, 31 insertions(+), 16 deletions(-)
>>
>> --
>> 1.8.3.2
>>
>>
