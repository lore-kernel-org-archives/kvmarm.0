Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77319C43334
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 04:34:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD16F4BD83;
	Tue, 12 Jul 2022 00:34:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LBpmiw7zXF88; Tue, 12 Jul 2022 00:34:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B94B34BD5C;
	Tue, 12 Jul 2022 00:34:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909C44BD5C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 00:34:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QE4kTeyFAzKi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 00:34:54 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F48E4BD5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 00:34:54 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id 185so6754835vse.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 21:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2G5DDdHN65V5QCqoc0hJXGvC6ZBJU+ZGuB0i5a889f4=;
 b=gKNWeGGUaQbxlF/L3rMRsDc2PhkbPzfLIFYAaRskfX4H9ypCvtdaYj7/rKQhk/y48h
 I9lsunvlZ8+Lsu86JBzxKJe5GniCyQfdac1lq2hTuBzxAoTfRHSK175NJBKZgkCrvwyy
 /fqzEh4zeK8tI+doDU04fUKl72XtLDsWx5ynhU4LGDzbrFRmTg08uJpftEIy0LvmD7kI
 Mt65vAQGOiFmtOSbRMChgtjfNLKh3JwhWghlaiHIDe7oLuWsAWGMd7F6JfLWV5nPMZ7I
 0HV4q6xtkcGn760H6Yzh1D8/YeEliuC+WIcHceUIlzzqF+Qizo3ER3AZJgR61gErc0Dm
 HmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2G5DDdHN65V5QCqoc0hJXGvC6ZBJU+ZGuB0i5a889f4=;
 b=jbZ9evtFBiBwgpG2qZAwuUSJglcnunR3D+KO5eSy6j8fFQ5OWKqaLNqG719UtscMJ9
 JU/w6+2LpWmRJVFOQDkz/Aybajykwk1e68zo+ayyVxGqp2yQiuZ+YBM+ZztZ/Qocbrwu
 iOVvLN9CxedrOdfI2UEZsIt6A1I8J2GrFEi7G420Gw+QEKl4G3NpHDi6L+RjHmocyIQG
 PcEF2jiwP3u6f81GlDM5H8CR/l+DMkjkmi3wbyaL3wUo++/c3yWBDnt8ZO8ILo0OQQ+8
 nd0jYp6DyD7PzysxfhD1Wvi8+IVfCmhEQvPB4ku3qmn6Lwq+aY3yqrG23MSmcDgrX5WK
 rxpA==
X-Gm-Message-State: AJIora8/UT/d5LyPcHcw+Qs1ad6K67VT2UBSKNE8eqHr4yRRJxHzYfRk
 Q1y1fA6P3FlmAvTwMcr170Wz/rF28RxKe5lhMINBcQ==
X-Google-Smtp-Source: AGRyM1vFWfnJO1N1oFZN8adTtTYjnWcRgKILoGUSyraLENahV/H1J4Vhbb0NTk1cOJ+a1timJoWqAJKzx/qEXEuDLsY=
X-Received: by 2002:a05:6102:2126:b0:357:6663:a469 with SMTP id
 f6-20020a056102212600b003576663a469mr2533719vsg.58.1657600493938; Mon, 11 Jul
 2022 21:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-7-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-7-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 11 Jul 2022 21:34:38 -0700
Message-ID: <CAAeT=FyqHFciAqBtD4K1-HFW4nefBovRyLX6uv=31sGsGk5ufQ@mail.gmail.com>
Subject: Re: [PATCH 06/19] KVM: arm64: Get rid of reg_from/to_user()
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
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

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> These helpers are only used by the invariant stuff now, and while
> they pretend to support non-64bit registers, this only serves as
> a way to scare the casual reviewer...
>
> Replace these helpers with our good friends get/put_user(), and
> don't look back.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
