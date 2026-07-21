Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF877274FE3
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 12:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784636694; cv=none; b=Ojs156ROP17RwXuXLqSbu1q7M7VVZOasr+uDAr9V+pYmNdCbIcQM5y7HDNb5w8QCcn3NP1wcG5X7X3DZkB2Pxv2GFsruREWAqP9M4oorjAIMzi3aUtrJYX2203DSgml6GHloYMxpvQfV/FD1vTZ9ZnaoavorDI0N0JuxW+KaV8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784636694; c=relaxed/simple;
	bh=3Gv95ZN/xC55vR+jB0FApJjVp7S1tEJNV1qJDH1HfEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KURubhxY3AOYOubREJOXE7nCga0gsMiIhE7MrrA436NxBIB6rm7E0tODoFoM6eWHuW3SKG84uEIoqEAmPIQIq6UP6cOxYPkd3AmAb5UEHH8x9B1LjJdBnyS8Lw/PH/DpMF3fES5RO254w8dzoiVKI5k+gUvOCL8BIDKyJc9wCaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aJuyni9G; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aJuyni9G"
X-Forwarded-Encrypted: i=1; AHgh+RpCTFeYkM3CNP6JvG+hzTnydzCUB0/2tekUdRmjfeakk25VJFALy2wSSb1rptOe7OZNUwOXYc4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784636690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zYTJwHkAf1TmQrTHI65fUCX9+FxnuGE2Bm0tJuySfOA=;
	b=aJuyni9G+yP4GHDDV10hyAlBbiZ0MWanX9rzWiN8B///XHh9PV6SzpWCXQsZv/bTFvZcKy
	Ju8oyr1jRbGFDEgBFGbjmoX9OSL1uMJIM3lVMOggmohNj8IEXLjdOp+CJsk6RrJktOMv2D
	HuamluJHWBTz0uKOwf6fy8lqb76B56I=
X-Gm-Message-State: AOJu0YxNga/gkf9Rz2Wf0mf2NuSYjArdpo5e3qFLB7U0fYvlypBhASEH
	8YidCSfuZRX+2Uh8X2k0Rdf3sLGePikUgc2zEiOuFR+nnCt3eCrToCVwWU7z8L/Ldtu6x2tYO80
	mEkwf2VFGYeKu7MmFEikOSqJ8uTXiasAZm79RtdhL
X-Received: by 2002:a05:622a:aa12:10b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-5260098e461mr13025061cf.9.1784636681231; Tue, 21 Jul 2026
 05:24:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
 <20260717130317.1953574-7-fuad.tabba@linux.dev> <C5D63651-E924-4297-9B4D-6E9DB04D64D8@grrlz.net>
In-Reply-To: <C5D63651-E924-4297-9B4D-6E9DB04D64D8@grrlz.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 21 Jul 2026 13:24:04 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw8Z5LDEi+1b62EEr2a8fqzBFGMsETsH0suZk76_DsNdw@mail.gmail.com>
X-Gm-Features: AUfX_myF8APD4JrsQUjpdgeGCuOrmjzvI9FEW6Snxcw0N2xLLub-E89efv0Armo
Message-ID: <CA+EHjTw8Z5LDEi+1b62EEr2a8fqzBFGMsETsH0suZk76_DsNdw@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] KVM: arm64: Don't advertise eager page splitting
 under pKVM
To: Bradley Morgan <include@grrlz.net>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Shuah Khan <shuah@kernel.org>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Gavin Shan <gshan@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Bradley,

On Tue, 21 Jul 2026 at 12:19, Bradley Morgan <include@grrlz.net> wrote:
>
> On July 17, 2026 2:03:16 PM GMT+01:00, Fuad Tabba <fuad.tabba@linux.dev>
> wrote:
> >Under pKVM the stage-2 walker resolves to pkvm_pgtable_stage2_split(), a
> >WARN_ON_ONCE(1) stub, yet KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE is still
> >enabled and reported for non-protected guests: the capability check keys
> >on the per-VM protected state while the walker dispatch keys on the
> >host-global mode. Enabling the cap and then dirty-logging the guest
> >reaches the stub, splatting a userspace-reachable WARN.
> >
> >Reject the capability, and stop reporting a chunk size and the
> >supported block sizes, for every VM once pKVM is enabled, keyed on the
> >host-global mode like the split dispatch. Gating only protected VMs
> >would leave the non-protected guests that reach the stub still able to
> >enable it. Userspace decides whether eager splitting is available from
> >the block-size bitmap (QEMU falls back to no eager splitting when it
> >reads 0), so leaving it advertised steers an explicit request into the
> >enable failure instead of the fallback.
> >
> >Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
> >Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>
> Do you think CC stable would be good? I do but sometimes I'm
> embarrassingly wrong

I'd lean against it here. The "Fixes" commit has been in mainline
since v6.14, the symptom is a WARN rather than a crash or data
corruption.

>
> >---
> > arch/arm64/include/asm/kvm_pkvm.h | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> >diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> >index 57afb07d6b13..beea00e693a0 100644
> >--- a/arch/arm64/include/asm/kvm_pkvm.h
> >+++ b/arch/arm64/include/asm/kvm_pkvm.h
> >@@ -45,6 +45,9 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> >               return true;
> >       case KVM_CAP_ARM_MTE:
> >               return false;
> >+      case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> >+      case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
> >+              return false;
>
>
> Nit: KVM_CAP_ARM_MTE right above already returns false, fold the two
> new cases into that and drop the duplicate return. And please put a small
> comment saying eager splitting is unimplemented under pKVM (WARN
> stub), so nobody reads the list later and "fixes" it back, here's a
> example, feel free to bikeshed

I'd prefer to keep the separate return. The grouping is deliberate:
MTE and eager splitting are unrelated features, and the two eager
splitting caps belong together. The function is self-explanatory from
its name and header comment, so I don't think an inline comment is
needed.

Thanks for the reviews!
/fuad

>
>
>         case KVM_CAP_ARM_MTE:
>         /* eager splitting is unimplemented in pKVM, please don't refix this */
>         case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
>         case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
>                 return false;
>         default:
>                 return !kvm || !kvm_vm_is_protected(kvm);
>         }
>
>
>
>
> Killing the reporting too is right imo. Qemu reads a 0 block size
> bitmap and quietly falls back, an explicit enable eating EINVAL is the
> worse failure mode. Good.
>
> if u choose not to, it's ok, please add
>
> Reviewed-by: Bradley Morgan
> <include@grrlz.net>
>
>
> >       default:
> >               return !kvm || !kvm_vm_is_protected(kvm);
> >       }
> >
>
> Thanks!
