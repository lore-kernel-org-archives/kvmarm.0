From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] Live migration sequence
Date: Tue, 13 Oct 2015 13:04:57 +0100
Message-ID: <CAFEAcA8P9okmf012ocoo6bx5y-0yObTFrsrPo1tQ99yGiHYo7A@mail.gmail.com>
References: <008b01d101be$0228d720$067a8560$@samsung.com>
 <20151009152942.GF2702@work-vm>
 <00b801d1059e$d6d4ffb0$847eff10$@samsung.com> <20151013110527.GB2555@work-vm>
 <00d801d105ae$fa1eb5a0$ee5c20e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AEEF41172
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 08:03:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LTq+a0Cdy8gP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Oct 2015 08:03:04 -0400 (EDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 335FA4113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 08:03:03 -0400 (EDT)
Received: by vkha6 with SMTP id a6so8585379vkh.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 05:05:16 -0700 (PDT)
In-Reply-To: <00d801d105ae$fa1eb5a0$ee5c20e0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, QEMU <qemu-devel@nongnu.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Amit Shah <amit.shah@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 October 2015 at 13:02, Pavel Fedin <p.fedin@samsung.com> wrote:
>  Hello!
>
>>   b) Once you're in the device state saving (a above) you must not change guest RAM,
>>      because at that point the migration code won't send any new changes across
>>      to the destination. So any sync's you're going to do have to happen before/at
>>      the time we stop the CPU and do the final RAM sync.  On the plus side, when
>>      you're loading the device state in (a) you can be sure the RAM contents are there.
>
>  This is good. I think, in this case i can teach the kernel (here we talk about accelerated
> in-kernel irqchip implementation) to flush ITS caches when a CPU is stopped. This will do the job.

Our idea at the discussion at Connect was to have an ioctl to request
a flush, rather than to do it automatically when a CPU is stopped
(you probably don't want to flush when only one CPU in an SMP system
is stopped, for instance). But we wanted to get the basic no-ITS
ABI sorted out and agreed first, so those details aren't in the
patch Christoffer sent out the other day.

It will probably be more efficient if we agree on the ABI details
here before doing the implementation rather than afterwards.

thanks
-- PMM
