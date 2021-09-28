Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C765C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 17:22:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E11661362
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 17:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0E11661362
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C16D4B090;
	Tue, 28 Sep 2021 13:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nT1rN9M7rFJm; Tue, 28 Sep 2021 13:22:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B66407E7;
	Tue, 28 Sep 2021 13:22:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0731407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 13:22:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9zpdGOM7ZZAT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 13:22:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F48E40762
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 13:22:23 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6998C61352
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632849742;
 bh=p1omdo8J0LTck4weGVlceL1bR9p0Zh2+XitDJiT9QIA=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=LgtnS2Rj9BH0Xm9rjL/KDnFmWfVCQ5cnOP+ZR+00NmDh7TxBWjYcG1kkQRDsDHEXf
 nvrNiRAUQd0tFWYdUKovBpzG3d28rcUdmXs4LzwetDqKfoWXEGuaiPdLbHffHVrM0i
 8QQPGTDAkt0y9IBTMcm9zCAQvUKwkUYnlNUfGrQCqvSuY8rOLK4ZDK7HHp41QE91NH
 9XIL1IB2jAT8MTg9oypVh8LeRhJRU3D9qdyQkjkNC+aK16uO+s+vXFJjkSL1LzxAPX
 /lr8MeNVbJShpiVvEZtX2emz2XPz1HClofzown+Wpk4Hjbyw4mfRNBM/m8x6J4DYej
 UbIqKxM/3INIg==
Received: by mail-ed1-f42.google.com with SMTP id l8so37047604edw.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 10:22:22 -0700 (PDT)
X-Gm-Message-State: AOAM532rcP/rt2YAyFX314U19mwwbDLDaGqZck9Oz951aXDw/Wv0MsGy
 BcdPCTwhpY3W2tgFK+dehhnUkqqSzYOQvBarRA==
X-Google-Smtp-Source: ABdhPJyYj6eZo+4rVJU4CYW255+Mc68GtlF90gxDfm5SHY/AXdUWRENNY4sqvr/w1Y6jnQWE59TZVZjjORVMXH70how=
X-Received: by 2002:a17:906:a294:: with SMTP id
 i20mr8026916ejz.128.1632849740003; 
 Tue, 28 Sep 2021 10:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210927064119.127285-1-gshan@redhat.com>
 <20210927064119.127285-3-gshan@redhat.com>
 <CAL_JsqL8+_Q690-c3J4TS6LBF-mCUBxbhTfr994=Fwffqab0_w@mail.gmail.com>
 <c101363f-1de7-1d56-a8d9-243f003b48c1@redhat.com>
In-Reply-To: <c101363f-1de7-1d56-a8d9-243f003b48c1@redhat.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 28 Sep 2021 12:22:08 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJtckde=Ngfhr7u3f_xsccavo+4Pt-v9o_nGHTX+wD91w@mail.gmail.com>
Message-ID: <CAL_JsqJtckde=Ngfhr7u3f_xsccavo+4Pt-v9o_nGHTX+wD91w@mail.gmail.com>
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

On Mon, Sep 27, 2021 at 6:59 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Rob,
>
> On 9/28/21 12:49 AM, Rob Herring wrote:
> > On Mon, Sep 27, 2021 at 1:42 AM Gavin Shan <gshan@redhat.com> wrote:
> >>
> >> There is no device node for the empty NUMA node. However, the
> >> corresponding NUMA node ID and distance map is still valid in
> >> "numa-distance-map-v1" compatible device node.
> >>
> >> This fetches the NUMA node ID and distance map for these empty
> >> NUMA node from "numa-distance-map-v1" compatible device node.
> >
> > This is much nicer.
> >
>
> Indeed, thanks for your suggestions :)
>
> >> Signed-off-by: Gavin Shan <gshan@redhat.com>
> >> ---
> >>   drivers/of/of_numa.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
> >> index fe6b13608e51..5949829a1b00 100644
> >> --- a/drivers/of/of_numa.c
> >> +++ b/drivers/of/of_numa.c
> >> @@ -111,6 +111,8 @@ static int __init of_numa_parse_distance_map_v1(struct device_node *map)
> >>                          return -EINVAL;
> >>                  }
> >>
> >> +               node_set(nodea, numa_nodes_parsed);
> >> +
> >
> > With this, couldn't we remove of_numa_parse_cpu_nodes() as the only
> > thing it does is node_set()?
> >
>
> I don't think so for couple of reasons:
>
> (1) With problematic device-tree, the distance map node might be missed
>      or incomplete. In this case, of_numa_parse_cpu_nodes() still helps.

It's not the kernel's job to validate the DT (if it was, it is doing a
terrible job). I would suggest writing some checks for dtc if we're
worried about correctness. (The schemas don't work too well for cross
node checks.)

> (2) @numa_nodes_parsed is also updated when the memory nodes are iterated
>      in of_numa_parse_memory_nodes() and numa_add_memblk().
>
> So @numa_nodes_parsed, which is synchronized to @node_possible_map afterwards,
> is the gathering output of CPU nodes, memory nodes and distance map node.

Is it valid to have node id's that are not in the distance map?

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
