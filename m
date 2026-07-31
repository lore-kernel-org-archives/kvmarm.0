Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565C144BC9A
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514561; cv=none; b=R/6QKvnle99473fiWhQFX7w6gPieRw8PWEMfDGSHkqVQ5FesOfxkP1CMWBG9DyVfXlbZHqbpww7xBcBHGrLlPVKWQJx123yXRiXKcY9MMuSCGifoLXUDLpLSHxAN6oqZ5DUJENcHeStOHyc575j/N4gFP6ehNT6M0+7bRQnQqsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514561; c=relaxed/simple;
	bh=/6OQz+DQUsZXcPRJ4R2zsd2kat4n8VozoJNKylE8h7k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKAiNC7M2Ef1SdbrE0OgDxd9YB9B/NSIRPPz2pMEHtyW0V/ltfskJX6ifxpYDWrKFv09m4y61KNFLOfR7X7t85kvPlyaXzpBh9THwqAnKJKz6UN9eT53FisdLyRS1hQZNhQJgPoV4itvETai5fJABx89LfO55ag+Zg2i/DABt8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQu/+g0Y; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQu/+g0Y"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cee894b3d8so20480655ad.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 09:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785514552; x=1786119352; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ytOyVvVUp1+iOjUCBAJJ+Zr5Yli10sJrrWCx9PaxhI=;
        b=JQu/+g0YYZFOc8E+7c4qYLtTr2PNP+T1VD1vNi/wz9U9FLshz8v1rxXjm8PNlxuv8M
         a8bXcCrEVZv3WXrnZ0GwRoy+EgU2YkxdvGX2CvKZsM6EMlmaZajh1IANpBMKZSez/kH2
         XrxQQYAShEianRF3AgwUA937vu9t7Ji7CPGzMvXoNinEsuTuaQp9vA6nPFmYrLSt6zx2
         uX1rvKm15zI8+2jCjTiZ0soXGIYwIV6GhgeslKOtIaCg41p2bQWMbMpxvZ4lL2bf3kzv
         rs34ZMdmpHwfAQbtXrSH7ycTQsiXU/lqGV/rgpqo8JKFAfIhDOYeHF5bpHgcKAqnEJDS
         JVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514552; x=1786119352;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ytOyVvVUp1+iOjUCBAJJ+Zr5Yli10sJrrWCx9PaxhI=;
        b=AU0KiWaRoIvbiProgFsYZhMnfnGEGiuK3L/jCgc8qNgfFgyPtxJV5aObBBisNk0zjU
         g+NsV0SCdwaC2VO/TzuROBNG3TxcoYNHWJ6NNMLo2Tzr7V1fIdZ4vUdWHHMGy65N1WPr
         NTjU4Bg8VT1o9l0b1APvMC3smxCK9mySaZNTzDcAvans61avl/WI7vDvbF4iyj16s7pp
         7Y9oSHRbFQSo2mIDb+mpVXIyEbV3SppXxJSYmnCPxKh0191AMhWSHrZZH1KSbAtt/84/
         U2qFJ77/YK4f/XSZ72TUdP/TqZ62yD/tFcK06Kabq1bx8sfZrlKNUgsLyIE8G6TXOGtn
         AcUw==
X-Forwarded-Encrypted: i=1; AHgh+RqEeNECCd1j7mYgQFhJi0YUHbu7INfIMOjA4u7I4+TSh58dcTmAZA+/EvIVlckCM7GkFLbB+es=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxji5TZO7NByKEb82l9ftQU9kh+eDkCm5dkopW9IFJ61mTJfwbo
	qdAF49T8kZLGsakk5pKGFs7LxcTAwEiIFCNngHkNq4T5Pw0KXOil3WDqbGbwXkvbuKnQiAWCMzF
	HMZHFgQ==
X-Received: from plbjg5.prod.google.com ([2002:a17:903:26c5:b0:2d0:40fa:a53d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2410:b0:2d0:4021:bb62
 with SMTP id d9443c01a7336-2d0521bcc4dmr5824855ad.16.1785514552447; Fri, 31
 Jul 2026 09:15:52 -0700 (PDT)
Date: Fri, 31 Jul 2026 09:15:51 -0700
In-Reply-To: <20260731145435.1016137-B-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731130902.654679-1-seiden@linux.ibm.com> <20260731130902.654679-2-seiden@linux.ibm.com>
 <20260731145435.1016137-B-seiden@linux.ibm.com>
Message-ID: <amzKNzYWD1ngXdOZ@google.com>
Subject: Re: [PATCH v5 01/31] vfio: Use file-based reference counting for KVM
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

On Fri, Jul 31, 2026, Steffen Eiden wrote:
> On Fri, Jul 31, 2026 at 03:08:29PM +0200, Steffen Eiden wrote:
> > Replace manual module reference counting with file-based reference
> > counting for KVM integration. Previously, VFIO used symbol_get() to
> > obtain function pointers for kvm_get_kvm_safe() and kvm_put_kvm(),
> > then manually tracked module references through these symbols. This
> > approach required storing the put_kvm function pointer in each device
> > and carefully managing symbol references.
> > 
> > Pass struct file pointers instead of struct kvm pointers throughout the
> > VFIO-KVM interface. This leverages the kernel's existing file reference
> > counting mechanism via get_file_active() and fput(), eliminating the
> > need for manual module reference tracking. The file->private_data field
> > provides access to the underlying struct kvm when needed.
> > 
> > This simplifies the code and removes all remaining externally exported
> > symbols for KVM, paving the path for a second concurrent KVM module.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> > ---
> >  arch/x86/include/asm/kvm_page_track.h |  8 ++---
> >  arch/x86/kvm/Makefile                 |  3 --
> >  arch/x86/kvm/mmu/page_track.c         | 16 +++++----
> >  drivers/s390/crypto/vfio_ap_ops.c     | 24 ++++++++++---
> >  drivers/vfio/group.c                  |  2 +-
> >  drivers/vfio/pci/vfio_pci_zdev.c      |  7 +++-
> >  drivers/vfio/vfio.h                   | 10 +++---
> >  drivers/vfio/vfio_main.c              | 49 ++++++---------------------
> >  include/linux/kvm_host.h              |  2 ++
> >  include/linux/vfio.h                  |  4 +--
> >  virt/kvm/kvm_main.c                   | 23 ++++++++++---
> >  virt/kvm/vfio.c                       |  8 ++---
> >  12 files changed, 81 insertions(+), 75 deletions(-)
> 
> @sean: This is based on your draft in https://lore.kernel.org/all/adkFk3ZN4HJtpLA3@google.com/
> do you want another/more attribution? 

No preference.  Do whatever feels right to you, you'll know better than me how
much of the final code came from me.  If you want to give me a Co-developed-by,
here's my:

  Signed-off-by: Sean Christopherson <seanjc@google.com>
