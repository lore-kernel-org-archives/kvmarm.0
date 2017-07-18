From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests 3/3] arm64: timer: Add support for phys
 timer testing
Date: Tue, 18 Jul 2017 15:31:03 +0200
Message-ID: <20170718133103.GE14069@cbox>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-4-cdall@linaro.org>
 <20170718120957.uvxb546eqpj5oxbp@kamzik.brq.redhat.com>
 <20170718130153.GD14069@cbox>
 <20170718132324.i5we5dsmpva45dw5@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170718132324.i5we5dsmpva45dw5@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 03:23:24PM +0200, Andrew Jones wrote:
> On Tue, Jul 18, 2017 at 03:01:53PM +0200, Christoffer Dall wrote:
> > On Tue, Jul 18, 2017 at 02:09:57PM +0200, Andrew Jones wrote:
> > > On Thu, Jul 13, 2017 at 09:20:09PM +0200, Christoffer Dall wrote:
> > > > Rearrange the code to be able to reuse as much as posible and add
> > > > support for testing the physical timer as well.
> > > > 
> > > > Also change the default unittests configuration to run a separate vtimer
> > > > and ptimer test so that older kernels without ptimer support just show a
> > > > failure.
> > > 
> > > We could run tests for both the ptimer and vtimer in a single execution,
> > > rather than splitting them and requiring the input, because the read of
> > > cntp_ctl_el0 will predictably cause an UNKNOWN exception. Also, by
> > > applying the errata framework we can ensure that if we expect the read
> > > to work, i.e. the host kernel is recent enough, then, if we still get
> > > an UNKNOWN exception, we can report FAIL instead of SKIP. Below is an
> > > add on patch that makes the conversion. Let me know what you think.
> > 
> > The problem with this patch, is that we then report SKIP instead of
> > FAIL, when we regress the kernel and actually break physical counter
> > access (which I did while developing my series).
> >
> 
> Well, as long as the cntp_ctl_el0 read isn't regressed into generating
> an unknown exception, then the ptimer tests will always be run, reporting
> failures as they should.
> 

And that is exactly what we've done a couple of times around, because
VHE changes the layout of the trap control register to EL2, and the way
we handle traps to KVM of the physical counter register is to inject an
undefined exception...

> > I think something like this should be discovered by way of capabilities
> > or hardcoding a kernel version.
> 
> That's possible already by making one more change (which I should have
> made in the first place)
> 
> diff --git a/errata.txt b/errata.txt
> index 5608a308ce7c9..8859d4f1d3860 100644
> --- a/errata.txt
> +++ b/errata.txt
> @@ -4,4 +4,5 @@
>  #---------------:-----------------------:--------------------------------------
>  9e3f7a296940   : 4.9                   : arm64: KVM: pmu: Fix AArch32 cycle counter access
>  6c7a5dce22b3   : 4.12                  : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
> +7b6b46311a85   : 4.11                  : KVM: arm/arm64: Emulate the EL1 phys timer registers
>  #---------------:-----------------------:--------------------------------------
> 
> With that change, when the test runtime system detects it's running on
> a host with at least a 4.11 kernel, then it will automatically set
> ERRATA_7b6b46311a85=y (unless overridden by the user). Having that
> errata set will even ensure the cntp_ctl_el0 read is tested.
> 

ah, ok then that makes perfect sense.

I'm a little confused about the logic though, if we regress the physical
counter access on a newer kernel in a way that gives you an undefined
exception, will we get FAIL or SKIP?

We should get FAIL.

Thanks,
-Christoffer
