Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3B6FC6
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716987262; cv=none; b=RdqLupSdwjkVv9wC30ydw3WDdrqw3IrgZxdOsb4ymg3MC1m4gmOrRaCFlJpb9pSZzaC8BU2sfGoO9RWotcQ5VwRK/HYcuyyb1ndvIv7ZAKnlEHzW8d4MZkzdh4i0v0YWGTlnztN5GtXQWF3ebpt6bG6U4/eMSuizNnSQB1Yu/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716987262; c=relaxed/simple;
	bh=7C3Ln9w/sSUWPP+BUdVx+PL58R8HTzOVmDKg36W3xec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DBZhJKTGfV5SruF/UbusO4sXB7CC00tN2hbmHsD21y36zJ0QEvNV1ORsqIq22fBmKI01GSEDfMMKv/WGwXdp4wq18a2vMJ6wMSZ8vs7V/vuY0wjpyEKQdJhnb2YiqDzIiC7h9d8bhZ/ouHK4BbvfYlMHuDVCt9p9SFwXV065A9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=27KaI3Ub; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="27KaI3Ub"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6819fd023b9so2194784a12.3
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716987260; x=1717592060; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1KVQFhVFh80Fdd96OAcePaAYKBvjrIO3JB8q5MbeFQU=;
        b=27KaI3UbOfCoRhke1cY9+3lF+pC9jfVNcr2V0hD7p3n3lTheNBn5QXNWxog9ZUxnLb
         Rcu0E0+5bvDtDM/RFrSOTPcPIaravgjkiqKYwc1mpB4+9jZFMC9K2u5CFcqrE4B/PWGv
         6MyjPQfi8gSkMOrfau1PgcZJZlmvuhtXuuKaCZuiykAQ5G4WNgB7eGjhFZvRyij9H87j
         58kOtnbfiXjHirahLWVhNrQ7KmxwbffLgp4mhNN3MPBkwdp5QLmgy37J78hnnOSfv4p9
         XxTn7DV4bbDKYHuP80du6ha9SbBhOc4V0qPTfRHxQNa1H1XkdBUpslNdVIyL+yg5QSgh
         c65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716987260; x=1717592060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1KVQFhVFh80Fdd96OAcePaAYKBvjrIO3JB8q5MbeFQU=;
        b=obssnpNDpL9ScJ4chqyC38fTVQ7qhTTA+CV0MPrRYKw7iR+UK0EZt0eg7lSz0urypA
         gx65S+LJreGPSTGNpmtewcrTuCXATQ3CZVDvF4lBs088T9c+sQibPT+GwFzsg50yKEt8
         V427ZCJ/a/N5h8i/csOoi7lHZ9cKfKQ72eMt5tzxvHDvpRv6syyagHZp46QNuNx7OVfw
         aROKhQyB9PRPI6kBQFuGEhX8AVBWz93wZdJTH1Y8VmciuEwD+6S5Bm51lOEEhGBd/K4i
         3T81QdNMCtD60nsMXupDmFxAKuGwxcxK2lAJhba5ZG1WDvUpdv3F3VvNit6vesngVhK7
         qGww==
X-Forwarded-Encrypted: i=1; AJvYcCV5eJ8O5Kcj09aPB23er/Xyb4nGYxz52WMuaONqwkSBLZhZxieiZ5sj8eCByplxIUM6bPzGwAuQZxVK3iIM4d2jz6BfJwAW
X-Gm-Message-State: AOJu0YwY+hKIgWJHpidpdl5MBropXVSjAAzuAPC0c76IB7Z1LkAhol3D
	UUOnu3vkr6NyrAhkRi+IYWSJvaDRj+/fhsWpnaQB+YrbSu6Z47aSUhFwBhK7FXW7fkUS20FQC/a
	SVg==
X-Google-Smtp-Source: AGHT+IHBbZP8iE9LJoz88cSwyGPtf4IYoLcqAZBm04Syis1dHtNGwvMpLLvLxNB1S+GJVlzsrbdgQQ4xG0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1421:0:b0:680:1ce8:ba9a with SMTP id
 41be03b00d2f7-681aea7d0ecmr40830a12.11.1716987260030; Wed, 29 May 2024
 05:54:20 -0700 (PDT)
Date: Wed, 29 May 2024 05:54:18 -0700
In-Reply-To: <2a221116a03f57dca8274b6bc2da7541b21d86bb.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com> <20240522014013.1672962-4-seanjc@google.com>
 <c77f3931-31b2-4695-bd74-c69cba9b96c1@intel.com> <ZlYte16cvQpPGHkx@google.com>
 <2a221116a03f57dca8274b6bc2da7541b21d86bb.camel@intel.com>
Message-ID: <ZlclevRvntUMYG6O@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"maz@kernel.org" <maz@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 29, 2024, Kai Huang wrote:
> I am not familiar with SVM, but it seems the relevant parts are:
> 
> 	control->pause_filter_count;
> 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> 
> And it seems they are directly related to programming the hardware, i.e.,
> they got automatically loaded to hardware during VMRUN.

"control" is the control area of the VMCB, i.e. the above pause_filter_count is
equivalent to a VMCS field.

> They need to be updated in the SVM specific code when @ple_window_dirty is
> true in the relevant code path.
> 
> Anyway, even it is feasible and worth to do, we should do in a separate
> patchset.

Ya.
