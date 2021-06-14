Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F7DC2B9F4
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 13:38:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE354611CE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 13:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE354611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D38A4B090;
	Mon, 14 Jun 2021 09:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vgklekvfsqlU; Mon, 14 Jun 2021 09:38:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D1A94AC78;
	Mon, 14 Jun 2021 09:38:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 827EB4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 09:38:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UXrEoZr+Lheg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 09:38:50 -0400 (EDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57B914083E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 09:38:50 -0400 (EDT)
Received: by mail-lj1-f172.google.com with SMTP id r14so20112115ljd.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 06:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jwXVBisdJjThQGclWp6IXCFWn4jZGyH9ozIVniD3KMs=;
 b=Sfnahi+pG4f+QayKKfpg1VM9f1f/aavyhFB9lV4TW7kVp8kgwXwutKZgf8qxz/lUHO
 lMF1eyk+OUeIfEflL2EVp7oOntvNTW4LR2xdgfo10unS7HOrbD/JfqvVvE65tdtNURq3
 cWjf08IDH/DHN/POTRHR+exPljpQFlQagIGlpaFpZGCbIGxW37FFXdAJ24/hrWm4l1f2
 3S+64Qxp+3t/WL/Nkn6sjpuboNlGonNj//y/G4zguiIgohLGREJhMkKuaVzxUvB3Vpm0
 66uiv+f1PifS8I+j8o9hts2k1EwrzNpReCSpsWIPLf3JP/VAkc3BYSjJLmrmllFTpLpo
 pDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jwXVBisdJjThQGclWp6IXCFWn4jZGyH9ozIVniD3KMs=;
 b=B3Up+0Y8TWS5DSh2QbqTinhJwwPUmPB77s8iy5Bl2hbWz0fZ0PqD2PYkFNnT3/00W3
 Ws3zO+qeIs/riwFWEK1eOfXnlEYTrxphah0GiwXehnvgcCN4z4VeIJNMcrnqVQ5NZjUv
 aPgHW/YuzUUcBa6fGcJdzLVNdbP4cz3u+aQXBSikAwO4ZMNiALuCRnFVwoqxu4Rn+RDO
 PuSrdrYv1iicV+GpMPDRIfM9aBdvoJPiJtLxfZeSkscQr3+SJx9rvjzBPZZtJ33Ketyz
 KrYnPSdYGBQpcZQFr0m2NbkFp5f+KTfaAP/1C4SZbTfrtPj0ytGQM+o0LIAdbTGFMhQR
 2Lgg==
X-Gm-Message-State: AOAM533klrMW4x1Bg4UPsDUyiHexyqLG1VfVY8DiDhtL53f6ZzZUYGcW
 WZi23s6C0yxNtIeIvzw+Py5i8Ucn751ayTtl3bH6fQ==
X-Google-Smtp-Source: ABdhPJxvc1pwRawgj0zOcL4Ijt7TpwUjNPqVQwwwwNAeptDw/nWdJwRIpcLx7ajZLxmfXVy2goAh+tpIPcpdk7YzAj8=
X-Received: by 2002:a2e:9b8f:: with SMTP id z15mr13317109lji.304.1623677928539; 
 Mon, 14 Jun 2021 06:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
 <dc48637c-e683-a64a-b744-bd5fe2037f31@redhat.com>
In-Reply-To: <dc48637c-e683-a64a-b744-bd5fe2037f31@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 14 Jun 2021 08:38:36 -0500
Message-ID: <CAAdAUtjxXmN0cG9EU55Pd1TFuED-itoUJQECv3_ab=8imkxMtQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Remove duplicated stats definitions for debugfs
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LinuxS390 <linux-s390@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

On Mon, Jun 14, 2021 at 4:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/06/21 04:53, Jing Zhang wrote:
> > This is a follow-up patchset to binary stats interface patchset as below:
> > https://lore.kernel.org/kvm/20210611124624.1404010-1-jingzhangos@google.com
> >
> > This patchset contains a commit to fix some missing stats and add static
> > check to make sure we have the right number of stats descriptors and add an
> > 'offset' field in stats descriptor to make sure the or order of stats
> > descriptors is not relevant to the order of stats in vm/vcpu stats
> > structure. This will totally avoid the possibility of missing stats and
> > mismatched stats definitions.
> >
> > The binary stats interface defines stats in another array of descriptors,
> > while the original stats debugfs interface uses array of kvm_stats_debugfs
> > item. To remove the duplicated stats definition, this patchset would
> > utilize only the stats descriptors to provide stats information to debugfs
> > interface. This patchset adds a 'mode' flag to support the read/write mode
> > of stats, which can be used to indicate the file permission of debugfs
> > stats files. It removes the usage of kvm_stats_debugfs_item and all the
> > debugfs_entries defined in all archs.
> >
> > The patch also fixes an issue that read only stats could be cleared in
> > global level, though not permitted in VM level in the original debugfs
> > code.
>
> Thanks for putting this together quickly.  I think we can drop the mode,
> see the suggestion in patch 2.
>
> It's probably best to fold the v8 for the stats functionality, these
> patches (squashed appropriately) and Fuad's remars in a single posting.
>   But I'm quite confident that it can make it in 5.14.
>
> Paolo
>
Thanks. Will drop the mode, squash stats functionality with v8 and fold them
in another single posting (v9).

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
