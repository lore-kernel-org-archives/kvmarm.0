From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: KVM/ARM: How to read the value of some physical address in HYP
 mode
Date: Wed, 19 Aug 2015 15:35:01 -0700
Message-ID: <20150819223501.GA16002@lvm>
References: <259c0e14.2f0f.14f3961e161.Coremail.tiancaixiaoyu90@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE185CAEF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2015 18:21:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FEltdrgpw0aR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2015 18:21:37 -0400 (EDT)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
 [209.85.192.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A29D5CAB9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2015 18:21:37 -0400 (EDT)
Received: by pdrh1 with SMTP id h1so6404539pdr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2015 15:35:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <259c0e14.2f0f.14f3961e161.Coremail.tiancaixiaoyu90@126.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: harry <tiancaixiaoyu90@126.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 17, 2015 at 09:59:20AM +0800, harry wrote:
> Hi, 
> 
> 
> I want to read the value of some physical address in HYP mode. But maybe there isn't any interface to achieve this. I hope to get some ideas to achieve this.
> 

If I understand your question correctly, you simply have to map the
physical address into hyp mode's virtual address space and read from
that address.

-Christoffer

> 
> And now I have a simple idea, but I don't know if it is possible. When the HYP mode is init, we create a mapping from one special virtual address to some physical address. And map the va to HYP mode. When we want to read the value of some PA, we modify the page table to let the special VA map to the PA, then we read the special VA and get the value of the PA. Because I only start to research on the KVM, so I am not sure if this can work. I hope to get help to achieve this.
> 
> 
> Thanks and regards,
> Harry

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
