Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8314C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 09:56:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED78721973
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 09:56:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HRDcpdXE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED78721973
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DE64B5C4;
	Wed,  9 Sep 2020 05:56:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UMoAeGr7WVd6; Wed,  9 Sep 2020 05:56:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1024B37E;
	Wed,  9 Sep 2020 05:56:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B471E4B35F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 05:56:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bw1nnCX33jBm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 05:56:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0224B348
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 05:56:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599645391;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1F7oNSzkYrwwlqYYpWF6QycIDBNCbe1zVIPy2aNmoRg=;
 b=HRDcpdXENC6ksEpxyR5oiPNFknyP42PTS+UQHWal80fQy8VqRi7YmXu/Isb+z+PBxVBYmn
 dLYvQbSrK1ByJ2beNy1FNsZdv/C21xCq70kDR4SdEq17mzZWi5lZI9z2hzt6+KMARuBcqH
 zIeIDJR3Bk7875TvvXxhsPThEgOmwEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-Tpf0cnimPfydsd2tQ52ReA-1; Wed, 09 Sep 2020 05:56:27 -0400
X-MC-Unique: Tpf0cnimPfydsd2tQ52ReA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A0F78018A9;
 Wed,  9 Sep 2020 09:56:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.171])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A5205D9E8;
 Wed,  9 Sep 2020 09:56:19 +0000 (UTC)
Date: Wed, 9 Sep 2020 11:56:16 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
Message-ID: <20200909095616.bbblmk5bwosb5c7c@kamzik.brq.redhat.com>
References: <20200908205730.23898-1-graf@amazon.com>
 <20200909062534.zsqadaeewfeqsgsj@kamzik.brq.redhat.com>
 <fcb9ccab-2118-af76-3109-4d491d888c7c@amazon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fcb9ccab-2118-af76-3109-4d491d888c7c@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Sep 09, 2020 at 10:43:41AM +0200, Alexander Graf wrote:
> Hey Drew!
> 
> On 09.09.20 08:25, Andrew Jones wrote:
> > 
> > On Tue, Sep 08, 2020 at 10:57:30PM +0200, Alexander Graf wrote:
> > > We currently pass through the number of PMU counters that we have available
> > > in hardware to guests. So if my host supports 10 concurrently active PMU
> > > counters, my guest will be able to spawn 10 counters as well.
> > > 
> > > This is undesireable if we also want to use the PMU on the host for
> > > monitoring. In that case, we want to split the PMU between guest and
> > > host.
> > > 
> > > To help that case, let's add a PMU attr that allows us to limit the number
> > > of PMU counters that we expose. With this patch in place, user space can
> > > keep some counters free for host use.
> > 
> > Hi Alex,
> > 
> > Is there any reason to use the device API instead of just giving the user
> > control over the necessary PMCR_EL0 bits through set/get-one-reg?
> 
> I mostly used the attr interface because I was in that particular mental
> mode after looking at the filtering bits :).
> 
> Today, the PMCR_EL0 register gets reset implicitly on every vcpu reset call.
> How would we persist the counter field across resets? Would we in the first
> place?
> 
> I'm slightly hazy how the ONE_REG API would look like here. Do you have
> recommendations?
>

Using the set/get_user hooks of the sysreg table we can accept a user
input PMCR_EL0. We would only accept one that matches what the hardware
and KVM supports though (EINVAL otherwise). We'll need to modify reset to
use the value selected by the user too, which we can store in 'val' of the
sysreg table.

Since userspace will likely get before set in order to know what's valid,
we'll need to provide the current reset state on get until it has been
set. I'm not sure how to track whether it has been set or not. Maybe new
state is needed or an initial val=0 or val=~0 may work.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
