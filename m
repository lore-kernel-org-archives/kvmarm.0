From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v7 09/17] KVM: arm64: introduce ITS emulation file with
 MMIO framework
Date: Mon, 4 Jul 2016 15:00:12 +0100
Message-ID: <33ff8f2c-89e0-5778-71a6-9d116e061752@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-10-andre.przywara@arm.com>
 <3fec9632-ce39-3508-2b71-4049fc959a64@redhat.com>
 <32d54016-731d-e4a9-272d-8b0934ebec31@arm.com>
 <8546ac45-f7cd-31af-a261-bb85ca7305ca@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10BE940F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jul 2016 09:53:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0KOMYmNV2jED for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jul 2016 09:53:55 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE4C240F77
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jul 2016 09:53:54 -0400 (EDT)
In-Reply-To: <8546ac45-f7cd-31af-a261-bb85ca7305ca@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 04/07/16 14:54, Auger Eric wrote:
> Hi Andre,
> 
> On 04/07/2016 15:38, Andre Przywara wrote:
>> 2) on KVM_DEV_ARM_VGIC_GRP_ADDR check that "initialized" is false
>> 3) on KVM_DEV_ARM_VGIC_CTRL_INIT check that "initialized" is false
>> 4) after KVM_DEV_ARM_VGIC_CTRL_INIT set initialized to true
>>
>> I don't want to rely solely on vgic_its_base being ADDR_UNDEF, since I
>> expect we extend that interface later by supporting more options (for
>> instance to size the virtual ITS, in terms of devices, number of LPIs,
>> collections, etc.)
>>
>> Does that make sense?
>> Or do we need more here?
> 
> So you will accept a call to KVM_DEV_ARM_VGIC_CTRL_INIT with an unset
> address? I don't think this is relevant.

Ah, good point. Will fix this.

However I think we do the same on GICv2/GICv3 at the moment. CTRL_INIT
will succeed, I guess we fail the first KVM_RUN then, right?

Cheers,
