Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160E1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:26:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 973884C409;
	Tue, 22 Feb 2022 23:26:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y-a0duBDP74e; Tue, 22 Feb 2022 23:26:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63F714C40D;
	Tue, 22 Feb 2022 23:26:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D8B4C409
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:26:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m96TVdNLRT0I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:26:37 -0500 (EST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35D474C402
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:26:37 -0500 (EST)
Received: by mail-lf1-f53.google.com with SMTP id g39so28840165lfv.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yOltLgvWydYJnuxlrjEjGgkNtwI9hxevSNBMbT48H/8=;
 b=SYpmP1ZC2tgC7paSEX2fIpV2BtAUZawz2yf2FAiGukOiiL0SRuFr1l7EvgOzs+n4oR
 BFsMpJuyPQSUHmqN/pCHQ1sVZSGapkaW2maF/cYQ31gfZ+XuD3ktFlbV6mpg6cUYPCQK
 K9khJAsMnJ993egZlUrufCmtvmBs0f8a3oLpZpUJjBRGD1KRQUo1RpYI1GNb/rZmDTmh
 vkm2W34HDVBkhh89Qsw2EKEWN6S0HXYHbbkine7AYP4ivna9EJ/sZjs90ZaVbGkUNr9h
 JUNm3QXSrOz3qb+7o2gZE0PfBfSZz5pbE3Mb/Ii2SlODwS1SPskx9sNYQEi2LDWJoKrM
 cdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yOltLgvWydYJnuxlrjEjGgkNtwI9hxevSNBMbT48H/8=;
 b=7dSa3GUYndPpDK30jd/Vb8D9Ivgii8ZSNDeBIxCzUqd/9BEWMkOK2ZiFrRpcbv1AFf
 us22oQxNkFfgfb//lQyh4Qo3zOrp9oW0xCp9mK7LJcA0d8GkFCYrAGaiRx12dyKHn3UP
 eDnqDLSdEQpNPaS+18NFyqMzosI9RdOD5qTPjHm+2Po8PVAOMMV6Z4fcPxcAuZFMMBlT
 gEyoSmbsocNVAQjttXW69uCdu7as1BbM+bvTlE4figtMk93fR2jtMtodN2ivH1sxluln
 oVaKKAOC4CEXX2QvBNWHQF3wTGZVmV5jI2ciS8/LkG9cRx2nOY2bKg6WBep5M6MWVPmW
 h9jA==
X-Gm-Message-State: AOAM5313oN8b3/gX/lmq01oLa5NyqpbHuFvYFw3FGeFiu/2haHluguRq
 qlh3lWGJHy2RyhkeYC4gIf8dgBzmRoaFzKHyvnlj/3rcIpEBqA==
X-Google-Smtp-Source: ABdhPJxf7Q+4gkUMXOvi7QEX+M/rO9KOFlKgosrkBvNqawwd3HKljioKFtSDFciK2PxaAOqFDwN79l/mYSO9uQbssfE=
X-Received: by 2002:a05:6512:3455:b0:443:5dc0:a32d with SMTP id
 j21-20020a056512345500b004435dc0a32dmr18808231lfr.38.1645590395245; Tue, 22
 Feb 2022 20:26:35 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-15-oupton@google.com>
In-Reply-To: <20220223041844.3984439-15-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 22 Feb 2022 20:26:24 -0800
Message-ID: <CAOQ_Qsgw4oHAf84tjwn3aBWgiNGPT_CxE8AxRm4Sf+GTx5uUwQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/19] KVM: arm64: Raise default PSCI version to v1.1
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> As it turns out, KVM already implements the requirements of PSCI v1.1.
> Raise the default PSCI version to v1.1 to actually advertise as such.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>

Ah, looks like this is already in /next, courtesy of Will :-)

https://lore.kernel.org/all/20220221153524.15397-2-will@kernel.org/

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
