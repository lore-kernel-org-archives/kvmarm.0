Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8660C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 17:46:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F43565120
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 17:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F43565120
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF7F4B590;
	Tue, 16 Mar 2021 13:46:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vVoA85w-A5IB; Tue, 16 Mar 2021 13:46:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F954B5DB;
	Tue, 16 Mar 2021 13:46:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A38894B5EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 13:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RpF9RCq1Jb9M for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 13:46:49 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C66C14B4FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 13:46:46 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id y16so10951837wrw.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 10:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8CWHxiV0ZKizo+vjFshSgCNglE9MeCQCWx2fDMf8iU8=;
 b=gYo2kERL9GIyhaZOa6PnViq0BRXBGefSRBZieSYFhlS1lW0yoNCUiliN2Cn6l4BirX
 BlvvIXzdoXNmkgVaURC+XAcXa0lXCs2NdACd8cPProNkQhZcbPlREIWB6dnrFIdi59j2
 ytNxz7q3toFgoz1mpxdX75jcbjJoLrOPdzZaDbYTpqgMRrqOu6AACZ92tZBXis10/464
 GGnBnjTFr9UdrTfL8cl0RFjhKCcegioXqStezi2b2K6dg/2HxW1W8yqM4aaV0DV4AvL+
 DXyo460cKTkPZQumL0LtSLdIGqDOZLV5FHjZyQlHjCQeXsDDdU2PW1nI+j9hewIITYy4
 03qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8CWHxiV0ZKizo+vjFshSgCNglE9MeCQCWx2fDMf8iU8=;
 b=nnLcdPT6BOhc0mP+vXGMQL1eVllcwAKzYj/tETg0T/R2R+AnNlteh8XaexphawWv40
 NzbDDv7dGn/WtLOhcz2st+Z2HRCfZ7ZIKy8XojnbmLDmxemf1vXAkJ/SBNjfHGSSME2d
 Ta4p5sfCwrQvL4MF3u89lSN8QtFPSodF8cY44qgQqWx3pdtCUpKVxnOUz+aZ+p2SGhPK
 cy0m+TcIBaDokMsCLngVTDbUhHN+YTS4ipl+ZHLagEwPKQxjqOLWkUREIz9t9Ck6CMhv
 SR3a3K89YHIZMgtNAs5i1LdBHPbE0Dji9S1SjFDPsQpyuHHGTmPaVMUUjLQ98Ng/cSyn
 JIpA==
X-Gm-Message-State: AOAM530wsR76Ue5HeT/EXr5YIgM95wZQ5+V6S8CV+XZha7tPZyG4x0eM
 1B/wUZH/YdN07y0JR+JQBQaJCg==
X-Google-Smtp-Source: ABdhPJy/Yk1N4Dwd5vCd00S1/qPonp2CAvh1R3Oab2RFqzCIWDW/+HMqKnOh2qKqDNLLxfncBWs3yg==
X-Received: by 2002:a5d:4d0f:: with SMTP id z15mr216557wrt.192.1615916805635; 
 Tue, 16 Mar 2021 10:46:45 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id t8sm22607136wrr.10.2021.03.16.10.46.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Mar 2021 10:46:45 -0700 (PDT)
Date: Tue, 16 Mar 2021 17:46:42 +0000
From: Quentin Perret <qperret@google.com>
To: Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
Message-ID: <YFDvAqgimPvpgiwQ@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
 <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com>
 <YFCqYT3Ib8kAN7/c@google.com> <YFDAyhjPEsnZ4N3P@google.com>
 <eb70a071-4d4a-885f-36a7-3b20358e5513@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eb70a071-4d4a-885f-36a7-3b20358e5513@arm.com>
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tuesday 16 Mar 2021 at 16:16:18 (+0100), Mate Toth-Pal wrote:
> On 2021-03-16 15:29, Quentin Perret wrote:
> > On Tuesday 16 Mar 2021 at 12:53:53 (+0000), Quentin Perret wrote:
> > > On Tuesday 16 Mar 2021 at 13:28:42 (+0100), Mate Toth-Pal wrote:
> > > > Changing the value of MT_S2_FWB_NORMAL to 7 would change this behavior, and
> > > > the resulting memory type would be device.
> > > 
> > > Sounds like the correct fix here -- see below.
> > 
> > Just to clarify this, I meant this should be the configuration for the
> > host stage-2. We'll want to keep the existing behaviour for guests I
> > believe.
> 
> I Agree.

OK, so the below seems to boot on my non-FWB-capable hardware and should
fix the issue. Could you by any chance give it a spin?

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index b93a2a3526ab..b2066bd03ca2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -76,10 +76,11 @@ struct kvm_pgtable {

 /**
  * enum kvm_pgtable_prot - Page-table permissions and attributes.
- * @KVM_PGTABLE_PROT_X:                Execute permission.
- * @KVM_PGTABLE_PROT_W:                Write permission.
- * @KVM_PGTABLE_PROT_R:                Read permission.
- * @KVM_PGTABLE_PROT_DEVICE:   Device attributes.
+ * @KVM_PGTABLE_PROT_X:                        Execute permission.
+ * @KVM_PGTABLE_PROT_W:                        Write permission.
+ * @KVM_PGTABLE_PROT_R:                        Read permission.
+ * @KVM_PGTABLE_PROT_DEVICE:           Device attributes.
+ * @KVM_PGTABLE_PROT_S2_NOFWB:         Don't enforce Normal-WB with FWB.
  */
 enum kvm_pgtable_prot {
        KVM_PGTABLE_PROT_X                      = BIT(0),
@@ -87,6 +88,8 @@ enum kvm_pgtable_prot {
        KVM_PGTABLE_PROT_R                      = BIT(2),

        KVM_PGTABLE_PROT_DEVICE                 = BIT(3),
+
+       KVM_PGTABLE_PROT_S2_NOFWB               = BIT(4),
 };

 #define PAGE_HYP               (KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index c759faf7a1ff..e695d2e1839d 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -144,13 +144,16 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL           0xf
+#define MT_S2_WEAK             MT_S2_NORMAL
 #define MT_S2_DEVICE_nGnRE     0x1

 /*
  * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
- * Stage-2 enforces Normal-WB and Device-nGnRE
+ * Stage-2 enforces Normal-WB and Device-nGnRE by default. The 'weak' mode
+ * honors Stage-1 attributes.
  */
 #define MT_S2_FWB_NORMAL       6
+#define MT_S2_FWB_WEAK         7
 #define MT_S2_FWB_DEVICE_nGnRE 1

 #ifdef CONFIG_ARM64_4K_PAGES
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index dd03252b9574..1ff72babe565 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -214,6 +214,8 @@ static int host_stage2_idmap(u64 addr)

        if (is_memory)
                prot |= KVM_PGTABLE_PROT_X;
+       else
+               prot |= KVM_PGTABLE_PROT_S2_NOFWB;

        hyp_spin_lock(&host_kvm.lock);
        ret = kvm_pgtable_stage2_find_range(&host_kvm.pgt, addr, prot, &range);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3a971df278bd..bd1b8464a537 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -343,6 +343,9 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
        if (!(prot & KVM_PGTABLE_PROT_R))
                return -EINVAL;

+       if (prot & KVM_PGTABLE_PROT_S2_NOFWB)
+               return -EINVAL;
+
        if (prot & KVM_PGTABLE_PROT_X) {
                if (prot & KVM_PGTABLE_PROT_W)
                        return -EINVAL;
@@ -510,9 +513,18 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
        bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-       kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
-                           PAGE_S2_MEMATTR(NORMAL);
+       bool nofwb = prot & KVM_PGTABLE_PROT_S2_NOFWB;
        u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
+       kvm_pte_t attr;
+
+       WARN_ON(nofwb && device);
+
+       if (device)
+               attr = PAGE_S2_MEMATTR(DEVICE_nGnRE);
+       else if (nofwb)
+               attr = PAGE_S2_MEMATTR(WEAK);
+       else
+               attr = PAGE_S2_MEMATTR(NORMAL);

        if (!(prot & KVM_PGTABLE_PROT_X))
                attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
