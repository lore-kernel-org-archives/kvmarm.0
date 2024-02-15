Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E314601B
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041258; cv=none; b=pL+BMTRT7iPojLDJANYn69JGT0lhMfjvaeVOdd6l/HxJ0IKy2Le0hdM2we3J8qSzXUikqVhIoVB/YJGAnIxfoEyhCkmt0n0Lq3uwBkPluW3Cb+VGbHZ5qCa0PF2BoYguxBNMmeuefpA4W1p/5m7QSE1+GLLyDuosikateLBrKDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041258; c=relaxed/simple;
	bh=Cgdei//BJ4TfS7THt3BBXytD0NBWfYjOmDteYlMCj40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gdd+ARoK4NQ/WrEArkByNCHZ2IquyBiA5x8GVOeO7xQovHOv+MDbiGKI3r0ywPVrp8ai9oor6VybPoWfPAjbndbbnSIHwJheVsn3OG4fGdJ3eu1IvO+WslswZ8OYFzgXTliAqv/DBOG32Dk/E9RJF8bhW/+iiq5/SXDd48LpSwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ONCJ69d5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ONCJ69d5"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dccc49ef73eso255458276.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041256; x=1708646056; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/E37B8pEtQeUXPVkKOjh16ZsPiNTw6lyoy6KXMrnX4=;
        b=ONCJ69d5Fgu+jNDT7u50EXC8knDES9CigmRGn5NSFGMmv1mtdMC7p6bH4J2j+LiBny
         7ID1USL9jJVQr2Ph8sidJEeqbNB+sD6lcJbf1xu17gA4R+Vt/ubL+rld38evrXGYURPH
         BVDFaArOBT7Vk5JQ6Yh+Du/MpaIm1kZ1Tl8bW4Yv/cv6MNofHnEOPkMc8WNIxHYHFPoW
         j4eWEQi5qWxdr8FZP3LLlFCmC0Za/uSymdELopUGUewkUwPbzqlsAEIDZYIU0Iwy7TmE
         zPDD5d2EsS8mGS0HwnDFPTUy8zxB6q7hQvLa+2kTVK8zU6p1FnONKfn86qlvsBxhTVtS
         IusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041256; x=1708646056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/E37B8pEtQeUXPVkKOjh16ZsPiNTw6lyoy6KXMrnX4=;
        b=wIgU981HL6UgbXc3eG4zHIfAhqQfLKWqWeTKBEn8TDzOXuNXM5ejbeX2zLNtekp5jO
         DJIqnz7BrIy784xGHyM+/kjZmYUyn6wfYJa9OPJtS9i8ScHtMxK760Sv4bD98RFChOUm
         iyup1D7Sltwg6lQPeLDi4kP1n//NpXYEMEU+vGevnsCEklgscoPIyhasr/jFvm7/RdDI
         +jni0Q+3KOupjSGf1rN8zufnO7F+AShJmUS4LEdV1zNzcLiORoK/SHKjy1R8efLF4mcD
         D43W+uRTGWxZHGNCtDNs+0R91fEzxnBYfEOWpP1eYb7WXBGKJ3HvALedSvFTQCdrVNAK
         rjBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhZYIlEB1IjFu5S9dbcUsuW+5ADpcGsmo/EeveQ2D82B9Sgjj2ORKi5paEnRFjSxkhzFwG53nz/NJRsuhB7iyAkqo0TVXU
X-Gm-Message-State: AOJu0YxurOOZSp78BWHPXdd526C3UTDLwNIx4bdrbNr7PX/qtcBhCToT
	+ST6EsSn9i4CHv12EmO9tZxYbLu6cs/JqwJ0J5xmA82/6mBY8CeGrpeR2wSHDJSgHjsDJb2G7wA
	lu7l2IuzgnA==
X-Google-Smtp-Source: AGHT+IHedA2uvd08JONpyjwItnwJE43l4fF1/9gQHix0D/EhvKZ7QtfHgjYc9NTkUnT48me3Qd8VZVAkzw6WqA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ad8e:0:b0:dc7:63e7:7a5c with SMTP id
 z14-20020a25ad8e000000b00dc763e77a5cmr197747ybi.11.1708041256253; Thu, 15 Feb
 2024 15:54:16 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:56 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-6-amoorthy@google.com>
Subject: [PATCH v7 05/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

kvm_prepare_memory_fault_exit() already takes parameters describing the
RWX-ness of the relevant access but doesn't actually do anything with
them. Define and use the flags necessary to pass this information on to
userspace.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++++
 include/linux/kvm_host.h       | 9 ++++++++-
 include/uapi/linux/kvm.h       | 3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8f75fca2294e..9f5d45c49e36 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6964,6 +6964,9 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+  #define KVM_MEMORY_EXIT_FLAG_READ     (1ULL << 0)
+  #define KVM_MEMORY_EXIT_FLAG_WRITE    (1ULL << 1)
+  #define KVM_MEMORY_EXIT_FLAG_EXEC     (1ULL << 2)
   #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
@@ -6975,6 +6978,8 @@ could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
 guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
 describes properties of the faulting access that are likely pertinent:
 
+ - KVM_MEMORY_EXIT_FLAG_READ/WRITE/EXEC - When set, indicates that the memory
+   fault occurred on a read/write/exec access respectively.
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..32cbe5c3a9d1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2343,8 +2343,15 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	vcpu->run->memory_fault.gpa = gpa;
 	vcpu->run->memory_fault.size = size;
 
-	/* RWX flags are not (yet) defined or communicated to userspace. */
 	vcpu->run->memory_fault.flags = 0;
+
+	if (is_write)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_WRITE;
+	else if (is_exec)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_EXEC;
+	else
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_READ;
+
 	if (is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..36a51b162a71 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -428,6 +428,9 @@ struct kvm_run {
 		} notify;
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+#define KVM_MEMORY_EXIT_FLAG_READ       (1ULL << 0)
+#define KVM_MEMORY_EXIT_FLAG_WRITE      (1ULL << 1)
+#define KVM_MEMORY_EXIT_FLAG_EXEC       (1ULL << 2)
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
-- 
2.44.0.rc0.258.g7320e95886-goog

