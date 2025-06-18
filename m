Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5533D220696
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220692; cv=none; b=LF+LkdA9OvDT1rUGJkVkcLEq/Hhr+547Eh/8erdkYOTUEQ1BlHSyi9KNMnctmBstuFV2jmI8e946yLy57wj9VZtycG+KIFE4VQW3kWNkyaQ9Fs0ZpmMOrenluQ/3qTtDr4ITNwTQcA1Wt3dSKMJ8w7oqitHjqdJU+RPR5vLGcI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220692; c=relaxed/simple;
	bh=TlPwQV38TsKUYD4upWrrqkkEe7fCtClTkHmYIdQHZto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KINEiJG1HVXdYvTNOaluNy18fV6uy09F5mpTgbhWEyBiuKS7YBp3LWnj9WIj70Xnu1agTsC6kBvhZMA2kQZVd4pHoMnYkqUXWKEv3CO+7OKHoag0SM9L7KyvlKGGKO3nj/bxay1atbebGn1kttWQdBgJP1j5vFyM7EkQqAQcTRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ursfMDQP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ursfMDQP"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c00e965d0so4298734a12.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220690; x=1750825490; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6MpWO9eGHCybkhP95T8R+1KfjKYk4MOXDyWFRHvmIc=;
        b=ursfMDQPnXP6kYMRNJan5zYlIai6zBFazXzEv5m6HwCWhHTWnUwV2YekE3OjimekS5
         MrtULd2qoclxangvNDeyvl4fNLEEEmcYll3gGMTqELD1lI7ZgO3m8IJJFuHtpW8cPd9E
         xh7sKzmgltalfQRNBpuntkLZyhhkfElb7oueGeoCfZ++dxXprvvWcEfwK7Ji/j/gUw8N
         9Lct5X322S/TStBMZFa0bhn8NvVwfo7skaDqRjcZ0jrysT/qS95JXyvKMaD7J3i04ry9
         rnumMDEaToRmS4vmFUG5+rbeCUtqoUUNfMzAXFTbRQUycK1CZWojODX+wliEo/9fAaxS
         35Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220690; x=1750825490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6MpWO9eGHCybkhP95T8R+1KfjKYk4MOXDyWFRHvmIc=;
        b=l6yRT5qsA3FF7XRRwmjJrHjqomhcopABC0Qb8BWtT7hjwQGP3wgtzpIORNF+bQo4+c
         Ync/5yvl2K+H/LFtAct2HNBe+MxPv3+zgV15FrJFCK2nrL3M84wC8v4ip77XZHy7aZIx
         7dn8Ooc2QMWgRhXGXQjegg+8Koe+L3N1HGaaqHVaZGsa7iQdHf/1Xgf9QRTmYxiVyiN9
         ECo7TDtG0UJeKaylEmoYKD6LD3HsSGdNmZo+0Xx7S7MwvzrZXWuLq8KekCM8moNcAHOe
         kepZN6DHFEX2plZ/eOEEPiflWstu7Ow0GAFMb4f3ktLfzqR9H4vGys5L4SCU6nue8i+E
         U2/A==
X-Forwarded-Encrypted: i=1; AJvYcCVafMa2+nMMxKjWgmdFezhrC/6cdZNwsWbDlTiAgBQtCgs9R5gj+sQmFuBIMCam18eMLWsaTk4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8naQxDCCOp9bkzplgU68jwDEKihlZ3NM7RRfaYGWaQ/kyb96N
	He7j/Gti5ZXvqRHlCY9wbm6mfv94HRV2BwzblDcyoUBj/qVKd+v4q8jNR8QeuUo5MSyxmnXO6gs
	YU+v/clCT7umbaP6/mY9Z5w==
X-Google-Smtp-Source: AGHT+IFBmqhQDFkst9hOrle0gOrugvU+bLMa/osue2o1jv722NhjgUmFbYBlQLzwI5ul7WF7bNf9FKyZ7x+dJLfM
X-Received: from pgbfq12.prod.google.com ([2002:a05:6a02:298c:b0:b2f:dfa3:cb81])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:512:b0:218:5954:1293 with SMTP id adf61e73a8af0-21fbd668df0mr28784142637.34.1750220689787;
 Tue, 17 Jun 2025 21:24:49 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:24 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-16-jthoughton@google.com>
Subject: [PATCH v3 15/15] KVM: Documentation: Add KVM_CAP_USERFAULT and
 KVM_MEM_USERFAULT details
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
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
index ff0aa9eb91efe..25668206a5d80 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6308,7 +6308,8 @@ bounds checks apply (use common sense).
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
 	__u32 pad1;
-	__u64 pad2[14];
+	__u64 userfault_bitmap;
+	__u64 pad2[13];
   };
 
 A KVM_MEM_GUEST_MEMFD region _must_ have a valid guest_memfd (private memory) and
@@ -6324,6 +6325,25 @@ state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
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
 
@@ -8557,6 +8577,17 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
+7.44 KVM_CAP_USERFAULT
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
2.50.0.rc2.692.g299adb8693-goog

