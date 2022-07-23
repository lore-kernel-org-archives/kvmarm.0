Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3CCC43334
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jul 2022 08:00:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7324C869;
	Sat, 23 Jul 2022 04:00:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9frL7VnK+Xm; Sat, 23 Jul 2022 04:00:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 180F24C8C9;
	Sat, 23 Jul 2022 04:00:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1274C840
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jul 2022 03:59:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JLcB8OcF9a+1 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jul 2022 03:59:57 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A85B34C697
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jul 2022 03:59:57 -0400 (EDT)
Date: Sat, 23 Jul 2022 09:59:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658563196;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ldcXzSGhyZjdlmTZ2qM8ncFsmbAjGlPourkAHG6dO0s=;
 b=YQiVHw7pVpwptBWQhEpviji4IDPGvsDLpXPyWbtVlzKPwU4aQwjcoMnG+sUjpmzlQqqNew
 0BJaqOR8RwB61z1yDR8yK36RbzVV68CasSxo4ktaXn0fNFtTz0Q2dbaqpQFuEht4+F/Rbq
 VYdBfCr10EowuNCCVeust1mGRJphwIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <20220723075955.ipoekdpzkqticadt@kamzik>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org> <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org> <Ythw1UT1wFHbY/jN@google.com>
 <Ythy8XXN2rFytXdr@google.com> <871quezill.wl-maz@kernel.org>
 <YtscUOUGKra3LpsK@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtscUOUGKra3LpsK@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, Jul 22, 2022 at 02:53:20PM -0700, Ricardo Koller wrote:
> 
> Which brings me to what to do with this test. Should it be fixed for
> bare-metal by ignoring the PMOVSSET check? or should it actually check
> for PMOVSSET=1 and fail on KVM until KVM gets fixed?
>

Hi Ricardo,

Please write the test per the spec. Failures pointed out in kvm-unit-tests
are great, when the tests are written correctly, since it means it's
doing its job :-)

If some CI somewhere starts blocking builds due to the failure, then there
are ways to skip the test. Unfortunately the easiest way is usually the
oversized hammer of skipping every unittests.cfg entry that fails. To do
better, either the CI needs to be taught about all the subtest failures it
can ignore or the test code needs some work to allow silencing known
failures. For the test code, refactoring to isolate the test into it's own
unittests.cfg entry and then skipping that entry is one way, but probably
won't work in this case, since the overflow checks are scattered. Another
way is to guard all the overflow checks with a variable which can be set
with a command line parameter or environment variable. Eventually, when
the KVM bug is fixed, the guard variable could be forced off for kernel
versions >= the version the fix is merged. The kernel version can be
detected in the unit test by looking at the KERNEL_* environment
variables.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
