Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBE3C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:50:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3716C49F08;
	Tue,  4 Jan 2022 14:50:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R+YtI-L84Awt; Tue,  4 Jan 2022 14:49:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9434B13A;
	Tue,  4 Jan 2022 14:49:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE7849F08
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJ6VO+aYCjOl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:57 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33D4F4A100
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:56 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id
 i3-20020ad45c63000000b0041143710adbso30779192qvh.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=koYIbVzLeCIp1ky1eF8weLmELE9lQop0nuOmnvUl4iM=;
 b=iEF20O6nEtnzg8QLg5HK2eQWSdMtJV4Yig8SF/aO+OPRLc5fD/RD5+aD5k2tAATXB/
 exX1WoJ9BzW3+g3/wuoHiUQ6rEfC8DeSZgWkvdhGgYSWdVD0GOjyewUpThL9LKVtuHDC
 xJQTXt3qV6G0ba76aVhBXeQKbAZNRRQhM7INjHirJWi1dj+NI6YUlSi/j2PcyLFzaCVl
 znzY3R2cL9ts2cWm13sgzoGMa9yH+HYKW46oK7KTBc9a3p0Ac7Sh50cDXvMItxDvNR2i
 TnKjQbG0/lUHtfMRshb/rMGBMvvpRmYFnt6kB9VcOILtL/ttqLjCfJjYQmWks5Jfucii
 OZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=koYIbVzLeCIp1ky1eF8weLmELE9lQop0nuOmnvUl4iM=;
 b=oHOe7yPLEgwzoCwJ8hlGVicZIT7umZvrWpBu5ONofhsTPMa/2S7yuoBrUWYKVlMj0S
 iX8u7CgRhEwdDiZTXb9HYH4e+T3RdVphxeSfp44g3RbPFSJgLg0a9oLntSZrc6CljHh8
 mPTdrow1X1BFaBkRkRzUmAZcSt/YU9fU+QRc9uT5w8gtbTETSSMYcr5Uln2Nn+3YB6y5
 alqZVuOfaoCv9LlKxiRdwaxCt0OCI6uvrRJyeBUdoRY05n5P85zHOCBZ7EeoNiYqQu52
 b6VEIPyAjJ6Jx3SmAiJ4l35zyh8gcHLC1UvfwDmdWzXjEDxj6YEd+G1Bi6TWXTQbgj+y
 UwFw==
X-Gm-Message-State: AOAM531yB1SJuR9qiveAjqf1BlpFXNIlHQwyDpcGg/fMYpgFQOm1JtP1
 R+FomnwcOIM5JdS/M2vaRch8sD2WWzcs
X-Google-Smtp-Source: ABdhPJyeojFG4fK/2r+cuOGGf0/iG6ojdW9/FWZt+iEktMSbqQcbtVlfPIpRpvAc8OdzwuV2BXd3zsjyzSv1
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:622a:554:: with SMTP id
 m20mr46031673qtx.623.1641325794799; Tue, 04 Jan 2022 11:49:54 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:18 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-12-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 11/11] selftests: KVM: aarch64: Add the bitmap firmware
 registers to get-reg-list
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add the psuedo-firmware registers KVM_REG_ARM_STD_BMAP,
KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP to
the base_regs[] list.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..6321f4472fdf 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -686,6 +686,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_REG(3),          /* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_REG(4),          /* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_REG(5),          /* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
