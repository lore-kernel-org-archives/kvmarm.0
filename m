From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PULL 0/5] KVM/ARM Fixes for v4.11-rc6
Date: Wed, 5 Apr 2017 16:48:13 +0200
Message-ID: <20170405144813.GF6369@potion>
References: <20170405101331.23812-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BCC40B3E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 10:46:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fo--MQmoqS8H for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 10:46:04 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EC7240187
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 10:46:03 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170405101331.23812-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-04-05 12:13+0200, Christoffer Dall:
> Hi Paolo and Radim,
> 
> Please pull a handfull of fixes for the next -rc release of v4.11.
> 
> They include:
>  - Addressing a problem with GICv3 userspace save/restore
>  - Clarify GICv2 userspace save/restore ABI
>  - Be more careful in clearing GIC LRs
>  - Add missing synchronization primitive to our MMU handling code

Pulled, thanks.
