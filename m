Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DAAC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 03:56:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13F5961A3A
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 03:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13F5961A3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A9CB4086C;
	Thu, 30 Sep 2021 23:56:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Npmm7Fc4U4nB; Thu, 30 Sep 2021 23:56:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A64B4B0B4;
	Thu, 30 Sep 2021 23:56:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D9894086C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 23:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yOewqjT4j1Br for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 23:56:48 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F1BE407F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 23:56:48 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 me5-20020a17090b17c500b0019af76b7bb4so8290063pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 20:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tCIk2rzSAK6/lGmAh+8ZVlsluD8ZtZDvCuWYLUwTxRw=;
 b=KolHYewwxAsc2/709MTf2RfXswtvqv7dB1KsqPRVjdQ3kLJwGv+vE/AZ6Z5XM2yEKV
 UFDwOUg+I3hDzyY2PvO8e6jmPInB1hId0QWprhc6S7ioXN942NJvnEtUc80l46KQ/gCO
 awYFOf7AnIQoPg/sVpghaHRdsKYydWvm5jelP35b9JTmC6oFRYOz2LDRAnPQy5hNu/lr
 ORASjkrhH9hIf/F+DS7WKVZKhqXzjqHQoLvJ1S8xIVnK0xEUFZblsrTCoyl3gMtMYezF
 hvicJ0yTXgdOPe1aKySnGeAuImP1baAJZxdN0oypUsZfil0EnOe4YhyFIejnrHAE6emP
 IWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tCIk2rzSAK6/lGmAh+8ZVlsluD8ZtZDvCuWYLUwTxRw=;
 b=NoiYyTTlS4eqzo9NI1DSzEnsOmGMBOmDRSaPhQGhUlGkgIZ7rnRaAUGaJAMtrtTL6k
 iRigMTjGHm2Wh9pXeMY2xKyJI3dsMJw8D+bP/dr4j7pfFGxQNjVBTP8LadWgftyNugV0
 MjGWxGYkT49SiNTCLbs/iv43gl+rPaFE13hOzFNJbQzrNFPPDkgfJRZ19XoFM6fkR6en
 FwN2utm1WP++94Vd/H3fc9lZ4AgBri9s+H7W0YKau/SWZDRGEm1lar9xW8QF4Exo2yUi
 rv4SttjYulgnEU96VJFpLY9ObCyJN7RZNokXgCeAOjJqhjIRMv5YLMkCVPV0Oq0ojaoT
 0Sww==
X-Gm-Message-State: AOAM532GbGlZC6B7MDQPD/DytTva4NLcYrg3w7GKZ0rXg54Tf0WDEKhE
 aC1c40hG3xYjI34k6epMhyS6RVBcim1d0bkLzTe0LdqS0JU=
X-Google-Smtp-Source: ABdhPJxxVTbIAcE8hsUmG1R6PXR6hasV9CPLD2zbS5x4ThW/2KNj+0yzykHBrrXoP3DuZ6QcbRfNwMAg//iLz+o/T9A=
X-Received: by 2002:a17:902:7142:b0:13e:e77:7a26 with SMTP id
 u2-20020a170902714200b0013e0e777a26mr8644884plm.38.1633060607156; Thu, 30 Sep
 2021 20:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-3-oupton@google.com>
In-Reply-To: <20210923191610.3814698-3-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 30 Sep 2021 20:56:31 -0700
Message-ID: <CAAeT=FzONsbTw9doo71XQjPdLXhWO+f+OD0FtWc9Ph_0d_vTcA@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
>
> The only valid calling SMC calling convention from an AArch32 state is
> SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
> when called from AArch32 rather than comparing against known SMC64 PSCI
> functions.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Looks nice.
Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
