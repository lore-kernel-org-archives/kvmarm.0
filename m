Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7C5C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 01:23:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8E934B1A0;
	Mon, 28 Mar 2022 21:23:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wqrlRUOdL9fs; Mon, 28 Mar 2022 21:23:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC1BB4B137;
	Mon, 28 Mar 2022 21:23:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97CF04B137
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:23:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ivrj89diuGA8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 21:23:16 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7560B49F29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:23:16 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id h7so27771139lfl.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 18:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gG1dsFEHxVSzlE39a8P+3Vh86tpXJgIh+oI8BehHFLw=;
 b=k929aJ5mhdg5v+9goYJGuSlk3WjPP/llT/brdP27DSd7CR8P8CiiYrUHF/wlRp3Afl
 +P6GxMlleZs1o8dNOmQALMYo9a8DdSC6KOdbMbNdv5QwYr8dCzZQowumgZUMD5tzP/0L
 BSs7U4vCN6fpgxtfHyoeRRL+i2typA2QX/dXjZ9hILlj+UAiYLebxHVvB0ElgTbBG6YR
 DifReIXAYpAwRSSelwGtiauFYNrHveyOivEvg83un375GcqqD4aAU1QRqi4kgCVolZ73
 oDCw81CmbTwoMs6nkxtc0F7DZTj5gSg44Yn20Ere0yrdA8z4haO2ascF+TMql76FlM7o
 YKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gG1dsFEHxVSzlE39a8P+3Vh86tpXJgIh+oI8BehHFLw=;
 b=gg56nAGV6HjnVS8Xew36Pglk52NFiF/QagZeO0LDbFl1+YOpBDAVNnBcQI7pkqjaxk
 HxQ6lr9UyLnj8H/0eVXELHrlMWjEj0XZOfl37UzCvKdenl9cZiQ39n63r30BI7opWMuS
 5QsiEbHIl6YrAWYKgHmq5YFOrA/dfSC4mnErz6rN861/PaFWi5rWZoY1jRm4HeOGDsGQ
 ggUVLg0EAk47796P+KukChgGu2UkUtVuvSUro4tkJu/xjAROxvua7ec86C6xqyXEqkLL
 tPBgmwXkUtZBeljQrNBWwlR8f+zyIOeICR/f2CG/xtJhiOyHqQaRXGhk4Knadlkr8BQo
 VfwQ==
X-Gm-Message-State: AOAM533hxVg+f/NGxxFRwKHmrf1Vj8zV0enUcULTROK2KppevGR3ZJ2H
 PenxObeCmC62I3ws1vSmTsknW/T0F1c7+f9SJkydrlC629z5Gw==
X-Google-Smtp-Source: ABdhPJydvgE88BCqtewlj0lkm2CZ45JgfLYYW6+/A89FABAyuZV4FU5z3LIFWOqUDvmtMWwUnjP7PxxlQryZixl0GgI=
X-Received: by 2002:ac2:510f:0:b0:44a:5ccc:99fb with SMTP id
 q15-20020ac2510f000000b0044a5ccc99fbmr321023lfb.38.1648516994642; Mon, 28 Mar
 2022 18:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 28 Mar 2022 18:23:03 -0700
Message-ID: <CAOQ_QsgH7s7gW6KTxKCFx25-oYHk+NXBHvWK7GfcPQ6ChxVEjg@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Limit feature register reads from AArch32
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
>
> KVM/arm64 does not restrict the guest's view of the AArch32 feature
> registers when read from AArch32. HCR_EL2.TID3 is cleared for AArch32
> guests, meaning that register reads come straight from hardware. This is
> problematic as KVM relies on read_sanitised_ftr_reg() to expose a set of
> features consistent for a particular system.
>
> Appropriate handlers must first be put in place for CP10 and CP15 ID
> register accesses before setting TID3. Rather than exhaustively
> enumerating each of the encodings for CP10 and CP15 registers, take the
> lazy route and aim the register accesses at the AArch64 system register
> table.
>
> Patch 1 reroutes the CP15 registers into the AArch64 table, taking care
> to immediately RAZ undefined ranges of registers. This is done to avoid
> possibly conflicting with encodings for future AArch64 registers.
>
> Patch 2 installs an exit handler for the CP10 ID registers and also
> relies on the general AArch64 register handler to implement reads.
>
> Finally, patch 3 actually sets TID3 for AArch32 guests, providing
> known-safe values for feature register accesses.
>
> I'll leave it as an exercise for the reader to decide whether or not I'm
> being _too_ lazy here ;-)
>
> Series applies cleanly to kvmarm/fixes at commit:
>
>   8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")
>
> Tested with AArch32 kvm-unit-tests and booting an AArch32 debian image
> on a Raspberry Pi 4. Nothing seems to have gone up in smoke yet...

That is to say, I booted an AArch32 debian image as a guest. The host
kernel was of course arm64.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
