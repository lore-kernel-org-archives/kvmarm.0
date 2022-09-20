Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330E0ECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 15:39:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C3D4B24D;
	Tue, 20 Sep 2022 11:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 67iOHs64NeXk; Tue, 20 Sep 2022 11:39:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 788424B637;
	Tue, 20 Sep 2022 11:39:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20AE74B62E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 11:39:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A0kO6tPztNBH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 11:39:54 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8FB34B24D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 11:39:54 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D9A6C624D1;
 Tue, 20 Sep 2022 15:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E9C433D7;
 Tue, 20 Sep 2022 15:39:50 +0000 (UTC)
Date: Tue, 20 Sep 2022 16:39:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
Message-ID: <Yynewxzc6Zy8ls0N@arm.com>
References: <20220810193033.1090251-4-pcc@google.com>
 <202208111500.62e0Bl2l-lkp@intel.com> <YxDy+zFasbAP7Yrq@arm.com>
 <YxYrgyybBMUqFswq@arm.com> <878rmfkzbu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878rmfkzbu.wl-maz@kernel.org>
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 Evgenii Stepanov <eugenis@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Sep 19, 2022 at 07:12:53PM +0100, Marc Zyngier wrote:
> On Mon, 05 Sep 2022 18:01:55 +0100,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Peter, please let me know if you want to pick this series up together
> > with your other KVM patches. Otherwise I can post it separately, it's
> > worth merging it on its own as it clarifies the page flag vs tag setting
> > ordering.
> 
> I'm looking at queuing this, but I'm confused by this comment. Do I
> need to pick this as part of the series? Or is this an independent
> thing (my hunch is that it is actually required not to break other
> architectures...).

This series series (at least the first patches) won't apply cleanly on
top of 6.0-rc1 and, of course, we shouldn't break other architectures. I
can repost the whole series but I don't have the setup to test the
MAP_SHARED KVM option (unless Peter plans to post it soon).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
