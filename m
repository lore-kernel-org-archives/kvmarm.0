Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBF4C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:04:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CB0C6108E
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7CB0C6108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA64B4B0AC;
	Wed,  1 Sep 2021 18:04:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dO6WzE1C+TVm; Wed,  1 Sep 2021 18:04:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 174394B11E;
	Wed,  1 Sep 2021 18:04:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A10FA4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:04:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9mhZkcH6LP79 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 18:04:09 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B85D4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:04:09 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id a15so1130232iot.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 15:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uAcZD9SKFW1AVCpO9fy2xcE9RkcQWlr+7iJy1aKTS5k=;
 b=IqadqVyNMf/GZSVQLByPmoGST5Yoe6VHJSXDJKjBpMmn12ALTuYElYhDRaFxgUJUnh
 Ei97BB4BG2dhB0qxmaygwLY66TG2qW8NKDzECdYdgqAl8nmRSlDYtcr3TI42eifXXsRf
 MtTeSKtV9bxupkt2+vheAfn70IzWWR3OgdmgxiY6RCP+/kIpsMylxa88a9gECQKYBM12
 QorJM/x/GLXBb/UWm+hzcrkGhoCM/gBGgmi1sB9G7jJUnEXBvG+5ngzDKj2d+aV7WZJS
 fgMm5+8NEGJTfXvzf0xCZHa9BSFI3GGL68GZkKT/EJ18Ym4XqeRflMw+VXgeQEZmaJFk
 VAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uAcZD9SKFW1AVCpO9fy2xcE9RkcQWlr+7iJy1aKTS5k=;
 b=njZGhCaIV6GpboTaro/EhMoQYCD4S1D4E6NuHNLesbVxsbsmSY/I/sN3Y8e0e9+2JE
 18+863XTL53MKoiM1h9W7RMUsM7HUsCgk1bie0nDZTWY08f+2YwsKVb4NIoPkK3xruyp
 eUYYUgws4fDjptqyy9cl9T8O6lbgN+znFjfMQ2ccTJVlZmV17nI+OVdyJKPqrlxj/yUh
 1bwqnIMl77JSYcsMnkN6KJGUzL3BDHrLyRyssclcwsjRi8Y1dndCbDnee5RmWthUnl0j
 nn+k9h/d7nkidCWEtoC6cBciR558wiyo3xBe7TZFliXowZpf2o8aEHpmTm2H7+c6xDVm
 LM2Q==
X-Gm-Message-State: AOAM531B18q0CkQQ7AVw6Yt3QPd873zS9E4YB+h9480Nfs8u0LxW4Wq0
 oRbhkCQTrMb7XdDcdXG5s9ttpQ==
X-Google-Smtp-Source: ABdhPJwTRdJFJ6ex11gPL8dYES9aQ8TT1xcF+pPFPuvFnHsEfoKjvOB5PvAT01pIWLgFdsX/2UcxFA==
X-Received: by 2002:a5d:8d06:: with SMTP id p6mr20177ioj.7.1630533848737;
 Wed, 01 Sep 2021 15:04:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id g14sm418990ila.28.2021.09.01.15.04.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 15:04:08 -0700 (PDT)
Date: Wed, 1 Sep 2021 22:04:04 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 00/12] KVM: arm64: selftests: Introduce arch_timer
 selftest
Message-ID: <YS/41Mj4KES1VMrm@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 01, 2021 at 09:14:00PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-11). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> Patch-12 adds an option to randomly migrate the vCPUs to different
> physical CPUs across the system. The bug for the fix provided by
> Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
> pending state on deactivation") was discovered using arch_timer
> test with vCPU migrations.
> 
> Since the test heavily depends on interrupts, patch-10 adds a host
> library to setup ARM Generic Interrupt Controller v3 (GICv3). This
> includes creating a vGIC device, setting up distributor and
> redistributor attributes, and mapping the guest physical addresses.
> Symmetrical to this, patch-9 adds a guest library to talk to the vGIC,
> which includes initializing the controller, enabling/disabling the
> interrupts, and so on.
> 
> Furthermore, additional processor utilities such as accessing the MMIO
> (via readl/writel), read/write to assembler unsupported registers,
> basic delay generation, enable/disable local IRQs, and so on, are also
> introduced that the test/GICv3 takes advantage of (patches 1 through 8).
> 
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
> 
> Regards,
> Raghavendra

For later submissions, can you include a lore.kernel.org link to your
older revisions of the series? NBD now, its easy to find in my inbox but
just for future reference.

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
