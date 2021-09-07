Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B44C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 22:29:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DE4D61156
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 22:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0DE4D61156
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C65E4B0A5;
	Tue,  7 Sep 2021 18:29:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UTW6UeKtiKIT; Tue,  7 Sep 2021 18:29:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78DB54AC80;
	Tue,  7 Sep 2021 18:29:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB75B4AC80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 18:29:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rAJ5jTr6EXf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 18:29:23 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 946CB4086D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 18:29:23 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id m28so787446lfj.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 15:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mLneQ0gyxHkkDtfnQOD0UsHJuuTR6tVk0d26lWCdN+E=;
 b=ilpTH5u3Qk+WishFjyAu6KuJqTJ09gPdjP8PRQUVAZZ8eHQKhJ2bCX/cXDHRP3gikt
 WPhA5uyLi+Kn864Yw/ptwhh4k8sZACwGNGzFACwidZrUdslXW5JyOEhGYPjMP8J4If1D
 +hdwO078kHDUEod1IiW+++jnRc2Wa2yTlsMX3E+3VP5l4QHx8Zmr8/DtxOr7s/aa5m30
 l5WI75VZ8VmlvyEE2xBy/9hopqcKSgUejybHURPW+Z9+lyyXGLw1mHtQN2rk9zAjV63e
 9VWf6KKIPgW5l77HdCxYUaKpHBEZK1EHJgBsgcOYxexJi/fzkcclBB9OuO47GMqszF5+
 2zrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mLneQ0gyxHkkDtfnQOD0UsHJuuTR6tVk0d26lWCdN+E=;
 b=ZlDOK3guEsOHAhBOB5x73IlkOl0uXXXcXje/2zYTtR/UeuGRCIG6fKpijtEJGJQZ4p
 shuhF4ZxpJENutgFCbm7v+FUQ4bs/Rd1X5gdlzDe2woqMKzzFM+laHRLWyU6l0tlVD+J
 JvWwMFEg8aesTDIJjLPUiix52PkH06XMPZT15enXsPznjWRjWhaSGRCxZG/By7dlHrUh
 YaaGE+9eZiGhV60WDGs4GuvLU81OiJ+GCg5ZgJMjRsWqIWHgI9suvMQbRx4msPu3L+eJ
 tvmpxfmTVrs1Fsq6fs/3uNkN7N0fwShMQfVe2uLl/+XqO6sl9FP9T1qVaS+m1HrmdEmG
 pv2Q==
X-Gm-Message-State: AOAM533nSjsLMnc/b3EovCM9mLa8WgKY1wBxsEYUq9wiNSH5zI3Q05So
 9Gz8IdKt9VDpmqo254lIxfvF8SxK6r/h1PthOP5jAg==
X-Google-Smtp-Source: ABdhPJy+3Fh2/TUVFm2riSjDONzsxcAbvhzevvTtD3GSMOgR57hNrnLarHgePQ+7B7Wi7nNxEH3/MU1B/tOUfL166CA=
X-Received: by 2002:a05:6512:36d9:: with SMTP id
 e25mr432276lfs.553.1631053761858; 
 Tue, 07 Sep 2021 15:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210907123112.10232-1-justin.he@arm.com>
 <20210907123112.10232-3-justin.he@arm.com>
In-Reply-To: <20210907123112.10232-3-justin.he@arm.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 7 Sep 2021 17:29:11 -0500
Message-ID: <CAOQ_QsjOmHw+545J0T9i-nWV2bVGGEwHq5SPVvBOM-SHMXpP5g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Add memcg accounting to KVM allocations
To: Jia He <justin.he@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Liu Shixin <liushixin2@huawei.com>, Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Xiaoming Ni <nixiaoming@huawei.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Jia,

On Tue, Sep 7, 2021 at 7:33 AM Jia He <justin.he@arm.com> wrote:
>
> Inspired by commit 254272ce6505 ("kvm: x86: Add memcg accounting to KVM
> allocations"), it would be better to make arm64 KVM consistent with
> common kvm codes.
>
> The memory allocations of VM scope should be charged into VM process
> cgroup, hence change GFP_KERNEL to GFP_KERNEL_ACCOUNT.
>
> There remain a few cases since these allocations are global, not in VM
> scope.

I believe there are more memory allocations that could be switched to
GFP_KERNEL_ACCOUNT. For non-pKVM kernels, we probably should charge
all stage-2 paging structure allocations to the VM process. Your patch
appears to only change the allocation of the kvm_pgtable structure,
but not descendent paging structures.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
