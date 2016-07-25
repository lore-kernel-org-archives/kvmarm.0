From: Andrew Jones <drjones@redhat.com>
Subject: Re: KVM on ARM crashes with new VGIC v4.7-rc7
Date: Mon, 25 Jul 2016 16:28:58 +0200
Message-ID: <20160725142858.dtch3pbf2x54p3n6@kamzik.localdomain>
References: <20160722173823.dcen33yyqqixmwkm@kamzik.localdomain>
 <57925CA0.7050904@arm.com>
 <762a6ad33268025f10b2198891e56d4d@agner.ch>
 <20160724132255.69ae1979@why.wild-wind.fr.eu.org>
 <20160724133604.7a538c75@why.wild-wind.fr.eu.org>
 <fc490685f98356a6bcf68270c7b81e5e@agner.ch>
 <5795C9C6.6090409@arm.com> <5795CB18.3060705@arm.com>
 <49791c0c-3a73-a05d-6b68-cdd943c33b95@arm.com>
 <57961CBA.1010008@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFC6849B30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 10:22:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wp-f-twghGii for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2016 10:22:38 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63355411E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 10:22:38 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <57961CBA.1010008@arm.com>
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
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 25, 2016 at 03:05:46PM +0100, Marc Zyngier wrote:
> News flash: Mark Rutland just saw it crashing on his Seattle using my
> kernel that doesn't crash on mine. So we're looking at external factors
> now. DT, firmware, whatever.

Interesting, especially with the information that the bug is also
on v7 with uboot (where it's present with 4k pages), and on v8
with UEFI (where it's not present with 4k pages, only 64k)

drew
