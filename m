Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580567FBC7
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320393; cv=none; b=l9PFPTAkcpROHn/YXAlwLcCcjLQIxaZI0zFYOgEf5Vb7jAJNKF8OrcQfEpXY6UWAJJ3ijyE98zVQ4Jc3BqZ4fR2JE6Nb5IsJZxajnIwZ6xm3baZPIIphcXpB5DVRe5o2lO13pnQWLdXBHwl2xwhMOHSk8bGckObsAb+xyG54Wa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320393; c=relaxed/simple;
	bh=LjkaP/58PtU/mEZcOrW3Z6nQNBjxZ1mblfqFHWtphoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SDN5RFOpGnpuJoajBy+gYo5NHSBpze/5+RGq+Po5RUeHtpssSQX5gZ9WW2UCtk0N2fljRz4G2pbi2x4mGV2h0VokKzE+pU4Jc9I7kA0WjkcfumZqix1t90ZMmgQqlwQQ1/bbMfuzuwddgSlNMqmoNw+xrBw6WQsKYOZp+ywfCOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=osyJDv0n; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="osyJDv0n"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e04e1ac09fso676223b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 07:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707320391; x=1707925191; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MP00cAF+lbB1IB+JNFIWr/0G3/2k6U4WEvUSE+Ofg6A=;
        b=osyJDv0nOWxsbXF9hGCjj/eoXOvBaaNiQTEBELBSzG8T8Tiwf+cZJ3ZXeAJEAUis8c
         /aNbDa0oFsEJRzzBIHiCZNYPdNdXOvME9BbhTYMM3B3YpnniFMM6+Tvo0qVg+x950wjB
         rRYXE/AUJ37eFFVKqStScHwh3lUhUp+uYWhkO7tTZ616iEKpi95dMWH+qxdhofT/kNwr
         M1TIvohFPicWIMkgZMWKWkiShFz9lmURxqXNaPmN4vgfLQAAa4CeOgQjTDjfBUPV6FQn
         TgnBahJjuJLmHa9nyivO1FljSLKaXDTotj9LUv8wcZewSi/uVof3SkxAMwEs1R9lgfnF
         7RKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320391; x=1707925191;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MP00cAF+lbB1IB+JNFIWr/0G3/2k6U4WEvUSE+Ofg6A=;
        b=UDDv3C8KsS9fPFw+AgVM8+Sz4I03Qvk3cGe5YcgrOQh64R85F3mvysXFBMFp3ByteS
         QKCVLeFXfvoRE4nySX1434qhhzhuTiuxHuuvpl+9NwVE0X+8yh948fT89fgcVxf3f+yc
         Bi+XGgW62tyutYZIp2/gBQ30hLsfFgScokoM8EU7fML64auMSnbgFW2C0EUGo6fCbEYq
         jYnCcBszurkuKwVAWUFoY3BV3JpiguR3MUMkuD/I7Ghlrv7JeHxkh6lsBU+iDOrz/wfb
         FSq2f14OOfwv5zfRY+5aOarU0rbe6hOQKUTiHuaK8d7ZN1qrfTCt46GVgmGckWmuTDAK
         n5/g==
X-Forwarded-Encrypted: i=1; AJvYcCXeRiEORld+Evs37vy86fga7BIFX0WVYj8HaU0uufNcfjlTwhJVE5JdSidtedNOFJPv2M32BJ+6Ngpxx6tG8VEoaZ2QkyZO
X-Gm-Message-State: AOJu0YyuAA85bL1BO1uVFpWPjgE+qXgmNTHJNMxqHLvwki6JOaTCnToh
	vE36baD0UOVnQB8Q8jDWpcD+htUOIuZirzlJ8VgalQj6YE4gmak2tAv8CjbdDbHIJtt/4j4QARf
	dUQ==
X-Google-Smtp-Source: AGHT+IEKNwD2x3BYf0hQrUmS/ECtCacMU0Y3UBFT7748g6QN/uYN0uZ9PIOGPsjg4lSmnGcbPb5fP5hZQAg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:84f:b0:6df:e757:cd56 with SMTP id
 q15-20020a056a00084f00b006dfe757cd56mr180478pfk.2.1707320391651; Wed, 07 Feb
 2024 07:39:51 -0800 (PST)
Date: Wed, 7 Feb 2024 07:39:50 -0800
In-Reply-To: <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
Message-ID: <ZcOkRoQn7Q-GcQ_s@google.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com=
> wrote:
> >
> > TODO: Changelog -- and possibly just merge into the "god" arm commit?
>=20
> *Facepalm*
>=20
> Well as you can tell, I wasn't sure if there was anything to actually
> put in the long-form log. Lmk if you have suggestions

I think the right way to organize things is to have this chunk:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b1e5e42bdeb4..bc978260d2be 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3309,6 +3309,10 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fa
                return RET_PF_RETRY;
        }

+       WARN_ON_ONCE(fault->goal_level !=3D PG_LEVEL_4K);
+
+       kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(fault->gfn), PAGE_SI=
ZE,
+                                     fault->write, fault->exec, fault->is_=
private);
        return -EFAULT;
 }


be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY_FAULT=
_INFO
is a lie.  Userspace can't catch KVM in the lie, but that doesn't make it r=
ight.

That should in turn make it easier to write a useful changelog.
