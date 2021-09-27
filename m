Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEE9C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 16:40:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17B0F6113D
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 16:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17B0F6113D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 862AE4A3A5;
	Mon, 27 Sep 2021 12:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sjj9a1BYTzpm; Mon, 27 Sep 2021 12:40:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AA7C40762;
	Mon, 27 Sep 2021 12:40:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F1740762
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x644mJgmY9O7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 12:40:07 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BDF94057F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 12:40:07 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id u18so53084247wrg.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 09:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uBxEi6AYAf/IDfN1v8J251RrBh4CFzk1e5mArk5PNvU=;
 b=ShmHcW7/EwN9y31VztAl5sWbgy+qbrOKhzAJBDeQTwUbLr3EqJa1zCP54fk27oJaHN
 nX+uDlhxuiJm3MuzUgDfp71rKNZvZ/NtJgJoIXrNrdO1oET1vtkPUCJFKKuxcfL8Kd9r
 9pXlnfVc5BbCh9f1BDvaKpeLDgurgmakIcGdrEJt87/+j7UM2g/CJGgDD7aJQz60TKkw
 D2LnDAOLUSm1coZM2D8JKP+EklxtaxFNBRJkjvZzmhDBc8X374FhqrUFYc/mz4WbES3t
 YNN1I+kET1+Jp/qfcCwCE5u8Mu+wX/3NCdC6+iqAiUdPwtk043eGTxBDETr8YPgo4a85
 +beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uBxEi6AYAf/IDfN1v8J251RrBh4CFzk1e5mArk5PNvU=;
 b=dgaKUuAeMdPlnygbeUtTpTBe2DfHF6U8Nsm4HTvSLTNo19XqnKqlxt61HSMzmHYQhN
 D+YJJhUsq67eecwxwdkRFkNe8QYnQ8GxulR1oBHKkYja/9olWE6xVfYsgCWkgd/V80Wz
 LL1ahPuzDCwE3WyqOQ0QouhU1wQXa0q+ggrO+MC7GVYk4be7BzBywdHMDGSdGf19lRUt
 tvu9kHJBU1Nf26jMwE2jlKlPju/oTstWXLkCcAIuvccVMPNkgWY1PmEyfVNJhYh9xbxv
 f8OBCeB7sapWzx8UMXczBgTcJboCGlTL7TMKRsdq8CAEbCcelBQawNjcq2Pjc9mEsBNZ
 LSyw==
X-Gm-Message-State: AOAM532ekKrnHX9hdAkEsxn64W0aja1mIFeUIh6zn44i3VOZXDCOBvtq
 Z5UNijgMaLkhwcuTGdq432+5kQ==
X-Google-Smtp-Source: ABdhPJxeIsgFjgYqOUquyC+YdPRjFg7ImEHfUd+nnFiThBHOZhs4dFClXfQIVL5NXC3K9mRijFdtDA==
X-Received: by 2002:adf:f48b:: with SMTP id l11mr977771wro.254.1632760806108; 
 Mon, 27 Sep 2021 09:40:06 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:fa68:b369:184:c5a])
 by smtp.gmail.com with ESMTPSA id x4sm18967wmi.22.2021.09.27.09.40.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 09:40:05 -0700 (PDT)
Date: Mon, 27 Sep 2021 17:40:03 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH v1 12/30] KVM: arm64: COCCI: add_hypstate.cocci
 use_hypstate.cocci: Reduce scope of functions to hyp_state
Message-ID: <YVHz48IuvHsHRaiG@google.com>
References: <20210924125359.2587041-1-tabba@google.com>
 <20210924125359.2587041-13-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210924125359.2587041-13-tabba@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Friday 24 Sep 2021 at 13:53:41 (+0100), Fuad Tabba wrote:
> Many functions don't need access to the vcpu structure, but only
> the hyp_state. Reduce their scope.
> 
> This applies the semantic patches with the following commands:
> FILES="$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arch/arm64/include/asm/kvm_hyp.h"
> spatch --sp-file cocci_refactor/add_hypstate.cocci $FILES --in-place
> spatch --sp-file cocci_refactor/use_hypstate.cocci $FILES --in-place
> 
> This patch adds variables that may be unused. These will be
> removed at the end of this patch series.

I'm guessing you decided to separate things out to make sure this patch
is purely the result of a coccinelle run w/o manual changes?

It looks like the patch to remove the unused variables is a 'COCCI'
patch too, so maybe it would make sense to run it here directly after
the first coccinelle run, and squash the result into this patch? The
resulting patch would still be entirely auto-generated, and wouldn't
have these somewhat odd unused variables. Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
