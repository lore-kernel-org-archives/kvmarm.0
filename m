Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF05C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 09:03:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 350554B30A;
	Fri, 17 Jun 2022 05:03:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTGz9+Wy-GrL; Fri, 17 Jun 2022 05:03:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6C04B330;
	Fri, 17 Jun 2022 05:03:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F8F49EB5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 17:54:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L4mcwivgzEOc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 17:54:22 -0400 (EDT)
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CBCA49EB2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 17:54:22 -0400 (EDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-62-astVriicPDe5cx5R_yDGqw-1; Thu, 16 Jun 2022 22:54:18 +0100
X-MC-Unique: astVriicPDe5cx5R_yDGqw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 16 Jun 2022 22:54:16 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 16 Jun 2022 22:54:16 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: "'oliver.upton@linux.dev'" <oliver.upton@linux.dev>
Subject: RE: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Thread-Topic: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Thread-Index: AQHYgXkNkdHi2edO0UOJoWwOrv/ni61SMGPg///3a4CAABX/cIAAENKAgABDjYA=
Date: Thu, 16 Jun 2022 21:54:16 +0000
Message-ID: <2ec9ecbfb13d422ab6cda355ff011c9f@AcuMS.aculab.com>
References: <3e73cb07968d4c92b797781b037c2d45@AcuMS.aculab.com>
 <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
 <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
 <20220616162557.55bopzfa6glusuh5@gator>
 <7b1040c48bc9b2986798322c336660ab@linux.dev>
In-Reply-To: <7b1040c48bc9b2986798322c336660ab@linux.dev>
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
X-Mailman-Approved-At: Fri, 17 Jun 2022 05:03:38 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Colton
 Lewis <coltonlewis@google.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Paolo
 Bonzini <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

From: oliver.upton@linux.dev
> Sent: 16 June 2022 19:45

> 
> June 16, 2022 11:48 AM, "David Laight" <David.Laight@aculab.com> wrote:
> > No wonder I was confused.
> > It's not surprising the compiler optimises it all away.
> >
> > It doesn't seem right to be 'abusing' WRITE_ONCE() here.
> > Just adding barrier() should be enough and much more descriptive.
> 
> I had the same thought, although I do not believe barrier() is sufficient
> on its own. barrier_data() with a pointer to uc passed through
> is required to keep clang from eliminating the dead store.

A barrier() (full memory clobber) ought to be stronger than
the partial one than barrier_data() generates.

I can't quite decide whether you need a barrier() both sides
of the 'magic write'.
Plausibly the compiler could discard the on-stack data
after the barrier() and before the 'magic write'.

Certainly putting the 'magic write' inside a asm block
that has a memory clobber is a more correct solution.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
