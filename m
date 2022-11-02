Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7768C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:19:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F144B7B6;
	Wed,  2 Nov 2022 19:19:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MM7hpOMJGOdT; Wed,  2 Nov 2022 19:19:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F06A4B803;
	Wed,  2 Nov 2022 19:19:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62F9C4B81A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3rGZ30lu6rSP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:25 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D0144B7E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:25 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 s82-20020a632c55000000b0046b2491aa95so93154pgs.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=Pp3PbLfGlbPMUpUfY94YYIKSvd3QEyEjimXY5GHh7Do=;
 b=UkZGnXGmq2elzgV9DLUz74QXF30iTWbFGDiWfdaXhQTrFX8aiqCFVBpq5xcu6/5CJ0
 6CAeS4zBndyLbi6uL4aOTOJPom/GUXPjp+wnaiLNi/IOKHaUUiAdDM0lQqJcKi8lJ3vx
 vnARJXxit3idHJ3CVkd3Epv6mh/Uh5po1QC+vmSMzcdxDA+trq8VPV/HTVpleuhXsuBJ
 gB5evBsfkJOotXoUamKJrE8Yp7t9k0CZooSYyZMUGEw+wssTud1LYZ35nFOFQX6SsKf7
 8kThfTBVhIqoMM2+KcJViQg4ABdkLDTwvbAbS0YvwKJ8JO2nHVa2hjZQKtmcKqW09CRW
 6M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Pp3PbLfGlbPMUpUfY94YYIKSvd3QEyEjimXY5GHh7Do=;
 b=Xdn+l0tHOACHII03HVAuPVwjbgIOpZEL2DfKoYlg/Snd4XJGlaES7Wpzaluh4Nhutr
 +2xmsP/uYF+xUbZAbDg1pypbmrthPIXD8T1jkdEF19BQCSyaClBrfXQncyVxl4EWF2V1
 Ni3TFcXnEl9LBZ+FxMqpnNjbBzmOG5OzrPfvNlaM5UNAgzqqBRhvX8/XUQ8HtCmn8Ntm
 oFO7Tw+ar0riWsYUcOC3Uv/JXx/OGSoMD5Uaws460xdvNkbQiFH5WhbEz4D3QFCqEUiu
 hW9nyKorzP7WS4tbI/1EW+NFPHS0gReTk2RxxQxYlhidzYSmOeaLXxpki507rPINfeZi
 /uiQ==
X-Gm-Message-State: ACrzQf28cyRtbcG3I142WsimVtCtHbykadH+/E6JBtqK1CsARJ8LmCPE
 S7KSJdl+KtrIkXHa33ThJ5wiFOWaRFo=
X-Google-Smtp-Source: AMsMyM5BN48AgcZOI4nVxc2uFg8TXUQwjAkA5TEHVSI5KiQDtZoUe78o5/c87/pf9J/oxQANcuw7e+pFPCs=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1206:0:b0:470:18c:1489 with SMTP id
 h6-20020a631206000000b00470018c1489mr6904894pgl.357.1667431164538; Wed, 02
 Nov 2022 16:19:24 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:33 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-7-seanjc@google.com>
Subject: [PATCH 06/44] KVM: s390: Move hardware setup/unsetup to init/exit
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
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

Now that kvm_arch_hardware_setup() is called immediately after
kvm_arch_init(), fold the guts of kvm_arch_hardware_(un)setup() into
kvm_arch_{init,exit}() as a step towards dropping one of the hooks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8395433a79b2..1aaee15211f2 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -323,21 +323,12 @@ static struct notifier_block kvm_clock_notifier = {
 
 int kvm_arch_hardware_setup(void *opaque)
 {
-	gmap_notifier.notifier_call = kvm_gmap_notifier;
-	gmap_register_pte_notifier(&gmap_notifier);
-	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
-	gmap_register_pte_notifier(&vsie_gmap_notifier);
-	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
-				       &kvm_clock_notifier);
 	return 0;
 }
 
 void kvm_arch_hardware_unsetup(void)
 {
-	gmap_unregister_pte_notifier(&gmap_notifier);
-	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
-	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
-					 &kvm_clock_notifier);
+
 }
 
 static void allow_cpu_feat(unsigned long nr)
@@ -517,6 +508,13 @@ int kvm_arch_init(void *opaque)
 	if (rc)
 		goto err_gib;
 
+	gmap_notifier.notifier_call = kvm_gmap_notifier;
+	gmap_register_pte_notifier(&gmap_notifier);
+	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
+	gmap_register_pte_notifier(&vsie_gmap_notifier);
+	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
+				       &kvm_clock_notifier);
+
 	return 0;
 
 err_gib:
@@ -533,6 +531,11 @@ int kvm_arch_init(void *opaque)
 
 void kvm_arch_exit(void)
 {
+	gmap_unregister_pte_notifier(&gmap_notifier);
+	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
+	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
+					 &kvm_clock_notifier);
+
 	kvm_s390_gib_destroy();
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
 		kvm_s390_pci_exit();
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
