Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1614EDA
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 10:38:10 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id gz8-20020a170907a04800b0087bd94a505fso9342395ejc.16
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 02:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd0FeyMlG74m/nm4XHJil0DTW7Kcn6gyhw0b15r3ih4=;
        b=VtqJzQK9sDGnSBOg9QMtSeyNfUP3G5EGSiBFDu5xjYOD0Uh5vmcmxL62Smu27C/dLn
         tGW60izEIgX7nRCyqz+Vu2uRkJm5JXvaOw8QvBN9CudqLuhuLdMXChD9+PquNW/OXjhj
         iGpXQZLw5mdFNVyqZ66l5DfQ8DO40a5W1cSAyy28AyyckjjBb6Uf8gxjVKDIZhdRUgJt
         D5TNbzz3Y96Mafu24UqZCFrSDCud7a/BoBgKrDMUHFxbU6MySQJXiJ4MnwxKMo5X4STE
         RG+EHkAzMugg355mzM+h7RrBHvoQbI0GCpqL8eZupXxeT0q5SM/utc3i1JwRxfjGBoS6
         1fww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd0FeyMlG74m/nm4XHJil0DTW7Kcn6gyhw0b15r3ih4=;
        b=FHEdew6n5MXWT09DuTLjD9yedU8MRuWptJObxllWO4lYGyccgzoYpzXONRg61pF/PX
         e10IPNg9/YTtOe5fCs8a2emlMNoQRygAO4i/iK/+mwBZ5qGKcU+5XJqpVztFe6MP7do8
         OuhtHk8bZiI/G5+dmqlMdeKpVmXhsrmTDfUXew/FCHPkK7kAAMEEinhMJZx/mAanovAs
         9Ksug2JFik6w7s8O9fnSepS267J//J/yUgp1LrWftlxbEPgTqJ+94ZMzeTLnpsio6C87
         CuJsG3teJz1bAOEvox/SeexSzSVxecb1suh9kaWQ/xYg9ZrjUNYu6wCFVxJLcSfW1+Vt
         vmMA==
X-Gm-Message-State: AO0yUKURrLIGH+8Jmi/b4VQpjsWkbFuGTZFalh4nYTvAF1pnRe6ssIUA
	9TdFAOzTRZp8xWYsTv5C8sTAG8EBLFzr
X-Google-Smtp-Source: AK7set8pUWH/EIRKqNBELwGkOXfTUro9UW9voB6iL5jldWiapgA0tzxfry3rHjCWX353kPSCNlq0/jQ1X/U8
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:1781:b0:878:7d2c:6ba4 with SMTP id
 t1-20020a170906178100b008787d2c6ba4mr572762eje.42.1675247888973; Wed, 01 Feb
 2023 02:38:08 -0800 (PST)
Date: Wed,  1 Feb 2023 10:37:53 +0000
In-Reply-To: <20230201103755.1398086-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201103755.1398086-1-qperret@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201103755.1398086-4-qperret@google.com>
Subject: [PATCH 3/4] KVM: arm64: Use sanitized values in __check_override in nVHE
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

The nVHE EL2 code has access to sanitized values of certain idregs, so
use them directly from __check_override instead of the *_override
variants.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index fb7d04b81033..1cc29960fcdb 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -196,6 +196,7 @@
 	__init_el2_nvhe_prepare_eret
 .endm
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 // This will clobber tmp1 and tmp2, and expect tmp1 to contain
 // the id register value as read from the HW
 .macro __check_override idreg, fld, width, pass, fail, tmp1, tmp2
@@ -219,6 +220,19 @@
 	mrs	\tmp1, \idreg\()_el1
 	__check_override \idreg \fld 4 \pass \fail \tmp1 \tmp2
 .endm
+#else
+// This will clobber tmp
+.macro __check_override idreg, fld, width, pass, fail, tmp, ignore
+	ldr_l	\tmp, \idreg\()_el1_sys_val
+	ubfx	\tmp, \tmp, #\fld, #\width
+	cbnz	\tmp, \pass
+	b	\fail
+.endm
+
+.macro check_override idreg, fld, pass, fail, tmp, ignore
+	__check_override \idreg \fld 4 \pass \fail \tmp \ignore
+.endm
+#endif
 
 .macro finalise_el2_state
 	check_override id_aa64pfr0, ID_AA64PFR0_EL1_SVE_SHIFT, .Linit_sve_\@, .Lskip_sve_\@, x1, x2
-- 
2.39.1.456.gfc5497dd1b-goog

