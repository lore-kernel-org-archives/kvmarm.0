Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1032EC28D13
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 00:08:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 597A04CE30;
	Mon, 22 Aug 2022 20:08:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux-foundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n9ptxOydk2GB; Mon, 22 Aug 2022 20:08:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD764CE33;
	Mon, 22 Aug 2022 20:08:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3496F4CE30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:08:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FTg9cPoneKaD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 20:08:24 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 392F54CE2A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:08:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 69469B8199B;
 Tue, 23 Aug 2022 00:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36841C433D6;
 Tue, 23 Aug 2022 00:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1661213301;
 bh=ql3WhYwvtGyV0nnW4S8Tm+rGjMLwd8ee87bzIsZn2ms=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=vRwnTZRxoiSrk0tZjUMMz0NWpy3KJjQW1Gzwl4s5BxfTEsZyNaPKh3ddH+egMSRAD
 2sR4hnNN+xm0NXU8iGalWA3ooH8VIUWkt4psle8L7uIrU6rbO7bDLYXnhrZRLNscHk
 bIFHQN8LlfFrHCUIGNFAHen8hRb613xJNDRLoVjU=
Date: Mon, 22 Aug 2022 17:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count
 secondary page table uses.
Message-Id: <20220822170819.60d888a5d3e23f40fd1b2e16@linux-foundation.org>
In-Reply-To: <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
 <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
 <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, 22 Aug 2022 17:04:57 -0700 Yosry Ahmed <yosryahmed@google.com> wrote:

> > SecondaryPageTables is too long (unfortunately), it messes up the
> > formatting in node_read_meminfo() and meminfo_proc_show(). I would
> > prefer "secondary" as well, but I don't know if breaking the format in
> > this way is okay.
> 
> Any thoughts here Andrew? Change to SecondaryPageTables anyway? Change
> all to use "sec" instead of "secondary"? Leave as-is?

Leave as-is, I guess.  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
