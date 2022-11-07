Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BF1C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 14:29:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 853B24B887;
	Mon,  7 Nov 2022 09:29:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dhzE8eOQ6CCq; Mon,  7 Nov 2022 09:29:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E334B895;
	Mon,  7 Nov 2022 09:29:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 279B84B887
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 09:29:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wLt3eiZUd7nQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 09:29:07 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB514B845
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 09:29:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667831346;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=humq6rQ40+uCr1dmaqj2I5gLtIPMUKzBIm5JAKLU5kM=;
 b=ZARNp8ShzSLa1oCn5ac43prUu+GVFIS92TM3+SujBt7SwR8r35uxHvONi+SHygjY/U2V52
 qA/bQ0T84dLEu7IGDTUe9QlXowgi/xH6Q+XztMz03QZXG/t+rBtF9gLniVGwLP/qfzjdMp
 F5UIqFqfLSXFNBKv/t+B2YOKWTQYZx0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-i-j7GyyPM9eAQ2R6Wb37sg-1; Mon, 07 Nov 2022 09:29:04 -0500
X-MC-Unique: i-j7GyyPM9eAQ2R6Wb37sg-1
Received: by mail-qt1-f197.google.com with SMTP id
 cd6-20020a05622a418600b003a54cb17ad9so8199877qtb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 06:29:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=humq6rQ40+uCr1dmaqj2I5gLtIPMUKzBIm5JAKLU5kM=;
 b=4B3K/4VUDaeHF77kOw1bkH7XwFZjsHTRgNjXaYitCei3Equmrikd06AA94KpYMDLpS
 eS0wb52Og9s0HcDx/yqZhGmuzk72gNJLbCiCzQuu52fc0pKwf60e6IOPkRVMmW1jck4B
 6fbmq1Wolfdna3HyDkBU3paOPDRUHM6/h9e4nqv9fYtGRpLQgWnmVdxdn4AkJ/3ysG//
 CrHF3Z1SP8QOlTF44yPALnRmZFeHUE8RydZpNxYZ/i8t2SEGST6dFJGBVqiw07OKc/7J
 BlPl2ExGJM25atwve0UiTW5UrE7WwLWNt1YpgDXQVss5ZSkuZfehVWE2uwT/hV1hfziI
 WGpQ==
X-Gm-Message-State: ACrzQf0h/pLwWXs+5T00brZzThCjhC/S5vbWIjiSpiRpTU+Oq+wJLUfZ
 7c2Lrm3gzyVurkqkgkLckNlTTVdsQe0QerStUyhOIpRzh6rwYZbLCU+kTZP/PzZEunYLGLOhnnM
 9+IwnhLjne4UgyyA/CcX5VH86
X-Received: by 2002:a05:620a:d55:b0:6f9:fadd:4762 with SMTP id
 o21-20020a05620a0d5500b006f9fadd4762mr35863876qkl.335.1667831342865; 
 Mon, 07 Nov 2022 06:29:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6QWKXb1TWdkP9qu08deog1NKsig/FMQot7OkY7UfMNUpgr2zjUhL2SrUPx+ND9wgrgFSLMDw==
X-Received: by 2002:a05:620a:d55:b0:6f9:fadd:4762 with SMTP id
 o21-20020a05620a0d5500b006f9fadd4762mr35863853qkl.335.1667831342661; 
 Mon, 07 Nov 2022 06:29:02 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 cg5-20020a05622a408500b0035cf31005e2sm6150909qtb.73.2022.11.07.06.29.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 06:29:02 -0800 (PST)
Date: Mon, 7 Nov 2022 09:29:00 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2kWLMMTho0+/BLR@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org> <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org> <Y2gh4x4MD8BJvogH@x1n>
 <35d005f3-655a-88f5-2de3-848576a26e42@redhat.com>
 <865yfrqf3j.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <865yfrqf3j.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Mon, Nov 07, 2022 at 09:38:24AM +0000, Marc Zyngier wrote:
> Peter said there is an undefined behaviour. I want to understand
> whether this is the case or not. QEMU is only one of the users of this
> stuff, as all the vendors have their own custom VMM, and they do
> things in funny ways.

It's not, as we don't special case this case in KVM_CLEAR_DIRTY_LOG.  If
that's confusing, we can drop it in the document.  Thanks.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
