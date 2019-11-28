Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A14C432C0
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 16:30:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47D9821774
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 16:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kS7Fyp7i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47D9821774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C37454A7FD;
	Thu, 28 Nov 2019 11:30:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Cu2dQEcoC6p; Thu, 28 Nov 2019 11:30:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CB3E4A8E0;
	Thu, 28 Nov 2019 11:30:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7AAF4A7D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 11:30:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vkUmE66pT1q2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 11:30:16 -0500 (EST)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBED24A610
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 11:30:16 -0500 (EST)
Received: by mail-ot1-f65.google.com with SMTP id z25so22649453oti.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 08:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yPEt+Nju5WcU4veBFi/Ga5jHOqhqtAro/oydEshYtiM=;
 b=kS7Fyp7iDOJxsphVx4uPCCZ6SQKHN5WxJzKywXc/bIvgucEkylxrWNNXWs4T9y9m4B
 zSGf1glua5q3mJok38ms+3X8pVgFctG7Ua1PRFmAlLcXyi2W2tjNqyRHHFNC7UCJLp0Y
 xaKtGeqhBZqncS9Lqbqu9hzZgNv+DwNxWe5bBceDx0HX3Gm6/9Aw1EsA9T8ucTTDl8pW
 WjBReBK8541aPpxPWZQVMZSLb/tV6VbMq165AUhueZY3ao4raQAFPXX18tc+cScjHKk0
 e3B4cYNa8MyuzXB6QtSZrNT1w/9xBSQ/o+mRHevLgT5p+4cNFGg5yPEbulCiSGZzsxco
 KvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yPEt+Nju5WcU4veBFi/Ga5jHOqhqtAro/oydEshYtiM=;
 b=h9wKz09MWLajAFq9nAaQa+HxmXI1Z+/+rP/OwDgwaDkCKWI4D7txIVl9F7Y4jLQjbC
 N5fkgN2yT4RGkMPLYv9VpuSDsJOyuWKfvwll+v9ebghcWsghG1hW5v7O8CTRDMyzlefy
 gVUudQmNye6Q1aylYiZ5pCBt1rCdH3EO7y5wMl/lgvEoEVjmtqWGETzzJQEycK8Fv1UP
 mXBOop3vCA6pUtrEj6sGmNWG61UnkYk0/bNBwEaSoFCI0ndedzpyS3uNaqPhVo14TFwF
 hnny8EiMZJeae0FR0bm1hsYUKhufp0SMPazfjP2w8QlEf1G9/FpG1o1Ex5MG0Az+oQIw
 kDCw==
X-Gm-Message-State: APjAAAVRenOIb0IYCDu1k9q6ojM4Rxbhb9SWwWFs04p05W5lvR1bm6ds
 WlZdvD/Wy+4V8TPM+dur0YhBeHYTWXj2bzILTZaglA==
X-Google-Smtp-Source: APXvYqyRP/Ze+GcllGSIuZVG5DxUMyLWFDdLzbBxNq/abvBFlXXlvtGbw42Wz9EjTh6F/FqwCx+Db3z6E0tDKndd3Uc=
X-Received: by 2002:a9d:6353:: with SMTP id y19mr8132604otk.135.1574958616053; 
 Thu, 28 Nov 2019 08:30:16 -0800 (PST)
MIME-Version: 1.0
References: <20191128161718.24361-1-maz@kernel.org>
In-Reply-To: <20191128161718.24361-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 28 Nov 2019 16:30:05 +0000
Message-ID: <CAFEAcA8GvqnwfGiKHi7OgcUqUu1JL9UKTe6J77-VHMnzRpKX_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] target/arm: More HCR_EL2.TIDx fixes
To: Marc Zyngier <maz@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, 28 Nov 2019 at 16:17, Marc Zyngier <maz@kernel.org> wrote:
>
> I started looking the rest of the missing TIDx handling,
> and this resulted in the following patches.
>
> There is still one thing I'm a bit puzzled by though:
>
> HCR_EL2.TID0 mandates trapping of the AArch32 JIDR
> register, but I couldn't find a trace of it in the QEMU
> code, and trying to read it seems to generate an exception.
>
> It isn't like anyone is going to miss it, but I wonder if
> it should be implemented... It could also be that I'm missing
> the obvious and that my testing is broken! ;-)

Hmm, I was under the impression that we correctly implemented
'trivial Jazelle', but we obviously missed some of it
(we do have the handling of BXJ insns).
We should, yes, ideally, have RAZ/WI implementations
of JIDR, JMCR and JOSCR.

We also I think don't get right the fiddly detail about
attempting an exception return with SPSR.J set, but that's
not worth messing about with IMHO.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
