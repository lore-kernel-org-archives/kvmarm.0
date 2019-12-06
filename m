Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8D9C43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 14:14:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF9A120707
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 14:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h9/iFhzn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF9A120707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CD34AF41;
	Fri,  6 Dec 2019 09:14:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DgAHCIC1ntto; Fri,  6 Dec 2019 09:13:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 337824AF39;
	Fri,  6 Dec 2019 09:13:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D6E4AF2D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 09:13:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-17WWD8KHwP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 09:13:56 -0500 (EST)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F2734AF15
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 09:13:56 -0500 (EST)
Received: by mail-ot1-f65.google.com with SMTP id i4so5914209otr.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Dec 2019 06:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sAwG1RdahKAAnevB5fnXeo19T4BGa6gPTGH93hfaZww=;
 b=h9/iFhzntozkFHkukFSX0Kb7aymZtALNeROIGrhqu81gy3LwYfJXHDuf/ymfvDMQGO
 4n8A6KNL8K5BPpH7zAfXi+cQFBZ+742OSQgY0XRPJtN4U00cf7rZx+Fbiwu5jlGBkBop
 G+XSPmj3Qpaxft53Gl1nzArHbZ0SJBcHUzL1H8GTivixhYvkwbF6KAoRGqtqZfHxSeg9
 CIRYpHWdBIW7oPJORN9r0+4bki2ouNTI/Zth2wlspsACJHF6MncT6SU9gdjppNAQpR/Z
 38g4aXS8ur2rshwALmHUug/adW2t9NMeccCYWIJkwShLvIu9A0KeTXMJopt1FyVMUETq
 NoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sAwG1RdahKAAnevB5fnXeo19T4BGa6gPTGH93hfaZww=;
 b=myLkiEfaiswcFh2nb3mHmnvjPykCsH/u/7h++0dDARx/zIxmZB9m/PmIOfklMGXL+R
 VrW0PmYfVZgBrukIydj9cxDOKGvS4eeDApkYolhBLq2GR4S0esjgsu7L9raJBweOmgew
 8gP1TkkMVA2CpKU1b8WGWjebRRAYpGZE3kvHyd4QMzTVo0FNRfc7gToKZkM+IkiDFSKK
 w9HWxLlIv3MaT8thQ8GWJ9aiQ8QkGlu8h1zjAfaPYeC/sdh8OR3Qxz4o7FdHZlUeSd3b
 HbDQPJmvfw3E/NNYxL+ofzjSDRUUL36H6NPonb3CnUi5Lg/ibXB0hBhiIdYPt7hFpFZ/
 YM5Q==
X-Gm-Message-State: APjAAAX/nUoe8nrYjR5HPOFVVbD7WDIE7WeqifQSKUqqUNBhoAlfg4Zt
 hi3LARbPSbFu2bizY+2Jly0s17l0qhI2mJXVQhGNcw==
X-Google-Smtp-Source: APXvYqwbA0R++xciQcgbFLyRMhfm9S1jgLftXf41A9mZ+0k3+h0K0Uy1L8rc0QwiBBkE/CrvLtXGQIZimKsFmk631ZU=
X-Received: by 2002:a9d:6745:: with SMTP id w5mr10591050otm.221.1575641635717; 
 Fri, 06 Dec 2019 06:13:55 -0800 (PST)
MIME-Version: 1.0
References: <20191201122018.25808-1-maz@kernel.org>
In-Reply-To: <20191201122018.25808-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Dec 2019 14:13:45 +0000
Message-ID: <CAFEAcA_XWvO4yhJzEaTGatTfqqjZ9u3cTd=eo1xaPszwEYpPkQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] target/arm: More EL2 trapping fixes
To: Marc Zyngier <maz@kernel.org>
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>,
 Richard Henderson <richard.henderson@linaro.org>,
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

On Sun, 1 Dec 2019 at 12:20, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi all,
>
> This series is a follow-up on [1], which tried to address the
> remaining missing HCR_EL2.TIDx traps. I've hopefully now adressed the
> comments that Peter and Edgar raised.
>
> I've also tried to tackle missing traps generated by HSTR_EL2, which
> got completely ignored so far. Note that this results in the use of a
> new TB bit, which I understand is a rare resource. I'd welcome
> comments on how to handle it differently if at all possible.
>
> Finally, and as a bonus non-feature, I've added support for the
> missing Jazelle registers, giving me the opportunity to allow trapping
> of JIDR to EL2 using HCR_EL2.TID0. Yay, Christmas! ;-)
>
> I'm now going back to kernel stuff. I swear!

To save you from having to roll a v3, I've fixed up the
handful of nits Richard and I found as I applied this
series to target-arm.next.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
