Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA5C29994B
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 19:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817637; cv=none; b=eeCklxfyI++tHXXEI/gxL2JVymLyR4GP5lxXy7fiKCfXQNBynNnmC3guaCeNJX6JtBNHJRxXemX3MlxuQZIVkxC9Cdv0+SMHDU5m2XP4vSK0ariZ4KNc3WVEfQ8M/ktzNjowt6CT9nCAIRgXCMcAMuSlHxEE4hORVG4dJLY6a6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817637; c=relaxed/simple;
	bh=GezEG6D+dGW2ASk1t1mkWRtt3ji/dNz8mwQjkZHk1gk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WSEKsgLBFfU1PtzXhoPPUXFCnDYFOxOtBK9fbmrblio2E1u3ygozhKTbgCJKSrI83UL35a0Dry8QYHohdVqjU6NTaJI0YOUTT+Io2KGM3vw/FH8MBPpt097KOivDapIQa6kXeFFXGxaYqgSI/whufI2WjZE0/MrhehfuYtBCJiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XlQ5ceI9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XlQ5ceI9"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f2dd307d4so1343367a91.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817635; x=1754422435; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LRgTVb6HxivGsODMp4kE86IHTk8ygg+wPbdHcPP2xOg=;
        b=XlQ5ceI9b+tE5NE3GVprRIk9D9uLUzNCjQdMt13VGQ5ZqZSqF6trBhes6P1A1ErhtE
         br7M5GB3V8P4BPnQqGFWLl9Nc2domHAJ/qs5/lNGeSHOg7zElbknJawExhh56/tVqtOq
         gXaoboazpi3JvQm0iggofdg7IK3v071SniIgGZflm/hNBFbRaP/ShO4GQQ5rUC6SHQdD
         iv7t7u70IkRXlUk0FaTqR1Hv9MVk9wv9GT+UFFxibXwtWrA0fX5EDwSIk8YqvJ44KN9S
         z5DFj+LUKnJEGjouzOfEi+SnVbXjmWyqRsFxeCQtm58EjQFAUkYQ05+HZoJDccuSHehU
         iW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817635; x=1754422435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LRgTVb6HxivGsODMp4kE86IHTk8ygg+wPbdHcPP2xOg=;
        b=vi7kQDShingR97blZu26RKkAXilh6bL6NHayn/g9iTEUqjdrPGx7cp2cTfOc4/NIib
         CW9R+NltSNgJJADP5ZVHUveOa4bU31RDNRB4WjozRf3MFiQXETLYgh9f1PJRq88oi0Qu
         KJNoWfiDDe9n38unzNM+J/3ZOXtUtDuwCZLUGWRMYgBKABznbXXz/QSvVZhJ4pXGzkjW
         RxDQMUW5B5dKBZWlTuQ/u37ET87TN1TjndFid0UW+HXq+5yt8qz5eyTYSHtJ2jrvAIvK
         hjzSObFePyInuqcHvEioaQELGlNYlRsMc/OdNzAhlAyxo4CsxwexSH25gJDUNGSI6bRF
         XZjA==
X-Forwarded-Encrypted: i=1; AJvYcCUZaUvXhyK7q//g+7GmImapTyTetEBV2Q/FXl/F72ZAubi92zjF3hnOakcplUoKkqBwDVk70HU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQoxGESsXzNy0KJxEIGpmFoPc38DlekwmvQHAt2sz2sIAmUXHr
	nVYBCb5Gguz4fv6p0a7y8qkctOGIw3TkaS+s0/l+4PxbovjVSLZ3xLpg3471zbYCtKEW6pW1wC1
	kMdtwzA==
X-Google-Smtp-Source: AGHT+IG/gL3d24hNw5SUEuxjxjut5eSNrEkkhi5cedOb5e+QFzIszFgoNw0OLcITFvyVJnRdvLf93b3+R4g=
X-Received: from pjqo23.prod.google.com ([2002:a17:90a:ac17:b0:31f:f3:f8c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5285:b0:312:f650:c795
 with SMTP id 98e67ed59e1d1-31f5de54b6dmr784023a91.21.1753817635200; Tue, 29
 Jul 2025 12:33:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:40 -0700
In-Reply-To: <20250729193341.621487-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
which enables more efficient reclaim of private memory.

Private memory is removed from MMU/TDP when guest_memfds are closed.  If
the HKID has not been released, the TDX VM is still in the RUNNABLE state,
and so pages must be removed using "Dynamic Page Removal" procedure (refer
to the TDX Module Base spec) which involves a number of steps:
	Block further address translation
	Exit each VCPU
	Clear Secure EPT entry
	Flush/write-back/invalidate relevant caches

However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state,
where all TDX VM pages are effectively unmapped, so pages can be reclaimed
directly.

Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
reclaim time.  For example:

  VCPUs    Size (GB)    Before (secs)    After (secs)
      4           18		   72              24
     32          107		  517             134
     64          400		 5539             467

Add kvm_tdx_capabilities.supported_caps along with KVM_TDX_CAP_TERMINATE_VM
to advertise support to userspace.  Use a new field in kvm_tdx_capabilities
instead of adding yet another generic KVM_CAP to avoid bleeding TDX details
into common code (and #ifdefs), and so that userspace can query TDX
capabilities in one shot.  Enumerating capabilities as a mask of bits does
limit supported_caps to 64 capabilities, but in the unlikely event KVM
needs to enumerate more than 64 TDX capabilities, there are another 249
u64 entries reserved for future expansion.

To preserve the KVM_BUG_ON() sanity check that deals with HKID assignment,
track if a TD is terminated and assert that, when an S-EPT entry is
removed, either the TD has an assigned HKID or the TD was explicitly
terminated.

Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
Link: https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 22 +++++++++++++-
 arch/x86/include/uapi/asm/kvm.h          |  7 ++++-
 arch/x86/kvm/vmx/tdx.c                   | 37 +++++++++++++++++++-----
 arch/x86/kvm/vmx/tdx.h                   |  1 +
 4 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 5efac62c92c7..bcfa97e0c9e7 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -38,6 +38,7 @@ ioctl with TDX specific sub-ioctl() commands.
           KVM_TDX_INIT_MEM_REGION,
           KVM_TDX_FINALIZE_VM,
           KVM_TDX_GET_CPUID,
+          KVM_TDX_TERMINATE_VM,
 
           KVM_TDX_CMD_NR_MAX,
   };
@@ -92,7 +93,10 @@ to be configured to the TDX guest.
         __u64 kernel_tdvmcallinfo_1_r12;
         __u64 user_tdvmcallinfo_1_r12;
 
-        __u64 reserved[250];
+        /* Misc capabilities enumerated via the KVM_TDX_CAP_* namespace. */
+        __u64 supported_caps;
+
+        __u64 reserved[249];
 
         /* Configurable CPUID bits for userspace */
         struct kvm_cpuid2 cpuid;
@@ -227,6 +231,22 @@ struct kvm_cpuid2.
 	  __u32 padding[3];
   };
 
+KVM_TDX_TERMINATE_VM
+--------------------
+:Capability: KVM_TDX_CAP_TERMINATE_VM
+:Type: vm ioctl
+:Returns: 0 on success, <0 on error
+
+Release Host Key ID (HKID) to allow more efficient reclaim of private memory.
+After this, the TD is no longer in a runnable state.
+
+Using KVM_TDX_TERMINATE_VM is optional.
+
+- id: KVM_TDX_TERMINATE_VM
+- flags: must be 0
+- data: must be 0
+- hw_error: must be 0
+
 KVM TDX creation flow
 =====================
 In addition to the standard KVM flow, new TDX ioctls need to be called.  The
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..e019111e2150 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -940,6 +940,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_MEM_REGION,
 	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
+	KVM_TDX_TERMINATE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -962,6 +963,8 @@ struct kvm_tdx_cmd {
 	__u64 hw_error;
 };
 
+#define KVM_TDX_CAP_TERMINATE_VM       _BITULL(0)
+
 struct kvm_tdx_capabilities {
 	__u64 supported_attrs;
 	__u64 supported_xfam;
@@ -971,7 +974,9 @@ struct kvm_tdx_capabilities {
 	__u64 kernel_tdvmcallinfo_1_r12;
 	__u64 user_tdvmcallinfo_1_r12;
 
-	__u64 reserved[250];
+	__u64 supported_caps;
+
+	__u64 reserved[249];
 
 	/* Configurable CPUID bits for userspace */
 	struct kvm_cpuid2 cpuid;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c2ef03f39c32..ae059daf1a20 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -188,6 +188,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
 	if (!caps->supported_xfam)
 		return -EIO;
 
+	caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;
+
 	caps->cpuid.nent = td_conf->num_cpuid_config;
 
 	caps->user_tdvmcallinfo_1_r11 =
@@ -520,6 +522,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		goto out;
 	}
 
+	write_lock(&kvm->mmu_lock);
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -544,7 +547,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	} else {
 		tdx_hkid_free(kvm_tdx);
 	}
-
+	write_unlock(&kvm->mmu_lock);
 out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
@@ -1884,13 +1887,13 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
+		KVM_BUG_ON(!to_kvm_tdx(kvm)->vm_terminated, kvm);
+		ret = tdx_reclaim_page(page);
+		if (!ret)
+			tdx_unpin(kvm, page);
+		return ret;
+	}
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -2884,6 +2887,21 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_terminate_vm(struct kvm *kvm)
+{
+	if (kvm_trylock_all_vcpus(kvm))
+		return -EBUSY;
+
+	kvm_vm_dead(kvm);
+	to_kvm_tdx(kvm)->vm_terminated = true;
+
+	kvm_unlock_all_vcpus(kvm);
+
+	tdx_mmu_release_hkid(kvm);
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -2911,6 +2929,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_FINALIZE_VM:
 		r = tdx_td_finalize(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_TERMINATE_VM:
+		r = tdx_terminate_vm(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..0abe70aa1644 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -45,6 +45,7 @@ struct kvm_tdx {
 	 * Set/unset is protected with kvm->mmu_lock.
 	 */
 	bool wait_for_sept_zap;
+	bool vm_terminated;
 };
 
 /* TDX module vCPU states */
-- 
2.50.1.552.g942d659e1b-goog

