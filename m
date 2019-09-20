Return-Path: <SRS0=YpAl=XP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30B0C3A5A6
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 00:07:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50C7A206B6
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 00:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="v5PB0Hhv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50C7A206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B50874A6ED;
	Thu, 19 Sep 2019 20:07:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0AinJxQvsNwq; Thu, 19 Sep 2019 20:07:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACBAA4A6C6;
	Thu, 19 Sep 2019 20:07:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14EDC4A656
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 20:07:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id unqdwWmgJVn7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Sep 2019 20:07:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2ECE44A6C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 20:07:54 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CF1352196F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Sep 2019 00:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1568938073;
 bh=KAhGCSVOVtUtAdEEuBhsqNfJhp1wcq6UJPR1rEams+Q=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=v5PB0HhvLmN/6ZaebrnHpnUH8NPDVNrrZqFQJxlbGHGW5BjN98ufBDZu0YRL8ANiQ
 BHqOCR3wlr8v5DE9t9rfG9yqZ1DCDNMv6n2DSES9zAB5DSHPlgCTPmZGM6nLPW8pkH
 s3npw8z3tv+lCr63gyPA3pj9qac4w4UP86/GKnD8=
Received: by mail-wr1-f53.google.com with SMTP id r5so4876727wrm.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 17:07:52 -0700 (PDT)
X-Gm-Message-State: APjAAAUz/ket5c9e1QMaFdv92LNr+7Zd8SNU1rF7acvd6gA2Dyc43KWi
 YWfbZGGQ9Bfd93lBg8Z70Lh0Jm+7aZE6SmWgjww=
X-Google-Smtp-Source: APXvYqzYKnFXikeBrYgOpER2Qjc+5Diq7t0DgzMJf2ATPzJa1qK18MTpVnoNyg+SDqozE2cOBqwBEvImB62CtwuT4PI=
X-Received: by 2002:adf:fe0f:: with SMTP id n15mr9371291wrr.343.1568938071266; 
 Thu, 19 Sep 2019 17:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
 <20190619123939.GF7767@fuggles.cambridge.arm.com>
 <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
 <20190624104006.lvm32nahemaqklxc@willie-the-truck>
 <CAJF2gTSC1sGgmiTCgzKUTdPyUZ3LG4H7N8YbMyWr-E+eifGuYg@mail.gmail.com>
 <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
 <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
 <CAJF2gTTsHCsSpf1ncVb=ZJS2d=r+AdDi2=5z-REVS=uUg9138A@mail.gmail.com>
 <057a0af3-93f7-271c-170e-4b31e6894c3c@linaro.org>
 <CAJF2gTRbyfrUqAULPqJTXdxx8YOscPqAEuMsoJ+dTNobNrUV1g@mail.gmail.com>
 <20190919151844.GG1013538@lophozonia>
In-Reply-To: <20190919151844.GG1013538@lophozonia>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 20 Sep 2019 08:07:38 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQtk7VhBgUan6WOZgc3UaQzHL8SxMi=yiHG-8eC207BbQ@mail.gmail.com>
Message-ID: <CAJF2gTQtk7VhBgUan6WOZgc3UaQzHL8SxMi=yiHG-8eC207BbQ@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: aou@eecs.berkeley.edu,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Palmer Dabbelt <palmer@sifive.com>,
 iommu@lists.linux-foundation.org, Mike Rapoport <rppt@linux.ibm.com>,
 Anup Patel <anup.Patel@wdc.com>, Atish Patra <Atish.Patra@wdc.com>,
 Julien Grall <julien.grall@arm.com>, gary@garyguo.net,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-riscv@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 19, 2019 at 11:18 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:

>
> The SMMU does support PCI Virtual Function - an hypervisor can assign a
> VF to a guest, and let that guest partition the VF into smaller contexts
> by using PASID.  What it can't support is assigning partitions of a PCI
> function (VF or PF) to multiple Virtual Machines, since there is a
> single S2 PGD per function (in the Stream Table Entry), rather than one
> S2 PGD per PASID context.
>
In my concept, the two sentences "The SMMU does support PCI Virtual
Functio" v.s. "What it can't support is assigning partitions of a PCI
function (VF or PF) to multiple Virtual Machines" are conflict and I
don't want to play naming game :)

-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
