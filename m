Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D44C2D0DB
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 14:04:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CDCD2083E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 14:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="warS5U3j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CDCD2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0130A4A800;
	Thu, 30 Jan 2020 09:03:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ni5A9vUBOMVZ; Thu, 30 Jan 2020 09:03:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E51774A968;
	Thu, 30 Jan 2020 09:03:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 436E04A800
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 09:03:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oSA3q+DOZAlc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 09:03:56 -0500 (EST)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 161924A542
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 09:03:56 -0500 (EST)
Received: by mail-oi1-f196.google.com with SMTP id b18so3608835oie.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+iZsjgsZakLtp6vowX2UviTy1HwcCzzv58SPakeE/f0=;
 b=warS5U3jI+nfBBZmMjN08U3zX3wbr/EKi7+YEZsJGrKnozxfcDtDdi0vcH40pW8WyR
 xQ+1AQ4Ff7t7oM2xo1oV7qsKQYJxiYFQepPpwKR4efAO2vwGlkq7FvBku3WYhlaBrDz3
 zAhpoSqtFV07ErIufrfOEatB/PasVrVs56La7TuY1bM47GsPW8V6WUxtQqqTJlpOf5K4
 nO3ipDPX3TS7+1Y6sbCxkz2ojEKjMydqOe7DNmrpH5jigJfDnd9VmHIKplRA2KluT4Dt
 pjgC/SHVTxNTi2nXMVYMnhKWFkEPwn0lv+eY51pVFZKumES5ffItoGkJh4WzYpbIz1RD
 dllA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+iZsjgsZakLtp6vowX2UviTy1HwcCzzv58SPakeE/f0=;
 b=F08mH7i7QVnhBEotw8FkLiigFZO8tjIODlpkDzhBTJdl7eeixI/NotRWB4ziJwlkPB
 uqsUGox4ulY+GeFR3VAjTnl2SEMMBuiBiDrOAXrbQB78IqCGxWwWXZtes+8lGqDDxLSZ
 mxg/iMbPJdauG28V3ENoI/9uadPTWIYKPRXOep8oo4hztDLrQjyfy3h+VRwkhEfraCLo
 yP+5XKyS94xtCsWWQfOUgqsOOLDQSxCyQE2N5U+vNtPro7hJ0JOw0r9UjWpgFEeT2MmH
 a/i6MpjvGetpnlztQQRyU/+kJM1Punq+CGSyqoKRPXy0kAk+Xhl+ZMuZqsNZDRd/NQKb
 RmBQ==
X-Gm-Message-State: APjAAAUxUXfIIQPzZctjKQI4J1VL7EDGldLRPrc1SXLaqPq4OHwsBwx2
 RYi0bhP/XzYlJcaJhi7UI+ScWA4sCXjYV4Yk99jWVw==
X-Google-Smtp-Source: APXvYqzxvy87xbQ6kIC63XdTIzKDOn1YjfuQUR+7MXWG/OSk7jFKlCe8eE3Fa10ZTBOEHMhZ5zca3hH3eC6HaiM1Qf4=
X-Received: by 2002:aca:3d7:: with SMTP id 206mr2953620oid.98.1580393035139;
 Thu, 30 Jan 2020 06:03:55 -0800 (PST)
MIME-Version: 1.0
References: <20200119133051.642-1-yuzenghui@huawei.com>
In-Reply-To: <20200119133051.642-1-yuzenghui@huawei.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 30 Jan 2020 14:03:44 +0000
Message-ID: <CAFEAcA8igVrEjyChLmbkeQb+gXYMCVhtgGwrNNKrZNaKKSp04w@mail.gmail.com>
Subject: Re: [PATCH] hw/intc/arm_gicv3_kvm: Stop wrongly programming
 GICR_PENDBASER.PTZ bit
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On Sun, 19 Jan 2020 at 13:32, Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> If LPIs are disabled, KVM will just ignore the GICR_PENDBASER.PTZ bit when
> restoring GICR_CTLR.  Setting PTZ here makes littlt sense in "reduce GIC
> initialization time".
>
> And what's worse, PTZ is generally programmed by guest to indicate to the
> Redistributor whether the LPI Pending table is zero when enabling LPIs.
> If migration is triggered when the PTZ has just been cleared by guest (and
> before enabling LPIs), we will see PTZ==1 on the destination side, which
> is not as expected.  Let's just drop this hackish userspace behavior.
>
> Also take this chance to refine the comment a bit.

I pulled up the original code-review discussion where this code
was added:
https://lists.gnu.org/archive/html/qemu-devel/2015-10/msg05889.html

It looks like the original reason for adding it was that the
GICR_PENDBASER.PTZ bit is write-only, and so there's no way for
the migration code in QEMU to accurately restore it on the
destination end of a migration. So Pavel picked a heuristic
for guessing what the right value of the PTZ bit was.

It sounds like the penalty if userspace sets the bit to 0
always on a migration is not significant, so I guess that
just setting this bit to 0 always is an OK thing to do (as you
say, there's a window in the existing implementation where
we do the wrong thing sometimes if migration happens at the
wrong time, because the current code's heuristic can
sometimes fail in the wrong direction).

Applied to target-arm.next.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
