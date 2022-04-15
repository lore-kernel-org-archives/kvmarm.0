Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92E3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 20:19:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB8C40719;
	Fri, 15 Apr 2022 16:19:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o7o10xfTGTJC; Fri, 15 Apr 2022 16:19:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65FC40A84;
	Fri, 15 Apr 2022 16:19:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D62840719
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 16:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G3k8oQiz0xEo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 16:19:18 -0400 (EDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88042405C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 16:19:18 -0400 (EDT)
Received: by mail-lj1-f180.google.com with SMTP id bn33so10531737ljb.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 13:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Cr58g6CfShtXO0vPAwUW4nrK3WFLlKprChO+5HKe11I=;
 b=pTQCdrK4nxKkRj5ZtnKlRQMEdwyiG4IxvjveFI+rN+RlG9us7lR4w3qho+5DXLr8YE
 4k5XDSqOYwkEHvEyokqgTPRA5Uo19tN2y3SIs8CTw62wMHAlr9X+pakIqMqsrEaBMtNJ
 PLq0jBQ0MPUGOHpGv6ylkeFpMPdyESc8sFmJCgWM/YcG1TBzostMsQd4S14vFj5mYwhh
 6ri3ijo80wBGP+Y7PMQs9e/vEKhW+pF1jxz2CUwQMZov/huko3a1A3JNyCVE0FL1vPF9
 eCUt0iFpIMZGGGvNtfcTOEAn+gMgQrVn5faLTtDTj5OkwOvEJSwVGkYBzrqZXATBIj58
 gbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Cr58g6CfShtXO0vPAwUW4nrK3WFLlKprChO+5HKe11I=;
 b=leWDP9B/hIvHlH/iXSk+2oIugZ5qnt07C8ZxPmoWSDuGO3c+JoYA66OtVUzfU/0BFi
 ByrcHm9wf6/aJmOatJXnkYZfenmuWZkFoLguczOFvwmEiA/Hzm1y1m/vm+y4BTc6ucSY
 K42y8QtvpEc1wjDcMMrlrCQTe1J8k8GDpCgxmLW52dz46nfqo3dUaaw5T3KLWNzwmRJW
 VUENcpivjmNQVDZVw4luzAIgQTwqpuB2OgJkyeDiRLAogT9Hhx82BOwbuXc8Qqy2Qy1d
 FwN3+LOW1pIwHLM3Yn0p+yvqSAlJBJQyoA6t9IjjQKHoaxebmbvR3KXb9nYuHejP5Mf0
 8aSg==
X-Gm-Message-State: AOAM5307SBRxIIAWnnFFTe+UJ8jFq9Kg2oBZCmsRe/qIWW4XdHOUfk20
 E3+Zm28aQICTPnGBCTMnVzSsOZtSqrU3YJUyiZ2D5g==
X-Google-Smtp-Source: ABdhPJxJiO85Bos5bUVj8dUf57mGhlYFxUljrowrHyO+zNoS7Z3hSAeRAnEnr/34bYX+3RQ00o2tlVFUXYQMummUeg4=
X-Received: by 2002:a2e:998b:0:b0:24d:a08d:8933 with SMTP id
 w11-20020a2e998b000000b0024da08d8933mr409178lji.170.1650053956782; Fri, 15
 Apr 2022 13:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Fri, 15 Apr 2022 13:19:05 -0700
Message-ID: <CAOQ_Qsj+Zq5J=ox9PT8qBeyzgLap9=a451FdDHr6p41LhcyzeA@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: Clean up debugfs+stats init/destroy
To: kvm@vger.kernel.org
Cc: maz@kernel.org, KVM ARM <kvmarm@lists.cs.columbia.edu>, pbonzini@redhat.com
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

+cc the actual kvmarm mailing list, what I had before was wishful
thinking that we moved off of the list that always goes to my spam :-)

On Fri, Apr 15, 2022 at 1:15 PM Oliver Upton <oupton@google.com> wrote:
>
> The way KVM handles debugfs initialization and destruction is somewhat
> sloppy. Although the debugfs + stats bits get initialized *after*
> kvm_create_vm(), they are torn down from kvm_destroy_vm(). And yes,
> there is a window where we could theoretically destroy a VM before
> debugfs is ever instantiated.
>
> This series does away with the mess by coupling debugfs+stats to the
> overall VM create/destroy pattern. We already fail the VM creation if
> kvm_create_vm_debugfs() fails, so there really isn't a need to do these
> separately in the first place.
>
> The first two patches hoist some unrelated tidbits of stats state into
> the debugfs constructors just so its all handled under one roof.
>
> The second two patches realize the the intention of the series, changing
> the initialization order so we can get an FD for the vm early.
>
> Lastly, patch 5 is essentially a revert of Sean's proposed fix [1], but
> I deliberately am not proposing a revert outright, in case alarm bells
> go off that a stable patch got reverted (it is correct).
>
> Applies to the following commit w/ the addition of Sean's patch:
>
>   fb649bda6f56 ("Merge tag 'block-5.18-2022-04-15' of git://git.kernel.dk/linux-block")
>
> Tested (I promise) on an Intel Skylake machine with KVM selftests. I
> poked around in debugfs to make sure there were no stragglers, and I ran
> the reproducer for [1] to confirm the null ptr deref wasn't introduced
> yet again.
>
> Oliver Upton (5):
>   KVM: Shove vm stats_id init into kvm_create_vm_debugfs()
>   KVM: Shove vcpu stats_id init into kvm_vcpu_create_debugfs()
>   KVM: Get an fd before creating the VM
>   KVM: Actually create debugfs in kvm_create_vm()
>   KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)
>
>  virt/kvm/kvm_main.c | 92 ++++++++++++++++++++++-----------------------
>  1 file changed, 46 insertions(+), 46 deletions(-)
>
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
