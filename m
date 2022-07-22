Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195CEC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 11:16:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F4874CA10;
	Fri, 22 Jul 2022 07:16:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f5Jc0uZRVRxu; Fri, 22 Jul 2022 07:16:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46A244CA13;
	Fri, 22 Jul 2022 07:16:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AA1C4CA10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 07:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UXUquVNKZODs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 07:16:37 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 391604CA11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 07:16:37 -0400 (EDT)
Date: Fri, 22 Jul 2022 12:16:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658488596;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bWMt6DrO+QpBB8jeoqRLaRrtD7zLY5M5syjYMGmYEtY=;
 b=Lhtr/basSfJ7soT0J6Z9kSRdSByaPWd/Q/wvSTsFIqpuD2HM2bD7yOHAHq26QrBiiVP69r
 iXiApSpbGWW7FcvvN/pp5eKGKPxWRgh8WoSWcG0oS+vH7yzNvYkzLxzEsMHuxwj9Y7J7hg
 s15kMJaK4m3UqyuT0c4Phm9u+xPLcDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v5 16/17] KVM: arm64: Introduce pkvm_dump_backtrace()
Message-ID: <YtqHDTpnn376Qb7u@google.com>
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-17-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220721055728.718573-17-kaleshsingh@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, android-mm@google.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 kernel-team@android.com, drjones@redhat.com, ast@kernel.org,
 broonie@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Hi Kalesh,

On Wed, Jul 20, 2022 at 10:57:27PM -0700, Kalesh Singh wrote:

[...]

> +/*
> + * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
> + *
> + * @hyp_offset: hypervisor offset, used for address translation.
> + *
> + * Dumping of the pKVM HYP backtrace is done by reading the
> + * stack addresses from the shared stacktrace buffer, since the
> + * host cannot direclty access hyperviosr memory in protected
> + * mode.
> + */
> +static void pkvm_dump_backtrace(unsigned long hyp_offset)
> +{
> +	unsigned long *stacktrace_entry
> +		= (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
> +	unsigned long va_mask, pc;
> +
> +	va_mask = GENMASK_ULL(vabits_actual - 1, 0);
> +
> +	kvm_err("Protected nVHE HYP call trace:\n");

This and the footer printks should be put in respective helpers to share
between pKVM and non-pKVM backtrace implementations. I imagine users
will invariably bake some pattern matching to scrape traces, and it
should be consistent between both flavors.

> +	/* The stack trace is terminated by a null entry */
> +	for (; *stacktrace_entry; stacktrace_entry++) {

At the point we're dumping the backtrace we know that EL2 has already
soiled itself, so we shouldn't explicitly depend on it providing NULL
terminators. I believe this loop should have an explicit range && NULL
check.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
