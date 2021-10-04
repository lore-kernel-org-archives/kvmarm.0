Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2BDC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:14:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62E296128A
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 62E296128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E55FD4B27C;
	Mon,  4 Oct 2021 06:14:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vsl9k+q-KPcY; Mon,  4 Oct 2021 06:14:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7484B238;
	Mon,  4 Oct 2021 06:14:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 303AD4B238
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G+ISvyOM9aZU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:14:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6613E4B22C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:14:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633342447;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DQy3hcmEG7f8p0XG7+HQIaO0VC6GZhQxwlTyx9Ls2o8=;
 b=DcTMgRFP0aJ6s8KATFUTjUECkBE8aVOY1rdWWhX60kvLcZ8iECMkGdvPV83ePvU4cIOjbj
 z4fNQwL5lOgANoBQCM8MtVpFZVNUlpA+UhmoXA4UZ1fDLf9p+JCUF8B4qqZ3lz/3/EZCqO
 1MVQKaFHy3EGfoaqm3K3HHJr3xLO5Zc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-14j_2BRqP5yfXZuicEtS0Q-1; Mon, 04 Oct 2021 06:14:06 -0400
X-MC-Unique: 14j_2BRqP5yfXZuicEtS0Q-1
Received: by mail-wm1-f72.google.com with SMTP id
 o22-20020a1c7516000000b0030d6f9c7f5fso714424wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 03:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DQy3hcmEG7f8p0XG7+HQIaO0VC6GZhQxwlTyx9Ls2o8=;
 b=Ch/ntlTAey32Fv/0Kylv/MEpahwtc7r21SbKEHX80+Gpl7O+A2j5PRU0cLRehbVmL9
 sHxACpiipU/6Pf4PyrdLLk2koLE/Wcb/4hdFs7kulnTmljUF782Tk120OlOKMx3LEzaK
 xSqCfdnRcTeQWLdyky8pDiUywldRxIeVgF8nHRT9ywY3LN3iNRmubZeu17BOyopbS8Ro
 vm9YnUO4JR9Sbn6PJXGsBjGbXc7yEWQyYAiVDBpTsIyaPXdBtlJyTR3NsiQyMTX/5MB3
 aqVWCu12+KQbHyEU00FDNsT0ed7zJDu0URsSdPaNXr14ysk1hVkNJvKu6Dj/XUzahVS1
 O3jA==
X-Gm-Message-State: AOAM530CJ2nUiFC9f+ouREFguU2rc5OdkvmICYrJNXcmqMDCjZ84sgzr
 5iqxSO8fwo1NqhHzPwd/Cezlji7EcxtArVandezpdFgpkwgsJTQNgDTU8ivxSzjhxNXilp3Ux6J
 8nfFDEmbS2jfSxJY/zqhK6C3o
X-Received: by 2002:adf:9bc9:: with SMTP id e9mr7896349wrc.388.1633342445293; 
 Mon, 04 Oct 2021 03:14:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6xmecZPd8EJ7UEjc/MNxBc0yktAFhzsCIEptziVSR332G2Q0OLjV37vXubMNa2VB7PxiVzw==
X-Received: by 2002:adf:9bc9:: with SMTP id e9mr7896330wrc.388.1633342445124; 
 Mon, 04 Oct 2021 03:14:05 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id l21sm7802830wmg.18.2021.10.04.03.14.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 03:14:04 -0700 (PDT)
Date: Mon, 4 Oct 2021 12:14:03 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/5] hw/arm/virt: Add a control for the the highmem
 redistributors
Message-ID: <20211004101403.i65r26cc22a5ktqi@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-3-maz@kernel.org>
 <20211004094408.xfftmls7h6bbypuk@gator>
MIME-Version: 1.0
In-Reply-To: <20211004094408.xfftmls7h6bbypuk@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
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

On Mon, Oct 04, 2021 at 11:44:08AM +0200, Andrew Jones wrote:
> On Sun, Oct 03, 2021 at 05:46:02PM +0100, Marc Zyngier wrote:
...
> >  
> > -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> > +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> > +            vms->highmem_redists) ? 2 : 1;
> 
> Wouldn't it be equivalent to just use vms->highmem here?

OK, I see in the last patch that we may disable highmem_redists
but not highmem.

In that case,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
