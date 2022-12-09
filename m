Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF107C4708D
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 21:35:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BFBD4B87A;
	Fri,  9 Dec 2022 16:35:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q3uf0iQ9jwdR; Fri,  9 Dec 2022 16:35:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 317094B86D;
	Fri,  9 Dec 2022 16:35:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9AA4B86D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 16:35:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ja2usMQcpW8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 16:35:32 -0500 (EST)
Received: from out-40.mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4476D4B815
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 16:35:32 -0500 (EST)
Date: Fri, 9 Dec 2022 21:35:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670621730;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=agoBlhJw/+KDy0+W1zZ2GK62ctFzKYI+xFVcrAtjBk8=;
 b=NS3bk9bTW9yLMUQP30XiRdXGlm8TEp49GntXjwxUVIVsQeD+1YLPL1WSTesnsFRMj2C5eZ
 W73BsYN6UvL8vHW74CeWdogfHe73GQIRS/cPcBODhsokqQ0TuoGYty61NU5wXaoRkdTPkn
 xxWmMg1XF3PjR6O8sxtFMuAkKAxtZZY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 7/7] KVM: selftests: Avoid infinite loop if
 ucall_alloc() fails
Message-ID: <Y5OqHUxCblbiysuo@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-8-oliver.upton@linux.dev>
 <Y5OisdH5ohtr6r3j@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5OisdH5ohtr6r3j@google.com>
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

On Fri, Dec 09, 2022 at 09:03:45PM +0000, Sean Christopherson wrote:

[...]

> > -	GUEST_ASSERT(0);
> > +out:
> > +	/*
> > +	 * If the guest cannot grab a ucall structure from the pool then the
> > +	 * only option to get out to userspace is a bare ucall. This is probably
> > +	 * a good time to mention that guest assertions depend on ucalls with
> > +	 * arguments too.
> > +	 */
> > +	GUEST_UCALL_NONE();
> 
> UCALL_NONE isn't much better than infinite stack recursion, e.g. a test might end
> up passing by dumb luck, or go in the wrong direction because it sometimes handles
> UCALL_NONE.

Oh, I was just seeking an end to my misery. Yeah, we can use a magic
value to signal this instead.

> How about this?

LGTM.

--
Thanks,
Oliver

> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 9 Dec 2022 12:55:44 -0800
> Subject: [PATCH] KVM: selftests: Use magic value to signal ucall_alloc()
>  failure
> 
> Use a magic value to signal a ucall_alloc() failure instead of simply
> doing GUEST_ASSERT().  GUEST_ASSERT() relies on ucall_alloc() and so a
> failure puts the guest into an infinite loop.
> 
> Use -1 as the magic value, as a real ucall struct should never wrap.
> 
> Reported-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/ucall_common.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 0cc0971ce60e..2f0e2ea941cc 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -4,6 +4,8 @@
>  #include "linux/bitmap.h"
>  #include "linux/atomic.h"
>  
> +#define GUEST_UCALL_FAILED -1
> +
>  struct ucall_header {
>  	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
>  	struct ucall ucalls[KVM_MAX_VCPUS];
> @@ -41,7 +43,8 @@ static struct ucall *ucall_alloc(void)
>  	struct ucall *uc;
>  	int i;
>  
> -	GUEST_ASSERT(ucall_pool);
> +	if (!ucall_pool)
> +		goto ucall_failed;
>  
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (!test_and_set_bit(i, ucall_pool->in_use)) {
> @@ -51,7 +54,13 @@ static struct ucall *ucall_alloc(void)
>  		}
>  	}
>  
> -	GUEST_ASSERT(0);
> +ucall_failed:
> +	/*
> +	 * If the vCPU cannot grab a ucall structure, make a bare ucall with a
> +	 * magic value to signal to get_ucall() that things went sideways.
> +	 * GUEST_ASSERT() depends on ucall_alloc() and so cannot be used here.
> +	 */
> +	ucall_arch_do_ucall(GUEST_UCALL_FAILED);
>  	return NULL;
>  }
>  
> @@ -93,6 +102,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  
>  	addr = ucall_arch_get_ucall(vcpu);
>  	if (addr) {
> +		TEST_ASSERT(addr != (void *)GUEST_UCALL_FAILED,
> +			    "Guest failed to allocate ucall struct");
> +
>  		memcpy(uc, addr, sizeof(*uc));
>  		vcpu_run_complete_io(vcpu);
>  	} else {
> 
> base-commit: dc2efbe4813e0dc4368779bc36c5f0e636cb8eb2
> -- 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
