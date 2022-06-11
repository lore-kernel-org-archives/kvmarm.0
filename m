Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6357DC43334
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jun 2022 18:41:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D84ED4B414;
	Sat, 11 Jun 2022 14:41:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dIKceImJH+SJ; Sat, 11 Jun 2022 14:41:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E254B3E4;
	Sat, 11 Jun 2022 14:41:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED3FB4B3E4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jun 2022 14:41:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TDXaM0IYuCO6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Jun 2022 14:41:54 -0400 (EDT)
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com
 [209.85.160.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBDDF4B3D8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jun 2022 14:41:53 -0400 (EDT)
Received: by mail-oa1-f54.google.com with SMTP id
 586e51a60fabf-fe4ac3b87fso3317216fac.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jun 2022 11:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aGUj2LVLNGk5sOwR7+tKcU/mD91p7d7Dvbf7YRvu4qg=;
 b=rPFZGQ3gOLwesD2QG9IU7Z5ORHjifYdHd3M3rHmqO3uS3mAECeXs6WSr08jhHalONZ
 00kH3g/6qwvm7Dxs4OZ+92EBsLjn+o7VUtqj90p3R3wmrgQ2eb8atHHvBtZZBrCW8++X
 kFVuv1Ot4n+8SKCcIx2n/ihi+/dBLMJD8UVXyxR68MluJYDarVW4aa25cfakTZv84r1J
 nn7YN7qw6zWnfq/+xGkexU0DFWnuoSdRk9EyoCt1b05nphByzWoPaWx2BZLAk18WZ0gs
 5+qCnSeOw0GNdYe6zeodER3hcZKsS8SpAhSeNZnVC6+Hjz3AEQiwhzij2Jsh9TGn5hDx
 +E4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aGUj2LVLNGk5sOwR7+tKcU/mD91p7d7Dvbf7YRvu4qg=;
 b=iMbARaCJqSGRGmDVq0aXMISmbjpfSFcSlPj0lg5vdf5iwkoFCRhrdIJqSQ4UxZwGT5
 qwuZv1NgzA6XRqlTh40bPhoqcwlxLhQg/hwd+yOH0/HOc0sV/I27mnFMM/LzjzZiA7JR
 jRFcmwGIwJWHU71zhYKVQMMwC9aHzUls/hmAg9F6X2Rmw2gpc4m1Ch203m/jXjeW5MVo
 R2D7BDvOCBnbyG9xG6HYNiiQguy3Z0A7t0onRQprkQYegUyQ9lySXBmbOYihqh/RdVDV
 OIO82oEd7R2RoTtFDNw4j6lG49HCX+GbH/3bYpX/DJVNCq7F82P6M/CY8drGEeQ1HCnn
 HHlg==
X-Gm-Message-State: AOAM53127Ensq29Nmy6MRhm9g6nxfBvXdxhpbD6/RWW9mbn4VaMY1R+0
 iRPnt6yBXEF+ZHxo3JIjplBpA7Yc3wEGqCgYKRYT1g==
X-Google-Smtp-Source: ABdhPJwBqvM9uOWilf/hZkJ/qSGvf+HPCw8ZzSqEItH5yaUmYPdRrrdg19+h1EH+Z84nEY0g6QaKN8589eW/COQRu1E=
X-Received: by 2002:a05:6870:304b:b0:f2:d164:5c85 with SMTP id
 u11-20020a056870304b00b000f2d1645c85mr3138557oau.107.1654972913135; Sat, 11
 Jun 2022 11:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org>
 <20220610092838.1205755-7-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-7-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 11 Jun 2022 11:41:37 -0700
Message-ID: <CAAeT=FxsPKgRbeNKWmRW3BYAnNrf_j6DeNGaCGUVG+_uNUUrFA@mail.gmail.com>
Subject: Re: [PATCH v2 06/19] KVM: arm64: Add three sets of flags to the vcpu
 state
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Jun 10, 2022 at 2:29 AM Marc Zyngier <maz@kernel.org> wrote:
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
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6d30ac7e3164..af45320f247f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -335,6 +335,15 @@ struct kvm_vcpu_arch {
>         /* Miscellaneous vcpu state flags */
>         u64 flags;
>
> +       /* Configuration flags, set once and for all before the vcpu can run */
> +       u64 cflags;
> +
> +       /* Input flags to the hypervisor code, potentially cleared after use */
> +       u64 iflags;
> +
> +       /* State flags for kernel bookkeeping, unused by the hypervisor code */
> +       u64 sflags;

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you, those comments are more clear to me now.

Thanks,
Reiji


> +
>         /*
>          * We maintain more than a single set of debug registers to support
>          * debugging the guest from the host and to maintain separate host and
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
