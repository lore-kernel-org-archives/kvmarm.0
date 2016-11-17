From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 0/7] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Thu, 17 Nov 2016 12:41:16 +0100
Message-ID: <20161117114116.GB22231@cbox>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33E604041A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 06:40:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ZGvSG-TbIPS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 06:40:50 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC07C401E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 06:40:49 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id f82so140159212wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 03:41:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya,

On Fri, Nov 04, 2016 at 04:43:26PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> This patchset adds API for saving and restoring
> of VGICv3 registers to support live migration with new vgic feature.
> This API definition is as per version of VGICv3 specification
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> 
> The patch 3 & 4 are picked from the Pavel's previous implementation.
> http://www.spinics.net/lists/kvm/msg122040.html
> 
> v7 => v8:
>  - Rebased to 4.9-rc3

I noticed when looking at this series that there are quite a few
conflicts when applying to kvmarm/queue, so if you could rebase the next
verson on kvmarm/queue, then you'll make Marc's life a bit easier.

Thanks,
-Christoffer
