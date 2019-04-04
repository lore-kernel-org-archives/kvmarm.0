From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH kvmtool v3 0/3] vfio-pci: Support INTx mode re-enabling
Date: Thu, 4 Apr 2019 10:57:39 +0800
Message-ID: <20190404025739.GA4490@leoy-ThinkPad-X240s>
References: <20190326074131.4284-1-leo.yan@linaro.org>
 <20190402165025.GA1442@fuggles.cambridge.arm.com>
 <20190403014730.GA5339@leoy-ThinkPad-X240s>
 <20190403124331.GA16362@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD8344A424
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 22:57:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qg+K6MebPVOf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Apr 2019 22:57:46 -0400 (EDT)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CAC04A36C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 22:57:46 -0400 (EDT)
Received: by mail-pf1-f194.google.com with SMTP id z5so585502pfn.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Apr 2019 19:57:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190403124331.GA16362@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On Wed, Apr 03, 2019 at 01:43:31PM +0100, Will Deacon wrote:
> On Wed, Apr 03, 2019 at 11:58:17AM +0800, Leo Yan wrote:
> > On Tue, Apr 02, 2019 at 05:50:25PM +0100, Will Deacon wrote:
> > > Just checking, but is this series intended to supersede this one:
> > > 
> > > https://www.spinics.net/lists/kvm/msg183750.html
> > > 
> > > ?
> > 
> > Yes, this patch series is v3 and the link you pointed out is the old
> > patch series v1.  Sorry for confusion.
> 
> No, that's fine and what I was assuming. Just wanted to confirm due to the
> change in $subject, so I don't miss anything.

Yes.

Gently ping Jean-Philippe if I can get green light for this patch set?
Otherwise, please let me know if I need to follow up anything; thanks
for reviewing.

Thanks,
Leo Yan
