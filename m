Return-Path: <SRS0=RYKq=DB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3ACC4363D
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 10:11:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E107621D24
	for <kvmarm@archiver.kernel.org>; Thu, 24 Sep 2020 10:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E107621D24
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F2E14B33D;
	Thu, 24 Sep 2020 06:11:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vW44HX6zOuq4; Thu, 24 Sep 2020 06:11:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C7A4B32C;
	Thu, 24 Sep 2020 06:11:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 376C34B234
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 06:10:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k50XRTIan2Fn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Sep 2020 06:10:58 -0400 (EDT)
Received: from gentwo.org (gentwo.org [3.19.106.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3403E4B230
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Sep 2020 06:10:58 -0400 (EDT)
Received: by gentwo.org (Postfix, from userid 1002)
 id D7A6C3F1AE; Thu, 24 Sep 2020 10:10:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by gentwo.org (Postfix) with ESMTP id D4FD23F1AA;
 Thu, 24 Sep 2020 10:10:52 +0000 (UTC)
Date: Thu, 24 Sep 2020 10:10:52 +0000 (UTC)
From: Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 00/10] Independent per-CPU data section for nVHE
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
Message-ID: <alpine.DEB.2.22.394.2009241003100.1613@www.lameter.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Tue, 22 Sep 2020, David Brazdil wrote:

> Introduce '.hyp.data..percpu' as part of ongoing effort to make nVHE
> hyp code self-contained and independent of the rest of the kernel.

The percpu subsystems point is to enable the use of special hardware
instructions that can perform address calculation and a memory operation
in one interruptible instruction. This is in particular useful to avoid
higher overhead for memory management related counters because preempt
disable/enable etc can be avoided.

ARM cannot do that and thus has a LC/SC loop.

This is a patchset for ARM64 so its not clear to me what kind of advantage
there would be against a simple implementation that does a regular fetch
from a base address with an offset.

> Main benefits:
>  * independent nVHE per-CPU data section that can be unmapped from host,
>  * more robust linking of nVHE hyp code,
>  * no need for hyp-specific macros to access per-CPU variables.

Maybe simply don't use percpu variables for your arm code? Those pointers
to data will be much more indepedent of the rest of the kernel and allow a
much higher degree of being self-contained.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
