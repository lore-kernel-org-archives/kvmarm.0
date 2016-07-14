From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 00/17] KVM: arm64: GICv3 ITS emulation
Date: Thu, 14 Jul 2016 13:01:30 +0200
Message-ID: <bbc2c000-34c9-da9b-63ed-f322a18ad7fa@redhat.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <57876EE1.3020905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DAFF49B34
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 06:55:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qbjwd3I-xtcw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2016 06:55:41 -0400 (EDT)
Received: from mail-lf0-f44.google.com (mail-lf0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 427CC49B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 06:55:41 -0400 (EDT)
Received: by mail-lf0-f44.google.com with SMTP id q132so60183671lfe.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 04:01:35 -0700 (PDT)
In-Reply-To: <57876EE1.3020905@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 14/07/2016 12:52, Marc Zyngier wrote:
> I'm done with that round. Couple of annoying bugs, and still a bunch of
> loose ends to be tied. Timing wise, this is getting pretty tight for
> 4.8, so unless you address the comments very quickly, it will be a miss
> again.
> 
> My plan is to cut the 4.8 branch at the end of this week, so you have
> until then to repost something that I can stick into -next.

FYI I'm on vacation on July 24-31, and will send the pull request to
Linus around Aug 2.  If necessary you can delay things by one more week
and send a pull request to Radim around the end of July after the merge
window has officially started already.

Paolo
