Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375E9C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 09:55:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAAC94B2EA;
	Mon,  9 May 2022 05:55:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1-jbhNFIr+d2; Mon,  9 May 2022 05:55:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D14A94B2E4;
	Mon,  9 May 2022 05:55:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AA34B2B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iEcIoRdUG9pr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 05:55:13 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D23B4B2E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:12 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 s14-20020adfa28e000000b0020ac7532f08so5571916wra.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 02:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PhvZKBoe39U/3XMHmUVWsW2UFiJi51cRGJG2oMiPjk0=;
 b=gy9Pr03wH/mN/XB3LzRNi4hBUvdoPadX+6gSpKuCnO8uMZaRwee/T/cXmhwHPp7jOf
 UXJsDe4l5e5cWjkkXmPZ2VygdY5RrxCx4vLOlHuU4uWoxadyDvAiVPXbzEGX8PfF/I49
 8X0EwOD9sETBcgUs4v+jKjuwUVo0OLMz5UQcbAL4VgtjqJQAXSjKbdh932vy1h7GQhDw
 k2dsFcS6jW843fUNI9r74FSxB569wCmInL4kHIoaA7FUMoSVmU5bMkfmKXNQtyjaw6vh
 OeRDNDDn3tM3aT8iyen4UTmwruuADa7fq9JoG5BbmOdevUKa/P1TlUVOXgAErFdIx0ZU
 gLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PhvZKBoe39U/3XMHmUVWsW2UFiJi51cRGJG2oMiPjk0=;
 b=nzJSXRQ+TVKZ5sZ/SaE6XOxhh47wwIu261/YVo8P2uAYCe475baFLCZy5ELnSmCyuo
 miSQgULZDv9sFxpXNfzMG1iNcQgF5e2pk2Sz70Q7oXXO3ieck0JfcIrAQcTcCxSUO2P6
 W62cRT5P10UTn2Wjm8xaE7Rhxjyhes0IMNIJ6R1UC2GHjd9tyrI9Xmk+lFPNqHm7cgJp
 InI4fsOoNQ+QA8Lj4yT8GtBkKmVApKAXxOcR2OT3Bs8oOEHq2C4wgutZLU0iM1/NrxIm
 KHXGqEnVQlT5ph90rcdrw7n5DAm97iN0obxcCYCzGIwfeLiwrxvs3VK6qqff+XFEX3a2
 kuZQ==
X-Gm-Message-State: AOAM533LFpZ4A7IZe9ckUYaEmkG/5caIxTaG/brSHPkCuVmd8qwHOEIV
 4EQkCaEdTc5g/1sheV+m9WIiuU6Pbk11E5iSRxIIKG7CJKr2qSjFm0ZlbBlD5GLh00QFDwZg+w7
 PjRHUfmO3C4c+u06sH/OWQCKTVOP+Pkksd0fvf3Uup+o/z99unVj4y75InrN4pO/gnBs=
X-Google-Smtp-Source: ABdhPJyQpUMf+PyLIdfmlviF5r7R4hnQrrGQnxivrS16KdcOz4sztzVanuIea+fT+sX8qxj68vsB+2uq4Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:2102:b0:394:2765:580c
 with SMTP id
 u2-20020a05600c210200b003942765580cmr15172324wml.150.1652090111772; Mon, 09
 May 2022 02:55:11 -0700 (PDT)
Date: Mon,  9 May 2022 09:55:00 +0000
In-Reply-To: <20220509095500.2408785-1-tabba@google.com>
Message-Id: <20220509095500.2408785-5-tabba@google.com>
Mime-Version: 1.0
References: <20220509095500.2408785-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v2 4/4] KVM: arm64: Reenable pmu in Protected Mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Now that the pmu code does not access hyp data, reenable it in
protected mode.

No functional change intended outside of protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 08d0551a4e43..cf15d510c06d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -777,8 +777,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
-	    is_protected_kvm_enabled())
+	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
