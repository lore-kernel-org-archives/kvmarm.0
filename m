Return-Path: <SRS0=sT9x=ZS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665CAC432C0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 12:46:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E721E2071E
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 12:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OwxcLR3X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E721E2071E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 382FE4ACBE;
	Tue, 26 Nov 2019 07:46:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dlBlp6XImZNT; Tue, 26 Nov 2019 07:46:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 289444A8E0;
	Tue, 26 Nov 2019 07:46:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3464A8E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 07:46:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FFnED4holw-n for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Nov 2019 07:46:43 -0500 (EST)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C21D14A7F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 07:46:43 -0500 (EST)
Received: by mail-ot1-f65.google.com with SMTP id c19so15727291otr.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 04:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HJOgI7Fkx9fkZmmYIqDXFqTNTL2Dsde/US2qZ7f/uac=;
 b=OwxcLR3XpXnjPB31Zc5NzrdXvJw/jIqskulrp1cQ8FcmuG1DZNhZyQJvLfEVMRRpfE
 fkIkzEiuIrdb9UYE2b4q/6XwVwoi+fH/HwScwk/rn2KzfFYM+ODxBTgeJKUUlbBCI07/
 OFVsnRVeAmBhH3j/a49OMpTv+74AxToDwOyYlz/aYAGQnqDP9jdNMzi2/wN2+XO/sHuY
 Pb4GiMz5GAdvCPfkCOX7RaepABtlYZrh/zsPqLNT/oa0dy+jBPfrTcW8e76kXxvTVIDM
 4TtcBh3zxxpRyLsuqd/ZP185irwlJNVHOcFBWFOtG/JslEWRgg2fRzt1XX4Gd1+5QNaG
 iSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HJOgI7Fkx9fkZmmYIqDXFqTNTL2Dsde/US2qZ7f/uac=;
 b=rfPzcJnNJ5jA2dTyFSeVdl0IsBJZ9vsj8ll8tceLYW4Lq2wT0N2X4UHpcwixr6fTv7
 tVCgkE4+nfjgN/5dx1ogfdWwQCTtEOXGEiR676bnqvUCPVT0f10yMSbzBZd7mZfX7gih
 7oB1v1yYGZvnhzCvRo1KPIPSwu7+V14BL3Y4S5sEBfKUC6dLlaKpv7HYMPmbZF5pCXlZ
 y0RDXI8SJrUPqjYYufMJOz1LgBUwEu5kiPZLeDrjLmzn5TdV0QPitd8yD+V+kS7mOEbu
 g3eY+a4aQRoc/T8i3vi4r0X1QgCiJFbDrrf9m2Ube5lgOttbmCVw4ib/pK2sqCIhQh/L
 XviA==
X-Gm-Message-State: APjAAAUPkLifm2UDhfH/He4eXSw1Ht97/DEVnhLzDpn/Go7rk4CN2Jlj
 9WwNUTcJnY8sHBph8tyxAWiR+WVNtU4hC2+KFSLqrw==
X-Google-Smtp-Source: APXvYqyuIPQDk7G6PQKTgCF+tzo2CVMn7YI29fNWYWLJgA2fUpG9fbZTs0uTA6UV5GDXf3ED1kxS6uZZwWUjEN8BDbg=
X-Received: by 2002:a9d:6357:: with SMTP id y23mr2263272otk.91.1574772402970; 
 Tue, 26 Nov 2019 04:46:42 -0800 (PST)
MIME-Version: 1.0
References: <20191123115618.29230-1-maz@kernel.org>
 <CAFEAcA_MQpJ=8UFnP=Qnt+4GWMUO_AtJBBNz-bM2L2wf5htuaQ@mail.gmail.com>
 <4d8c4763da39d5bfb1800735f90d82d1@www.loen.fr>
 <CAFEAcA87ceF_0ifLn1t9CxyEwJ-rwW8h4QauJGk+ATphJaWa6Q@mail.gmail.com>
 <15acc2b5111716b10ab7624a1ee45ce7@www.loen.fr>
In-Reply-To: <15acc2b5111716b10ab7624a1ee45ce7@www.loen.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 26 Nov 2019 12:46:32 +0000
Message-ID: <CAFEAcA9nPgELq1A0JNrb330kD6qkXFrNvK0BjRwVG+ryfk4kxQ@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Honor HCR_EL2.TID3 trapping requirements
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
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

On Mon, 25 Nov 2019 at 17:49, Marc Zyngier <maz@kernel.org> wrote:
> I also had a look at TID0, but couldn't find any of the Jazelle
> stuff in QEMU...

We implement only "minimal Jazelle", ie the minimal set of
registers needed to be architecturally compliant for an
implementation without Jazelle.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
