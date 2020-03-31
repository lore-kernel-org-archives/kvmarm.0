Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7438C43331
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 11:18:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3ED7620772
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 11:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcmSm1fz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ED7620772
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D624A2E5;
	Tue, 31 Mar 2020 07:18:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6qCdWf4u0EBs; Tue, 31 Mar 2020 07:18:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A6544ACC9;
	Tue, 31 Mar 2020 07:18:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EA814A418
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 07:18:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NKx0G2IVX977 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 07:18:04 -0400 (EDT)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
 [209.85.208.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78E3C4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 07:18:04 -0400 (EDT)
Received: by mail-lj1-f194.google.com with SMTP id p10so21319798ljn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 04:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to;
 bh=nQSLmyc/1TYfDE79XCh4E3URoEM1KZdp90U8gKRTd1E=;
 b=BcmSm1fzLtK4jN/aM5jNNy1E9h1UtMVyamJlRBx72dTObj8Mu9XVSAEDkqzvNaqvsJ
 LR9kkrIM+zH9l/NUnLnWjIQ7pwptPZJJ+SYWrv1f+VMobb2KDOJQHvgn1BO4yFEecpHs
 A4tt3Oqg7jMW0K0ZF7NLWtiYaPIbTCDuHPhS0yEFqx+wFROszgjuCoqwoHkGjkQlGC/p
 oIhKQH2oxhyvW1bHMyCQmJLoWJ5me4NS3qe9WhnNd2UvhE0Csjz9Xp33Tg0uqzA0U1pl
 CtrTtrlobZavqXKjCSzTp3fl+8iSGaI3YTzyfUTCn/SwFqGu7uLet2zmG8tYivPHj1ph
 KbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=nQSLmyc/1TYfDE79XCh4E3URoEM1KZdp90U8gKRTd1E=;
 b=KzSjJppTk8CEWD8xUBFV3zD4QvTR5e2nhbprfpOthPRhyG0i8bOPyyf23gxVUF6bMc
 dwqblpxuaWM8kORgJjNO8yXepcwKutw0et13sJs3BUL8NWIUvhShCXgn+izpvAbSB70j
 klA6Gfel05E+dR0TM7s9UOSa3Dyk3EEJhYu7HdnZIiC1tbxffMdzRdjZTBZqN0UNJsMR
 yeMD6YMYSg1NbS50NCbX6/fd6Awb2j/p5broGxsVmPE2npYo3kaPGt5Nb/6QnLBh1856
 SzwrimStC1jdU9lFIZoOE6/OlRTGYaTerUdXCuP/+ZmY7MNPXIgtJsPVz974uNP6cSSE
 50YQ==
X-Gm-Message-State: AGi0PuasFT74sXCyJ36jMtsWScokrNStqSxiDxADoKhwH+jnPALwyQYJ
 YSAX1XpTwGm/i5lpDnHAJH2UbSJOya0mTJbR0utMY8xM
X-Google-Smtp-Source: APiQypJJLhAprvkV4Y+on0qPbLSY34Y1aS+DSEN+h8i3jTtVSsXvZ1CGpXvnBYgI+JsNMUVp5xiZ+TrP0v+VoL3Ac8A=
X-Received: by 2002:a2e:914b:: with SMTP id q11mr9734609ljg.291.1585653482543; 
 Tue, 31 Mar 2020 04:18:02 -0700 (PDT)
MIME-Version: 1.0
From: Janne Karhunen <janne.karhunen@gmail.com>
Date: Tue, 31 Mar 2020 14:17:51 +0300
Message-ID: <CAE=NcrY4K-K8eWwW-8+8J8P2Wg3TnJc-TQko117X=aTy8bQFPQ@mail.gmail.com>
Subject: kvm stage 2 mapping logic
To: kvmarm@lists.cs.columbia.edu
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

Hi,

I'm experimenting with the kvm in order to see how it would work in
co-existence with a tiny external hypervisor that also runs the host
in el1/vmid 0. More about this later on in case it turns out to be
anything generally useful, but I've been stuck for a few days now
understanding the kvm stage-2 (ipa-to-phys) mapping when the guest is
being created. Things I think I've understood so far;

- qemu mmaps the guest memory per the machine type (virt in my case)
- qemu pushes the machine physical memory model in the kernel through
the kvm_vm_ioctl_set_memory_region()
- kvm has mmu notifier block set to listen to the changes to these
regions and it becomes active after the machine memory model arrives.
The mmu notifier calls handle_hva_to_gpa() that dispatches the call to
the appropriate map or unmap handler and these do the s2 mapping
changes for the vm as needed
- prior to starting the vm, kvm_arch_prepare_memory_region() is given
a try to see if any IO areas could be s2 mapped before the host is
allowed to execute. This is mostly an optimization?
- vcpu is started
- as the pages are touched when the vcpu starts executing, page faults
get generated and the real s2 mappings slowly start to get created.
LRU keeps the active pages pinned in memory, others will get evicted
and their s2 mapping eventually disappears
- all in all, the vm runs and behaves pretty much like a normal
userspace process

Is this roughly the story? If it is, I'm a bit lost where the stage2
page fault handler that is supposed to generate the s2 mappings is. It
was surprisingly easy to get the external hypervisor (with very
minimal changes to the kvm) to the point when the guest is being
entered and the vmid 1 starts to refer to the instructions at the vm
ram base (0x4000 0000 for virt). Those, of course, currently scream
bloody murder as the s2 mapping does not exist.


--
Janne
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
