Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F54206F16
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455811; cv=none; b=ew/g3Ru9d4jboXXASrfT8jHa08/UvNZ9mVz2uq84ohcGM5yRv5IXk5dSDzVoFh99c7Dat/2IrmkdZ2TWDQiZFqoKR6BEyr6IrPwyc4qJE0o9MSxneT3cmJ0If5n/PJmdwHg/OhJsdNrzraRW+OWbV4FmTwBoNVMu+Kx1yRBPh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455811; c=relaxed/simple;
	bh=c6V4B4l9UrLf1w77J8RGRf/h3npRvkrIneh/XJhh/Us=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hBSqr7h/fgIHwXDQDaxyngudGFTolsOAWOekXRkJUia5bHnxcEzhv1mw+fBtWGG4tluOcEcFgEwTJAuR+aGy4XUrc4A6wnMFXRA8nztFJ1lvZ8lmF/Oc/geRUEzRmd0oX3Na7HL8xTN9wvkSx/SDuLkR1d75qQNEKLUgC6FNzCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZoKm24gh; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZoKm24gh"
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4afe8c469f3so975930137.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455806; x=1737060606; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1FPGE2VUglE9CFYJaRkZs5d1Qv8okwjTkQX7zeGY738=;
        b=ZoKm24ghZjJbbQAzABSZExZe1vPSWt8pdIr+fcFcSREMWvWgbUMHmFLoi6oxdfQfVG
         9EtuEIC1/DsLduGX0bSVs/+kxihibLKOXK9RbvuMoKGbiYgi6GswlWOy1Nq/VglBjP+p
         lKcF3oLOZ4jLGmaLqdS2wZBWP2QYqPOnAH4M1XtpqZhjUR8ItMpBrBCupSjtv2J1NgnU
         5zww2MX3024FwS83JGAVOfWOPGdINAtvA5qY6mcjmTovyIsJYlVXdcWHZHX1q0yqc7p/
         wbkyael7KgPK7XwLtN/5IkioIgVMrn5KE4+8O3YhgWfZszT06xy/aFmbZ5vJNtIlG8wF
         +7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455806; x=1737060606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1FPGE2VUglE9CFYJaRkZs5d1Qv8okwjTkQX7zeGY738=;
        b=mRfPd2UBiBe5w8v9RYXKmsK4Z5lPNYWci8jHhNhlLLsoMo/c4V6tmMGVFPNbkWXbZc
         P/9oCAnytEvZeVte4ll+HoPRn4PlpHSAGO1vgKc+94strZct2uKvypu/mA/m9D+e6bPv
         H2Bm8as+qwlRPcphb07+mnBQhO5kOMdy3TtAzfPxwoBvirwE6b7E/g/OxD57khCcbvuW
         LvHOZdCn6TWA/THMCKk3QiQABN3+wiTMO0dLO5aVToKWyngdIBiwtdeg9jgOqx7i/Wud
         TNrDQaEpLZkr9S3v+XtmkR0EKBLdo02iqlBcV3zY3g/Gy7e4AkWuJdI9pro9EjmxGmDi
         S9YQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRYIf/DMdHlKbcTjeonjV6fLu1esnTijkgiLy2v1LUFyrJS4oORc64j7emft3qfPtLXWl5YQk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8j1fEdl0b9IoYJzC0NbQrdNghNG41UHyicfX37OMK/n2hNuZF
	60TY0MEnqSWgNpvrDF2qHZl/qmsUkjsq1szQsa4g76TSbUjaG8lYz2wlvcykyJMn1yxbzsutK9+
	u+rV2rdzLyNrcO7Ar5w==
X-Google-Smtp-Source: AGHT+IER4UDdWkNRD2ZPfHth4m0AOq+dYEUlBJOggH5PvPrkTbjMUbHW/yGSl0VACauqUoUnO5tUTjFJuH8L321Q
X-Received: from vsvg20.prod.google.com ([2002:a05:6102:1594:b0:4af:fda4:ed12])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:6e88:b0:4b4:e7e7:56c0 with SMTP id ada2fe7eead31-4b4e7e76563mr5145199137.3.1736455806482;
 Thu, 09 Jan 2025 12:50:06 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:29 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-14-jthoughton@google.com>
Subject: [PATCH v2 13/13] KVM: Documentation: Add KVM_CAP_USERFAULT and
 KVM_MEM_USERFAULT details
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Bagas Sanjaya <bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Include the note about memory ordering when clearing bits in
userfault_bitmap, as it may not be obvious for users.

Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e..eec485dcf0bc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6281,7 +6281,8 @@ bounds checks apply (use common sense).
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
 	__u32 pad1;
-	__u64 pad2[14];
+	__u64 userfault_bitmap;
+	__u64 pad2[13];
   };
 
 A KVM_MEM_GUEST_MEMFD region _must_ have a valid guest_memfd (private memory) and
@@ -6297,6 +6298,25 @@ state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
 is '0' for all gfns.  Userspace can control whether memory is shared/private by
 toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
 
+When the KVM_MEM_USERFAULT flag is set, userfault_bitmap points to the starting
+address for the bitmap that controls if vCPU memory faults should immediately
+exit to userspace. If an invalid pointer is provided, at fault time, KVM_RUN
+will return -EFAULT. KVM_MEM_USERFAULT is only supported when
+KVM_CAP_USERFAULT is supported.
+
+userfault_bitmap should point to an array of longs where each bit in the array
+linearly corresponds to a single gfn. Bit 0 in userfault_bitmap corresponds to
+guest_phys_addr, bit 1 corresponds to guest_phys_addr + PAGE_SIZE, etc. If the
+bit for a page is set, any vCPU access to that page will exit to userspace with
+KVM_MEMORY_EXIT_FLAG_USERFAULT.
+
+Setting bits in userfault_bitmap has no effect on pages that have already been
+mapped by KVM until KVM_MEM_USERFAULT is disabled and re-enabled again.
+
+Clearing bits in userfault_bitmap should usually be done with a store-release
+if changes to guest memory are being made available to the guest via
+userfault_bitmap.
+
 S390:
 ^^^^^
 
@@ -8251,6 +8271,17 @@ KVM exits with the register state of either the L1 or L2 guest
 depending on which executed at the time of an exit. Userspace must
 take care to differentiate between these cases.
 
+7.37 KVM_CAP_USERFAULT
+----------------------
+
+:Architectures: x86, arm64
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that KVM_SET_USER_MEMORY_REGION2 will
+accept KVM_MEM_USERFAULT as a valid memslot flag.
+
+See KVM_SET_USER_MEMORY_REGION2 for more details.
+
 8. Other capabilities.
 ======================
 
-- 
2.47.1.613.gc27f4b7a9f-goog

