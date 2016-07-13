From: Diana Madalina Craciun <diana.craciun@nxp.com>
Subject: Re: [PATCH v9 00/17] KVM: arm64: GICv3 ITS emulation
Date: Wed, 13 Jul 2016 07:57:21 +0000
Message-ID: <HE1PR04MB1321470CDA673EDB88B8930DFF310@HE1PR04MB1321.eurprd04.prod.outlook.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8419D49B40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 03:51:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ysJXcUfs9Go7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 03:51:33 -0400 (EDT)
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr40056.outbound.protection.outlook.com [40.107.4.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9956C49B3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 03:51:33 -0400 (EDT)
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric
 Auger <eric.auger@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 07/13/2016 04:59 AM, Andre Przywara wrote:
> To test this you can use the kvmtool patches available in the "its-v6"
> branch here [2].
> Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
> and see the ITS being used for instance by the virtio devices.
>
> [1]: git://linux-arm.org/linux-ap.git
>      http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v9
> [2]: git://linux-arm.org/kvmtool.git

It seems that its/emul/v9 branch does not exist.

Thanks,

Diana
