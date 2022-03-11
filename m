Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921B2C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:57:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CAFC49EE9;
	Fri, 11 Mar 2022 12:57:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qqa6iv+7Lixr; Fri, 11 Mar 2022 12:57:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD9F49F09;
	Fri, 11 Mar 2022 12:57:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D362249ECF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M-bDzkDBP8VZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:57:41 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C97D849EBD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:41 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 x9-20020a0566022c4900b0064289c98bf8so6776066iov.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=reY3JxO0Qz3iJXrFE+fLTwQO2MuKL1UPGAjn20Lqoao=;
 b=n/M+lnBk+N7zApRlOssTP+KALpqfkDUpxmbbZf9OVnsbAGTF24lyWr2yvrKj3eJhHh
 KlwuG3VKWe3524zQ0pEL4J6TBwFwPOoRAebN3n0vpides8mGXB+EbYFeJmmkZfQTfGzZ
 XYvyGdDyjkXVzSAzkiq91lVWeQmg14E+ZshflwW/ntyiQxAJxwuPNucacslawQCbPYYm
 WD3ZFVMIGBG78tv4VKrrv5Q/SbGCWnBDtlQP2/T9o/33WqeTY/4Pf+YD0SNDX81gEwaX
 G3KYqOFofFz3jHwq3lO7/3gzvWvfYvIGk9aFdVJLuYnlmsuLWzAaO0YJUmB9pJCY0LLG
 0zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=reY3JxO0Qz3iJXrFE+fLTwQO2MuKL1UPGAjn20Lqoao=;
 b=azlw9OryVU1fZr7PtTcaNaC2mGELTEgfzDPWxk3X4beOtenD3h6Lzyafr48m4lNreE
 tDNHHsdCcZnPNbcqbkCFiJkrq8J9Fh17ITZSjUAvWGfRMT5Qtp+8pllUAONYygfyiuO6
 3EhxPZVknKJuWD1z/bZQ99SrJgVti79nIo3tFgzfjYBzNyXOkc5ucTBP8DpKkBic27BT
 AQjiyUN3IMvgWePhPlieroG+CTezx1cKnQ4LlpI9wJCiRQHcCPeGvs6pUdirvPJ+J2le
 isy2F0MXJO/hHmebNXPg1s5nzZg4MW/SewkVa+faKx5BwrwBmzZ8X1Gz72ijLjOzNW27
 TX7w==
X-Gm-Message-State: AOAM533USyo7Av0UgN2PGcM6uy9WDutvVG/LH38qke10g2C28/9+2SvN
 2QfiAp3b8exNnHVbt/KZdGv/B639hJ0BiBxN/aEdpTwehGsfFem7vcXNluwDS1fwslgIre7AzQE
 1kYqGDvT6frs6yS3olhrUuVPR2+NDv6VCdXEZuIHMDvC8LzoZQPs040RCOe79Zpz9jR6GQA==
X-Google-Smtp-Source: ABdhPJwIV2dE5aKw/FZ4JxGUOLBoR07htZIM8UZWxJDfUBN8z5M+T3xIKkUCNUzF/rey8m9ZGZWSrRl15SE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a081:0:b0:317:b141:29ca with
 SMTP id
 g1-20020a02a081000000b00317b14129camr9018933jah.275.1647021461237; Fri, 11
 Mar 2022 09:57:41 -0800 (PST)
Date: Fri, 11 Mar 2022 17:57:14 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-3-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 2/5] Allow architectures to hook
 KVM_EXIT_SYSTEM_EVENT
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
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

Certain system events require architecture-specific handling. Allow
architectures to intervene for exits unhandled by the default exit
handler.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/kvm/kvm-cpu.h | 1 +
 kvm-cpu.c             | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d..75e42d8 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -20,6 +20,7 @@ void kvm_cpu__run(struct kvm_cpu *vcpu);
 int kvm_cpu__start(struct kvm_cpu *cpu);
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
+bool kvm_cpu__arch_handle_system_event(struct kvm_cpu *vcpu);
 
 int kvm_cpu__get_debug_fd(void);
 void kvm_cpu__set_debug_fd(int fd);
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7dec088..d615c37 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -23,6 +23,11 @@ int __attribute__((weak)) kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 	return VIRTIO_ENDIAN_HOST;
 }
 
+bool __attribute__((weak)) kvm_cpu__arch_handle_system_event(struct kvm_cpu *vcpu)
+{
+	return false;
+}
+
 void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
 {
 	struct kvm_guest_debug debug = {
@@ -224,6 +229,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 			 */
 			switch (cpu->kvm_run->system_event.type) {
 			default:
+				if (kvm_cpu__arch_handle_system_event(cpu))
+					break;
+
 				pr_warning("unknown system event type %d",
 					   cpu->kvm_run->system_event.type);
 				/* fall through for now */
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
