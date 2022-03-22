Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A4BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 03:30:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6E449EEF;
	Mon, 21 Mar 2022 23:30:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3SfNSLYYv47c; Mon, 21 Mar 2022 23:30:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62A7849EAA;
	Mon, 21 Mar 2022 23:30:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8483349E44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 23:30:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKWG-oUHLF5q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 23:30:55 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C7B240C10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 23:30:55 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id gb19so14637048pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 20:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vHhSiR4NEl9sHSjdl1ma5WrsausBMeT/k+B8si8EB+I=;
 b=EirvhGafGNcJ8JIzxwmt3w8wqVW7VQQCgNGmwsfNJyM5G8N8vnyIINJrANxjcZX1HU
 sxkz4TwWf2aaOud7nv7hMfVWj5QsqOBD0/QKS7Bx01STIjEpTASjIULsGMs32X6JRTN6
 7ENoD/2JMxZgitgMpawhuyOFyPG9DaZ1bOgvIqHaM1XLABtR9hLHHw64+zNXKN+d9zot
 27BOebUK+Ur+fzD42eaKjvU3Qi3/lD0sC/N1rqpY6xkd+Ei2ogb+2byLVW1R+8ilbWnw
 FUSgmLzro3VwVdExVS5FEh6vtyB47vCSU0aeUAwnCW1D+QgZNkfr06jS5o2Nr6rZUZYB
 9X7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vHhSiR4NEl9sHSjdl1ma5WrsausBMeT/k+B8si8EB+I=;
 b=jY69u7ZszYBqHM8xs/omIq6uqbCPqymouRpM8rWOiX15ORpXH7mRwsbsTAvgn7OCYz
 EVdpDl6/w1C4feWaUbLoCfeMfUS7s21/SslHriZuGb+wdetHue4UJMOBDRbv4Vq338zm
 b4edaVDyffwdSlFv6Ajd12bgOiCKVHc5wNzMdTrd+PJ+QjwT/yR3XHiIaJQZMbpt253b
 ACX0VB4tUHG930ZQP4g1XCrcNhGymjEG55qKmi+ANW/hc2g1DjvoNvZMlBhTEnSXpkg6
 zZu9KoaOkJHDTmvub+5e2S+yHOEni+4S1q/l0zVZHgS3LXkOUONOVyGfrjmOVfmXDK/4
 +6MQ==
X-Gm-Message-State: AOAM533NGPfIqEztlRN1TOVnSPua4puQ3CFP3d8Afif1SYRnhWZU+img
 doNlLes/qrgVH2xlCAnKNSfyj1TzA9mgf2Tg7C+iiA==
X-Google-Smtp-Source: ABdhPJy3GzdAtZ9zwFJ0Bdk3Wa4NlT1lmI0Dn1dcyAmuw0V4DSomEvnW7tgxmmsnbKkUftURU6j5v/g3XrKaVml9LfE=
X-Received: by 2002:a17:90b:1a8a:b0:1c5:f707:93a6 with SMTP id
 ng10-20020a17090b1a8a00b001c5f70793a6mr2565266pjb.110.1647919854371; Mon, 21
 Mar 2022 20:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220321050804.2701035-1-reijiw@google.com>
 <20220321050804.2701035-3-reijiw@google.com>
 <YjgYh89k8s+w34FQ@google.com>
In-Reply-To: <YjgYh89k8s+w34FQ@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 21 Mar 2022 20:30:38 -0700
Message-ID: <CAAeT=Fyju6Pi4XAxJnTJ20PPJj1wVF_fPLWMFvx5D0H7UovETg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

On Sun, Mar 20, 2022 at 11:17 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Mar 20, 2022 at 10:08:04PM -0700, Reiji Watanabe wrote:
> > Introduce a test for aarch64 that ensures non-mixed-width vCPUs
> > (all 64bit vCPUs or all 32bit vcPUs) can be configured, and
> > mixed-width vCPUs cannot be configured.
> >
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> Tiny nits, but looks fine to me. Only bother addressing if you do
> another spin, otherwise:
>
> Reviewed-by: Oliver Upton <oupton@google.com>

Thank you for the review!
Since I would like to fix one of your comments (the typo) at least,
I will respin the series (and will address all the comments).

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
