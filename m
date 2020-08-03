Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC95C433DF
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 17:13:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38FA920A8B
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 17:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="A2LguaTJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38FA920A8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4FA4B599;
	Mon,  3 Aug 2020 13:13:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5BSzhA3gQDsV; Mon,  3 Aug 2020 13:13:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B80B4B59B;
	Mon,  3 Aug 2020 13:13:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38D2D4B598
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 13:13:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-BZEGp0B0KG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 13:13:04 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F9254B592
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 13:13:04 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id k20so289277wmi.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2020 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2RPI3rXXGTTh10EN+l9aE7UZRFL4g67sVtHQJK7hRGE=;
 b=A2LguaTJ3xgcSiwKcayFiBAx6WeljSGOc5DWwg/Xqbf3NiCnBA9WqnB2F3XfRXZt7x
 QoI31Z37Xbuwt3Wzmn+78QEpnJrhva5GWieGI5X0YG3k27FRSN9p3fHIWy9B9neAckHW
 jnUL3eDmKmui9vY5YMlKXg+FXR7E3fkHH/If9GEFKWQ2+wfaiP6q7d7GVsKncNkx8i2Q
 pvIJ0VJfl6QLV/C9isUndIDbR08Ea97t8k9ItPZuHXBhki2jkxyeuApVY3YMehL1xE7d
 2VktoDrBt0siG8+IYna2lZSAtRj0B0pHHImPcCoygAHe6VxGNv0xu7MuT8WtVdMBtvZ6
 C+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2RPI3rXXGTTh10EN+l9aE7UZRFL4g67sVtHQJK7hRGE=;
 b=axVX1bdBNCVa/UvYCoSwc38+5R7uStkKe3xEJUNebFpDEuBz1F4dibLx32UqToWIYq
 EVAkQNw0i985i3MqaYQV75sX5ZVoe7hzW1OLf9QuOV2Km+qoUBbQvHJ4IXKMMvmQLICM
 DoFs7xJc7ZMI9MEq6ras/xR5Z06XIgS8e6LEe3nAS75e1uROM0MM0aBKS4UaF6ZkTr5n
 SNQlCFHgkz3GyzQgFeZEm98yivpZe2rt49SRCYPI9RkBULt3EYN7o+79JwatszjTQ917
 ZVt5uD9guA0QSjJ8aBwJ3cdYz1YICnHb8uG0mTtFAQyhEPGllgzNR/rPpHGJqcMTP9Uh
 N3vw==
X-Gm-Message-State: AOAM531i5asVThRSHSPmB7m1aX8o1dp7VZLtRpfTqCi1GTJepixss/Q6
 8XKjmP3e5+Qoh8RJ2JMUcG9cbQ==
X-Google-Smtp-Source: ABdhPJyxlm/N/A9mtl857SUYnyz2UymhHW/c/jaKdmar2/4Tj8uKRawpksUkllRhOsvjBXK30MrSYg==
X-Received: by 2002:a1c:720e:: with SMTP id n14mr227341wmc.152.1596474781657; 
 Mon, 03 Aug 2020 10:13:01 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id 33sm28160784wri.16.2020.08.03.10.13.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 Aug 2020 10:13:01 -0700 (PDT)
Date: Mon, 3 Aug 2020 18:12:58 +0100
From: Quentin Perret <qperret@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 00/20] KVM: arm64: Rewrite page-table code and fault
 handling
Message-ID: <20200803171258.GA2728028@google.com>
References: <20200730153406.25136-1-will@kernel.org>
 <20200803081756.6y2plzh3p7uzjljo@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200803081756.6y2plzh3p7uzjljo@kamzik.brq.redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
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

Hi Andrew,

On Monday 03 Aug 2020 at 10:17:56 (+0200), Andrew Jones wrote:
> On Thu, Jul 30, 2020 at 04:33:46PM +0100, Will Deacon wrote:
> > In terms of testing, I've done the usual Debian installer type things, but
> > Quentin has also written targetted guest code [1] which we used to
> > exercise dirty logging page-table collapse and coalescing.
> ...
> > [1] https://android-kvm.googlesource.com/misc/+/refs/heads/qperret/pgtable-test
> 
> Hi Quentin,
> 
> Any reason you didn't look into extending
> 
>  tools/testing/selftests/kvm/dirty_log_test
> 
> and, if necessary, the AArch64 KVM selftests framework?

I did run this particular test, but it didn't seem to exercise the code
paths I wanted at the time, so I went with a custom-made implementation
only to get this patch series out of the door as quickly as possible.

But I have no plan to maintain / push this further, and we should
definitely be looking at extending the selftest instead to cover this
use-case. I'll try to get to it at some point but there are a few things
I need to finish off first :)

I hope that helps!

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
