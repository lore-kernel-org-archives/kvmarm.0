Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D397C38145
	for <kvmarm@archiver.kernel.org>; Wed,  7 Sep 2022 02:27:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9C94BE4C;
	Tue,  6 Sep 2022 22:27:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wD9QJAapfT06; Tue,  6 Sep 2022 22:27:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A374BE3D;
	Tue,  6 Sep 2022 22:27:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 293EF4BD99
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 22:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pZRvSPl2GCfK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 22:27:01 -0400 (EDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com
 [209.85.222.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4605F4BD98
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 22:27:01 -0400 (EDT)
Received: by mail-ua1-f45.google.com with SMTP id s5so5021395uar.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 19:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=pwFmJDralQuPsmi85jLOaYYTf896GNyoxThIcLObtQo=;
 b=S8+67QypVVGymC9ftQWRJdOke7mKZuzJ7mL7uh7aQwMhTkXAEdk9XP41Xtc/TMPvZ2
 2lMCGni0hc6PcLRnNJGshXz5QTRCHY0LGATJ/zkPG/BvszgifXhkL2bqvXkQm1BjGy/n
 z11SvT+yVZVhdHwSO7WwieIIv4JgwBZKLzvm7nf3bxdwmuCgJDTPnI0pimU3VEgbBhID
 xEooM2SKmB1yR2MkNHAQn9mT10e/ZNfUs0Ssp3iwhMgRsLM3OgX829fUlyiQFN0/su+/
 UOojUS1V0RAJOFg2SIMKBeVzAA8syDcJTUlzcMBEfBMDEw1rQICNYgWYI0vTDUkQ53+d
 kKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=pwFmJDralQuPsmi85jLOaYYTf896GNyoxThIcLObtQo=;
 b=V5FYJcZ73viLOMTgFf1g1yGYun+tAtBaTP3WDS/zay6dYeNgP+n/vgX3nsrE1okChR
 NLCRUFZUnK4HwtCJgBPEdXWKiaUEbZBFd5xkFswhEL9FRrSYhXJGR02Ytg/Pebo0ytIl
 DXiz2w3snNIjUBJ3p9mtos/nQUl+Bk2AuQQDhPBYaF451D63bT5TpCVMUg6uEbcFoHVd
 ByFiz9Cd/Q3wXmVMaw8CqgN+rAFSN9/XmTK6K8/xl5GoIlQxJklvwJCaUA7d7KuRScAc
 hihTRkku5zdmA8h5n5LZZf/SdSlbwHZP3bNV4+iKj2w/KajFxCyXc0WlIPJrFG+lpga4
 qG4Q==
X-Gm-Message-State: ACgBeo1d1j/40Kh3sADR49drTVrxgOb5LO26EPoRpL/vVwuEk6F6+L/s
 b//wrV7tVOrG50vGxORPo5d5OMue7xtSjUoWD0HCEg==
X-Google-Smtp-Source: AA6agR4L/Ysf4UGfyY06Bl3A9WStVJxvIZauMf63xBjr99mNZgT82Ya7oDQb9CC3wQhnwu5zpxtEQTfvTq/gCnw1GMs=
X-Received: by 2002:ab0:13ed:0:b0:39a:2447:e4ae with SMTP id
 n42-20020ab013ed000000b0039a2447e4aemr462462uae.37.1662517620579; Tue, 06 Sep
 2022 19:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
 <20220902154804.1939819-4-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-4-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 6 Sep 2022 19:26:44 -0700
Message-ID: <CAAeT=Fz6mFGB5kT18Z3B2YXuCY41DdCOQOTJcdRzp-zgj=rOfQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: arm64: Drop raz parameter from read_id_reg()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 2, 2022 at 8:48 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> There is no longer a need for caller-specified RAZ visibility. Hoist the
> call to sysreg_visible_as_raz() into read_id_reg() and drop the
> parameter.
>
> No functional change intended.
>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
