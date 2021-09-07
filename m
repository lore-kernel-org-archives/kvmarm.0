Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447DCC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:52:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA85C610C9
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:52:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AA85C610C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EA04B24D;
	Tue,  7 Sep 2021 08:52:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NWa1VbzWEe9s; Tue,  7 Sep 2021 08:52:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B24D4B1FC;
	Tue,  7 Sep 2021 08:52:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E15E64B1B0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:52:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tdf609a1gcd2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 08:52:04 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEAE84B19D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:52:03 -0400 (EDT)
Received: by mail-wm1-f50.google.com with SMTP id
 k5-20020a05600c1c8500b002f76c42214bso1739884wms.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 05:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wovuk/YJ4ZzxTgEM/WTOLuXvX25Yjntehj+QQBKkeck=;
 b=K76J8SyL+1jOA8UfApaeCDLxztO+LZ8h4Nx9PbBNYsr+paYOiEqK9OIn2ldFs+7jzC
 YEttCcgHMvN3u1/0AVrT+pgr4UyIN1fY0TWDjPrCpijQjVadGHS6qCJxNRMRydMpbkpe
 vklWQApsPXT85SJjEbrr4whDc3f1MVpzfNFQ7ks6sAhOJgokRCkk4axYWPqo9Gq8UOEF
 jTjR2dGFy5N5XLZ6yElzSZACsjQFOUeQqAW9Htb6vbipQslVAql4L3mbDnFLy8aIY//W
 PjA+HrI7kjxQ45KDdftoS1ecm4AaCZ37azSPgx8Nz0Y44zMdL0lD1CCofVVAd3cPXEKz
 fYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wovuk/YJ4ZzxTgEM/WTOLuXvX25Yjntehj+QQBKkeck=;
 b=fUspkS3FlwST2JTT7oY5zYT6Coj7w6X1JO6zIfPyN21SQ8mVAGqwNHgCnqYq9irsMG
 VEB1UYVHMT3FUUEEp0mk5P9VLyYW5hVkcD6f450MxKh9BTs3m8WgIvpU84klAhOQkrNP
 cG8eke08Y7LmuO3FKGkZfSPKOZkxxyBdoi1GBHTkeZyK+UI7d3Wlg4vMhpWkke43hKQH
 ZIlaTct89OyE9z3Qs6CLX9mroCqYOyil1tQ9nSyDGcwPnDU8Ui0rbsFFYJ5+rHJDkF3L
 7CXeL9NV5t4k2QOIO1zz9622QwhNLbiJK6LUD4OxQWUISNVvceFQz1fpbk1bGhpoBvM8
 pzHA==
X-Gm-Message-State: AOAM530VBZjeIJyPCZVtYfLCB/I9uQY3YesaI3eOH3zBaDdELkXHc+IA
 FFg3AtQ5mKFjaTX0KWBjgdGexS/0x56uRUhzUMB8YQ==
X-Google-Smtp-Source: ABdhPJzN1k5vdacf8pXMz+PcUOlliO8oElhlm9+Wxx2tO4deEucQ0q5nA8yws4gRRyTPG0HwiEfKkeMxeGbJ78NSUUM=
X-Received: by 2002:a05:600c:4fcd:: with SMTP id
 o13mr3850083wmq.32.1631019122955; 
 Tue, 07 Sep 2021 05:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-4-maz@kernel.org>
In-Reply-To: <20210822144441.1290891-4-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 7 Sep 2021 13:51:13 +0100
Message-ID: <CAFEAcA_J5W6kaaZ-oYtcRcQ5=z5nFv6bOVVu5n_ad0N8-NGzpg@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs/system/arm/virt: Fix documentation for the
 'highmem' option
To: Marc Zyngier <maz@kernel.org>
Cc: kvm-devel <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>
> The documentation for the 'highmem' option indicates that it controls
> the placement of both devices and RAM. The actual behaviour of QEMU
> seems to be that RAM is allowed to go beyond the 4GiB limit, and
> that only devices are constraint by this option.
>
> Align the documentation with the actual behaviour.

I think it would be better to align the behaviour with the documentation.

The intent of 'highmem' is to allow a configuration for use with guests
that can't address more than 32 bits (originally, 32-bit guests without
LPAE support compiled in). It seems like a bug that we allow the user
to specify more RAM than will fit into that 32-bit range. We should
instead make QEMU exit with an error if the user tries to specify
both highmem=off and a memory size that's too big to fit.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
