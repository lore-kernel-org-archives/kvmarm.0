Return-Path: <SRS0=hjn/=55=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ADEC2BA19
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 17:06:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B75AA20692
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 17:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HaTDPiB+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B75AA20692
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 361304B10E;
	Mon, 13 Apr 2020 13:06:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5CvHhpDsPe8l; Mon, 13 Apr 2020 13:06:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D37D24B0E2;
	Mon, 13 Apr 2020 13:06:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8444B184
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 10:04:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pk7KU02JsFfm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2020 10:04:00 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 036BD4B096
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 10:03:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586786639;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=tr36Ztz1zaNKdeDfrf7SQyxfeOTbsC/uHO5FgmoVJ30=;
 b=HaTDPiB+yalsPuDlWr+cexb+IGbOw24seOoEfm142LJVyxevnaQY+P8MI+89Y/omC0+0tN
 89hnydv8gyK5odtggvt5hs8dYJMpJL/xW7kVn/T0dKj9GllDWSnA7mLj08ZvBbiz/aD029
 e7ySc8HyPEw2X10wZCDSlYSFKA5oko0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-HezcoG7BMsO29XMtjuj_dg-1; Mon, 13 Apr 2020 10:03:56 -0400
X-MC-Unique: HezcoG7BMsO29XMtjuj_dg-1
Received: by mail-wm1-f69.google.com with SMTP id b203so2615643wmd.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 07:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=DMxjnALOO+13jpd4EXyv1/+VreDyJBNjIrO01oQGGFU=;
 b=ddCkf1WEMIG05E2Lumibwf25eAj1+rfXLzZpBvN7mLrHtZq/eEY+KjbcQ6UMSiOiqL
 3gfEfolUm7MN8C/KcpUjq+MmPnejHtSfgfQZ4szYV9krrKB5gEcRKOSAPKYu53dq7hnZ
 gixWYm1d+eTg2av+eRAOi1dUClwW/e8p6QcYF9d+ZSukDV/n688eC04RXgSl2bO+ssRu
 YjhwoaeMbOjrtDRik585OB4UfSrx0kxZy/JfXe8FQC7TEkBFnBUHdALuRALQHxm5+u6I
 bdFMvkfJ10cz6HKAqA2TzuM3NDDsAT9R7XX15cJC2adJpENBYdgP8iT8mFRAo6TxcK+a
 fxdQ==
X-Gm-Message-State: AGi0PubuVoF2hJWozKUJZHnBCnT6bSzXs+wQESjNrqR+/n1MctjsSdcY
 O/KnlWH/4fIR1lxaDaHy+0o6gGYd8mOkek74oy3hRE/9xAy4h7ohVltUBpwp9sUg9Se2Ju0od8/
 +vNAposVl+jOfudRwcKcfNEFV
X-Received: by 2002:adf:fc4c:: with SMTP id e12mr18660283wrs.265.1586786634645; 
 Mon, 13 Apr 2020 07:03:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypLRZJuELUsSHD7peAwU3uRWTiihVpgUEtD1l8rr9Jo5lHrC+5Swh69bNDnIpYlTippwc8wt9Q==
X-Received: by 2002:adf:fc4c:: with SMTP id e12mr18660255wrs.265.1586786634361; 
 Mon, 13 Apr 2020 07:03:54 -0700 (PDT)
Received: from emanuele-MacBookPro.redhat.com ([194.230.155.239])
 by smtp.gmail.com with ESMTPSA id j10sm11726263wmi.18.2020.04.13.07.03.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Apr 2020 07:03:53 -0700 (PDT)
From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a single
 place
Date: Mon, 13 Apr 2020 16:03:32 +0200
Message-Id: <20200413140332.22896-1-eesposit@redhat.com>
X-Mailer: git-send-email 2.17.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 13 Apr 2020 13:06:30 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The macros VM_STAT and VCPU_STAT are redundantly implemented in multiple
files, each used by a different architecure to initialize the debugfs
entries for statistics. Since they all have the same purpose, they can be
unified in a single common definition in include/linux/kvm_host.h

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/arm64/kvm/guest.c    | 23 +++++++--------
 arch/mips/kvm/mips.c      | 61 +++++++++++++++++++--------------------
 arch/powerpc/kvm/book3s.c |  3 --
 arch/powerpc/kvm/booke.c  |  3 --
 arch/s390/kvm/kvm-s390.c  |  3 --
 arch/x86/kvm/x86.c        |  3 --
 include/linux/kvm_host.h  |  3 ++
 7 files changed, 43 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 23ebe51410f0..3e3aee8b37c0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -29,20 +29,17 @@
 
 #include "trace.h"
 
-#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
-#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
-	VCPU_STAT(halt_successful_poll),
-	VCPU_STAT(halt_attempted_poll),
-	VCPU_STAT(halt_poll_invalid),
-	VCPU_STAT(halt_wakeup),
-	VCPU_STAT(hvc_exit_stat),
-	VCPU_STAT(wfe_exit_stat),
-	VCPU_STAT(wfi_exit_stat),
-	VCPU_STAT(mmio_exit_user),
-	VCPU_STAT(mmio_exit_kernel),
-	VCPU_STAT(exits),
+	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
+	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
+	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
+	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
+	{ "hvc_exit_stat", VCPU_STAT(hvc_exit_stat) },
+	{ "wfe_exit_stat", VCPU_STAT(wfe_exit_stat) },
+	{ "wfi_exit_stat", VCPU_STAT(wfi_exit_stat) },
+	{ "mmio_exit_user", VCPU_STAT(mmio_exit_user) },
+	{ "mmio_exit_kernel", VCPU_STAT(mmio_exit_kernel) },
+	{ "exits", VCPU_STAT(exits) },
 	{ NULL }
 };
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8f05dd0a0f4e..f14b93d02f02 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -39,40 +39,39 @@
 #define VECTORSPACING 0x100	/* for EI/VI mode */
 #endif
 
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x)
 struct kvm_stats_debugfs_item debugfs_entries[] = {
-	{ "wait",	  VCPU_STAT(wait_exits),	 KVM_STAT_VCPU },
-	{ "cache",	  VCPU_STAT(cache_exits),	 KVM_STAT_VCPU },
-	{ "signal",	  VCPU_STAT(signal_exits),	 KVM_STAT_VCPU },
-	{ "interrupt",	  VCPU_STAT(int_exits),		 KVM_STAT_VCPU },
-	{ "cop_unusable", VCPU_STAT(cop_unusable_exits), KVM_STAT_VCPU },
-	{ "tlbmod",	  VCPU_STAT(tlbmod_exits),	 KVM_STAT_VCPU },
-	{ "tlbmiss_ld",	  VCPU_STAT(tlbmiss_ld_exits),	 KVM_STAT_VCPU },
-	{ "tlbmiss_st",	  VCPU_STAT(tlbmiss_st_exits),	 KVM_STAT_VCPU },
-	{ "addrerr_st",	  VCPU_STAT(addrerr_st_exits),	 KVM_STAT_VCPU },
-	{ "addrerr_ld",	  VCPU_STAT(addrerr_ld_exits),	 KVM_STAT_VCPU },
-	{ "syscall",	  VCPU_STAT(syscall_exits),	 KVM_STAT_VCPU },
-	{ "resvd_inst",	  VCPU_STAT(resvd_inst_exits),	 KVM_STAT_VCPU },
-	{ "break_inst",	  VCPU_STAT(break_inst_exits),	 KVM_STAT_VCPU },
-	{ "trap_inst",	  VCPU_STAT(trap_inst_exits),	 KVM_STAT_VCPU },
-	{ "msa_fpe",	  VCPU_STAT(msa_fpe_exits),	 KVM_STAT_VCPU },
-	{ "fpe",	  VCPU_STAT(fpe_exits),		 KVM_STAT_VCPU },
-	{ "msa_disabled", VCPU_STAT(msa_disabled_exits), KVM_STAT_VCPU },
-	{ "flush_dcache", VCPU_STAT(flush_dcache_exits), KVM_STAT_VCPU },
+	{ "wait",	  VCPU_STAT(wait_exits) },
+	{ "cache",	  VCPU_STAT(cache_exits) },
+	{ "signal",	  VCPU_STAT(signal_exits) },
+	{ "interrupt",	  VCPU_STAT(int_exits) },
+	{ "cop_unusable", VCPU_STAT(cop_unusable_exits) },
+	{ "tlbmod",	  VCPU_STAT(tlbmod_exits) },
+	{ "tlbmiss_ld",	  VCPU_STAT(tlbmiss_ld_exits) },
+	{ "tlbmiss_st",	  VCPU_STAT(tlbmiss_st_exits) },
+	{ "addrerr_st",	  VCPU_STAT(addrerr_st_exits) },
+	{ "addrerr_ld",	  VCPU_STAT(addrerr_ld_exits) },
+	{ "syscall",	  VCPU_STAT(syscall_exits) },
+	{ "resvd_inst",	  VCPU_STAT(resvd_inst_exits) },
+	{ "break_inst",	  VCPU_STAT(break_inst_exits) },
+	{ "trap_inst",	  VCPU_STAT(trap_inst_exits) },
+	{ "msa_fpe",	  VCPU_STAT(msa_fpe_exits) },
+	{ "fpe",	  VCPU_STAT(fpe_exits) },
+	{ "msa_disabled", VCPU_STAT(msa_disabled_exits) },
+	{ "flush_dcache", VCPU_STAT(flush_dcache_exits) },
 #ifdef CONFIG_KVM_MIPS_VZ
-	{ "vz_gpsi",	  VCPU_STAT(vz_gpsi_exits),	 KVM_STAT_VCPU },
-	{ "vz_gsfc",	  VCPU_STAT(vz_gsfc_exits),	 KVM_STAT_VCPU },
-	{ "vz_hc",	  VCPU_STAT(vz_hc_exits),	 KVM_STAT_VCPU },
-	{ "vz_grr",	  VCPU_STAT(vz_grr_exits),	 KVM_STAT_VCPU },
-	{ "vz_gva",	  VCPU_STAT(vz_gva_exits),	 KVM_STAT_VCPU },
-	{ "vz_ghfc",	  VCPU_STAT(vz_ghfc_exits),	 KVM_STAT_VCPU },
-	{ "vz_gpa",	  VCPU_STAT(vz_gpa_exits),	 KVM_STAT_VCPU },
-	{ "vz_resvd",	  VCPU_STAT(vz_resvd_exits),	 KVM_STAT_VCPU },
+	{ "vz_gpsi",	  VCPU_STAT(vz_gpsi_exits) },
+	{ "vz_gsfc",	  VCPU_STAT(vz_gsfc_exits) },
+	{ "vz_hc",	  VCPU_STAT(vz_hc_exits) },
+	{ "vz_grr",	  VCPU_STAT(vz_grr_exits) },
+	{ "vz_gva",	  VCPU_STAT(vz_gva_exits) },
+	{ "vz_ghfc",	  VCPU_STAT(vz_ghfc_exits) },
+	{ "vz_gpa",	  VCPU_STAT(vz_gpa_exits) },
+	{ "vz_resvd",	  VCPU_STAT(vz_resvd_exits) },
 #endif
-	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll), KVM_STAT_VCPU },
-	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll), KVM_STAT_VCPU },
-	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid), KVM_STAT_VCPU },
-	{ "halt_wakeup",  VCPU_STAT(halt_wakeup),	 KVM_STAT_VCPU },
+	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
+	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
+	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
+	{ "halt_wakeup",  VCPU_STAT(halt_wakeup) },
 	{NULL}
 };
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 5690a1f9b976..55cb728ba06e 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -36,9 +36,6 @@
 #include "book3s.h"
 #include "trace.h"
 
-#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
-#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
-
 /* #define EXIT_DEBUG */
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 6c18ea88fd25..fb8fa7060804 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -35,9 +35,6 @@
 
 unsigned long kvmppc_booke_handlers;
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmio",       VCPU_STAT(mmio_exits) },
 	{ "sig",        VCPU_STAT(signal_exits) },
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 19a81024fe16..1a7bf8759750 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -57,9 +57,6 @@
 #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
 			   (KVM_MAX_VCPUS + LOCAL_IRQS))
 
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "userspace_handled", VCPU_STAT(exit_userspace) },
 	{ "exit_null", VCPU_STAT(exit_null) },
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8124b562dea..fb035d304004 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -97,9 +97,6 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
-#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
-#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
-
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d58beb65454..e02d38c7fff1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1130,6 +1130,9 @@ struct kvm_stats_debugfs_item {
 #define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
 	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
 
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
+
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
