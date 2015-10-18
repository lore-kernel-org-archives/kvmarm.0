From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: kvm: restore EL1N SP for panic
Date: Sun, 18 Oct 2015 22:13:52 +0200
Message-ID: <20151018201352.GD7531@cbox>
References: <1444658690-8180-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96A46412D0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 16:10:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bS7ctDjh3Rde for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 16:10:57 -0400 (EDT)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FFBD41022
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 16:10:56 -0400 (EDT)
Received: by lffz202 with SMTP id z202so15653264lff.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 13:13:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1444658690-8180-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 12, 2015 at 03:04:50PM +0100, Mark Rutland wrote:
> If we panic in hyp mode, we inject a call to panic() into the EL1N host
> kernel. If a guest context is active, we first attempt to restore the
> minimal amount of state necessary to execute the host kernel with
> restore_sysregs.
> 
> However, the SP is restored as part of restore_common_regs, and so we
> may return to the host's panic() function with the SP of the guest. Any
> calculations based on the SP will be bogus, and any attempt to access
> the stack will result in recursive data aborts.
> 
> When running Linux as a guest, the guest's EL1N SP is like to be some
> valid kernel address. In this case, the host kernel may use that region
> as a stack for panic(), corrupting it in the process.
> 
> Avoid the problem by restoring the host SP prior to returning to the
> host. To prevent misleading backtraces in the host, the FP is zeroed at
> the same time. We don't need any of the other "common" registers in
> order to panic successfully.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: <kvmarm@lists.cs.columbia.edu>

Applied - thanks,
-Christoffer
