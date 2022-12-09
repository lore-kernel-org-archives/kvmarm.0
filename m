Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A88C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 08:29:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D36274B9D1;
	Fri,  9 Dec 2022 03:29:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KZJw6xGYMuvr; Fri,  9 Dec 2022 03:29:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B77034B9D8;
	Fri,  9 Dec 2022 03:29:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2E7C4B9D1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 03:29:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pjHKShUVbqcO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 03:29:13 -0500 (EST)
Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com
 [91.218.175.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A64E64B9A4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 03:29:13 -0500 (EST)
Date: Fri, 9 Dec 2022 08:29:08 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Message-ID: <Y5Lx1KhQvqtAvHoc@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209082423.yideydkw6ig6x5zg@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221209082423.yideydkw6ig6x5zg@kamzik>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Dec 09, 2022 at 09:24:23AM +0100, Andrew Jones wrote:
> On Fri, Dec 09, 2022 at 01:52:59AM +0000, Oliver Upton wrote:
> > base-commit: 89b2395859651113375101bb07cd6340b1ba3637
> 
> This commit doesn't seem to exist linux-next or kvm/queue, but the patch
> context seems to match up with linux-next pretty well. Anyway,

Ah, a force push to kvm/queue likely explains it :) I believe Paolo has
taken the first two patches in his merge resolution now on kvm/next.

> For the series
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
