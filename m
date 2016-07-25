From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: KVM on ARM crashes with new VGIC v4.7-rc7
Date: Mon, 25 Jul 2016 16:25:02 +0100
Message-ID: <d9d3820f-f614-4728-f30b-17810dad80e2@arm.com>
References: <20160722173823.dcen33yyqqixmwkm@kamzik.localdomain>
 <57925CA0.7050904@arm.com> <762a6ad33268025f10b2198891e56d4d@agner.ch>
 <20160724132255.69ae1979@why.wild-wind.fr.eu.org>
 <20160724133604.7a538c75@why.wild-wind.fr.eu.org>
 <fc490685f98356a6bcf68270c7b81e5e@agner.ch> <5795C9C6.6090409@arm.com>
 <5795CB18.3060705@arm.com> <49791c0c-3a73-a05d-6b68-cdd943c33b95@arm.com>
 <57961CBA.1010008@arm.com>
 <20160725142858.dtch3pbf2x54p3n6@kamzik.localdomain>
 <57962B28.6030401@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37DDA49B54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 11:17:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KsmgpBkdmQHN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2016 11:17:46 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E009549B4E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 11:17:45 -0400 (EDT)
In-Reply-To: <57962B28.6030401@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 25/07/16 16:07, Marc Zyngier wrote:
> On 25/07/16 15:28, Andrew Jones wrote:
>> On Mon, Jul 25, 2016 at 03:05:46PM +0100, Marc Zyngier wrote:
>>> News flash: Mark Rutland just saw it crashing on his Seattle using my
>>> kernel that doesn't crash on mine. So we're looking at external factors
>>> now. DT, firmware, whatever.
>>
>> Interesting, especially with the information that the bug is also
>> on v7 with uboot (where it's present with 4k pages), and on v8
>> with UEFI (where it's not present with 4k pages, only 64k)
> 
> Here's what I get with Mark's DT:
> 
> [    2.199618] kvm [1]: 8-bit VMID
> [    2.202756] kvm [1]: Hyp mode initialized successfully
> [    2.207907] kvm [1]: GICV size 0x2000 not a multiple of page size 0x10000
> [    2.214736] kvm [1]: virtual timer IRQ4

Stefan, can you check whether you see something similar in your host
dmesg after booting? Do you use a DT that is based upon the upstream
imx7d.dtsi? Do you have an interrupt defined in there? Can you post the
DT, or at least the gic node?

> Somehow, we fail to detect that we cannot run with 64k pages,
> because we cannot safely pass the 8kB region to the guest.
> KVM should fail to initialize, or at least report that there
> is no VGIC. Drew, is that what you have on your system as well?

So chasing back the error path I see that we don't fail KVM entirely,
just set vgic_present to false. But that variable exists in
arch/arm/kvm/arm.c only and we don't check it in the VGIC code. Chasing
that trace now ...

Cheers,
Andre.
