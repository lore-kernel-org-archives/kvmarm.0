Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EBFC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 15:53:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B903206DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 15:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kS/4p+1X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B903206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D65BC4B0C3;
	Mon, 15 Jun 2020 11:53:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AySnhMP3FgOZ; Mon, 15 Jun 2020 11:53:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBAC04B0C7;
	Mon, 15 Jun 2020 11:53:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFDE14B097
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 11:53:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7JIhp4f8i-hh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 11:53:48 -0400 (EDT)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2C2F4B080
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 11:53:48 -0400 (EDT)
Received: by mail-oi1-f193.google.com with SMTP id d67so16291925oig.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 08:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=LpWoqLfnguV0GF6n4sJERMG+0Xr1p7BH5DoEXiKawJQ=;
 b=kS/4p+1Xf00zo77o/0QZGXVkaM0e5CHgM4kDNE4lKpSLqYOokRmTrzAoFWyb3xC//y
 Exru4PSTsuX/ZYcu7Q0PY8ysi9YBtcwVMRBzdyQOWq68ug4oaahur3YQR113utD8jZPK
 2TTu5eaAKWuvdCDsq+OgzLxIsKhaPG164KAhWlh4SVeITCLTEZYfqP2V8hN2OFSNw2N2
 c7HxmRj/eHBDhIYFfchWh3i2Pv5Yppb1jdB+itvo1QFWHpx3X+AXTosEa7HkSMkUlZ4a
 XS/cSTyJo5rhwzo+mXVpdZt+7hWA2VMzpDTD4jpGKaUOLoO2jhdCpbFkGY6T7GXexoYg
 KFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=LpWoqLfnguV0GF6n4sJERMG+0Xr1p7BH5DoEXiKawJQ=;
 b=ipjbCjeUIiQzN/NDXRl/Oma0bIqNd8AJYII9EVfzyaGIETVZrhKmBnFRgweuNuzXK/
 xgaUI/vrXyXClsxpetYRvTj4k92j1G9gXQmA/Hwh3OZm1JuyDD9R8BqUK1mYfYO1akr5
 5fAHt+9yp3Y1OZ9T0b1TDPeFUFuwgeSP+S3xiqVZuLYRHCHbiIWa4hKFqjEw+tw8txhS
 B05vYwNZJDm0+K6cNPBKpfaHdCSVdhpRhQSHQh2CaArr54eKdoYwKo9poetpwNHTq0Mm
 N9NlrlweXbc85BbGBzhOPQGNeGn4aVsSNfshrLpLYBHdVd4Dx30jk01ZtDfyVKGDieRm
 CoPg==
X-Gm-Message-State: AOAM531UQ1yCLfk5yKRbuMQ4T868gLWeZm1ZVRaiDWTjO9+OZujY5WUd
 +f9VVoBR9o48SJwLObWXdvEC2rW9mfCmAh5gNsq4hQ==
X-Google-Smtp-Source: ABdhPJz/dLhMgzEaqMzMzutuHgM69KbjBV3f6an0jDjlyC17KvCwJ9Sf9rYrzBWzeHjfuWLlQGI/SX4Y2TQeU9jBzd0=
X-Received: by 2002:aca:568c:: with SMTP id k134mr4196oib.48.1592236428190;
 Mon, 15 Jun 2020 08:53:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200529112757.32235-1-beata.michalska@linaro.org>
In-Reply-To: <20200529112757.32235-1-beata.michalska@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 15 Jun 2020 16:53:37 +0100
Message-ID: <CAFEAcA_d=F6k3RcihV2x-HiOR-Qq+kWOcwh1FL9AUcG_2SqEVA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] target/arm: kvm: Support for KVM DABT with no
 valid ISS
To: Beata Michalska <beata.michalska@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, 29 May 2020 at 12:28, Beata Michalska
<beata.michalska@linaro.org> wrote:
>
> Some of the ARMv7 & ARMv8 load/store instructions might trigger a data abort
> exception with no valid ISS info to be decoded. The lack of decode info
> makes it at least tricky to emulate the instruction which is one of the
> (many) reasons why KVM will not even try to do so.
>
> So far, if a guest made an attempt to access memory outside the memory slot,
> KVM reported vague ENOSYS. As a result QEMU exited with no useful information
> being provided or even a clue on what has just happened.
>
> ARM KVM introduced support for notifying of an attempt to execute
> an instruction that resulted in dabt with no valid ISS decoding info.
> This still leaves QEMU to handle the case, but at least now it gives more
> control and a start point for more meaningful handling of such cases.
>
> This patchset relies on KVM to insert the external data abort into the guest.
>
>
> Thanks for all the input on the previous version!



Applied to target-arm.next, thanks.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
