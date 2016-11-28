From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test cases
Date: Mon, 28 Nov 2016 11:51:35 +0100
Message-ID: <20161128105135.ryolphjeiho56hbm@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1661940795
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 05:50:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2l8cLx+b3XL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 05:50:56 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C44A240782
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 05:50:56 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
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
Cc: mttcg@greensocs.com, nikunj@linux.vnet.ibm.com, kvm@vger.kernel.org, mark.burton@greensocs.com, marc.zyngier@arm.com, jan.kiszka@siemens.com, qemu-devel@nongnu.org, cota@braap.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, serge.fdrv@gmail.com, bobby.prani@gmail.com, kvmarm@lists.cs.columbia.edu, rth@twiddle.net
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:22PM +0000, Alex Benn=E9e wrote:
> Hi,
> =

> Looking at my records it seems as though it has been a while since I
> last posted these tests. As I'm hoping to get the final bits of MTTCG
> merged upstream on the next QEMU development cycle I've been re-basing
> these and getting them cleaned up for merging.
> =

> Some of the patches might be worth taking now if the maintainers are
> happy to do so (run_test tweaks, libcflat updates?). The others could
> do with more serious review. I've CC'd some of the ARM guys to look
> over the tlbflush/barrier tests so they can cast their expert eyes
> over them ;-)
> =

> There are two additions to the series.
> =

> The tcg-test is a general torture test aimed at QEMU's TCG execution
> model. It stresses the cpu execution loop through the use of
> cross-page and computed jumps. It can also add IRQ's and self-modifying
> code to the mix.
> =

> The tlbflush-data test is a new one, the old tlbflush test is renamed
> tlbflush-code to better indicate the code path it exercise. The the
> code test tests the translation invalidation pathways in QEMU the data
> test exercises the SoftMMU's TLBs and explicitly that tlbflush
> completion semantics are correct.
> =

> The tlbflush-data passes most of the times on real hardware but
> definitely showed the problem with deferred TLB flushes running under
> MTTCG QEMU. I've looked at some of the failure cases on real hardware
> and it did look like a timestamp appeared on a page that shouldn't
> have been accessible at the time - I don't know if this is a real
> silicon bug or my misreading of the semantics so I'd appreciate
> a comment from the experts.

One other thought. I'm not sure how best to approach a bunch of TCG-only
tests getting integrated. I'm thinking it might be nice to give them
their own subdir under the arch dir, e.g. arm/tcg. That subdir would
have its own unittests.cfg file too. Otherwise when we run on KVM we'll
have a load of "SKIP: requires TCG" type messages...

We'll want to add a run_tests.sh option to pass the name of the subdir,
'-d tcg'. When the subdir name is 'tcg' ACCEL could automatically be
switched to 'tcg' as well.

Thanks,
drew
