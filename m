Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D3BC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:38:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A294B9DA;
	Fri, 25 Feb 2022 10:38:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RfQtrTxeW0Kt; Fri, 25 Feb 2022 10:38:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 185874B9E8;
	Fri, 25 Feb 2022 10:38:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FBFB4B9DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 10:38:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tJrb1Ig+UH4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 10:38:24 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC0314B9D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 10:38:23 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 07243618A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 15:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFB8C340E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645803502;
 bh=Qp6aGn+gfpXQjgM8XZgj/bDqpiOmsivhTJEvuTz+fDA=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=vKYh1x0GLneHhE/0yXjH1+P2NcfgvGJ3rCBu/pBYythxhJYskOaY0cmc7hWO4hiPz
 68HtLHzakEQIt9ab4Oh9cw7bOTzhwh+6FB/vhIbFOQU+sQerX5/FIxGW+iEGN9b2NJ
 QbnFnvcW6iL0ElUVoOpWEik/X3w82RwNCbmdYvQWoxvBQTqI1yS7C5hgMgwx1/6750
 MR2ctkpc7CDcrWOGB07E7GwZY4AOzEqk1VQyG+269hgNHnaTA2X2g97sWnSVV8HZV/
 vY5Aw9WvYq/cnbeUBCD33rTerbIScpj1+E3HCzJftDyqekClorrI5KpA0qMfwcuJfb
 Z+RUrCbwGQZqg==
Received: by mail-yb1-f182.google.com with SMTP id d21so6589454yba.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 07:38:22 -0800 (PST)
X-Gm-Message-State: AOAM531kxDThCEVnLSgonWwanIgsbdQEY1N3hJ5SCbPrRM4188+twQF7
 5IkktoSVN2TMfupjglHIom3jsp+/Epj4IQI1M70=
X-Google-Smtp-Source: ABdhPJx3rvESMXLxmCbN7BFFRnF9VG0LfFW9lEx0SZZrJ9ggiEnkwCvqiu8bEDq0wko4R3DdaAXk1mMrwpgvYOmaWJ4=
X-Received: by 2002:a25:6c43:0:b0:61d:e94b:3c55 with SMTP id
 h64-20020a256c43000000b0061de94b3c55mr7907145ybc.224.1645803501561; Fri, 25
 Feb 2022 07:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20220222165212.2005066-7-kaleshsingh@google.com>
 <202202231727.L621fVgD-lkp@intel.com> <875yp63ptg.wl-maz@kernel.org>
 <YhYpvfZaSjrAtkZp@rli9-dbox> <cb750267af0636c49d2f8aa354f086a5@kernel.org>
 <CAMj1kXHsNsQXbeeS1zcy+xYA7kSE5apbLpChohfvkABS7Z6jKg@mail.gmail.com>
 <89c48bd2a9b32b4607d1515714fa3c1b@kernel.org>
 <16f47fa9-90b4-0b5c-33cb-cb004fc39266@intel.com>
In-Reply-To: <16f47fa9-90b4-0b5c-33cb-cb004fc39266@intel.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 25 Feb 2022 16:38:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEfsxj44t13rpgNddvTeM3qgfv5zU_xpnxn7HV3xUN2YA@mail.gmail.com>
Message-ID: <CAMj1kXEfsxj44t13rpgNddvTeM3qgfv5zU_xpnxn7HV3xUN2YA@mail.gmail.com>
Subject: Re: [kbuild-all] Re: [PATCH v2 6/9] KVM: arm64: Detect and handle
 hypervisor stack overflows
To: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Kalesh Singh <kaleshsingh@google.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 kernel test robot <lkp@intel.com>, Marc Zyngier <maz@kernel.org>,
 Android Kernel Team <kernel-team@android.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Suren Baghdasaryan <surenb@google.com>, Peter Collingbourne <pcc@google.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kbuild-all@lists.01.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Fri, 25 Feb 2022 at 03:12, Chen, Rong A <rong.a.chen@intel.com> wrote:
>
>
>

> Hi Marc, Ard,
>
> We have ignored the warning related to asmlinkage according to the below
> advice:
>
> https://lore.kernel.org/lkml/CAMj1kXHrRYagSVniSetHdG15rkQS+fm4zVOtN=Zda3W0QaEoJA@mail.gmail.com/
>

Excellent! Thanks for implementing this - I wasn't aware that you
adopted this suggestion.

> do you want the bot ignore such warning if asmlinkage not specified?
>

Even though I think this warning has little value, I think asmlinkage
is sufficient for us to avoid it for symbols that are exported for use
by assembler code.

So I don't think this additional change is needed.

-- 
Ard.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
