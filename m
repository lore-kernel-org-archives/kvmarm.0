Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D5FC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50BF761038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 50BF761038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065E44B174;
	Fri,  8 Oct 2021 22:13:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OXYGYKnPkxh7; Fri,  8 Oct 2021 22:13:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04F94B156;
	Fri,  8 Oct 2021 22:13:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21DD04B13E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MblOle1wTkyV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:33 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C9204B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:31 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 v203-20020a25c5d4000000b005bb21580411so2358387ybe.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=JkZfdKKKsnqnpAtGUC7eJv8NSTwENPUfH6MKqHK3m28=;
 b=qVLIqxee/wprC+4bjZNYJueP2zjkd+ggVBKmgUwNSOpnEV7X/9yGfblAJrRqdCWEih
 HkkaQsOOaOeL+/6gKeVGYHju8vK+HKNcdt3bTPsONepW8SXVyQdRvqfaAKZcB8+jVwae
 l3QyVEsfib1Ds5XSLDwK5fjGQZuWnnjDxgzphYDPgXfwssEpRJVHvOakRnpFdPD78q0R
 +0gwjhJzjz6GJsBbS0TZrWfFGUf6BV3+uE57g+PTVVc8UKWIe6wyeSoVcPpQNBbE7SiU
 oPp2V17b+NBHZjC8Iixu81AY6DPeXf4DpNjHUN5949xj5Ej8bfX8i2do7PuBJAHe/oBY
 ATyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=JkZfdKKKsnqnpAtGUC7eJv8NSTwENPUfH6MKqHK3m28=;
 b=ZdmDRNr1gvJO7YeDj7q56KfJzRahIyBHAqaECzZaDkTNfVp54F3YhT4cXj74d3NDvu
 V2gpq/wPEEKPm3OHSmCyT6UFNJo5pThIpM3RaEsb412cC4/n9esslNcd9n5YMv+qKSGt
 4ZyvkhjGi+tTif3oTiBFW5JATvKQp21R1TdE69rrNgrRR2n9inoCZEfW/QkZdaFLal6c
 8IMKaXlUWqjsEVvfNGBYw5LsJLOqro1vzBOTrDP6oRzj+7l17K+c7049eVdAtB97AXGn
 zlQh5vuSDaLYU3ax7E0A7EYuJW0FODkNHb6XyJncJld5gWKGJVk820bkWLKhH2A46Q5y
 IcUA==
X-Gm-Message-State: AOAM533bsZUwTnr5suIQ4icHeXzzDdWn0/UOOPMblEavNfctun/9+08v
 9pfaachTnYeEEBn9Ljs3gdq+bWMMDvk=
X-Google-Smtp-Source: ABdhPJzgeMmRSEoifPybAsuoSY+JDjln6XTZNwptycydEyLK/6KcdeEb7uS4dZEit5L6yoPPTC+t8rdx1rg=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a5b:d03:: with SMTP id
 y3mr7590634ybp.400.1633745611129; 
 Fri, 08 Oct 2021 19:13:31 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:13 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 20/43] KVM: VMX: Skip Posted Interrupt updates if APICv is
 hard disabled
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Anup Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

Explicitly skip posted interrupt updates if APICv is disabled in all of
KVM, or if the guest doesn't have an in-kernel APIC.  The PI descriptor
is kept up-to-date if APICv is inhibited, e.g. so that re-enabling APICv
doesn't require a bunch of updates, but neither the module param nor the
APIC type can be changed on-the-fly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3263056784f5..351666c41bbc 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -28,11 +28,14 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	unsigned int dest;
 
 	/*
-	 * In case of hot-plug or hot-unplug, we may have to undo
-	 * vmx_vcpu_pi_put even if there is no assigned device.  And we
-	 * always keep PI.NDST up to date for simplicity: it makes the
-	 * code easier, and CPU migration is not a fast path.
+	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST and
+	 * PI.SN up-to-date even if there is no assigned device or if APICv is
+	 * deactivated due to a dynamic inhibit bit, e.g. for Hyper-V's SyncIC.
 	 */
+	if (!enable_apicv || !lapic_in_kernel(vcpu))
+		return;
+
+	/* Nothing to do if PI.SN==0 and the vCPU isn't being migrated. */
 	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
 		return;
 
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
