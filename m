From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] ARM64: use linux/types.h in kvm.h
Date: Fri, 13 Nov 2015 12:38:43 +0100
Message-ID: <20151113113843.GG12968@cbox>
References: <9679324.UdV9GV0mFA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 464F549630
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2015 06:38:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n1023v-Ks55S for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2015 06:38:22 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34A7D41280
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2015 06:38:22 -0500 (EST)
Received: by wmdw130 with SMTP id w130so25224452wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2015 03:38:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <9679324.UdV9GV0mFA@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 12, 2015 at 03:41:08PM +0100, Arnd Bergmann wrote:
> We should always use linux/types.h instead of asm/types.h for
> consistency, and Kbuild actually warns about it:
> 
> ./usr/include/asm/kvm.h:35: include of <linux/types.h> is preferred over <asm/types.h>
> 
> This patch does as Kbuild asks us.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I don't see this error when building the kernel, does it require a
special option to check for these things?


In any case, thanks for the patch, I have applied it.

-Christoffer
