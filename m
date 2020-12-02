Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503EDC64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A883F2173E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A883F2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38CB04B3C2;
	Wed,  2 Dec 2020 13:41:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LNdE+8a8felq; Wed,  2 Dec 2020 13:41:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 443D34B333;
	Wed,  2 Dec 2020 13:41:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 492684B36D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4065FO-XyrUP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:44 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34F274B40B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:44 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id o1so5162223wrx.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=y2p8Ay2XnBVL3vmtVVdiQ6iCXfVcEKgd2S1Ri8Ky5yc=;
 b=RVZK76j4k6bFwiXLgYuFF1wtJaBoX2V07k5mb0zz2XzuAWmLJ1i+F8W5NohjH00/sj
 gWlE7qrSAwcbIAEG3hSs7PAR248eOVkY6Xm3SGr2s7GCAbFd1nsA3SXKbGnzIxFSrkg8
 irlXEGzEcD3yJ1mQ7deVRYJx/fqkEt/rYVXS4dv7nID08H9qJKazcokqFUOi0xPNWDmc
 wSiS1Rr8Nrm4KLg51r8BdgmhZJ5lT0++p3Ln9OxqEdQrrLW0MIdiVj2Hn7v3NIVuTRH5
 LzsCZkvPa5kTdTcpPz8VJgGlrbBlyP+9VsdgTapGlKyPChgjeyjIeM7KiQROiHGleMKZ
 qLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=y2p8Ay2XnBVL3vmtVVdiQ6iCXfVcEKgd2S1Ri8Ky5yc=;
 b=ax6XAkUaZu/Sw/TsFmppyWXZZPoPgGDN8muoCOvF66SC/e4GT/wJ2Py3LTz+BdKty4
 13wchZSOI5R9FTd2l0Md8UILKJJgr52XGBIbOOXR82CxTQYuCpdhlZfU6EpC9krAEKYc
 CRTN0/EGwtKwj+X9b6XesfU3K0t3tcRaK6cpz+iSIsCu64Vx57ZWsY89mOLLS3IZFZ1e
 dljIgNRNnpKW7GryfryuqlfNRyZjxZWhovqrfl7XeVztCabKMkYJVgQsReQqt52cWf/+
 2nyWv6D5eLzl/igODM7+Jr1ERXJ590ISt8AUTSawaPTnESCl8m8GUU6/6Vr5yqkkJK5N
 C/oQ==
X-Gm-Message-State: AOAM533GxtbL9i8J9QpzDT5CpUb79ZF5ImYiCE7VEeF7b/XPxwIW1Cpa
 L6am+PTJnb2JXwm5xs53f7bbw+QO6Dz4Og==
X-Google-Smtp-Source: ABdhPJxAQnxesV8ENz1UWdK5eE8OCnghkt8xaIi7bsuMXjZf93/bl2MjqeL5MAHnTzF9beINxPa0Kg==
X-Received: by 2002:adf:c443:: with SMTP id a3mr5093368wrg.249.1606934502768; 
 Wed, 02 Dec 2020 10:41:42 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id v20sm2813264wmh.44.2020.12.02.10.41.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:41 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 07/26] arm64: Make cpu_logical_map() take unsigned int
Date: Wed,  2 Dec 2020 18:41:03 +0000
Message-Id: <20201202184122.26046-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

CPU index should never be negative. Change the signature of
(set_)cpu_logical_map to take an unsigned int.

This still works even if the users treat the CPU index as an int,
and will allow the hypervisor's implementation to check that the index
is valid with a single upper-bound check.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/smp.h | 4 ++--
 arch/arm64/kernel/setup.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index 2e7f529ec5a6..bcb01ca15325 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -46,9 +46,9 @@ DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
  * Logical CPU mapping.
  */
 extern u64 __cpu_logical_map[NR_CPUS];
-extern u64 cpu_logical_map(int cpu);
+extern u64 cpu_logical_map(unsigned int cpu);
 
-static inline void set_cpu_logical_map(int cpu, u64 hwid)
+static inline void set_cpu_logical_map(unsigned int cpu, u64 hwid)
 {
 	__cpu_logical_map[cpu] = hwid;
 }
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 133257ffd859..2f2973bc67c7 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -276,7 +276,7 @@ arch_initcall(reserve_memblock_reserved_regions);
 
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
-u64 cpu_logical_map(int cpu)
+u64 cpu_logical_map(unsigned int cpu)
 {
 	return __cpu_logical_map[cpu];
 }
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
