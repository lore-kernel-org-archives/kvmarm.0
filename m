Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC48212D2F
	for <kvmarm@lists.linux.dev>; Thu,  7 Nov 2024 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731002156; cv=none; b=HSYXrhqVbBEn/660z64hDggohhYJT2nyr9vxdMOLF8+nUXR0PKjnnDzUmqY+HeaHGrHSvyIyc8X3t+GRPCLSsHg6jgQsCYuehvKg5DHDSZ9C3tljU1yjPHALhmoawb3R+CPoz5jU69rJvSEX+991ZuEdBC5Y6Gb/PM/JcvM25Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731002156; c=relaxed/simple;
	bh=2s4A8gKTdQZhphe0yJhrlb5JiI83cOaCyhsF5E0G8Yc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q4TAhqwLskVeUWJEzthuuZBYrYYvy1vFNvdGyxivAFyR1F0PAyUMEB39MzBIOAR2w+3BFTMlzUzIuqNia5YXU3R6y3tA7iU/xNIdfR/jusHqNGWuDrqRzUXJjTtzPJbh4N6CM9QoNwRDrITGwswQJ/2NbHqoZ8l1grfg3aeGLKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Em99KYQz; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Em99KYQz"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30df8dbfd4so2567851276.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Nov 2024 09:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731002154; x=1731606954; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgKJYCEI2CSDb/xLh6X/UMs+jy9ls5WzdJWZNluUnjQ=;
        b=Em99KYQz2lD1aJeV1SEM8vN09+dDkHmsYLqp6lAGsIVrCXttAd0oEV9pv5hgr7R2qL
         Qjg9HqcMrXW/Wd6+hva1knIOO0fp4t1wEjKOEKhtzHHWQn4RBpO6p58Im9wVrHz1D6Gi
         pZDpEJYB+88B8HNZG/J9r91nbhC4hoLtRYWL9jk0pwLwebj1ErJkR+jQY+tDQxbqzSzS
         eIJU3S5O0fdH6HTqOSLZmicqlp9XYhYX0wsGOlQOfBy7hpIQGCP+C6hCkx9NpxHVtwch
         b0M7FxDkrFu+qNm0kIUfzMRdFMvAayKqrQZNpmSgHP4SZCgOJ6cWTFHp/5CwA1X6KTgw
         JAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731002154; x=1731606954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgKJYCEI2CSDb/xLh6X/UMs+jy9ls5WzdJWZNluUnjQ=;
        b=AyXUa/Su/+OBQVgOLVjRefyMxoHwJP4M5vW1Qpc5e55iGo647z9zXpv1PjUaEZs00b
         ijH66mnNNaa71UAk6BA5CN3kzUynC4MieQGxfFiU4llvP0mdoFPZ6yHiNukY7swesPOW
         pUORi9lIFJ3x5cwLW8xwA3LC9qr353qWiD5lLCKclJNsKvRApxSouLD4Fo7wg4xld3yq
         YHllpVr1hfbjX799Zabv/hoTOgJbDgg20PdFBblMIkBd2ASZEmXPfV3lBmdWyVmBKtJn
         6GWcrGxa4sSwuT9ciPfSkNU3GGo+obBPgMKWSRmewEaK3sNwJli5IK5hQ2fMDseMGMJh
         ipzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1pg+Y6JtY4poQCr9CTm0f9C6DU0YH8zs8MLG0b59zZldqr1V1mV8sVS2tZ8Qg1lk+2N07G50=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmQ4xVtTr1CJWmjVAQVDsmOy9wBF8SCoIvQ1Vyrit7U4DufCDC
	qWidlgAmKjoRg64w5mAziRE0r1aV2y7nx0eU1AZuib0WR9yRxDtAr2hp0IFvpUS+GKGeoKlw1uu
	JvA==
X-Google-Smtp-Source: AGHT+IFvhTHMuMFI9mT31McwxfLIdUC6ciPwdbQZ4NP2mqW4X0p7NR7s1YxE8I5RlOmEFOSOgJ08jSvYgEg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c347:0:b0:e30:d61e:b110 with SMTP id
 3f1490d57ef6-e337e429bb0mr369276.5.1731002154247; Thu, 07 Nov 2024 09:55:54
 -0800 (PST)
Date: Thu, 7 Nov 2024 09:55:52 -0800
In-Reply-To: <20241107094000.70705-3-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241107094000.70705-1-eric.auger@redhat.com> <20241107094000.70705-3-eric.auger@redhat.com>
Message-ID: <Zyz_KGtoXt0gnMM8@google.com>
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
From: Sean Christopherson <seanjc@google.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, broonie@kernel.org, maz@kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, joey.gouly@arm.com, 
	oliver.upton@linux.dev, shuah@kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Eric Auger wrote:
> In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> KVM ioctls will fail and cause test failure. This now happens
> with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> add a new kvm_vm_dead_free() helper that does all the deallocation
> besides the KVM_SET_USER_MEMORY_REGION2 ioctl.

Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
a more helpful error message, it is most definitely not intended to be an "official"
way to detect and react to the VM being dead.

IMO, tests that intentionally result in a dead VM should assert that subsequent
VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
resources adds complexity and pollutes the core selftests APIs, with very little
benefit.

Marking a VM dead should be a _very_ rare event; it's not something that I think
we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
where KVM needs to prever accessing the source VM to protect the host.  IMO, the
vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
enter_smm() case can't synthesize a triple fault.

If memory utilization is a concern for the vgic_init test (which seems unlikely),
I would much rather solve that problem by expanding KVM selftests support for the
selftests harness so that each testcase runs as a child process.

https://lore.kernel.org/all/ZjUwqEXPA5QVItyX@google.com
