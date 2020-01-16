Return-Path: <SRS0=uwID=3F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D71C33CB3
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 08:06:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CC972075B
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 08:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUDuyi0l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CC972075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9557B4B0CF;
	Thu, 16 Jan 2020 03:06:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gTXWgRKvGtvz; Thu, 16 Jan 2020 03:06:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135144B133;
	Thu, 16 Jan 2020 03:06:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E214B156
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 03:06:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8gwZDklANKnm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jan 2020 03:06:23 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7C24B0CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 03:06:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579161983;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=T6hutKtjaQ1lNx4PJ3aLb67/cBy7jWlVyp/OF4XcnLo=;
 b=PUDuyi0lXrKtbT6WBYpooyUgCwTW7BX9Of8BcX8x24O4SPVncl8jpq7YFd+RcdZoJ7LD8C
 eSdzcNMQPExVe42quMABNRklrmP2S+egnFDUU03E4QwPPOI17Nmb8hBdDHPOioZPDZPtOq
 bDNgxlvbCMhP0lo1S193qhnwt119s5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-CiYYQcitPImWik046IWKbw-1; Thu, 16 Jan 2020 03:06:18 -0500
X-MC-Unique: CiYYQcitPImWik046IWKbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAA35800D55;
 Thu, 16 Jan 2020 08:06:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDB1C5DA70;
 Thu, 16 Jan 2020 08:06:11 +0000 (UTC)
Date: Thu, 16 Jan 2020 09:06:09 +0100
From: Andrew Jones <drjones@redhat.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 13/16] arm/arm64: ITS: INT functional
 tests
Message-ID: <20200116080609.thwiyi36rttnezxd@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-14-eric.auger@redhat.com>
 <20200113181701.jit3ywxoifduipew@kamzik.brq.redhat.com>
 <1c046216-b873-a4c1-4a7a-374f10947d59@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1c046216-b873-a4c1-4a7a-374f10947d59@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jan 15, 2020 at 06:11:23PM +0100, Auger Eric wrote:
> >> +static int its_prerequisites(int nb_cpus)
> >> +{
> >> +	int cpu;
> >> +
> >> +	if (!gicv3_its_base()) {
> >> +		report_skip("No ITS, skip ...");
> >> +		return -1;
> >> +	}
> >> +
> >> +	if (nr_cpus < 4) {
> >> +		report_skip("Test requires at least %d vcpus", nb_cpus);
> >> +		return -1;
> > 
> > We have nr_cpu_check() in arm/gic.c that does a report_abort for this
> > case. Is there a reason to do report_skip instead of report_abort?
> Why should we mandate 4 vcpus?

I don't know. It's your test :-) afaict if there aren't 4 vcpus then you
skip this test and exit, which is the same thing as report_abort'ing.
If you intend to run multiple tests and only want to skip a few when there
aren't enough vcpus, then I agree report_skip makes some sense.

On a related note, so far I've always tried to write tests that require
more than one vcpu to be testable with only two, but then test even more
if more are provided. Do you really need four for this test?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
