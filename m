Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AADC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 07:55:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAB1E2072D
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 07:55:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHlkQh/6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAB1E2072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BCA94BF36;
	Mon, 17 Aug 2020 03:55:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EHhnrXC+20cf; Mon, 17 Aug 2020 03:55:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23A1A4BF34;
	Mon, 17 Aug 2020 03:55:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D0B94BC02
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2020 22:03:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wopY1ZqCwvKV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 16 Aug 2020 22:03:13 -0400 (EDT)
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BE354BC01
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2020 22:03:13 -0400 (EDT)
Received: by mail-pg1-f196.google.com with SMTP id j21so7361932pgi.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2020 19:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=g5HDuGeUVDk8sqM9/o9Q4NUmETeOwP25OuVRGMdbePY=;
 b=UHlkQh/6diYYltxpDHOf9F6jhol14EbQYUrpGuhjvkcO8jon5uiJ4TImBdetaDSwv2
 XEawf1DrPtHMEfmKHTXnLkZFvqmqbO8rYrd37X3aiOk8vBrEoWL+G94nVoT5aJsXmQsm
 Go9KlFt4aN3b9hWucnpcRpB/NQcLN+vX0Rd/Kk2MiJ036vl7dnnQ5XeO7DpTKnnqG2qU
 dsifEdi4HLaQk8lmm5b++5gcyTKSwaKiXkqPnyUKhJs4NEYLhAzQCN8n84QpQZDV3p/u
 7wtsBbqByBqeEXfd32Q33LqFtpwduLcrA857QLGv4wcraYoxWiGFxmK/u0O2z5OTkvzn
 d95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=g5HDuGeUVDk8sqM9/o9Q4NUmETeOwP25OuVRGMdbePY=;
 b=uTFSlvUJ1dn92WuIiNngF5mRH7U7wWgpUX9kIp/N/nex227/g15bd9EJcIsuYOzcFd
 QvxDjZF57Z+BL4TS58sSncYKMdIKgBid0ng35jo1Rxv4vXS0pf45BKqYw8e5sTqXmlhF
 dTwImogmcatl0/OLeso7xmYU1L1aWimdAPz7BeLqITp+4CtFry5LxREc7LuO0fxD+7kT
 iM/BnAD9e/c970dxAVf3WA87NdbtNw8KNsegtmMYZxZiP9NxQJ2xRBkEF57tjjG2GpKr
 MkIwPHZhPNcbQQ5cl6Svb1Tx991VU0pnaDynkAOC+MpHAfkcFEV3h++zdhLfp19ZJ5RV
 S7RQ==
X-Gm-Message-State: AOAM533iPFpctFukm7qb5AK3qGCeN2i34qQdXB3JA19Z2+CWXe8QuYpZ
 S3RJ0YFk7eZWqBJxRzG42Kk=
X-Google-Smtp-Source: ABdhPJwQc+l1piKsFZa/qTebQhuu4bbc4URcZ9WtR1gAqur0rzEPvsvBexYaTUpz1Zlk7YJhLE+qJg==
X-Received: by 2002:a62:2c0e:: with SMTP id s14mr9881030pfs.289.1597629791959; 
 Sun, 16 Aug 2020 19:03:11 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id na16sm15433091pjb.30.2020.08.16.19.03.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 16 Aug 2020 19:03:11 -0700 (PDT)
Date: Mon, 17 Aug 2020 11:03:10 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
Message-ID: <20200817020310.GA1210848@jagdpanzerIV.localdomain>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
X-Mailman-Approved-At: Mon, 17 Aug 2020 03:55:37 -0400
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On (20/07/21 13:17), Sergey Senozhatsky wrote:
> Hello,
> 
> 	RFC
> 
> 	We noticed that in a number of cases when we wake_up_process()
> on arm64 guest we end up enqueuing that task on a preempted VCPU. The culprit
> appears to be the fact that arm64 guests are not aware of VCPU preemption
> as such, so when sched picks up an idle VCPU it always assumes that VCPU
> is available:
> 
>       wake_up_process()
>        try_to_wake_up()
>         select_task_rq_fair()
>          available_idle_cpu()
>           vcpu_is_preempted()    // return false;
> 
> Which is, obviously, not the case.
> 
> This RFC patch set adds a simple vcpu_is_preempted() implementation so
> that scheduler can make better decisions when it search for the idle
> (v)CPU.

Hi,

A gentle ping.

	-ss
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
