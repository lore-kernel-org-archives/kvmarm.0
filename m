From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 01/19] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Thu, 16 Mar 2017 16:25:43 +0100
Message-ID: <23365078-ef4e-fa69-40d2-7177ca603862@redhat.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-2-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_hobSQZvOQHGgdoJYw9q099GNrY=5ffjYO5YeePtKdNA@mail.gmail.com>
 <6f86ec3f-6b9e-34ba-628a-c2ef7b8c3529@redhat.com>
 <CAFEAcA_VqJQ-BFQPpdnK07x6B=cN-HcPY7pBr7=J5UGXm4iSnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 305D140A6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 11:24:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g5uhLm7wIxlS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 11:24:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C40E40064
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 11:24:12 -0400 (EDT)
In-Reply-To: <CAFEAcA_VqJQ-BFQPpdnK07x6B=cN-HcPY7pBr7=J5UGXm4iSnQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On 13/03/2017 18:38, Peter Maydell wrote:
> On 13 March 2017 at 15:42, Auger Eric <eric.auger@redhat.com> wrote:
>> On 13/03/2017 14:08, Peter Maydell wrote:
>>> These CTE/ITE/DTE formats don't seem to have any kind of
>>> "escape hatch" for allowing backwards compatible extensions
>>> to the format. Do we need one? (I think that's particularly
>>> likely to be useful where there's an ITS feature we don't
>>> currently implement but might perhaps want to in future,
>>> like GICv4 virtual interrupt injection.)
>>
>> Maybe we could rely on the ITS registers (that must be restored before
>> the tables) to get any info about the format used to encode the table
>> entries. We have GITS_CTLR[1] that can help discriminate between GICv3/
>> GICv4. GITS_BASER.Entry_size can be 8B for current implementation and
>> 16B for an enhanced implementation. CTE[52:62] can be used to encode a
>> format version.
> 
> Using the registers seems like a good idea, though I
> don't know about the specific fields. The most obvious
> place to keep something like this would be GITS_IIDR.Revision
> I suppose. Using the "size of the table entry" fields would
> work too.
> 
> If we have to make all these tables double the size if
> we move to 16b/entry in future, is that a significant
> increase in memory used, or a don't-really-care increase?
Sorry for the delay, I tried to have a better understanding of the GICv4
new features before answering.

I don't think the device table nor the collection table are impacted by
GICv4. To me only the ITT is impacted and ITE would certainly become
2*8Bytes since there are new fields to encode (vPE, doorbell INTID). We
would also need to save/restore the vPE table.

ITT size for 1 device is nb_supported_eventids_for_the_device * 8 or 16
Bytes

I would tempt to think this falls under the category of don't-really-care.
> 
> I guess what we should do is:
>  * identify obviously imminently upcoming features (like
>    GICv4 support, wider physaddrs) and make sure the format
>    supports them
>    [let's say, anything we think we're definitely likely
>    to be adding in the next 12 months]
- support of GICv4 on guest side. I guess this relates to nested
virtualization use case.
- extension of phys addrs, Marc? is there any requirement/plan?
>  * decide on our 'escape hatch' plan for anything
>    more vague
OK I will formalize this. My understanding is if we need to update the
ITE format, we will directly encode all the fields and update the ITE
size to a 2x 8B entry. This change is easily recognizable through
GITS_TYPER register.
>  * test that we do correctly fail migration for an
>    incoming ITS state that asks for an unsupported Revision
OK I will do that
>  * document how the 'escape hatch' is intended to work
>    so we don't then invent a different approach in the
>    future :-)
OK

Thanks

Eric
> 
> thanks
> -- PMM
> 
