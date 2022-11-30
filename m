Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB602D50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:10:38 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so132345pge.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=o5DX67Qf2lnPlegwx7eC6dN+k138IpkuF8evogRIbaisU3puqyVi83avpgNlxkIZDa
         qETmK2dyr+nIiPPx8v/6DlNSWFTw1bD6SoEUYHL/jO6du+sL2CiudnBTvJ/16ODAMgQZ
         3+nfOvw1YZyOL75gcFypWK9WoqmxR8njawPhik8OTXf9PgYGMd9M6d8AMjyi/BszB9OF
         g8icjTBWe/7o+k+/RtsCyBNL+6UD5F5fmjxGpVCjdrpqGDKt4XTPyLP6xnEClEauUWrh
         0Q0CeZHh5b9xW+BGETAHGLWy8+hk+qdWsImf2GHnYMLpVCQt8ySTe9HWBH1wDM8NtuFp
         TS0w==
X-Gm-Message-State: ANoB5plsCT5X6bCRBR8xU/yFrSibAkbdaQgm3n7ZKhAZT+MYx9wUzt86
	aPQzD2SvrUbtPlp9UHqKgDT2VwgGOAM=
X-Google-Smtp-Source: AA0mqf6iPCX6KyjCp3cF1IRt5Mv13lZJWlEm0jsHehxUqphsE1Cogz37ZNgUSTWxB9XNJiT56sIeMfxkVVA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:63d8:0:b0:477:172b:c350 with SMTP id
 n24-20020a6563d8000000b00477172bc350mr40707643pgv.313.1669849838234; Wed, 30
 Nov 2022 15:10:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:19 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-36-seanjc@google.com>
Subject: [PATCH v2 35/50] KVM: VMX: Use current CPU's info to perform
 "disabled by BIOS?" checks
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>, 
	Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Fabiano Rosas <farosas@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221130230919.ifTH-5EGJrrGu5bFVVflMpjdQr9mpMrMS96QnlDOGI8@z>

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

