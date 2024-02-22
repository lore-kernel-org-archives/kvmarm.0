Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD9153517
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618266; cv=none; b=rSxcJwVxewwFOsqDh1kiSa077q/VYLzjGaoTKzfB+xQ8NnXvq2UzfO6DG4YhtP/AJTQz1bkkioBaltRBR/QGMOdzwaUrUL6YZV/oFuxuH3iVDnkIdbVrild4PvB+/AMia2SIur6Em09f7VLQqb93BinKA2/534zy8K5nQOoG+nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618266; c=relaxed/simple;
	bh=34CFzZBAcfeTUUnSxZLLwRxztPMpGbF0RaaQznrO7WE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tR/vqPeAy2YIZdxhcmkI3sQaQ2J9UA2BTvpxo42BFbCeYyECPZxs/l6V5woR5tjJuexMdQTTp9A/50MmFmiQLoZiQWoh8LT5GZzjuTOiqTFsNYqbMsdmL9uA5ZIG1Vnk1FmDTvazfnl28MsS4slvs7ClbcYLNHg/3XndCrl5H9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ul+YSbV9; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ul+YSbV9"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-40e53200380so9902125e9.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618262; x=1709223062; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ps0B2uWSs1/RQhbKakYOYB3FB0WNj1ejEuJDeJil1+8=;
        b=Ul+YSbV9i0IVGP3/RpAeUjLsJwqUhNSLVxVm09MhA28gBXsRo1jLVSvvFBLCYzSnyt
         kQR82wMEj2ziABPy8yerRc9JJuze9QXNlpqUGmeMbqoeDBB6lMwapE7+wTF1wQjQbP9O
         zTpHsZGXGiqdNcsjDlE6PS+OqrRVpkf7YTtOYXb0rZiS+pYTyfQVQdMU8+zx/fMMNKwm
         ybAmy9FGWXtvN679pfsaHwbJLI+cl/j93B/2iK62mLcPQRIXsmj5LCJm2GQdNiX/W6Xo
         JdsJwWM2P09dKwTCvjXpbpm5332mLhfXvCXBq869C41zhaic1kaOz+XwSyDB6b+zcx8W
         oGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618262; x=1709223062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ps0B2uWSs1/RQhbKakYOYB3FB0WNj1ejEuJDeJil1+8=;
        b=u7Kw6H1oOsuqtSvG7qYhEoHewv83lKL1cBVaSF/z0ajOUoCTsSQX1HjLX3tYXu4tHy
         Aw4uZoe7i9EvO8Eaft176rXmCzfVweR7X0I2THkra92mCBu5dnbIIOxDrvgHnsoRNXAw
         qLgYvN1HkAiEcpdBLm5/3VHqzYqzig2eUlM5bajeb2yv/AIPdr6Ot9W1COeb+gzy8wDB
         urCuCwr/zgzQd59cMZPOzpOBfpHVeVZnf2lxB52H3koeZnV0uubwwsyWY7dXOeiV/nsT
         egBnauZfbs4HVLfHKV9y7pkgaOdMvGOEHF6IDxXnbZY88I3lk1cHeTkgaPog1urt4Wx/
         pb8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOFIA6Gz1WtM2c31oNXsf8s8yeEHMW5N5G64ZfL8mrqbvre+ZL+s+0OPykZmrr3Nzh8DdH4S79cOGvsgVMQmIlU5PsgfV6
X-Gm-Message-State: AOJu0YxjH1km+TuisMtrz7M0WaV5aWqhwBOMS4QVrCHJ41hkNrZxC9qi
	N2w7okkxbIVSbM9tioLnVt9MbkvE4z1VShIdeR1DkzYYM1c1AdBLLAMpqHTXavoWMk8fHJ7jMA=
	=
X-Google-Smtp-Source: AGHT+IHx3V/mRqxPnXGsf4wttfDhhzBtQLJct5h8U32Pa1DCbngXj0qYKMXJICyFPSYG82DXJTE7ZZxBNg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5187:b0:412:8887:2946 with SMTP id
 fa7-20020a05600c518700b0041288872946mr4674wmb.3.1708618262659; Thu, 22 Feb
 2024 08:11:02 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:26 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-6-tabba@google.com>
Subject: [RFC PATCH v1 05/26] KVM: Don't allow private attribute to be removed
 for unmappable memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Unmappable memory cannot be shared with the host. Ensure that the
private attribute cannot be removed from unmappable memory.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9f6ff314bda3..adfee6592f6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
+#include <linux/rcupdate_wait.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -2464,6 +2465,40 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return has_attrs;
 }
 
+/*
+ * Returns true if _any_ gfn in the range [@start, @end) has _any_ attribute
+ * matching @attr.
+ */
+static bool kvm_any_range_has_memory_attribute(struct kvm *kvm, gfn_t start,
+					       gfn_t end, unsigned long attr)
+{
+	XA_STATE(xas, &kvm->mem_attr_array, start);
+	bool has_attr = false;
+	void *entry;
+
+	rcu_read_lock();
+	xas_for_each(&xas, entry, end - 1) {
+		if (xas_retry(&xas, entry))
+			continue;
+
+		if (!xa_is_value(entry))
+			continue;
+
+		if ((xa_to_value(entry) & attr) == attr) {
+			has_attr = true;
+			break;
+		}
+
+		if (need_resched()) {
+			xas_pause(&xas);
+			cond_resched_rcu();
+		}
+	}
+	rcu_read_unlock();
+
+	return has_attr;
+}
+
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2614,6 +2649,14 @@ static int __kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 			r = -EPERM;
 			goto out_unlock;
 		}
+
+		/* Unmappable memory cannot be shared. */
+		if (!(attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE) &&
+		     kvm_any_range_has_memory_attribute(kvm, start, end,
+				KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE)) {
+			r = -EPERM;
+			goto out_unlock;
+		}
 	}
 
 	/*
-- 
2.44.0.rc1.240.g4c46232300-goog

