From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V2] KVM: ARM: Remove pgtable page standard functions from
 stage-2 page tables
Date: Mon, 8 Apr 2019 15:22:38 +0100
Message-ID: <20190408142212.GA4331@fuggles.cambridge.arm.com>
References: <3be0b7e0-2ef8-babb-88c9-d229e0fdd220@arm.com>
 <1552397145-10665-1-git-send-email-anshuman.khandual@arm.com>
 <20190401161638.GB22092@fuggles.cambridge.arm.com>
 <20190401183425.GA106130@google.com>
 <20190402090349.GA25936@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A93B4A389
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 10:22:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A9StIjFll4-R for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 10:22:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A46B34A321
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 10:22:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190402090349.GA25936@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yu Zhao <yuzhao@google.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 10:04:30AM +0100, Will Deacon wrote:
> On Mon, Apr 01, 2019 at 12:34:25PM -0600, Yu Zhao wrote:
> > On Mon, Apr 01, 2019 at 05:16:38PM +0100, Will Deacon wrote:
> > > [+KVM/ARM folks, since I can't take this without an Ack in place from them]
> > > 
> > > My understanding is that this patch is intended to replace patch 3/4 in
> > > this series:
> > > 
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/638083.html
> > 
> > Yes, and sorry for the confusion. I could send an updated series once
> > this patch is merged. Thanks.
> 
> That's alright, I think I'm on top of it (but I'll ask you to check whatever
> I end up merging). Just wanted to make it easy for the kvm folks to dive in
> with no context!

Ok, I've pushed this out onto a temporary branch before I merge it into
-next:

https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=pgtable-ctors

Please can you confirm that it looks ok?

Thanks,

Will
