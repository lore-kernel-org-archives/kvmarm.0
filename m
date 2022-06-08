Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC54CC43334
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 15:24:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4298E4B302;
	Wed,  8 Jun 2022 11:24:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g3PggxEPmmMC; Wed,  8 Jun 2022 11:24:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32C1A4B2A0;
	Wed,  8 Jun 2022 11:24:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B84C14B298
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 11:23:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4QcBiveeBiZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 11:23:58 -0400 (EDT)
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com
 [209.85.160.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96EFC4B292
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 11:23:58 -0400 (EDT)
Received: by mail-oa1-f43.google.com with SMTP id
 586e51a60fabf-e93bbb54f9so27555697fac.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 08:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=H6iQ1oiG4jqbRTAVgqyiczhzaZiBR3863cdsPwx94jE=;
 b=ZAKXSBqjVvyYD1DtUywOeOLaK2m28DXPZEgG+1XMHv4nCFXk9wRZ4biu72jxqhOm2V
 qTZJVZMpWLHLA7oFHQHqsVjYECEus3IgpInDpaRrPTb7j1wUP83DQSzd1EXj2o3OMnqu
 It1KIGAuzXgMOJX+IOOYkqXCa7ty/Jt7xW2kThXu+Ko2EniIDv0fylfnsEKFcD3e3Ax6
 1r5LlP5HizW0m3xa/eiqTnrEnsuil6ghqC6sZ6/zybBIzsXp2bpx/I5Q8g5FXzd5/svK
 pZRuqt1zH8i66lqQX9tzqcDCxh+vWpC/JFuPnWKGOWmcRkxKfj5XYmjFfByQOYpCEnDT
 YB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=H6iQ1oiG4jqbRTAVgqyiczhzaZiBR3863cdsPwx94jE=;
 b=brqYqDhgLqVM02xQNFP5QB9UHy08ElaJkz4hHHMQW8YknvwD/7HsCov8ZhkkldWSdL
 zvDyjcRE0+hv+VRWp2fJghwjgsdjo0I3nC61dgB2KyYMwpZkq5Y/Ai2uqHK+mUYe42ZH
 I0GjSLITvgOR3PDb1E9aL12lK8Vt6c4pwptX4HA2PT/igyCyPIcRLM35rHnCZWrdY7BY
 l1QSac/y0ARs0zvk4BZy6qwcQQjZ8V9wu5hsF9XZMotmcDUI7K2DD8bP7Hb04CWMEnCK
 AzV0TLsjpBfHWxcLjiBBgAq8Txw5Lf3rz9RPlxE582t3+cOkWfbrxt3t5twLdAORWais
 qbDw==
X-Gm-Message-State: AOAM532MniDN83W7lHGtGj4e2GHEfILueN9tof2jGi/3TLDxkK6MkOxl
 4wkYcEqmrzqemc7TjkVcMavk07bThzm4fN5WqUNrcQ==
X-Google-Smtp-Source: ABdhPJwWh0t18ojumdlRudXhBLwAtkB8k6FbFwmPSKZgVK0Aco06/t4gPcQUgndn2klBnUFc65KaTHwARgYsZ7pj0Sc=
X-Received: by 2002:a05:6870:828d:b0:f3:4dd7:5ceb with SMTP id
 q13-20020a056870828d00b000f34dd75cebmr2758965oae.294.1654701837865; Wed, 08
 Jun 2022 08:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-7-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-7-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 8 Jun 2022 16:23:21 +0100
Message-ID: <CA+EHjTw4wOMKxz1sF7L5pDSidV=GrpO6XPnF1sAw0z6QiT7y0A@mail.gmail.com>
Subject: Re: [PATCH 06/18] KVM: arm64: Add three sets of flags to the vcpu
 state
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Sat, May 28, 2022 at 12:38 PM Marc Zyngier <maz@kernel.org> wrote:
>
> It so appears that each of the vcpu flags is really belonging to
> one of three categories:
>
> - a configuration flag, set once and for all
> - an input flag generated by the kernel for the hypervisor to use
> - a state flag that is only for the kernel's own bookkeeping

I think that this division makes sense and simplifies reasoning about
the state and what needs to be communicated to the hypervisor.

I had a couple of minor nits, which I have already pointed out in the
relevant patches. With that, patches 6~18:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





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
> +
>         /*
>          * We maintain more than a single set of debug registers to support
>          * debugging the guest from the host and to maintain separate host and
> --
> 2.34.1
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
