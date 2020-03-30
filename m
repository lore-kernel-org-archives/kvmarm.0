Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0D5C43331
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 09:12:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FDB820733
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 09:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XIgl9shC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FDB820733
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F5424B15B;
	Mon, 30 Mar 2020 05:11:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ILYfOQTDN6ej; Mon, 30 Mar 2020 05:11:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56FE94B170;
	Mon, 30 Mar 2020 05:11:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4424B15A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 05:11:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZnZ-C4KRr8tQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 05:11:54 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D84CD4B156
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 05:11:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585559514;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=m2DCNzbDRPMtY5AnjTRXp7pP6euGDlLTuk3BX6MYjYU=;
 b=XIgl9shCPaavJGtc9Yp5n3i8xLVQzkkuC68CIqNvOcOuzdkz2/yC7awfYTAtN1VpaDvEOY
 mgzLmHHbRphz4wHjXAUxjluKFscRFp2ZBm4UmMOx0EX5wEKosk8A14ukroAZxIk9fHgvdB
 TM6+pUh2aw7oP3MtD8OUvntHT3dq8IU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-YUwdMTuWP9aQAZleaNZsXw-1; Mon, 30 Mar 2020 05:11:50 -0400
X-MC-Unique: YUwdMTuWP9aQAZleaNZsXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FFFDB83;
 Mon, 30 Mar 2020 09:11:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.172])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 340D419925;
 Mon, 30 Mar 2020 09:11:42 +0000 (UTC)
Date: Mon, 30 Mar 2020 11:11:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
Message-ID: <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Mar 30, 2020 at 10:46:57AM +0200, Auger Eric wrote:
> Hi Zenghui,
> =

> On 3/30/20 10:30 AM, Zenghui Yu wrote:
> > Hi Eric,
> > =

> > On 2020/3/20 17:24, Eric Auger wrote:
> >> +static void its_cmd_queue_init(void)
> >> +{
> >> +=A0=A0=A0 unsigned long order =3D get_order(SZ_64K >> PAGE_SHIFT);
> >> +=A0=A0=A0 u64 cbaser;
> >> +
> >> +=A0=A0=A0 its_data.cmd_base =3D (void *)virt_to_phys(alloc_pages(orde=
r));
> > =

> > Shouldn't the cmd_base (and the cmd_write) be set as a GVA?
> yes it should

If it's supposed to be a virtual address, when why do the virt_to_phys?

> > =

> > Otherwise I think we will end-up with memory corruption when writing
> > the command queue.=A0 But it seems that everything just works fine ...
> > So I'm really confused here :-/
> I was told by Paolo that the VA/PA memory map is flat in kvmunit test.

What does flat mean? kvm-unit-tests, at least arm/arm64, does prepare
an identity map of all physical memory, which explains why the above
is working. It's doing virt_to_phys(some-virt-addr), which gets a
phys addr, but when the ITS uses it as a virt addr it works because
we *also* have a virt addr =3D=3D phys addr mapping in the default page
table, which is named "idmap" for good reason.

I think it would be better to test with the non-identity mapped addresses
though.

Thanks,
drew

> =

> > =

> >> +
> >> +=A0=A0=A0 cbaser =3D ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)=
=A0=A0=A0 |
> >> GITS_CBASER_VALID);
> >> +
> >> +=A0=A0=A0 writeq(cbaser, its_data.base + GITS_CBASER);
> >> +
> >> +=A0=A0=A0 its_data.cmd_write =3D its_data.cmd_base;
> >> +=A0=A0=A0 writeq(0, its_data.base + GITS_CWRITER);
> >> +}
> > =

> > Otherwise this looks good,
> > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Thanks!
> =

> Eric
> > =

> > =

> > Thanks
> > =

> =

> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
