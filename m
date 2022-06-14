Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA143C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jun 2022 04:15:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0304E401C6;
	Tue, 14 Jun 2022 00:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IhZ8kTbhh8V2; Tue, 14 Jun 2022 00:15:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058C54B204;
	Tue, 14 Jun 2022 00:15:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73AAE4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2022 00:15:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 984VemZ5LU8O for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jun 2022 00:15:50 -0400 (EDT)
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com
 [209.85.161.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B9984B1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2022 00:15:50 -0400 (EDT)
Received: by mail-oo1-f54.google.com with SMTP id
 v33-20020a4a9764000000b0035f814bb06eso1549945ooi.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 21:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=c+Rp2RVEpu3MX7WeOUfPLY5BNmqBN8ySZmPahKyFmPk=;
 b=rwEWc6oeXP3pUzO9Q3sZp88gjVV6FWStAUQOC1b+N2itM3EgGqAcjQo4kdP9KcrnCp
 pqDV8WqpC6AApOglkZ9Sicp9anig7WyqXStHC6b2TFcw9GPvh3xS/MWlGwytIBDBiD8N
 8ZAIWeEXPPsT8yhbGlA8464ObjRwV/87RgaBtpynhwNZBLz/wpXJ3aVhI2w2wFtIaoCH
 BE55bc6IL4bUjBBiXT6kFZUdExMCHLUh7VsuOMTAjy+Gw28mk1WhwuN/11us7AYFtoaC
 y/4Y8sC90rlObTFXvlZjCa1yQwWKaUEl2DHhzkXBcS2X5mOUNtvLa1C9K7LSoam8idi7
 zaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=c+Rp2RVEpu3MX7WeOUfPLY5BNmqBN8ySZmPahKyFmPk=;
 b=jj6I3cwPf5asJp0NK4LqzKcu7gsUxez6uc+Pe0uNm7+laCgLh/hsVTZYfZYoMV2ZEf
 MlZLroILpb2KgQtq+hZaXUTV0jcnwUbfxv49bGVZ7K/3sBCQWWrBGeZZQImqHyzXkwhz
 3CrcR/fgzpfDlB8wSZZ6nRVZoDFsmsCcluwO19ngrZMNQufv6h9zH1GxLtahIlS8eSE9
 K6/s5ehaHlLNtqgBpWB+CBFtSi0JBd/T8hbY/hT/mgiF+89RMqdTTwbdKnthDl/piv1e
 79cNQ4/8JrSbBzthF9JRQIUOCU3lCcxAo0tn7u64cvxx+0ip07wMagVwG4GNb+0SdplL
 p4/A==
X-Gm-Message-State: AOAM533/6Am79A+i+Pffa14kaxJybyWB0U1S+mYYbEpMvCBzry8ms8C+
 pFRYa6YMGEqEyMGykJbxjMgakJKs5IprHoyaRZV7mA==
X-Google-Smtp-Source: ABdhPJypOZtefVLb22hKytzMlPi7WjxrWiezVIH5Yerm2RclFvxbaIinEfvYVAnXqJH/Nlpbh1vodkgn4diJAhYSnjE=
X-Received: by 2002:a4a:8c48:0:b0:41b:43c3:fa54 with SMTP id
 v8-20020a4a8c48000000b0041b43c3fa54mr1271721ooj.78.1655180149501; Mon, 13 Jun
 2022 21:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org>
 <20220610092838.1205755-20-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-20-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 13 Jun 2022 21:15:33 -0700
Message-ID: <CAAeT=FwuUsZSgV-tTBEf-V1vjjhvmFHSDzSMyVjWDQd+jdHf7A@mail.gmail.com>
Subject: Re: [PATCH v2 19/19] KVM: arm64: Move the handling of !FP outside of
 the fast path
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Fri, Jun 10, 2022 at 2:35 AM Marc Zyngier <maz@kernel.org> wrote:
>
> We currently start by assuming that the host owns the FP unit
> at load time, then check again whether this is the case as
> we are about to run. Only at this point do we account for the
> fact that there is a (vanishingly small) chance that we're running
> on a system without a FPSIMD unit (yes, this is madness).
>
> We can actually move this FPSIMD check as early as load-time,
> and drop the check at run time.
>
> No intended change in behaviour.
>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

For patches 9~19 in the series,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
