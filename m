Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46C1C56201
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 15:45:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BDC72224A
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 15:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yd+dDD5s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BDC72224A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065714B30D;
	Thu, 19 Nov 2020 10:45:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9X7R6Omfaoc8; Thu, 19 Nov 2020 10:45:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0C14B31F;
	Thu, 19 Nov 2020 10:45:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 962144B30E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 10:45:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWzEUx9PVxRU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 10:45:53 -0500 (EST)
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C7344B30D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 10:45:53 -0500 (EST)
Received: by mail-ej1-f68.google.com with SMTP id oq3so8545595ejb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 07:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=45e0VgNBbvYnn00UZUV/75YCSw3FH7awq7f1yZmGnIA=;
 b=yd+dDD5sCyrZHocr/ApiPlXl8Vodq1TGFhwOHBFO8f6IhOtQwsioH35yKK7UONHdH5
 TitQsHK6lA8fYRer+u4YnGR1szOVLD1j7PQF214pS7Ce6d2fyplN4xEO63Z0fMf+eo5F
 +D7s7HaiYkc1/gXas5BwAL1r0YHLx3mzjYUBJ3VVkquNN71MOzWoSStwN2EHOedXyFIr
 Ro9F1WQY4P81qMbCgNbC/Ev/imG/WmHAd4i9hs/qUPN2WgCzFgjiXtJGT7k0K/b08nuD
 3c0yMqnN3mBXKuySRziRYw0DuO4lMXk7AGWqZHMjPIhhmOGjOj8ao0ADRhK4NexKY+xa
 jw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=45e0VgNBbvYnn00UZUV/75YCSw3FH7awq7f1yZmGnIA=;
 b=Y0FiG8rBNDD5lOERI3tYnR4fxQsCUdMo7nj7/f/p4YveVW2MS94yKVg/L3G9xrCAtp
 k1f/Ip15bIDZIIfpv0lAKgSaTFdvzjl9+5jPxtmQQd/q2Rk4mK/G9wBdnykyS7eCKiST
 r4OHWZKdQv610gwpQgplWHU8SXrvuXg9AqHcyb+sB4N54QCpCc++97GmPDWfb1cGG8DU
 j2l0QFxye5r5M88fXPnKm390HfDYgVJWoVYtda9MGilQGF1Bmil8T496wKfL+uDMyJtg
 hwH3csF9WKPEbRySFLKa5wI3K68L5ZjeJtfWqEh13XtHq+tV/XTM3AQtdLWIcjXJ0oPf
 Qr6Q==
X-Gm-Message-State: AOAM531sgh3XduIBhF8cz4s+6ozWWCLCbzacezOor8UnO2CROLYsxbVW
 zJSc/TZgauuDTol1OMZLZghBqqfEhgd7hquRr2iUuQ==
X-Google-Smtp-Source: ABdhPJwerYJJayn5lWpV2YdXL6eFXH1urcMvWimgMV3daCqtLlvmtu4pEM2RJAtpVko5A8pZi6+uXKrICI4dBfpc4FU=
X-Received: by 2002:a17:906:6896:: with SMTP id
 n22mr30365553ejr.56.1605800751989; 
 Thu, 19 Nov 2020 07:45:51 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
In-Reply-To: <20201119153901.53705-1-steven.price@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 19 Nov 2020 15:45:40 +0000
Message-ID: <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 19 Nov 2020 at 15:39, Steven Price <steven.price@arm.com> wrote:
> This series adds support for Arm's Memory Tagging Extension (MTE) to
> KVM, allowing KVM guests to make use of it. This builds on the existing
> user space support already in v5.10-rc1, see [1] for an overview.

> The change to require the VMM to map all guest memory PROT_MTE is
> significant as it means that the VMM has to deal with the MTE tags even
> if it doesn't care about them (e.g. for virtual devices or if the VMM
> doesn't support migration). Also unfortunately because the VMM can
> change the memory layout at any time the check for PROT_MTE/VM_MTE has
> to be done very late (at the point of faulting pages into stage 2).

I'm a bit dubious about requring the VMM to map the guest memory
PROT_MTE unless somebody's done at least a sketch of the design
for how this would work on the QEMU side. Currently QEMU just
assumes the guest memory is guest memory and it can access it
without special precautions...

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
