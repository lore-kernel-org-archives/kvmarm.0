From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Save two instructions in __guest_enter()
Date: Mon, 29 Aug 2016 20:15:09 +0200
Message-ID: <20160829181509.GC10162@cbox>
References: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
 <20160825133122.GA8016@lvm>
 <daa6aa0c-27d0-25bd-02fd-4e87e9a908fe@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2FB14998D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 14:04:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uWGZ+KxvJwDJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Aug 2016 14:04:50 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D12940FA2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 14:04:50 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id i5so105063621wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 11:12:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <daa6aa0c-27d0-25bd-02fd-4e87e9a908fe@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 29, 2016 at 10:22:06AM -0500, Shanker Donthineni wrote:
> Hi Christoffer,
> 
> This is change may not provide the measurable performance
> improvement, but still we can
> save a few cpu cycles on vCPU context switch and also improves the
> code readability.

I'm not so convinced about saving CPU cycles, but now when I've reviewed
your patch I think it has potential to slightly improve the code.  See
my review of your patch.

-Christoffer
