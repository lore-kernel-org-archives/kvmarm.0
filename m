Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76EDC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 08:27:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BFFA4B64F;
	Tue, 20 Sep 2022 04:27:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G9QfuUKf2mQ2; Tue, 20 Sep 2022 04:27:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F894B637;
	Tue, 20 Sep 2022 04:27:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78B9B4B630
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:27:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8H9yaPk9DzQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 04:27:05 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FDAF4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 04:27:05 -0400 (EDT)
Date: Tue, 20 Sep 2022 10:27:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663662424;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wkhrlpTcE9gr3IvZCURiyAx4WO76j5beHMNEbt6Gc3s=;
 b=Tw/OLBTom06BSxI2FYf7MbQKQomDYGYO2QHssZ2C58PVKMJOEB1FSzmjUQ4clCZ+x+Q7Pt
 ToheBMvnADX/lAnHCX/7dLnQWYB/elY6svwd9SNf1EE5WvL3xIsuGavxw/unc7wndB2Efi
 YZmSaW56xZDSHKvQCA0EF/4snymwb30=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 03/19] lib/alloc_phys: Use
 phys_alloc_aligned_safe and rename it to memalign_early
Message-ID: <20220920082703.u37twjovg7yv2ea6@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-4-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Aug 09, 2022 at 10:15:42AM +0100, Alexandru Elisei wrote:
> phys_alloc_aligned_safe() is called only by early_memalign() and the safe
> parameter is always true. In the spirit of simplifying the code, merge the
> two functions together. Rename it to memalign_early(), to match the naming
> scheme used by the page allocator.
> 
> Change the type of top_safe to phys_addr_t, to match the type of the top
> and base variables describing the available physical memory; this is a
> cosmetic change only, since libcflat.h defines phys_addr_t as an alias
> for u64.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_phys.c | 38 ++++++++++++++------------------------
>  1 file changed, 14 insertions(+), 24 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
