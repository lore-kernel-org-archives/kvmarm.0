Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAB3225CD
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458815; cv=none; b=pAT0TYgCiSPXzIacF7i+sRltRsHvFwRabLVrv68Sybg1KRWaFB9X+TKK+0tjDLXxUKPOpSouLyQNXTmQ2eplYm2RdF4+3A0UfZdRXrqObnNIJtn5NDZrFYl1NyY2lZMZIE6YLdd5bjVstvD+EjX9RTZrhIw+j1fe6YQ0Jj4lkWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458815; c=relaxed/simple;
	bh=Y4lg842eyRtWuiU4N+Si7fkQtHRQlH6n5P6xF36CfXg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oyNQQDQR+c9osZD8R7AyYGjMs+h+hst1ZvIFdFAml2jE5rae46uTgI99H07/39iWb2qJsjGF4t+lusXKvt10U2V1euyTgdmjA7ky0tDcTDWJNG2egU7D0sCPz0dlGw+8fiz3+ZmTgq/N7AE0ReLJt91D+f4NPXZxWyhAXxASITA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cARHCjhq; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cARHCjhq"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so1791018276.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458813; x=1711063613; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bGD1oHLzIwlI71Um3uWf9rz8YDkt0fT9aZFmZxidv5s=;
        b=cARHCjhqDWDZ0uOwIH0nHa5a1mXS+Ms7M8vIZV2UXYu4Gj7HFn8bBoWM9aFlx5c0iX
         4J5W0eSYiDKiioioHSLnWNy5D3UbZx+iIU4+FShvXRqGwwiGH2SgdnvwTOHXtFNDPd91
         O34RoihLgszaFdEr1vNIpmfYZ8Z7bwTS0mujg+W4rFfCNDZIhPn9nUZ2bmkiySpbLgPZ
         AryrfyVGj/EuLP0nC9HhtF1yHVIw+j3RPTtj9wO1VKN/9XY+SbsT0mLoT+LFw5LAyiUp
         566cZCnxEbO2glnlvsX9vIEqVKdR84PGqpGSLi/gwq1wxsm+3m/uSqK2ocRZjRwlKeQJ
         ad/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458813; x=1711063613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bGD1oHLzIwlI71Um3uWf9rz8YDkt0fT9aZFmZxidv5s=;
        b=IsE7UoM8tAy1zYDXuBwu5Swyjf2Ftuj4RVDWzwDNtZShJUVvcrUf83SXtOYD4aM0M2
         i1G4vLhcmIQHXpQVRWAckTj73YcTdDiydpDuFs88OTaBTKc4LE6nG4r0cTPCh0avzd5N
         1ml96yo496fEMj1txkvbhI+O7jlWHIZqP7edUcd9W3vVBtNR6U1n9dyIsQF9j8MN1F47
         PcTuLsKTzMD3Ii+iSuJZKeFya2Hgf9ymRxeM1FbhqVqfS1bvIax4bSE/aYVud9S38px3
         KAATQVpB3kSmfemeLrejN9FCiDcQ6pgMFARDCPgnaX4p2OroRlkjNq9Eo+CqZ1ylxzSb
         nMvg==
X-Forwarded-Encrypted: i=1; AJvYcCXSc5oDSdKL/sp2uGyHmI7K6RuSIw3EE7Y6hMOynKECbKTLIzG4CKfxSEu2VGscqumv8GU69SAHOleAUnfoFxjkTDv7TsH2
X-Gm-Message-State: AOJu0Ywx60/4ViflFsGpVs+MgD8lA0BXZneT+TOHzSWJA/hgnOQqEZ1W
	iJ7gJLNuPd8zmNif+EH0A7FpK6DUnyqviA2R3luDbhUFefXQD1eklNB5clFln3zm4YmDY1X6yUJ
	krg==
X-Google-Smtp-Source: AGHT+IEf2SHyoW7Ci/nXvsu/vvl6dD716Be1qw4xm14NPqmYsKQJNpbDJU6sbwjkwsuGTYDcc+4TPOzUy5A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b85:b0:dbe:30cd:8fcb with SMTP id
 ei5-20020a0569021b8500b00dbe30cd8fcbmr188618ybb.0.1710458812732; Thu, 14 Mar
 2024 16:26:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:26 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-8-seanjc@google.com>
Subject: [PATCH 07/18] KVM: selftests: Explicitly clobber the IDT in the
 "delete memslot" testcase
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly clobber the guest IDT in the "delete memslot" test, which
expects the deleted memslot to result in either a KVM emulation error, or
a triple fault shutdown.  A future change to the core selftests library
will configuring the guest IDT and exception handlers by default, i.e.
will install a guest #PF handler and put the guest into an infinite #NPF
loop (the guest hits a !PRESENT SPTE when trying to vector a #PF, and KVM
reinjects the #PF without fixing the #NPF, because there is no memslot).

Note, it's not clear whether or not KVM's behavior is reasonable in this
case, e.g. arguably KVM should try (and fail) to emulate in response to
the #NPF.  But barring a goofy/broken userspace, this scenario will likely
never happen in practice.  Punt the KVM investigation to the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 06b43ed23580..9b814ea16eb4 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -221,8 +221,20 @@ static void test_move_memory_region(void)
 
 static void guest_code_delete_memory_region(void)
 {
+	struct desc_ptr idt;
 	uint64_t val;
 
+	/*
+	 * Clobber the IDT so that a #PF due to the memory region being deleted
+	 * escalates to triple-fault shutdown.  Because the memory region is
+	 * deleted, there will be no valid mappings.  As a result, KVM will
+	 * repeatedly intercepts the state-2 page fault that occurs when trying
+	 * to vector the guest's #PF.  I.e. trying to actually handle the #PF
+	 * in the guest will never succeed, and so isn't an option.
+	 */
+	memset(&idt, 0, sizeof(idt));
+	__asm__ __volatile__("lidt %0" :: "m"(idt));
+
 	GUEST_SYNC(0);
 
 	/* Spin until the memory region is deleted. */
-- 
2.44.0.291.gc1ea87d7ee-goog

