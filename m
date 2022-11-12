Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13985C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:01:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E95A4B6E9;
	Sat, 12 Nov 2022 03:01:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6L+IvClVUh-C; Sat, 12 Nov 2022 03:01:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811D14B7F0;
	Sat, 12 Nov 2022 03:01:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E424B7ED
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:01:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4PFoG3yd9KQC for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:01:48 -0500 (EST)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB38E4B6E9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:01:48 -0500 (EST)
Received: by mail-pf1-f169.google.com with SMTP id g62so6730559pfb.10
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=j7VZmjwtxmbTDgJG6yNy/NKZz0sCcAw91UAS7XNqqYU=;
 b=bpxwH/fsUWb40bD9Q3Zy01qs7U9eWAv1qNXbpwt51L21rpaRtLIEo8HIrWFdyzP4yL
 /zfNHocVpNHojMyhwgBgHy2szKnLMNF+RPhb9+6X7Mmz1XkrbHeq26Xl+crefpHvPBTj
 VZUOK8XbJ9QmuEWAjz94L45bEGdyvvlB3TEcSpfgnZsYH2lZ+QDrbdn1Y98qdDvq4WQr
 EtbFfoSn9+SDw60SOPYvBtOeI7s2U8ZGPeC2io7bRxTQyUQ6sC57jNdMZlg71ZfjNhQX
 2N5YW0rhU+GzqFbSMwjsYC6AnR7719veX3hI6FTd+js+hw7ZsrZf4vYAG1+uJd18gLmN
 BNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=j7VZmjwtxmbTDgJG6yNy/NKZz0sCcAw91UAS7XNqqYU=;
 b=lIZ7wZCBOh+9y6t/2IoOlurHVZv3TBpAKSEhiXrXMt1md4HlGmsWzkuEjiiCvKZ+Pk
 uBbPRdQgR7Xq9mKV7fmvl1h6k8jF6G+dyxCkRTzdHdPsNMbf26wVD5cU6prb7g+O/M3M
 uiq8UegQzoyRHdRhqxnBQcJEHl5ydF/hX60MNYVB+UA90wNCTdJ0HqJ9E9iaE6qwqgEr
 I3GvEYl9Q+nrrWOuIcWK2VKMzrhEzQ4N5TC86BEoe5yDHKV2XUVgof+z8x/3eg859saD
 mMBHlVfh3RO+Z2NwPLmjT4TQQ7/LA4zjugJ09zJ4sL3C+FhHqm9p9OhNr2XtSYpniuhD
 z/cg==
X-Gm-Message-State: ANoB5pm2a0JyLZp3RNjHvzF7TNBglWb0dtABeCHUdVptMKU2sQ39Zhh1
 jJqVAx9cEzkBP4RCUbdgFF2UkjRXd95fByWzMbRLzw==
X-Google-Smtp-Source: AA0mqf74mZ/Q5PIpOqoIn8jOkWvbTBKBd4IOdrQQX67B9+okXa8HRPAozoxqlNHz6mFBRo8PFEWGE7yhXHYJs+AwBLU=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id
 x33-20020a634a21000000b0046f0d9f0476mr4521743pga.468.1668240107535; 
 Sat, 12 Nov 2022 00:01:47 -0800 (PST)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-4-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-4-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 12 Nov 2022 00:01:31 -0800
Message-ID: <CAAeT=Fxs3ScU8oDtevsuG+7QH7Dyh8Gm0h+m+ibCmaFQ3LfL6w@mail.gmail.com>
Subject: Re: [PATCH v2 03/14] KVM: arm64: PMU: Always advertise the CHAIN event
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

On Fri, Oct 28, 2022 at 3:54 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Even when the underlying HW doesn't offer the CHAIN event
> (which happens with QEMU), we can always support it as we're
> in control of the counter overflow.
>
> Always advertise the event via PMCEID0_EL0.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
