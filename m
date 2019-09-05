Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DA7C3A5A5
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:17:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1334021743
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OuTz5wvU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1334021743
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76D1C4A521;
	Thu,  5 Sep 2019 04:17:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4RdPIy1fO2Kt; Thu,  5 Sep 2019 04:17:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5D14A581;
	Thu,  5 Sep 2019 04:17:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4569C4A558
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:17:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KTDdaVWR1Ozs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 04:17:06 -0400 (EDT)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23B4F4A521
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:17:06 -0400 (EDT)
Received: by mail-ot1-f65.google.com with SMTP id n7so1302990otk.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Sep 2019 01:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0xPzSESc4AZSzOz8iuenGzI1AlT1OxyaOVK/bXB62NU=;
 b=OuTz5wvUQ35QYkpSKKPCxxQaaU1HK9r2e88MGLbbYqoqxReti2Duuk8kuS0KYSC1Ip
 pdHLMs7zhO419UJhHXlo+5eiLjxOlJzvBJvCkJ3krsKonpbm0VX4vie2pR8FyWB7NvC8
 xwNADNZ++jqxlZ73zV3Fv4RHQ1CtN/gCiJYwY6zC+I9oUFbUzixbhoF1ofdOq8nGsV/x
 zsdighpHoFIa+hFO9Gfuw4SI4cNG/br0SpICPLmLwP7JT0b8Rw1es+25pX61XTWttPNd
 pNvFwcXfQACkPtI8sYYB2mxINaHDTZiPwLrnEMjPnV1KdzshSBt/8xJLmUURA816hh65
 xaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0xPzSESc4AZSzOz8iuenGzI1AlT1OxyaOVK/bXB62NU=;
 b=hhHgI2qRbmt8SV4ZNYv/xD7Xf/M0GOlfiapoEsjmqRbKIZz9LnTw4W5kvC66ji6deL
 mALyVmsYZd26dDXDTjhiZyZDjrWl7LEPKQBmhrklEz02FGtSsNrzuFKzvZLga016VflA
 8l//clvPZAFsPkcm+7GdIZC1H43eCnJg4T8owZ1hq3F+mb7TFCbHFNH4bfdO/3s6PfSd
 RPmZSKmhDGpJKAsQZermjEN91ox3khYxphhc0xkEHyD9MuTAct2012j4ARI7rSKnKTRa
 dPgr4QNP2JhBaOMJpyt5UluHDQWl1aZFTU2vhkjB3jfwoXgbl+tn3tNb24kTWX+/Z2fC
 b+4A==
X-Gm-Message-State: APjAAAUFWW2frsPRoihquyQOMAjnQjxa7ErPpG/ByJfbg01HfP/vqe0v
 Iiz43yK0cQhGTH8ohpgjcy/w01rC8guiiw3/gUuY/Q==
X-Google-Smtp-Source: APXvYqy24rjXe/FVSgFiU9SxJ4vZK2hJu//H06XcbxMiz2ueKtSmAR0GsP61bsSotW7CRw5je/6qibK/HvRFMTwLvZ0=
X-Received: by 2002:a9d:5e11:: with SMTP id d17mr1498113oti.135.1567671425605; 
 Thu, 05 Sep 2019 01:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
In-Reply-To: <86r24vrwyh.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 5 Sep 2019 09:16:54 +0100
Message-ID: <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Marc Zyngier <maz@kernel.org>
Cc: =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Thu, 5 Sep 2019 at 09:04, Marc Zyngier <maz@kernel.org> wrote:
> How can you tell that the access would fault? You have no idea at that
> stage (the kernel doesn't know about the MMIO ranges that userspace
> handles). All you know is that you're faced with a memory access that
> you cannot emulate in the kernel. Injecting a data abort at that stage
> is not something that the architecture allows.

To be fair, locking up the whole CPU (which is effectively
what the kvm_err/ENOSYS is going to do to the VM) isn't
something the architecture allows either :-)

> Of course, the best thing would be to actually fix the guest so that
> it doesn't use non-emulatable MMIO accesses. In general, that the sign
> of a bug in low-level accessors.

This is true, but the problem is that barfing out to userspace
makes it harder to debug the guest because it means that
the VM is immediately destroyed, whereas AIUI if we
inject some kind of exception then (assuming you're set up
to do kernel-debug via gdbstub) you can actually examine
the offending guest code with a debugger because at least
your VM is still around to inspect...

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
