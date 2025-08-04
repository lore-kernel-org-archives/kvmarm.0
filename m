Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAB529A2
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 07:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754290886; cv=none; b=VyxczJ9rlQ80BmE0redBR942Ft2+MvHIQkjSPmQziQZTs6xP9JLZD4DvJHzlRVDcRgyqB6bZaVKbHlmZ/WQusyH/WYgnTAGomHlxLYK3JmbyDSJqNvGFQ5RSyu7LkYpl4b7XWk4M++FL72fWkgWG4AzWJHz/3zEykkbtGzgEH1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754290886; c=relaxed/simple;
	bh=vpzFDWHx1vzLUpzzVT1XmrHvTcJ2axEi+eoubCbO0sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hys6k/VoIrdU5UyDagb4oh20w3WkPzAvY24zXMedPaRB/AINAS/LRs/B0I/+6psVb9Jvi11T+WLzPF6Gs/SPifB3dICrCNWYaOY54rvnXUtizFaA3RtaMU2CHIRMY0zLgGgQukfqPuFBjm5Mr5wQS3oahcx/5P3PG6gf2+ApFOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kbu/8vUN; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kbu/8vUN"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b0673b0a7cso278351cf.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Aug 2025 00:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754290884; x=1754895684; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RSHEYJX788VYHRiy4xhCclV7U8sQXRjHeZkuG3AFE8g=;
        b=kbu/8vUN7lM/+2HoArscT+RaEpixSVr91kE1b7zMn55YRXDan3rvolOTz8SxUYzRAs
         Fx7Tp7Z+xlwbT8ucGhmkZtp9+qE2Ubsk52o4g9mKR+0HwbpbrWR7zwV4n62Y2ieS9dZe
         tqBSP9OK5UTQREZX4/Ke3er79Gh3liuona+QKtg0CJqpi6w8xOMsf3UPgzecd6v3BAIU
         JqX+9o/QaQbxy7h/1Nzs9dnmH9dpaNOhVVvVxyJfm6N5UH5zO/pmltV+/ZOJNd9a1NEH
         T6ZFjlq5SwZiWN20TwFFbe/IMO8DM4CZlV1AId0hZ7JetWpUl6o8ZDpWEWon/ouvK6zs
         zltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754290884; x=1754895684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSHEYJX788VYHRiy4xhCclV7U8sQXRjHeZkuG3AFE8g=;
        b=dZkVV6ch9SvecH7Ad69k3o79Eq2B1pd/f//xkQa3fOpX38XCkRcVHqpJCFo0NjHlKb
         m5s+qZ4FmxqIjVOHw5b+W7+tocsoF1MtwTUJ1hXyIMgflGuQKVFEh73PtuK7YNpb8uJ9
         G7SMLUYa3MoIL5OvD5zY6wGhTu0SeKd2snYRYAyeOCfCdQBYvHVrucUeOhoonUV2Wd/Z
         vE9oUjVdlASORTt5skLRTVvg34RQWGtMMl2HewDkoko0e9eNedfGCBKw9iSClcMPIWkV
         45Tv+mS+2L9cIRg3gRaRtuZuA2Q4/CisKre3F5Kly8egXDMxM81IWy8nJeTF90EWyz5M
         /dcw==
X-Gm-Message-State: AOJu0YxAKqmsYUiewAXWU97cZ8DTf4DRvB9h/2bEvxlT4+hxZ1fz3PBe
	nXO2jGLVKnlwqd144AIspy5iUAwAM8tg/kIVuwhVd5ZDKoSqf/WSMLu6uNiHXFywSegyMEpwCfT
	+XykGd86/557VKUlr75wcpmjxQXaMqqct+7Ehx064
X-Gm-Gg: ASbGncv6wUs4b6wNXoV9VzwXscw6o+vuGWRRDQj1+EgA3WBJdR4YKDa55ldXf+uBSA+
	I4yqTCUofWc0l8XmDAsISnuvpjFyn74fdFjFYGzTl+15Wlx0DfukePGpzagdb01WkXHHCevDuGC
	U2//wYQvBTIos9dCoq12uGlHgRAXT5sqKNz3DSghraBwkP5GgWSSz7vwej2ipeFMXWNESIGUb8o
	x7837Lq
X-Google-Smtp-Source: AGHT+IGniHAA7FH+Eqd7YBUZA05anC+yqxu5yiEtg/S9Kxo9mx70xDcmXaV24SioouRxAn4eOORFllugMTauEdotgoE=
X-Received: by 2002:a05:622a:15cb:b0:4af:103d:f71 with SMTP id
 d75a77b69052e-4af12e2b2b0mr9053651cf.2.1754290883220; Mon, 04 Aug 2025
 00:01:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com> <20250729120014.2799359-2-tabba@google.com>
 <szsqsx77mjo4kdawzcboud4eawuvz3sye4grmx5n74qzze26ap@xbfwc44ruetx>
In-Reply-To: <szsqsx77mjo4kdawzcboud4eawuvz3sye4grmx5n74qzze26ap@xbfwc44ruetx>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 4 Aug 2025 08:00:46 +0100
X-Gm-Features: Ac12FXzPxlkyqKTxS6wmipvAxMngDbBJoOhGXmwgi5KEq_pfkUCqwpGRVI4eeuY
Message-ID: <CA+EHjTxMoVD=ViS8rC+4oiLojQpobfnxHMBSx7qOLSwU_v_J=g@mail.gmail.com>
Subject: Re: [PATCH v1 1/8] KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
To: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, mark.rutland@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Wei-Lin,

On Sun, 3 Aug 2025 at 07:09, Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
>
> Hi Fuad,
>
> I am reading some pKVM code and would like to ask for help on some
> questions to make sure my understanding is correct:
>
> While looking at the code I don't see pkvm.enabled, or now
> pkvm.is_protected really assigned, is pkvm development going to add the
> ability to let the user pick whether they want to start a protected VM
> (host EL1 can't access VM memory and registers, mostly) or not (like
> nVHE mode VMs) in the future?
>
> Also, since when running pKVM (kvm-arm.mode=protected) the user can't
> yet choose the VM to be protected or not, the current state is that all
> VMs started by pKVM is protected, is that understanding correct?
>
> Sorry if I missed anything.

You're absolutely right. We are in the process of upstreaming pKVM,
especially support for protected VMs. As you've noticed, upstream code
doesn't yet support that. This series is meant to help facilitate
that.

To get an idea of what we hope to upstream, you could have a look at
what we have in Android:

https://android.googlesource.com/kernel/common/+/refs/heads/android16-6.12

What we have in Android is a new VM type, KVM_VM_TYPE_ARM_PROTECTED,
that you would set on VM creation (when running in protected mode) to
designate a VM as protected. That would set is_protected (or enabled)
to true.

I hope this helps.

Cheers,
/fuad

>
> Thanks,
> Wei-Lin Chang
>
> On Tue, Jul 29, 2025 at 01:00:06PM +0100, Fuad Tabba wrote:
> > The 'pkvm.enabled' field in struct kvm_protected_vm is confusingly named.
> > Its purpose is to indicate whether a VM is a pKVM protected VM, not
> > whether the VM itself is enabled or running.
> >
> > For a non-protected VM, the VM can be fully active, yet this field would
> > be false. This ambiguity can lead to incorrect assumptions about the VM's
> > operational state and makes the code harder to reason about.
> >
> > Rename the field to 'is_protected' to make it unambiguous that the flag
> > tracks the protected status of the VM.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 4 ++--
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 3e41a880b062..55dc7cd83e40 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -252,7 +252,7 @@ struct kvm_protected_vm {
> >       pkvm_handle_t handle;
> >       struct kvm_hyp_memcache teardown_mc;
> >       struct kvm_hyp_memcache stage2_teardown_mc;
> > -     bool enabled;
> > +     bool is_protected;
> >  };
> >
> >  struct kvm_mpidr_data {
> > @@ -1522,7 +1522,7 @@ struct kvm *kvm_arch_alloc_vm(void);
> >
> >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> >
> > -#define kvm_vm_is_protected(kvm)     (is_protected_kvm_enabled() && (kvm)->arch.pkvm.enabled)
> > +#define kvm_vm_is_protected(kvm)     (is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
> >
> >  #define vcpu_is_protected(vcpu)              kvm_vm_is_protected((vcpu)->kvm)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 338505cb0171..6198c1d27b5b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -406,7 +406,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
> >       hyp_vm->host_kvm = host_kvm;
> >       hyp_vm->kvm.created_vcpus = nr_vcpus;
> >       hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
> > -     hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
> > +     hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
> >       hyp_vm->kvm.arch.flags = 0;
> >       pkvm_init_features_from_host(hyp_vm, host_kvm);
> >  }
> > --
> > 2.50.1.487.gc89ff58d15-goog
> >
