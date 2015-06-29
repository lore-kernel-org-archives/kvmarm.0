From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/3] arm/arm64: speed up spinlocks and atomic ops
Date: Mon, 29 Jun 2015 12:44:27 +0200
Message-ID: <20150629104427.GB2948@hawk.localdomain>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com>
 <1435248739-25425-3-git-send-email-drjones@redhat.com>
 <20150629102832.GJ11332@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3F9756996
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 06:33:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5tY0celZP1Xq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 06:33:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9A8D56990
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 06:33:22 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150629102832.GJ11332@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 29, 2015 at 12:28:32PM +0200, Christoffer Dall wrote:
> On Thu, Jun 25, 2015 at 06:12:18PM +0200, Andrew Jones wrote:
> > spinlock torture tests made it clear that checking mmu_enabled()
> > every time we call spin_lock is a bad idea.
> 
> why a bad idea?  Does it break, is it slow?

Just slow, but really slow. After porting vos' spinlock test
over, there were three implementations to compare, this one,
gcc-builtin, and none. none doesn't really matter as it's not
"real". gcc-builtin took about 6 seconds to complete on my
machine (an x86 notebook, recall it's a tcg test), and this one
took 20 seconds.

> 
> > As most tests will
> > want the MMU enabled the entire time, then just hard code
> > mmu_enabled() to true. Tests that want to play with the MMU can
> > be compiled with CONFIG_MAY_DISABLE_MMU to get the actual check
> > back.
> 
> If we don't care about performance, why this added complexity?

I think the series I sent that allows us to optimize mmu_enabled()
has about the same level of complexity, not much, but now we also
only take 6 seconds with the test. So, IMO, the extra _count
variable is worth it.

Thanks,
drew
