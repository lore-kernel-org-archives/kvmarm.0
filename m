From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM KVM guest virtual address to host virtual address Look up
Date: Fri, 15 Jan 2016 10:02:23 +0000
Message-ID: <CAFEAcA-rOAGxVrEs5q--z5BFq2YR0ExK8cmQn2PX1s+cCo27hA@mail.gmail.com>
References: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CF549A07
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 04:58:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LrGhn-fhmoCP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 04:58:30 -0500 (EST)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com
 [209.85.213.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C245949857
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 04:58:30 -0500 (EST)
Received: by mail-vk0-f41.google.com with SMTP id i129so157559221vkb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 02:02:43 -0800 (PST)
In-Reply-To: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: hiwu@derytech.com.tw
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 15 January 2016 at 09:33,  <hiwu@derytech.com.tw> wrote:
> How to lookup host virtual address by guest virtual address ?
> Is there any function to do guest page table walk?

There is no single function to do this (depending on what
bit of QEMU this is, we might either try a TLB access to
see if we can get guest-virtual to host-virtual, with a
slow-path fallback for TLB misses, or we might do guest
virtual to guest physical and then look up whether that
is RAM or a device and behave accordingly). What are you
actually trying to do?

thanks
-- PMM
