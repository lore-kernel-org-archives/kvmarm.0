Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C90145FF1
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041256; cv=none; b=mkoqOvkuyuNWnkmuz61XGBaMEhM9EmG1mY++BwUxGJZRVreTWdmG5hb7wYiCl9PTKFtbyja4NnQlixgTPlNCwHsi4NcwkcwbxG927TJiLIs4x4JvlQq24M71HXQ5tkokEhhdIIn+LJM3Xyd+ZIM+4L9xnTt+OQvCcqiyk2b+eCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041256; c=relaxed/simple;
	bh=OMyN7fHzEfLgoBye4T8ZSNiYVwuoMrC6dnIEAZg3ngg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YSamIkAZB+r2D6AJ+IdNoc3h8+3wVgb/d+vOZaEItFqgenKQFJGTZfal7ZFC3/QEIgA1JGEahRWubZF/A6tsyaBI25DOVLcqqhf2P8W8Hz8uA9CoWMWKMwHD8y2ZXPqx8F60cv9X+kOh8VGYlJpWIArQ9z+nt3JbZer4r/FMoh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3Wx3S9w; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3Wx3S9w"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269686aso2204189276.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041254; x=1708646054; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jBD0v9lfe/Rw/ET2I01vheD5aGv2zWzm/5LdmhbgJC4=;
        b=F3Wx3S9w0W19osPF4OmIwpVWRfciALllrB/YecnEOTHCKvnse9FqBcmyZZ1XMTh1EA
         8sFt3IzEbZoI6Wx2KMVCV5oNPqWIeiYUglCyQZ87Qu0qwLtDNDM7w+lCHi8TVu4ciRVW
         VldazwvDkq9malwL8/eEUD74hXplcpdIUAIh+KOe5gAJ8btuEc7p1Wed1CjZAfjjzF4v
         QN49O624V8qgexGbPyE2OiRy6XhAOLRyEMh+b8xaw5f+TwQ/yzx4kR0CfocJ6rPormai
         hd7/PZH3G3na2b4aSVeD+IV41K7SzWhkY5/0jwYf+BlBdOse3nxaeei044XTdJZ6KLzC
         fe5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041254; x=1708646054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jBD0v9lfe/Rw/ET2I01vheD5aGv2zWzm/5LdmhbgJC4=;
        b=iiZciGin/lX5GsDLiRmsIk1IzN9ryxuPnvt970oS1HNbMiWt6i5ZqtQ0i8Z3Fu6bz/
         IHVBpJ1iWsDrcK7d7lLdf2ycscmI1+ltV8WqaaZjLwxg3zchCEDtEveWXJKtWtrgJVXT
         FQ3Dc4tPhOHnCXrHL2Rwy0VUmHMcP34/s/0NIBqe8fpaTzuihJkBi9rA3eqXiqt/mqQw
         OOmUG+8lKkCeIwMC60i5F23pZcDW0dnTy9wa0DJ/VlhG0+rfv8gCEXw5P6EEjtl8mvd7
         tYtQ6CZq+liiBEXv5twOPcP0Gv7kL6WT1UTLIko4KT7lPzcNiqRm/72NJ14eprKiFkzs
         K0cw==
X-Forwarded-Encrypted: i=1; AJvYcCVNMzg/OndoTDMstUeZxqZ3+of7NJQ02/t1J3mwNMLdREy/hgXzZeKkux65yDExd+vNBgg4RFZ6y2bVRPo2Ud1stbyNa8U3
X-Gm-Message-State: AOJu0YwJh8GJASbCNnqJXVuJXIoOgRsx23ZgJfokP1dl5oBKJv6xvP5O
	luJZ33tOOYWCUK7b61K9FDmZrRk+ByBgn1b2A6fNcK/Xh6jg0hkwX+0JWSXtBNHilgXY8p/ajIV
	tLJ8Xub4obw==
X-Google-Smtp-Source: AGHT+IFG6eQ7U1pvB32UpE/Y9o390fzwKxrTI+bmqgzS9btoriiRyB8NESOhZyB5uyLvr3E+n4pE3rTBJf6EHA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:d47:b0:dcb:611c:9055 with SMTP
 id cs7-20020a0569020d4700b00dcb611c9055mr129053ybb.5.1708041254107; Thu, 15
 Feb 2024 15:54:14 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:54 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-4-amoorthy@google.com>
Subject: [PATCH v7 03/14] KVM: Documentation: Make note of the
 KVM_MEM_GUEST_MEMFD memslot flag
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The documentation for KVM_SET_USER_MEMORY_REGION2 describes what the
flag does, but the flag itself is absent from where the other memslot
flags are listed. Add it.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ec0b7a455a0..8f75fca2294e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1352,6 +1352,7 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1382,12 +1383,16 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
+The flags field supports three flags
+
+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
+use it.
+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
+3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
+incompatible with KVM_SET_USER_MEMORY_REGION.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
-- 
2.44.0.rc0.258.g7320e95886-goog

