From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 9 Jul 2015 14:05:31 +0200
Message-ID: <20150709120531.GL13530@cbox>
References: <558BC90B.4060806@huawei.com>
 <558CD9DE.3010609@web.de>
 <55917E5B.3030401@huawei.com>
 <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
 <559D483A.40507@arm.com>
 <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
 <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
 <20150709102201.GH13530@cbox>
 <CAFEAcA-4rMB6i2=UBXjxTAHQWn5xMiCSiaYbknuXOuHmf4XY_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA-4rMB6i2=UBXjxTAHQWn5xMiCSiaYbknuXOuHmf4XY_A@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Claudio Fontana <claudio.fontana@huawei.com>, Jan Kiszka <jan.kiszka@web.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 09, 2015 at 11:38:40AM +0100, Peter Maydell wrote:
> On 9 July 2015 at 11:22, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > On Wed, Jul 08, 2015 at 08:13:59PM +0100, Peter Maydell wrote:
> >> I suspect Jan is right and we really need to distinguish
> >> the KVM_PUT_*_STATE levels in ARM QEMU. This probably
> >> implies some kind of whitelist/override mechanism, since
> >> by and large we neither know nor want to know the
> >> semantics for system registers, we leave that up to the
> >> kernel.
> >>
> >> Q: if you have a running VM, and you pause it for
> >> an hour, what should the CNTVCT register do? Presumably
> >> it should not advance, but how do we arrange for that
> >> to happen?
> 
> > I think the CNTVCT should not advance when the VM is not scheduled, so
> > if we pause the VM or starve all the VCPUs for enough time, the guest
> > should not see time progressing, since otherwise the guest scheduler
> > cannot maintain fairness and you're bound to see spurious RCU stalls
> > etc.
> >
> > That's exactly why a guest can read both a virtual and physical counter
> > and it is an area where you simply want some level of
> > paravirtualization.  I haven't studied how/if Linux deals with this at
> > all.
> >
> > So I think adjusting CNTVOFF should be managed by the kernel for the
> > pause/starvation scenario (which I think Avi once told me x86 does too -
> > does anyone know the current state of the art?).
> 
> Agreed that we should be aiming for same behaviour as x86
> rather than reinventing the wheel...
> 
> > So the only situation where I think userspace should adjust the CNTVOFF
> > value is for migration where we are talking about a brand new VM with
> > has_run_once clear.
> 
> For incoming migration/loadvm the VM will be freshly *reset*,
> but it will not be completely created from scratch. It's
> possible for the user to run a VM for a bit, and then use
> "loadvm" from the monitor to load an old snapshot. This
> will do a qemu_system_reset() and then restore the state.
> So in that case has_run_once won't be clear. (Would it be
> OK to clear it when userspace does VCPU_INIT? What else
> does it control?)

We would have to introduce another flag.  It is currently used to only
map the VGIC resources once (we have to do this before running the VCPU
the first time because only then do we have the required info of where
to map the resources etc.), and we use it to enforce that the user
doesn't initialize a VCPU with one setting, and then initialize it with
a different setting afterwards (for example with power-on state or the
emulated CPU target).

> 
> > Thus, if we were designing this from scratch now, the API should
> > be to return an error when trying to set KVM_REG_ARM_TIMER_CNT after the
> > VM has run once, but it's too late for that as we would break userspace.
> > The best alternative IMHO would be to merge Marc's patch and fix CNTVOFF
> > in the kernel side as well, and finally also fix QEMU so that it doesn't
> > try to do the thing that future kernels will ignore.
> 
> Isn't Marc's patch causing us to return an error to userspace?
> (It does a 'return -1', at least -- does that get ignored at
> a higher level?)

I remembered it as it simply ignored it, but you're right, it returns -1
to userspace (which is a strange thing we do in arch_timer.c, I'm not
sure why we return -EPERM here - probably a bug).

So that can't work obviously, because it will regress userspace.

> 
> In principle, if userspace does:
>  * stop all vCPUs
>  * read the counter values from each vCPU
>  * write the counter values back to each vCPU
>  * resume vCPUs
> 
> this shouldn't cause time to do funny things, should it?

No, it shouldn't.

> (ie the problem only occurs if we try to write the vCPU
> counter value while only one vCPU is stopped).
> 

As I understand it, the problem is that if we ever run a VCPU after
reading the value, and write back the value afterwards, you potentially
make time go backwards and get inconsistent views of time from different
VCPUs because they may have read the time before/after updating the
CNTVOFF.

-Christoffer
