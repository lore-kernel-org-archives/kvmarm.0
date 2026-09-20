Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDCF3DBD43
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933024; cv=none; b=eIjssZDIe/UfrqQ3nmcz0z0qjzydOpoDYzjNBOXHc1Uu5MkPayTBjyTZKkgZuazWrVmDYrhQRLJOnyINjeNyoEgiwWVtZhUPvZtR31UpJgX5t3x3xMyjeTdhyPDXsGBhQ3SmhyvX1jwkSWZxpZRsLNKPNxxQbaYH3cZ6PbZAUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933024; c=relaxed/simple;
	bh=VA+J8gVgQJjXgqa1KyYAn5D2Rm8bdS8GTWaA8o/nJp0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWFtK6zb1POUMCk/sZEeJsAqgUpA0CHGHjEL7dmtLrwnb0fOX75Eo/0ZZst6wc+5Qdcp9F9gfha5UqMWlCAUOs4N/wYxIItOC8Hmu3CqwDyLAaaW3yrv+RXL9SWimtUJiiJ15THpJ9D9BAOPYqx4vnSqkFrfamkRyJI/T4YtLb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=cVGrVJCL; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="cVGrVJCL"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aae3149so1690627d50.2
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933021; x=1790537821; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S731x7B1q5+LU0uMImlSdu51MYq8nznsZeZCtyZbDcY=;
        b=cVGrVJCLUCvpagq0xSa7aAM3JPGDKUZyCnR2IGrFsmXcbxC29Wwo7M2+uAlEUqc2GG
         wBjJOZ+Kpj79A4RmlBnmx6F51a2+DPfbtgl8JjQoRfK20Xq+rF5Z0t2rxEd3GL4Ew6Yn
         H9hrGFwowUfMr6tSokoWmWeB8E8d+BiGO6yvzV/iAvgxQ6go8y9fVevjhNfD9NmUmUNx
         WBJgN1MJDO6lQcuAxwmY2Mdpj9J6M00kHeXn4wvdz4fdNb31hEqqPxFqwulqWiJIh2be
         z8D0S8X1/pC6fs9KUaC70i4PNtjVgobqkztZaFrt5Gp/8IItaMqorgHlNSlRhc3kv01D
         m4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933021; x=1790537821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=S731x7B1q5+LU0uMImlSdu51MYq8nznsZeZCtyZbDcY=;
        b=Muk2zAReUCDCdLVbe/6omLqI+ZaMIZQhtbbUmA4eiLEfJ8lGul0WZjwby3wcbA2qp3
         IetsOA0TqgCLjFxP9T7byIRQ2MImR1tmMXHoWKN/Ugl1wyA+WJ2OMoRYIIzlri6hhoGk
         kF0pxTAG+8J5IHRKVhuAjOADoQHePX+V/9rgQ2zQ3rD++PCtXYgmvxbVUT7W06X9OnWW
         kS795TGApGnh66XYcCyfM2uMyj3hRB3f3/dctddRaS00uqxVSgO8QHTU7K1eVxWG8gQ/
         uwp/cS+rJ6Q3lyLN4wnG0HQ61Ri3Ai2YAaI9u7KllMCkv4mEYL1EPPNpFt9AicTW+z1r
         p2nw==
X-Forwarded-Encrypted: i=1; AKwUvBzjsVbSbmoepsRPjk0ESdSAuSZ6/j/Gu9sYWMUU0+I52iXNYLh9T9+GCqNLKI0+WiBPSB0Ls3M=@lists.linux.dev
X-Gm-Message-State: AFuF++ndThO44CuJayt9axRbEb/bOGrzMMsXHsZJ6HiF3TFMSEn2bAn0
	tjS0EmNnHpybpCnpwMvo0VQpi3i3UjvUDjLLZ9GhvqzSjboWLlJ+ECY/FWDcReGczXY=
X-Gm-Gg: AYBFou3U3HtNDmmK+RS3AxhrK8fpDA9rgSat0eOwi8DPlcsv+uq0YhAS6rKW+NZOv03
	0Zt/O3fZbYrVpK7YdXfxWIGyUwR7pPjEH5GLZ5E7ufaA7IeP2CEO14khHv1D9XC8aFG256Odlsw
	lrZqhBhzRg/GUjp9+Qni2QmO+N65o80MukZRx9NwWuR5Y9tWj1YsdzbfC3C/Ab87MHtXIPXQwLy
	LfZi1we7j6mNNcS3sMnLZugkGYFtxiwUaRx1pwxv5L5ZNauH9nKBpFCgoRK/y88fRWlTv7LZDFw
	25M+2OUORY158+i7CQGUm9rNALCPLTTrwAsZCG/NbTKcC01iB+8hraxJvLqFNcnmRVeUTi7WvMq
	IzJEIFSnWYdD175uuoWMq8u3JB5iHycDdCMHAwIouecYlNtGYIFXAnSf3ml0Pry03VqwgpP6l5J
	4eHcPpkx8Hk/rAQyer/3sDTCnG6ZQvzBX7BDCK1dl7A7M6eRbDwVXxFqPuPfHB53Lf1wlAv1Fx7
	B0tYCKveH1v/3TMkoE2ZXz4+nMRF9OyXfEWm2KFmhn9BqCSZq2zpSBaU6q68rOhRNgmB1zzn8j+
	iE17Z/e/BX3BkJpYF20=
X-Received: by 2002:a05:690e:11c7:b0:672:a2ee:6155 with SMTP id 956f58d0204a3-672a2ee6b7cmr1008959d50.45.1789933021253;
        Sun, 20 Sep 2026 12:37:01 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67299146eb0sm2607555d50.21.2026.09.20.12.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:00 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 01/46] KVM: luo: Delegate VM creation type to kvm_arch_vm_luo_preserve
Date: Sun, 20 Sep 2026 15:36:05 -0400
Message-ID: <20260920193650.3373435-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the architecture-specific #ifdef ladder setting ser->type in
kvm_luo_preserve(). Leaving ser->type zero by default allows
kvm_arch_vm_luo_preserve() to populate the architecture-defined VM
creation flags without referencing unexported architecture symbols in
generic KVM code.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 virt/kvm/kvm_luo.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
index 025b53151b6a..b3bd9bebe17a 100644
--- a/virt/kvm/kvm_luo.c
+++ b/virt/kvm/kvm_luo.c
@@ -73,16 +73,13 @@ static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
-#if defined(CONFIG_X86)
-	ser->type = kvm->arch.vm_type;
-#elif defined(CONFIG_ARM64)
-	ser->type = kvm_phys_shift(&kvm->arch.mmu);
-	if (kvm_vm_is_protected(kvm))
-		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
-
-#else
+	/*
+	 * @type is the argument the new kernel will pass to KVM_CREATE_VM, and
+	 * only the architecture knows how to spell it.  kvm_arch_vm_luo_preserve()
+	 * fills it in; leaving it zero here is the right answer for an
+	 * architecture that does not implement the hook.
+	 */
 	ser->type = 0;
-#endif
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
@@ -115,7 +112,6 @@ static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
 	kvm = file->private_data;
 
 	args->file = file;
-	kho_restore_free(ser);
 
 	kvm_uevent_notify_vm_create(kvm);
 	return 0;
@@ -147,11 +143,7 @@ static void kvm_luo_finish(struct liveupdate_file_op_args *args)
 {
 	struct kvm_luo_ser *ser;
 
-	/*
-	 * If retrieve_status is true or set to error, nothing to do here.
-	 * Already cleaned up in kvm_luo_retrieve().
-	 */
-	if (args->retrieve_status)
+	if (args->retrieve_status < 0)
 		return;
 
 	if (!args->serialized_data)
-- 
2.55.0.1082.g2b9226bbc0-goog

