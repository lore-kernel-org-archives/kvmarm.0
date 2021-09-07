Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A01BC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:53:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06E30604E9
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 06E30604E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C594B1B0;
	Tue,  7 Sep 2021 08:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XLW6DpYJzYMi; Tue,  7 Sep 2021 08:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A6754B20C;
	Tue,  7 Sep 2021 08:53:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD364B1E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOwAAZGbCYow for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 08:53:41 -0400 (EDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDD454B1B0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:53:40 -0400 (EDT)
Received: by mail-wr1-f47.google.com with SMTP id q26so13339129wrc.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 05:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4cDtvvJiDONxbktDTeL+URNXfqhs06YOh0Wb0vKpXuE=;
 b=gTVzdRInjX/dnmGg73hvgZhaP3j9eU6oGyZskECjKsUwR7c3DWRJE9mEnEnxleavw6
 1cn8lg6CTY985kb4nComyKckxvjXFL2WxeqpVzpe29I3msh8fQFx7BD6y6hHXpxHnVYP
 wurcE/GA+ZupuCLpbFfjp9K5p0+h4a2dk95VT8Ya28D7zV035oKH1QdeeGvQJExM2as9
 WJcvH4mcWpf0fRKBheCGBAbfzqCuJeLfy99mQLuXs5a5TXrjS81anxQFHF/+exdvxdTi
 XUxHswQ/eEzyuAPLVdWT9NGTGmeVqWSKVysXnViop5DaRa3cgdnz6M9o3BXUwKThjO5z
 p+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4cDtvvJiDONxbktDTeL+URNXfqhs06YOh0Wb0vKpXuE=;
 b=jtdYiMCTEqvvUc0WdwgIvdKK9rL3Ey358QlgZsu3X/LdWL3ZpoTC+LthWJ10PijkxN
 NmzZWP8PeFJ38Y195I99AviJU3saQqToXBj6PQooxpVXXSbfud3zrLNr7KXujL+laEKY
 7l8D/rz26V7rErrPRQy6EVkl1ZQ7xXWEK1jZcZvVfWT4UlpD9iHARthSuun4I9aMlyT+
 IAu5h0Ium7Dwp6Xn77MLdKhULBahiV7EtaXrhV56bOrsEGZFb0FHyfieh4gfjwZasVP+
 A1ugRYIyTKAeJ0Or+ybrKAq6o/ja9IMcf44AZpH3Sm1ZHYDZ/sgmXQkti+jx1LZRiMnM
 hRDg==
X-Gm-Message-State: AOAM531W48AHKMlnAKUoqaL0vE3HQA7IBoIf2E5phrO3OkeC2cy9qM9L
 emBpjjV6CRhSzQ1MVc/QcYwzGjx5SWHtB6oKzledBQ==
X-Google-Smtp-Source: ABdhPJxrLmDLa+HjRoX8Rv60uwocrI+Qc6d7xcHSWB8bchkHtGLPk+nY6fi0MnnqybP7bULCaOkzltqGHJO4o0kGo9M=
X-Received: by 2002:adf:fb91:: with SMTP id a17mr18038543wrr.376.1631019219992; 
 Tue, 07 Sep 2021 05:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org>
In-Reply-To: <20210822144441.1290891-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 7 Sep 2021 13:52:51 +0100
Message-ID: <CAFEAcA_09YHF3LhxcLVoxd=yvO5g4dUsjkwDo5bdVNFNcaOXuQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] target/arm: Reduced-IPA space and highmem=off fixes
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
> With the availability of a fruity range of arm64 systems, it becomes
> obvious that QEMU doesn't deal very well with limited IPA ranges when
> used as a front-end for KVM.
>
> This short series aims at making usable on such systems:
> - the first patch makes the creation of a scratch VM IPA-limit aware
> - the second one actually removes the highmem devices from the
> computed IPA range when highmem=off
> - the last one addresses an imprecision in the documentation for the
> highmem option
>
> This has been tested on an M1-based Mac-mini running Linux v5.14-rc6.
>
> Marc Zyngier (3):
>   hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE when creating
>     scratch VM
>   hw/arm/virt: Honor highmem setting when computing highest_gpa
>   docs/system/arm/virt: Fix documentation for the 'highmem' option

I've applied patch 1 to target-arm.next; thanks.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
