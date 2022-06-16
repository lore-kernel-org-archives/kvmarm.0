Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84888C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 09:03:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A2F4B2B8;
	Fri, 17 Jun 2022 05:03:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RxRRKTULj-mD; Fri, 17 Jun 2022 05:03:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7C04B326;
	Fri, 17 Jun 2022 05:03:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B94C54B0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 11:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bsZ9o2vRBTy3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 11:58:56 -0400 (EDT)
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4647449E45
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 11:58:56 -0400 (EDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-127-G5mX8BQ_PnOGd3hJyVz1GQ-1; Thu, 16 Jun 2022 16:58:53 +0100
X-MC-Unique: G5mX8BQ_PnOGd3hJyVz1GQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 16 Jun 2022 16:58:52 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 16 Jun 2022 16:58:52 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Andrew Jones' <drjones@redhat.com>, Raghavendra Rao Ananta
 <rananta@google.com>
Subject: RE: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Thread-Topic: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Thread-Index: AQHYgXkNkdHi2edO0UOJoWwOrv/ni61SMGPg
Date: Thu, 16 Jun 2022 15:58:52 +0000
Message-ID: <33ca91aeb5254831a88e187ff8d9a2c2@AcuMS.aculab.com>
References: <20220615185706.1099208-1-rananta@google.com>
 <20220616120232.ctkekviusrozqpru@gator>
In-Reply-To: <20220616120232.ctkekviusrozqpru@gator>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Colton Lewis <coltonlewis@google.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

From: Andrew Jones
> Sent: 16 June 2022 13:03
> 
> On Wed, Jun 15, 2022 at 06:57:06PM +0000, Raghavendra Rao Ananta wrote:
> > The selftests, when built with newer versions of clang, is found
> > to have over optimized guests' ucall() function, and eliminating
> > the stores for uc.cmd (perhaps due to no immediate readers). This
> > resulted in the userspace side always reading a value of '0', and
> > causing multiple test failures.
> >
> > As a result, prevent the compiler from optimizing the stores in
> > ucall() with WRITE_ONCE().
> >
> > Suggested-by: Ricardo Koller <ricarkol@google.com>
> > Suggested-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/aarch64/ucall.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > index e0b0164e9af8..be1d9728c4ce 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > @@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
> >
> >  void ucall(uint64_t cmd, int nargs, ...)
> >  {
> > -	struct ucall uc = {
> > -		.cmd = cmd,
> > -	};
> > +	struct ucall uc = {};
> >  	va_list va;
> >  	int i;
> >
> > +	WRITE_ONCE(uc.cmd, cmd);
> >  	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
> >
> >  	va_start(va, nargs);
> >  	for (i = 0; i < nargs; ++i)
> > -		uc.args[i] = va_arg(va, uint64_t);
> > +		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
> >  	va_end(va);
> >
> > -	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
> > +	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
> >  }

Am I misreading things again?
That function looks like it writes the address of an on-stack
item into global data.

Maybe 'uc' ought to be static?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
