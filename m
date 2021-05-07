Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81928C43461
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 10:28:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16E866143F
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 10:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16E866143F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC43C4B589;
	Fri,  7 May 2021 06:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9tddFVojS7iW; Fri,  7 May 2021 06:28:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 722A84B587;
	Fri,  7 May 2021 06:28:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0A7A4B534
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 05:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hz-iJ5SvorwJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 05:59:32 -0400 (EDT)
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83EBE4B531
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 05:59:32 -0400 (EDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-124-XIgOuarZNwyN-c2JrDVmUg-1; Fri, 07 May 2021 10:59:29 +0100
X-MC-Unique: XIgOuarZNwyN-c2JrDVmUg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 7 May 2021 10:59:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 7 May 2021 10:59:27 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Steven Price' <steven.price@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: RE: [PATCH v11 5/6] KVM: arm64: ioctl to fetch/store tags in a guest
Thread-Topic: [PATCH v11 5/6] KVM: arm64: ioctl to fetch/store tags in a guest
Thread-Index: AQHXQyWd0YdlNuDzYEavAjiQNQoHN6rXyCEQ
Date: Fri, 7 May 2021 09:59:27 +0000
Message-ID: <42fd9c5ceb974be3b2aae5dd288507e8@AcuMS.aculab.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-6-steven.price@arm.com>
 <20210427175844.GB17872@arm.com>
 <340d35c2-46ed-35ea-43fa-e5cb64c27230@arm.com> <YJGIBTor+blelKKT@arm.com>
 <25c85740-0119-549e-6ddb-aea69c5efc76@arm.com>
In-Reply-To: <25c85740-0119-549e-6ddb-aea69c5efc76@arm.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
X-Mailman-Approved-At: Fri, 07 May 2021 06:28:11 -0400
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Marc Zyngier <maz@kernel.org>,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Steven Price <steven.price@arm.com>
> Sent: 07 May 2021 10:45
> 
> On 04/05/2021 18:44, Catalin Marinas wrote:
> > On Thu, Apr 29, 2021 at 05:06:07PM +0100, Steven Price wrote:
> >> On 27/04/2021 18:58, Catalin Marinas wrote:
> >>> On Fri, Apr 16, 2021 at 04:43:08PM +0100, Steven Price wrote:
> >>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >>>> index 24223adae150..2b85a047c37d 100644
> >>>> --- a/arch/arm64/include/uapi/asm/kvm.h
> >>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >>>> @@ -184,6 +184,20 @@ struct kvm_vcpu_events {
> >>>>    	__u32 reserved[12];
> >>>>    };
> >>>> +struct kvm_arm_copy_mte_tags {
> >>>> +	__u64 guest_ipa;
> >>>> +	__u64 length;
> >>>> +	union {
> >>>> +		void __user *addr;
> >>>> +		__u64 padding;
> >>>> +	};
> >>>> +	__u64 flags;
> >>>> +	__u64 reserved[2];
> >>>> +};
> > [...]
> >>> Maybe add the two reserved
> >>> values to the union in case we want to store something else in the
> >>> future.
> >>
> >> I'm not sure what you mean here. What would the reserved fields be unioned
> >> with? And surely they are no longer reserved in that case?
> >
> > In case you want to keep the structure size the same for future
> > expansion and the expansion only happens via the union, you'd add some
> > padding in there just in case. We do this for struct siginfo with an
> > _si_pad[] array in the union.
> >
> 
> Ah I see what you mean. In this case "padding" is just a sizer to ensure
> that flags is always the same alignment - it's not intended to be used.
> As I noted previously though it's completely pointless as this only on
> arm64 and even 32 bit Arm would naturally align the following __u64.

It is nice to be explicit though.
You also have the problem that a 32bit (LE) application would leave the
high bits of the user address undefined.

All moot and pointless if 64bit only though.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
