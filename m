From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 05/45] KVM: arm/arm64: vgic-new: Add acccessor to new
 struct vgic_irq instance
Date: Tue, 26 Apr 2016 20:42:37 +0200
Message-ID: <20160426184237.GA25138@cbox>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-6-git-send-email-andre.przywara@arm.com>
 <20160425161525.b4hqjrrharfdsdgo@hawk.localdomain>
 <20160425194901.GM16590@cbox> <571F250A.2040507@arm.com>
 <20160426094433.z5y44u5eb3ovkfb6@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC277410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2016 14:40:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IeeYDwYtpCpf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2016 14:40:06 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE18040FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2016 14:40:06 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id e201so7961865wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2016 11:42:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160426094433.z5y44u5eb3ovkfb6@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 26, 2016 at 11:44:33AM +0200, Andrew Jones wrote:
> On Tue, Apr 26, 2016 at 09:21:30AM +0100, Marc Zyngier wrote:
> > On 25/04/16 20:49, Christoffer Dall wrote:
> > > On Mon, Apr 25, 2016 at 06:15:25PM +0200, Andrew Jones wrote:
> > >> Hi Andre,
> > >>
> > >> I'm just randomly jumping in here because I spotted a typo in $SUBJECT.
> > >> 'accessor' has too many c's. Also, just curious, but if the author is
> > >> from Linaro (hi Christoffer), then why do the new files this patch adds
> > >> have ARM copyrights?
> > >>
> > > 
> > > We just decided to let ARM deal with asserting the license since we all
> > > collaborated on it, but others also suggested that we should let ARM and
> > > Linaro share the license.
> > 
> > I personally have no objections to having both ARM and Linaro sharing
> > the copyright, but I just don't know how this works in practice (and
> > asking any legal department is a sure recipe to delay these patches for
> > an extra 6 months, give or take a few years).
> > 
> > In the end, all I care about is the licence under which the code is
> > released.
> >
> 
> Thanks, my curiosity is satisfied. I fully agree that if it's not easy
> to share a collaborated file, then it's just a matter of flipping a coin,
> or defaulting to whichever has the majority.
> 
I also only care about the license under which it is released.

I opted for defaulting to the company that is most set up to pursue any
potential infringement on the copyright.

-Christoffer
