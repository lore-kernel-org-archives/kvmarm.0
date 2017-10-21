From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RESEND PATCH 0/2] arm/arm64: kvm: Disable branch profiling in
 HYP code
Date: Sat, 21 Oct 2017 17:04:29 +0200
Message-ID: <20171021150429.GC12618@cbox>
References: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E86EC406D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 11:03:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JUgyyulCoWDU for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 Oct 2017 11:03:22 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 009E5406BB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 11:03:21 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id 196so3599480wma.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 08:04:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20, 2017 at 12:34:15PM +0100, Julien Thierry wrote:
> [Resending for Christoffer and adding kvmarm to recipients]
> 
> Hi,
> 
> When enabling branch profiling, a lockup occurs at boot time, after
> displaying: "kvm [1]: Hyp mode initialized successfully"
> 
> The issue is caused by the Hyp code getting instrumented and trying to
> access unmapped code or data, which happens when trying to initialize EL2.
> 
> So it also seems like KVM is misleadingly announcing it was initialized and
> yet gets stuck during initialization.
> 
> * First patch deals with printing the initialization message once KVM has
>   fully initialized Hyp mode
> * Second patch actually disables branch profiling instrumentation in Hyp
>   code

Applied, thanks.

-Christoffer
