Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E82C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 19:12:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC4B4BA0A;
	Thu, 20 Oct 2022 15:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DToPcdgWrfN3; Thu, 20 Oct 2022 15:12:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511824B9AB;
	Thu, 20 Oct 2022 15:12:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F2A4B94A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:12:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zlzpByVIwAAl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 15:12:32 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA3E64B9AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:12:32 -0400 (EDT)
Date: Thu, 20 Oct 2022 22:12:29 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666293151;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8UxLxujHJ2w8hcXZyfAGTDxrJz5/OfrfjzTusuwGxQc=;
 b=fuHgHLIO7XBKt9+16Uvpzi8QrDhJC54rr/WDX57lVPW/NcnAJwrHJDpueIaZQRPhFdsRX+
 MASPrtpseKq2znAFCqYchHuUYlNRUSQNTa/FDnYpCkBrD/VRxwvLJPiHwG0T1DAo6w0mpy
 OV6oQlpoeCfaDOjHFcW3oGSDia39z5E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 5/9] KVM: arm64: selftests: Stop unnecessary test
 stage tracking of debug-exceptions
Message-ID: <Y1GdnaxoFCk+8Mhn@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
 <20221020054202.2119018-6-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221020054202.2119018-6-reijiw@google.com>
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

On Wed, Oct 19, 2022 at 10:41:58PM -0700, Reiji Watanabe wrote:
> Currently, debug-exceptions test unnecessarily tracks some test stages
> using GUEST_SYNC().  The code for it needs to be updated as test cases
> are added or removed.  Stop doing the unnecessary stage tracking,
> as they are not so useful and are a bit pain to maintain.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Much cleaner!

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
