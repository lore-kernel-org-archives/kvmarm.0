From: Alexander Graf <agraf@suse.de>
Subject: Re: development guide for installing KVMARM kernel
Date: Tue, 11 Oct 2016 22:11:01 +0200
Message-ID: <77b4ee22-a823-07e1-e4f8-9677efb839f9@suse.de>
References: <CY1PR0401MB1629013D592E886EF2332C80EEC50@CY1PR0401MB1629.namprd04.prod.outlook.com>
 <8a3d33a861d6dc90ef2da82ad3f1950c@www.loen.fr>
 <CY1PR0401MB16290C3826BFA5ED46E3F81BEEC70@CY1PR0401MB1629.namprd04.prod.outlook.com>
 <bd6adc0e4698903a5bc986e88f4ab9dd@www.loen.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AED40412ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2016 16:01:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0tmUn2jh7O5Z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Oct 2016 16:01:01 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C75884113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Oct 2016 16:01:01 -0400 (EDT)
In-Reply-To: <bd6adc0e4698903a5bc986e88f4ab9dd@www.loen.fr>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <maz@misterjones.org>, Eugene Bagdasaryan <eb693@cornell.edu>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 10.10.16 15:50, Marc Zyngier wrote:
> On 2016-10-06 19:54, Eugene Bagdasaryan wrote:
>> Hey Marc
>>
>> I basically want to try and install OpenStack on RPi, which I guess
>> is possible.
> 
> Sounds pretty ambitious, but I guess someone has to try...
> 
>> (1) For the 64-bit arm OS, what would you suggest?
> 
> I'll defer that to the local RPi zealot (Alex, cc'd), because I've
> stopped caring about this platform long before it even existed.
> 
> Alex, would you mind letting Eugene know how to run a full 64bit
> mainline kernel + userspace on a RPi3?

Sure! If everything works (and if it doesn't, please report to the
mailing list), just follow the description below:


https://en.opensuse.org/HCL:Raspberry_Pi3#Installing_the_64-bit_non-upstream_openSUSE_Tumbleweed_image

Get the image, put it on an SD card, boot it up (it takes ~5 minutes for
the first boot), then install your own upstream kernel on it and run it.
4.8 should work just fine.

If you also want KVM, make sure you have the user space irqchip fixes in
your kernel.


Alex
