Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859F5C352A1
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A58403A6;
	Wed, 30 Nov 2022 18:10:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 93J1TvNohO0m; Wed, 30 Nov 2022 18:10:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B65B4B74F;
	Wed, 30 Nov 2022 18:10:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A354B649
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gWDTqKPV5qY3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:47 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2F514B653
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:45 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 d2-20020a170902cec200b001899479b1d8so9786016plg.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=9siMTxNa3uAP5fZIzNGfC6XHHMwgiKNlJBnmhPRbPro=;
 b=ChW1Nps965Qp18Q6+pUQJ9HaZg+bsuoNAPERVx5vtZW0btHu7mssz1zq2swGpNBnOO
 xeSdi4iwUV2bHGTbxVVeaFbSd7hDQi+GikXoUOMA+ds3pfZUeA7jrH6W4f5P6c5pwr9B
 U3XVYRZQ7E6Yrhd7CzlvGARnYPdmscwvfkiQmHkzv9OBvomDdeXYt/xK1+qhaSsZxp4N
 N9NxXX+4yvTNEHy1B6JV5V2Zu6j+0V3rnH/CXLtu/bfRs93WfDHZOPYCsGgSMQHV2o0D
 eDMkxgUR8PhMKsVPRy8wQRrlE6YEWvcusAVfquXtz1XnSeeHga0XG3gUzph6fBCETn2R
 dxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=9siMTxNa3uAP5fZIzNGfC6XHHMwgiKNlJBnmhPRbPro=;
 b=GpLP+TYUTAmYnX5Kz/x7evjWjNyzW36aVtWhW4C+Ix7dNcMEzmfWts4tOZ/l+l8hmj
 3I0l+KwGPBcRhe1eEeKkHbDbwOSvDrR0UGIMnzVYa+l4nKqRE0K55R7uFOc0Jhv0Aocb
 3bZO8nTwABGRtO/uVut3om/aiZzxInPxixyjcTXIAyk6xKG/OVPMUSnIf+tML23kEzR7
 eCCm1cJwAcAZoQzz2xQ3H5LGY1vEp7LdhpggVRf9trIJSENGVY5toCPdUCRlAvg0CkyW
 HaRiSgI3Lbuuon5jlYqmNRD8Kh60kiXemD2GV4fk6nE9Rjd6H0mJ0JZClUQKn5sWOrbh
 5a+Q==
X-Gm-Message-State: ANoB5plP4OsM/O0F0A8TlCzE67MWp109pEngI++wZx0JgnveeBHkop9I
 10LtgoVg3ZuKKLf7Gbsg9IohcEP0KRg=
X-Google-Smtp-Source: AA0mqf6VC0HWkGfsmW3gbMncl1EgCwyuCiATzAwaZawtYWdw9a793FC2Aun76Ue7cKpeYcZGTN4fYSLmS4k=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:43a4:b0:219:1d0a:34a6 with SMTP id
 r33-20020a17090a43a400b002191d0a34a6mr2520763pjg.1.1669849843212; Wed, 30 Nov
 2022 15:10:43 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:22 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-39-seanjc@google.com>
Subject: [PATCH v2 38/50] KVM: SVM: Check for SVM support in CPU compatibility
 checks
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Check that SVM is supported and enabled in the processor compatibility
checks.  SVM already checks for support during hardware enabling,
i.e. this doesn't really add new functionality.  The net effect is that
KVM will refuse to load if a CPU doesn't have SVM fully enabled, as
opposed to failing KVM_CREATE_VM.

Opportunistically move svm_check_processor_compat() up in svm.c so that
it can be invoked during hardware enabling in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 49ccef9fae81..9f94efcb9aa6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -543,6 +543,14 @@ static bool kvm_is_svm_supported(void)
 	return true;
 }
 
+static int __init svm_check_processor_compat(void)
+{
+	if (!kvm_is_svm_supported())
+		return -EIO;
+
+	return 0;
+}
+
 void __svm_write_tsc_multiplier(u64 multiplier)
 {
 	preempt_disable();
@@ -4087,11 +4095,6 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
-{
-	return 0;
-}
-
 /*
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
