From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 00/10] Provide the EL1 physical timer to the VM
Date: Sun, 29 Jan 2017 15:55:28 +0000
Message-ID: <86h94h97yn.fsf@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F40B74096F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 10:55:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H8DAKxMFlGw0 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Jan 2017 10:55:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0696640967
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 10:55:24 -0500 (EST)
In-Reply-To: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 (Jintack Lim's message of "Thu, 26 Jan 2017 20:04:50 -0500")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jintack,

On Fri, Jan 27 2017 at 01:04:50 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> The ARM architecture defines the EL1 physical timer and the virtual timer,
> and it is reasonable for an OS to expect to be able to access both.
> However, the current KVM implementation does not provide the EL1 physical
> timer to VMs but terminates VMs on access to the timer.
>
> This patch series enables VMs to use the EL1 physical timer through
> trap-and-emulate.  The KVM host emulates each EL1 physical timer register
> access and sets up the background timer accordingly.  When the background
> timer expires, the KVM host injects EL1 physical timer interrupts to the
> VM.  Alternatively, it's also possible to allow VMs to access the EL1
> physical timer without trapping.  However, this requires somehow using the
> EL2 physical timer for the Linux host while running the VM instead of the
> EL1 physical timer.  Right now I just implemented trap-and-emulate because
> this was straightforward to do, and I leave it to future work to determine
> if transferring the EL1 physical timer state to the EL2 timer provides any
> performance benefit.
>
> This feature will be useful for any OS that wishes to access the EL1
> physical timer. Nested virtualization is one of those use cases. A nested
> hypervisor running inside a VM would think it has full access to the
> hardware and naturally tries to use the EL1 physical timer as Linux would
> do. Other nested hypervisors may try to use the EL2 physical timer as Xen
> would do, but supporting the EL2 physical timer to the VM is out of scope
> of this patch series. This patch series will make it easy to add the EL2
> timer support in the future, though.
>
> Note that Linux VMs booting in EL1 will be unaffected by this patch series
> and will continue to use only the virtual timer and this patch series will
> therefore not introduce any performance degredation as a result of
> trap-and-emulate.

Thanks for respining this series. Overall, this looks quite good, and
the couple of comments I have should be easy to address.

My main concern is that we do expose a timer that doesn't hide
CNTVOFF. I appreciate that that was already the case, since CNTPCT was
always available (and this avoided trapping the counter), but maybe we
should have a way for userspace to ask for a mode where CNTPCT=CNTVCT,
byt trapping the physical counter and taking CNTVOFF in all physical
timer calculations.

I'm pretty sure you've addressed this one way or another in your nested
virt series, so maybe extracting the relevant patches and adding them on
top of this series could be an option?

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny.
