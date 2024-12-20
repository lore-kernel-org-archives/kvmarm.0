Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0209410A3E
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 01:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658752; cv=none; b=gBgw69yqdlPoxKltP1+Z53DxbsyL1RUuNcRlYwd/iciNOYLZXSAGGcR7SdTAIxKG6JrZRsuuQM2PJWJRYq4Bypfwy0t89e/8j5V0KMUSBHBONPJG6K7OOCen/KTjRAbd0Pyj07ZBe/p0iibqpFMgLEOfFsDF0YoZ82HxqUblAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658752; c=relaxed/simple;
	bh=vUAkr3IX2LE4GH/mlPkbcxzVyqeoUOtvVrlhcSINMSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQ3osmzosFrz4jDvaFDVuYQnVL9FXj+WBb9CNvmbB/Z6CgMqJ+V2Vq3LVgqJ+/qSIFEZM7IzsYPuk1qRtFLT8SYnZt78EqLecwf9nmB1F5Q2jN4F19CWQW90JQsp8D+ZNNJxJ56zrJP+xvO+0AE/01aRA45PRDW/5FZjMb3AKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GMrl4pMI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GMrl4pMI"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eaac1e95ffso910715a12.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658750; x=1735263550; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=GMrl4pMILMPoPkOzfWXrnrXJZVUUviBC7QPs/k+Kny3js2bM2A8dUj+ev48SuDp3SE
         m4G19KAGoDJ86bRDFUEYN17zDOI5tym7oasMS9osmpTK5uijR7QqOa28jKXqt8MtTJ6o
         mg8+MmF0svc2GxxLGsMCidozDOi8FjO485Q9JfPE/7I72ImTTfBsZ0H7TWBf5MrMvU2x
         nCwCW50nFfxEEVTFwLiQbQVCXXN8KL6yvcC6bZAJHyTNPFpnG6G7W3UFGMh83gNqsaMb
         c4PbmtWfUIecV/o8HP1qSvK00eP8KcUYWTmfj/LF9LyAmBwEP2CNOKV5bku0Avge+vZT
         pahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658750; x=1735263550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=gpy+MJp87x1bbEe89lB9wXFKB7DMYSSz3DignjMHhnn2bqGk1UVj9ALjuVU1Og8tNW
         AMzIsBC+pJrGJ5RMnasTUOBgRtpRfeYVbBMEibLh6DSV4SRD5frnHfVU6F0bJB/BWTf/
         hdqLojuu9kFrzjJJkWlNwj8hfBL3/U+UTDmZr5Fe2B/Dlqb2BCLNKEg/Ua9qffalIOfD
         C9jM0SBx9bnH2kDCBqoNgC7tPQ6+9e8F9WDZLw+z10INBiaTbVXGMt8rn4oqj0BTvftu
         S5IjgUzyDVIa0ljWpifnYcolqv6UBHrsCB2jzd8P2mxwOBtdDtNyA1RrGuI3N9NIJcye
         iR0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZVzRKM3FKX3i3Mx49j5Pm6nIetN0R623GV3LqYRfiRGqV8SK7oZ1TF8rtZoOHFGv/JqfTBDk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWH9vtO85ooW/0El8iSGjTM6zWXQq6Va4zO6T/d/Pbu5GscLg2
	CFjliLSQmE2pNboOSVL1BIK8a6LaJl86CHQEY2FEdJlcCeR5EauvSQRBxVGRuZmp6kWynnFanWO
	shg==
X-Google-Smtp-Source: AGHT+IGntiLPaNNzeAfuu6/TEmKwPAvoTiJFX2SO6583j9CN5As5xvpXTmf/fSQgTUKQrOus8R97PMQPQe4=
X-Received: from pfbch14.prod.google.com ([2002:a05:6a00:288e:b0:727:3a40:52cd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a85:b0:1e1:c8f5:19ee
 with SMTP id adf61e73a8af0-1e5e04945e8mr2117339637.25.1734658750347; Thu, 19
 Dec 2024 17:39:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:38:59 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-2-seanjc@google.com>
Subject: [PATCH 1/8] KVM: selftests: Fix mostly theoretical leak of VM's
 binary stats FD
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When allocating and freeing a VM's cached binary stats info, check for a
NULL descriptor, not a '0' file descriptor, as '0' is a legal FD.  E.g. in
the unlikely scenario the kernel installs the stats FD at entry '0',
selftests would reallocate on the next __vm_get_stat() and/or fail to free
the stats in kvm_vm_free().

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 33fefeb3ca44..91d295ef5d02 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -749,7 +749,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 		return;
 
 	/* Free cached stats metadata and close FD */
-	if (vmp->stats_fd) {
+	if (vmp->stats_desc) {
 		free(vmp->stats_desc);
 		close(vmp->stats_fd);
 	}
@@ -2218,7 +2218,7 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 	size_t size_desc;
 	int i;
 
-	if (!vm->stats_fd) {
+	if (!vm->stats_desc) {
 		vm->stats_fd = vm_get_stats_fd(vm);
 		read_stats_header(vm->stats_fd, &vm->stats_header);
 		vm->stats_desc = read_stats_descriptors(vm->stats_fd,
-- 
2.47.1.613.gc27f4b7a9f-goog

