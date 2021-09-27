Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8378C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 14:49:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6601360FD7
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 14:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6601360FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B01074A524;
	Mon, 27 Sep 2021 10:49:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NNK-Nc11YMV6; Mon, 27 Sep 2021 10:49:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A16474A534;
	Mon, 27 Sep 2021 10:49:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AEB64A524
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:49:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FYuuZg4VhUfN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 10:49:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B3944A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:49:44 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48EAA60FED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632754183;
 bh=nlm+GXqBOJFgPGuqH4ktEyVp0rZXsByzVCpaKGKn9Pw=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=CtSY0hs0nhLxHyr6ErsvWuAR1cv3yUK5t2GqYnY79ud/jOLtgMBvrFATh1DTQk5Wr
 emdDTnPAPoArKZsQl3de5W+/e+Ei/O8rV7O0zRGuu/hG2q+3r5n400glzNY3fMncfY
 bSsFfTIP/pPxAJ9T2baDtHFfCMU6qXpUwXfEghNuIyrGlhOP79telufsEH0MrhRfuR
 Uon1rEsEJDFbGdqfsvYSUDQgTmmfQCqiOuqp47yPXAUHLS0DodF2zvxGFADDNU45P8
 6QyNaDEy01x74UUZCCMh3Joul+V3W09gvDMPW/qq0YTwZdYKRkrNasv7R6CLNsnUDn
 QI/RyzqUaefig==
Received: by mail-ed1-f50.google.com with SMTP id g7so10896145edv.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 07:49:43 -0700 (PDT)
X-Gm-Message-State: AOAM533B89LH6hqWaF5JDF7RIBCGe6mJ1Naf7Y1REQZ+Ld+p6rNf4neS
 T/+se0UbmvKR6xN686+M43/XuwzkKU5w6m7vZg==
X-Google-Smtp-Source: ABdhPJwAdi6VamHHELYSAbPUEIJOXg9VYm6jMbUqTQD67z8h2BqyDUn/kOFm4ji2hkz/vqnJ2ZIn0ddX0WT5DJGrUCg=
X-Received: by 2002:a17:906:7250:: with SMTP id
 n16mr449630ejk.147.1632754181882; 
 Mon, 27 Sep 2021 07:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210927064119.127285-1-gshan@redhat.com>
 <20210927064119.127285-3-gshan@redhat.com>
In-Reply-To: <20210927064119.127285-3-gshan@redhat.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 27 Sep 2021 09:49:30 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL8+_Q690-c3J4TS6LBF-mCUBxbhTfr994=Fwffqab0_w@mail.gmail.com>
Message-ID: <CAL_JsqL8+_Q690-c3J4TS6LBF-mCUBxbhTfr994=Fwffqab0_w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of,
 numa: Fetch empty NUMA node ID from distance map
To: Gavin Shan <gshan@redhat.com>
Cc: devicetree@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 shan.gavin@gmail.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Mon, Sep 27, 2021 at 1:42 AM Gavin Shan <gshan@redhat.com> wrote:
>
> There is no device node for the empty NUMA node. However, the
> corresponding NUMA node ID and distance map is still valid in
> "numa-distance-map-v1" compatible device node.
>
> This fetches the NUMA node ID and distance map for these empty
> NUMA node from "numa-distance-map-v1" compatible device node.

This is much nicer.

> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  drivers/of/of_numa.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
> index fe6b13608e51..5949829a1b00 100644
> --- a/drivers/of/of_numa.c
> +++ b/drivers/of/of_numa.c
> @@ -111,6 +111,8 @@ static int __init of_numa_parse_distance_map_v1(struct device_node *map)
>                         return -EINVAL;
>                 }
>
> +               node_set(nodea, numa_nodes_parsed);
> +

With this, couldn't we remove of_numa_parse_cpu_nodes() as the only
thing it does is node_set()?

>                 numa_set_distance(nodea, nodeb, distance);
>
>                 /* Set default distance of node B->A same as A->B */
> --
> 2.23.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
