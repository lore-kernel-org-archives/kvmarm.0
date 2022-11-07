Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40986C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CCC4BADA;
	Thu, 10 Nov 2022 09:51:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id teSrHCxQ3Bl0; Thu, 10 Nov 2022 09:51:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0584BB28;
	Thu, 10 Nov 2022 09:51:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A294B893
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 14:48:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lidyvJqn+679 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 14:48:35 -0500 (EST)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFCA74B838
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 14:48:35 -0500 (EST)
Received: by mail-oi1-f180.google.com with SMTP id c129so13354730oia.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 11:48:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=pC3VraCs8s6YEvpVTV0I2PtrYdEY09JJSU0EEtgPIig=;
 b=ZuG1RomTPNC8KablyGHC2oHAnuD4Ze2RGZqAo5wN3ZA8MjBjxcCBZfOdCrLCzj+0R9
 tmfmfw74dlspfxNvLoRz9qRXMjdpkztkyOlXJYG+BMwHwWBfmDNbCFDIq/mPCUZme58z
 pSA9Wn91NAL7q7HYVRPkH5DyGYQ8CteGyz9hhCTXje5wbDKqCBWLWuvqeTLKNNPTwMuU
 zalkAemcQT7efpQfqzs/GE1JhyzE4E7WWM0xFX5xzIgaMrcDIzZyLZkl0RJ0TrRX/rwZ
 +T5QM+2zrhhvhrUWKVDic+x30TiVMbO42sCYjDMJ3CwXuEdhrTvwQzXpcCPXUcWmidbr
 pw4Q==
X-Gm-Message-State: ACrzQf1ESX2/TWKh7q7aodFXU1rogIZOjxxV+ZTYfJ9qp1WyXblg2CZx
 v1LAMlHCF/717UD3veWVQRtL0ppuZ6CBbWptuQU=
X-Google-Smtp-Source: AMsMyM4Z/18xRjOjvwABmJlezj2L/eczEI73izOERN6BTvW3w6fEqYeDeoy80slhhl69ZKNf1gn6csGrVR6G4/dsA4Q=
X-Received: by 2002:aca:2805:0:b0:359:e340:d53 with SMTP id
 5-20020aca2805000000b00359e3400d53mr26615294oix.209.1667850515046; Mon, 07
 Nov 2022 11:48:35 -0800 (PST)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-8-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-8-87682f78caac@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 7 Nov 2022 11:48:23 -0800
Message-ID: <CAM9d7ciYabTpo0q5Z8h229dZ+RXG7JP1zgOoR1fgdZZCH87vow@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] perf: arm_spe: Add support for SPEv1.2 inverted
 event filtering
To: Rob Herring <robh@kernel.org>
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, James Clark <james.clark@arm.com>
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

Hello,

On Fri, Nov 4, 2022 at 8:55 AM Rob Herring <robh@kernel.org> wrote:
>
> Arm SPEv1.2 (Arm v8.7/v9.2) adds a new feature called Inverted Event
> Filter which excludes samples matching the event filter. The feature
> mirrors the existing event filter in PMSEVFR_EL1 adding a new register,
> PMSNEVFR_EL1, which has the same event bit assignments.

Just out of curiosity, is it possible to have the event filter and
inverted filter at the same time?  What if they have the same?

Thanks,
Namhyung

>
> Tested-by: James Clark <james.clark@arm.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v3:
>  - No change
> v2:
>  - Update for auto generated register defines
>  - Avoid accessing SYS_PMSNEVFR_EL1 on < v8.7
> ---
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
