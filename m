Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDA6C54EE9
	for <kvmarm@archiver.kernel.org>; Thu,  8 Sep 2022 13:29:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08DEE4CC45;
	Thu,  8 Sep 2022 09:29:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3BayokVXApYB; Thu,  8 Sep 2022 09:29:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5A44CBF9;
	Thu,  8 Sep 2022 09:29:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F1894CC08
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2022 09:29:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r9qsqfmKuOqt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2022 09:29:04 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 472924CBF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2022 09:29:04 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C90D6B82075;
 Thu,  8 Sep 2022 13:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCA9C433D6;
 Thu,  8 Sep 2022 13:28:58 +0000 (UTC)
Date: Thu, 8 Sep 2022 14:28:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Use kmemleak_free_part_phys() to unregister
 hyp_mem_base
Message-ID: <YxnuFzxDpFwEYLxF@arm.com>
References: <20220908130659.2021-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220908130659.2021-1-yuzenghui@huawei.com>
Cc: will@kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Sep 08, 2022 at 09:06:59PM +0800, Zenghui Yu wrote:
> With commit 0c24e061196c ("mm: kmemleak: add rbtree and store physical
> address for objects allocated with PA"), kmemleak started to put the
> objects allocated with physical address onto object_phys_tree_root tree.
> The kmemleak_free_part() therefore no longer worked as expected on
> physically allocated objects (hyp_mem_base in this case) as it attempted to
> search and remove things in object_tree_root tree.
> 
> Fix it by using kmemleak_free_part_phys() to unregister hyp_mem_base. This
> fixes an immediate crash when booting a KVM host in protected mode with
> kmemleak enabled.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
