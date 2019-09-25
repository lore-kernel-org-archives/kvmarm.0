Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56ADBC432C1
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 06:55:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD86A217F4
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 06:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD86A217F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=patchew.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF9F4A657;
	Wed, 25 Sep 2019 02:55:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sq+GfLxjhZe3; Wed, 25 Sep 2019 02:55:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 839714A658;
	Wed, 25 Sep 2019 02:55:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D894A658
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 02:55:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9lVIjEgUgci8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 02:55:24 -0400 (EDT)
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com
 [136.143.188.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5720E4A657
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 02:55:24 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; t=1569394499; cv=none; d=zoho.com; s=zohoarc; 
 b=G9fwlLYhaCLgMp4Wfx8ck+IPbQ7Puhu10Gba3XsosLq/2xcQVJZFO+CDcZynGncYl3PpY+cqYwXY5Dk5+3YoCDTmSUdjn4SEex/Ek4AojODKApmK1AKSSDlhhM4lSb0IwX+H5hBUI53h8eBF9CjjmPT7A2dLJrdHurK6ZhnLUlk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com;
 s=zohoarc; t=1569394499;
 h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To:ARC-Authentication-Results;
 bh=oeqeulBf4Vwbu+50L48ehygqO8U7uSyqvJgVC9qTLRw=; 
 b=WmnqH0n+vesLrDZWLG4nHEZMjGLHX+7C7UMQZEcdQQOUgR5mKKR/Q8A7zOvtWQ7hmbFu058UPp8SvAednFyZKGc9N55d6FmzJWuOzE4i7ko9cH5lRAVxOXdeeOa7XSXtKJ3WA2912OIz+NW5fVxjQ2P1GWW3fCRym4reqpVe8WE=
ARC-Authentication-Results: i=1; mx.zoho.com; dkim=pass  header.i=patchew.org;
 spf=pass  smtp.mailfrom=no-reply@patchew.org;
 dmarc=pass header.from=<no-reply@patchew.org>
 header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by
 mx.zohomail.com with SMTPS id 156939449744494.24444381336264;
 Tue, 24 Sep 2019 23:54:57 -0700 (PDT)
Subject: Re: [RFC PATCH 00/12] Add SDEI support for arm64
In-Reply-To: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
Message-ID: <156939449538.4188.158567627991892527@8230166b0665>
MIME-Version: 1.0
Resent-From: 
From: no-reply@patchew.org
To: guoheyi@huawei.com
Date: Tue, 24 Sep 2019 23:54:57 -0700 (PDT)
X-ZohoMailClient: External
Resent-Message-Id: <20190925065528.59D894A658@mm01.cs.columbia.edu>
Resent-Date: Wed, 25 Sep 2019 02:55:28 -0400 (EDT)
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

This series failed the docker-quick@centos7 build test. Please find the testing commands and
their output below. If you have Docker installed, you can probably reproduce it
locally.

=== TEST SCRIPT BEGIN ===
#!/bin/bash
make docker-image-centos7 V=1 NETWORK=1
time make docker-test-quick@centos7 SHOW_ENV=1 J=14 NETWORK=1
=== TEST SCRIPT END ===

libudev           no
default devices   yes

warning: Python 2 support is deprecated
warning: Python 3 will be required for building future versions of QEMU
cross containers  no

NOTE: guest cross-compilers enabled: cc
---
  LINK    aarch64-softmmu/qemu-system-aarch64
hw/arm/virt-acpi-build.o: In function `virt_acpi_build':
/tmp/qemu-test/src/hw/arm/virt-acpi-build.c:810: undefined reference to `sdei_enabled'
collect2: error: ld returned 1 exit status
make[1]: *** [qemu-system-aarch64] Error 1
make: *** [aarch64-softmmu/all] Error 2
Traceback (most recent call last):


The full log is available at
http://patchew.org/logs/1569338511-3572-1-git-send-email-guoheyi@huawei.com/testing.docker-quick@centos7/?type=message.
---
Email generated automatically by Patchew [https://patchew.org/].
Please send your feedback to patchew-devel@redhat.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
