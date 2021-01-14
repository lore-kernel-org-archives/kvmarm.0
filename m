Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E73AC433E6
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD2BB23B40
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 17:44:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD2BB23B40
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76AB04B2B1;
	Thu, 14 Jan 2021 12:44:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RKZAR544vjSI; Thu, 14 Jan 2021 12:44:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 844754B27C;
	Thu, 14 Jan 2021 12:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECE5A4B22B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpFh9lqeMQet for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 12:24:42 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF72C4B187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 12:24:42 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id t18so5134020qva.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 09:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=xV+/a2Rp5lRcHlFRCafjdMqZdknib/NjGfl4/F+eUSQ=;
 b=RHWeCTmFFlh0JG7mSrwt1xtK3BPDcF/hNwHiBSWk2tm3duHiYAEvtevj2/GAO5f869
 2m3HICWqldEJ2EfhWZYJCnQAAWHfwp4TUOTERQqiZTnMzKq4FXSuSlHKsQCkxaLo5kyJ
 JZVSqwaPfHYu/kDGisDgA7beJwN0XcGGRgTpC4koHF1IBZ6E1aV1zcU2X2ozQZL+hprg
 GrABIORMdgZx5+EJ9vs7hqClA49Ey+lSP3BmQz4bubQJKTHQ36oAAVVxJ3tegF17coOb
 T9ZgM+wBKsYD90vhlOkPfEgk6gcyTQJ+48x4N36NaoN+BBBZ8562dlxSZD1b5nMk/z5w
 cP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xV+/a2Rp5lRcHlFRCafjdMqZdknib/NjGfl4/F+eUSQ=;
 b=M3njkbs+au+1Zr+Kg5AC+/rb0OBxxkNfdKhQjoCxpJUfYNtgK5EmM2Yq12wLbXtvMI
 VXDETXJCSQC2A8W5UDxFVSA0cdNml9Eqjfx+F+G2FwzPx5Fn4Uu9TMB9Buzu4UCT4+4G
 j8cb2K0Doi/1IZWgtYTKtknPUUkgJ0+3I2SxF/JY5nf9AiQQ86ZfkQbDcBWHbQthlCDf
 BIWqXxsuxd1L2aRx3Lzylj4ZVXTMm8b0LjH5T1N4TO7nIfTiUBb3HCgCnur6L0P3OJnP
 KZvRbazVl1IiBDRyzey3oKpnC2OkBgpuG+emPd4Bd2aEHqbDMozlt+QjKd7y1u5qlxbF
 Aa6A==
X-Gm-Message-State: AOAM533g3c+xpWgDMSAAXvwQ1jIlcbmsZ1jL7PNEFhjEZmpz5+qiAyc6
 yY+uqZz3K1oDVrA+Ihjth1fExkYMdHlbNd2mL15fgdDO/8sd7f/sjy/Qioi85WmlQPPPic34OGt
 F/1pkSbHgAg7xJlxVs01COGEJkEf+M5mS5W1PgM9AeKJvyIDwYOxLmLIeAvNAnlIS+do1sDLJ
X-Google-Smtp-Source: ABdhPJxYOrg0jToecCcCtBlCANab6SAeOu4IUUuOLW8kdj70MALJwg3ucMAxQNeuFfe9E7QdMPkIvkLD8o+D
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a0c:a789:: with SMTP id
 v9mr7957944qva.41.1610645082204; Thu, 14 Jan 2021 09:24:42 -0800 (PST)
Date: Thu, 14 Jan 2021 17:23:33 +0000
In-Reply-To: <20210114172338.2798389-1-lenaptr@google.com>
Message-Id: <20210114172338.2798389-4-lenaptr@google.com>
Mime-Version: 1.0
References: <20210114172338.2798389-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 3/9] KVM: arm64: Enable UBSAN_BOUNDS for the both the
 kernel and hyp/nVHE
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 14 Jan 2021 12:44:06 -0500
Cc: George Popescu <georgepope@google.com>, Elena Petrova <lenaptr@google.com>,
 Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

From: George Popescu <georgepope@google.com>

If an out of bounds happens inside the hyp/nVHE code, the ubsan_out_of_bounds
handler stores the logging data inside the kvm_ubsan_buffer. The one responsible
for printing is the kernel ubsan_out_of_bounds handler. The process of
decapsulating the data from the buffer is straightforward.

Signed-off-by: George Popescu <georgepope@google.com>
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/kvm_ubsan.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 ++++++++++++--
 arch/arm64/kvm/kvm_ubsan_buffer.c  | 10 ++++++++++
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
index fb32c7fd65d4..4f471acb88b0 100644
--- a/arch/arm64/include/asm/kvm_ubsan.h
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -9,6 +9,23 @@
 #define UBSAN_MAX_TYPE 6
 #define KVM_UBSAN_BUFFER_SIZE 1000
 
+
+struct ubsan_values {
+	void *lval;
+	void *rval;
+	char op;
+};
+
 struct kvm_ubsan_info {
-	int type;
+	enum {
+		UBSAN_OUT_OF_BOUNDS,
+	} type;
+	union {
+		struct out_of_bounds_data out_of_bounds_data;
+	};
+	union {
+		struct ubsan_values u_val;
+	};
 };
+
+void __ubsan_handle_out_of_bounds(void *_data, void *index);
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index 8a194fb1f6cf..55a8f6db8555 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -13,7 +13,6 @@
 #include <asm/kvm_ubsan.h>
 #include <asm/kvm_debug_buffer.h>
 #include <kvm/arm_pmu.h>
-#include <ubsan.h>
 
 DEFINE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
                 kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
@@ -44,7 +43,18 @@ void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
 
 void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
 
-void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
+void __ubsan_handle_out_of_bounds(void *_data, void *index)
+{
+	struct kvm_ubsan_info *slot;
+	struct out_of_bounds_data *data = _data;
+
+	slot = kvm_ubsan_buffer_next_slot();
+	if (slot) {
+		slot->type = UBSAN_OUT_OF_BOUNDS;
+		slot->out_of_bounds_data = *data;
+		slot->u_val.lval = index;
+	}
+}
 
 void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
 
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
index 4a1959ba9f68..a1523f86be3c 100644
--- a/arch/arm64/kvm/kvm_ubsan_buffer.c
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -17,6 +17,15 @@
 DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
 		kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
 
+void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
+{
+	switch (slot->type) {
+	case UBSAN_OUT_OF_BOUNDS:
+		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
+				slot->u_val.lval);
+		break;
+	}
+}
 
 void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
 {
@@ -26,6 +35,7 @@ void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
 	slot = (struct kvm_ubsan_info *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buffer);
 	for (i = left; i < right; ++i) {
 		/* check ubsan data */
+		__kvm_check_ubsan_data(slot + i);
 		slot[i].type = 0;
 	}
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
