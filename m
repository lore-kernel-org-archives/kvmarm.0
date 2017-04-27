From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 03/22] KVM: arm/arm64: vgic-its: rename itte into ite
Date: Thu, 27 Apr 2017 04:09:04 -0700
Message-ID: <20170427110904.GI50776@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-4-git-send-email-eric.auger@redhat.com>
 <20170427090504.GC50776@lvm>
 <c32b8369-711c-1a1a-b3c1-bba2408ff003@arm.com>
 <82b7eb70-1705-8fc5-7ec1-12ba58418389@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C20BF40D25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 07:06:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TPZX8UcPHhdM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Apr 2017 07:06:13 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4521D40D19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 07:06:13 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id m123so14862255wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 04:09:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <82b7eb70-1705-8fc5-7ec1-12ba58418389@redhat.com>
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
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 27, 2017 at 11:40:16AM +0200, Auger Eric wrote:
> Hi Christoffer, Andre,
> 
> On 27/04/2017 11:20, Andre Przywara wrote:
> > Hi,
> > 
> > On 27/04/17 10:05, Christoffer Dall wrote:
> >> On Fri, Apr 14, 2017 at 12:15:15PM +0200, Eric Auger wrote:
> >>> The actual abbreviation for the interrupt translation table entry
> >>> is ITE. Let's rename all itte instances by ite.
> >>
> >> Is there really any confusion or problems with using itte?  This is a
> >> lot of churn...
> > 
> > I tend to agree (just didn't dare to mention this before).
> > I see that the spec speaks of "ITE", but the spelled out term hints more
> > at ITTE (because it's a "translation table").
> > Besides three letters tend to be more ambiguous than a four letter
> > identifier.
> > 
> > Would adding a comment to the structure definition help?
> > 
> > But speaking of churn I am not sure how much more work dropping this
> > patch now creates on Eric's side ...
> 
> I addressed one comment from Marc saying that ITTE was a wrong name and
> he had a patch ready to rename them.
> 
> see https://patchwork.kernel.org/patch/9513491/
> 
> Renaming back would largely impact the other patches I am afraid
> 
Ok, it's fine, Marc likes the change, and Andre is happy that you are
now responsible for all ITS bugs, and I'm happy if you're all happy.

Let's keep this change :)

-Christoffer
