From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 8 Oct 2015 12:14:08 +0200
Message-ID: <20151008101408.GA20936@cbox>
References: <cover.1443796321.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71CA641451
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 06:11:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uaAx0thk2RL1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 06:11:56 -0400 (EDT)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
 [209.85.217.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35E9941338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 06:11:56 -0400 (EDT)
Received: by lbos8 with SMTP id s8so40911470lbo.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 03:13:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1443796321.git.p.fedin@samsung.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On Fri, Oct 02, 2015 at 05:44:27PM +0300, Pavel Fedin wrote:
> Current KVM code has lots of old redundancies, which can be cleaned up.
> This patchset is actually a better alternative to
> http://www.spinics.net/lists/arm-kernel/msg430726.html, which allows to
> keep piggy-backed LRs. The idea is based on the fact that our code also
> maintains LR state in elrsr, and this information is enough to track LR
> usage.
> 
> This patchset is made against linux-next of 02.10.2015. Thanks to Andre
> for pointing out some 4.3 specifics.
> 
I'm not opposed to these changes, they clean up the data structures
which is definitely a good thing.

I am a bit worries about how/if this is going to conflict with the ITS
series and other patches in flight touchignt he vgic.

Marc/Andre, any thoughts on this?

-Christoffer
