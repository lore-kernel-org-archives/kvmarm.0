Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5730C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58E92611CA
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 00:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58E92611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 032FB4B0B3;
	Wed,  3 Nov 2021 20:26:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9GJayCFkJ-qz; Wed,  3 Nov 2021 20:26:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A69204B125;
	Wed,  3 Nov 2021 20:26:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D18ED4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f0i6qPZ7F2wA for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 20:26:03 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C76E4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 20:26:02 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 z4-20020a634c04000000b00299bdd9abdbso2366832pga.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Nov 2021 17:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=YU3JQHoEXhNYeqTaFGElIxIrX+lTdkV7tmvn1pNhx20=;
 b=nzIiCi8a3FdUTPNh7ytN/z1OZHuDUfxPkVLwkX7a0tH3K3c1YU/GUrVbVsUKogWulg
 8TV0o+lCCtBLbDlyn4CdD1ZyDyGmDuKpEashuorjvvAytB9Fha6Xh4GdoRmbK2lCIj46
 yaw8bm9yIsgJfAeOZzVP5kZxJzf5HvyCshSjBFStaw+bzKBcK6bPZX6ZcbGAXqRyq2X0
 r24cJ2J/KvfMuDyi9skDCmfAMeR4jILYlAAhpoLRq8XhdUkbVLo1pJ78Onj43zLqECqm
 BUFjMpHQOpmAXdYIVQtZSEVPXFkfrUmNQanymXLbwXrV/MiRmrChRqGkV2fOUirqVkRC
 KbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=YU3JQHoEXhNYeqTaFGElIxIrX+lTdkV7tmvn1pNhx20=;
 b=vDWvhHaGjE1C49qwzdJYgcav/gCt4+YSaY5hVsn4EL9sYCdFsps/PNQ0GwAwD+1qDC
 Cy+3WMcAM+vDiUGku/Rlt0/f89ebBw0NJoha8QZ1+UcZrB1ZlUaXrXISNJCfv1Odij8K
 Tk3UOCa9UrcqzbPjvoAthpCZ1K/RytYyrzDXu0t8spY4PxWnpm/HxdufuR3lD6YoROAp
 KvKDcqXmkTU07UlnyFY48WjTn1QfNJT1a0C7lgww1w5CJgy8jsCcaH1CxFKE7f/bFV+4
 nWqMdN3yc1nD1pPcj6xNKaBprR3fGG1ECKh/NB3pFRSSjAHz7yYKyV8Tro6tITg1wh5q
 4xlw==
X-Gm-Message-State: AOAM53101jxA58dJHjt7YDB/B2qsae3qW7DkIJdtGx1SQJ2CRQuNd2rF
 FjVEBzWAE/UvM9NONCKfiIk92dAusBI=
X-Google-Smtp-Source: ABdhPJweDq2zn2AkOEc4n/Ejh97liBXXjVYy6U4pABPdgYlHkkJl2at3TcV1J/XikSLWHiPxtEuWDooqyFQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:16c6:b029:32d:e190:9dd0
 with SMTP
 id l6-20020a056a0016c6b029032de1909dd0mr48630576pfc.70.1635985561569; Wed, 03
 Nov 2021 17:26:01 -0700 (PDT)
Date: Thu,  4 Nov 2021 00:25:03 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 02/30] KVM: Disallow user memslot with size that exceeds
 "unsigned long"
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
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-riscv@lists.infradead.org,
 Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

Reject userspace memslots whose size exceeds the storage capacity of an
"unsigned long".  KVM's uAPI takes the size as u64 to support large slots
on 64-bit hosts, but does not account for the size being truncated on
32-bit hosts in various flows.  The access_ok() check on the userspace
virtual address in particular casts the size to "unsigned long" and will
check the wrong number of bytes.

KVM doesn't actually support slots whose size doesn't fit in an "unsigned
long", e.g. KVM's internal kvm_memory_slot.npages is an "unsigned long",
not a "u64", and misc arch specific code follows that behavior.

Fixes: fa3d315a4ce2 ("KVM: Validate userspace_addr of memslot when registered")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 99e69375c4c9..83287730389f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1689,7 +1689,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	id = (u16)mem->slot;
 
 	/* General sanity checks */
-	if (mem->memory_size & (PAGE_SIZE - 1))
+	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
+	    (mem->memory_size != (unsigned long)mem->memory_size))
 		return -EINVAL;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		return -EINVAL;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
