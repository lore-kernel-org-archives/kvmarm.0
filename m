Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355033A7F7A
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 12:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785240720; cv=none; b=O6NUC2yBYxRm6OEUys/znat+1v+ucZMi97lYRM9OW8Mvi8GpmVZiHgMoBnx8T+n9gxSP7RUbdfTuOtYovKilZSjigCJ2/6wqa2MN7n0HeBnCOHkFb8sjxmVHJn9iM3ajOiIirTuSq7yZFsCvcG2EB5H1huBukmUaMS2TsYLnh6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785240720; c=relaxed/simple;
	bh=TO6T9uww6lJLdEIDRwdalblJ0RmmQaoqllzwmIafrlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KsZ1Oma3k1ySBZ3mNlBtr8Vt5W2lnjY9yT2CErgHquzc195bBLBA7Hcx7tVXhceGPLaejW6hkpRDNn38zBry6c+/FLn/LdrX/B+Q5i/vIQjsFPihkNZLPo5OwKPruZbfimpCbXc8YKMlB5TL3vvVnWM8+Y/xqGZcicIHT0vjUD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yh1YWHh8; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yh1YWHh8"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c1630a90890so204479366b.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 05:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240712; x=1785845512; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ARgzZjHeTdBuB8exqJqKuaM+KX+IhgDD0EDGHp8wJgQ=;
        b=Yh1YWHh8VRpe1E0kByOzaKeGHp1fq19IVKfCFwDPO1r7WwnHITc65jIFDv7sBeaYyt
         H6eqj9v/t0iz9xkQ6PbcGQq6GIEVDsPhWUvDAmoo5tCSZMzJGmuNHLvV9bwYZvUVSdE/
         iAoE6t0714vAXFqsKzUw7Yk+f5zc4ONCtz1d6wC57AMNGtpqkL/vuTWDmKzslBDhxRVk
         2WZaKMJfDRdfTG9nJfCMsNgB/S5FyVm1k9+hK1ZwW/YgbZ/hap3P1NUXQ0PqZjv1NTQC
         S+vddtG/jhZKULVormi+DdFvueK9+CtXF3fXHbeQ0izYi1Wn6ZOvrp3dA130cJWVtvii
         og0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240712; x=1785845512;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ARgzZjHeTdBuB8exqJqKuaM+KX+IhgDD0EDGHp8wJgQ=;
        b=ibVVIP+DwIy38OSfrINfxE7Eo7k8zvwBXox5Vy+SrrVHga7PRuE27kGzt9nW30/bD2
         naewbsV3+CN+kFZuan4lbpo48eKLAWb8F8g1VLVfGKP6pUefFLbkCzBiBN2iPfTaa4Nm
         TKYOjG4H78jjB9EgKrHRoCNsK1/YpkWC7uZUBpCXacMyMI5z7evnfurwT8ToG8841zsW
         ncbfVUTFNidR2Ibf3F9DaoDYwjhlzzp4XRuX8i9cSR6v/Y+AYJZ+kdirgcTwpX8M9DwU
         HCsCDJwWhbORmwEYIfuBIb7BSIYFRDAWoMV0fHgwOyQ9bhqXH5CC+M66TJOyStgxy55e
         mAwQ==
X-Forwarded-Encrypted: i=1; AHgh+RqJL5GALMvZReH6UaKYLhoQM+Uwx3gE7mIG+1fEQVELBXRX2E8mbaLgghdpr/1RuSCeIamEAHA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbkOhpTH6WsAuPyn1HOoe8w63Mcmecok8ohriWJz0VW+kZwQ1B
	zQFKDsiCQeBKYV92fDCgibj46c2CugYSTDzp/UEO+dQcKzVVIAJaIs+nPeLvkUNsd5fPKsvp4oL
	+zxH+REfGhm2E3zExtA==
X-Received: from ejjj6-n1.prod.google.com ([2002:a05:6938:a086:10b0:c15:be99:e164])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6938:a087:20b0:c16:3187:997e with SMTP id a640c23a62f3a-c1f71d61504mr70847266b.7.1785240711384;
 Tue, 28 Jul 2026 05:11:51 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:36 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-10-tarunsahu@google.com>
Subject: [PATCH v4 09/11] docs: liveupdate: Add documentation for VM and
 guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Add Documentation/liveupdate/vmm.rst detailing VMM requirements, scope,
ordering constraints, and kernel-doc inclusions for KVM VM and
guest_memfd preservation via Live Update Orchestrator (LUO).

Also update Documentation/core-api/liveupdate.rst and MAINTAINERS.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 Documentation/core-api/liveupdate.rst |   1 +
 Documentation/liveupdate/vmm.rst      | 107 ++++++++++++++++++++++++++
 MAINTAINERS                           |   1 +
 3 files changed, 109 insertions(+)
 create mode 100644 Documentation/liveupdate/vmm.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index 5a292d0f3706..bac58a363151 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -34,6 +34,7 @@ The following types of file descriptors can be preserved
    :maxdepth: 1
 
    ../mm/memfd_preservation
+   ../liveupdate/vmm
 
 Public API
 ==========
diff --git a/Documentation/liveupdate/vmm.rst b/Documentation/liveupdate/vmm.rst
new file mode 100644
index 000000000000..b8e8fb2b63c2
--- /dev/null
+++ b/Documentation/liveupdate/vmm.rst
@@ -0,0 +1,107 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+=============================
+VM & Guest_Memfd Preservation
+=============================
+
+.. kernel-doc:: virt/kvm/kvm_luo.c
+   :doc: KVM VM Preservation via LUO
+
+.. kernel-doc:: virt/kvm/guest_memfd_luo.c
+   :doc: Guest_Memfd Preservation via LUO
+
+VMM Instructions
+================
+
+This section describes the requirements, scope, conditions, and
+ordering constraints that a Virtual Machine Monitor (VMM) must adhere
+to for successful preservation and retrieval of guest_memfd files
+across a Live Update Orchestrator (LUO) sequence.
+
+Scope and Limitations
+---------------------
+
+At this stage, the scope of guest_memfd preservation is restricted to:
+
+1. **Fully Shared guest_memfd**:
+   At this time only fully shared guest_memfd is supported. Any system that
+   supports coco vm (which uses private guest_memfd), will not support
+   the preservation.
+
+2. **Standard Page Size**:
+   Only guest_memfd backed by standard page size (``PAGE_SIZE``,
+   order-0) pages is supported. Large/huge page backing (e.g.,
+   hugetlb guest_memfd) is not supported.
+
+Any Virtual Machine (VM) whose memory is fully backed by such
+guest_memfd files can be preserved across live update.
+
+VMM Actions and Conditions during Live Update
+---------------------------------------------
+
+During the live update sequence, the kernel introduces a *freezing*
+phase for the guest_memfd inode. Freezing prevents any modifications to
+the guest_memfd page cache. Specifically, once a guest_memfd mapping is
+frozen:
+
+- Any subsequent ``fallocate`` calls on the guest_memfd file descriptor
+  will fail and return ``-EPERM``.
+- Any new page faults (guest-side or host-userspace-side) that require
+  folio allocation will fail and return ``-EPERM``.
+
+To prevent vCPUs or VMM helper threads from failing due to these
+``-EPERM`` errors, the VMM must implement one of the following
+strategies:
+
+1. **Pause the VM (Recommended)**:
+   The VMM should pause/suspend all vCPUs before invoking the
+   preservation or freezing of the VM and guest_memfd files. This
+   ensures no new page faults or memory accesses can occur while the
+   guest_memfd is frozen.
+
+2. **Handle Fault Failures**:
+   If the VM is not paused, the VMM must be prepared to handle VM
+   exits or user page fault errors resulting from the ``-EPERM``
+   failures. The VMM must take appropriate action, such as
+   immediately pausing the VM, or aborting the live update sequence
+   (by tearing down or unpreserving the live update session).
+
+Preservation and Retrieval Ordering
+-----------------------------------
+
+Preservation Order
+~~~~~~~~~~~~~~~~~~
+
+There is no strict ordering requirement for initiating the
+preservation of the KVM VM file and the guest_memfd files; they are
+preserved independently. If kexec is triggered with guest_memfd
+preservation without preserving the vm file, kexec will fail.
+
+Retrieval Order
+~~~~~~~~~~~~~~~
+
+Similarly, there is no strict ordering required for retrieving the VM
+and guest_memfd files. Any file can be retrieved at any order.
+
+If guest_memfd file is retrieved and VM file is not retrieved, and
+luo_finish is called, then vm_file will be lost and guest_memfd file
+will be hanging around.
+
+NOTE: Before Initiating the preservation/retrieval, it is necessary to make
+sure that the kvm module is loaded (/dev/kvm must be available).
+
+
+VM & Guest_Memfd Preservation ABI
+=================================
+
+.. kernel-doc:: include/linux/kho/abi/kvm.h
+   :doc: DOC: guest_memfd Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/kvm.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/userspace-api/liveupdate`
diff --git a/MAINTAINERS b/MAINTAINERS
index 8db8bb448b23..c032f9a0451b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14548,6 +14548,7 @@ L:	kexec@lists.infradead.org
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/liveupdate/vmm.rst
 F:	virt/kvm/guest_memfd_luo.c
 F:	virt/kvm/kvm_luo.c
 
-- 
2.55.0.229.g6434b31f56-goog

