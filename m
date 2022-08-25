Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC70C04AA5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EE774E2C7;
	Thu, 25 Aug 2022 01:10:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WcN-9sAwziRE; Thu, 25 Aug 2022 01:10:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5144E2C8;
	Thu, 25 Aug 2022 01:10:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AFE14E2C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XC8vXmQZ1e3j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:09:59 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7A184E2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:09:59 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-33352499223so325287497b3.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=Q3hjf8MS4AzzCWp5/oCSzOsoQ1ZbyBHYLyXOhMM4IQU=;
 b=VcczpBcdz/1D305XYzhC6q4QuudDMoUbJqkU5dHnorb9t4TPC3YwLgmqsMEgbahnh2
 +hfdMdra6lWeBABxnmLdId4Ay0ymjcNv5EE4jwqvZ2EibwlPZAZAz6kqcHdQR+jrui9V
 3Y90iiBnvUuscRTb5mNg1fDqOSXTCsWuDQ83fJ5FSRid5MLS6CNxBUG7Iy/V95SQ3Tng
 5nGiaioEr1PWX94QrqMYngmxniCLA0gWbZ7FG+9v0DlrN7P/DkVhTT8u3leAUgc7zos2
 MW4e0TWfavCUFfS++lbscSG4VwEa4ERsBnaAV3U678vU7DDvmy6klM5GBI/dJBos8c/p
 OXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=Q3hjf8MS4AzzCWp5/oCSzOsoQ1ZbyBHYLyXOhMM4IQU=;
 b=WPP8YLm4DpzqgIpvVELbDltCF7R19XcuK06JhmYKNN1mTsTZxgwe/4lS+VdYJY/Sed
 +V1f5OtE21wWvtS4ipvwSpFo2aVd+bArhxaLJbGx7D6tnyK1H/pMDUnBRT8VHwa7rnt6
 yzxmZcSf/PrTQRiDiFY7SzYwC+vcJ6gBHG5oy5YeuMyZLjotJdwJQIQVT+G5ySz8/qkr
 TcYdm4lN5d1cAY0A8mBZ1gKodEK+Qsg4vTw1lXSxwmfIRbTFROheonwe5rLew3PS5mAC
 6/qntdhoI3JUCVHF0+XaazAnSozTdXpQqO0MSCOAzLrF50CgZ1ajnqBOntesP39lIAlI
 Oo3g==
X-Gm-Message-State: ACgBeo0/LKSUfdDFfQFWgV5XSZ9Hxi5ccQsQLLe2qPCUl0J6h+an0X2V
 R6UpQxvAcmNrXEablwEQSwmOm77+u2E=
X-Google-Smtp-Source: AA6agR58GZbl6co9b3RXWIjzW0YOxe8HSUhxD7OeeygT/Iu7A8ou68w797ekVXhGcdByFqk3CBisadep1EQ=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:6d88:0:b0:695:9728:f253 with SMTP id
 i130-20020a256d88000000b006959728f253mr2035825ybc.39.1661404199334; Wed, 24
 Aug 2022 22:09:59 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:38 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a field of
 an ID register
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Introduce helpers to extract a field of an ID register.
Subsequent patches will use those helpers.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h     |  2 ++
 .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index a8124f9dd68a..a9b4b4e0e592 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 
 uint32_t guest_get_vcpuid(void);
 
+int cpuid_get_sfield(uint64_t val, int field_shift);
+unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..0b2ad46e7ff5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
 		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
 }
+
+/* Helpers to get a signed/unsigned feature field from ID register value */
+int cpuid_get_sfield(uint64_t val, int field_shift)
+{
+	int width = 4;
+
+	return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
+}
+
+unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
+{
+	int width = 4;
+
+	return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
+}
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
