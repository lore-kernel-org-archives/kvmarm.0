From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 3/3] arm64: timer: Add support for phys
 timer testing
Date: Tue, 18 Jul 2017 16:29:03 +0200
Message-ID: <20170718142903.xduo635ph6ufejyu@kamzik.brq.redhat.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-4-cdall@linaro.org>
 <20170718120957.uvxb546eqpj5oxbp@kamzik.brq.redhat.com>
 <20170718130153.GD14069@cbox>
 <20170718132324.i5we5dsmpva45dw5@kamzik.brq.redhat.com>
 <20170718133103.GE14069@cbox>
 <20170718135003.4vzeoc2ahykvi4ol@kamzik.brq.redhat.com>
 <CAMJs5B-vjze6dZ_fhzjbY=vsx9S7HaCa_LXNwt_NhOWAFsWraQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A771840D68
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:28:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vRKZD+uiyNBA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 10:28:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98DAC40D1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:28:37 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAMJs5B-vjze6dZ_fhzjbY=vsx9S7HaCa_LXNwt_NhOWAFsWraQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 04:15:23PM +0200, Christoffer Dall wrote:
> On Tue, Jul 18, 2017 at 3:50 PM, Andrew Jones <drjones@redhat.com> wrote:
> > On Tue, Jul 18, 2017 at 03:31:03PM +0200, Christoffer Dall wrote:
> >> On Tue, Jul 18, 2017 at 03:23:24PM +0200, Andrew Jones wrote:
> >> > On Tue, Jul 18, 2017 at 03:01:53PM +0200, Christoffer Dall wrote:
> >> > > On Tue, Jul 18, 2017 at 02:09:57PM +0200, Andrew Jones wrote:
> >> > > > On Thu, Jul 13, 2017 at 09:20:09PM +0200, Christoffer Dall wrote:
> >> > > > > Rearrange the code to be able to reuse as much as posible and add
> >> > > > > support for testing the physical timer as well.
> >> > > > >
> >> > > > > Also change the default unittests configuration to run a separate vtimer
> >> > > > > and ptimer test so that older kernels without ptimer support just show a
> >> > > > > failure.
> >> > > >
> >> > > > We could run tests for both the ptimer and vtimer in a single execution,
> >> > > > rather than splitting them and requiring the input, because the read of
> >> > > > cntp_ctl_el0 will predictably cause an UNKNOWN exception. Also, by
> >> > > > applying the errata framework we can ensure that if we expect the read
> >> > > > to work, i.e. the host kernel is recent enough, then, if we still get
> >> > > > an UNKNOWN exception, we can report FAIL instead of SKIP. Below is an
> >> > > > add on patch that makes the conversion. Let me know what you think.
> >> > >
> >> > > The problem with this patch, is that we then report SKIP instead of
> >> > > FAIL, when we regress the kernel and actually break physical counter
> >> > > access (which I did while developing my series).
> >> > >
> >> >
> >> > Well, as long as the cntp_ctl_el0 read isn't regressed into generating
> >> > an unknown exception, then the ptimer tests will always be run, reporting
> >> > failures as they should.
> >> >
> >>
> >> And that is exactly what we've done a couple of times around, because
> >> VHE changes the layout of the trap control register to EL2, and the way
> >> we handle traps to KVM of the physical counter register is to inject an
> >> undefined exception...
> >>
> >> > > I think something like this should be discovered by way of capabilities
> >> > > or hardcoding a kernel version.
> >> >
> >> > That's possible already by making one more change (which I should have
> >> > made in the first place)
> >> >
> >> > diff --git a/errata.txt b/errata.txt
> >> > index 5608a308ce7c9..8859d4f1d3860 100644
> >> > --- a/errata.txt
> >> > +++ b/errata.txt
> >> > @@ -4,4 +4,5 @@
> >> >  #---------------:-----------------------:--------------------------------------
> >> >  9e3f7a296940   : 4.9                   : arm64: KVM: pmu: Fix AArch32 cycle counter access
> >> >  6c7a5dce22b3   : 4.12                  : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
> >> > +7b6b46311a85   : 4.11                  : KVM: arm/arm64: Emulate the EL1 phys timer registers
> >> >  #---------------:-----------------------:--------------------------------------
> >> >
> >> > With that change, when the test runtime system detects it's running on
> >> > a host with at least a 4.11 kernel, then it will automatically set
> >> > ERRATA_7b6b46311a85=y (unless overridden by the user). Having that
> >> > errata set will even ensure the cntp_ctl_el0 read is tested.
> >> >
> >>
> >> ah, ok then that makes perfect sense.
> >>
> >> I'm a little confused about the logic though, if we regress the physical
> >> counter access on a newer kernel in a way that gives you an undefined
> >> exception, will we get FAIL or SKIP?
> >>
> >> We should get FAIL.
> >
> > We'll get FAIL as long as the user doesn't override ERRATA_7b6b46311a85
> > to be 'n'. See the if-else in set_ptimer_unsupported()
> >
> >   if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
> >           report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
> >   } else if (ptimer_unsupported) {
> >           report("ptimer: read CNTP_CTL_EL0", false);
> >           report_info("ptimer: skipping remaining tests");
> >   }
> 
> so report("...", false); means FAIL?

Yup, first argument following fmt to report() is the test result. We
should probably create report_pass/fail() wrappers.

Thanks,
drew
