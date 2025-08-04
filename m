Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7E325A2D8
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309870; cv=none; b=b844/QJY35xDJtBXm4U8+2H8sQETeQ8zT5WOl0cGofgbR7r5FoRkKnB3wredi3NV7pVzemxySttss3eqtlPC4hOQlryOdKhAPHruTWvdq9GdrQiRxi0oVhip1+p6p0UinZHJM2Mp57rLbYqQnTy5boNam+GsbiGAYKa4w8hPAII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309870; c=relaxed/simple;
	bh=0RuV7veSWYBDxktIBx0KFjRyZwHxx1FH2GA6DveO/jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzCHcBL+LQF4up34og/Xof/XhoFlhKNK62Ga/4Km7GXb5OTCq1JhVlhTXyhFJImDtGkj4/NzbRnP5sq44UkReyDqap4pb0QHul7VEVutTYtYDoauzQgFf4C47aRWQLoke7NneocdoCebUSMtswBZgMq7nzfjaXPtmWRhz5FZw9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=J+len6zn; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="J+len6zn"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76bc55f6612so3659808b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Aug 2025 05:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1754309865; x=1754914665; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ktd0JN0bhMpCqOyvDaN3st69xiJStXvUJcRQtdXWfaU=;
        b=J+len6znBQ+Dc2saePPi/LIv5A9RuN7o46WD/ceHh2bmwGUWekPG6LF4t2XkG26RIt
         m75rlGSYzOYa/azRseqKnU6mocLNF+oxkWvjnj5gETjZ/yASl9ZQx1+J3z8/CXEvtv+D
         lbK3VOwt7Rjgh8WYDUWqLOFA5RhnctE7i73NxRmTDlgf8C+Q4zxw2XGcKXSFOXG2CNg7
         YgmmEel6KN0pe02ydJBRDHgq5StklQpBolefR4SCUR7xR36rUz2z7deM1joHKC2p2+EQ
         ULq2JjBiB+SJaYUbCkjs+fgNJfTGl7Raec5LgB0oVqqe8cNb2bvfjt6NHs55cHSjMyZ9
         39mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309865; x=1754914665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktd0JN0bhMpCqOyvDaN3st69xiJStXvUJcRQtdXWfaU=;
        b=eLVHhwxHg4ITaJeiss3Hmm6tTPPcV/zuASh5GZmmA0RadttTtWW4VHaB729l5Tgdtg
         rPdVf5Qv6TNAAkDaMjAc7NU4z61w0Gl9WJPQdr8AWa4uUdLpVoCJJaWew7SO8B92WH9G
         YSZaT6TYnU8leJgUGEHDqSZfLE1yszsffNhsZLiSmhlf2myT9cXxKy1TRqiQ0T/66LTu
         lcxFQbIY96gW4z9qhPSQSFXVOnNgMhHuJ505YwwDAwrlgLlmq5mZaUyZ2PmU0ls0ET3j
         MqaFAatt5v8ONE0Uq8289+EvB/OWRDQxw8L9pAqosO3/qEza9b3L6lsizi5rnd2Kad/k
         cMSA==
X-Gm-Message-State: AOJu0YwxYmUFmXfKVsesN3TFLMEdLLCAdwFtNfE+IuMHQGEbTx82/aiR
	/vKMDarQFUjU2hDcLc6uX1LErGSHt+wdpAVRPHwSNGaEBG4+hDE0Qmqm0f98P5Ndl5DTbHlRr26
	8h8wlz4/32iwE8vPy3qXjt/9dQCctRCUg7nJ6y7kYpZsLyw7H7ZY=
X-Gm-Gg: ASbGnctQD5flvyEOEzJrhgmoQClJNE0ENg7pZz0gSiIg+2K6AB/CYPGkbG/jVWkXVjU
	B1xkB+ET8rkdC5MpfHjOaWmzAsykfsgaHFhaGpJqoRL+VpiPeEqALfm/SNmOuOBfQHbPI2iViPf
	GUU9omXhZuJwMDu+4DEysIGwPAc6HKDPsz+rjnw92NlTInCv8EIdAzsnnlgd5D3m42ytxHFE8b7
	yi8tnlP6jLDsiPUt/JJ/JAKmbc+VLWJck0s4TYtyp+vswXHHKTPzdksXaLw36AmQ5O6pDyGM/a0
	T1fxzgPKQDwff/FMQiL2y6rq9t5zuglNg6Ybl7hB1O/TvBvapyEzGaF6gC5iR51IDTDOnsCKSH9
	2vD6GWGxZCSEIdtBkHEBIOaPW4pCHeHfbPpk2alXrFK5XnKH2Cqr8Vkbiel7h
X-Google-Smtp-Source: AGHT+IF5p6gKayCUrAAvuWYcfZabjhqxiReCyBd2h1TZV7/HKyAQbFyYs3JUb60Q0quq7V+1kO2U/w==
X-Received: by 2002:a05:6a00:189d:b0:736:4e14:8ec5 with SMTP id d2e1a72fcca58-76beaa83acbmr11450110b3a.11.1754309865033;
        Mon, 04 Aug 2025 05:17:45 -0700 (PDT)
Received: from zenbook (1-162-100-196.dynamic-ip.hinet.net. [1.162.100.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfbd22csm10541915b3a.65.2025.08.04.05.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:17:44 -0700 (PDT)
Date: Mon, 4 Aug 2025 20:20:15 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, mark.rutland@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v1 1/8] KVM: arm64: Rename pkvm.enabled to
 pkvm.is_protected
Message-ID: <574cl7kjaxdpmpthrdkysvsr266o76anmhblrxqgomlfbgeexa@vhsj33febheg>
References: <20250729120014.2799359-1-tabba@google.com>
 <20250729120014.2799359-2-tabba@google.com>
 <szsqsx77mjo4kdawzcboud4eawuvz3sye4grmx5n74qzze26ap@xbfwc44ruetx>
 <CA+EHjTxMoVD=ViS8rC+4oiLojQpobfnxHMBSx7qOLSwU_v_J=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxMoVD=ViS8rC+4oiLojQpobfnxHMBSx7qOLSwU_v_J=g@mail.gmail.com>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Aug 04, 2025 at 08:00:46AM +0100, Fuad Tabba wrote:
> Hi Wei-Lin,
> 
> On Sun, 3 Aug 2025 at 07:09, Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> >
> > Hi Fuad,
> >
> > I am reading some pKVM code and would like to ask for help on some
> > questions to make sure my understanding is correct:
> >
> > While looking at the code I don't see pkvm.enabled, or now
> > pkvm.is_protected really assigned, is pkvm development going to add the
> > ability to let the user pick whether they want to start a protected VM
> > (host EL1 can't access VM memory and registers, mostly) or not (like
> > nVHE mode VMs) in the future?
> >
> > Also, since when running pKVM (kvm-arm.mode=protected) the user can't
> > yet choose the VM to be protected or not, the current state is that all
> > VMs started by pKVM is protected, is that understanding correct?
> >
> > Sorry if I missed anything.
> 
> You're absolutely right. We are in the process of upstreaming pKVM,
> especially support for protected VMs. As you've noticed, upstream code
> doesn't yet support that. This series is meant to help facilitate
> that.
> 
> To get an idea of what we hope to upstream, you could have a look at
> what we have in Android:
> 
> https://android.googlesource.com/kernel/common/+/refs/heads/android16-6.12
> 
> What we have in Android is a new VM type, KVM_VM_TYPE_ARM_PROTECTED,
> that you would set on VM creation (when running in protected mode) to
> designate a VM as protected. That would set is_protected (or enabled)
> to true.
> 
> I hope this helps.

Got it, thank you so much for the explanation!

Thanks,
Wei-Lin Chang

> 
> Cheers,
> /fuad
> 
> >
> > Thanks,
> > Wei-Lin Chang
> >
> > On Tue, Jul 29, 2025 at 01:00:06PM +0100, Fuad Tabba wrote:
> > > The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly named.
> > > Its purpose is to indicate whether a VM is a pKVM protected VM, not
> > > whether the VM itself is enabled or running.
> > >
> > > For a non-protected VM, the VM can be fully active, yet this field would
> > > be false. This ambiguity can lead to incorrect assumptions about the VM's
> > > operational state and makes the code harder to reason about.
> > >
> > > Rename the field to 'is_protected' to make it unambiguous that the flag
> > > tracks the protected status of the VM.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 4 ++--
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 3e41a880b062..55dc7cd83e40 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -252,7 +252,7 @@ struct kvm_protected_vm {
> > >       pkvm_handle_t handle;
> > >       struct kvm_hyp_memcache teardown_mc;
> > >       struct kvm_hyp_memcache stage2_teardown_mc;
> > > -     bool enabled;
> > > +     bool is_protected;
> > >  };
> > >
> > >  struct kvm_mpidr_data {
> > > @@ -1522,7 +1522,7 @@ struct kvm *kvm_arch_alloc_vm(void);
> > >
> > >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > >
> > > -#define kvm_vm_is_protected(kvm)     (is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
> > > +#define kvm_vm_is_protected(kvm)     (is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
> > >
> > >  #define vcpu_is_protected(vcpu)              kvm_vm_is_protected((vcpu)->kvm)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > index 338505cb0171..6198c1d27b5b 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > @@ -406,7 +406,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
> > >       hyp_vm->host_kvm = host_kvm;
> > >       hyp_vm->kvm.created_vcpus = nr_vcpus;
> > >       hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
> > > -     hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
> > > +     hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
> > >       hyp_vm->kvm.arch.flags = 0;
> > >       pkvm_init_features_from_host(hyp_vm, host_kvm);
> > >  }
> > > --
> > > 2.50.1.487.gc89ff58d15-goog
> > >
