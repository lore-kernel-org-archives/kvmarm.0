Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BF1C2D0C6
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 13:57:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ADA820706
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 13:57:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yeaXDVs8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ADA820706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D374AF46;
	Fri,  6 Dec 2019 08:57:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kt0p8ttSDBE5; Fri,  6 Dec 2019 08:57:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5E14AF37;
	Fri,  6 Dec 2019 08:57:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307034AF17
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 08:57:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u+rImFVtbJtH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 08:57:02 -0500 (EST)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64A554AE9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 08:57:02 -0500 (EST)
Received: by mail-ot1-f66.google.com with SMTP id d17so5886264otc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Dec 2019 05:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6WfAA5W8BZkXD9ffx7UeqY8vIew9vi7Mn2RNb8mbH2Q=;
 b=yeaXDVs8v83FYKp/axfTSvAXTIYXbQKoBS3/0CvvtI807zf0TKZ4P1LfXqCWc/788w
 sUNd3V6t9UvVUeAYgHXRucfCT5ZT3OMxIHA2zOf1OmUxpSyk1UD8A45qKpDn+XaWK8s0
 wu9v0Sk+jFqmFG6oCAwOQ4q/AdgrAERZ9K5NrcTyVS0Ip1uBH7N4Ny1/ulYqZkuV2Ety
 Fb6STJpKI8RUgeh401W1L6Tu2azdHn6f1SCWAXPgyl8kEhY3NaFhJI2zUTB6vdY/fVlA
 pKJoBJ3Q+jYEpoW5GttQUoB9+HB8TQkE8MLneQGAt/qfBFddhkEjZT7tlhqugIEhN40E
 5pzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6WfAA5W8BZkXD9ffx7UeqY8vIew9vi7Mn2RNb8mbH2Q=;
 b=LNkxoUYs2Y9in4sbVu7vyoEpOFb2ntV2xkS/6tFLVRl2E6mRPKju4vWp8fDV5eRDel
 6/DI40KjcvNWFN17IpyGsZtH1wAq4j3sGJ32sZ0vUBzrFNAFlAfSet6jsPeDuo6ydqU3
 7Md4SWiWqUHtVb1pAtKKRVUqE5w5wQxnE7WmXGwdbBif8bBjPsIRCXOKcVdPjHMXwIYG
 flNe3xFyW+dcLt6bJ6aU/wGaBIxjMiR2SywM/rM6oQZ1eNEQQoqCp39+NGq7yqivIOQK
 Sv6WBPw2BN1HQ+0NkcHS2eKUpyKYn5Z/rKdyV0ZoZU0UNrqrtWnAlQPJmKUM4WLaTUrF
 dA+A==
X-Gm-Message-State: APjAAAXxUrFa9QzuDKKF8xoTbqWiYtLwfIztFsUyZX4DPM/1dp7NafwB
 sXZNxx7Y5YzLHTZSlYN7+COu5Y6MSm+3lPGzJipLcQ==
X-Google-Smtp-Source: APXvYqwf+2IoMlq5ZuCeWxiAi+OGyYXw+F8XkRm8Om33qIWxjKTR1d+07NjLkldp1XuE3YL2LQpe6AzmwGdnuJY5umE=
X-Received: by 2002:a9d:12d2:: with SMTP id g76mr11381867otg.232.1575640621933; 
 Fri, 06 Dec 2019 05:57:01 -0800 (PST)
MIME-Version: 1.0
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-6-maz@kernel.org>
 <27089f4b-5bd3-04a9-9c16-91474a225c45@linaro.org>
In-Reply-To: <27089f4b-5bd3-04a9-9c16-91474a225c45@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Dec 2019 13:56:50 +0000
Message-ID: <CAFEAcA-oqASZ1N0q1F5qn4a6y3f+3=nMZo=Cb3EXU0LYt16xYA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] target/arm: Add support for missing Jazelle system
 registers
To: Richard Henderson <richard.henderson@linaro.org>
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>,
 Marc Zyngier <maz@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 kvmarm@lists.cs.columbia.edu
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

On Mon, 2 Dec 2019 at 15:58, Richard Henderson
<richard.henderson@linaro.org> wrote:
>
> On 12/1/19 12:20 PM, Marc Zyngier wrote:
> > +    if (cpu_isar_feature(jazelle, cpu)) {
> > +        ARMCPRegInfo jazelle_regs[] = {
>
> static const.

If this can be static const we should just declare it
at file scope. The only arrays we put inline in this
function are the ones which need some non-const
fields.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
