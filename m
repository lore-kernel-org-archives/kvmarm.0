Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C5EECAAD8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 11:08:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C694BB5B;
	Wed, 14 Sep 2022 07:08:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IfrDPx9bK1zv; Wed, 14 Sep 2022 07:08:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C01284BB98;
	Wed, 14 Sep 2022 07:08:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E524BB28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 07:08:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DufJYWN7CIw0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 07:08:19 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EC5B4B9A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 07:08:19 -0400 (EDT)
Date: Wed, 14 Sep 2022 12:08:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663153697;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4icdTTwMOEDl/FiFqEWnD1meNX7EE2LU8zEMLkINvBI=;
 b=W6EdHTzE6hL8xf2xCXTgPfAWhGW726ekqZCMjg7k35lyEBz7Tt3ZmzHp0iwg7+fHlaXFD6
 dahkLcn8Jn4N+5PEv8i7exrmNXbsNqkC/YGp9Dh5q1LGzRfEanP4LFGy9xYjWbimwNLn43
 LcJIWApPaRoNmrdDX3GsRJLYLkQNYHs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Use kmemleak_free_part_phys() to unregister
 hyp_mem_base
Message-ID: <YyG2H8PbJjehAwch@google.com>
References: <20220908130659.2021-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220908130659.2021-1-yuzenghui@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: will@kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
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

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Marc or Paolo, do one of you want to pick this patch up? Looks like a
good fix.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
