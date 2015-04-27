From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2] sysbus: add irq_routing_notifier
Date: Mon, 27 Apr 2015 12:39:35 +0200
Message-ID: <553E11E7.7070704@redhat.com>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
 <CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>
 <553DF2AA.2070102@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1924E952
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 06:31:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nWkQOLpXTz5z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 06:31:17 -0400 (EDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC1F44E951
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 06:31:16 -0400 (EDT)
Received: by wgyo15 with SMTP id o15so111001500wgy.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 03:39:39 -0700 (PDT)
In-Reply-To: <553DF2AA.2070102@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, eric.auger@st.com, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Patch Tracking <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 27/04/2015 10:26, Eric Auger wrote:
>> > One of my long term goals is to try and get rid of sysbus IRQ
>> > abstraction completely in favor of just qdev gpios. This means
>> > features that apply to GPIOs automatically apply to IRQs and vice
>> > versa. Can your notifier hook be pushed up to the qdev GPIO level to
>> > make it more globally usable and avoid a new feature to sysbus IRQs?
> Yes sure, I am going to put the notifier in DeviceClass then.

I've thought too about this, and I'm not sure about it.

It would mean you have to pass the gpio name (e.g.
SYSBUS_DEVICE_GPIO_IRQ) to the hook, and in the case of sysbus IRQs this
would leak the SYSBUS_DEVICE_GPIO_IRQ abstraction to the implementors of
the hook.

Paolo
