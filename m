Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA16C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 07:08:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83D2C4BEE0;
	Thu, 24 Feb 2022 02:08:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dx2+mpu3vkra; Thu, 24 Feb 2022 02:08:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9864BEE3;
	Thu, 24 Feb 2022 02:08:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC434BEDF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 02:08:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4SzaMoKupDc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 02:08:11 -0500 (EST)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FEA34BEDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 02:08:11 -0500 (EST)
Received: by mail-pj1-f47.google.com with SMTP id
 cp23-20020a17090afb9700b001bbfe0fbe94so1249432pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 23:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VUMb4AVvanmWYO4fyDpaR3WwHIHA1HS4iYPCky/2b1o=;
 b=I+dKm1uFEn6jTF3g1+sBeTHv80CIAU+f5gP02ph3FvVTKEsRvFmof4QoJwAyL1o7C3
 ZIsceVtOYhoHp+yHDRw/MDpXKXvPl3qWou8WfMMqg2ezb0/D6uJWjoD18ZmlsPmgJ8Os
 01vq6oH4j1YXTxA17rUnvFcFg48eg/u6kRH+m9Qrs8PigDYl5OqHhLoNpcg0YidG5WOH
 9Tt3KxXesVMKnalH5MneSmpRjGdF9p8XfT8YEbt1PSCX4nC9J1qHBEVb00qHBqLS9xf8
 KbxdqUgcnullT092qTKFB8NMWBE5nKZLc+DcAA9jFCfi395SBHKAwlNMX7qiw5NHzy/8
 JKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VUMb4AVvanmWYO4fyDpaR3WwHIHA1HS4iYPCky/2b1o=;
 b=aijY/1BopNS0XbbL0e/kS30833GtICK9+djzHHT1EuUOb6jXrd5olwtufC3vBBx4QM
 9reVDUSTMLAI4ZfhNvGfmb0hPC7Fy6OGfHb+N/ck8WrjtbddIR+vE2Ai/Lr4poGmfAMp
 UWz/OIDLfpF89qHz/AtY1YF4omFcasjvdOunRQIacnuGfQHWtlt1D0QCKyGldJKIduyo
 kUJI571xPT3L+pPPvNCPPP6XqeLr3zUB5HAZQkdPCrX968XJpEKwke7AcbwROht+7x9v
 m947Egdl18eGsucJpcD3yvzmtzkgz/OHgfsrhBtnCMQDCFQu+rptBSAoIJm8N2BwuW76
 qZhw==
X-Gm-Message-State: AOAM530s3MbybUWW+uPULhI1wU9yJF8Zg6H/3jlr9uh9FB15bZxGzDzo
 PkmIgUTRqEcknV7M37AUeh56k20LqJ0rOtrX2ek81Q==
X-Google-Smtp-Source: ABdhPJzNt3mHF18BypBkAErSy6XHq7Iq3acinzWGyGToaKTSih4h37R44XGrA+hPk5btrU4dXQ13JKrnJampKnvU2e0=
X-Received: by 2002:a17:902:7296:b0:14f:2a67:b400 with SMTP id
 d22-20020a170902729600b0014f2a67b400mr1572795pll.172.1645686489919; Wed, 23
 Feb 2022 23:08:09 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-6-oupton@google.com>
In-Reply-To: <20220223041844.3984439-6-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Feb 2022 23:07:54 -0800
Message-ID: <CAAeT=Fz7jCBGS6UkMJRjgRfOo-8Bs5S0kkJfpmyq9Q+bwGD=+A@mail.gmail.com>
Subject: Re: [PATCH v3 05/19] KVM: arm64: Dedupe vCPU power off helpers
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
> vcpu_power_off() and kvm_psci_vcpu_off() are equivalent; rename the
> former and replace all callsites to the latter.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
