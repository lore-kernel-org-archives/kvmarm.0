From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 00/10] Provide the EL1 physical timer to the VM
Date: Thu, 2 Feb 2017 13:31:04 +0100
Message-ID: <20170202123104.GJ27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FF3A4096F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 07:30:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HWruvOCoUCfJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 07:30:47 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 123BB40783
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 07:30:46 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id x1so7679178lff.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Feb 2017 04:31:09 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jintack,

On Wed, Feb 01, 2017 at 12:43:00PM -0500, Jintack Lim wrote:
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
> 
> v2 => v3:
>  - Rebase on kvmarm/queue
>  - Take kvm->lock to synchronize cntvoff across all vtimers
>  - Remove unnecessary function parameters
>  - Add comments

I just gave v3 a test run on my TC2 (32-bit platform) and my guest
quickly locks up trying to run cyclictest or when booting the machine it
stalls with RCU timeouts.

Could you have a look?

Thanks,
-Christoffer
