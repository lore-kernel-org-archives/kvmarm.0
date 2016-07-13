From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v9 00/17] KVM: arm64: GICv3 ITS emulation
Date: Wed, 13 Jul 2016 09:15:29 +0100
Message-ID: <ed267877-0071-1cf3-d173-4eedfd183c10@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <HE1PR04MB1321470CDA673EDB88B8930DFF310@HE1PR04MB1321.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F3349B5A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 04:09:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xF1slICdRWdS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 04:09:03 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B0449B54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 04:09:02 -0400 (EDT)
In-Reply-To: <HE1PR04MB1321470CDA673EDB88B8930DFF310@HE1PR04MB1321.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Diana Madalina Craciun <diana.craciun@nxp.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Diana,

On 13/07/16 08:57, Diana Madalina Craciun wrote:
> Hi Andre,
> 
> On 07/13/2016 04:59 AM, Andre Przywara wrote:
>> To test this you can use the kvmtool patches available in the "its-v6"
>> branch here [2].
>> Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
>> and see the ITS being used for instance by the virtio devices.
>>
>> [1]: git://linux-arm.org/linux-ap.git
>>      http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v9
>> [2]: git://linux-arm.org/kvmtool.git
> 
> It seems that its/emul/v9 branch does not exist.

I could claim it was just a test to see whether someone cares ;-), but
in fact I just forgot it.
Just pushed it now, please try again!

Thanks,
Andre.
