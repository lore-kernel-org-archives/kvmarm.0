Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C0538DDB
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkT/Clls"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a7c97d5d5aso18628807b3.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563828; x=1700168628; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nUPeAHfZEyhmLdl3NqUNDrUfGjWmU/+Qb2Tjd/grrc=;
        b=UkT/Clls7lc5djtMH81w/RqEWUx4FF/qolL4n9aNG2WmkfY093VoX4eu3o0w6gOhhL
         ba86mWVY3YIvZVRUZAWKXrFAH3Cu8qXKayIDzFK5mfa5z3XR8R+zkNFaru/+lDAazKKe
         zfyu7OEgg8pcwgHVDiEU1kujRJNAW/vbG72c72iWXm/5OhIgzi37vFH/jfdDdSphYqLW
         CxgbbAwEWKiyBgzu1PjsOS9w6MIMO+2imSBR2ggMqgwCedGc5VVatuK1dyo30P6q9rFt
         MubaL2U4jMm12rpZZZouVZ3Z47UMlrqOfexN4utzNyoZuBSxqlNENS8wJWUdARKu138C
         zJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563828; x=1700168628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nUPeAHfZEyhmLdl3NqUNDrUfGjWmU/+Qb2Tjd/grrc=;
        b=CwSVRbqGkYhxTF3T2l1iJBY2DMr+toIk8KZwoMa9NL+B6rygud7sux9OevXMqOrdyn
         0YdRpKaioV7Lkifiv+coz1Md3rCKM3DjKbAEadKVTOJY7lbFeiOizSm9XEglJNqvZUaD
         B7/umL0Vl62oSBZZQBoaph2EErldzPIizppF+wJWG714ba8xADTjUV7shZesT04r6+Je
         4Oop1rFztOYpgmVQ3AY4UmxQ7q2Zfwn1POkoYlQfVpw5YPgHj5X0PwdJ7Ie/9SADclV3
         WmXucXemWcUIbpfQUo90GsTE6uFBvpqGJE1bnUEgKZXnLYyhHHl7iQ/sYZa6+4Tjh+9t
         6LcQ==
X-Gm-Message-State: AOJu0YxbtWQeRShcnB96ZkL+nLHtQSz03ozzkczibMQUjLNO7APYfGUl
	Xqdbqr3vxuP5M54VG3wKlHVVsQr2w4RqEg==
X-Google-Smtp-Source: AGHT+IGYRKD7rEcFCG/FkA77dggqygTDLeWg1w3kaLGy0YrkzhLxkHgLcnRLFPcg6Q/Xm7V2ZW+NzaJ/Oc7KBg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:e643:0:b0:d9a:c218:8177 with SMTP id
 d64-20020a25e643000000b00d9ac2188177mr146076ybh.8.1699563827866; Thu, 09 Nov
 2023 13:03:47 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:15 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-5-amoorthy@google.com>
Subject: [PATCH v6 04/14] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT
 RWX flags to userspace
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++++
 include/linux/kvm_host.h       | 9 ++++++++-
 include/uapi/linux/kvm.h       | 3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c13ede498369..a07964f601de 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6979,6 +6979,9 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
 
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
+  #define KVM_MEMORY_EXIT_FLAG_READ     (1ULL << 0)
+  #define KVM_MEMORY_EXIT_FLAG_WRITE    (1ULL << 1)
+  #define KVM_MEMORY_EXIT_FLAG_EXEC     (1ULL << 2)
   #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
 			__u64 flags;
 			__u64 gpa;
@@ -6990,6 +6993,8 @@ could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
 guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
 describes properties of the faulting access that are likely pertinent:
 
+ - KVM_MEMORY_EXIT_FLAG_READ/WRITE/EXEC - When set, indicates that the memory
+   fault occurred on a read/write/exec access respectively.
  - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
    on a private memory access.  When clear, indicates the fault occurred on a
    shared access.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d5d139b0bde..5201400358da 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2372,8 +2372,15 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
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
index b4ba4b53b834..bda5622a9c68 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -535,6 +535,9 @@ struct kvm_run {
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
2.42.0.869.gea05f2083d-goog

