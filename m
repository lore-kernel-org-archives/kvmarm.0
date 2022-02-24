Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B98C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 06:55:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56D3C4BEC1;
	Thu, 24 Feb 2022 01:55:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rE2UcE+aiwfR; Thu, 24 Feb 2022 01:55:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EE2A4BEC5;
	Thu, 24 Feb 2022 01:55:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 514304BEBA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 01:55:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ve4-P9NKbsVt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 01:55:29 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22DC64BEB7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 01:55:29 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id c9so945892pll.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 22:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Ip1yGFvWnzVPcI5baHpTJEAS2apjxgastb+/8JG8p0o=;
 b=gnp1J6ZgOgKZkzPE/TLGYw6HgkT6WfdFs7W1DkbrdWUaQfxzzNtyA/uUNoWDzz7DvO
 Wtciz8zSIQ0ArEcg/cbzNutpNRWBvamMYiBoBUkTxpVuS7Cj75p9hEnA0h0qs084b03N
 qZQTC21C6/jYINQh85CgJ8w79TX1lzzx4HvOmf2g32jf8m59KZM99CggJPCBdqbUjlF0
 xhinssQtZVuZ9Z5tLZ9cj+F+lFgwU4VXOAqyWVRK0E/kMW7x77oAl5oLaE6eDHB67huO
 4kQPEcgY6o7kdSzhybeLdqxZ3V/mKX5gYzX3pYEpyUOyx9qzuVdnQ6J7DoR+5y4pGVlg
 D+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ip1yGFvWnzVPcI5baHpTJEAS2apjxgastb+/8JG8p0o=;
 b=gXeSeTX5OBcGheora1tNy5SuBEs0QNHV63ucxuF702tFiB3JnXJJfBIcpdcENd2+Pd
 PKT05JNkBVNvIq90qH5DAWCGnnKt7YPjDem+cNKW4dXZipqlpejMF81vj7yiMKGSSNsX
 1RDqJ9n5GLebB5KGVkWkuewwzLHBav+5hwHA+bkvSCnemDBolVE5hSTakIuCDcQJY/ss
 8uDTVXHIsxRqsuvo+hPtD9TvLqGx9gGwepAQBpq5J9otuZcUHk5bOXVtasMVnYFN29ye
 zksCkx+Fxgwn4B8jjD6zysSnB9W/fY9ie74uhnYZPxH2ijnx9gKXZZ3n9j4SCxlXh/DI
 pEZg==
X-Gm-Message-State: AOAM530eMTUnuPldPbsfvHG3XoG/w40lzk2FBR/ztOjLQwOaBKLYXLL9
 P4Gw46QRkLaz9ldJHKtbDLwcmDqkwzn1RGuwp2BaLQ==
X-Google-Smtp-Source: ABdhPJyRnrb1Nqkq289GPPagDgdXvd0ne4RNNibt9f6cIdLsgHeqzPUNBEyIJbLu8mrs1KnYUl4Uorcr2LHYBB7UWHY=
X-Received: by 2002:a17:90a:9288:b0:1bc:568b:55bc with SMTP id
 n8-20020a17090a928800b001bc568b55bcmr1389089pjo.9.1645685728059; Wed, 23 Feb
 2022 22:55:28 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-4-oupton@google.com>
In-Reply-To: <20220223041844.3984439-4-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Feb 2022 22:55:12 -0800
Message-ID: <CAAeT=FyP36QL1Dsjx-7rOJ-bwUtXJD89YxndMo8hvyBjM_z6cA@mail.gmail.com>
Subject: Re: [PATCH v3 03/19] KVM: arm64: Reject invalid addresses for CPU_ON
 PSCI call
To: Oliver Upton <oupton@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Atish Patra <atishp@atishpatra.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> DEN0022D.b 5.6.2 "Caller responsibilities" states that a PSCI
> implementation may return INVALID_ADDRESS for the CPU_ON call if the
> provided entry address is known to be invalid. There is an additional
> caveat to this rule. Prior to PSCI v1.0, the INVALID_PARAMETERS error
> is returned instead. Check the guest's PSCI version and return the
> appropriate error if the IPA is invalid.
>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
