Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FA2C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 06:10:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A124B166;
	Thu,  9 Jun 2022 02:10:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NQWh4iOsYE-9; Thu,  9 Jun 2022 02:10:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748844B375;
	Thu,  9 Jun 2022 02:10:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD934B373
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 02:10:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6WBsBKI5GnQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 02:10:31 -0400 (EDT)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
 [209.85.167.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD4094B166
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 02:10:31 -0400 (EDT)
Received: by mail-oi1-f174.google.com with SMTP id q11so15413614oih.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 23:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NdHR2NIjbUP78PFYeyIgFS7y+RZOhrjzozxhM3S1oaY=;
 b=Q6TcKRsb6QCacT1EloeSMw+QV8ThhugDK6lXavablrtGoy/D+ItGZNTGRCXrMI65fW
 9xglhOhXk8oZyXXmztAW/HwS1dCaBUBqNJvQmZYPudVkwpBEukJiMTGstre1ho17QVQC
 yCHeBmBr2e6DbmSPxKKJ5l7YDx4M315jPRtCbqjTqksSHpmH3LZFcIKC/W/TxnyDkz84
 3JOCl1tplNBLTJqO7akACXx1yI4zM0VAwx2mnR19pCzMevGvesP6urjnOUx9D4P4vQ0+
 mJYUD31fDD6pvBKlPgMGWGTf91s7VFTZhESNpJ3UYVCv6U/qBG9C0Vn27oIHYgueH4+Z
 fM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NdHR2NIjbUP78PFYeyIgFS7y+RZOhrjzozxhM3S1oaY=;
 b=w1XUQruASaG9D87RXSSMEPRhukocFoRVgbe+SabI5F5vHyVpXyR5xFP367dFh73kts
 hbi6RnUOKYhT0wt2Im/tmgmdWGZ06mjvJD0OxOFk535UIxdmVhvgd/45r/KZb7PItyl2
 DJA1TfT+x0BIE6kWxL4twZBlHZqCLvq7jwFOPofFn2KEZYJaiLe3F/ZIaoMtU3RHxTat
 GBh4+4CVEo0PwYFOvbi1W1ovxEHSK+yDLHNC+gWkgMcPfv52zJbBwgZC4RKOuZkwwz7q
 Vg4+TvePa3irOki7vVEUnswj/CEg1i4iVHqlDY7vAg65wdzXfxRu4vZva7GmlRV7Wh3q
 qS6A==
X-Gm-Message-State: AOAM533ViBs+QO9dxQ+FEBXQ+oYIGp1Uc3s6DeRZ9rKilfGCOp2Vpxly
 KVH0KxT0jmL8ImIW/qdhep2FdghbQhQCCuNkRNu7Zw==
X-Google-Smtp-Source: ABdhPJySBCo7XChZly1cnDd33GTRmnk064t0lYsGNiwe9fWhmKZvx39GjcsC8z6DIWzlxBRQ0UP6jFPW8g/Vh/fwQ+g=
X-Received: by 2002:a05:6808:3198:b0:32b:a54:1238 with SMTP id
 cd24-20020a056808319800b0032b0a541238mr808316oib.16.1654755030894; Wed, 08
 Jun 2022 23:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-7-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-7-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 8 Jun 2022 23:10:14 -0700
Message-ID: <CAAeT=FzXWDfkR5ck0vpiRLKi0nU9e5Ua=yg=3Rj--Gq+aBaVUg@mail.gmail.com>
Subject: Re: [PATCH 06/18] KVM: arm64: Add three sets of flags to the vcpu
 state
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Marc,

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> It so appears that each of the vcpu flags is really belonging to
> one of three categories:
>
> - a configuration flag, set once and for all
> - an input flag generated by the kernel for the hypervisor to use
> - a state flag that is only for the kernel's own bookkeeping
>
> As we are going to split all the existing flags into these three
> sets, introduce all three in one go.
>
> No functional change other than a bit of bloat...
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5eb6791df608..c9dd0d4e22f2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -338,6 +338,15 @@ struct kvm_vcpu_arch {
>         /* Miscellaneous vcpu state flags */
>         u64 flags;
>
> +       /* Configuration flags */
> +       u64 cflags;
> +
> +       /* Input flags to the hypervisor code */
> +       u64 iflags;
> +
> +       /* State flags, unused by the hypervisor code */
> +       u64 sflags;

Although I think VCPU_SVE_FINALIZED could be considered "state" rather
than "configuration", I assume the reason why it is handled by cflags
in the following patches is because VCPU_SVE_FINALIZED is set once
for all. If my assumption is correct, it would be clearer to add
"set once and for all" in the comment for cflags.

Also, if we end up using VCPU_SVE_FINALIZED in hypervisor code later,
then should it be handled by iflags instead of cflags ?

My understanding of how those flags should be used is as follows.
Is my understanding correct ?

 iflags: flags that are used by hypervisor code
 cflags: flags that are set once for all and unused by hypervisor code
 sflags: flags that could be set/cleared more than once and unused
         by hypervisor code

Thanks,
Reiji

> +
>         /*
>          * We maintain more than a single set of debug registers to support
>          * debugging the guest from the host and to maintain separate host and
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
