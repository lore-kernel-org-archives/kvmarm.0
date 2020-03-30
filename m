Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6F3C43331
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 09:14:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A146720776
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 09:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6r9RsZ2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A146720776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 285624B1B9;
	Mon, 30 Mar 2020 05:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4UPIY34pwley; Mon, 30 Mar 2020 05:14:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE00B4B1C8;
	Mon, 30 Mar 2020 05:14:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A764B1B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 05:14:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lQfsBDmcfcRH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 05:14:04 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F283F4B1A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 05:14:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585559643;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=G3YtU9cQSu/MJLCZpAjz+jBQ87NL+MN25O2wNM+ILfI=;
 b=D6r9RsZ2FfLQYOYQGcLbqs5I9yxYXGAmQq5FmECRELYk+gpLnsvRDILP3AL2bD/Q9Q4u2h
 ZkCMd3sRLi37Ba2NkstitPwwUpMaoDVlV4Ge/Z7MEpJsdO8FJzWY3sVWgdI0bSny2reuJ1
 mlMWvoGeB6rvOaVY8S5qcPzT3InWCQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-htfeA-L7OCOCs7vXl5OVkQ-1; Mon, 30 Mar 2020 05:13:59 -0400
X-MC-Unique: htfeA-L7OCOCs7vXl5OVkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23080801A06;
 Mon, 30 Mar 2020 09:13:58 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.172])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C066D1036D00;
 Mon, 30 Mar 2020 09:13:51 +0000 (UTC)
Date: Mon, 30 Mar 2020 11:13:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 08/13] arm/arm64: ITS: Device and
 collection Initialization
Message-ID: <20200330091348.izdzq5ekc47vg2y3@kamzik.brq.redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-9-eric.auger@redhat.com>
 <63f3d8aa-c1e3-f40f-32a1-fb6d22e70541@huawei.com>
 <c5ce7101-9ea3-8b04-7ec0-cb27dfbdc116@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c5ce7101-9ea3-8b04-7ec0-cb27dfbdc116@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

On Wed, Mar 25, 2020 at 10:20:43PM +0100, Auger Eric wrote:
> Hi Zenghui,
> =

> On 3/25/20 9:10 AM, Zenghui Yu wrote:
> > Hi Eric,
> > =

> > On 2020/3/20 17:24, Eric Auger wrote:
> >> Introduce an helper functions to register
> >> - a new device, characterized by its device id and the
> >> =A0=A0 max number of event IDs that dimension its ITT (Interrupt
> >> =A0=A0 Translation Table).=A0 The function allocates the ITT.
> >>
> >> - a new collection, characterized by its ID and the
> >> =A0=A0 target processing engine (PE).
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v3 -> v4:
> >> - remove unused its_baser variable from its_create_device()
> >> - use get_order()
> >> - device->itt becomes a GVA instead of GPA
> >>
> >> v2 -> v3:
> >> - s/report_abort/assert
> >>
> >> v1 -> v2:
> >> - s/nb_/nr_
> >> ---
> >> =A0 lib/arm64/asm/gic-v3-its.h | 19 +++++++++++++++++++
> >> =A0 lib/arm64/gic-v3-its.c=A0=A0=A0=A0 | 38 ++++++++++++++++++++++++++=
++++++++++++
> >> =A0 2 files changed, 57 insertions(+)
> >>
> >> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
> >> index 4683011..adcb642 100644
> >> --- a/lib/arm64/asm/gic-v3-its.h
> >> +++ b/lib/arm64/asm/gic-v3-its.h
> >> @@ -31,6 +31,19 @@ struct its_baser {
> >> =A0 };
> >> =A0 =A0 #define GITS_BASER_NR_REGS=A0=A0=A0=A0=A0=A0=A0 8
> >> +#define GITS_MAX_DEVICES=A0=A0=A0=A0=A0=A0=A0 8
> >> +#define GITS_MAX_COLLECTIONS=A0=A0=A0=A0=A0=A0=A0 8
> >> +
> >> +struct its_device {
> >> +=A0=A0=A0 u32 device_id;=A0=A0=A0 /* device ID */
> >> +=A0=A0=A0 u32 nr_ites;=A0=A0=A0 /* Max Interrupt Translation Entries =
*/
> >> +=A0=A0=A0 void *itt;=A0=A0=A0 /* Interrupt Translation Table GVA */
> >> +};
> >> +
> >> +struct its_collection {
> >> +=A0=A0=A0 u64 target_address;
> >> +=A0=A0=A0 u16 col_id;
> >> +};
> >> =A0 =A0 struct its_data {
> >> =A0=A0=A0=A0=A0 void *base;
> >> @@ -39,6 +52,10 @@ struct its_data {
> >> =A0=A0=A0=A0=A0 struct its_baser coll_baser;
> >> =A0=A0=A0=A0=A0 struct its_cmd_block *cmd_base;
> >> =A0=A0=A0=A0=A0 struct its_cmd_block *cmd_write;
> >> +=A0=A0=A0 struct its_device devices[GITS_MAX_DEVICES];
> >> +=A0=A0=A0 u32 nr_devices;=A0=A0=A0=A0=A0=A0=A0 /* Allocated Devices */
> >> +=A0=A0=A0 struct its_collection collections[GITS_MAX_COLLECTIONS];
> >> +=A0=A0=A0 u32 nr_collections;=A0=A0=A0 /* Allocated Collections */
> >> =A0 };
> >> =A0 =A0 extern struct its_data its_data;
> >> @@ -93,5 +110,7 @@ extern void its_parse_typer(void);
> >> =A0 extern void its_init(void);
> >> =A0 extern int its_baser_lookup(int i, struct its_baser *baser);
> >> =A0 extern void its_enable_defaults(void);
> >> +extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
> >> +extern struct its_collection *its_create_collection(u32 col_id, u32
> >> target_pe);
> > =

> > Maybe use 'u16 col_id'?
> fair enough. At this point, not sure this is worth a respin though ;-)

I'd like all the virt_to_phys calls removed where there are not necessary,
which was pointed out in a different patch. This can be fixed up at the
same time.

Thanks,
drew

> > =

> > Besides,
> > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Thanks!
> =

> Eric
> =

> =

> =

> =

> > =

> > =

> > Thanks
> > =

> > =

> =

> =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
