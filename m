From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: kvm status on lsk-3.14
Date: Thu, 3 Sep 2015 10:52:23 +0200
Message-ID: <20150903085223.GD5171@cbox>
References: <BY2PR0301MB0743E324B8112812CC532C2587690@BY2PR0301MB0743.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D020041289
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 04:50:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dVPjN0x2ijhY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2015 04:50:35 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86E1C411AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 04:50:34 -0400 (EDT)
Received: by lbcjc2 with SMTP id jc2so20244635lbc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2015 01:50:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <BY2PR0301MB0743E324B8112812CC532C2587690@BY2PR0301MB0743.namprd03.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Kevin Hilman <khilman@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 02, 2015 at 04:56:46PM +0000, Stuart Yoder wrote:
> Chris,
> 
> On the Linaro wiki there is an ARMv8 status page
> https://wiki.linaro.org/LSK/ARMv8
> 
> ...that seems a bit out of date.  It reports that KVM
> support on the Linaro 3.14 kernel had a "target" of
> release 14.10 (last October).
> 
> I see ~70 "arm64:" + "kvm:" patches added or backported
> to the Linaro 3.14 kernel.  Is KVM considered 'supported'
> in the latest lsk-3.14? If yes, are there any known
> limitations or anything missing?

We've backported most of the functionality and fixes up until 4.0, I
believe.

> 
> We have a customer interested in 3.14 on 
> ARMv8 and would like to understand what I can say
> about KVM support on the Linaro 3.14 kernel.
> 

The biggest weakness is probably lack of testing for virtualization
purposes.  I'm not aware of anyone haveing done any serious testing on
LSK with KVM.

Cc'ing Kevin for his comments on the testing and status aspect.

Thanks,
-Christoffer
