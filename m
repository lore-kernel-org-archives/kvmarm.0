Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422ADC282DD
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:27:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B14DF20880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A2QtCdQQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B14DF20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6014A47A;
	Sun,  7 Apr 2019 21:27:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yWqcP3i2EnAs; Sun,  7 Apr 2019 21:27:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3910E4A3B3;
	Sun,  7 Apr 2019 21:27:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6AA84A389
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r49VxG4iFBkT for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:27:45 -0400 (EDT)
Received: from mail-yw1-f65.google.com (mail-yw1-f65.google.com
 [209.85.161.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D63384A379
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:27:45 -0400 (EDT)
Received: by mail-yw1-f65.google.com with SMTP id w66so4369650ywd.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id;
 bh=gMClCoGru9SbxhXyYZVyCMVONtLpGHa2M0yJ+er1miE=;
 b=A2QtCdQQSFDU4f21dwX6N79T3jCPQF4Hl46wepGY/kgsHKCgyN3BqiZ4C6rZmzJb31
 cJ4G0Eirmq4Run87mh+cYOA9RdVF8kU3IMzCHvWobwxKT5d7daXNZjldNBGKpgftBkCW
 fn5vsbAfRp6H/ktj/pNb/XEOOk1spGSHW1AyZyjFdiO1Y60ODrBHIFUW95tofMZq7mWF
 guVHiT2Sb4sdIVbdT9lN6ydtDfpAWZyJUYUOdpi+8RVyCY5/kMyFPSRayuNOqqbBvPuM
 ENAu9Tixxmrtz8Qr7pduDB2yoEF8FNFaFKr9w4cckUpU6GPlMSgxDRW6TpJW/ZQfxZDs
 34cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=gMClCoGru9SbxhXyYZVyCMVONtLpGHa2M0yJ+er1miE=;
 b=ZC8W7yGpn4/7bOXG11uAOV/xHn7JstbjUOFOHJp5l4SlwDA1C2txMspA8MQbHdayTJ
 iMh+eg1MGy9u4UgrwHzSbk/CTX4RAo2Rx7XM+K/CsycoPwGuhP64iqGtlH6o3T7UMwAf
 InTUIuR35pV/c50PaRjI6TWee205xc6xyfDjKikj8fMRmV5M1UksAPHXr6NgvCkK53qY
 TtQGi4vXOIfMUI5lE8/XU8r4QOeSgXOkkmLCPJwpBaKP8f7JzU9BeeRxEohfokKFeCOx
 Q/WLUDjI8ErthXigr80eS7zv7pxZ8au+e5M7gkw6ipRUBPHYn3zElnDaebsjayCtCqXh
 vgZg==
X-Gm-Message-State: APjAAAXqyOXlDMwkzKBtcKdsv/bkL8xDCJSYOovjzCfh++yyCmYyVyzq
 H1v07PfWh6uGjZLrk8yNd3E/GQ==
X-Google-Smtp-Source: APXvYqxy+Tp7yCqsliZlcm1nenyTrrwCNgADPR4oKcQqfaY6gz4abEEnUxXxTT1UyQ2NuOAYRawlZQ==
X-Received: by 2002:a81:441e:: with SMTP id r30mr21344710ywa.65.1554686865231; 
 Sun, 07 Apr 2019 18:27:45 -0700 (PDT)
Received: from localhost.localdomain (li931-65.members.linode.com.
 [45.56.113.65])
 by smtp.gmail.com with ESMTPSA id 190sm10494919ywd.62.2019.04.07.18.27.41
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 07 Apr 2019 18:27:43 -0700 (PDT)
From: Leo Yan <leo.yan@linaro.org>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Will Deacon <Will.Deacon@arm.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>,
 Robin Murphy <Robin.Murphy@arm.com>
Subject: [PATCH v4 0/3] vfio-pci: Support INTx mode re-enabling
Date: Mon,  8 Apr 2019 09:27:16 +0800
Message-Id: <20190408012719.16158-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
Cc: Leo Yan <leo.yan@linaro.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408012716.qr6KpCRuhlPSroMPdc106IWgiPd7J25uk3yJ8d4orp4@z>

When enable vfio-pci mode for NIC driver on Juno board, the IRQ is
failed to forward properly from host to guest, finally root caused this
issue is related with kvmtool cannot re-enable INTx mode properly.

So the basic working flow to reproduce this issue is as below:

    Host             Guest
-------------  --------------------
  INTx mode
                 MSI enable failed in NIC driver
                 MSI disable in NIC driver
                 Switch back to INTx mode --> kvmtool doesn't support

So this patch is to support INTx mode re-enabling; patch 0001 is one
minor fixing up for eventfd releasing; patch 0002 introduces a new
function vfio_pci_init_intx() which is used to finish INTx one-time
initialisation; patch 0003 is the core patch for support INTx mode
re-enabling, when kvmtool detects MSI is disabled it rollbacks to INTx
mode.

This patch set has been tested on Juno-r2 board.

== Changes for V4 ==
* Removed the unnecessary comments in patch 0003 (Jean-Philippe).
* Added Jean-Philippe's review tags.

== Changes for V3 ==
* Add new function vfio_pci_init_intx() for one-time initialisation.
* Simplized INTx re-enabling (don't change irq_line anymore at the
  runtime).


Leo Yan (3):
  vfio-pci: Release INTx's unmask eventfd properly
  vfio-pci: Add new function for INTx one-time initialisation
  vfio-pci: Re-enable INTx mode when disable MSI/MSIX

 include/kvm/vfio.h |  1 +
 vfio/pci.c         | 95 ++++++++++++++++++++++++++++++----------------
 2 files changed, 64 insertions(+), 32 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
