From: Bharat Bhushan <bharat.bhushan@nxp.com>
Subject: RE: [PATCH v4 00/12] KVM: arm64: GICv3 ITS emulation
Date: Mon, 6 Jun 2016 05:29:46 +0000
Message-ID: <DB5PR04MB09977DF578DFB03A582745869A5C0@DB5PR04MB0997.eurprd04.prod.outlook.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <DB5PR04MB099754E61027226E5210C2399A590@DB5PR04MB0997.eurprd04.prod.outlook.com>
 <32b86adb-cdba-89bb-3f19-e7677f39fa1f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2230412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 01:25:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2AZHP0zlTb-C for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2016 01:25:41 -0400 (EDT)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01on0062.outbound.protection.outlook.com [104.47.1.62])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4CCF40F90
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 01:25:40 -0400 (EDT)
In-Reply-To: <32b86adb-cdba-89bb-3f19-e7677f39fa1f@arm.com>
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
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Diana Madalina Craciun <diana.craciun@nxp.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On clarification, are V5 version of patches are based on new-GIC emulation patches? How are you testing these patches, kvm-tool?

Hi Christoffer/Peter,

Is someone working on QEMU side patches? We need this feature a bit urgently so if no one is working then we can start working on this.

Thanks
-Bharat

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
> bounces@lists.cs.columbia.edu] On Behalf Of Andre Przywara
> Sent: Friday, June 03, 2016 8:02 PM
> To: Bharat Bhushan <bharat.bhushan@nxp.com>
> Cc: kvm@vger.kernel.org; Marc Zyngier <marc.zyngier@arm.com>;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v4 00/12] KVM: arm64: GICv3 ITS emulation
> 
> Hi Bharat,
> 
> On 03/06/16 05:26, Bharat Bhushan wrote:
> > Hi Andre,
> >
> > We are looking for these patches but seems like these needed to
> > rebased/redesigned based on new GIC emulation changes. Can you give us
> > some sense on when this will be done?
> > Also do you know if someone is working on QEMU size changes for this,
> > if not then we can help on getting that done.
> 
> I just pushed a new version of the patches:
> https://lists.cs.columbia.edu/pipermail/kvmarm/2016-June/020482.html
> 
> I hope that answers your question about the kernel side of things.
> For QEMU I have no idea, maybe Christoffer or Peter would know.
> 
> Cheers,
> Andre.
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
