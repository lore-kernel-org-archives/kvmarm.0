Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11487C00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 10:47:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54B082225E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 10:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/K/r3ia"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54B082225E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68DEA4B2A7;
	Mon,  2 Nov 2020 05:47:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QQ--mR4jiNLn; Mon,  2 Nov 2020 05:47:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D1B24B53D;
	Mon,  2 Nov 2020 05:47:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 091EC4B533
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 05:47:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wd6e0c6TOR-b for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 05:47:33 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 099774B2A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 05:47:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604314052;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=dte52e25xBoC2/b3aj6vhffLW479SBHbzp6Yy/rEPiI=;
 b=Q/K/r3iaDbnxpVZAIQk8CtFGPmT45448e0gmqBN3xqqAvcqIkzvHnLmeOs/ldlKFYg8MyC
 Do6yaS7RFDQ3UL349nIo+2gZMvVaYkHngeU1fcHrynXsPJRiqf3gJqtfsAEPswrkNQnCo2
 IhaWSzpCusDZ3OCxW0RWKT1oXSZ2Dx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-H92V8Ia-OqOoGg3xNt_OjQ-1; Mon, 02 Nov 2020 05:47:29 -0500
X-MC-Unique: H92V8Ia-OqOoGg3xNt_OjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1D038015B1;
 Mon,  2 Nov 2020 10:47:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA99C1002C24;
 Mon,  2 Nov 2020 10:47:22 +0000 (UTC)
Date: Mon, 2 Nov 2020 11:47:19 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH v2 3/5] arm64: spe: Add introspection
 test
Message-ID: <20201102104719.qqrt6l6rlx6n7i6o@kamzik.brq.redhat.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-4-alexandru.elisei@arm.com>
 <5745ad18-be1a-da91-7289-a48682ad59a5@redhat.com>
 <66ff5a16-1771-9423-9205-5aabb4635c1b@arm.com>
 <c78da5aa-f429-d651-c460-b6cc46d6f188@redhat.com>
 <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
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

On Fri, Oct 30, 2020 at 05:50:35PM +0000, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 10/30/20 5:09 PM, Auger Eric wrote:
> > Hi Alexandru,
> >
> > On 10/30/20 4:59 PM, Alexandru Elisei wrote:
> > [..]
> >>>> +	spe.align = 1 << spe.align;
> >>>> +
> >>>> +	pmsidr = read_sysreg_s(SYS_PMSIDR_EL1);
> >>>> +
> >>>> +	interval = (pmsidr >> SYS_PMSIDR_EL1_INTERVAL_SHIFT) & SYS_PMSIDR_EL1_INTERVAL_MASK;
> >>>> +	spe.min_interval = spe_min_interval(interval);
> >>>> +
> >>>> +	spe.max_record_size = (pmsidr >> SYS_PMSIDR_EL1_MAXSIZE_SHIFT) & \
> >>>> +		      SYS_PMSIDR_EL1_MAXSIZE_MASK;
> >>>> +	spe.max_record_size = 1 << spe.max_record_size;
> >>>> +
> >>>> +	spe.countsize = (pmsidr >> SYS_PMSIDR_EL1_COUNTSIZE_SHIFT) & \
> >>>> +			SYS_PMSIDR_EL1_COUNTSIZE_MASK;
> >>>> +
> >>>> +	spe.fl_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FL_SHIFT);
> >>>> +	spe.ft_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FT_SHIFT);
> >>>> +	spe.fe_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FE_SHIFT);
> >>> Why did you remove the report_info() section? I think those human
> >>> readable info can be useful.
> >> I made them part of the test. Since the architecture says they are 1, I think
> >> making sure their value matches is more useful than printing something that the
> >> architecture guarantees.
> > OK for those caps which are always 1 anyway but I was more thinking about
> >
> > report_info("Align= %d bytes, Min Interval=%d Single record Max Size =
> > %d bytes", spe.align, spe.min_interval, spe.maxsize);
> >
> > I'd prefer to keep it.
> 
> Oh, I think I see what you mean, I chose to print them using printf in main().
> This is very similar to what the timer test does, only it does it directly in
> main(), instead of calling another function (print_timer_info(), in the case of
> the timer test). I can move the printfs to spe_probe() if that's what you prefer.

Please use report_info(). When tests fail it's popular to diff the failing
results against the passing results. Some output changes each run, even
in the same environment, and some output really isn't that important. We
should keep important, non-test test results in INFO messages. Then, when
diffing, we can filter out anything without a prefix.

(BTW, I was cc'ed, or maybe bcc'ed, on this series from the beginning.)

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
