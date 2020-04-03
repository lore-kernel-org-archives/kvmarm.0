Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E11AC43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 12:57:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A9C22063A
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 12:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="v0geNIrY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A9C22063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D4E4B166;
	Fri,  3 Apr 2020 08:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G+Nkj8DvhdfJ; Fri,  3 Apr 2020 08:57:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB354B153;
	Fri,  3 Apr 2020 08:57:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D27C14B12A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 08:57:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w9kS2rHTyWLG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 08:57:34 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAA884B113
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 08:57:34 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id a25so8461362wrd.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Apr 2020 05:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=De90a92kWZhlz8/GqOLJr1o2dyhjPM0KlYRv0Pnryd8=;
 b=v0geNIrY4VMNqemSmVkdgKaGLuj11BxeFgEOQp7x7J8E5O4Ts2mvwj4katWM7F13uE
 8fqzIQnaQTrs5W2NO0Vhb6xuCwU8jxk3SwLkz5wfbCdwPte34VzxSeM535pysZxREL1d
 AScFZRbwVD/h+4xlF1wvG41/B+Yn/SZvOrWej5mtajrGlhwcjXnmGzGSew0bkSMOsIf5
 6cLDrWbwks1uPMr/xHy0n9HyOEEjYXf8aq8HcebHPBXW3qp2F97BN0kRoJm/Ridx/uUf
 Sb5mZ1o7UwuvNusa0MC4IlLryA2MmtrJfc/JlUNW9ayaly/j6IoIu7ncmBIxqf6728lN
 vjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=De90a92kWZhlz8/GqOLJr1o2dyhjPM0KlYRv0Pnryd8=;
 b=roNvKp65mifQtodHPd1tKQ77lNiGIkuaPDSxKCo6H88wVt2hJPu62or7RFrLx6Y6h5
 DCR/XzLWOHPxVe4MaIQwa9aBVdrspQqBY2FJen8uoKPJNw00Z87kZzRLyE+W8VpL3SV/
 QH/V19KdFsoISa3a2F3ab+GfYqt+ozw1/YMYtD9+lhh7TQ6ljL/ndpfvy5C8P4a4Qn9p
 fK1Z/137KkSi4fJjHZm4wJ6pwybHIutRS5KpTzunqR4bGzpdvc3nQ70lXQd8sByjo3+D
 9pZyB5acaiTPcXqlXHfpOpbt4/bpzSeDIc+y1xog71IlPijZ2ongIEvA59uroVBNdbjB
 w7/Q==
X-Gm-Message-State: AGi0PuaBXm1o0ETg22C+lk8CqjneeBjoJUUub1bPnOCKRlUtrqZcqjq4
 4W3WMLjxGrwQyUS1A10N0hBZyg==
X-Google-Smtp-Source: APiQypJmLc85SD7IKOR2B22lhDeMH0Nl0U4hNc2juYBV0N+oS3eCdXIlMRZIUSQq+/Kdj2OELmxrJQ==
X-Received: by 2002:adf:f50d:: with SMTP id q13mr9155725wro.374.1585918653352; 
 Fri, 03 Apr 2020 05:57:33 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id q19sm7582976wra.38.2020.04.03.05.57.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Apr 2020 05:57:32 -0700 (PDT)
Date: Fri, 3 Apr 2020 13:57:26 +0100
From: Andrew Scull <ascull@google.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
Message-ID: <20200403125726.GA33049@google.com>
References: <20200327143941.195626-1-ascull@google.com>
 <1705907b-234c-6f56-1360-f598c8047d1d@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1705907b-234c-6f56-1360-f598c8047d1d@arm.com>
Cc: "qwandor@google.com" <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, "wedsonaf@google.com" <wedsonaf@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

On Fri, Mar 27, 2020 at 02:59:47PM +0000, Steven Price wrote:
> I proposed something similar a while ago[1], but Marc was concerned about
> the microarch detail[2] and hence I split the workaround into VHE/non-VHE.
> 
> That said I'm not saying this is necessarily wrong, just that we'd need some
> more information on whether the non-VHE workaround is suitable for the CPUs
> we're currently forcing VHE on.

We noticed that both the nVHE and VHE workarounds share the same
assumption that the EPDx bits are not being cached in the TLB.

`__tlb_switch_to_guest_vhe` and `__tlb_switch_to_guest_nvhe` are both
setting EPDx as part of the workaround. However, neither handles the
possibility of a speculative AT being able to make use of a cached EPD=0
value in the TLB in order to allocate bad TLB entries.

If this is correct, the microarch concern appears to have been solved
already. Otherwise, or if we are unsure, we should go ahead and add the
TLB flushes to keep this safe.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
