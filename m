Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBC0C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 00:43:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0144B7E7;
	Wed, 16 Nov 2022 19:43:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VFmsCL1n3kkL; Wed, 16 Nov 2022 19:43:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F75A4B7FC;
	Wed, 16 Nov 2022 19:43:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0534B7F0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:43:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IG1UFDbAP6gI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 19:43:33 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 787D14B7E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:43:33 -0500 (EST)
Date: Thu, 17 Nov 2022 00:43:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668645812;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=x1yq7+HlMjVk7Mh1lF9aHzv9fMnW5d57Fj9ITz0qudw=;
 b=VKj6EkJlmRwJ/R9BSNln/48AvN39ZRzjnnqQut2Sebkl98iH4xYuh1yWwPrN5/Ljyxyoo5
 8OELoe35KKjnxshX7VpbR8bk/n97tA5ti5e2q/DThvPqFdjgNukfU1YQj0258KD+EKQht/
 ZjjLqjPgqwbDvsAz1xMWCU42Ooo50bE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: selftests: Disable single-step with
 correct KVM define
Message-ID: <Y3WDsIp6Jk5dVg0n@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-2-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221117002350.2178351-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Thu, Nov 17, 2022 at 12:23:49AM +0000, Sean Christopherson wrote:
> Disable single-step by setting debug.control to KVM_GUESTDBG_ENABLE,
> not to SINGLE_STEP_DISABLE.  The latter is an arbitrary test enum that
> just happens to have the same value as KVM_GUESTDBG_ENABLE, and so
> effectively disables single-step debug.
> 
> No functional change intended.
> 
> Cc: Reiji Watanabe <reijiw@google.com>
> Fixes: b18e4d4aebdd ("KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
