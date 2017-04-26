From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save
 API documentation
Date: Wed, 26 Apr 2017 15:00:20 +0200
Message-ID: <20170426130020.GM4104@cbox>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
 <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
 <CAFEAcA-u-sH+v-Pnr_3gRC3iSJP0ZK68+GqkDzmi3xe1-B2WAQ@mail.gmail.com>
 <20170426084830.GB2098@work-vm>
 <4dc866a0-582c-af69-916f-eb435988b5ec@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E7F540C30
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 08:57:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2BDgumbwy8wZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 08:57:31 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 821DC40C17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 08:57:31 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id w64so49817291wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 06:00:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4dc866a0-582c-af69-916f-eb435988b5ec@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "prasun.kapoor" <Prasun.Kapoor@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 26, 2017 at 11:57:16AM +0200, Auger Eric wrote:
> Hi Peter, Dave,
> 
> On 26/04/2017 10:48, Dr. David Alan Gilbert wrote:
> > * Peter Maydell (peter.maydell@linaro.org) wrote:
> >> On 26 April 2017 at 09:26, Auger Eric <eric.auger@redhat.com> wrote:
> >>> On 25/04/2017 12:43, Peter Maydell wrote:
> >>>> When does the -EFAULT return happen? (if the guest points GITS_BASER<n>
> >>>> etc at invalid memory, presumably?)
> >>>
> >>> Yes that's correct, when GICR_PENDBASER contains a bad GPA.
> >>>
> >>>>  How does the QEMU migration code
> >>>> handle this case? Failing migration because the guest has done something
> >>>> silly doesn't seem too palatable, but trying to avoid that could be
> >>>> more effort than an obscure corner case really merits.
> >>>
> >>> The kvm_device_access will cause an abort() as for other errors returned
> >>> by kvm_device_ioctl().
> >>
> >> That's pretty nasty. Guests shouldn't be able to provoke QEMU
> >> into abort()ing, ideally. We don't necessarily have to produce
> >> a successful migration, but we should at least fail it cleanly.
> > 
> > Yes, no abort()'s during migration due to guest behaviour.
> > They always end up coming back around to being filed as migration
> > bugs and people worry why they've got cores.
> > 
> > Ideally log a message into stderr to say that the guest state
> > is inconsistent so that when someone comes to debug it then they
> > can see it's obvious.
> 
> OK I agree. I will respin the QEMU part accordingly and in that
> situation I won't abort and will print a message.
> 
Alternatively we should mark a pending error notification to the guest
in KVM, so that when the guest boots it gets something like an SError
instead, given that presumably the guest wrote the weird value.  Except
of course if the problem is caused by QEMU fudging with the register
value for the PENDBASER.

Just a thought.

Thanks,
-Christoffer
