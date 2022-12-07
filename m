Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E03C4708D
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 23:57:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 208C04B87C;
	Wed,  7 Dec 2022 18:57:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A6K+73k-dEKY; Wed,  7 Dec 2022 18:57:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CACE94B878;
	Wed,  7 Dec 2022 18:57:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C338E4B876
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 18:57:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hbpcuqmz3vkC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 18:57:02 -0500 (EST)
Received: from out-213.mta0.migadu.com (out-213.mta0.migadu.com
 [91.218.175.213])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 430054B875
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 18:57:02 -0500 (EST)
Date: Wed, 7 Dec 2022 23:56:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670457420;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qhIDkNMWFrw/BML2Cf6mgZzatycSfUupNCdq7V2NZos=;
 b=HY/h51zVycRcdzDUCbof89MlN7kXyAU/yP5TMyU/lDpo22Zsbhk4m07HUlJcGgLvkJZRuT
 dnCIhswOvG+6aBUJZjZpBj6GW3k6gPWAgy3Sx6sgU0O1Mx2JzoAXpnrU+WgXwKtoYSpZFJ
 6PAe0dxx/BTffdNTRlRNW3m43RV1JmU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Allocate ucall pool from
 MEM_REGION_DATA
Message-ID: <Y5EoR9U/TjdtksHK@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-5-oliver.upton@linux.dev>
 <Y5ElcibE2CubONgm@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5ElcibE2CubONgm@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Dec 07, 2022 at 11:44:50PM +0000, Sean Christopherson wrote:
> On Wed, Dec 07, 2022, Oliver Upton wrote:
> > MEM_REGION_TEST_DATA is meant to hold data explicitly used by a
> > selftest, not implicit allocations due to the selftests infrastructure.
> > Allocate the ucall pool from MEM_REGION_DATA much like the rest of the
> > selftests library allocations.
> > 
> > Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")
> 
> Not that it really matters because no one will backport this verbatim, but this
> is the wrong commit to blame.  As of commit 426729b2cf2e, MEM_REGION_DATA does not
> exist.  And similarly, the common ucall code didn't exist when Ricardo's series
> introduced MEM_REGION_DATA.
> 
>   $ git show 426729b2cf2e:tools/testing/selftests/kvm/include/kvm_util_base.h | grep MEM_REGION_DATA
>   $ git show 290c5b54012b7:tools/testing/selftests/kvm/lib/ucall_common.c
>   fatal: path 'tools/testing/selftests/kvm/lib/ucall_common.c' exists on disk, but not in '290c5b54012b7'
> 
> The commit where the two collided is:
> 
> Fixes: cc7544101eec ("Merge tag 'kvmarm-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

Yeah, this Fixes is garbage, apologies.

I imagine Paolo is going to squash some things into the kvmarm merge, so
the Fixes tag ought to be dropped altogether.

> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> 
> Fixes nit aside,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
