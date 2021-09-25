Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE328C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B83461265
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5B83461265
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 099EE4B149;
	Fri, 24 Sep 2021 20:56:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gEy0Mt6gk13W; Fri, 24 Sep 2021 20:55:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E11A44B133;
	Fri, 24 Sep 2021 20:55:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B9274B134
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C0upKHqgNDRk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:56 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A4EF4B150
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:55 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 e2-20020ad45582000000b0037e7bdc88d4so44331192qvx.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=6T7U4FXDkZ4wSGR8PtdmKZv58jArlrzHMsBoVgMor+w=;
 b=KgOQHaJyXdK+GWQ+2KMuSUf8InFqvhIUK/RxDy04xLvESXB6G2X9Jrj1x+kNBAkBne
 PhOPZCYyVTUtZk6I8w8hOOLbiyX3n5M/2piepUvMuIeJBbfMZODdPBqWRJwDQLPaSQaV
 ewfzmZaiB/oD/jH9DEY0fO4j1eb1EJD3/BuOYOmy3Z3p8tliNWZ3jgZE0pCoLAqL2Vps
 m5RIhb9I1VErm10gqjjLk+L9EXIdeOdjyBhSzqXoCpxEKT+r+HDGPmZylA5xz8VPnVSN
 xkjZ3BURokP4QeF2PBXLrqVKvIiL/oQGDt7iU9yMu62sr1RqEYFvj68QISSAxPBFN6sX
 XnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=6T7U4FXDkZ4wSGR8PtdmKZv58jArlrzHMsBoVgMor+w=;
 b=U4l+ivJWEJjU7EAVicPxRpbqchWqXGWD2rf+YaY7EohD9fyJRtwPvPQ7aSJgdgp+Nc
 NTlpV9SeYBNdEGvP8BIz8O+1A2tewthKFfA+szp9qzua/dwNwErdnRoYe8bLcHgUDI9t
 bdocHTXk+2UDZ3/cUPi0k8jkG1j/FIJhSHm3QDEJuzIk6GZ5gxKmdRa/6bZ0f3sxcYxo
 IDoUnAdDsBWkIeha/vg3Y1x4Bo21Bm6k/gq2bEdxPfCkuXYb9MagU7vZ7fBrrSp73944
 4bq01Pb4LYdclCEhJF/AlEQQuIuCUXsW7q2IbSo5jJpiDeuPRZevnaNTODumjggVgsTK
 gEFQ==
X-Gm-Message-State: AOAM530GRYr5VPxjYjiMthXq7joacGhUzGE22K/eEuRz9TRR1D+URYS/
 e02cjRuVLIDgW5rPpx32FChYa00JHdQ=
X-Google-Smtp-Source: ABdhPJxLb+obVS+gVpjC5G0ly7yv0fDwQXsQOvFcbn5XQYMMnEu8TwQl4KzgaC2kLIcfTeYpbPGVyglE2HA=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:ad4:446f:: with SMTP id
 s15mr13334020qvt.3.1632531354888; 
 Fri, 24 Sep 2021 17:55:54 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:25 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 11/14] KVM: stats: Add stat to detect if vcpu is currently
 blocking
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, David Matlack <dmatlack@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

From: Jing Zhang <jingzhangos@google.com>

Add a "blocking" stat that userspace can use to detect the case where a
vCPU is not being run because of a vCPU/guest action, e.g. HLT or WFS on
x86, WFI on arm64, etc...  Current guest/host/halt stats don't show this
well, e.g. if a guest halts for a long period of time then the vCPU could
appear pathologically blocked due to a host condition, when in reality the
vCPU has been put into a not-runnable state by the guest.

Originally-by: Cannon Matthews <cannonmatthews@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
[sean: renamed stat to "blocking", massaged changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h  | 3 ++-
 include/linux/kvm_types.h | 1 +
 virt/kvm/kvm_main.c       | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 655c2b24db2d..9bb1972e396a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1453,7 +1453,8 @@ struct _kvm_stats_desc {
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT)
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_ICOUNTER(VCPU_GENERIC, blocking)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2237abb93ccd..c4f9257bf32d 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,6 +94,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
+	u64 blocking;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fe34457530c2..2980d2b88559 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3208,6 +3208,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	bool waited = false;
 
+	vcpu->stat.generic.blocking = 1;
 	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(&vcpu->wait);
@@ -3223,6 +3224,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	finish_rcuwait(&vcpu->wait);
 
 	kvm_arch_vcpu_unblocking(vcpu);
+	vcpu->stat.generic.blocking = 0;
 
 	return waited;
 }
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
