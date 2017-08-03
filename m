From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 0/4] KVM/ARM fixes for 4.13-rc4
Date: Thu, 3 Aug 2017 19:44:28 +0200
Message-ID: <20170803174427.GD1015@flask>
References: <20170803152857.32055-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E513E49C28
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Aug 2017 13:43:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OWQy2I8EYQ+y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Aug 2017 13:43:15 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51B7440D8B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Aug 2017 13:43:15 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170803152857.32055-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-08-03 16:28+0100, Marc Zyngier:
> Paolo, Radim,
> 
> Here's a pull request for a few KVM/ARM updates. Nothing major except
> for a VM destruction race (Suzuki has a knack for finding those...).
> 
> Please pull.

Pulled, thanks.
