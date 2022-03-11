Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D204C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 883AD4B093;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eODzegoq+5mu; Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD9B849EC1;
	Fri, 11 Mar 2022 03:48:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D54A40C58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hP2vcxwaYnk9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:34 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1E6C40C2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:33 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 41-20020a17090a0fac00b001bfcd158e65so2244637pjz.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=j95pgE4Sx8peHA829tzkUc37bNityDTC3xUJdMO2UzA=;
 b=eY6emTpNoacvuiaoysnSFSYEGI+0B+krHa4P/Kh4D2MAjDRyvsIDsQzdiBWa0mReKe
 wLLIOmJC46PoM8Ve2y9iabrtTA3QVfRHxFm60wkR7QuQ3z3KjIr+FBV3ypD6+hqr/YlG
 oW2es0oK5N9Ctdp+T7UEZqjXrpgspiy/S7kJWnoT89pQXVGng1c0NPgbAZi4G2rX77Df
 GywIyvqUz+kS6x19Cro3q/w81nweCY468m7CiSYcFHlOvSXrGNZgMoAREj7DhcA1MQv+
 Usb8QAEJ//5umwpZGGeozCTn8uddNLyxyhaHsmzSCQQKz02S7oHN67gRirf+EMGfG7em
 pUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=j95pgE4Sx8peHA829tzkUc37bNityDTC3xUJdMO2UzA=;
 b=sqvDdT6vS2i7/gLJGivShTYZT8d8wkLtazMYIpeJyPGIDOz9PY8XfTfHoUD6asAxV8
 aW7Mw6z6SZj2/LaFq4dWMPCmA1UfCRNIp3Xr5njD9/3zSd0dEux6KaEQogRinRoTE0Ce
 /GuwDkQhx3iz11OoRG8lgEmNV59WheZlzHI0mJut7IeFcVObd2Bs4dHAigj6K0Y8H1sF
 l/kSKjCZ0QyOIrruRLDHW9mxchYVT1BFRjCF3yjRkBgHq+VnjxD+V0Qe/idBx6cjbmdk
 juA1ZXAfYvFG3vsLSgW6ZHGUsgB3+MY/p39OPURGWbSa8f1tEpykJuTp7lfQwEN4y8PI
 hGAQ==
X-Gm-Message-State: AOAM531J32QVFQI6t0exDjD905af1aW2XR7pivev9FyM6ZFEb3sHH3MC
 Rnlju45oExI9Uji86DMvSWhvMPHxqdll4A==
X-Google-Smtp-Source: ABdhPJyr0Yxi/VkLVPG0JOeVLGZN1qgnMSwCFGFVa2lsMkBsD9BSYG73ywf0RhTzqzlrQfQDXUPJWYoLTcZWYQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1a0b:b0:4cf:9a9:5c5f with SMTP
 id g11-20020a056a001a0b00b004cf09a95c5fmr7693681pfv.45.1646958332777; Thu, 10
 Mar 2022 16:25:32 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:03 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 01/26] KVM: x86/mmu: Optimize MMU page cache lookup for all
 direct SPs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:41 -0500
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
fully direct MMUs") skipped the unsync checks and write flood clearing
for full direct MMUs. We can extend this further and skip the checks for
all direct shadow pages. Direct shadow pages are never marked unsynced
or have a non-zero write-flooding count.

Checking sp->role.direct alos generates better code than checking
direct_map because, due to register pressure, direct_map has to get
shoved onto the stack and then pulled back off.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b8da8b0745e..3ad67f70e51c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2034,7 +2034,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->direct_map;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2075,7 +2074,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (direct_mmu)
+		/* unsync and write-flooding only apply to indirect SPs. */
+		if (sp->role.direct)
 			goto trace_get_page;
 
 		if (sp->unsync) {

base-commit: ce41d078aaa9cf15cbbb4a42878cc6160d76525e
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
