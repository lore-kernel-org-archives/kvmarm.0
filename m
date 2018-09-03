From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 2/2] arm64: add micro-bench
Date: Mon, 3 Sep 2018 18:31:39 +0200
Message-ID: <20180903163139.arpf6vpg4d2z7mju@kamzik.brq.redhat.com>
References: <20180830141733.21725-1-drjones@redhat.com>
 <20180830141733.21725-3-drjones@redhat.com>
 <CAO+sbHHswsoUqhnwwzB5bGoc7G_cbkw24t6Br1=7bULVxoctaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE0E4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 12:31:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tbiXXrtgkB0X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 12:31:43 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF64B49F94
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 12:31:43 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAO+sbHHswsoUqhnwwzB5bGoc7G_cbkw24t6Br1=7bULVxoctaw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 03, 2018 at 11:06:51AM -0400, Shih-Wei Li wrote:
> On Thu, Aug 30, 2018 at 10:17 AM, Andrew Jones <drjones@redhat.com> wrote:
> > +static bool test_init(void)
> > +{
> > +       int v = gic_init();
> > +
> > +       if (!v) {
> > +               printf("No supported gic present, skipping tests...\n");
> > +               return false;
> > +       }
> > +
> > +       if (nr_cpus < 2) {
> > +               printf("At least two cpus required, skipping tests...\n");
> > +               return false;
> > +       }
> > +
> > +       switch (v) {
> > +       case 2:
> > +               vgic_dist_base = gicv2_dist_base();
> > +               write_eoir = gicv2_write_eoir;
> > +       case 3:
> > +               vgic_dist_base = gicv3_dist_base();
> > +               write_eoir = gicv3_write_eoir;
> > +       }
> 
> I think we'll need a "break" in the switch case body for gicv2 here
> otherwise it'll fall into the case body below and refer to the wrong
> symbols for gicv3.
> 
> As I've tested on my seattle server hardware (with gicv2), this results
> to incorrect execution in mmio_read_vgic_exec and a crash in
> eoi_exec().
>

Argh... Obviously my testing of this was pretty poor. You are certainly
right that I'm missing breaks in this switch. If you don't mind, please
add them, along with the fix in v2, to your local repo and test again.
I'll hold off on sending v3 until you've had a chance to test and review
more.

Thanks,
drew
