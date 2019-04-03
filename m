From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool v3 0/3] vfio-pci: Support INTx mode re-enabling
Date: Wed, 3 Apr 2019 13:43:31 +0100
Message-ID: <20190403124331.GA16362@fuggles.cambridge.arm.com>
References: <20190326074131.4284-1-leo.yan@linaro.org>
 <20190402165025.GA1442@fuggles.cambridge.arm.com>
 <20190403014730.GA5339@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ABA84A3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 08:43:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mghwe0aDsXdd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Apr 2019 08:43:38 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E01034A331
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Apr 2019 08:43:37 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190403014730.GA5339@leoy-ThinkPad-X240s>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Leo Yan <leo.yan@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 03, 2019 at 11:58:17AM +0800, Leo Yan wrote:
> On Tue, Apr 02, 2019 at 05:50:25PM +0100, Will Deacon wrote:
> > Just checking, but is this series intended to supersede this one:
> > 
> > https://www.spinics.net/lists/kvm/msg183750.html
> > 
> > ?
> 
> Yes, this patch series is v3 and the link you pointed out is the old
> patch series v1.  Sorry for confusion.

No, that's fine and what I was assuming. Just wanted to confirm due to the
change in $subject, so I don't miss anything.

Will
