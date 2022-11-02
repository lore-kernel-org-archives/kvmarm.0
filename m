Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C036CC43219
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:49:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67F994B88E;
	Wed,  2 Nov 2022 12:49:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K+V1kirYsbRO; Wed,  2 Nov 2022 12:49:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 212B74B9BD;
	Wed,  2 Nov 2022 12:49:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FD9B4B976
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ssTp-ieMUdhM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:14:25 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 603724B97D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:25 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id j15so25278225wrq.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=m7TrrgzPAckx8MhzlXbOG19HS5vuSIcZLDLnFx3IxeQ=;
 b=0fMwoeRZHNCs3+eyJg3ygNryplDr80DrJk1L3bYfCxV2ziWdoNriajz7egBPWFlUDx
 wqVWXJacNM3jRg0yzHjHQpfEY/qDel4qPeh/ZooONZpvmKmUgjuDgzJyqfaFCaqf6Kkn
 vNXcaH0SzwTD6G6FuprpgURrGQwMsvB6jmdu+kC6DAELIFzdNKEHEria5xPI151SqlyR
 820zReyhlMk9aGbFb2I+z4lbPK6qrUliHAgmfSavPTd/dSuFeEfAVFTVGFRcpymdZfa6
 u3I3NE0yAEEpXsV+niZ0vDnSsXVFh/cuwQ5ien2+FwztNLuEdRgIBnvNU4iKh+QiezP/
 h9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=m7TrrgzPAckx8MhzlXbOG19HS5vuSIcZLDLnFx3IxeQ=;
 b=XCQh46Fq3MJcqNb+CSot5wV4KgXs+7hVoGaOYj8498dwuaIvlAiyfTG7raMgjD8GxV
 uYGru+/ZXToVEL0KSEg/uDygvR860YVXo/l3QowZdLMd7eJNWWIKFFEFfBDwJeu7jZgh
 07EnI57TfXnSzcJCdDVSJyvzDTZLLmGKADML8ghgWjvAPKbnR/J/pnq+0AnyMlAx5YCU
 uET+fFOvrK1Xo79wjukP/wF7ggJohZrI5UsW2kL7XHDqY8fJHZrjtkavpdhV7av0oHay
 47BGJyjfpApGVTZjdMd/tYYeFWVPjOmZaR41FenwsQxBydgCVKQTTZSoojF5XjW6uA3X
 iuHQ==
X-Gm-Message-State: ACrzQf0ZW2tzaN3lRgz1Chcol9i/tLsTzl4jkltbPfAchVb0bc3CjZ3z
 uQEMaOWcESNj892PDTxyQHUqHg==
X-Google-Smtp-Source: AMsMyM64kx8n6kzyuVGSQjYf92MlBu2zMhzN4ZR8BycrERCw7fqPcNS02NCH0GQQnVYB90z0ymW8kQ==
X-Received: by 2002:adf:fc12:0:b0:236:9b2e:4843 with SMTP id
 i18-20020adffc12000000b002369b2e4843mr15535660wrr.620.1667405664466; 
 Wed, 02 Nov 2022 09:14:24 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:6a08:9b26:ab04:7065])
 by smtp.gmail.com with ESMTPSA id
 m17-20020a5d56d1000000b0022cc6b8df5esm13230923wrw.7.2022.11.02.09.14.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:14:24 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Subject: [RFC 6/6] KVM: selftests: add tests for PV time specific hypercalls
Date: Wed,  2 Nov 2022 16:13:40 +0000
Message-Id: <20221102161340.2982090-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102161340.2982090-1-usama.arif@bytedance.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 02 Nov 2022 12:49:29 -0400
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

These are vendor specific hypercalls.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index a39da3fe4952..743ee6cb97d8 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -79,6 +79,8 @@ static const struct test_hvc_info hvc_info[] = {
 			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, KVM_PTP_VIRT_COUNTER),
+	TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_HV_PV_LOCK_FEATURES),
+	TEST_HVC_INFO(ARM_SMCCC_HV_PV_LOCK_FEATURES, ARM_SMCCC_HV_PV_LOCK_PREEMPTED),
 };
 
 /* Feed false hypercall info to test the KVM behavior */
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
