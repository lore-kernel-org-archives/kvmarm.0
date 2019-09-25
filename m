Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC9EC432C1
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 06:59:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13E83217F4
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 06:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13E83217F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=patchew.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 944B44A658;
	Wed, 25 Sep 2019 02:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2NTGuwQHmEHc; Wed, 25 Sep 2019 02:58:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7DB4A69F;
	Wed, 25 Sep 2019 02:58:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2504A69F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 02:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hkdypUtI76TL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 02:58:51 -0400 (EDT)
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com
 [136.143.188.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E47054A658
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 02:58:50 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; t=1569394700; cv=none; d=zoho.com; s=zohoarc; 
 b=d05H5eQZTfn/gVOC4Wf3VXBQClUQL55Tsdly/85GattlAAHwpF/uqSfiHjFveYZLWObcGPUm9w7QsRA0YymVEG+f+E1AUeLEyIKDLy+oGOD8ri1WKUZyQmN+0CHGkFdsOlFXyCTSjCAkB9RMV/6SP69J0B1rZYZUSg353VqzbUA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com;
 s=zohoarc; t=1569394700;
 h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To:ARC-Authentication-Results;
 bh=OuuvftXiZpEYTEx33ue2LCEfHJMeIVr9mOUMhJPV78Y=; 
 b=byq5MDNSx2YkRS19wMpHq8c0/GRqYQMT2dEWS6vZ+luz2tzWp99LjmkddzQ6BjfzsGgheMfC3UJMMGUPlxOXB3XC1kYYpQtIzU1dUPA1U3eOC7o7I1UY9uHKtv8kVbh6Kb71p2IkIWliek9VZdF9CWw14u3YG69croJifCjaP54=
ARC-Authentication-Results: i=1; mx.zoho.com; dkim=pass  header.i=patchew.org;
 spf=pass  smtp.mailfrom=no-reply@patchew.org;
 dmarc=pass header.from=<no-reply@patchew.org>
 header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by
 mx.zohomail.com with SMTPS id 1569394698476125.88900174032096;
 Tue, 24 Sep 2019 23:58:18 -0700 (PDT)
Subject: Re: [RFC PATCH 00/12] Add SDEI support for arm64
In-Reply-To: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
Message-ID: <156939469669.4188.3839690402456058930@8230166b0665>
MIME-Version: 1.0
Resent-From: 
From: no-reply@patchew.org
To: guoheyi@huawei.com
Date: Tue, 24 Sep 2019 23:58:18 -0700 (PDT)
X-ZohoMailClient: External
Resent-Message-Id: <20190925065854.DF2504A69F@mm01.cs.columbia.edu>
Resent-Date: Wed, 25 Sep 2019 02:58:54 -0400 (EDT)
Cc: marc.zyngier@arm.com, qemu-devel@nongnu.org, Dave.Martin@arm.com,
 qemu-arm@nongnu.org, guoheyi@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: qemu-devel@nongnu.org
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

Patchew URL: https://patchew.org/QEMU/1569338511-3572-1-git-send-email-guoheyi@huawei.com/



Hi,

This series failed the docker-mingw@fedora build test. Please find the testing commands and
their output below. If you have Docker installed, you can probably reproduce it
locally.

=== TEST SCRIPT BEGIN ===
#! /bin/bash
export ARCH=x86_64
make docker-image-fedora V=1 NETWORK=1
time make docker-test-mingw@fedora J=14 NETWORK=1
=== TEST SCRIPT END ===

  CC      aarch64-softmmu/hw/arm/tosa.o
  CC      aarch64-softmmu/hw/arm/z2.o
In file included from /tmp/qemu-test/src/hw/arm/virt-acpi-build.c:35:
/tmp/qemu-test/src/target/arm/sdei.h:26:10: fatal error: linux/kvm.h: No such file or directory
 #include <linux/kvm.h>
          ^~~~~~~~~~~~~
compilation terminated.


The full log is available at
http://patchew.org/logs/1569338511-3572-1-git-send-email-guoheyi@huawei.com/testing.docker-mingw@fedora/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
