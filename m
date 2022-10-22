Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C85C04A95
	for <kvmarm@archiver.kernel.org>; Sat, 22 Oct 2022 07:33:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3763A4B0AC;
	Sat, 22 Oct 2022 03:33:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IwbVuo9R44cQ; Sat, 22 Oct 2022 03:33:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFC154B372;
	Sat, 22 Oct 2022 03:33:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF7B4B372
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Oct 2022 03:33:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CyhbRZr+4czA for <kvmarm@lists.cs.columbia.edu>;
 Sat, 22 Oct 2022 03:33:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C269B4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Oct 2022 03:33:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666424033;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eQot4DamRtIVvtNXrDIRa8lRq5oa24j9DE2lulJ2uFI=;
 b=RdWg+9QuELbf9wsYlcgHsN3adTlnewUzl0JvRY8HhTwRUKAt9hH3HbjEc8Ymhq4c7LWU1M
 59/2UNQbryi+4DuFMYHX4Qg1GdCbOAOburG5EJaj73HdCE8tZNKaefQDQgS11ffMQzR1xI
 sDYYs9CAQW7J8ik8cP1VKs6myROUDVU=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-5_17ayyqM6yl1AamaX3uyQ-1; Sat, 22 Oct 2022 03:33:52 -0400
X-MC-Unique: 5_17ayyqM6yl1AamaX3uyQ-1
Received: by mail-ua1-f71.google.com with SMTP id
 z44-20020a9f372f000000b00390af225beaso2945189uad.12
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Oct 2022 00:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=eQot4DamRtIVvtNXrDIRa8lRq5oa24j9DE2lulJ2uFI=;
 b=0qO1yesENoFY4UT8qOU9+n21Q/veHFpfgxWbFrgD6jM6PrGYV3lbvKQA6L3PJ2zYvF
 Zwqg6nD8VoWsM8EFTmhrigA/CrGdMd2ehwMOGQdRU8rK07Xrar73lj3z+uYksZ4+AyC7
 YRFaC8O/mf7jjhx5HtzM48eBNvE9EutFKaiq5h1HhgLdhPJWlWQdi4PMHoeEPT/Zpi/e
 4XwpQr1Oqk38q2VQjkLDfzxpjEqzj8J8XdK+jzaoYg0hOMuRAXbZQi61DAXVVnVG6CyV
 V9TWU65MP20vqhIsgnCuoX7Yc+Dbd4Tsty5Mt4B9N9v8SpkjEdeMauJc7olFmbs5Zo8l
 zH9Q==
X-Gm-Message-State: ACrzQf0Blk6Mb4QMcDgIoP1L5xyt/e7dw0rrHvvjhwgholouOrILsVzG
 slIUlpLiMF7iWvSQpjt9cX936bkIsYQsNNEPBIEe/JqhfKshtGFO2gdk7IBBeDXsvWMVXwnSCzh
 7cnO1lICXs/CYEPHYbH3JJzk2cLUKLoY426vaNjKR
X-Received: by 2002:a05:6122:1809:b0:3ae:d68e:92b8 with SMTP id
 ay9-20020a056122180900b003aed68e92b8mr14353343vkb.10.1666424031905; 
 Sat, 22 Oct 2022 00:33:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5XJ6Px8OxHtSAMMDOSIaZ7WomWjAkS8tov7b+lxHhzJeJhpDcwPk1Rbhq4f/pfEg9kswJ6CRijofNfOryUOu0=
X-Received: by 2002:a05:6122:1809:b0:3ae:d68e:92b8 with SMTP id
 ay9-20020a056122180900b003aed68e92b8mr14353325vkb.10.1666424031644; Sat, 22
 Oct 2022 00:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221020100125.3670769-1-maz@kernel.org>
In-Reply-To: <20221020100125.3670769-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 22 Oct 2022 09:33:40 +0200
Message-ID: <CABgObfYexXFT507Ufz3o2SLOAVDWO1AhJV5yKi9Ar1OeLNnPSQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.1, take #2
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Denis Nikitin <denik@chromium.org>, kvm@vger.kernel.org,
 Eric Ren <renzhengeek@gmail.com>, kvmarm@lists.linux.dev,
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

On Thu, Oct 20, 2022 at 12:02 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's a couple of additional fixes for 6.1. The ITS one is pretty
> annoying as it prevents a VM from being restored if it has a
> convoluted device topology. Definitely a stable candidate.
>
> Note that I can't see that you have pulled the first set of fixes
> which I sent last week[1]. In order to avoid any problem, the current
> pull-request is a suffix of the previous one. But you may want to pull
> them individually in order to preserve the tag descriptions.

Yes, that's why I did. Pulled now, thanks.

Paolo

>
> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/r/20221013132830.1304947-1-maz@kernel.org
>
> The following changes since commit 05c2224d4b049406b0545a10be05280ff4b8ba0a:
>
>   KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test (2022-10-13 11:46:51 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-2
>
> for you to fetch changes up to c000a2607145d28b06c697f968491372ea56c23a:
>
>   KVM: arm64: vgic: Fix exit condition in scan_its_table() (2022-10-15 12:10:54 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.1, take #2
>
> - Fix a bug preventing restoring an ITS containing mappings
>   for very large and very sparse device topology
>
> - Work around a relocation handling error when compiling
>   the nVHE object with profile optimisation
>
> ----------------------------------------------------------------
> Denis Nikitin (1):
>       KVM: arm64: nvhe: Fix build with profile optimization
>
> Eric Ren (1):
>       KVM: arm64: vgic: Fix exit condition in scan_its_table()
>
>  arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
>  arch/arm64/kvm/vgic/vgic-its.c   | 5 ++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
