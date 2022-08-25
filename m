Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2E9ECAA24
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 17:22:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A41B84EADE;
	Thu, 25 Aug 2022 13:22:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vX9+AMaPlBOn; Thu, 25 Aug 2022 13:22:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F03B4EADF;
	Thu, 25 Aug 2022 13:22:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DECED4EADD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 13:22:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p9FHXbdCMGmF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 13:22:01 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A153A4EAD1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 13:22:01 -0400 (EDT)
Date: Thu, 25 Aug 2022 10:21:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661448120;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Fv5uLAiqTfJ7ki0m8vXx4vs+Jg/Y+MlltpOcaffBFAo=;
 b=hCNBLE8xOnvioAmSw1qaKUFLJI121ieWuU2y0LduHX7bASykDCdmx62a9ocDSXMbeikvGv
 j9Z8YdxxaCxUqCoOgvbiuKT8VIYjypf8Virf/z3Jlq2SKFg0Aki0uQX1f/KhoGfssBZMg7
 CD6u0+7mrIRtbaC54AbWc1boPzToqB0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug
 exceptions
Message-ID: <YwevrW4YrHQQOyew@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-5-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-5-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Aug 24, 2022 at 10:08:41PM -0700, Reiji Watanabe wrote:
> Add helpers to enable breakpoint and watchpoint exceptions.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 183ee16acb7d..713c7240b680 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -128,10 +128,20 @@ static void enable_os_lock(void)
>  	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
>  }
>  
> +static void enable_debug_bwp_exception(void)

uber-nit: enable_monitor_debug_exceptions()

(more closely matches the definition of MDSCR_EL1.MDE)

With that:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
