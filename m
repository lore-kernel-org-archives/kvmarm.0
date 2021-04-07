Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D57C433ED
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 10:58:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17E5E61363
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 10:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17E5E61363
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87A9E4B85D;
	Wed,  7 Apr 2021 06:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sBL-oKt13Rug; Wed,  7 Apr 2021 06:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A79D4B847;
	Wed,  7 Apr 2021 06:58:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713F14B283
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 06:58:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uYjoV2YW1uym for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 06:58:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A928F4B24C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 06:58:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617793125;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/ectKhnKcoDaO3UDJhZ3amlFZtQ86PgM9l1u4tO96Zw=;
 b=Rd0zFJaJmxXepgPdkkW5jTsKzSbif1ZLEvobQmhZDYDMrU+1KIkGq+cULF/eTZI48ZwfTz
 j4tVWuYbhUW9MNKUfbYOkmeu9YHnII2S/vUvC3Ncumo7U3tBRg3sTbLsbYGRb1uJyf+wVD
 Lutb28mNlhM4AFyXAb/NsNfwsYjtfow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-w4DSsssAOOqklvgNCW5_mg-1; Wed, 07 Apr 2021 06:58:44 -0400
X-MC-Unique: w4DSsssAOOqklvgNCW5_mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 981FA107ACF2;
 Wed,  7 Apr 2021 10:58:42 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CF8319D61;
 Wed,  7 Apr 2021 10:58:36 +0000 (UTC)
Date: Wed, 7 Apr 2021 12:58:33 +0200
From: Andrew Jones <drjones@redhat.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 9/9] KVM: selftests: aarch64/vgic-v3 init sequence tests
Message-ID: <20210407105833.mrs5yk4prkopqp6p@kamzik.brq.redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
 <20210405163941.510258-10-eric.auger@redhat.com>
 <20210406150916.aym4eohr2mawfdkm@kamzik.brq.redhat.com>
 <3baf455d-c771-b2b7-a7ba-1cc4687054c8@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3baf455d-c771-b2b7-a7ba-1cc4687054c8@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
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

On Wed, Apr 07, 2021 at 12:14:29PM +0200, Auger Eric wrote:
> >> +int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
> >> +{
> >> +	struct kvm_create_device create_dev;
> >> +	int ret;
> >> +
> >> +	create_dev.type = type;
> >> +	create_dev.fd = -1;
> >> +	create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
> >> +	ret = ioctl(vm_get_fd(vm), KVM_CREATE_DEVICE, &create_dev);
> >> +	if (ret == -1)
> >> +		return -errno;
> >> +	return test ? 0 : create_dev.fd;
> > 
> > Something like this belongs in the non underscore prefixed wrappers.
> I need at least to return the create_dev.fd or do you want me to add an
> extra int *fd parameter?
> What about:
> 
>         if (ret < 0)
>                 return ret;
>         return test ? 0 : create_dev.fd;

Maybe the underscore version of kvm_create_device isn't necessary. If
the non-underscore version isn't flexible enough, then just use the
ioctl directly from the test code with its own struct kvm_create_device
Being able to call ioctls directly from test code is what vm_get_fd()
is for, otherwise you could just use vm->fd.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
