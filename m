Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8748CECAA25
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 16:48:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E713D4E87A;
	Thu, 25 Aug 2022 12:48:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VhrcSF-rzVjp; Thu, 25 Aug 2022 12:48:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF3134EA74;
	Thu, 25 Aug 2022 12:48:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C554EA71
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 12:48:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NYyG97X41IeL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 12:48:50 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FC684EA70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 12:48:50 -0400 (EDT)
Date: Thu, 25 Aug 2022 09:48:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661446128;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=O55Usr66A7V9l1jjtJXC2418I7L6XcDR17b2fP/LeV8=;
 b=RWt+g44/T7Kp2wGu4/ODtzLHwl5J2VponJSj4snIACnF6961LlO6/FqMTLLeKZ5i8pXgkP
 JG8COFmBFhlxryApELZ0rw/dQ6SuiPVpUC7IfxETtgmTJDjF1vSd0nKQewgAW/dAmNKuE+
 7TQYRvTi2ZFt8n5VqZ3BjO/D5fLTYZQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a
 field of an ID register
Message-ID: <Ywen44OKe8gGcOcW@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-2-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-2-reijiw@google.com>
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

Hi Reiji,

On Wed, Aug 24, 2022 at 10:08:38PM -0700, Reiji Watanabe wrote:
> Introduce helpers to extract a field of an ID register.
> Subsequent patches will use those helpers.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h     |  2 ++
>  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index a8124f9dd68a..a9b4b4e0e592 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
>  
>  uint32_t guest_get_vcpuid(void);
>  
> +int cpuid_get_sfield(uint64_t val, int field_shift);
> +unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 6f5551368944..0b2ad46e7ff5 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
>  		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
>  		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
>  }
> +
> +/* Helpers to get a signed/unsigned feature field from ID register value */
> +int cpuid_get_sfield(uint64_t val, int field_shift)
> +{
> +	int width = 4;
> +
> +	return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
> +}

I don't believe this helper is ever used.

> +unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
> +{
> +	int width = 4;
> +
> +	return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
> +}

I would recommend not open-coding this and instead make use of
ARM64_FEATURE_MASK(). You could pull in linux/bitfield.h to tools, or do
something like this:

  #define ARM64_FEATURE_GET(ftr, val)					\
  	  	  ((ARM64_FEATURE_MASK(ftr) & val) >> ftr##_SHIFT)

Slight preference for FIELD_{GET,SET}() as it matches the field
extraction in the kernel as well.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
