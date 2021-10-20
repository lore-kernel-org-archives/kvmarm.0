Return-Path: <SRS0=uoKB=PI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A7FC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3FD8611B0
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B3FD8611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13ED34B136;
	Wed, 20 Oct 2021 10:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hD+MV2hWwRFq; Wed, 20 Oct 2021 10:27:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 485844B150;
	Wed, 20 Oct 2021 10:27:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12BF4B12C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:05:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nx33heI4yb3W for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Oct 2021 08:05:05 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFB984B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:05:04 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id c29so2792656pfp.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 05:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=waYD8dsvUPs/3L1638bXCQkgi6UBgjkYBImUZ1krvko=;
 b=IPB6vWRptmpwaKLEJ2X1nkyazjjUtdTq5CkxdHOjuBZhT/HfwszGKGLZSkLoLYq0R5
 ztf2MLxBp40XOAYLBCWmO4AK+rH0/qqbhm4tJLLEASl582myoqUsTP0DfzoqHWybF3i/
 7j+Z09yo9qBg9ov5T9IFPSKwM5D7QkuuL7muY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=waYD8dsvUPs/3L1638bXCQkgi6UBgjkYBImUZ1krvko=;
 b=0xm9SJp8D4h8LEe5nwYVxAidyVvjzjFFYM4DdLuOqy3hDFrrTpTVh2gvizGhT3RFnl
 eJv6Bh44D5FcSOVEtNsQoe8pWs5zhe+S6WUA3uTm8zhapqX7fEXQz11/WgQdIaKVVHZ7
 uZ/k+c45sMRSi3fW04Ba6praLiTvxaIy8z3g72E39Em0uVYCnbddAIFsCGgpWFtJircH
 KSg5h94S/hkMkuiWVaQrIbOPKLp8XMzYT2OQmuzBzI4n/aJAY5bJHJbVITzNwRs3KXgV
 +KSZQ6s/aGQrCaov8+lwHYmGCdZV6EzBf4B+bGF/WkG2Sq4hLvT631NofQUCYQZ4hUSN
 y1fw==
X-Gm-Message-State: AOAM532yIUq1zbBDtxd2rNE5ETc9tOQRCJuKeJyBfWvxIuatudLRTOEs
 0E+FGWMXN3/guOGbjDEC5BtM/A==
X-Google-Smtp-Source: ABdhPJyAa/wmxbz/aUVIPHp/LNEJI1zHjIqTNYybV06ibBEmD12XdN3Ms4lEYjUO9FXnD0ifkyqlBg==
X-Received: by 2002:a05:6a00:1916:b0:44d:b930:df4f with SMTP id
 y22-20020a056a00191600b0044db930df4fmr5921135pfi.39.1634731504152; 
 Wed, 20 Oct 2021 05:05:04 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
 by smtp.gmail.com with UTF8SMTPSA id z11sm2424576pfk.204.2021.10.20.05.04.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 20 Oct 2021 05:05:03 -0700 (PDT)
From: Hikaru Nishida <hikalium@chromium.org>
To: linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
 mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
 vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Subject: [RFC PATCH v3 2/5] kvm/x86: Include asm/pvclock.h in asm/kvmclock.h
Date: Wed, 20 Oct 2021 21:04:27 +0900
Message-Id: <20211020120431.776494-2-hikalium@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020120431.776494-1-hikalium@chromium.org>
References: <20211020120431.776494-1-hikalium@chromium.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 20 Oct 2021 10:27:47 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 Hikaru Nishida <hikalium@chromium.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 suleiman@google.com, senozhatsky@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Include asm/pvclock.h in asm/kvmclock.h to make
struct pvclock_vsyscall_time_info visible since kvmclock.h defines
this_cpu_pvti() that needs a definition of the struct.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

Changes in v3:
- Added this patch.

 arch/x86/include/asm/kvmclock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index 6c5765192102..9add14edc24d 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -4,6 +4,8 @@
 
 #include <linux/percpu.h>
 
+#include <asm/pvclock.h>
+
 extern struct clocksource kvm_clock;
 
 DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
