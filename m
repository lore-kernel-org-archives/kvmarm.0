From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with
 percpu irq request
Date: Tue, 25 Apr 2017 12:22:30 +0200
Message-ID: <20170425102230.GJ4104@cbox>
References: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
 <398f3f3d-c567-0f1f-1a43-9b8d5805d5fd@arm.com>
 <20170424185909.GD2137@mai>
 <92e2a022-93d4-d4f3-78af-c9b5d51bb867@arm.com>
 <20170424195948.GE2137@mai>
 <16042494-2e67-e1a5-b9f6-af57e349d8a7@arm.com>
 <20170425083451.GA16888@mai>
 <f840e9d2-8aac-dc1d-6468-44f7658b55b1@arm.com>
 <20170425094927.GB16888@mai>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E6640C8A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 06:19:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rscL7RrrspJr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 06:19:43 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B908D40C57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 06:19:43 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id w64so18576553wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 03:22:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170425094927.GB16888@mai>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, kernel@stlinux.com, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Vineet Gupta <vgupta@synopsys.com>, Patrice Chotard <patrice.chotard@st.com>, Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org, Javier Martinez Canillas <javier@osg.samsung.com>, Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, linux-snps-arc@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 25, 2017 at 11:49:27AM +0200, Daniel Lezcano wrote:

[...]

> > 
> > The idle code is very much *not* aware of anything concerning that guest
> > timer.
> 
> Just for my own curiosity, if there are two VM (VM1 and VM2). VM1 sets a timer1
> at <time> and exits, VM2 runs and sets a timer2 at <time+delta>.
> 
> The timer1 for VM1 is supposed to expire while VM2 is running. IIUC the virtual
> timer is under control of VM2 and will expire at <time+delta>.
> 
> Is the host wake up with the SW timer and switch in VM1 which in turn restores
> the timer and jump in the virtual timer irq handler?
>  
The thing that may be missing here is that a VCPU thread (more of which
in a collection is a VM) is just a thread from the point of view of
Linux, and whether or not a guest schedules a timer, should not effect
the scheduler's decision to run a given thread, if the thread is
runnable.

Whenever we run a VCPU thread, we look at its timer state (in software)
and calculate if the guest should see a timer interrupt and inject such
a one (the hardware arch timer is not involved in this process at all).

We use timers in exactly two scenarios:

 1. The hardware arch timers are used to force an exit to the host when
    the guest programmed the timer, so we can do the calculation in
    software I mentioned above and inject a virtual software-generated
    interrupt when the guest expects to see one.

 2. The guest goes to sleep (WFI) but has programmed a timer to be woken
    up at some point.  KVM handles a WFI by blocking the VCPU thread,
    which basically means making the thread interruptible and putting it
    on a waitqueue.  In this case we schedule a software timer to make
    the thread runnable again when the software timer fires (and the
    scheduler runs that thread when it wants to after that).

If you have a VCPU thread from VM1 blocked, and you run a VCPU thread
from VM2, then the VCPU thread from VM2 will program the hardware arch
timer with the context of the VM2 VCPU thread while running, and this
has nothing to do with the VCPU thread from VM1 at this point, because
it relies on the host Linux time keeping infrastructure to become
runnable some time in the future, and running a guest naturally doesn't
mess with the host's time keeping.

Hope this helps,
-Christoffer
