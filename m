Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18073C2BC11
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 09:16:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7111D2087C
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 09:16:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hxpb2Uk3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7111D2087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F19964B368;
	Fri, 11 Sep 2020 05:16:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jt9VGQq6piEf; Fri, 11 Sep 2020 05:16:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B0E4B34F;
	Fri, 11 Sep 2020 05:16:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12BD24B31B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 04:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rW6xZimUBzVb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 04:58:46 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA24F4B314
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 04:58:45 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id j34so6172439pgi.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 01:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=c8nz9oNcqS43/JX3gIjCU/zwWUctvs6c1e4wLHvLc2Y=;
 b=Hxpb2Uk3qvJAd3R0XfksSYNI8kdRCaccIUM/VdyS2lkhsMLXtOLRME8qLbuhPRhV7y
 roW/F/u6PTATgscybfZNaRVTOG7YlC66Fa2gylGkaElmNTELAQA87zHgP5W9HZmKY4kG
 sia/LM9pLookkv7sYkraeIi7fFQ31KlFVIrzmLg16dlNSOTcCroYiyskRO/yjHZnbv7R
 z29Bg+AdyZGixBqgba5i6ttcQyhAXy54KqdYGJvzHFHmbQG1tVEBDx1raDCT21FKjprb
 oYqWHsZEzqTjowkA1WkprF/4s4fiLyDEWd2fPD25icFROAkqHGvBCStRHrKWg1xqH6M8
 2OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=c8nz9oNcqS43/JX3gIjCU/zwWUctvs6c1e4wLHvLc2Y=;
 b=jLVMRH/800FlpzBTT94aqwyc8L0LQaNR0R/F+5M6DgHu/SEqoJGeBoXbQ8FIy7YeyY
 RO7TOZFfLw0yowIB0iklC9eUl3xD0C/QPLTEgAQVYPalQYPTDHAUxHaYVbd8shEpR4WV
 wHwarXn2klpGghoUs7a6MDDQd6/f4E/OtGEeqN0oB8REHGDhUktd5aZ1XNXLyPpjOBei
 BlxPDRWAsZjbWI+nGyTHmKcHjAoVdjJ8lK6DxxYAbWw1B9KImKJd2y3+f4XPT9IIYdTz
 mYNbNA3c4NavjGLgq2ksOm9F6pMs/wH05TPOCD0NrSGBo5po7Xsy4e5OzoS4dM/fqPxK
 Dhdg==
X-Gm-Message-State: AOAM532+aQLelA6uTFh3Yy9IYgbtQDsGzzXSB104v34zAotxX1PD+eBL
 tuBYGWBh7KsUY2LuaNT+0R0=
X-Google-Smtp-Source: ABdhPJyoeITgOIN4JjrXohV3LFRjO6CAR/hsMueYMeKLzKIO6N7sKT5jESAJGrqk4eb/udlvx7W2CA==
X-Received: by 2002:a62:8286:0:b029:13c:1611:6588 with SMTP id
 w128-20020a6282860000b029013c16116588mr1176188pfd.5.1599814725003; 
 Fri, 11 Sep 2020 01:58:45 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id u10sm1600580pfn.122.2020.09.11.01.58.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Sep 2020 01:58:44 -0700 (PDT)
Date: Fri, 11 Sep 2020 17:58:41 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
Message-ID: <20200911085841.GB562@jagdpanzerIV.localdomain>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
 <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
X-Mailman-Approved-At: Fri, 11 Sep 2020 05:16:14 -0400
Cc: joelaf@google.com, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
 linux-kernel@vger.kernel.org, suleiman@google.com, will@kernel.org,
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

My apologies for the slow reply.

On (20/08/17 13:25), Marc Zyngier wrote:
>
> It really isn't the same thing at all. You are exposing PV spinlocks,
> while Sergey exposes preemption to vcpus.
>

Correct, we see vcpu preemption as a "fundamental" feature, with
consequences that affect scheduling, which is a core feature :)

Marc, is there anything in particular that you dislike about this RFC
patch set? Joel has some ideas, which we may discuss offline if that
works for you.

	-ss
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
