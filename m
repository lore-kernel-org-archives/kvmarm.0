Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7AAC07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 15:29:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E7F361400
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 15:29:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E7F361400
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB5F4B0F3;
	Fri,  4 Jun 2021 11:29:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e6S8X1VA3sGa; Fri,  4 Jun 2021 11:29:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B3C34B105;
	Fri,  4 Jun 2021 11:29:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D454B0C4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 05:22:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A0o4Lm7HGi96 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 05:22:10 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0F114B0C1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 05:22:10 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id k15so7023963pfp.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jun 2021 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pcVIrrrWEUuSA+N6NdZCH+jzIyXyj1HQeo01ZwpdXxY=;
 b=T6vUk/4jMaY1sFB+ktO56Tu+hSYK1wiZBd79Qpkt7cR3wdk6RgqpEA+MqmoApExn4u
 Ki+XTdzY1lKdvlx+de9gaG+wdCW5+FLPTTH3w22d8er65zizi+PUDGgUHvaCEEPTouoT
 LUIBuV5Az0wlga/c+czm/LVkend9CKDw/kZwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pcVIrrrWEUuSA+N6NdZCH+jzIyXyj1HQeo01ZwpdXxY=;
 b=rl4taqg32eNmEugsgEZHQo+bM87Ywb1vT+hyrTK7zK9ckluXGpGoubhy67QammScsF
 uZ7Z0xJ3LkDVJY5iBm1bhBSyUi0GVA9D9itv5669f+3IXTzNmJHY0qjfUp01ZquzuemZ
 4OefLbZp4/yM+Vkhg1k2KD04t6HyLj7WXhrJMlCnPTwMszxZTm0jM4xfHbcBOl2Z7sg0
 RkyJJ7rO8OT/HPePMEhghJInAoDw9GOXisnSntrsyeW6MrzKAcxy9IrwPlRikIiWZJXw
 UQGbJlilmKhjuDiD8WrJWUt6uGeOw/mjq3Jx/comks93BVvIRDrt8mpIMSuoYzHlywQk
 uZMw==
X-Gm-Message-State: AOAM530u01jskx99765hMHvRjCiw4He0fy9jAP605Jja4rtlPaPkrcVH
 U6tIttweBD6zlTCkdLoIxBUwlg==
X-Google-Smtp-Source: ABdhPJyN+y7mCRzpjZlapAyCgZr6LbpUALEaLKem6t6vFwqQAQV8qZmVYl6DOYQnER784of3HxKE+Q==
X-Received: by 2002:aa7:82cb:0:b029:2e6:f397:d248 with SMTP id
 f11-20020aa782cb0000b02902e6f397d248mr3647517pfn.52.1622798529641; 
 Fri, 04 Jun 2021 02:22:09 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
 by smtp.gmail.com with ESMTPSA id d15sm4208168pjr.47.2021.06.04.02.22.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Jun 2021 02:22:09 -0700 (PDT)
Date: Fri, 4 Jun 2021 18:22:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLnwum6AtcURNlRL@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87a6o614dn.fsf@vitty.brq.redhat.com>
 <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
X-Mailman-Approved-At: Fri, 04 Jun 2021 11:29:07 -0400
Cc: linux-s390@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-kernel@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Sean Christopherson <seanjc@google.com>,
 Suleiman Souhlal <suleiman@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On (21/06/04 09:24), Paolo Bonzini wrote:
> On 04/06/21 09:21, Vitaly Kuznetsov wrote:
> > >   	preempt_notifier_inc();
> > > +	kvm_init_pm_notifier(kvm);
> > You've probably thought it through and I didn't but wouldn't it be
> > easier to have one global pm_notifier call for KVM which would go
> > through the list of VMs instead of registering/deregistering a
> > pm_notifier call for every created/destroyed VM?
> 
> That raises questions on the locking, i.e. if we can we take the kvm_lock
> safely from the notifier.

Right, I wanted to take the VM lock, rather than subsystem lock
(kvm_lock).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
