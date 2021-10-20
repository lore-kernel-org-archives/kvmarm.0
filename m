Return-Path: <SRS0=uoKB=PI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CD6C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3360260EE9
	for <kvmarm@archiver.kernel.org>; Wed, 20 Oct 2021 14:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3360260EE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA89F4B199;
	Wed, 20 Oct 2021 10:27:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PYJPUge4U9c1; Wed, 20 Oct 2021 10:27:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9D74B12F;
	Wed, 20 Oct 2021 10:27:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CEE74B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:04:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rz+NnAy2xNIW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Oct 2021 08:04:58 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49FD54B12C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 08:04:58 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id o133so2774367pfg.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Oct 2021 05:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=pU7j7Xk9+/byWORMoTjuh+PtfIleRNtFNR9pisRaOIs=;
 b=V++5qWbqy5428E4+L8MN0z76u0WFToo1W/QPmRiz3Y2mC128yoEwYEbB+FWVhgenuB
 n+q6iWsUMxoBq63k7TZlDaAFsLpNQMhhMZKNtAvJHVTqVAJ9VUojVmNE8vYiYx8R+ufz
 cVJPMZ5WhVbo7SnHuHoClSMPP6oZyFSv/o/vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pU7j7Xk9+/byWORMoTjuh+PtfIleRNtFNR9pisRaOIs=;
 b=GvSxxF65M8TozxHIyGokd3J1K6ohHFhws2ZB97Ty8Q913af7jFNVjVq9sX2yHS5HCw
 RkBIGG66jFEwmNajoGfW2V5uCs9Ao8XSfaGaa6Vfo3FjVegw/O6IpJ59xIGHy6YPYLqu
 KNGeceUcCy5qEwdy1PtUBKLEq83XNYfLOgC+nEGF+p5n9KNII42yjxUe5ivoou4R/7b/
 It7hvw3SBj4h6U2LX/zkmenTe4BOGmdxdf3DwCK+924xRBTQeZ/5gKJiP8TxrlNtBkKO
 fwxTmw2qrVqQfQYJq54QmmneUaL0EjNocRAQJ47ZoujTiA1QIpfKpBEMBw2/lXiswdQv
 D9pw==
X-Gm-Message-State: AOAM532g/u5kBRkY1CEXnUIf56UdSm0bGRAel2F1zR0wN0mbvueNHpA+
 Qwj/klwpbDoc1xfaY8rR/Z8/wA==
X-Google-Smtp-Source: ABdhPJxaf4wQew/0fxehgf4we7eoDadSQ+ziLebkvEYdeY0bf6NB9PnUwEUIMDvlNw3FihCdjsAaDA==
X-Received: by 2002:a63:710d:: with SMTP id m13mr33036191pgc.467.1634731496586; 
 Wed, 20 Oct 2021 05:04:56 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
 by smtp.gmail.com with UTF8SMTPSA id i12sm2108246pgd.56.2021.10.20.05.04.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 20 Oct 2021 05:04:56 -0700 (PDT)
From: Hikaru Nishida <hikalium@chromium.org>
To: linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
 mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
 vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Subject: [RFC PATCH v3 1/5] timekeeping: Expose tk->offs_boot via
 ktime_get_offs_boot_ns
Date: Wed, 20 Oct 2021 21:04:26 +0900
Message-Id: <20211020210348.RFC.v3.1.Ic2211981441d0504581923b8770809f0750a4d0d@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020120431.776494-1-hikalium@chromium.org>
References: <20211020120431.776494-1-hikalium@chromium.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 20 Oct 2021 10:27:47 -0400
Cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
 Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Hikaru Nishida <hikalium@chromium.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, suleiman@google.com,
 senozhatsky@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Expose tk->offs_boot to be used in kvm virtual suspend injection.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

Changes in v3:
- Added this patch.

 include/linux/timekeeping.h |  2 ++
 kernel/time/timekeeping.c   | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 78a98bdff76d..f7be69c81dab 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -179,6 +179,8 @@ extern u64 ktime_get_raw_fast_ns(void);
 extern u64 ktime_get_boot_fast_ns(void);
 extern u64 ktime_get_real_fast_ns(void);
 
+extern u64 ktime_get_offs_boot_ns(void);
+
 /*
  * timespec64/time64_t interfaces utilizing the ktime based ones
  * for API completeness, these could be implemented more efficiently
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b348749a9fc6..e77580d9f8c1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -565,6 +565,16 @@ u64 ktime_get_real_fast_ns(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_real_fast_ns);
 
+/**
+ * ktime_get_offs_boot_ns - boottime offset to monotonic.
+ * Return: boottime offset in nanoseconds.
+ */
+u64 ktime_get_offs_boot_ns(void)
+{
+	return ktime_to_ns(tk_core.timekeeper.offs_boot);
+}
+EXPORT_SYMBOL_GPL(ktime_get_offs_boot_ns);
+
 /**
  * ktime_get_fast_timestamps: - NMI safe timestamps
  * @snapshot:	Pointer to timestamp storage
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
