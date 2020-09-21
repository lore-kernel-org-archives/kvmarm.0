Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6C2C43465
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 14:49:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B927C221EC
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 14:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zsy3GD2u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B927C221EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CC364B275;
	Mon, 21 Sep 2020 10:49:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N2B1e9QUbvId; Mon, 21 Sep 2020 10:49:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A46D4B518;
	Mon, 21 Sep 2020 10:49:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 734844B50F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 10:49:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xJHpQNubpC89 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 10:49:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 850084B275
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 10:49:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600699790;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=F3FyjfZ9RZEbVqhAWSzA19t3wmR3tQIA6RiVWQrCB2A=;
 b=Zsy3GD2uiM1kysEn83QEwSs0pQ9SAm5+bDUTQjUkVKkzmBXVdCtXusONiPgMAmmO30pIF+
 jAZIjTgGUK5gU3bgsbpivvYTzOQo6gFpfBqnfSaO03d5oLFhWHyWOnmTcMZa++LainHEcI
 KQ7WpUksTLKwKRf6CyThFdMcgKcDz+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-RMU1iApAOumlpDm5azAWWg-1; Mon, 21 Sep 2020 10:49:46 -0400
X-MC-Unique: RMU1iApAOumlpDm5azAWWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 402668015FA;
 Mon, 21 Sep 2020 14:49:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.131])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE6603782;
 Mon, 21 Sep 2020 14:49:43 +0000 (UTC)
Date: Mon, 21 Sep 2020 16:49:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Match PMU error code descriptions with
 error conditions
Message-ID: <20200921144940.cgeu7liuo772vx5j@kamzik.brq.redhat.com>
References: <20200921130838.37296-1-alexandru.elisei@arm.com>
 <20200921130838.37296-3-alexandru.elisei@arm.com>
 <20200921141713.dr6l6po2luqyodjx@kamzik.brq.redhat.com>
 <cafbf0c7-1fed-3188-3f73-50611263fc2c@arm.com>
MIME-Version: 1.0
In-Reply-To: <cafbf0c7-1fed-3188-3f73-50611263fc2c@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Sep 21, 2020 at 03:30:24PM +0100, Alexandru Elisei wrote:
> Hi Andrew,
> 
> Thank you for having a look at this.
> 
> On 9/21/20 3:17 PM, Andrew Jones wrote:
> 
> > On Mon, Sep 21, 2020 at 02:08:38PM +0100, Alexandru Elisei wrote:
> >> Update the description of the PMU KVM_{GET, SET}_DEVICE_ATTR error codes
> >> to be a better match for the code that returns them.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  Documentation/virt/kvm/devices/vcpu.rst | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> >> index 96d6cf77cb1e..5b8db30c61db 100644
> >> --- a/Documentation/virt/kvm/devices/vcpu.rst
> >> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> >> @@ -26,8 +26,8 @@ Returns:
> >>  	 =======  ========================================================
> >>  	 -EBUSY   The PMU overflow interrupt is already set
> >>  	 -EFAULT  Error reading interrupt number
> >> -	 -ENXIO   The overflow interrupt not set when attempting to get it
> >> -	 -ENODEV  PMUv3 not supported
> >> +	 -ENXIO   PMUv3 not supported
> > I think -ENXIO matched the code better before the change.
> 
> KVM_SET_DEVICE_ATTR for KVM_ARM_VCPU_PMU_V3_IRQ returns -ENXIO if
> CONFIG_KVM_ARM_PMU is not set (in include/kvm/arm_pmu.h).
> 
> But I think I understand what you mean, you're referring to
> kvm_arm_pmu_v3_get_attr(), which returns -ENXIO if the irq number was not set. I
> can change the description to "PMUv3 not supported or the overflow interrupt not
> set when attempting to get it", what do you think?
>

Works for me.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
