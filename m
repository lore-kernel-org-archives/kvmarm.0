From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Output Guest cntvoff value
Date: Sun, 10 Jan 2016 20:26:23 +0100
Message-ID: <20160110192623.GA13541@cbox>
References: <1451674709-31074-1-git-send-email-amittomer25@gmail.com>
 <20160104142321.GB28354@cbox>
 <CABHD4K-5CvP+JK=74Z0=v42GTWOMwXU8Hw6R4H01hXiBs+AO5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8C64993B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 14:21:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1k1SkiGuy2MH for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Jan 2016 14:21:50 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE8FA49937
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 14:21:50 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id u188so191573034wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 11:25:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CABHD4K-5CvP+JK=74Z0=v42GTWOMwXU8Hw6R4H01hXiBs+AO5w@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit Tomer <amittomer25@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jan 10, 2016 at 10:55:32PM +0530, Amit Tomer wrote:
> > Out of curiosity, what is the value of having this?
> 
> As we know that host and guest clocks are not in sync(Running at a
> difference of CNTVOFF value initialized in guest). This value can be
> used to correlate the trace event between host and guest.
> 
ok, I'm fine with this patch.

-Christoffer
