Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7964CC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 05:31:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D67214BB55;
	Sat, 19 Nov 2022 00:31:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J5Gp-G3nxHgL; Sat, 19 Nov 2022 00:31:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B984BB51;
	Sat, 19 Nov 2022 00:31:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD544BB51
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Nov 2022 00:31:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hotPttGjBE4A for <kvmarm@lists.cs.columbia.edu>;
 Sat, 19 Nov 2022 00:31:29 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CD4E4BB49
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Nov 2022 00:31:29 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id 6so6728370pgm.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 21:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=zA4MvfCx2wJ6ZC0yAwP3Kt5ez44MPaUUZGSZKLr05qU=;
 b=OViBe7Prr+WNneb+sFV50YXvGDB4BUPrIn0sCBrBFXjV6NuqIO2ITUpTAlVzYbM7fO
 A2NsPkpnPIkVBi71AwoceBT1dirH64Fmm0AM4Nrsa+IICdwYwARgMzukzOL+fAt6Dtkm
 ksr8oomCuHB4tc4g3EtEa8lIMU6XqB00JEOmWX2+atzDS/GVF/qn2JDIiljMGhHhmOVT
 6y8QjZuX1sqbBa0vzK6yN1SMxvRYk+xaGlRfyihgQDBBDVBI+z6m4wtEBvla+Bw6Lmnw
 iNvg9CkwSxC/yrVNd4VW4qTS6S8pJoKg5vt9rUisCnSNnTyh/bah2l25GOT2XjCjt7yr
 1M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=zA4MvfCx2wJ6ZC0yAwP3Kt5ez44MPaUUZGSZKLr05qU=;
 b=E9ow39kSkQFq//5jtFurosPdq41uz/eDBeQ7a78Wns0f/eXWTI+x9pep7jY6oAce55
 rGeEnEkc5SQkhUwb3ZuzSHrgLhdPsit0eQne1LtF0NLhUoUwN/rjdP+kJFO5dKv19N+s
 TandOLaHpL36CkhHmOSQqChLqczZPlQVQLbFAMrRZXDXcvsREqEG0WL0VN82uCFtL5Ci
 8fDw8RpkczwuKkBFOzes8HLc+O2pqIY2Fcusq2fEW6xFcC0ZeI8o27dfFHTRck74ONck
 fzHtgwIpYXg9YSkk3DgGoca8xOLpJI2uysn5X2iQeowQTzflDNNyQ1sQ3JrqI/vvymwf
 jfIg==
X-Gm-Message-State: ANoB5pnEv8bRByDf1wvigEBdnvH3RXEXaATCCeImKWBvLZOqUJqQtvLf
 JcBwhGFxCyl/G9T4nwl2J9i4LHwkCB9Vu7D82J6tFQ==
X-Google-Smtp-Source: AA0mqf6QqOtcX601H4y3vkSngjFJKCDeIT0BRH0yTFy+3iR7DMokQILefhm0heQeNptOQNwem6K9h6J9RMChIkJjll8=
X-Received: by 2002:aa7:80d8:0:b0:56d:98e3:4df8 with SMTP id
 a24-20020aa780d8000000b0056d98e34df8mr10899836pfn.37.1668835888263; Fri, 18
 Nov 2022 21:31:28 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-12-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-12-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 18 Nov 2022 21:31:12 -0800
Message-ID: <CAAeT=Fzn2znqPRTH6TE_NbgD+OF8oLcFX5uooZ3Svn-OgBa7Gw@mail.gmail.com>
Subject: Re: [PATCH v4 11/16] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
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

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
