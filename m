Return-Path: <SRS0=FNOB=O5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0337AC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B04761038
	for <kvmarm@archiver.kernel.org>; Sat,  9 Oct 2021 02:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B04761038
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F8544B12C;
	Fri,  8 Oct 2021 22:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IbyvgvYBKr3d; Fri,  8 Oct 2021 22:13:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5FF4B1A3;
	Fri,  8 Oct 2021 22:13:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298974B1AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a4d7cHpk54cP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 22:13:57 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A9C44B12E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 22:13:56 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 124-20020a251182000000b005a027223ed9so14953809ybr.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 19:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=BSxRZmRXQvTOhREE9VGZ+Ow0Eb/sKeyruI9O693O544=;
 b=Nq6mAzMn8lDyB3Y76plThgBUM5+lzQFzvcnH6nf4492bBrVyn9ck7GKbYqiO0fPX1k
 RtO6Tbh+fVA8kKKB5dfSn40puADaw1AZTWHfUhXRqDCPxkpaLN/jW7P8wDCNf5O+ZN2W
 o20t3D7+BvjahIP2EWoNGDpuq75LRMnoeyo+2e07rHfheQBVKmrV3GR1iNU5W+dWkxdx
 q3sbYxMcvibv82b/Gn150GZhBkJ6/ximka4nAWWizGZ/RcYQl+xqLlKkBDXDFmHazy20
 mn7+XEIvuuwdQeI+uMO7ytk/Gxh9aFkTHmGL9NUGs5Tnak8RvnSPI5FeOcxYuto9C6rq
 7/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=BSxRZmRXQvTOhREE9VGZ+Ow0Eb/sKeyruI9O693O544=;
 b=fvIbfLmA9KU3uh8AJtwVeydH2ICkM3cK0Rb4EW0G0eCCdmsHEEoL8QopKhtaJtxTrh
 CuEHMxH5Omuvpiup024pDzGPH+giguIs/iBuDpKQSxiZbJjiLD4EQXgOIcAi/edJDsVt
 hgyvtYICG7cpFGJSDjUjd8Ua2aWwkUgD10mKDm1KjxAWNBuqUA74iAJopV8U36RSD70F
 WszTlNgeA5VuG1omuBtUAsCNqRaIwkJfl5pfYpxCzhRobhB7cp7DaL812TCAydIEXaO5
 xaZAXwAFiFC7BZYe/QeOJ5PftMnW7ieNjgtymh38vdt1L1AMOKk0j3ZeG1iMFjrP/cS2
 +hMg==
X-Gm-Message-State: AOAM5336LGYqHUGpD6Uk81SKq04zES4eMW4J1SNwFR7Ie+tVhuANRYBV
 Ta+oyNrM0FJ8Y+1x1EFsGYz2uN21X1w=
X-Google-Smtp-Source: ABdhPJwWmIgGATZaEFLCpRZX3pSkHkB9RK0xc5KzmBhnfa/imJ82wP/Pf1l0pMZYT2dHdA6zyBMoRuy25Io=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5402:: with SMTP id
 i2mr7429080ybb.312.1633745635912; 
 Fri, 08 Oct 2021 19:13:55 -0700 (PDT)
Date: Fri,  8 Oct 2021 19:12:23 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-31-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 30/43] KVM: Drop unused kvm_vcpu.pre_pcpu field
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

Remove kvm_vcpu.pre_pcpu as it no longer has any users.  No functional
change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1fa38dc00b87..87996b22e681 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -304,7 +304,6 @@ struct kvm_vcpu {
 	u64 requests;
 	unsigned long guest_debug;
 
-	int pre_pcpu;
 	struct list_head blocked_vcpu_list;
 
 	struct mutex mutex;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c870cae7e776..2bbf5c9d410f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -426,7 +426,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
 
-	vcpu->pre_pcpu = -1;
 	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
 
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
