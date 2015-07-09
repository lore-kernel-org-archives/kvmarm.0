From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 9 Jul 2015 12:22:01 +0200
Message-ID: <20150709102201.GH13530@cbox>
References: <558BC2F5.9010303@huawei.com>
 <CAFEAcA_RzWSppaYA9vuAaL-MO6sQV1SgpXf3w-LScUdaarpOEQ@mail.gmail.com>
 <558BC90B.4060806@huawei.com> <558CD9DE.3010609@web.de>
 <55917E5B.3030401@huawei.com>
 <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
 <559D483A.40507@arm.com>
 <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
 <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C05F58308
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 06:10:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h0OqPFS+KEa2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 06:10:23 -0400 (EDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4695F58305
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 06:10:22 -0400 (EDT)
Received: by laar3 with SMTP id r3so243676396laa.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 03:21:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter and Marc,

[cc'ing Paolo for his input on x86 timekeeping]

On Wed, Jul 08, 2015 at 08:13:59PM +0100, Peter Maydell wrote:
> On 8 July 2015 at 17:37, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On 08/07/15 17:06, Peter Maydell wrote:
> >> I'd prefer it if somebody could investigate to see why QEMU
> >> is actually doing this -- so far we just have speculation.
> >
> > I'd prefer that too, but so far people seem to be more comfortable
> > waiting for the issue to fix itself. In the meantime, VMs are broken in
> > weird and wonderful ways, and I don't think the current status-quo helps
> > anyone.
> 
> Putting in a patch which might not be the right fix isn't
> necessarily a good plan either...
> 
> Does has_run_once get cleared if we do a re-VCPU_INIT
> of a CPU that's run before? (We need to allow rewriting
> of guest state at that point so that "reset VM and
> load migration state" behaves correctly.)

no, it does not, has_run_once is set the first time a VCPU is run and is
currently *never* cleared.

> 
> I suspect Jan is right and we really need to distinguish
> the KVM_PUT_*_STATE levels in ARM QEMU. This probably
> implies some kind of whitelist/override mechanism, since
> by and large we neither know nor want to know the
> semantics for system registers, we leave that up to the
> kernel.
> 
> Q: if you have a running VM, and you pause it for
> an hour, what should the CNTVCT register do? Presumably
> it should not advance, but how do we arrange for that
> to happen?
> 

I think the CNTVCT should not advance when the VM is not scheduled, so
if we pause the VM or starve all the VCPUs for enough time, the guest
should not see time progressing, since otherwise the guest scheduler
cannot maintain fairness and you're bound to see spurious RCU stalls
etc.

That's exactly why a guest can read both a virtual and physical counter
and it is an area where you simply want some level of
paravirtualization.  I haven't studied how/if Linux deals with this at
all.

So I think adjusting CNTVOFF should be managed by the kernel for the
pause/starvation scenario (which I think Avi once told me x86 does too -
does anyone know the current state of the art?).

So the only situation where I think userspace should adjust the CNTVOFF
value is for migration where we are talking about a brand new VM with
has_run_once clear.

Thus, if we were designing this from scratch now, the API should
be to return an error when trying to set KVM_REG_ARM_TIMER_CNT after the
VM has run once, but it's too late for that as we would break userspace.
The best alternative IMHO would be to merge Marc's patch and fix CNTVOFF
in the kernel side as well, and finally also fix QEMU so that it doesn't
try to do the thing that future kernels will ignore.

-Christoffer
