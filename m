From: Roman Livshits <romanliv@gmail.com>
Subject: Android on virt device
Date: Sun, 26 Feb 2017 12:12:35 +0200
Message-ID: <6e04464a-9570-7d62-4bf4-9bbc1fb46e6b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C6D40DA4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Feb 2017 05:11:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id io3sylF3sKOx for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Feb 2017 05:11:35 -0500 (EST)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BBE640D55
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Feb 2017 05:11:34 -0500 (EST)
Received: by mail-lf0-f49.google.com with SMTP id z127so23134179lfa.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Feb 2017 02:12:39 -0800 (PST)
Received: from [192.168.100.12] (85-76-144-124-nat.elisa-mobile.fi.
 [85.76.144.124])
 by smtp.gmail.com with ESMTPSA id t2sm3160262lfe.9.2017.02.26.02.12.36
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 26 Feb 2017 02:12:37 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi

I am trying to run Android on qemu virt machine.
I want to use virt as this was used by the op-tee for implementing TEE 
for ARM TrustZone, see https://github.com/OP-TEE/build#op-tee-buildgit, 
so hope that running Android on virt would be easier comparing to 
putting op-tee to ranchu, used by Android emulator 
(http://www.linaro.org/blog/core-dump/running-64bit-android-l-qemu/).

Is there any advice how to do this?

Regards,
Roman
