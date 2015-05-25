From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v3 4/4] target-arm: Add the GICv2m to the
 virt board
Date: Mon, 25 May 2015 22:56:00 +0200
Message-ID: <20150525205600.GA10659@cbox>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
 <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 204DD52018
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 16:45:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u0qXZyMOK9Uy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2015 16:45:56 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0E0251FF9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 16:45:55 -0400 (EDT)
Received: by lagv1 with SMTP id v1so55157515lag.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2015 13:55:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On Mon, May 25, 2015 at 04:09:58PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> >  typedef struct MemMapEntry {
> > @@ -88,6 +90,7 @@ typedef struct VirtBoardInfo {
> >      int fdt_size;
> >      uint32_t clock_phandle;
> >      uint32_t gic_phandle;
> > +    uint32_t v2m_phandle;
> >  } VirtBoardInfo;
> 
>  Could you rename v2m_phandle to something more neutral like msi_phandle ? It will also be
> used by GICv3 ITS implementation.
> 
That's sort of how to speculate about.  Why can't those patches just
rename the variable then?  Right now, as the code stands, msi_phandle
would be less clear IMHO.

-Christoffer
