Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D115AC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Dec 2021 16:33:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B9640BDB;
	Thu, 23 Dec 2021 11:33:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YjNyRBn9AOQN; Thu, 23 Dec 2021 11:33:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E407040D26;
	Thu, 23 Dec 2021 11:33:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE51540D01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 11:33:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j0XHc-0irdHP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Dec 2021 11:33:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 832BD40BDB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 11:33:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640277181;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=0L0+tsspM3Sr4bIkDveJ5wOCn0r+niWRUrhQ1sw4e1M=;
 b=E6mZ+LRGjCSnSn58v/b4l+BEFARQMj7wqflKdYAj0OUeVZnpgGH8ZoUE+a+ngZHIYuQUnV
 h6ffIcFLQrR0QMghHZwXlR25ejEjBX3xwaQVwo4nefWPQchWZkjWI14AWPMpb1osXskND8
 +Thsg/CC9/uvMDDihkcArsQHuEbCCKQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-5SYJoLAWOpuP03_WlnrnHw-1; Thu, 23 Dec 2021 11:33:00 -0500
X-MC-Unique: 5SYJoLAWOpuP03_WlnrnHw-1
Received: by mail-ed1-f72.google.com with SMTP id
 dz8-20020a0564021d4800b003f897935eb3so4889490edb.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 08:32:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0L0+tsspM3Sr4bIkDveJ5wOCn0r+niWRUrhQ1sw4e1M=;
 b=kTjoFrdiuCa9imQ/HI7iYkd4Gzzt4eVCKOm4AWSO/7LrdESmIgls9ja0JFMK+rqX8x
 buPQPw5X/MxUf554HTXQsrjYVXbGn4huhl8Bm8ApuGdi1kh/NbyywgrFbX8S47GYpWfU
 Ih9/0EdSjSqM2CMXeqJB/MsqLwoJqLtEekESVH/kJBZGieveW3Rb1YhURI3q5lEBK9nn
 0gM5OM63waLe8fSvmqNUjFP50ebY/moDxMv7ncfYva1Y7Tp1mbP5snLTKRkrgvAq+ubP
 UEGJT07emKyyCMKRgED04CKLo3EskKxEhosVgYsr41h7yuSO+VXG7YrMCkdmw5ySUI7M
 GXUQ==
X-Gm-Message-State: AOAM533EfkG8SI7qFEvDlSLbR9JfaH86QLzlysAFiVLzsBAwVqzAAme5
 ntp2f6PJRDfc29pSp7C6T5HLDVEdUrbSTf3gIr91COrtboS9cV9eGfgEopfcuQhuPdIJdgsxTgT
 7kaUznEUFJI5DinHi68F1EWF6
X-Received: by 2002:a17:906:794c:: with SMTP id
 l12mr2664826ejo.300.1640277177610; 
 Thu, 23 Dec 2021 08:32:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykALJDGO3IeZ2oWghmdAmCC8/3tAVh7kAZddXvgesDgLY3AvQZPm7lC8xcpGxYNve1X+MJEA==
X-Received: by 2002:a17:906:794c:: with SMTP id
 l12mr2664815ejo.300.1640277177399; 
 Thu, 23 Dec 2021 08:32:57 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id u21sm2164756eds.8.2021.12.23.08.32.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Dec 2021 08:32:57 -0800 (PST)
Date: Thu, 23 Dec 2021 17:32:55 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5/5] KVM: selftests: arm64: Add support for
 VM_MODE_P36V48_{4K,64K}
Message-ID: <20211223163255.vzjvlwkicsvgzfbx@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-6-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211216123135.754114-6-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Dec 16, 2021 at 12:31:35PM +0000, Marc Zyngier wrote:
> Some of the arm64 systems out there have an IPA space that is
> positively tiny. Nonetheless, they make great KVM hosts.
> 
> Add support for 36bit IPA support with 4kB pages, which makes
> some of the fruity machines happy. Whilst we're at it, add support
> for 64kB pages as well, though these boxes have no support for it.
> 
> 16kB is left as a exercise for the eager reviewer.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 8 ++++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c       | 4 ++++
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 6 ++++++
>  4 files changed, 20 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
