Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A8DECAAD5
	for <kvmarm@archiver.kernel.org>; Wed,  7 Sep 2022 02:00:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0124BDE1;
	Tue,  6 Sep 2022 22:00:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eOIFLZwUhhaD; Tue,  6 Sep 2022 22:00:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3474BDED;
	Tue,  6 Sep 2022 22:00:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 207284BDED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 22:00:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l9YSzFdO7AqV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 22:00:27 -0400 (EDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com
 [209.85.217.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F6DA4BDEB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 22:00:27 -0400 (EDT)
Received: by mail-vs1-f53.google.com with SMTP id d126so13467809vsd.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=wsARz19b+rqPn9IK6GAlYftVxiNnl8OSsSaYZNoi6rM=;
 b=Fjf1quEBH87cQ2lo1jAZw8/pXBsxTTFmjB4Du1roRZT2tFwQC1LGAhv7wb9ecLlDbZ
 4WLHqzeKZ39AwmJOoYrHzI3/hI+v1SXBe7g8UEm2x3mQllXU2MH80Ux/HuU927Sitouy
 Z2nhmfmrdHiLM8g0yiZrt9SnygUkclEnJfBSZ0aqRfxF3tkSOyfFd4jAkiINg7vQ4wbr
 qeQz6r2AmY+GGLoam41+4s4qc5hrcE+t5o2rLIo/JO3tEXwslAGOxdW9smgZ2JWx9JMN
 QwMtsW9LKWiHLrEvQaJd02SrlgpqZblqxlErh8Ty1Q7B7G2/200GHLi/c/1oxK/1nGSy
 97XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=wsARz19b+rqPn9IK6GAlYftVxiNnl8OSsSaYZNoi6rM=;
 b=HBT2w6q9D/U8esZscGkb4uLaqMAUGCRDf6kZMYyf4XJRHM0P//kqqtkL8/n+sZsZxX
 2GeZPHqMOaDWNltLo8mKUtPbRKZvSiZRnC6aak+4sL1MSJTB+tjhGuN0rwW1O2JbAb1F
 DB7VC4j94PF0fYMLAoUEqHWWxNzclYBy+irJAlxWgG5and+jG1yZXOsy83Ulzl3zBlUx
 d77OUJDXO1PLOQdtAeIsEFqYy8NKxRq4PSHiA0JjGkisp0yk8KqZFXTQ2YX5sCFUSOsh
 x9s8pYBcKZYR3aLqM2xNMiXcXob0xW+XWwHT8KSg+UKpuqkrNY1VaFEcQgkyG6JSQ+Gc
 +ylA==
X-Gm-Message-State: ACgBeo2g3euQ96z8xpeZv/D/r/q9n2q8n2rVQmNuP9w6UdZxKeGESE1g
 JowjGANouFyBX7wE2WHo+RvnNapXARExnr/whTyKNQ==
X-Google-Smtp-Source: AA6agR72eSD2FyY1WmLUjqFEq/K1rYb4p3qgCXjKN6DF4JjBjQeIvq0s2+BMqLmG4qdAmVkQp095RHnNT+lmfmMtrks=
X-Received: by 2002:a67:fdd0:0:b0:397:c028:db6a with SMTP id
 l16-20020a67fdd0000000b00397c028db6amr450011vsq.58.1662516026551; Tue, 06 Sep
 2022 19:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
 <20220902154804.1939819-3-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-3-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 6 Sep 2022 19:00:10 -0700
Message-ID: <CAAeT=FzjL=iPEO6FeHLTzHX5V4snoVOWVx27oeShHQYRi6HeAQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Remove internal accessor helpers for
 id regs
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
> The internal accessors are only ever called once. Dump out their
> contents in the caller.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
