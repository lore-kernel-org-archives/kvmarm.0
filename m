From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 12/14] ARM: spectre-v2: KVM: invalidate icache on guest
 exit for Brahma B15
Date: Mon, 21 May 2018 20:22:37 -0700
Message-ID: <f6a2cbbd-0c76-cb8c-5394-df6d910474dd@gmail.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFj-00064b-62@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3004A0DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 23:12:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uTxGQX1vZ55D for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 May 2018 23:12:12 -0400 (EDT)
Received: from mail-oi0-f66.google.com (mail-oi0-f66.google.com
 [209.85.218.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF9F34A0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 23:12:04 -0400 (EDT)
Received: by mail-oi0-f66.google.com with SMTP id c203-v6so14915408oib.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 20:22:40 -0700 (PDT)
In-Reply-To: <E1fKjFj-00064b-62@rmk-PC.armlinux.org.uk>
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



On 05/21/2018 04:45 AM, Russell King wrote:
> Include Brahma B15 in the Spectre v2 KVM workarounds.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
