Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78D1C4741C
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:33:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 442782467A
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 442782467A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7694AC6C;
	Fri, 13 Dec 2019 06:28:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z3aSKtRvSujr; Fri, 13 Dec 2019 06:28:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E0B4A597;
	Fri, 13 Dec 2019 06:28:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFE584A483
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 06:28:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K7qhRNWkOuTl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 06:28:50 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A9A74A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 06:28:50 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifj7k-0004JA-4j; Fri, 13 Dec 2019 12:28:44 +0100
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
 collections
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 13 Dec 2019 11:28:43 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <d36b75e7-bd83-e501-3bd4-76bf0489c5ce@huawei.com>
References: <20191213094237.19627-1-eric.auger@redhat.com>
 <d36b75e7-bd83-e501-3bd4-76bf0489c5ce@huawei.com>
Message-ID: <9e9e3ed65ddf40ab72528187089e0997@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, eric.auger@redhat.com,
 eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 eric.auger.pro@gmail.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 2019-12-13 10:53, Zenghui Yu wrote:
> Hi Eric,
>
> On 2019/12/13 17:42, Eric Auger wrote:
>> Saving/restoring an unmapped collection is a valid scenario. For
>> example this happens if a MAPTI command was sent, featuring an
>> unmapped collection. At the moment the CTE fails to be restored.
>> Only compare against the number of online vcpus if the rdist
>> base is set.
>
> Have you actually seen a problem and this patch fixed it? To be 
> honest,
> I'm surprised to find that we can map a LPI to an unmapped collection 
> ;)
> (and prevent it to be delivered to vcpu with an 
> INT_UNMAPPED_INTERRUPT
> error, until someone had actually mapped the collection).
> After a quick glance of spec (MAPTI), just as you said, this is 
> valid.

Yes, this is one of the (many) odd bits in the architecture. And there 
is
a bizarre wording in the MAPC description when V=0:

"Behavior is unpredictable if there are interrupts that are mapped to 
the
specified collection, with the restriction that further translation 
requests
from that device are ignored."

It is really odd that:

- it is unpredictable to unmap the collection with mapped interrupts,
   but mapping interrupts to an unmapped collection is fine

- the notion of "interrupts from that device" doesn't match any of the
   MAPC parameters

Do you hate the GIC already? ;-)

> If Marc has no objection to this fix, please add
>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks for that, I've applied it to the patch and will push out
the update as soon as ra.kernel.org is reachable again.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
