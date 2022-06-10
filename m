Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88B2C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 06:13:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0E64B3B1;
	Fri, 10 Jun 2022 02:13:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BpP2xMI4oXUC; Fri, 10 Jun 2022 02:13:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A8F4B39E;
	Fri, 10 Jun 2022 02:13:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69DF84B399
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 02:13:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wcJRVhiOKTEW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 02:13:38 -0400 (EDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 741944B29D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 02:13:38 -0400 (EDT)
Received: by mail-oi1-f173.google.com with SMTP id y69so20685233oia.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jun 2022 23:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gpIjTUIy/sYUCUxAj7KpvSMIco0OqPienYjZRuLvs/M=;
 b=VAfU23ocUGTYC2vy6DVxgSaoiUC2MRx7bj2MyyD6z+lrcKLSm719EmdaWBW7dwDBjF
 5mXbB0fh8uPL4ElnsiDw9xOWC7VIQVSmO0IH7CWA7XJb2Te5NrGiNDvqu87pyJBsDCQI
 +CD0jwICLt8uwtntWgx5e/SXA2AvuqNzMHiz3wvYU3AjFpXUGzrdZDAOTpYHFXsnINHR
 qn2hL9eQfopRDxHYzzRzaNUdxChfJMb5ZmdByP+PMOlRsXHM+PQmdsRVDqR/YgHipTI6
 9+u/0+xd3C8k0gpB7b6qEfuEdcMc423hszvyJmk5S8l4dRzDlpC0ctZR7wd4/u8holCl
 wevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gpIjTUIy/sYUCUxAj7KpvSMIco0OqPienYjZRuLvs/M=;
 b=QSgtIhZNpbz3FT4wLIjgQ8wKbDgr8VFshgkQXcMSXeZQbLKSSdX4itqMpbk7fAu6Eb
 K2QLyk5vj5uDovdCgRs63CK+LvDuSGTE0XARbhJHsADfdjVhwZwvgZvEexTzDdCHhUMQ
 zoJcbLANsxPSrLTgu/vGWYjc/H4L44vosqOo7BjXUs+1CPh81jV9U1gmJth8JyajDC2e
 pxFdSjME6qiSY9Ps4HInpk1zbuNWqdujGqeTuyBUW8Obj+/By+ruBYXfsCPytsplz9+m
 4m7I5AH1pqtJbyMJ7wXY689JveyhNUR4rtPYMxleCLbjWxHsK7ShYmwL0HRXnYXDw0X/
 7g9w==
X-Gm-Message-State: AOAM531rOdOTYIHuNjnQjvzY2zZrx1MlPlktzCsWrc7Hq1EU/587ye2f
 dYgR4ih/o0Rhk12aeVWQLKwOnrv1dN6n62qFJxBJHA==
X-Google-Smtp-Source: ABdhPJxvHBDy+GsUTZeTF2opWbpTgXcsvwdl4BgLSzULzLgn7eCarwu0mJbV3IEMC7FZ98AK5iwyyqEDRasTsWl7QHI=
X-Received: by 2002:a05:6808:144d:b0:32b:7fbc:943d with SMTP id
 x13-20020a056808144d00b0032b7fbc943dmr3713078oiv.107.1654841617628; Thu, 09
 Jun 2022 23:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-9-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-9-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 9 Jun 2022 23:13:21 -0700
Message-ID: <CAAeT=FyfKbubGTFpssRq1KoAs=Fxu2jZjFSbYCm85X9Zk-ZWbA@mail.gmail.com>
Subject: Re: [PATCH 08/18] KVM: arm64: Move vcpu PC/Exception flags to the
 input flag set
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The PC update flags (which also deal with exception injection)
> is one of the most complicated use of the flag we have. Make it
> more fool prof by:
>
> - moving it over to the new accessors and assign it to the
>   input flag set
>
> - turn the combination of generic ELx flags with another flag
>   indicating the target EL itself into an explicit set of
>   flags for each EL and vector combination
>
> This is otherwise a pretty straightformward conversion.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
