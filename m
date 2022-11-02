Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44FDC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 836844B7FD;
	Wed,  2 Nov 2022 19:20:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KTr2JqbT8-0k; Wed,  2 Nov 2022 19:20:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 804BD4B7F0;
	Wed,  2 Nov 2022 19:20:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D647B4B7EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ieJwnSzDWTKU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:20:04 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D5A84B75D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:02 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-349423f04dbso768757b3.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=mKnEtQX0QH/ggk+Ht36/d+63ROqx6WCYCltiz+Zzjv4=;
 b=SdQ/LsY4NGnVE1yE06OYtnoYVCRmFREHfZbDy+hy/qKLprusJ3oD9C3Z6OVRKqQrnE
 CInFERbmx9ZRnFYiATYzBK74mPS4+cAZJ+5ijRabgzbKKerJGVt8ZZlmJzt5Hj/aV0PA
 EGW/7VotUp9NojxVblVL/QpJZuKvGxyCajSBZEMqVRwQDUQw2wRSv4vj1QT6bcpnpc9t
 e4rP+2f3gLSJ/JJRtgPX3AbV2Tyauor4ctFIQiYJWU548K+/wXsudAS9Uik/E0jRBxNq
 qFZGa2xPRMU89uQ30BChflY3hdbUkhWTUyAN3U9JeOyLGBy95xzkfXnGKk726vF8pKbF
 n5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=mKnEtQX0QH/ggk+Ht36/d+63ROqx6WCYCltiz+Zzjv4=;
 b=7/Wc8XEsAdhsfbdP5u1LzMEw3/S7zm8D8bgrwNjehqqOifeNKi8CSh03ay+dndAmdW
 /DdrLm9Cw86QyIlEEeS1F42IAmo09x8/c3szlXQvO5ZggFs2n9YKN9Mka+51zGtsehr+
 5hX6E56FU8wkKhMBZ1HkWLhPl5Pm+DL7EeIAc3nsM4y9A92C6dRSfyynoADXTdUHRObR
 J+ZFgHItkrfOiKI+Ui9siCaHUabtQYBghPK0bFWMRznDN02osvg9GVS/oe5dbYYhA2Ei
 ZjE2kkwe+ldwCALijV3pBMK23vF5SJvkwNlf5WpJZrLwhbx0oZztyf3vzWvdtW6lCInQ
 XdmQ==
X-Gm-Message-State: ACrzQf2r4pvYdLRHoL6FD0c3HPbrLH+CLTFpu8aI40IO7vDL1n4xqlkI
 08C4Ta5KQkTg7F2tzVR8LeGA3ugSC2A=
X-Google-Smtp-Source: AMsMyM58olcArAfGw4eM2juSx6NG/cSk/6KUdGGsxOwq8NmV4ZhdhKDU4RNI0GuMTLVYYG9b0/LsdP0LTpo=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c615:0:b0:6c9:f71a:f95d with SMTP id
 k21-20020a25c615000000b006c9f71af95dmr26436245ybf.411.1667431202255; Wed, 02
 Nov 2022 16:20:02 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:55 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-29-seanjc@google.com>
Subject: [PATCH 28/44] KVM: VMX: Make VMCS configuration/capabilities structs
 read-only after init
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

Tag vmcs_config and vmx_capability structs as __init, the canonical
configuration is generated during hardware_setup() and must never be
modified after that point.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 87c4e46daf37..2aaa0fd53d08 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -68,13 +68,13 @@ struct vmcs_config {
 	u64 misc;
 	struct nested_vmx_msrs nested;
 };
-extern struct vmcs_config vmcs_config;
+extern struct vmcs_config vmcs_config __ro_after_init;
 
 struct vmx_capability {
 	u32 ept;
 	u32 vpid;
 };
-extern struct vmx_capability vmx_capability;
+extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6adb60485839..81690fce0eb1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -489,8 +489,8 @@ static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
 
-struct vmcs_config vmcs_config;
-struct vmx_capability vmx_capability;
+struct vmcs_config vmcs_config __ro_after_init;
+struct vmx_capability vmx_capability __ro_after_init;
 
 #define VMX_SEGMENT_FIELD(seg)					\
 	[VCPU_SREG_##seg] = {                                   \
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
