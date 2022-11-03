Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E124C43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 13:13:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4D0C4B650;
	Thu,  3 Nov 2022 09:12:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iSbZQH570kgV; Thu,  3 Nov 2022 09:12:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D9B94B631;
	Thu,  3 Nov 2022 09:12:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E90E4B492
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u4lPSeaT1p-s for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 09:12:56 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 479D44B17C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 09:12:56 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id k8so2740787wrh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 06:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=DMCevN2t3u4efqzCq1N5+13ZhEiTNq+v0n0oSnn+yyc=;
 b=a+kjRi4JO19KMObVrE9NrlM7N8rOXaA0DSi+sAFEBct1LRvXh2vtZaN4eos5JRwjfc
 GIh69g8n6LAGXk+tUPgoRDFmEXEPYOLuQHgtgkiCjW1m5Pesq8BZKhdOQmG9nJMeq+D+
 /7KpbvasuXFi/kH1C7BHHQt0vZ24VZ7TeZpED+ekjXso09V+OpK6f7F7/M/N3vFaio3r
 oW2xS5NydmXQRUQY+F49uQmDdnZRk1KCb95ZleeMBuMVJRsDGlh56WwpAxETFGcsSgGW
 2xh3n8NYRRrT32HpycNiYfYoe1a/uTukXsDpDDwbTTKMnb5XkTz8yTrAglduh/gX7vtJ
 h9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=DMCevN2t3u4efqzCq1N5+13ZhEiTNq+v0n0oSnn+yyc=;
 b=Iw0n8J2c9N5lps8aYyLmZ8U3rowehyjP1be6RG7UJpsFs/i5+3xBEfbXaH46cfaP0k
 xepqXrwURXXgF0jtYXZQgg3zVwgz3TQa1YZclqQuebI2F5Ys1vmJGUlOGeTyYZYbSQAw
 nUCwYfGiP3cBJvMD0005WvMC7QOU0g6GYaTnWEbDo6sxXowyltjT14eN3cGDmxoGIC4n
 enONUwZocK4/yBAZMJlJ+GHR91hr5P94jQ1P+IcOjgwb9tuDiVBYMySbYSOvlQ+HrlPy
 Vftxbjg0O8veRHU2j6da71/5PaDl8HoTCeQ3p4ixeRhrMcnwxlB4HQ6+/QzkbA/PlgUl
 EMxw==
X-Gm-Message-State: ACrzQf091W/nNjDvbdWxTcflTvlv1g0y/iRscf3NqSmj+Qwuh/VRLAxZ
 ip2EHFf+cUBu4b1Yja1mwo0i2A==
X-Google-Smtp-Source: AMsMyM4FLskXFFfmgc8C4mbNPem7m0JVrbmyMOJf4JYBCDCqX67gaH3asI2ftJOlpRErjLr2R76NSQ==
X-Received: by 2002:a05:6000:1ac7:b0:232:8c6c:6c4a with SMTP id
 i7-20020a0560001ac700b002328c6c6c4amr18775577wry.455.1667481175055; 
 Thu, 03 Nov 2022 06:12:55 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:e42f:dffe:32d3:8bf2])
 by smtp.gmail.com with ESMTPSA id
 z8-20020a056000110800b002383e977920sm765813wrw.110.2022.11.03.06.12.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 06:12:54 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com,
 mark.rutland@arm.com, bagasdotme@gmail.com
Subject: [PATCH] kvm/arm: Fix pvtime documentation
Date: Thu,  3 Nov 2022 13:12:10 +0000
Message-Id: <20221103131210.3603385-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

This includes table format and using reST labels for
cross-referencing to vcpu.rst.

Suggested-by:  Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 Documentation/virt/kvm/arm/pvtime.rst   | 14 ++++++++------
 Documentation/virt/kvm/devices/vcpu.rst |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
index 392521af7c90..e88b34e586be 100644
--- a/Documentation/virt/kvm/arm/pvtime.rst
+++ b/Documentation/virt/kvm/arm/pvtime.rst
@@ -23,21 +23,23 @@ the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
 ARCH_FEATURES mechanism before calling it.
 
 PV_TIME_FEATURES
-    ============= ========    ==========
+
+    ============= ========    =================================================
     Function ID:  (uint32)    0xC5000020
     PV_call_id:   (uint32)    The function to query for support.
                               Currently only PV_TIME_ST is supported.
     Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
                               PV-time feature is supported by the hypervisor.
-    ============= ========    ==========
+    ============= ========    =================================================
 
 PV_TIME_ST
-    ============= ========    ==========
+
+    ============= ========    ==============================================
     Function ID:  (uint32)    0xC5000021
     Return value: (int64)     IPA of the stolen time data structure for this
                               VCPU. On failure:
                               NOT_SUPPORTED (-1)
-    ============= ========    ==========
+    ============= ========    ==============================================
 
 The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
 with inner and outer write back caching attributes, in the inner shareable
@@ -76,5 +78,5 @@ It is advisable that one or more 64k pages are set aside for the purpose of
 these structures and not used for other purposes, this enables the guest to map
 the region using 64k pages and avoids conflicting attributes with other memory.
 
-For the user space interface see Documentation/virt/kvm/devices/vcpu.rst
-section "3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL".
+For the user space interface see
+:ref:`Documentation/virt/kvm/devices/vcpu.rst <kvm_arm_vcpu_pvtime_ctrl>`.
\ No newline at end of file
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 716aa3edae14..31f14ec4a65b 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -171,6 +171,8 @@ configured values on other VCPUs.  Userspace should configure the interrupt
 numbers on at least one VCPU after creating all VCPUs and before running any
 VCPUs.
 
+.. _kvm_arm_vcpu_pvtime_ctrl:
+
 3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
 ==================================
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
