Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEE0C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 14:40:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2DBD60D07
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 14:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E2DBD60D07
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863B949FE6;
	Mon, 16 Aug 2021 10:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rT65qGtJj1Sn; Mon, 16 Aug 2021 10:40:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 934B34A500;
	Mon, 16 Aug 2021 10:40:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E72534A1A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 10:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SLKKqBXv2b4b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Aug 2021 10:40:52 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB14449FE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 10:40:51 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 108-20020a9d01750000b029050e5cc11ae3so21199664otu.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 07:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jpoj5iCTMpBtuveund1Jovu3PUExq8PlBdpO9R73f80=;
 b=YVYuCy9LxytZmlRmWxD/FobguJ0iwY+LPvBBS+sVoR605xB721guWfr3Y7SwfZgPKe
 em4hMCJu9FaulSQ9YuFrSe6QYIsAD9W6r+2HPkwcHAJwzyd1fqfqx5n+Y9N2mdJTHTPo
 GLZq5z6NMPAaktOqhSYPvaGJ4EoXMY7Hwx4F55zuDij0a2t9VEOPKv1IJAvNdyihn0gT
 u+bxgpI2GzlUSUz1wYPsfQfEynXGAo+pfm8vBV6lTnaki8tEHapEXf9zjoNHHDWa4hks
 1SprL91FYtafVyyRDoiOI+L266dPSQLBEVe5xJPa53od8G/OYO/z2558IRRjN+xSxdqq
 +B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jpoj5iCTMpBtuveund1Jovu3PUExq8PlBdpO9R73f80=;
 b=sNT1cJQ84oeaM9vCyIMzNvQH+uKtbvfljeVry3eTo8euSDjsjLyYfx0wiGR+bQ1dX9
 CKwS8rTkKpv6g0Q+tEjHQomv3AeUHjFKMLvuAMNyB4iGxn5MkiZ2XB2nsCaj2V82VoK7
 E4jlrDkDNrqKxoHAXRpdPEIyIiLTSBwY8fvJiGmjfQC9zZAyxj5J5RxrqIF6Slug8K4g
 XlXZGVHMKeVNVELNDx/UbOyUcYLmjpkX0lMKPKIQ+bHaU6WU3FH6WntDNhC+Wt/+ZFih
 6czUgYwSXn43HxrkAgQEn+rkziYeH0McpGlO4F3CfCgw/3xuxfAHW/NmRYDJiGLOfCtn
 JOSQ==
X-Gm-Message-State: AOAM5320gHH/o6I9W0u9sqrp3MScUXCf4csJ0ZlWd84CB/sDUxKGg56z
 d9TCzJm2XyfXRavMPJG8wklwNxdnPypbZAbvAb5ixA==
X-Google-Smtp-Source: ABdhPJxyKKgzhxJN7pyMLbR5MMwZdXIxe+IQZCEbPee8J8SnbX4cYeXlosNYMavu3g8MiSG0lqTaJXvU/pZhp+Zooa0=
X-Received: by 2002:a9d:309:: with SMTP id 9mr11338581otv.365.1629124851313;
 Mon, 16 Aug 2021 07:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-16-tabba@google.com>
 <20210812095938.GM5912@willie-the-truck>
In-Reply-To: <20210812095938.GM5912@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Aug 2021 16:40:15 +0200
Message-ID: <CA+EHjTz8ct68cZEHU_x_oTNGJw=sffy9HcgQiNPVbwFy5M7dGA@mail.gmail.com>
Subject: Re: [PATCH v3 15/15] KVM: arm64: Restrict protected VM capabilities
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Aug 12, 2021 at 11:59 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:46PM +0100, Fuad Tabba wrote:
> > Restrict protected VM capabilities based on the
> > fixed-configuration for protected VMs.
> >
> > No functional change intended in current KVM-supported modes
> > (nVHE, VHE).
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_fixed_config.h | 10 ++++
> >  arch/arm64/kvm/arm.c                      | 63 ++++++++++++++++++++++-
> >  arch/arm64/kvm/pkvm.c                     | 30 +++++++++++
> >  3 files changed, 102 insertions(+), 1 deletion(-)
>
> This patch looks good to me, but I'd be inclined to add this to the user-ABI
> series given that it's really all user-facing and, without a functional
> kvm_vm_is_protected(), isn't serving much purpose.

Sure.
/fuad

> Cheers,
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
