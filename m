From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save
 API documentation
Date: Wed, 26 Apr 2017 09:48:31 +0100
Message-ID: <20170426084830.GB2098@work-vm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
 <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
 <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54EE440C42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:45:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4DZFNmOWUA7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 04:45:48 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 877E340C4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:45:48 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
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
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On 26 April 2017 at 09:26, Auger Eric <eric.auger@redhat.com> wrote:
> > On 25/04/2017 12:43, Peter Maydell wrote:
> >> When does the -EFAULT return happen? (if the guest points GITS_BASER<n>
> >> etc at invalid memory, presumably?)
> >
> > Yes that's correct, when GICR_PENDBASER contains a bad GPA.
> >
> >>  How does the QEMU migration code
> >> handle this case? Failing migration because the guest has done something
> >> silly doesn't seem too palatable, but trying to avoid that could be
> >> more effort than an obscure corner case really merits.
> >
> > The kvm_device_access will cause an abort() as for other errors returned
> > by kvm_device_ioctl().
> 
> That's pretty nasty. Guests shouldn't be able to provoke QEMU
> into abort()ing, ideally. We don't necessarily have to produce
> a successful migration, but we should at least fail it cleanly.

Yes, no abort()'s during migration due to guest behaviour.
They always end up coming back around to being filed as migration
bugs and people worry why they've got cores.

Ideally log a message into stderr to say that the guest state
is inconsistent so that when someone comes to debug it then they
can see it's obvious.

Dave

> thanks
> -- PMM
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
