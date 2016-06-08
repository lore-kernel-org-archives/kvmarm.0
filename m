From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v2 00/10] arm/arm64: add gic
 framework
Date: Wed, 8 Jun 2016 12:00:34 +0200
Message-ID: <20160608100034.l4ex6riemq7nyp2c@hawk.localdomain>
References: <87d1nweqsc.fsf@linaro.org>
 <87oa7chqge.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDBD749D64
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2016 05:56:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pMYJTQTKrNwE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2016 05:56:25 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FA1749D4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2016 05:56:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87oa7chqge.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 07, 2016 at 06:13:53PM +0100, Alex Benn=E9e wrote:
> =

> Alex Benn=E9e <alex.bennee@linaro.org> writes:
> =

> > Andrew Jones <drjones@redhat.com> writes:
> >
> >> v2:
> >>  Rebased on on latest master + my "populate argv[0]" series (will
> >>  send a REPOST for that shortly. Additionally a few patches got
> >>  fixes/features;
> >>  07/10 got same fix as kernel 7c9b973061 "irqchip/gic-v3: Configure
> >>        all interrupts as non-secure Group-1" in order to continue
> >>        working over TCG, as the gicv3 code for TCG removed a hack
> >>        it had there to make Linux happy.
> >>  08/10 added more output for when things fail (if they fail)
> >>  09/10 switched gicv3 broadcast implementation to using IRM. This
> >>        found a bug in a recent (but not tip) kernel, which I was
> >>        about to fix, but then I saw MarcZ beat me to it.
> >>  10/10 actually check that the input irq is the received irq
> >
> > Cool stuff. I'll get to reviewing this next week as my kvm-unit-tests
> > queue is getting overly long I need to clean-up and re-submit.
> =

> OK I think I'm done for now. Sorry I've skipped the main bits of the GIC
> test but I'm not up to speed on the GIC layout so I'll defer to people
> who have a better understanding of it ;-)

OK, thanks for the review! May I ask that you also give it some testing?
I'd like some results for, at least, ACCEL=3Dkvm,HOST=3Darm32 (which will
only be gicv2). I've already tested

HOST	BUILD	GICTEST	ACCEL
x86_64	arm32	gicv2	tcg
x86_64	arm32	gicv3	tcg
x86_64	arm64	gicv2	tcg
x86_64	arm64	gicv3	tcg
arm64	arm32	gicv2	kvm, -cpu host,aarch64=3Doff	(mustang)
arm64	arm64	gicv2	kvm, -cpu host			(mustang)
arm64	arm64	gicv3	kvm, -cpu host			(thunderx)

(Note, the gicv3 broadcast test with ACCEL=3Dkvm will fail, unless
 you have a host kernel with dd5f1b049 "irqchip/gic-v3: Fix
 ICC_SGI1R_EL1.INTID decoding mask")

Thanks,
drew =
