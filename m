From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 06/14] ARM: spectre-v2: harden branch predictor on context
 switches
Date: Mon, 21 May 2018 20:21:58 -0700
Message-ID: <61e24c59-9905-8524-92ba-98cdbadb3011@gmail.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFD-00063u-Q5@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D67DF4A0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 23:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LVMi929LIoEm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 May 2018 23:11:27 -0400 (EDT)
Received: from mail-ot0-f195.google.com (mail-ot0-f195.google.com
 [74.125.82.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4D3E4A0D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 23:11:26 -0400 (EDT)
Received: by mail-ot0-f195.google.com with SMTP id 15-v6so19280182otn.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 20:22:02 -0700 (PDT)
In-Reply-To: <E1fKjFD-00063u-Q5@rmk-PC.armlinux.org.uk>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 05/21/2018 04:44 AM, Russell King wrote:
> Harden the branch predictor against Spectre v2 attacks on context
> switches for ARMv7 and later CPUs.  We do this by:
> 
> Cortex A9, A12, A17, A73, A75: invalidating the BTB.
> Cortex A15, Brahma B15: invalidating the instruction cache.
> 
> Cortex A57 and Cortex A72 are not addressed in this patch.
> 
> Cortex R7 and Cortex R8 are also not addressed as we do not enforce
> memory protection on these cores.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
