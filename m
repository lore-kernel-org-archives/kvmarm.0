Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE60C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 07:27:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC364B8DE;
	Wed, 16 Nov 2022 02:27:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AVQJkUhYHkvy; Wed, 16 Nov 2022 02:27:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7819A4B8D2;
	Wed, 16 Nov 2022 02:27:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB4D4B8B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 02:27:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SY3lys1inOFg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 02:27:33 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79BA24B8B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 02:27:33 -0500 (EST)
Date: Wed, 16 Nov 2022 07:27:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668583652;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QTadVoqTlZKm9VTvcDO0wveHBTpSFQKiIG+uKAG+8kM=;
 b=V9pS43higRceJa5AF+9MmdQqVOFLDPCAwKI1AmsPGuPobz+Q0p1LSPwm1Q5+C4DFql5b7T
 MijRBdX22IcazcREY5/9LVAwgx3USgWhVzi5ei6y2tHNSKu4G261ko5CYgb7yp2YwvSH8D
 fEAuY323ZCDbqMrpdyfbPkYtQwA5GCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Message-ID: <Y3SQ3wogsVUEu1Qe@google.com>
References: <20221115225502.2240227-1-oliver.upton@linux.dev>
 <868rkbppdq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <868rkbppdq.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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

On Wed, Nov 16, 2022 at 03:08:49AM +0000, Marc Zyngier wrote:
> I'm not crazy about this sort of parameters. I think it would make a
> lot more sense to pass a pointer to the walker structure and do the
> flag check inside the helper.
> 
> That way, we avoid extra churn if/when we need extra state or
> bookkeeping around the walk.

Sure, let's go that way instead. v3 on the way lol :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
