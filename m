Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5749DC432C0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 07:34:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE5A820708
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 07:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iMxHXeZL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5A820708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E37354AEC0;
	Fri, 22 Nov 2019 02:34:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NdCNhPI8rJ5o; Fri, 22 Nov 2019 02:34:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F55B4AEAA;
	Fri, 22 Nov 2019 02:34:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91F824ACB8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 15:17:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mwz+JvbhsHEG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Nov 2019 15:17:15 -0500 (EST)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
 [209.85.208.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8904E4A591
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 15:17:15 -0500 (EST)
Received: by mail-lj1-f194.google.com with SMTP id q2so4699174ljg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 12:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:from:date:message-id:subject:to:cc;
 bh=5mgJC093r+n2ha3eZi7CwoIqJtWi8hIhxEacvrOtxLY=;
 b=iMxHXeZLSN/opBP6eW8zqafc22N90TicVceZhG/xZQGRqcViUrmu4dLLk7ju3Ykmhv
 F0CaqPyd9Pr/Me0m7qq6XuNQD7e7wJpZz2RU9D4IgupgQtBxcr8gIo4gdHdCbLpSzuCc
 3YkDB05rIa39+jfbZqmTB4FlaU3+ycSQsYD64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
 bh=5mgJC093r+n2ha3eZi7CwoIqJtWi8hIhxEacvrOtxLY=;
 b=gXf4rTNtQ2MJm/qLbyhQDMzLfBijxJcUnBZdgOTTpjf0OKZ+G1mtnqmHDU29Vznidf
 wOk+U6BPkHV9lSAQ13/U7IzgWm+6PEMow+vM3QC8f21ME2KQ0d4ZxjBC3f60wTyzjtR5
 e6IIF2KzmC5r4GMrWdAfGLMvJfIasm74SpkKeAet/riAbF/rXOjDKv1yR7lNW/XUMN9F
 GjhzS4ge2LyGqiHaiPupljCsRL0VuJt5FllXmG4XDBpRS0nC+tHhG44vnnSxxQ3o4a+e
 uNwG4+NBegjipdxAP7ynmKdnMNzPlFVsZq9I6iOeg5rN7Lx4ToLCLTp2kF8fLtORBtt0
 pl4A==
X-Gm-Message-State: APjAAAXRDPpHJGbyd5jgiu8uhPLdBvwN2oZtNlLDz9ul3G4qz6IUAfpG
 R8BxDKow9C+jbby+7Rc1XfMmbdg4sFI=
X-Google-Smtp-Source: APXvYqybkPnqnlzLvuzgcnV5S0dsVl+AsGQwWmR1OByhInMcPq7HRsGfKOjAnQAU2Ng/PESwPAe8cA==
X-Received: by 2002:a2e:8e27:: with SMTP id r7mr9542942ljk.101.1574367433881; 
 Thu, 21 Nov 2019 12:17:13 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com.
 [209.85.208.180])
 by smtp.gmail.com with ESMTPSA id j8sm1778408lja.32.2019.11.21.12.17.12
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 21 Nov 2019 12:17:13 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id g3so4654355ljl.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 12:17:12 -0800 (PST)
X-Received: by 2002:a2e:3805:: with SMTP id f5mr8951812lja.220.1574367432482; 
 Thu, 21 Nov 2019 12:17:12 -0800 (PST)
MIME-Version: 1.0
From: Daniel Verkamp <dverkamp@chromium.org>
Date: Thu, 21 Nov 2019 12:16:45 -0800
X-Gmail-Original-Message-ID: <CABVzXA=DGxc4eE0RQX=tGu3QAYQ0RmEL7Y=WZYWBr355zEp_vA@mail.gmail.com>
Message-ID: <CABVzXA=DGxc4eE0RQX=tGu3QAYQ0RmEL7Y=WZYWBr355zEp_vA@mail.gmail.com>
Subject: KVM_COMPAT support on aarch64
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Fri, 22 Nov 2019 02:34:33 -0500
Cc: Dylan Reid <dgreid@chromium.org>
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

Hi Marc,

I noticed that in recent kernels (4.19 in our case), KVM no longer
works for 32-bit processes running on arm64 machines. We
(Crostini/crosvm, Linux VM support on Chromebooks) use this KVM_COMPAT
on all arm64-based Chromebooks that support VMs, since our entire
userspace (including crosvm) is 32-bit.

I found this commit (KVM: arm64: Prevent KVM_COMPAT from being
selected): https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=37b65db85f9b2fc98267eee4a18d7506492e6e8c

Is there any particular reason the compat ioctl is disabled (e.g.
actual bugs/breakage), or would it be possible to re-enable KVM_COMPAT
for ARM64?

In my brief testing with a 4.19-stable-based kernel on a new arm64
board, everything seems to work fine with the commit above reverted.

Thanks,
-- Daniel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
