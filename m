Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82481C4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13B4D4B75D;
	Wed, 30 Nov 2022 18:10:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f+xXBVauMhhR; Wed, 30 Nov 2022 18:10:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0AC24B6B9;
	Wed, 30 Nov 2022 18:10:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BEFC4B3DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KeVUq2csF+Ip for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:44 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7577D4B6B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:39 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 pi2-20020a17090b1e4200b0021834843687so3838156pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=sHcyHjJ8KuW26EmyMG2GCKXDxJlY2ojJURA0kcfw/9k=;
 b=VFFqhuPme1m1eQU16n2iG/J4RAGy2zrHzndrwcDa2UqPCuhmGJAJUoqWiUJ0hBawNj
 h+1PCcwEa7TWtGKSi7eE+1ph58rOUBv3xDHOkx/n95w6cUeiQfhXEh79gM7EIyUtnO0y
 ioN8O+FtRJeTVR0iP2uSqqMMZ5ce7bBX8TmoSKstA2185sSr20JSkv0QaUPbyNWz1HPN
 V+igGOZxxi1EiiIK8zOP02RlczC9ypmTY7mqbv223oTCKi8YwUrElYdikisBH1Zh971w
 Fr2k5IgU2gcv415RYRumMziSQSo+TFWu1mQkGuJbocDRmVfBg+o1I6JFksOzDsAHNWBN
 gCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=sHcyHjJ8KuW26EmyMG2GCKXDxJlY2ojJURA0kcfw/9k=;
 b=KltbtnnWcfAUBOTZvq8XOU5T8+tR4qqa9CG2q0lwJ4+NPx1gdGzDcUnEwm6/vEaQsG
 99NnhgK/isnV2x/0pWYwX/z3Ubi4xwa03Lv4gxN/ZXGs+K30PeGTMmJiLihDIklX50qQ
 8fgImevUazVfa65n3sOXDVPPQ6GqcLonuOVCBn2hg5Ut2Pg7a8e96wdf2Z7tMyGI8LK5
 Efz5JtBt96wEyFLuck3d62YStNBGQgR45KvEa7lECEHOlX+ByhVLajGVt4X95klcgnX3
 x247sOkme42npwzcGK32xa54z/5uOGC/+kEAIB/i0UtF3fwdY/9uK6zUpEvDiF0N+tbo
 lcpw==
X-Gm-Message-State: ANoB5pn+WvwDbV8lO/58jXytkx0fbzYtj9QUaSWaj9dsrF1UShFu97k5
 Gk+bPiWne3sFvfAXApdXu0nE90qvpBQ=
X-Google-Smtp-Source: AA0mqf6iPCX6KyjCp3cF1IRt5Mv13lZJWlEm0jsHehxUqphsE1Cogz37ZNgUSTWxB9XNJiT56sIeMfxkVVA=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:63d8:0:b0:477:172b:c350 with SMTP id
 n24-20020a6563d8000000b00477172bc350mr40707643pgv.313.1669849838234; Wed, 30
 Nov 2022 15:10:38 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:19 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-36-seanjc@google.com>
Subject: [PATCH v2 35/50] KVM: VMX: Use current CPU's info to perform
 "disabled by BIOS?" checks
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

Use this_cpu_has() instead of boot_cpu_has() to perform the effective
"disabled by BIOS?" checks for VMX.  This will allow consolidating code
between vmx_disabled_by_bios() and vmx_check_processor_compat().

Checking the boot CPU isn't a strict requirement as any divergence in VMX
enabling between the boot CPU and other CPUs will result in KVM refusing
to load thanks to the aforementioned vmx_check_processor_compat().

Furthermore, using the boot CPU was an unintentional change introduced by
commit a4d0b2fdbcf7 ("KVM: VMX: Use VMX feature flag to query BIOS
enabling").  Prior to using the feature flags, KVM checked the raw MSR
value from the current CPU.

Reported-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e859d2b7daa4..3f7d9f88b314 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2492,8 +2492,8 @@ static __init int cpu_has_kvm_support(void)
 
 static __init int vmx_disabled_by_bios(void)
 {
-	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	       !boot_cpu_has(X86_FEATURE_VMX);
+	return !this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	       !this_cpu_has(X86_FEATURE_VMX);
 }
 
 static int kvm_cpu_vmxon(u64 vmxon_pointer)
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
