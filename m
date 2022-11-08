Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE5A0C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 05:36:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 193134B8C0;
	Tue,  8 Nov 2022 00:36:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 51S5+andP--f; Tue,  8 Nov 2022 00:36:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DACFD4B8C6;
	Tue,  8 Nov 2022 00:36:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664EF4B8BC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 00:36:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R04B6cya30JI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 00:36:54 -0500 (EST)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 319614B8BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 00:36:54 -0500 (EST)
Received: by mail-pj1-f52.google.com with SMTP id
 r61-20020a17090a43c300b00212f4e9cccdso16888477pjg.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 21:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=BySxdp/7FbkyS9rQ/+SYkYHjIbHSrwzWviAFRY2ZPdQ=;
 b=jlgow3Yb6SgeKXBbO3czTUh+xNvvjFHf5z9ViSJ61Te93gNnScVTxpPdHdT0l7k62F
 lMrHOG03BfSjw2UfLzDRH+RXS0WR4VTQobaYGOSlEeJAzgE29G9Fs3PTFtSoRNJ2lsDP
 rp0PpZoXb1pTQgLNwDewCRkXTSd0VD2UnGaEqh9OBYLx6U4QpTvTGuKtpRiWBAAdeDq6
 BupIKIXcNl5Jz9YKhzqCZK1Zqb6IeNpvb7fpbUcyQY8vS/dUjH/ef8j3NZEU1GlKSkJ5
 KtoaRb8jEUBKaeh9EDW7vyVfw83qUDyWWtZPLL7bbZyLBEvN6jw/u2ubAUqXn8x1atsw
 HieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=BySxdp/7FbkyS9rQ/+SYkYHjIbHSrwzWviAFRY2ZPdQ=;
 b=w2lzlXzyN4Q7cAoNnmacMR1ajekvyBjWuQB1kqGUBIkYjEXlPFDHYERPbdHgmj3dA/
 r+AZBmhRR6uRHNycgq7uRVQYU5LFBCZu6xjJL7LhGqBLDsJ5Y1bHPFE5DLuZsb4iNVxQ
 r8Zu5agFINQzlAvNto1fej1QmQ2CvqShwn2R8xa04ChgpZOejSdp2ycUUn5Q5CzMxt22
 wjXJ8e7/U+ikyfq1rDW+V7aCIPGPsd/POV2l7QBTsMBL2GKmo2xC6slL1wIJP0HOqRoO
 Z8dG/Vv3vi+bhXT8i6VlLBKy0eJaYf58bFBDqttXBcHgNn6YoOAwTkcFK3wz9mPIc03x
 N3fw==
X-Gm-Message-State: ACrzQf3gZHv+yvHNLxtmeLTvg4WFBj4D/zrxTfkwaQIJKIy3/qfjQDY3
 OWmeDH3zFB23TXIOBr3pMYzeiHDxVDQZk7lTiu7+3Q==
X-Google-Smtp-Source: AMsMyM5h/BK7dlR9tXFEYHomDewWZpzTj+DR/oCqXMDG+trxJqZakFJMlhmhsO/VcM4HGEgEalX+qA4zQQDUKnfZXJ4=
X-Received: by 2002:a17:902:7145:b0:187:2356:c29d with SMTP id
 u5-20020a170902714500b001872356c29dmr43846977plm.154.1667885812893; Mon, 07
 Nov 2022 21:36:52 -0800 (PST)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
 <87tu3gfi8u.wl-maz@kernel.org>
 <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
 <86bkpmrjv8.wl-maz@kernel.org>
 <CAAeT=Fzp-7MMBJshAAQBgFwXLH2z5ASDgmDBLNJsQoFA=MSciw@mail.gmail.com>
 <87pme0fdvp.wl-maz@kernel.org>
In-Reply-To: <87pme0fdvp.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 7 Nov 2022 21:36:36 -0800
Message-ID: <CAAeT=Fzgu1iaMmGXWZcmj9ifmchKXZXG2y7ksvQzoTGAQ=G-jw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

> > BTW, if we have no intention of supporting a mix of vCPUs with and
> > without PMU, I think it would be nice if we have a clear comment on
> > that in the code.  Or I'm hoping to disallow it if possible though.
>
> I'm not sure we're in a position to do this right now. The current API
> has always (for good or bad reasons) been per-vcpu as it is tied to
> the vcpu initialisation.

Thank you for your comments!
Then, when a guest that has a mix of vCPUs with and without PMU,
userspace can set kvm->arch.dfr0_pmuver to zero or IMPDEF, and the
PMUVER for vCPUs with PMU will become 0 or IMPDEF as I mentioned.
For instance, on the host whose PMUVER==1, if vCPU#0 has no PMU(PMUVER==0),
vCPU#1 has PMU(PMUVER==1), if the guest is migrated to another host with
same CPU features (PMUVER==1), if SET_ONE_REG of ID_AA64DFR0_EL1 for vCPU#0
is done after for vCPU#1, kvm->arch.dfr0_pmuver will be set to 0, and
the guest will see PMUVER==0 even for vCPU1.

Should we be concerned about this case?

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
