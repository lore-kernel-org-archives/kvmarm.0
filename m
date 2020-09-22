Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6F5C4727C
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 18:08:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3DA123787
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 18:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="egbsABv+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3DA123787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D95E4B26E;
	Tue, 22 Sep 2020 14:08:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u7PjHjz1w2Iy; Tue, 22 Sep 2020 14:08:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B4D64B38D;
	Tue, 22 Sep 2020 14:08:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2474B38D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 14:08:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a1YBzhwTF5Lb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 14:08:23 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED6354B271
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 14:08:22 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id t10so18121897wrv.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 11:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=S85mHKKhhbko2ySJAQKUTdWj1TX7uz3rxKtwsx1/9tE=;
 b=egbsABv+Cx3fjNH8Y0a//3+OdnXJ+m/wZrAgdar+SqABSl5c1bOOyzaNpuvwxHAJuE
 3haNe7U7B0RlMB9uM9lp344Xtdd0QkqhPCOru0VVSaoZzbOvQ18vAWFr9p1hkCMWK8He
 7gj28UrhzDDw1IXylghe+1z7Mz/7Lb1/yBsGZYN2Zhe6swSSiwkSg3HRZTe77xrtVm4H
 9l9Z6V/BKYjC31H5ZvRjEs0Ez3XNU+XtR4JSbCYjTyaDnE8w5KO5N5QaRCM0PsIPCpv6
 m/z+f+HRgyXG2Vu14cbIHijvbu7PvK6D2WKMb7m0iA+7LCbWzaB3fesklBa4SqJZtdyG
 bXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=S85mHKKhhbko2ySJAQKUTdWj1TX7uz3rxKtwsx1/9tE=;
 b=jUAKABBLR1cykUEp2ScXYecZnwFcmiFgGYkOSVW6EjQWd+eSEtWS97BTJ18PhsNF8x
 8oceYQGPikF3Pg1CnsW67ugkJBIAyiVJ/rxaFYQfDFJ/OX10gwi6br63w0okd8B6gk1b
 nPUhfHHD99139/9KmLft/3rkSOHNPPRaKsQoP+70Iz4+V7cOYt1xJEtUeA4FQjdti2Oh
 VzYD/KR0NpzutOFiQhz30MVSloWjdA38JuXXEj/bBtKoxmoICAAIHgcA5XsopcF6JHag
 bkO3kr4M9cgoJo62H1d8HvrvtCMxSetzVd4vVpoHQqw46QNu0LdoL5nodKxj6vXGY6od
 /6HQ==
X-Gm-Message-State: AOAM531VBpU8iOr8x1op0H7PqqGU3HePC5fDmID2tJFgjA5DqyCHI9at
 nsiZgWwqcUTyJxop05noDC1Dig==
X-Google-Smtp-Source: ABdhPJzxYdJzCnmfgJwQkGcuUr41IDa7NW2BGo7rpNNeP8eDF9Limc0GeK+lSLgZCl9X6kBSEKAvfw==
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr6709773wrt.84.1600798101991; 
 Tue, 22 Sep 2020 11:08:21 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:55c2:2cdf:ff31:96a3])
 by smtp.gmail.com with ESMTPSA id p11sm5346000wma.11.2020.09.22.11.08.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Sep 2020 11:08:21 -0700 (PDT)
Date: Tue, 22 Sep 2020 19:08:20 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 09/11] kvm: arm64: Mark hyp stack pages reserved
Message-ID: <20200922180820.gmt6ryhjj7gepqiu@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-10-dbrazdil@google.com>
 <20200918120044.GC31096@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200918120044.GC31096@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Fri, Sep 18, 2020 at 01:00:44PM +0100, Will Deacon wrote:
> On Wed, Sep 16, 2020 at 06:34:37PM +0100, David Brazdil wrote:
> > In preparation for unmapping hyp pages from host stage-2, allocate/free hyp
> > stack using new helpers which automatically mark the pages reserved.
> 
> Given that this series doesn't get us that the point of having a stage-2 for
> the host, I don't see why we need this part yet.
> 
> Will

Dropped
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
