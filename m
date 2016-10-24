From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: Map the BSS at HYP
Date: Mon, 24 Oct 2016 10:10:37 +0200
Message-ID: <20161024081037.GG13680@cbox>
References: <1476968441-29003-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 814074078A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2016 04:10:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lgGf7GcEEq4k for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Oct 2016 04:10:36 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FBE640787
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2016 04:10:35 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id b80so89243423wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2016 01:10:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1476968441-29003-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 20, 2016 at 02:00:41PM +0100, Marc Zyngier wrote:
> When used with a compiler that doesn't implement "asm goto"
> (such as the AArch64 port of GCC 4.8), jump labels generate a
> memory access to find out about the value of the key (instead
> of just patching the code). The key itself is likely to be
> stored in the BSS.
> 
> This is perfectly fine, except that we don't map the BSS at HYP,
> leading to an exploding kernel at the first access. The obvious
> fix is simply to map the BSS there (which should have been done
> a long while ago, but hey...).
> 
> Reported-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
