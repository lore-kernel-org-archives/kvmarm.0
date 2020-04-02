Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A5FC2D0F3
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:41:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 653D620784
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SRxHE2xH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 653D620784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 102CB4B164;
	Thu,  2 Apr 2020 10:41:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hXJCxCMX2KXD; Thu,  2 Apr 2020 10:41:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3EE44B15D;
	Thu,  2 Apr 2020 10:41:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B66D4B159
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:41:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yjFvMXDy8QhN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 10:41:27 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B0B4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:41:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585838487;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LQlIPwSA6eO8FaNGqaPVKwSvrWhWEma0a4EepOgZn9Y=;
 b=SRxHE2xHo6MwBPHWu79tFhGLGd+Rfik79qgtkL4tc34VNZMYNQAbW5O0zHggZ0OdnMXO52
 CdG75jI3MZzMukDps1XweOgiH/hNnG5FbqE1Jcgm8soNy1JuH3/MqRfbTQ8WWGRP8m800F
 6QNoOQ0yXal+8quQdCriIaee6O6yxvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-jcwdGm7hNY6oM0oaAdC1ag-1; Thu, 02 Apr 2020 10:41:25 -0400
X-MC-Unique: jcwdGm7hNY6oM0oaAdC1ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94C7419067E7;
 Thu,  2 Apr 2020 14:41:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 78A36D768E;
 Thu,  2 Apr 2020 14:41:15 +0000 (UTC)
Date: Thu, 2 Apr 2020 16:41:12 +0200
From: Andrew Jones <drjones@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [kvm-unit-tests PATCH v7 10/13] arm/arm64: ITS: INT functional
 tests
Message-ID: <20200402144112.u6nwzkqe7mt3rr6c@kamzik.brq.redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-11-eric.auger@redhat.com>
 <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
 <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
 <114f8bba-a1e0-0367-a1b4-e875718d8dba@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <114f8bba-a1e0-0367-a1b4-e875718d8dba@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On Thu, Apr 02, 2020 at 08:40:42PM +0800, Zenghui Yu wrote:
> Hi Eric,
> =

> On 2020/4/2 16:50, Auger Eric wrote:
> > Hi Zenghui,
> > =

> > On 3/30/20 12:43 PM, Zenghui Yu wrote:
> > > Hi Eric,
> > > =

> > > On 2020/3/20 17:24, Eric Auger wrote:
> > > > Triggers LPIs through the INT command.
> > > > =

> > > > the test checks the LPI hits the right CPU and triggers
> > > > the right LPI intid, ie. the translation is correct.
> > > > =

> > > > Updates to the config table also are tested, along with inv
> > > > and invall commands.
> > > > =

> > > > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > > =

> > > [...]
> > > =

> > > So I've tested this series and found that the "INT" test will sometim=
es
> > > fail.
> > > =

> > > "not ok 12 - gicv3: its-migration: dev2/eventid=3D20 triggers LPI 819=
5 en
> > > PE #3 after migration
> > > not ok 13 - gicv3: its-migration: dev7/eventid=3D255 triggers LPI 819=
6 on
> > > PE #2 after migration"
> > > =

> > >  From logs:
> > > "INFO: gicv3: its-migration: Migration complete
> > > INT dev_id=3D2 event_id=3D20
> > > INFO: gicv3: its-migration: No LPI received whereas (cpuid=3D3,
> > > intid=3D8195) was expected
> > > FAIL: gicv3: its-migration: dev2/eventid=3D20 triggers LPI 8195 en PE=
 #3
> > > after migration
> > > INT dev_id=3D7 event_id=3D255
> > > INFO: gicv3: its-migration: No LPI received whereas (cpuid=3D2,
> > > intid=3D8196) was expected
> > > FAIL: gicv3: its-migration: dev7/eventid=3D255 triggers LPI 8196 on P=
E #2
> > > after migration"
> > > =

> > > > +static void check_lpi_stats(const char *msg)
> > > > +{
> > > > +=A0=A0=A0 bool pass =3D false;
> > > > +
> > > > +=A0=A0=A0 mdelay(100);
> > > =

> > > After changing this to 'mdelay(1000)', the above error doesn't show up
> > > anymore. But it sounds strange that 100ms is not enough to deliver a
> > > single LPI. I haven't dig it further but will get back here later.
> > =

> > Did you find some time to investigate this issue. Changing 100 to 1000
> > has a huge impact on the overall test duration and I don't think it is
> > sensible. Could you see what is your minimal value that pass the tests?
> =

> I can reproduce this issue with a very *low* probability so I failed
> to investigate it :-(.  (It might because the LPI was delivered to a
> busy vcpu...)
> =

> You can leave it as it is until someone else complain about it again.
> Or take the similar approach as check_acked() - wait up to 5s for the
> interrupt to be delivered, and bail out as soon as we see it.

I think the check_acked approach would be the best approach.

Thanks,
drew

> =

> =

> Thanks,
> Zenghui
> =

> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
