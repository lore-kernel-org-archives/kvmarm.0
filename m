Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EC9C47082
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:14:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 309F8613F1
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 309F8613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 952774B0BB;
	Thu,  3 Jun 2021 08:14:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RB+muTZW76Ot; Thu,  3 Jun 2021 08:14:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA0A4B0D4;
	Thu,  3 Jun 2021 08:14:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 631624B0C9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UKm914KDfOg5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 08:14:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BEA54B087
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:14:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622722455;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=h7KKMDASbghFb3fKVPA26WDfGRNRufLOOkWxirieT+A=;
 b=BbQXkmr4d/n7W4lC0Dzota7S6KhrUKHo0ORLBkhQXLbtcZbg+6xWYcGhCxNqmeuJu1txAi
 TEjSUc8xyWP2cN6/sPN+AZfV+h4QFNxNF5UH89ZXKRXY/wBpWB/EV+tbylx4o00vjB/TEh
 2BwsOUBCPOl01SWMDm5Du2pRw4QjctU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-GMoBIwhxMy6j7ArVjii2Eg-1; Thu, 03 Jun 2021 08:14:13 -0400
X-MC-Unique: GMoBIwhxMy6j7ArVjii2Eg-1
Received: by mail-ej1-f72.google.com with SMTP id
 f1-20020a1709064941b02903f6b5ef17bfso1846551ejt.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Jun 2021 05:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=h7KKMDASbghFb3fKVPA26WDfGRNRufLOOkWxirieT+A=;
 b=oLnxDGNfPPFuJSLQEaQNf+EKXMCo2XCM8MpIX4aZBXnLjZc1nrvfMGvQLridHcMFbz
 uSzulW7/npWUaXh0WZgjlj06RtJtvt9Hh4WasOXwDR6AP2P6IbLVvmPV24JZbLSGN1wX
 xQHstrYoy8EC5ai/FzsiQK25Ka1Pfvz6jHz9Y8VjFDCXNbqyo5hNJJ3osM1/ulDgDoQx
 +x9lJFstQEjA7lZKNVZWT8xdt6CsLVO7eK5BwyOwbwzNJL+JY8L+1LEoBm5ficvqiWhb
 1YvB2N4Vl2MTOcFFBkhe6KVakzE91+wsA3pZGJd4faS+ZhVGB+BQXMYUACbcY4QYCwwM
 M6bw==
X-Gm-Message-State: AOAM530ontBeU7oblNWTx0HXknhI9kgeyeCpsLhsDpVczl2HGu7TA6IW
 um9sYEn7sTrFWTMG8cUeCX8fPKzC2d8PXYmPP8grJb3SEAcK/5WRxWVh9s7jDw12q9xv8gpgnZB
 hpVaPUzJTM7GUZ6/Ns3ajp3AR
X-Received: by 2002:aa7:d482:: with SMTP id b2mr26697641edr.45.1622722452514; 
 Thu, 03 Jun 2021 05:14:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA1xBICRSF57oS9q23u0rz34s1KwYHZ+9+yvEbkkzn9DEAfAF8YWtLGH7UkAi5mBuPd6zbSg==
X-Received: by 2002:aa7:d482:: with SMTP id b2mr26697618edr.45.1622722452283; 
 Thu, 03 Jun 2021 05:14:12 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id dy19sm1662873edb.68.2021.06.03.05.14.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Jun 2021 05:14:09 -0700 (PDT)
Date: Thu, 3 Jun 2021 14:14:07 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 1/5] KVM: arm64: selftests: get-reg-list: Introduce
 vcpu configs
Message-ID: <20210603121407.pb7cm3t6cfjwzana@gator.home>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-2-drjones@redhat.com>
 <YLgW7BDz6zAyU+Of@google.com>
MIME-Version: 1.0
In-Reply-To: <YLgW7BDz6zAyU+Of@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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

On Wed, Jun 02, 2021 at 04:40:28PM -0700, Ricardo Koller wrote:
> On Mon, May 31, 2021 at 12:33:40PM +0200, Andrew Jones wrote:
> > We already break register lists into sublists that get selected based
> > on vcpu config. However, since we only had two configs (vregs and sve),
> > we didn't structure the code very well to manage them. Restructure it
> > now to more cleanly handle register sublists that are dependent on the
> > vcpu config.
> > 
> > This patch has no intended functional change (except for the vcpu
> > config name now being prepended to all output).
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Reviewed-by: Ricardo Koller <ricarkol@google.com>

Thanks

> I don't think it matters that much for this test, but ".capability = 0"
> is already taken:
> 
> #define KVM_CAP_IRQCHIP	  0
>

This is a good point, and I should have checked it before assuming I
could use zero for "no special capabilities". I'm tempted to leave this
as is for now though. If we ever need to consider KVM_CAP_IRQCHIP,
then we can cross that bridge later.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
