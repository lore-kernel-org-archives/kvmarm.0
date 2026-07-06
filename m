Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C50A3F7A82
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 21:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783372378; cv=none; b=lJze+MgTJjhMslpT7SJ9LWPUjTXsejEme8pHr4KwJWwtPGOxGz+xdjOZG5a9jtCUDwUeQNWNvnllJa0HrZ5hP5f9eNQcsVpjttqHLVRkGsL94vI3mF4iL52N8CEiQaJBFNmF0Yzsj90gTYiymwqK5BBfVALd1r1rk1kAY5S4fA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783372378; c=relaxed/simple;
	bh=pmu2Ns+u7j3MrvpRzE4vBrZuDK2pA+O79byFKdV4S24=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a9kWnp5mvmRYgPY2fjKs3h6GXIaVcK9Glfl+6Z3gyjyoO0t2GRJeuNxqChpIBW98eJjYZHXgTWT3aaFrSCGx7XRouDEkMjxORUl9QBxkvbw8oB5VNKThqo9kmrjwFTS/kLB0Gz1ESXkEe3zgnzGfKv0bMjnmKrag2jpuYJzQ8y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XuapbNOS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XuapbNOS"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8894570b58so2435680a12.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 14:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783372376; x=1783977176; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7eGtWkkyAP+CX1fJ/+ZRWJr9u4Vfu7xwsEfOdR5rCGU=;
        b=XuapbNOSLJNcz1dT5AkYjAP+fcA74DnowgYs1JnSRf7XvDufl8ebDDo2UK3g/TiexG
         Ui0gG1/ntwEHFt6Ekjca/cl6X9+wQ3Ksj/iLNsoorN1WpGHc9F0jWTlQ1s6ugNSgBeWR
         1gfUGaTFPBZhRIz8V37D0OmHu1Hi5OLjF5KCOX2z0pmmQj73KLEFRnaet3UeWVXbMISm
         2fKCePye+45A1Us4YPlz8tig6Ir043x03UBxyEijeaxLcH0R5UEk3JAp5VRkLKhXWXdX
         dvvyR7etPgHgrJM6ubTGCDy2LpiE/SOIArBDDa1PCznQqhaLeQxZyrN1yVd+S5SH0zE7
         69jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783372376; x=1783977176;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7eGtWkkyAP+CX1fJ/+ZRWJr9u4Vfu7xwsEfOdR5rCGU=;
        b=fRgnA2xpvvA9kRQWG0FZkIg+sYJxCzDVl3gl+nHraixLraDhfUNjwrtSFjoue+fiF3
         4QK/fZiYbYXa3BHdKKZ+YQuMMqrk9EN7dK/B8oTALMzof7EaByIsNxWzod8vM+9ho7QK
         xN1AcfzU/mvYICAeaiyGjAJeA1Y0w31a/i3G0cgS0DDAXMVcTh0z3N1i3ERYPSMK952s
         Taw/65GvfE6vP9qq/7VU4z1B0Ry2RVbWIW+3gQ3kzBSw0/n/nH6RWumE/3VtxOEu+91W
         7pKSrhogp/tnGwWfL8k8z8rNrIF8K+tZNFyewbzCo1wBaEyEosbtqUlOXJ+jOguF20Ei
         UA2g==
X-Forwarded-Encrypted: i=1; AHgh+Rq48lkoodhfovhdGy+Ju9opMqGjv3CtIxXmIJgVQVG1SE34whY7k4Hhlt7EtrcMBqykx4MZmSI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjiq5oTC8u19fKgJL5OBXMkFz+AuspujlwM5cXSCYEHluWemYX
	2Pwd8PshJ01fGqYZARXwc2K6oawlZVFiZqVDvxet8PASNVagkvDy8k9tnOQiw7lRhUhJzfpD7lv
	py8Ei5A==
X-Received: from plth5.prod.google.com ([2002:a17:902:7045:b0:2c8:903:9ae7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19cf:b0:2ca:bf8e:35fe
 with SMTP id d9443c01a7336-2ccbe611af8mr26055545ad.16.1783372375629; Mon, 06
 Jul 2026 14:12:55 -0700 (PDT)
Date: Mon, 6 Jul 2026 14:12:55 -0700
In-Reply-To: <20260706195313.GE118978@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706085229.979525-1-seiden@linux.ibm.com> <20260706085229.979525-2-seiden@linux.ibm.com>
 <20260706195313.GE118978@ziepe.ca>
Message-ID: <akwaVzghHzi8o8fK@google.com>
Subject: Re: [PATCH v4 01/27] VFIO: take reference to the KVM module
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Gautam Gala <ggala@linux.ibm.com>, 
	Hariharan Mari <hari55@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Hendrik Brueckner <brueckner@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 06, 2026, Jason Gunthorpe wrote:
> On Mon, Jul 06, 2026 at 10:52:01AM +0200, Steffen Eiden wrote:
> > From: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > VFIO is implicitly taking a reference to the KVM module between
> > vfio_device_get_kvm_safe and vfio_device_put_kvm, thanks to
> > symbol_get and symbol_put.
> 
> I thought we weren't doing this approach? Use the struct file as the
> kvm handle. I thought I saw patches doing that already?

+1, my joking-but-serious NAK stands.

https://lore.kernel.org/all/adf29Rn7q9Db0hxc@google.com
