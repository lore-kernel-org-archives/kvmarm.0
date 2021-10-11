Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D72C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 12:45:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDD4A60F3A
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 12:45:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DDD4A60F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 827624B0B8;
	Mon, 11 Oct 2021 08:45:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2jJyG4vCcyV0; Mon, 11 Oct 2021 08:45:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3374B0BD;
	Mon, 11 Oct 2021 08:45:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 157DF4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 08:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T7-jQR4Ie8nw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 08:45:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D2BA4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 08:45:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633956353;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HLQTlu/zNNIUvc/JMMQ+IXkLoOHLj3d35ae3vo+SDqM=;
 b=S3tAMZdKAev320J7mPdD6f2BKgVml86fVNTqZ90iz02BzWTKmn67166i5mYdrsDJjkSLLj
 K5+ulJoQkJTGbhaKUyBPIrHEfdRE1fOWpli20IPAFkxMXsYHYmjyYs531x123aPRLklrGR
 UdW11+S57Nf7jPHuXI7421MNkcp0AL0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-YbtKPo2uMYSo3LIQEu3MiQ-1; Mon, 11 Oct 2021 08:45:52 -0400
X-MC-Unique: YbtKPo2uMYSo3LIQEu3MiQ-1
Received: by mail-wr1-f71.google.com with SMTP id
 f11-20020adfc98b000000b0015fedc2a8d4so13226542wrh.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 05:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HLQTlu/zNNIUvc/JMMQ+IXkLoOHLj3d35ae3vo+SDqM=;
 b=FW7iORSKxQ6c7M5Rot8NsA0vzoOpsmQazuq4FaUq7Yi95L7JagWX8RGnLerHZZ2ZXT
 qpRsegMLkgSvKfBsJNtaGeb/1NPWksGhZRsYOx1E8cBx4GpPQFN63P1gOl0n58U+F43i
 7X4dGaH0TAKq9A0NbiqRD6p327yzfT+eqZUHvc6zpJRQqfkb8VQir+tUeVVVl/ngcvzX
 KWhwjn1i6zaD/zFjgkQZHNxlY2Dzk3tNye/O2modNTmaH+AY87f2ubqboRveSTmYa3H9
 SkqcskkCoHqQmm7vKb/1pjS5SBUeNuUXBihT5hSbj+c152c/U+xBdRxlvSBnAduErXDC
 jO7A==
X-Gm-Message-State: AOAM531bjUYjZ5pPdJJ3rbLfh7lSxSUKshoYdFQRbK1T/j7EqdlVzinR
 0XKMN2hiuSpvcidaGoCURJX5WtfJirsHarA0xo9dtxWmIbFtw6AyJIqpf6Nef4IiVzkmgllYmhO
 UWm4tEbMPwDbExWlSVCn7TK4m
X-Received: by 2002:a05:6000:154b:: with SMTP id
 11mr2699302wry.422.1633956350974; 
 Mon, 11 Oct 2021 05:45:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8MvAutDCZCeoaqhsVZYtxlzZFMh6u60EhMSoLVe/183YCy9wLAIjPrPbKXmZuEd0G6NB6Nw==
X-Received: by 2002:a05:6000:154b:: with SMTP id
 11mr2699283wry.422.1633956350872; 
 Mon, 11 Oct 2021 05:45:50 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id 143sm21226770wma.37.2021.10.11.05.45.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Oct 2021 05:45:50 -0700 (PDT)
Date: Mon, 11 Oct 2021 14:45:49 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Replace get_raz_id_reg() with
 get_raz_reg()
Message-ID: <20211011124549.z5xhyicyfoptfayy@gator>
References: <20211011105840.155815-1-alexandru.elisei@arm.com>
 <20211011105840.155815-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20211011105840.155815-4-alexandru.elisei@arm.com>
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

On Mon, Oct 11, 2021 at 11:58:40AM +0100, Alexandru Elisei wrote:
> Reading a RAZ ID register isn't different from reading any other RAZ
> register, so get rid of get_raz_id_reg() and replace it with get_raz_reg(),
> which does the same thing, but does it without going through two layers of
> indirection.
> 
> No functional change.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
