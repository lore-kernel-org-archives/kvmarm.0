From: Christoffer Dall <cdall@linaro.org>
Subject: Re: unmap_ptes is not complete
Date: Wed, 29 Nov 2017 19:08:44 +0100
Message-ID: <20171129180844.GF10563@lvm>
References: <CAPB=Z-piv-Fe+7p9xH8TuZ=xH6oJHmh2+g+Dk6gJRagixseL_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3003A49D75
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 13:05:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ro3dQJ33aL1D for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Nov 2017 13:05:53 -0500 (EST)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD1F949D6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 13:05:52 -0500 (EST)
Received: by mail-wr0-f180.google.com with SMTP id a41so2359476wra.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 10:08:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPB=Z-piv-Fe+7p9xH8TuZ=xH6oJHmh2+g+Dk6gJRagixseL_Q@mail.gmail.com>
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

Hi Raz,

On Mon, Nov 27, 2017 at 09:10:56PM +0000, Raz wrote:
> Hey
> in mmu.c unmap_ptes() you invalidate *pte but not the pte itself. This
> leads to inconsistency in el2 translation tables. ie; the pte entry is
> cleared in the cached memory but not in the RAM, so the entry may still be
> valid in EL2 translation tables.

I'm not sure which code you're talking about.  Perhaps try sending a
patch?

> You should also clear pte itself.
> 

If you're talking about unmap_stage2_ptes(), then I must be missing
something, because I don't see why setting the pointer to 0 should
matter, and what you say about cached memory and RAM doesn't sound
correct, as all virtualization-capable ARM CPUs have coherent page table
walks.

Thanks,
-Christoffer
