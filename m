Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B727E155309
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618294; cv=none; b=Kf1YnlQmYOFmzX9gKrDHHw5NDsWV9x9r0aKEI5b6Pa/GiWxIduv+4tvSWci5To4raJCyYXDpZSrvS4aW8UgZyIUKETevNbKiJpbloM/oKTQDH9uQOt3JRnmwO5dfkOljIiJEc+sfRiVsItTX0aUqT0RDvAoFsuqvqmYLVUq4SJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618294; c=relaxed/simple;
	bh=6iVb08zKfzH5hJWQLjCXBzmY+3QGd9wO5l8hFYC0rUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJATuQv+fXSlNUlXkYIU7XyUkxZe8sNjNaK4xLJb8XT2lIeHnreR/k1x7/WJqWkSwUIEb3yw8BYigieY0LOJ/sp3cxeSgJP66BvZsfeKc7O3jfRRj+pnY5yPC+4r47FvMskmBYm98HZ3aDuAUboXP/cBhrEyyTUClwd8c5V1fOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c8sHGanu; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c8sHGanu"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33d19ac07c5so915677f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618291; x=1709223091; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rlwq3mGjsbZmc2k1s/E60FvUuielQ8IuRYRmKjrhRfg=;
        b=c8sHGanuXgUUO89kwin1TDj1qc2Xxj1Xaa5PJ52USOOBDpxiFfsQNRrwOY2GT1PHqm
         F4TWKIhQtr0uW8cV0TzKTPMWoHGytAltbjk9jdMyVxhtVCUNKGi//VQ085DWItClv7/h
         RnvaDyBEyT3W3rcTtbnePtYLdSeTKqdpjezaZnh6Pjeni6rhxmzAugcTGqSsiYfixPcG
         R1sO7PAg/d8OAyVkI4NOl9Omuuck5FR8WHsS0G8SweqLh6stNxnNeSRftOJFoCfOy4OU
         6U89JvEAFyqddgEIqb9JIkLyB5ywvByaoeETgKqjpuiycYXYZf2md/pzlEUV9uV1N2P5
         2Fbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618291; x=1709223091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rlwq3mGjsbZmc2k1s/E60FvUuielQ8IuRYRmKjrhRfg=;
        b=LWyoU/rNUPGiJ9YYEXwXFEnz6cki8det8jxoPA2yTdLKxiKODKaV2TesIPfvz+m/YV
         hFvc5Dgzx4lzas0eDJhq9dMl0irxk5D4cbsU26GE1mBfANkF7sPcAY80oWMVdkmq8x2k
         OQ41RpP78NsktsIK5G3xT9EAXc6Gxlj61TPT3nrLhyRcJBu4Ts7vXGUGmGis5vszVFSc
         9R+KFa9+uNZeSyin2HZXwbkCTl5hnIACBRJDTnLcQjJRwBItFUVerCqkVdQsgYcISPIf
         Uhy+zjTJuy1avQYUqZEzThOfXwSLqQ5VNkP959ERlSIrsnJ7G6Kb0fBhjkgh9iY0t9AF
         TAwA==
X-Forwarded-Encrypted: i=1; AJvYcCUCkXyftBMZzh4MxGNucyRaSHP5e8yAP2h2Dlbw0rj1TuGatUcaDcjgwMb9UW0po6uhs7yk5ftfiCjPlF12wqczXM7HrkLU
X-Gm-Message-State: AOJu0Yzp+Vf3DIe6fsMgv5hEZ2U3JrxAOUG3LaJrSdm56lNgdrPbrTpf
	DFYD9V2Cr4LaSlfb3gGLexda2giOhUxZLglJXq0PQKjcuef/CUOuQBBSesPKUP9fUzNBCMmdYg=
	=
X-Google-Smtp-Source: AGHT+IGPBlBEWHSVTXybSf5AXKW9r7iJYYYJVo0ATzUwHor8Yu6mnFaOUn7raP8SctTXcV/NU58hv2UYQg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6f18:0:b0:33d:9fc2:5e26 with SMTP id
 ay24-20020a5d6f18000000b0033d9fc25e26mr109wrb.9.1708618291025; Thu, 22 Feb
 2024 08:11:31 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:38 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-18-tabba@google.com>
Subject: [RFC PATCH v1 17/26] KVM: arm64: Do not allow changes to private
 memory slots
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

Handling changes to private memory slots can be difficult, since
it would probably require some cooperation from the hypervisor
and/or the guest. Do not allow such changes for now.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 391d168e95d0..4d2881648b58 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2158,6 +2158,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		}
 	}
 
+	if ((change == KVM_MR_MOVE || change == KVM_MR_FLAGS_ONLY) &&
+	    ((kvm_slot_can_be_private(old)) || (kvm_slot_can_be_private(new))))
+		return -EPERM;
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
-- 
2.44.0.rc1.240.g4c46232300-goog

