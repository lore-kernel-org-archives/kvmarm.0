Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37B7ECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 09:25:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DF574B629;
	Tue, 20 Sep 2022 05:25:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4+WoTEGQ84Jo; Tue, 20 Sep 2022 05:25:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C8184B63B;
	Tue, 20 Sep 2022 05:25:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2030A4B629
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rq4UiZL-MztH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 05:25:00 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1AA640B59
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:25:00 -0400 (EDT)
Date: Tue, 20 Sep 2022 11:24:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663665899;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9zrLhW6+j/sbUQdXwNAlZMyILSK9/uM8auDZkZ2Ibrg=;
 b=a63720QQS8maY/E/11LPxMihWSMsik+ISeTPBLj8yb/ScHEdkXiaGBbFqZ5zE2NkTV5ztj
 CmWTcZFDhm2JznDf4irbevFWtS1Iff5d+/fFNcqIh+uQrV6e488cJYY7khdkgtgCx50bce
 UZoLu1waKnHrJSlJt6bl2oTzqYUy7Wo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 09/19] arm/arm64: Zero secondary CPUs'
 stack
Message-ID: <20220920092459.ptiwfll5cxo76bah@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-10-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-10-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:48AM +0100, Alexandru Elisei wrote:
> For the boot CPU, the entire stack is zeroed in the entry code. For the
> secondaries, only struct thread_info, which lives at the bottom of the
> stack, is zeroed in thread_info_init().
> 
> Be consistent and zero the entire stack for the secondaries. This should
> also improve reproducibility of the testsuite, as all the stacks now start
> with the same contents, which is zero. And now that all the stacks are
> zeroed in the entry code, there is no need to explicitely zero struct
> thread_info in thread_info_init().
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S          | 6 ++++++
>  arm/cstart64.S        | 3 +++
>  lib/arm/processor.c   | 1 -
>  lib/arm64/processor.c | 1 -
>  4 files changed, 9 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
