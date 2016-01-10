From: Amit Tomer <amittomer25@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: Output Guest cntvoff value
Date: Sun, 10 Jan 2016 22:55:32 +0530
Message-ID: <CABHD4K-5CvP+JK=74Z0=v42GTWOMwXU8Hw6R4H01hXiBs+AO5w@mail.gmail.com>
References: <1451674709-31074-1-git-send-email-amittomer25@gmail.com>
 <20160104142321.GB28354@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5701D499F2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 12:21:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BO0tD6QOehEq for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Jan 2016 12:21:37 -0500 (EST)
Received: from mail-yk0-f176.google.com (mail-yk0-f176.google.com
 [209.85.160.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38109499C9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 12:21:36 -0500 (EST)
Received: by mail-yk0-f176.google.com with SMTP id a85so332460893ykb.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 09:25:32 -0800 (PST)
In-Reply-To: <20160104142321.GB28354@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

> Out of curiosity, what is the value of having this?

As we know that host and guest clocks are not in sync(Running at a
difference of CNTVOFF value initialized in guest). This value can be
used to correlate the trace event between host and guest.

Thanks,
Amit.
