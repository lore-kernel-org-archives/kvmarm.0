Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F4EC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF60861040
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF60861040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A42AC4B085;
	Wed,  4 Aug 2021 04:58:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TRH1zJBoOx18; Wed,  4 Aug 2021 04:58:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1BD84B092;
	Wed,  4 Aug 2021 04:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5394A193
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 26h3sG9KQa51 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:51 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEB954B097
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:50 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 d69-20020a25e6480000b02904f4a117bd74so2216441ybh.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kDlmZ2q+VtsAE3exEj8aYy6Fk3kSky3TCXUK2+oaNSo=;
 b=lzMCH9i930DInyi3TgFPeE0uphR3Msy4pTrV5RPcS66cl2mtNGs6v5FMcT24ugSCvu
 9t2LTl5MeANnamFbgsOAhO26iTUlsALVuwLmAlCcO3GJ9l1hjsOAorK4kMvfpjtwNn0A
 BzurnpIA6EmR8GyK1/kV3LTsEcDNwzJRnnugFj0EUJxJYPmqNanYRpUqh9Iho74VI27e
 Za6PQgbIG636DV/zsqE46glgJvckLVfEpvZwIfocJHgnxj1mN/9rtgCngqSXNiD/Gw/d
 kHmREJP/0WVtk9MY2zVUvznJ0l9KvXjtClvLNoYeMw2fOuBBfPoJ8QZKRd6CAiszFLAJ
 PK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kDlmZ2q+VtsAE3exEj8aYy6Fk3kSky3TCXUK2+oaNSo=;
 b=DvpCajBsbl/yAi6QpGlSKvPA6mIGbdRmUzx6nYBRkoOFw5xD4HjL6kH+rLgm5QbOle
 dwTLW5/soEadyLtDlCgoKR0M9oNMXL7R0iBmKJkrpsQv07kIZnXRnsWmLrXBXlRFlMHD
 HoLZQsO0h3ncIPttEiufC3Z/U5D4bNAEjM3j3EGVC3bj5HEHDoUEKiYmt+IQjAfYSXW4
 GBCmjfVS4UQ7aKI9Gt0loArWDXkZ3/8C/172oxMPEOMdptSSF3hZKF5OolYgaDskxKDT
 vhFOFAzReCOXcwViCeHL7gi1CgQzonblsSM9mQPyDHefR+QqvJeVxpKRwSS09rpKAmcz
 cPWw==
X-Gm-Message-State: AOAM5333xe/0UhXya045aarIpq8HH1lcnMcjXIrHXUqac+BOLh1kztOW
 hnznSGMiHBn/ST1ZdvcvAgBaaLs0Vlc=
X-Google-Smtp-Source: ABdhPJwoa+pdRQxhpipLNFgpIp6Y6GN/h2wf96Y41BJ+I1JnXOOC4/K6kyDAjQKCzkOIoOhBQEk5G+hqcxc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:be48:: with SMTP id
 d8mr33406835ybm.521.1628067530295; 
 Wed, 04 Aug 2021 01:58:50 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:12 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-15-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 14/21] selftests: KVM: Add helper to check for register
 presence
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

The KVM_GET_REG_LIST vCPU ioctl returns a list of supported registers
for a given vCPU. Add a helper to check if a register exists in the list
of supported registers.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1b3ef5757819..077082dd2ca7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -215,6 +215,8 @@ void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
 		  struct kvm_fpu *fpu);
 void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
 		  struct kvm_fpu *fpu);
+
+bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id);
 void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 #ifdef __KVM_HAVE_VCPU_EVENTS
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0fe66ca6139a..a5801d4ed37d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1823,6 +1823,25 @@ void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
 		    ret, errno, strerror(errno));
 }
 
+bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id)
+{
+	struct kvm_reg_list *list;
+	bool ret = false;
+	uint64_t i;
+
+	list = vcpu_get_reg_list(vm, vcpuid);
+
+	for (i = 0; i < list->n; i++) {
+		if (list->reg[i] == reg_id) {
+			ret = true;
+			break;
+		}
+	}
+
+	free(list);
+	return ret;
+}
+
 void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
 {
 	int ret;
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
