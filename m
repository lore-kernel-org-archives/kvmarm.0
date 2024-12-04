Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F9B20766C
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339671; cv=none; b=QlOI6c1KC6DH0pMU4kCIUwkmFGT84eoqxJEGjmhexDHz+8oIDjMe8wxmpj7Be8p2Nr2fm53VDC+6oN7z5K+ubcYtob/yJmSWX0vfyZvC7aBq9RpgxWPFxgte7ydtkSaq5TmGu8qLbv6TiBN+rN3rYm0mRTto8EHYdK2bws/wnxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339671; c=relaxed/simple;
	bh=y+38ZRGskOv31V+pgdRIkwmafpiX8dTbP5MleVcleIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fUSDsIzuJSbhJKF1UPSB5o8iY0KALN5jpRyYnMAjM2sA+4RzYYxgLR/8aqRPtcHKJCVEGYpZNqFVn9/tS5iQ8uYAqGvq1oXXvKnfPi7Yy+yAneGwzprPdKf2oE+PhCRJVQwLvka9IcDYhWM3btytr/Q6dhsnsNSQQ1ABrV5wAS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=blH0vO94; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="blH0vO94"
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-515d07b1251so54678e0c.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339668; x=1733944468; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVmBABSFHx5R5MTquILKgGxl08w4PCC+wHr0khmGJK8=;
        b=blH0vO94SsTEd42cb1MZd+vZonNdu37JUNgETViDkEaHp8q7H+PiS4dLKEN2tTZ90V
         2Ku7G9NE6r9BgX07PzISrW/DZ8piEAF0nOgSj1qH+Uq4n3+K7VWZRf6VoDuWtrQ5/snT
         A8y6UkodBpYDjYjlctUbxlnUj8Id3pQy5r3fFwN2D37Eo/Pxi57LjXQ55+EO3oxtUZ17
         Uir7bdotF0E/k9LqfHNvYsglBHKid11IOt8xRNLljk0TgNEBIJNXBOiN5CNR1vWathfV
         Mpj2SbjF+mUVXryM6hBbQ3ooCMvuCiLdWgyNrF/ODSUG7lPj1zlozhe2zAEpiW8Nfmq0
         GZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339668; x=1733944468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVmBABSFHx5R5MTquILKgGxl08w4PCC+wHr0khmGJK8=;
        b=Da7CYaszlCpAER3taY4NJlLybD86UPLOXgqeiQ8MqHw5IBAyXExoCRTzuLpvF5wQeH
         ezxP7i49A/oizPyw9BAgnOYheeTeLkBpS7LZsFkvj20zVITm3Lv9Vef1YG4kSYQ1F/ts
         xhF4QEO2nhmh0kb1ZpC5k2TNMoxTAIqYPT6lrBR3Wp+EQG81CxIMmf5RaE7wlMVLR9d+
         aJrDvko09tfeLFw9oEx18d38h8RXk+3jo05PpCR3F9TI9OAFXTAGaOMSDR5nDfdgHnF9
         GiHmb+vmIb975WycjLVkpEp2qaneFtGjflqbZCM8VzLVZREM6cvZkdrKarFUgJOuFD9I
         tX9Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8iaO35xwz+1izutfHG5MrHanWNBniaiDjIGIOPTX3OG3eeWkx6PeSKO1XSBn/o4TQ5JMaNbc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxsISdn076MYOBVe2zKBuEvLEclBK3OPtlcwtAPhYSOf+jy7vb
	NuxOdlV5ubVW1C8VIXTDcqUbqvuMIv2iHe08OrAFRNjwc7IRTLeN5u5LktnQzft/m/T28PMsRRU
	aGtFJVeiJbLmeNnFiBA==
X-Google-Smtp-Source: AGHT+IH+tCG51tTfToGtalOfr4jm1GPLIEdYYz0WZu1LFU6o/sXkUUif2KKj20JmKczb7eMhosGsEIxjk4+0fihs
X-Received: from vkbfs3.prod.google.com ([2002:a05:6122:3b83:b0:50d:9196:e944])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:4203:b0:515:26e7:736 with SMTP id 71dfb90a1353d-515bf307c0emr11029687e0c.6.1733339668025;
 Wed, 04 Dec 2024 11:14:28 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:48 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-14-jthoughton@google.com>
Subject: [PATCH v1 13/13] KVM: Documentation: Add KVM_CAP_USERFAULT and
 KVM_MEM_USERFAULT details
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Include the note about memory ordering when clearing bits in
userfault_bitmap, as it may not be obvious for users.

Signed-off-by: James Houghton <jthoughton@google.com>
---
  I would like to include the new -EFAULT reason in the documentation for
  KVM_RUN (the case where userfault_bitmap could not be read), as -EFAULT
  usually means that GUP failed.
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
2.47.0.338.g60cca15819-goog

