Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277BBC352A2
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:24:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9D0021927
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LoDSgMsd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9D0021927
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3944D4A49C;
	Thu,  6 Feb 2020 16:24:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EjMw5+Dcq5Rg; Thu,  6 Feb 2020 16:24:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3365A4A4A4;
	Thu,  6 Feb 2020 16:24:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD334A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:24:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KZltVwVnGbu2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 16:24:38 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FC1A4A389
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:24:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581024278;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3Y2UsX0iGKeSydEQeVi48EFJ1DRsKZGjPTwGNyfBBJI=;
 b=LoDSgMsdjWekXMYKaZ0VFsqrv5p0UVY7meKCLKHphZmxM/rhrVd7Lkbsrm5hKhgrvpMcxI
 udvtZ6ph/IPR87fHvG6oD1+EX02vmOGtw0SvNNYaNyfUFSkHZ8osL06fKzoxS1izGxhr2L
 oxurl2EKuezhKH30i4vHRzkL509yn04=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-XOoeUkkIPROZknUITrZu4Q-1; Thu, 06 Feb 2020 16:24:35 -0500
Received: by mail-qt1-f199.google.com with SMTP id c10so126423qtk.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 13:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mpppjCJmC0FyN5SMr7bSEAaCj98EBVmwQP8+IcdCU94=;
 b=INu+U7xPxUXiXyraGToG519yy1KyANsfg0DLBk4OPuz1T7d3AoYpVcyL1yg6p9fZb7
 93rFRYlF2yFx9qfZKnk1sXGj0XJxw6j/fuEJLmpwaT4dKYIra/eL6rF23UCme9JmclW4
 MIhOsTgT49Cz1btjBlWhhVLN1cBmBdnkJYFmGAKV3fOS0RA6uCo4CQtccxMD9+MGgLqN
 pDAAouLU6o8EYpG63e7XUnsLgfuAkc8PxPYRmQ10yx7+sYFRRI7G/8pBLLyylHUBeOPz
 HCgMC3m6YWpMAEKgosmD1mI8oJNJxCmFpIOvP/WGjC2ITOrq3tknh3PEcgXHmX6p47yh
 Bw2Q==
X-Gm-Message-State: APjAAAWjsDa0CtQ/ah5Tfz87RaVCj30KGi5eyEUFScK9dxcPld+bMAK9
 VJqxsU0Zeo5ZbwNLx0ZRE3ni0buKkFOsyglO9PP1Rmkz0fLp1A9GJwdPpgCM7NsfeVDcqA3c2Gx
 eQ2QijrvGfjz2xVHjiDVQypPE
X-Received: by 2002:ae9:ebd8:: with SMTP id b207mr4579989qkg.353.1581024275410; 
 Thu, 06 Feb 2020 13:24:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5VOLMiLzF1LhwmvuD3bg8z0IeFMhpmxCeKGC9RcbBKEXcR3SRyFUKynAlxMw185+NrKLCqw==
X-Received: by 2002:ae9:ebd8:: with SMTP id b207mr4579963qkg.353.1581024275206; 
 Thu, 06 Feb 2020 13:24:35 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id v78sm278695qkb.48.2020.02.06.13.24.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 13:24:34 -0800 (PST)
Date: Thu, 6 Feb 2020 16:24:31 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206212431.GF700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-16-sean.j.christopherson@intel.com>
X-MC-Unique: XOoeUkkIPROZknUITrZu4Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:

[...]

> @@ -1333,6 +1369,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	unsigned long i, n;
>  	unsigned long *dirty_bitmap;
>  	unsigned long *dirty_bitmap_buffer;
> +	bool flush;
>  
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
> @@ -1356,7 +1393,9 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
>  	    return -EINVAL;
>  
> -	*flush = false;
> +	kvm_arch_sync_dirty_log(kvm, memslot);

Do we need this even for clear dirty log?

> +
> +	flush = false;
>  	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
>  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>  		return -EFAULT;

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
