From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 0/3] Extend check callback usability for irq connect notifier
Date: Tue, 28 Apr 2015 10:18:00 +0100
Message-ID: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C80C54EC93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1NPYARBxjTYV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 05:09:43 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1DB14EC90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:43 -0400 (EDT)
Received: by widdi4 with SMTP id di4so131749015wid.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 02:18:09 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The VFIO platform device gets connected to the platform bus
on a machine init done notifier. Only at that point irqfd can be
setup. An irq connect notifier would be helpful to do that job.
Instead of adding a new callback at sysbus or qdev level, this
series proposes to use the property check() callback (credit to
Paolo).

- the callback is passed to qdev_init_gpio_out_named
- sysbus class now holds a irq_set_hook method usable as check
  callback
- sysbus_init_irq initializes the callback to the class method
- object_set_link_property is modified so that
  * the target object is populated before the check
  * check takes an Object ** enabling to access the object
    container.

Then The VFIO platform device would override the irq_set_hook
method in a separate patch.

Please let me know if those modifications are acceptable. Else
I will follow Peter's proposal. 

Best Regards

Eric

Eric Auger (3):
  qdev: pass the check callback to qdev_init_gpio_out_named
  qdev: check callback takes Object **target as third argument
  sysbus: add irq_set_hook

 hw/core/qdev-properties.c    |  2 +-
 hw/core/qdev.c               |  8 +++++---
 hw/core/sysbus.c             |  8 +++++++-
 include/hw/qdev-core.h       |  3 ++-
 include/hw/qdev-properties.h |  2 +-
 include/hw/sysbus.h          |  1 +
 include/qom/object.h         |  8 +++++---
 qom/object.c                 | 15 +++++++++------
 8 files changed, 31 insertions(+), 16 deletions(-)

-- 
1.8.3.2
