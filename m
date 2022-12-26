Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2C2C4167B
	for <kvmarm@archiver.kernel.org>; Mon, 26 Dec 2022 18:12:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A45004BB53;
	Mon, 26 Dec 2022 13:12:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jyQ0wgLI9mHw; Mon, 26 Dec 2022 13:12:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E8E4BAB7;
	Mon, 26 Dec 2022 13:12:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3706E4BAB7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 13:12:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PX0vizxOiaW7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2022 13:12:16 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D55014BA9D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 13:12:16 -0500 (EST)
Date: Mon, 26 Dec 2022 19:12:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1672078335;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4NvLV2ID3qQzfb9lyy35QudvVSz5KeLV7z2G9Cnlngo=;
 b=RvSbWTt82CD7poH5jiz+bxf9wKNHgQyPv/Tlg/mo5+6BHeKqaQDi5LaXmJW2RLQfPf2OZJ
 7deW0KG96py2z+PsfZs0x8XN5fwRwnXqnqcUcYHxsCxYvCbKa6EwGXHNcc9/PyHiLQSEmV
 D9HZ4/IUU3S/R9O4k15gQe3m+7YUA3c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <20221226181207.3ngrwv74p4pcjabe@orel>
References: <20221219185250.631503-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221219185250.631503-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Dec 19, 2022 at 06:52:50PM +0000, Colton Lewis wrote:
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
                                                                    ^ 1
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
> 
> The loop is safe to remove with no side effects. It has an explanitory
> comment explaining that it only applies to kernels <=v4.3 on arm and
> suggestion deletion when it becomes tiresome to maintain.

Removing this loop is safe if the body of the loop is not expected to
ever run, i.e. we're through testing kernels older than v4.3. But, if
MAX_SMP is getting reduced, as stated above, then that implies

 $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP

is resulting in a "exceeds max CPUs" error. If that's the case, then
the tests which configure $MAX_SMP cpus should be failing as well.

IOW, the loop should never do anything except be a pointless extra
invocation of QEMU. If it does do something, then we should understand
why.

Thanks,
drew

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  scripts/runtime.bash | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9..18a8dd7 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -183,17 +183,3 @@ function run()
>  
>      return $ret
>  }
> -
> -#
> -# Probe for MAX_SMP, in case it's less than the number of host cpus.
> -#
> -# This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
