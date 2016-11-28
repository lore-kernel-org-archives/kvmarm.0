From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test cases
Date: Mon, 28 Nov 2016 15:04:45 +0100
Message-ID: <20161128140445.j336ksd7vqhi4ivz@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161128103744.s3wq53xzsxvu5uus@kamzik.brq.redhat.com>
 <878ts3uac6.fsf@linaro.org>
 <CAFEAcA9JUOHnJL59EuhQ_dEWjt+YjEcu8LGiJ3CSk_7R4J5Efg@mail.gmail.com>
 <20161128115824.hrofgivt2mlfk7fh@kamzik.brq.redhat.com>
 <CAFEAcA8-3qHnp1T4bAiUL3NT8fHWik7-8zruyQKGgfADn5xF9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C949440543
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 09:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zOzaejDJ1-OQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 09:04:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BCF940428
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 09:04:05 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8-3qHnp1T4bAiUL3NT8fHWik7-8zruyQKGgfADn5xF9w@mail.gmail.com>
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
Cc: MTTCG Devel <mttcg@greensocs.com>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@siemens.com>, Mark Burton <mark.burton@greensocs.com>, QEMU Developers <qemu-devel@nongnu.org>, "Emilio G. Cota" <cota@braap.org>, Fedorov Sergey <serge.fdrv@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Pranith Kumar <bobby.prani@gmail.com>, Richard Henderson <rth@twiddle.net>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 28, 2016 at 01:30:54PM +0000, Peter Maydell wrote:
> On 28 November 2016 at 11:58, Andrew Jones <drjones@redhat.com> wrote:
> > On Mon, Nov 28, 2016 at 11:14:48AM +0000, Peter Maydell wrote:
> >> On 28 November 2016 at 11:12, Alex Benn=E9e <alex.bennee@linaro.org> w=
rote:
> >> >
> >> > Andrew Jones <drjones@redhat.com> writes:
> >> >> I've skimmed over everything looking at it from a framwork/sytle
> >> >> perspective. I didn't dig in trying to understand the tests though.
> >> >> One general comment, I see many tests introduce MAX_CPUS 8. Why do
> >> >> that? Why not allow all cpus by using NR_CPUS for the array sizes?
> >> >
> >> > Yeah - I can fix those. I wonder what the maximum is with GIC V3?
> >>
> >> So large that you don't want to hardcode it as an array size...
> >
> > 255 with the gic series, not yet merged.
> =

> I was talking about the architectural GICv3 limit, which is larger
> than that by many orders of magnitude. For QEMU it looks like
> MAX_CPUMASK_BITS is now 288 rather than 255.

Ah, yeah. So far we haven't considered testing limits beyond what
KVM supports, VGIC_V3_MAX_CPUS=3D255. However with TCG, and some
patience, we could attempt to test bigger limits. In that case,
though, we'll want to recompile kvm-unit-tests with a larger NR_CPUS
and run a specific unit test.

mach-virt still has 255 as well, mc->max_cpus =3D 255, so we'd have
to bump that too if we want to experiment.

Thanks,
drew
