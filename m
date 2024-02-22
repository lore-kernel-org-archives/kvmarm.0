Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7633154C0C
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618284; cv=none; b=bhzzM1Uj1rU4kyv8TQ1WROSg/eo+IStiLgdMzr2wlsDndJEROV67YhnoYgC/VVcGKy+NZqVOh7CbCU642qQLhYO63e1Wlo/HMmvs2XFgr1YdetM8u+SmCR5svad8+kAHWV4OTuegwH+qHL62OLJp5vTXhLx2o+bTs5ZpPss5XXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618284; c=relaxed/simple;
	bh=xoA6/QoNnISiMa1SzXuzX77CZKmuI5864LBCKgX+2hY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AtiH+uqcjb6djUxKpLKpYhxboFLZYzjHiNEuXXCK8pFjGs1lwJjAAc7B+OGhX2wFDR4OvCZUVSdMxoLXUxgGYXpMpQiqlBj6J6islpujGqKl/+Radeb3ehlXlUdOAC6wVVA2bbMovbK4HG5Gn+W7RIZfWd621QcKPMtBUAnJAqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qmCfWWN7; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmCfWWN7"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so8125911276.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618282; x=1709223082; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CeE6bcXPJ6+XfnAesbZJh5X/3MioJE5wiGBVIwsoMXY=;
        b=qmCfWWN7pK2Tmg3gx/46h1gTHO/Z+e2LyBzHRcIvVY4LGSucvPMjvDnZK03tUSOFLf
         HLiTvkwqMwqn7Y28OuXm/oRrECDKjY2wSv7hokL2t3poZl6FIRy4P3uWh80XhNwmlaYu
         pZurDEon31/67cjPDBdJT98QlFPDJV2FqMDQv145K6ddl0t/wf4fuGy/UyZ9+hWyYfSn
         hKO+G9qWxvUbUwly51Gxj/8E26Dhs3p2LFk4EQBDnXXudIklXnyRGIvGl57N/SyJ9HJA
         uPU0Hnc5F2BJPi8oZSMrM+aJyGalm4VZDCeaQOkQ8SqEGVkHqAOKVfETLZRACMIjlxxM
         QM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618282; x=1709223082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CeE6bcXPJ6+XfnAesbZJh5X/3MioJE5wiGBVIwsoMXY=;
        b=ohaNGCDbUF4A9uucB0rftG7xlSECMBrJPx20VVNcz0KfKNmS74q3ScKAj5MQSyx4tj
         dFRnL7gs5OjfzG9HT4ZOCNlc7KxFIx6ECJkrhI3OEA+AhJX7QCQ9KCFjkDG7efdK8xIZ
         LJFVDUEXKRtfosd7zusNVn1kyEI7K3nMj7xyJgPybytYUCXrx2X2pebsU8eofspv/Eru
         6Tt053YdQsjosX92EvbmLg7OXkQQe/+gNWxs+IXhSelHcavWve6fBJoEW1c4D1sssKTk
         ofvomT8U+ORiGYNhrPQ/TwxBvy7dPoj5SpGp0/3GyYQb7cgcrJdQiZ/ea5sZKT84Md74
         vBxw==
X-Forwarded-Encrypted: i=1; AJvYcCWKkly5usKOwmUW+9tFtGrA9IVEfEFwDNm6TJq7mUlKXTELTQhhOnF/AKn14gsU7h+viAgalwmJ5vrEmiRVjS7rrXQkyLqV
X-Gm-Message-State: AOJu0YwTghF8D3M6tvesMmA+R/Qx5DDYXwem/wPG/lFK1ON9CVe3EhLl
	/ai0okj0mhNLdAkUf4Rhj0FMQA2Op2I4XPvQXtmUSANhiQXiMDY/7j/lbO7SlnjGSBeFE7apog=
	=
X-Google-Smtp-Source: AGHT+IFstTNpKcDxQ2leE1X3c1ER9vVPby1ys0ufBrD4msybQfHDs42OffDOkXrhTSWHmYX9zR+v4HUSxA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1008:b0:dbe:387d:a8ef with SMTP id
 w8-20020a056902100800b00dbe387da8efmr90717ybt.1.1708618282006; Thu, 22 Feb
 2024 08:11:22 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:34 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-14-tabba@google.com>
Subject: [RFC PATCH v1 13/26] KVM: arm64: Create hypercall return handler
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

Instead of handling the hypercall return to guest from host
inline, create a handler function. More logic will be added to
this handler in subsequent patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  8 +++-----
 arch/arm64/kvm/hypercalls.c       | 10 ++++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f6187526685a..fb7aff14fd1a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1100,6 +1100,7 @@ void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
 unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
 
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
+int kvm_handle_hypercall_return(struct kvm_vcpu *vcpu);
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa);
 
 /*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6bba6f1fee88..ab7e02acb17d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1092,11 +1092,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (ret <= 0)
 			return ret;
 	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
-		smccc_set_retval(vcpu,
-				 vcpu->run->hypercall.ret,
-				 vcpu->run->hypercall.args[0],
-				 vcpu->run->hypercall.args[1],
-				 vcpu->run->hypercall.args[2]);
+		ret = kvm_handle_hypercall_return(vcpu);
+		if (ret <= 0)
+			return ret;
 	}
 
 	vcpu_load(vcpu);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b93546dd222f..b08e18128de4 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -24,6 +24,16 @@
 	f;								\
 })
 
+int kvm_handle_hypercall_return(struct kvm_vcpu *vcpu)
+{
+	smccc_set_retval(vcpu, vcpu->run->hypercall.ret,
+			 vcpu->run->hypercall.args[0],
+			 vcpu->run->hypercall.args[1],
+			 vcpu->run->hypercall.args[2]);
+
+	return 1;
+}
+
 static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 {
 	struct system_time_snapshot systime_snapshot;
-- 
2.44.0.rc1.240.g4c46232300-goog

