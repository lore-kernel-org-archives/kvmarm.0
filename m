From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v11 0/8] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Fri, 27 Jan 2017 11:27:21 +0100
Message-ID: <20170127102721.GA10506@cbox>
References: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
 <20170126202640.GD15850@cbox>
 <9fea1713-7087-7052-5ca6-d9257a6f973a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7D0D4092C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 05:27:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W-plqS4Zw++K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Jan 2017 05:27:12 -0500 (EST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 022D540430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 05:27:11 -0500 (EST)
Received: by mail-lf0-f46.google.com with SMTP id x1so72948798lff.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 02:27:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <9fea1713-7087-7052-5ca6-d9257a6f973a@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 27, 2017 at 09:45:06AM +0000, Marc Zyngier wrote:
> On 26/01/17 20:26, Christoffer Dall wrote:
> > Hi Vijaya,
> > 
> > On Thu, Jan 26, 2017 at 07:50:45PM +0530, vijay.kilari@gmail.com wrote:
> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>
> >> This patchset adds API for saving and restoring
> >> of VGICv3 registers to support live migration with new vgic feature.
> >> This API definition is as per version of VGICv3 specification
> >> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> >>
> >> The patch 3 & 4 are picked from the Pavel's previous implementation.
> >> http://www.spinics.net/lists/kvm/msg122040.html
> >>
> >> NOTE: Only compilation tested for AArch32. No hardware available to test.
> > 
> > Thanks for the respin.  I've given this a once-over and tested on GICv2
> > against migrations and on GICv3 for this functionality, and it looks

haha, just noticed this.  That's against *regressions* obviously.


> > good.
> > 
> > It would be good to see a soon respin of the QEMU series as well.
> > 
> > Marc, unless others have objections to this series, I think we can queue
> > this series.
> 
> Yup, I'll queue it on top. Thanks everyone for sticking with this series.
> 

Thanks,
-Christoffer
