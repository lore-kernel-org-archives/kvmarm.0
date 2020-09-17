Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1426C43463
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 22:17:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E61C2087D
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 22:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HbZxUoaq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E61C2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D52D4B307;
	Thu, 17 Sep 2020 18:17:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GVGoPs+VSJ0G; Thu, 17 Sep 2020 18:17:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A62884B30E;
	Thu, 17 Sep 2020 18:17:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D2B4B306
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 18:17:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u2Hca2HBfdtp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 18:17:07 -0400 (EDT)
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
 [209.85.214.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 889934B2F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 18:17:07 -0400 (EDT)
Received: by mail-pl1-f193.google.com with SMTP id k13so1880798plk.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 15:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=15AUeIGCB8Co4ppPyHutmBPEoR96J0ZC+70DS6d6lEA=;
 b=HbZxUoaquDF7xsCL0N1nGOtEhjC6k/29ufocwCgKegfzTw+SnKB4PHA5efYOqvK5H8
 qB29ehLrJeRvDiCO8wPb8MQdU7Q2icOOK5ZQA/+5FaVUaFbhQF8nbM1rBfgWZ4QUsvuy
 i0+a0YxbWmt8uHoYV7J6SZv0i7QqbjjxftLFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=15AUeIGCB8Co4ppPyHutmBPEoR96J0ZC+70DS6d6lEA=;
 b=HMNp+5YHklcrg4LSryg0/TZUvo2bF87LjzvmFpQSDPI59Rmdb3cD+8Wx94GGeKhLAE
 ZakCKWaao+lUY85o6NyNxcshJYg6mwfuf3B7BzXqx3DsZRjpsU6hIHMYM0Muy6VjGiZh
 0OIfV683pMD01bcGduIERHXjvdYVzCJbmOgahtlTgzxmuWp6VcTwiPgqjHAD24V1vr7E
 by4B+MsZVCtnrqTxChCwthMUuRp2WhZskpoTK8af5nNTCFyFzj2RcBLdJNXrqnoai63G
 6UsHrzL7ohVxvWDu1DL2yNIL/Mf1VoJAaBV+tmni4jXF5mvOozpGvszLIB97M7orBCGb
 wkGQ==
X-Gm-Message-State: AOAM530GT/2+R5Gwjekt5pGQhbpXkrkkAdlf9Ywn05ACXnG1hv4HPWUL
 zondab8oJrYfa85iZg8dh6ejTQ==
X-Google-Smtp-Source: ABdhPJxoOnxlx8CTv3DWk2KqkOMYm+QxpzLZyBZuGVpXsjrtygCBDQZLnqcz+qPsh63Ko+YuX/aNpA==
X-Received: by 2002:a17:902:9343:b029:d1:f3e1:c190 with SMTP id
 g3-20020a1709029343b02900d1f3e1c190mr7793977plp.2.1600381026580; 
 Thu, 17 Sep 2020 15:17:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id h35sm626057pgl.31.2020.09.17.15.17.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 17 Sep 2020 15:17:05 -0700 (PDT)
Date: Thu, 17 Sep 2020 15:17:04 -0700
From: Kees Cook <keescook@chromium.org>
To: George Popescu <georgepope@google.com>
Subject: Re: [PATCH 06/14] Fix CFLAGS for UBSAN_BOUNDS on Clang
Message-ID: <202009171516.6543C7649@keescook>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-7-georgepope@google.com>
 <202009141509.CDDC8C8@keescook>
 <20200915102458.GA1650630@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200915102458.GA1650630@google.com>
Cc: tglx@linutronix.de, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maskray@google.com, maz@kernel.org,
 masahiroy@kernel.org, clang-built-linux@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, elver@google.com, arnd@arndb.de,
 linux-kbuild@vger.kernel.org, broonie@kernel.org, natechancellor@gmail.com,
 dvyukov@google.com, michal.lkml@markovi.net, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
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

On Tue, Sep 15, 2020 at 10:24:58AM +0000, George Popescu wrote:
> This would mean losing the local-bounds coverage. I tried to  test it without
> local-bounds and with a locally defined array on the stack and it works fine
> (the handler is called and the error reported). For me it feels like
> --array-bounds and --local-bounds are triggered for the same type of
> undefined_behaviours but they are handling them different.

Er, if --array-bounds still works on local arrays, what does
local-bounds actually do? >_> :P If we don't have a reduction in
coverage, yeah, I'm fine to turn that off.

-- 
Kees Cook
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
