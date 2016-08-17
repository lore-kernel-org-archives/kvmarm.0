From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: report configured SRE value to 32-bit world
Date: Wed, 17 Aug 2016 13:18:47 +0200
Message-ID: <20160817111847.GH8808@cbox>
References: <1470822583-9014-1-git-send-email-vladimir.murzin@arm.com>
 <1470822583-9014-2-git-send-email-vladimir.murzin@arm.com>
 <20160817104602.GE8808@cbox> <57B44299.2000600@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D98D40F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:09:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pz5PIzzMqkR3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 07:09:20 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 446C240F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:09:20 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id q128so193039663wma.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 04:16:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57B44299.2000600@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 17, 2016 at 11:55:21AM +0100, Vladimir Murzin wrote:
> On 17/08/16 11:46, Christoffer Dall wrote:
> > On Wed, Aug 10, 2016 at 10:49:43AM +0100, Vladimir Murzin wrote:
> >> After commit b34f2bc ("arm64: KVM: Make ICC_SRE_EL1 access return the
> >> configured SRE value") we report SRE value to 64-bit guest, but 32-bit
> >> one still handled as RAZ/WI what leads to funny promise we do not keep:
> >>
> >> "GICv3: GIC: unable to set SRE (disabled at EL2), panic ahead"
> >>
> >> We could keep that promise and force panic, but it doesn't look
> >> reliable, instead report configured SRE value to 32-bit guest.
> > 
> > I don't really understand this part of the commit message?
> > 
> > Why would we force a panic, and at what time?
> 
> To make statement "panic ahead" true ;) kind of irony, so feel free to
> remove that part (alternatively I can re-spin v2)
> 
No need, I just replaced it with:

  Instead, return the actual value of the ICC_SRE_EL1 register that the
  guest should see.

Thanks,
-Christoffer
