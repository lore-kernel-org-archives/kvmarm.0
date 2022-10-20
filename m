Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73CBC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 19:11:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6884B9EE;
	Thu, 20 Oct 2022 15:11:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NhtSs7J5Pk4Z; Thu, 20 Oct 2022 15:11:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4E94B95D;
	Thu, 20 Oct 2022 15:11:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 009744B95D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:11:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qYo8LNOWHXaa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 15:11:19 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB9DC4B94A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:11:18 -0400 (EDT)
Date: Thu, 20 Oct 2022 22:11:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666293078;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=o0ijBOoIwkeAC+4P2wSY2PPVmhiuBD8dwNZ6MmnDsjw=;
 b=rkksVbp2MoNLbNuE2/VH9H075rIDlpGXjs4yiOuHdJDveZrAbGEYF5AS26zLrp3NRwv4u+
 94xaNFW6xx4HxzHn+cRlF3fToiKFMRzIXvqY3SmkCJLTOpLFPMwcGr1GeI1UsJb3pllEAg
 zGKYDZ90o5X6aygpHMn4zGhO2692KZk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
Message-ID: <Y1GdU5891M5lAqvH@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
 <20221020054202.2119018-4-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221020054202.2119018-4-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
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

On Wed, Oct 19, 2022 at 10:41:56PM -0700, Reiji Watanabe wrote:
> Remove the hard-coded {break,watch}point #0 from the guest_code() in
> debug-exceptions to allow {break,watch}point number to be specified.
> Change reset_debug_state() to zeroing all dbg{b,w}{c,v}r_el0 registers
> so that guest_code() can use the function to reset those registers
> even when non-zero {break,watch}points are specified for guest_code().
> Subsequent patches will add test cases for non-zero {break,watch}points.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
