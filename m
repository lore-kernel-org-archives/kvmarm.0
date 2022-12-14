Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A19FC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 14 Dec 2022 00:59:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D928A4B91C;
	Tue, 13 Dec 2022 19:59:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Un5d7EMyv6Gu; Tue, 13 Dec 2022 19:59:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C36464B90A;
	Tue, 13 Dec 2022 19:59:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8974B906
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 19:59:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9mvBTzy6c14P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 19:59:23 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D106B4B939
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 19:59:23 -0500 (EST)
Date: Wed, 14 Dec 2022 00:59:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670979562;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qbKxRIPYAhQPs9JSjFRsJUAAmMT3SmynUTp6Kob5aSA=;
 b=BJmn8mmJMMe4GC4cqN0JMmdIVim+izlQOZFM7XZq1llY0jN+dMVlj1H4EP4eIBEmXp8lYK
 MXbZuomcvx54TXdefIJEo1RVkbTUFi+HJtKiWnQoFfOhiWeNG5+ZIYpfylkQgVG/nu5OMS
 hIMZmFyTmHWQIDkc9Qi42jOvL1qPC/g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Normalize cache configuration
Message-ID: <Y5kf5XDUb5En00BZ@google.com>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221211051700.275761-1-akihiko.odaki@daynix.com>
X-Migadu-Flow: FLOW_OUT
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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

Hi Akihiko,

On Sun, Dec 11, 2022 at 02:16:57PM +0900, Akihiko Odaki wrote:
> Before this change, the cache configuration of the physical CPU was
> exposed to vcpus. This is problematic because the cache configuration a
> vcpu sees varies when it migrates between vcpus with different cache
> configurations.
> 
> Fabricate cache configuration from arm64_ftr_reg_ctrel0.sys_val, which
> holds the CTR_EL0 value the userspace sees regardless of which physical
> CPU it resides on.
> 
> HCR_TID2 is now always set as it is troublesome to detect the difference
> of cache configurations among physical CPUs.
> 
> CSSELR_EL1 is now held in the memory instead of the corresponding
> phyisccal register as the fabricated cache configuration may have a
> cache level which does not exist in the physical CPU, and setting the
> physical CSSELR_EL1 for the level results in an UNKNOWN behavior.
> 
> CLIDR_EL1 and CCSIDR_EL1 are now writable from the userspace so that
> the VMM can restore the values saved with the old kernel.
> 
> Akihiko Odaki (3):
>   arm64/sysreg: Add CCSIDR2_EL1
>   arm64/cache: Move CLIDR macro definitions
>   KVM: arm64: Normalize cache configuration

Next time you do a respin can you please bump the version number? I.e.
the next version should be v3.

Additionally, it is tremendously helpful to reviewers if you can provide
(1) a summary of what has changed in the current revision and (2) a
lore.kernel.org link to the last series you mailed out.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
