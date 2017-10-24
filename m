From: Christoffer Dall <cdall@linaro.org>
Subject: Re: MAIR_EL2 Attributes
Date: Tue, 24 Oct 2017 17:41:24 +0200
Message-ID: <20171024154124.GA91785@lvm>
References: <CAPB=Z-qpezQAQ84hwpYVvqLuRczx-oMcjQvDQtH-T7u4B9YD6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE26F49D40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Oct 2017 11:40:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P49Ic6UbB7WP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Oct 2017 11:40:12 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1C6149D48
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Oct 2017 11:40:11 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id y39so21160839wrd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Oct 2017 08:41:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-qpezQAQ84hwpYVvqLuRczx-oMcjQvDQtH-T7u4B9YD6A@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Mon, Oct 23, 2017 at 09:33:28PM +0000, Raz wrote:
> 1. According the documentation of MAIR_EL2 there are 8 attributes but
> in the code you present only 6. Why ?

I just don't think we need those other defines.

> 2. Why there are names to the attributes ? Does it make a difference if I
> assign
> an attribute index 2 or attribute index 0 in the page while the two attr
> 

I'm not entirely sure what you're asking here.

Can you try to explain what the background of your question is?

I think these defines are just the way Linux configures the page tables.


> /*
>  * Memory types available.
>  */
> #define MT_DEVICE_nGnRnE    0
> #define MT_DEVICE_nGnRE        1
> #define MT_DEVICE_GRE        2
> #define MT_NORMAL_NC        3
> #define MT_NORMAL        4
> #define MT_NORMAL_WT        5

-Christoffer
