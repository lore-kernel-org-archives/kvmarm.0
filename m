Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6296FC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 13:01:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03165206B7
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 13:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AhIik/DX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03165206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F25C4B14F;
	Fri,  3 Jul 2020 09:01:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sE+r8aoWfqQR; Fri,  3 Jul 2020 09:01:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 837584B156;
	Fri,  3 Jul 2020 09:01:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0064B14E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 09:01:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oN16AV1LgRCf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2020 09:01:06 -0400 (EDT)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 114594B130
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 09:01:06 -0400 (EDT)
Received: by mail-ot1-f65.google.com with SMTP id n5so26676368otj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2020 06:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=E5rO2xkav8qempBVEekmcKPJ77H6iG3rRif77s86Ajg=;
 b=AhIik/DXfy2epE5Yz43CROdtoC5KMu0B6oq3VndRKh6iqK8kYO2BsOvUnRhu3QZvLx
 4QR/GVl5BGcODHM94yd2OpB3/GvAfliIrSwitIAegpRmI7cR/SP/1K1jsTc8LR0YxirT
 /aDpq5F1XmcZeag1N46Y3oBedrLBf/9UD64RzCmjbDcwa2CIa6yp+SSk2udxPG/GW/KD
 dJihy4DKTUtxKdbkyhAMgsE79Ba7LQR4kjZZSQ5fJvQNCQhwHaz/nznkiM51hhzWrBL5
 8S30GJNbmWdKxe62Lvm9y1m9VhEbnhuIrncwuQK0ezJ8zmVjWtJXj8WHQ8LjyTuSXOlr
 3JZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=E5rO2xkav8qempBVEekmcKPJ77H6iG3rRif77s86Ajg=;
 b=VBVPmXUhezbTCn7hXIGxSEoUZtDrr9J6gsZkQtC1IjHhh/5T6Se3zBBhMQmRxfMG5x
 bi4TYwlt4azeu13CFetM6bmAWtMn4baT1+wvk+fwK+uM6VF26xbguSKWZJLOQoLMR5rv
 g07m2dylRu7/Auo02NVdDCwtysZFDIRoFhqlNT0DkikcNPR2T1t38kpOJxWNB4pg3FAU
 K3SuT6urVSuBHwSK56pDF9536JRQGr2O3132W/Cp5uowTITQB3hGvlhh+KrCv28HRBPt
 nIA+Q7YtK+Jx3pzedNvnWiIqfWAe29tj6M7p7YMYEB8TdMVlPoBbCCclMBdj/SfTBQrf
 NvZg==
X-Gm-Message-State: AOAM532pPTU8UbtGlISCTPub+CKO/rzFgcaMUl9SOZ+pEWRTGk1Rt2Cj
 tjYN+ZJYWdrbKwrjQsvvE7NUBkZoJRBLgK7kdJTRLA==
X-Google-Smtp-Source: ABdhPJx/hSX9eOK8XYmESF6MLIATWFTIDJ2rBcyfo9GSqDL5P4aLBbPS2JAdAdxXrPqepYPaRjaIIEtmyCcFWTWO7ys=
X-Received: by 2002:a05:6830:10ce:: with SMTP id
 z14mr23075129oto.135.1593781265438; 
 Fri, 03 Jul 2020 06:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200629114110.30723-1-beata.michalska@linaro.org>
In-Reply-To: <20200629114110.30723-1-beata.michalska@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 3 Jul 2020 14:00:54 +0100
Message-ID: <CAFEAcA8F-LR8qBw-ozp=0pDe2f9oC+F1fQW4xDO0ooPRws53uQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/2] target/arm: kvm: Support for KVM DABT with no
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

On Mon, 29 Jun 2020 at 12:41, Beata Michalska
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



Applied to target-arm.next, thanks.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
