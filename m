Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1284A8FD6
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366027; cv=none; b=SOZACdIM5zzXjjjVUdJtsSPBcqwe+Ihien6hLH6gZrzbL1slQg3OzRvOiCiFjCBvwWE+ltLo+Y1gvCFDOIThb2ETLC5tcA9uxeA/lMYmDlWCdRwbVl9efvnrmIyQr2xIdIkt7ehw8UGXUx9v/r+jbWuy4BU0ecFj4Byg8+wzHa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366027; c=relaxed/simple;
	bh=kirF1Z6H1us8C+w/nRlLFHvxONxvS/UzEcyYUHsaSLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p4ghqo90cYDYJ1+85PYL/4Bg8qJn6bMmud7x8l8qx/iKTtkXfMOXKvI0sdDuUJuU5q12JD5Q6T5BMhncrJDEVECB6SPm85ASLxd/iYgnPvMcgT61WI17oILpTG+pHcPxhIag/ebzb+Lf7fJ2mIumpA2Qs5GCZars4UtUz2DBOec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ARPNrDeC; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ARPNrDeC"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso1306731a12.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788366024; x=1788970824; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nmUHQDRJovGy5euybNv8U4I384UlmmpWUQBP5c7RHzY=;
        b=ARPNrDeCBREIuNfQDUJGnf23Eblk4mg15+ogZ1rgSAAIwnn6bQQzNiZGPqxBrMxzVi
         glRm0YIx1wdyc91d6paHaE9ABu702T9lro6aO9PlQE/jAsYr7EWkNmN050PDURoEa3s5
         2p4mz0rFhDHmAIK4DkjBIfUNBO6kGPXiBKZJGspKTMazHUdL4UJ/dsSh3qqxOJZx7sgw
         aI4chglY6+cGFi2XhPilJxi4Hq+rkyXyir4noNjwPttqoeH79HVAVrTSl5fJnQ2+/x0d
         Cg+Q0G4Da9gPq9AiCBQ3Kolfk+I+UFpFD2SmRnuy7XH/RaPU7NVhqMVemfmzBq+mhIXn
         3aiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788366024; x=1788970824;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nmUHQDRJovGy5euybNv8U4I384UlmmpWUQBP5c7RHzY=;
        b=MWKGxaessXK0uR159YKfFuqfkHGNuDYE8FpVoKYa+iLT+DChPed7cPVaXCOD1IPWIL
         +gX1l+QAakB73e4wO6CGblVkddL4WsVZnE9VM/Vdmk0MsrTCmXT3Cgab7L/NTKWy3lqm
         J/ue8Oh9A95k3VLVCpoLcJsx9iJTz7/gszk6sJIRAi46W+m+0w8qyiXJoJ0y6989hJaq
         VhHTivXTMPx1KhT5LggHcKkJU0OBCuDO+7lTEjIo0Yi1GYg7xj3VD4vkUIF4pVpN/L6+
         6Hi3K3Gr2IhFbHUF0sfUBGHNUPupKY3ASK+msUiA8xQ7p2+AV8rM1vxpb4Qa06s5wkMN
         dl9w==
X-Forwarded-Encrypted: i=1; AHgh+Rrc3dsHk1QRJ48wXQoqyCtaTwF3HzoS2hSakZsoyUcw3RbfbCKcpa7iH9WQ0tVf/18IOsbK9dU=@lists.linux.dev
X-Gm-Message-State: AFuF++mMW53aNTXz/61KzoIGpJazATQnbEiRQHMYuJtQE5f18yCa27LB
	OAoF/vtcZ2Mb3nTatjqXfy1ZpM+ZXMu/Wne8LaZOxVYRkgUCjqHXlM0Pcq78sSRgiDHCr0wzgpA
	XIptOLA==
X-Received: from pgp27-n1.prod.google.com ([2002:a05:6a02:62db:10b0:cbe:e120:3788])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d22:b0:3d3:aec2:4dcb
 with SMTP id adf61e73a8af0-3d9b051aa7dmr10390341637.23.1788366023624; Wed, 02
 Sep 2026 09:20:23 -0700 (PDT)
Date: Wed, 2 Sep 2026 09:20:23 -0700
In-Reply-To: <20260831144802.834315-24-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-24-seiden@linux.ibm.com>
Message-ID: <aphMx5hsoXwIpNjt@google.com>
Subject: Re: [PATCH v7 23/23] KVM: s390: arm64: Add KVM_S390_ARM64 Kconfig and Makefile
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 31, 2026, Steffen Eiden wrote:
> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index 8d3ee17a1bcb..9c69ea16031e 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -53,4 +53,33 @@ config KVM_S390_UCONTROL
>  
>  	  If unsure, say N.
>  
> +config KVM_S390_ARM64
> +	def_tristate y
> +	prompt "KVM support for hardware accelerated arm64 guests"
> +	depends on HAS_IOMEM
> +	depends on KVM

Is this actually necessary?  I.e. does kvm.ko need to be *loaded* in order for
kvm-arm64.ko to be loaded?

If kvm-arm64.ko does indeed have a hard dependency on kvm.ko, then I think it
makes sense to not have redundant "select" statements below.  As an outsider,
it's super confusing because the KVM_S390_ARM64 are incomplete, e.g. are lacking
things like VIRT_XFER_TO_GUEST_WORK (at least, I assume those are lacking), and
makes it hard to see what is actually unique to kvm-arm64.ko.

If kvm-arm64.ko doesn't have a dependency on kvm.ko, e.g. to initialize hardware
or something, then this "depends on" should go away.
