Return-Path: <SRS0=/ewP=63=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC3FC2D0FA
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 10:48:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B94F20675
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 10:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="R75BSXoo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B94F20675
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8503A4B274;
	Wed, 13 May 2020 06:48:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s3SY7lZLwqcI; Wed, 13 May 2020 06:48:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F1624B26C;
	Wed, 13 May 2020 06:48:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 371E84B227
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 06:48:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OVMTILN+qO0k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2020 06:48:54 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F07B4B242
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 06:48:54 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id y24so27969236wma.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 03:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:date:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=DkTu8Boy9+QFrN/nz9Dlp+esnFEQSCB9OlQtV2ZrE7g=;
 b=R75BSXoo/V9oojjqwA3xBMD3P4vlpXd3u9G2gA7d4K574Evnf5YbrWWh+MGgJzlRmY
 v1SYw72qo/2orD01DCCs6OJmX8zpu4Uj6M9TykGeeBcBBUXlh2oBFAV6WlVzt2ddERvJ
 0oE88kPY+xs/eeYEO50EPToSNjn+iue4TmSdkGMZbnorC6LpOR0aKfaLHLFbI9zn7kuP
 jFTLhAF4AdrzPshcFYHolAqw0VaLGa/ZZ9ozjDPA9+YBafjJWAKOH1XyjRMzS4HtINQY
 PSM5KlyRMM1H6oC2eewNV3faKxvpmbWqilenWE9pZ0cWG/Vzk8PzbEvUCt7ukN3wzUub
 tu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DkTu8Boy9+QFrN/nz9Dlp+esnFEQSCB9OlQtV2ZrE7g=;
 b=Abo0vyKVHxNFFdw2IFeIfxUSTcHo2tvsYjcFXkXe/hlEeo5D8ol73KP8GjwqiyApxr
 3n3Tyba3t/8J+/JeHwAL7ux9nihp2xH8QUdJFcFVQfqOCtQr7I0xyV1p5ZqUszeSIC4V
 b6Sa4YsZeq6p5rO9X9Qu7kJ4w3pjFRbPBo71gMSyWnXaIUf0VR1X5Kk10pwbXHjKHtQC
 Fq9HzJ568M/WDYkcSv1OeKktlQgv3t0B4xraSxwgLZoAfDodMOpbjCw3HWcwG7i2K9w2
 pXjKMHJbfZ4CDRMqjmgQ1ag5N3fuuFswH3xQ4t/8ESr3lQAfsyf7eIPb6/PT77x+fQM6
 TFrg==
X-Gm-Message-State: AGi0PuaukrWmvuWcciiNnaPhP3SY+RZQWmLulDDauuLHtno5o0Fb5VdU
 U4HqeIBA9WHidF+O81YhrpaY8w==
X-Google-Smtp-Source: APiQypI/miEqKd1bRU5KlIz6q+mV3Wo21I4z4di7LSyrHxy1dzFnHEBiY8isceJjKhRMQ+TuIif8YA==
X-Received: by 2002:a1c:790e:: with SMTP id l14mr41466821wme.174.1589366932710; 
 Wed, 13 May 2020 03:48:52 -0700 (PDT)
Received: from dbrazdil-macbookpro.roam.corp.google.com
 ([2a01:4b00:8523:2d03:e021:170a:2079:28ea])
 by smtp.gmail.com with ESMTPSA id p4sm15896164wrq.31.2020.05.13.03.48.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 May 2020 03:48:51 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
X-Google-Original-From: David Brazdil
 <dbrazdil@dbrazdil-macbookpro.roam.corp.google.com>
Date: Wed, 13 May 2020 11:48:50 +0100
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/15] arm64: kvm: Formalize host-hyp hypcall ABI
Message-ID: <20200513104850.6rer4ued2uq6lpxs@dbrazdil-macbookpro.roam.corp.google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
 <20200430144831.59194-3-dbrazdil@google.com>
 <87d07fj3g9.wl-maz@kernel.org> <20200507133320.GA16899@google.com>
 <871rns14dl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871rns14dl.wl-maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

> > In fact David already has a nice patch that transforms the whole thing
> > in a jump table, which is much nicer. I'll let him share the details
> > :)
> 
> Ah! Looking forward to reviewing it then!

It's not actually that different. It still has the same header file, just uses
the macros to generate a jump table rather than an array of function pointers.
The main advantage being that we can avoid .hyp.text dependency on
physvirt_offset. Feel free to have a look, branch 'topic/el2-obj-wip' at:
	https://android-kvm.googlesource.com/linux

Perhaps this is not worth the trouble. We do hope to get to a point where the
ABI between .text and .hyp.text is formalized, but in my mind that ABI is
unlikely to be using this same hypcall path.

On the other hand, I've played with preserving the function-pointer interface
in the last couple of days and later in this series we do end up having to
declare all of the hcall entry points (which now have two ELF symbols), so we
end up with a similar table regardless, just with no IDs assigned.

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
