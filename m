From: Christoffer Dall <cdall@linaro.org>
Subject: Re: A question about TTBRs
Date: Fri, 24 Feb 2017 11:22:40 +0100
Message-ID: <20170224102240.GG1409@cbox>
References: <CAPB=Z-omrvPjkjmQWfLNWtA86XJzEM1wCB1Rbc-2dnd0iUtaDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30AEA40D55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:21:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B+E+FlShUJdy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Feb 2017 05:21:54 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6B8640D4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 05:21:53 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id v77so10925929wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 02:22:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-omrvPjkjmQWfLNWtA86XJzEM1wCB1Rbc-2dnd0iUtaDA@mail.gmail.com>
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

On Fri, Feb 24, 2017 at 09:55:09AM +0000, Raz wrote:
> Hello
> I am reading the arm8a book. According to the documentation the output
> address of each level 3 entry in TTBRx_EL1points to an address in the
> physical memory.
> By looking in the mmu tab in the DS5 studio I can see the TTBRs tables.
> 
> What I do not understand is why while I have 2GB of RAM in the FVP (
> /proc/meminfo ) some page entries ( level 3 ) of the ttbr points to memory
> above 4GB; for instance:
> 
> Output address NP:0xF794D000
> 
> Doesn't the physical memory starts at address zero ? if not, where its
> starting point is configured?

It depends on your particular system where RAM starts, and it does not
necessarily start at zero.  You'd have to check the documentation of
your model or hardware or look at the device tree you use, for example.

-Christoffer
