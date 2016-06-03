From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 00/12] KVM: arm64: GICv3 ITS emulation
Date: Fri, 3 Jun 2016 15:32:01 +0100
Message-ID: <32b86adb-cdba-89bb-3f19-e7677f39fa1f@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <DB5PR04MB099754E61027226E5210C2399A590@DB5PR04MB0997.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2EA412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 10:27:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0EpKrLMoFQv0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 10:27:18 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4244F41267
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 10:27:17 -0400 (EDT)
In-Reply-To: <DB5PR04MB099754E61027226E5210C2399A590@DB5PR04MB0997.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bharat Bhushan <bharat.bhushan@nxp.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Bharat,

On 03/06/16 05:26, Bharat Bhushan wrote:
> Hi Andre,
> 
> We are looking for these patches but seems like these needed to
> rebased/redesigned based on new GIC emulation changes. Can you give us
> some sense on when this will be done?
> Also do you know if someone is working on QEMU size changes for
> this, if not then we can help on getting that done.

I just pushed a new version of the patches:
https://lists.cs.columbia.edu/pipermail/kvmarm/2016-June/020482.html

I hope that answers your question about the kernel side of things.
For QEMU I have no idea, maybe Christoffer or Peter would know.

Cheers,
Andre.
