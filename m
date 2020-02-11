Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EFEC3B187
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:49:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D9ED20656
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IGL+kH9B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D9ED20656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0CC4ACB7;
	Tue, 11 Feb 2020 10:49:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XWe85+ELLQzz; Tue, 11 Feb 2020 10:49:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F944AC88;
	Tue, 11 Feb 2020 10:49:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E264AC88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:49:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UzE44J8F+kpp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 10:49:30 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD1F4A578
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:49:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581436169;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fz/9T71wlj0EphJ0rxzCeEvJ/uyMAvvoFKZFbiWI/y4=;
 b=IGL+kH9BxzcEu9fAG7Ks3CJTc6izgafKusYkdCFIPZoDy5rpoWbJo4q1cCYAf2FEa4SMJ4
 egCVLAekyYb1kxrxA97V4bbakJtsKtEFdG8d/Yg/G1hgZ9sj9e+nQNyE7+hsd4gJKqIvdA
 qYQJy36G68vn3q+nEm/peYLiaRg2kh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-Fnl9TNtkPa2RWvAp4KFIAw-1; Tue, 11 Feb 2020 10:49:25 -0500
X-MC-Unique: Fnl9TNtkPa2RWvAp4KFIAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E16361800D42;
 Tue, 11 Feb 2020 15:49:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C64C260499;
 Tue, 11 Feb 2020 15:49:22 +0000 (UTC)
Date: Tue, 11 Feb 2020 16:49:20 +0100
From: Andrew Jones <drjones@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
Message-ID: <20200211154920.gxb32rzzcbnuo34v@kamzik.brq.redhat.com>
References: <20200211133705.1398-1-drjones@redhat.com>
 <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
 <83803119-0ea8-078d-628b-537c3d9525b1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <83803119-0ea8-078d-628b-537c3d9525b1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Feb 11, 2020 at 11:32:14PM +0800, Zenghui Yu wrote:
> On 2020/2/11 22:50, Zenghui Yu wrote:
> > Hi Drew,
> > =

> > On 2020/2/11 21:37, Andrew Jones wrote:
> > > Let's bail out of the wait loop if we see the expected state
> > > to save over six seconds of run time. Make sure we wait a bit
> > > before reading the registers and double check again after,
> > > though, to somewhat mitigate the chance of seeing the expected
> > > state by accident.
> > > =

> > > We also take this opportunity to push more IRQ state code to
> > > the library.
> > > =

> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > =

> > [...]
> > =

> > > +
> > > +enum gic_irq_state gic_irq_state(int irq)
> > =

> > This is a *generic* name while this function only deals with PPI.
> > Maybe we can use something like gic_ppi_state() instead?=A0 Or you
> > will have to take all interrupt types into account in a single
> > function, which is not a easy job I think.
> =

> Just to follow up, gic_irq_get_irqchip_state()/gic_peek_irq() [*] is
> the Linux implementation of this for PPIs and SPIs.
> =

> [*] linux/drivers/irqchip/irq-gic-v3.c
>

Thanks. I just skimmed that now and it looks like the diff I sent is
pretty close. But, I do see a bug in my diff (missing '* 4' on the
offset calculation).

Thanks,
drew =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
