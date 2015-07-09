From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 9 Jul 2015 18:06:31 +0200
Message-ID: <20150709160631.GA25650@cbox>
References: <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
 <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
 <20150709102201.GH13530@cbox>
 <CAFEAcA-4rMB6i2=UBXjxTAHQWn5xMiCSiaYbknuXOuHmf4XY_A@mail.gmail.com>
 <20150709120531.GL13530@cbox>
 <CAFEAcA94qRKs7TV4MmrhD4O0+cE4SYPb4iKydQQbSzdrzKMC+w@mail.gmail.com>
 <20150709122406.GN13530@cbox>
 <20150709141723.GP13530@cbox>
 <CAFEAcA81LRcRu1r+H-6T_yT-AQ4XLAzX1osAWZYNPEDHSTiAQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA81LRcRu1r+H-6T_yT-AQ4XLAzX1osAWZYNPEDHSTiAQg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Claudio Fontana <claudio.fontana@huawei.com>, Jan Kiszka <jan.kiszka@web.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 09, 2015 at 03:26:20PM +0100, Peter Maydell wrote:
> On 9 July 2015 at 15:17, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > On Thu, Jul 09, 2015 at 02:24:06PM +0200, Christoffer Dall wrote:
> > So I ran this through GDB, and this happens when the guest probes the
> > virtio devices, specifically the backtrace tells me that
> >
> > virtio_current_cpu_endian () at /root/src/qemu/hw/virtio/virtio.c:594
> > => cc->virtio_is_big_endian
> >   -> arm_cpu_is_big_endian
> >     -> cpu_synchronize_state
> >       -> kvm_cpu_synchronize_state
> >
> > which causes cpu->kvm_vcpu_dirty = true, which causes the run-loop to
> > write the CNTVOFF on a per-vcpu basis without stopping anything, as far
> > as I can tell.
> 
> Ah, I was wondering if it was going to turn out to be this,
> but I hadn't figured out why it was going to cause us to do
> a write-back of state rather than just a read.
> 
> > So yeah, I guess the only required fix here is to fix QEMU in some way
> > as to not fiddle with the timer registers in this way, and then I
> > honestly don't know if we should try to fix legacy userspace in the
> > kernel, but based on the feedback from Jan, I suppose not.
> 
> arm_cpu_is_big_endian() doesn't actually want to write
> back any state -- all it's interested in is reading.
> So we really ought not to need to write anything back there.
> kvm-all.c's sync functions don't seem to provide a "sync
> kernel state to userspace but I promise I'm not going to
> dirty it" function though. I guess we could add one.
> 
> (Overall it's kind of fragile even if we can avoid this
> specific case where we're writing back the counter state,
> though -- we should probably think about the sync level
> stuff as well.)

Sounds to me like we should add the sync level stuff first, as it should
catch all callers, and afterwards consider adding the sync-one-way
optimization.

-Christoffer
