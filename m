From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH] Support micro operation measurement on
 arm64
Date: Tue, 19 Dec 2017 14:07:06 +0100
Message-ID: <20171219130706.GD31048@cbox>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <20171218181440.yggldvw6lry6wsza@hawk.localdomain>
 <CAO+sbHGU6EUUHQynAaA33T-ThUwA=5f9yq_Uq2mLtXRcHN02Ew@mail.gmail.com>
 <20171219090620.GA31048@cbox>
 <20171219121109.hxqbqjkdgt7k5jo6@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219121109.hxqbqjkdgt7k5jo6@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 19, 2017 at 01:11:09PM +0100, Andrew Jones wrote:
> On Tue, Dec 19, 2017 at 10:06:20AM +0100, Christoffer Dall wrote:
> > On Mon, Dec 18, 2017 at 03:58:49PM -0500, Shih-Wei Li wrote:
> > > On Mon, Dec 18, 2017 at 1:14 PM, Andrew Jones <drjones@redhat.com> wrote:
> > > > Hi Shih-Wei,
> > > >
> > > > Thanks for doing this! Porting Christoffer's selftests to kvm-unit-tests
> > > > has been on the kvm-unit-tests' TODO list since it was first introduced.
> > > >
> > > > On Fri, Dec 15, 2017 at 04:15:38PM -0500, Shih-Wei Li wrote:
> > > >> The patch provides support for quantifying the cost of micro level
> > > >> operations on arm64 hardware. The supported operations include hypercall,
> > > >> mmio accesses, EOI virtual interrupt, and IPI send. Measurements are
> > > >> currently obtained using timer counters. Further modifications in KVM
> > > >> will be required to support timestamping using cycle counters, as KVM
> > > >> now disables accesses to the PMU counters from the VM.
> > > >
> > > > KVM only disables access when userspace tells it to, which it doesn't
> > > > do by default. Is there something else missing keeping the PMU counters
> > > > from being used?
> > > 
> > > Thanks for the feedback! What I meant by PMU counters here was for
> > > "CPU cycle counter" specifically. I'm not aware of a way to enable the
> > > PMU cycle counter from QEMU, did I miss something here?
> > > 
> > 
> > We always set MDSCR_EL2.TPM, meaning that you cannot reliably read a
> > cycle counter in the guest.
> > 
> > If userspace tells KVM to emulate a PMU, you will get an emulated result
> > when reading the cycle counter from a guest, instead of an undefined
> > exception, but you will never access the cycle counter directly.
> 
> Ah, of course. Real vs. emulated access makes a big difference here.
> 
> > 
> > Here we want to measure round-trip time from the VM through the
> > hypervisor, and we don't currently count cycles in EL2 with the PMU
> > emulation, and even if we did, we'd be counting additional round-trip
> > times, so if the goal is to get more precision than the arch counters,
> > this won't help you.
> > 
> > What we did for the papers was to hack KVM to not set the TPM bit and
> > jut read the cycle counter directly, but this isn't safe, as the guest
> > then gets full access to the PMU and can mess with the host.
> > 
> > If it's crucial to measure individual operations on a cycle-accurate
> > level, then our options are pretty much to either patch KVM when doing
> > so, or introduce a scary command line parameter, but I'm not thrilled
> > by the idea.
> > 
> > > >
> > > >>
> > > >> We iterate each of the tests for millions of times and output their
> > > >> average, minimum and maximum cost in timer counts. Instruction barriers
> > > >
> > > > Can we reduce the number of iterations and still get valid results? The
> > > > test takes so long that of all the platforms I tested it on timed out
> > > > before it completed, except seattle. The default timeout for kvm-unit-
> > > > tests is 90 seconds. I'd rather a unit test execute in much shorter time
> > > > than that too, in order to keep people encouraged to run them frequently.
> > > > If these tests must run a long time, then I think we should add them to
> > > > the nodefault group.
> > > 
> > > I think it's possible to reduce the timeout without losing accuracy. I
> > > can look into this further.
> > > 
> > 
> > I think just running them for 100,000 or maximum 1,000,000 times should
> > be sufficient.  Alternatively an option to run it for a long time could
> > be provided?
> 
> Providing a number of iterations option or something, that has a
> reasonable default, sounds good to me.
> 
> > 
> > > >
> > > >> were used before and after taking timestamps to avoid out-of-order
> > > >> execution or pipelining from skewing our measurements.
> > > >>
> > > >> To improve precision in the measurements, one should consider pinning
> > > >> each VCPU to a specific physical CPU (PCPU) and ensure no other task
> > > >> could run on that PCPU to skew the results. This can be achieved by
> > > >> enabling QMP server in the QEMU command in unittest.cfg for micro test,
> > > >> allowing a client program to get the thread_id for each VCPU thread
> > > >> from the QMP server. Based on the information, the client program can
> > > >> then pin the corresponding VCPUs to dedicated PCPUs and isolate
> > > >> interrupts and tasks from those PCPUs.
> > > >
> > > > To isolate the CPUs one would need to boot the host with the isolcpus
> > > > kernel command line option. Pinning the VCPUs is pretty easy though,
> > > > so we could provide a script that does that in kvm-unit-tests and then
> > > > always use it for this test. The script could also warn if we're
> > > > pinning to CPUs that haven't been isolated.
> > > >
> > > 
> > > My intention was to support VCPU pinning as an optional feature,
> > > so the users that care about extra precision can add qmp option in
> > > QEMU config and run the script to pin VCPUs. Otherwise, the test can
> > > be conducted in a fashion similar to what's done in vmexit on x86.
> > > 
> > 
> > If we can script VCPU pinning, I think that's preferred.  In our
> > experiments we never actually saw measurable differences between
> > isolcpus and simple vcpu pinning when using a high enough number of
> > iterations, except when looking at things like jitter, which we don't do
> > for these tests.
> > 
> > That notwithstanding, I think it's an optional feature that can be added
> > later.
> 
> Yeah, let's do it later, but I think doing it makes enough sense that
> it's worth writing more bash.
> 

Agreed.

> > 
> > > >>
> > > >> The patch has been tested on arm64 hardware including AMD Seattle and
> > > >> ThunderX2, which has GICv2 and GICv3 respectively.
> > > >
> > > > I tried thunderx2, amberwing, mustang, and seattle. Only seattle
> > > > completed, the rest timed out.
> > > 
> > > I have only tested the code by invoking test directly using make
> > > standalone like the following. I did notice that it took ~90 seconds
> > > to finish the test itself.
> > > ./"tests/micro-cost"
> 
> standalone still uses timeout with 90 seconds. So your hardware was just
> faster than mine, I guess :-)
> 

[indentation confusion?]

You're responding to something Shih-Wei wrote here, but I didn't
understand Shih-Wei's answer, and I think he ran the work on Seattle, so
not sure what the difference was.

Anyway, let's have it execute more fast by default as you suggest.

-Christoffer
