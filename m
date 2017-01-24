From: Andre Przywara <andre.przywara@foss.arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Add debugfs vgic-state file
Date: Tue, 24 Jan 2017 12:35:43 +0000
Message-ID: <1b65df04-0b3d-b012-ac33-9b3727a66c7c@foss.arm.com>
References: <20170120103330.13858-1-christoffer.dall@linaro.org>
 <524751ae-8e17-f9a0-88c6-95d4614478af@arm.com> <20170124105833.GM15850@cbox>
 <fde51e21-5f90-b2de-72a6-3ba04ed04893@arm.com> <20170124122954.GO15850@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A57BE40967
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 07:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E2EeIf+FkVBq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Jan 2017 07:34:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2FF4019A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 07:34:18 -0500 (EST)
In-Reply-To: <20170124122954.GO15850@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

[...]

>>>>
>>>> As I didn't understand the seq_* semantics in the first place, I didn't
>>>> have a look yet what could cause this.
>>>
>>> Nice catch, I'll have a look at this.
>>>
>>> Just so I'm sure, these are two processes reading the vgic-state file
>>> for the same single VM, right?
>>
>> Yes, just one VM. I was about to write a small test program which is a
>> bit more nasty and launches <n> threads all doing lseek();read(); on the
>> same file in a loop, but it turned out that this isn't necessary ;-)
>> I have that now working, so I can give this a test later.
>>
>> I was wondering if you could ditch that lseek / offset setting feature
>> at all? The smaller debugfs files don't support it as well (ESPIPE on
>> lseek()). Is that an option when setting up the seq interface?
>>
> 
> I think that only works if you're guaranteed to always only print within
> the buffer allocated for a single read, but if you run out of buffer
> space the seq_file code will allocate more space, do the fast forward
> thing, and continue reading where it left off.  I feel like when we're
> enumaring over 1000 irqs and could be spitting out a bunch of LPI data
> later on, this is a bit fragile.
> The recommendations also state you should only do this if you don't need
> a lot of locking or printing small data amounts, but I'm not enough of
> an expert on the seq file to know exactly when that applies and when it
> doesn't, but it doesn't feel like this fits within that bracket.

Thanks for the explanation, and this indeed makes some sense.
I just wanted to save you some nasty debugging, instead tricking you
into just papering over the issue ;-)

Cheers,
Andre.
