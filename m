Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B129364A4
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001203; cv=none; b=R+wlucsRO7oOAsvFlSQQXZ1aK96+a0cuM6JGMuWF352UvMBd5crAYlferV1fgI7SrodJyqWNenrSdV1bGcTS8hQf7CAH4U4XXRkTwpnR9mazu019OvqYJ+B7I4MUmA56EzvkjpAmoGh/WaWP7iXPV/hYv5JXCVPExRdaAwMVcUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001203; c=relaxed/simple;
	bh=qfv6I1jjnDAU1Imno9iVu5bVjsuWAXtM6J7EWpc+Pus=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HB0hYTehiEBg3FBfa7AKWE/XJqkCVrteuDYlPH7a+BGSoYcBExKY01rih1+pPDruKXlVN7iCi+CYk6zpgGiMyZvKMmVEge2HsjlxtI2XDfBCzyC3i1Zmo8tvRyibJFwv0B1IpFL0sAoqiYYaOvSMtDXQXxbxCJaPCsQyxESdqNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bFlk5eBH; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFlk5eBH"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-57c748dd112so677875a12.0
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001200; x=1718606000; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3Fqo6uZ6WACSXr1SiKgfaQUsW+tD2BveY2g61YybgU=;
        b=bFlk5eBHM53eik4xMc4jzgxTZIrmo6x3ChjQOApdVICdHiGtz8Tk0moHoYHa+BZHOV
         D1BuwJmBqj73w1Z1f44jvlmNG15xr+zGaJNzGmA+KgbP/PctuEfV6Sb3IVQ2LZOHNE3i
         gYlpM7g8VGgYTNIytlYLaYDguCwXzhKE6v1DkQG/RnQ1S/GMU266BzidNCWTESpayRxj
         UBAjxIIMwtFj2jzb1EMqhg/rb1+PeMNjctv2M1Tm/gHy3Y+hPUZfL9JtTBOG3NPRCh4Y
         n+EyoUDxaYiI9uzGVTU6Niky83NtDepFGLYG75yALlxOv7f87y/4/OHzaIDfuF1jze3s
         0LwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001200; x=1718606000;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/3Fqo6uZ6WACSXr1SiKgfaQUsW+tD2BveY2g61YybgU=;
        b=gvvtTWBb/5ld2tGK7yZ4f0Bp0HxADZwAR1U656CYEIwaMd2CB4nFiBaQNXipEBBIxX
         pWYXfIjWh9NjuUm9mYByXGR37eOcCOllQ5577djSIT6CSS8u55WorCSLO2q+Ni7DfANf
         zNTdR6ihlGF7Vfr/UDTINF3EBNG87S4nTAtvikmYNv5RP555Bje5Wn6tJZEH0W0dTXqT
         8gEm/1lQzW9eNrkQOdiG7J2Kp6GtUUoQ83KXV1+5LrxX0rwR3l6DP4k4XVetCDA5jnks
         ZdTNGMpY6sM+02nwvH0TrTZ0/zvwdIDFQ79565/LToyzigkgW9uXCqeVs22ayXQLqcv6
         7o2g==
X-Gm-Message-State: AOJu0Ywhbgt/Nx1g3ayD5CkVLeFl/uSMTCAWePLggf19Q5SmNLljqWsD
	wjh25+yIwEzw+icPIaGaIEno2qH5c6R5Mv+B5lj7iur52y2/LaKLzyIzA4eNe3CGCIu5l/qxzuZ
	MPgYpWRrHWpcna1NVbLexU98ioGZQG6eU8yDvnA+2BBT0qgHGL8X5cZYUqzubatPjXbnMH4aeVr
	20/xCie3jQxtSGxxu/2afYjfMtcfs=
X-Google-Smtp-Source: AGHT+IGl14UbfzJFzP5FVcOdHdoo6VR8VgccIp2YuEQvM8uJdIjgJCFM5cwo5OdJoioDTQ1NLN2OfjF80w==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:381b:b0:57c:803e:3a57 with SMTP id
 4fb4d7f45d1cf-57c803e3c99mr3092a12.2.1718001200147; Sun, 09 Jun 2024 23:33:20
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:37 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-9-ptosi@google.com>
Subject: [PATCH v5 8/8] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The compiler implements kCFI by adding type information (u32) above
every function that might be indirectly called and, whenever a function
pointer is called, injects a read-and-compare of that u32 against the
value corresponding to the expected type. In case of a mismatch, a BRK
instruction gets executed. When the hypervisor triggers such an
exception in nVHE, it panics and triggers and exception return to EL1.

Therefore, teach nvhe_hyp_panic_handler() to detect kCFI errors from the
ESR and report them. If necessary, remind the user that EL2 kCFI is not
affected by CONFIG_CFI_PERMISSIVE.

Pass $(CC_FLAGS_CFI) to the compiler when building the nVHE hyp code.

Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
call it directly and must use a PA function pointer from C (because it
is part of the idmap page), which would trigger a kCFI failure if the
type ID wasn't present.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/handle_exit.c       | 10 ++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b3d6657a259d..69b08ac7322d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -417,6 +417,14 @@ static void print_nvhe_hyp_panic(const char *name, u64=
 panic_addr)
 		(void *)(panic_addr + kaslr_offset()));
 }
=20
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+{
+	print_nvhe_hyp_panic("CFI failure", panic_addr);
+
+	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
+		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -446,6 +454,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
 			print_nvhe_hyp_panic("BUG", panic_addr);
+	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
+		kvm_nvhe_report_cfi_failure(panic_addr);
 	} else {
 		print_nvhe_hyp_panic("panic", panic_addr);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index 50fa0ffb6b7e..782b34b004be 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,9 +89,9 @@ quiet_cmd_hyprel =3D HYPREL  $@
 quiet_cmd_hypcopy =3D HYPCOPY $@
       cmd_hypcopy =3D $(OBJCOPY) --prefix-symbols=3D__kvm_nvhe_ $< $@
=20
-# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
-# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotation=
s.
-KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FL=
AGS_CFI), $(KBUILD_CFLAGS))
+# Remove ftrace and Shadow Call Stack CFLAGS.
+# This is equivalent to the 'notrace' and '__noscs' annotations.
+KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUI=
LD_CFLAGS))
 # Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profil=
e'
 # when profile optimization is applied. gen-hyprel does not support SHT_RE=
L and
 # causes a build failure. Remove profile optimization flags.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index 3a2836a52e85..07120b37da35 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -5,6 +5,7 @@
  */
=20
 #include <linux/arm-smccc.h>
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
=20
 #include <asm/alternative.h>
@@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
 /*
  * void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
  *                             void (*fn)(void));
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirec=
tly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x3, sctlr_el2
--=20
2.45.2.505.gda0bf45e8d-goog

