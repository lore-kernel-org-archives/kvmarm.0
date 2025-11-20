Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B6B1F5617
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 12:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763640122; cv=none; b=sbwoHNAH95VqjY675tOKRQj87SwMaQCnOb6OWT4sWSAPok70qCkZqLxzsaveqK1sQTqvZ7uveqN6u2wprMsaOX4gw6+b4w3i3t1N2Yr2h3lv+D+sTfrTMiDUAKeU+fa2YD0rUN6TSDdeLMXG3Z4vCf6RsMwyDZ2XcAEvRH9qCKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763640122; c=relaxed/simple;
	bh=l5X1M6FBP6DayK9Ql6g8vjX4aA54CXzX54bmX/HNAik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apbVbZOe21Cc1cwCPw46RhvVq3XcwUXluF9DzOvTWir4r1DB4ceTRiJR78jIK/4ZX9QqZHbmxHzGcfmnQZ75S/MAnfejACdCIAlWOn8pZPbtREb+Hu+SUKjHn97adC8OsmqZX2Di5O2Xr/UVT4CbERniYw4K6FIHmLMV4NthIL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oZuqt4c1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oZuqt4c1"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47774d3536dso6223735e9.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 04:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763640119; x=1764244919; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h29daZyB4oG+q+opR9L96UtT0D3drFHL81djpgYvOIM=;
        b=oZuqt4c1yYORYI8qKVjOkvy5guUeg4US4hbV0ph3V2N4T9/h4J9mk6SDUgbFmaroT6
         Hl2tM2dz7+jQ8F/bCSPQ/43ybtmWMj0HUKz4ASK8593XNycDNZdJ1zGRf2A74W/EG6mT
         1cZgYges59UIaKnXYgtcTdT8mQVMR/5m9aCma4pxEU44BnygPOeRpBi9Je5gJO623Wr0
         gJaw8pTkQyHda79uC3hmnAjF+nO89hNm/FFvRJTRVfOcL88WohNLm4Lx2doIZ5s+xXCH
         U4a9k52pJ6ATQWw6ydN1Zo8SLqWdueTaHrP2T7cInrdt8B2EE0gsRqILo6QVVDA+LKxm
         naWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763640119; x=1764244919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h29daZyB4oG+q+opR9L96UtT0D3drFHL81djpgYvOIM=;
        b=dxKBNtuC2aWdfldMPftArNX3bj2dIukRr1nYtOLDv+gFWftoMv0/aG3EPxYIPggwWK
         Eb+edGtNALf1huI/tw4sTitYfC4AHtzmmX7dFzncTo2bPQ8ekiCNGFxo9+eK95Zmim54
         qfJjGYUSna7PaD3+a4LL5+/otVfBJeDkEiXujNaTzPVKTdnDSIf6DkMdADrCPl3DjEpB
         O6Tf/xlfXbRRJ2aSjj5uJevyxrFfWoRXmQr6H2vlaxcmBrJzVeTaK8gyomd6/DAjPVKz
         0rIZ+InmSdYj2h9aONpS7u2Skx2uPEUZrgJrVwSk5rnxYq189oaKSgHXFLDsIWwrYks3
         j/CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjy+LOxhm81avZdOd3BstP7OF4f9qjFEVAeA+WRnnuEKbMRM8In4HuGHjGyscS2g7HnTmOG9o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxId1XSXLmis/MGAUTy5x5q03XrAVc1yBT1+ufvDawo2YIAXh/
	AumozRzzltX9zazlkeD4iRwap81X9JekuBFzBacUAYMDGSAKo9CKC7BTBB0b/eUSKQ==
X-Gm-Gg: ASbGncuXXNIleNRqawbMuaRmmDOK0A236qoHncXVkhVhs3zX7Chbedh2R9hMq0PGY/k
	0NYZLLXVehhIp6yseohq/C6baS+hUgNb+FhWc6Rt4DYa/EAMnF8T1U5aBRz/N8F0Q/R81vATd8G
	U/xr+UPMBk5X/1ZWYmaPwvt9Zot2TF8UliCfstjD2G2SbbL8vVblSMC4CBHOUhOoiVKBeWdzI83
	nw8UQHJ7NzG2kHYmIPNyM9Bi3a15wczAleNE/glxCsj7qk2l9oXt/WMwZpCjqgxCXaB1tRxFOL0
	ZO8D1xO5rdjVmGrXn8MhlO5mNxP8gCZwhlSOBcU/ldbDg+0S+ZY8nkwDwRZXAsZX15HySRoN3BA
	BTpTbjcMPV+y4YiKor4vbrAQYXz1np1hKRdb+ES+lrAcqWcGJeyHGjrwU7vGgIaGlPc2/iJxHVu
	yvMzKNP4v4El+GJirr6wCCOjFibH8snfcih0TEEh7avBaw9kfHgg==
X-Google-Smtp-Source: AGHT+IEH5Qk6xomHJqxz1J/Ne6qSerXpBVOOPuJy2CRilZnpK8DiEWwuEIr1RkfRUoWDaiyCIB+T5g==
X-Received: by 2002:a05:600c:35d5:b0:477:9e0c:f59 with SMTP id 5b1f17b1804b1-477b9ea5683mr29594085e9.2.1763640118768;
        Thu, 20 Nov 2025 04:01:58 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b83142b8sm48432785e9.9.2025.11.20.04.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 04:01:58 -0800 (PST)
Date: Thu, 20 Nov 2025 12:01:55 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 21/28] KVM: arm64: Add tracing capability for the pKVM
 hyp
Message-ID: <aR8DM6Xf8cmTGVR0@google.com>
References: <20251107093840.3779150-1-vdonnefort@google.com>
 <20251107093840.3779150-22-vdonnefort@google.com>
 <86bjkyrly9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjkyrly9.wl-maz@kernel.org>

On Wed, Nov 19, 2025 at 05:06:38PM +0000, Marc Zyngier wrote:
> On Fri, 07 Nov 2025 09:38:33 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > When running with protected mode, the host has very little knowledge
> > about what is happening in the hypervisor. Of course this is an
> > essential feature for security but nonetheless, that piece of code
> > growing with more responsibilities, we need now a way to debug and
> > profile it. Tracefs by its reliability, versatility and support for
> > user-space is the perfect tool.
> > 
> > There's no way the hypervisor could log events directly into the host
> > tracefs ring-buffers. So instead let's use our own, where the hypervisor
> > is the writer and the host the reader.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 9da54d4ee49e..ad02dee140d3 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -89,6 +89,10 @@ enum __kvm_host_smccc_func {
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> >  	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> > +	__KVM_HOST_SMCCC_FUNC___pkvm_load_tracing,
> > +	__KVM_HOST_SMCCC_FUNC___pkvm_unload_tracing,
> > +	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
> > +	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
> >  };
> >  
> >  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> > diff --git a/arch/arm64/include/asm/kvm_hyptrace.h b/arch/arm64/include/asm/kvm_hyptrace.h
> > new file mode 100644
> > index 000000000000..9c30a479bc36
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_hyptrace.h
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef __ARM64_KVM_HYPTRACE_H_
> > +#define __ARM64_KVM_HYPTRACE_H_
> > +
> > +#include <linux/ring_buffer.h>
> > +
> > +struct hyp_trace_desc {
> > +	unsigned long			bpages_backing_start;
> 
> Why is this an integer type? You keep casting it all over the place,
> which tells me that's not the ideal type.

That's because it is a kern VA the hyp needs to convert. However it would indeed
make my life easier to declare it as a struct simple_buffer_page * in the
struct hyp_trace_buffer below.

> 
> > +	size_t				bpages_backing_size;
> > +	struct trace_buffer_desc	trace_buffer_desc;
> > +
> > +};
> > +#endif
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 4f803fd1c99a..580426cdbe77 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -83,4 +83,11 @@ config PTDUMP_STAGE2_DEBUGFS
> >  
> >  	  If in doubt, say N.
> >  
> > +config PKVM_TRACING
> > +	bool
> > +	depends on KVM
> > +	depends on TRACING
> > +	select SIMPLE_RING_BUFFER
> > +	default y
> 
> I'd rather this is made to depend on NVHE_EL2_DEBUG, just like the
> other debug options.

NVHE_EL2_DEBUG is unsafe for production because of the stage-2 relax on panic.
While this one is. So ideally this should be usable even without NVHE_EL2_DEBUG.

I can remove this hidden PKVM_TRACING option and use everywhere CONFIG_TRACING. But
then I need something to select SIMPLE_RING_BUFFER. 

Perhaps with the following?

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 2ae6bf499236..c561bf9d4754 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
        select SCHED_INFO
        select GUEST_PERF_EVENTS if PERF_EVENTS
        select KVM_GUEST_MEMFD
+       select SIMPLE_RING_BUFFER if CONFIG_TRACING


> 
> > +
> >  endif # VIRTUALIZATION
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > new file mode 100644
> > index 000000000000..996e90c0974f
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > @@ -0,0 +1,23 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef __ARM64_KVM_HYP_NVHE_TRACE_H
> > +#define __ARM64_KVM_HYP_NVHE_TRACE_H
> > +#include <asm/kvm_hyptrace.h>
> > +
> > +#ifdef CONFIG_PKVM_TRACING
> > +void *tracing_reserve_entry(unsigned long length);
> > +void tracing_commit_entry(void);
> > +
> > +int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
> > +void __pkvm_unload_tracing(void);
> > +int __pkvm_enable_tracing(bool enable);
> > +int __pkvm_swap_reader_tracing(unsigned int cpu);
> > +#else
> > +static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
> > +static inline void tracing_commit_entry(void) { }
> > +
> > +static inline int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
> > +static inline void __pkvm_unload_tracing(void) { }
> > +static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
> > +static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
> > +#endif
> > +#endif
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index f55a9a17d38f..504c3b9caef8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -29,7 +29,7 @@ hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >  	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
> >  hyp-obj-y += ../../../kernel/smccc-call.o
> >  hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
> > -hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o
> > +hyp-obj-$(CONFIG_PKVM_TRACING) += clock.o trace.o ../../../../../kernel/trace/simple_ring_buffer.o
> 
> Can we get something less awful here? Surely there is a way to get an
> absolute path from the kbuild infrastructure? $(objtree) springs to
> mind...

Ack.

[...]

> > +int __pkvm_load_tracing(unsigned long desc_hva, size_t desc_size)
> > +{
> > +	struct hyp_trace_desc *desc = (struct hyp_trace_desc *)kern_hyp_va(desc_hva);
> > +	int ret;
> > +
> > +	if (!desc_size || !PAGE_ALIGNED(desc_hva) || !PAGE_ALIGNED(desc_size))
> > +		return -EINVAL;
> > +
> > +	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn((void *)desc),
> > +				     desc_size >> PAGE_SHIFT);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!hyp_trace_desc_validate(desc, desc_size))
> > +		goto err_donate_desc;
> > +
> > +	hyp_spin_lock(&trace_buffer.lock);
> > +
> > +	ret = hyp_trace_buffer_load(&trace_buffer, desc);
> > +
> > +	hyp_spin_unlock(&trace_buffer.lock);
> > +
> > +err_donate_desc:
> > +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn((void *)desc),
> > +				       desc_size >> PAGE_SHIFT));
> 
> That's basically a guaranteed panic if anything goes wrong. Are you
> sure you want to do that?

A failure would mean a lost page for the kernel. As there's really no reason for
this to happen (the host_donate_hyp worked few lines above), it sounds alright
to panic here in this case. 

In reclaim_pgtable_pages() applies the same reasoning: if hyp_donate_host fails,
something really wrong happened.
 
> 
> > +	return ret;
> > +}
> > +
> > +void __pkvm_unload_tracing(void)
> > +{
> > +	hyp_spin_lock(&trace_buffer.lock);
> > +	hyp_trace_buffer_unload(&trace_buffer);
> > +	hyp_spin_unlock(&trace_buffer.lock);
> > +}
> > +
> > +int __pkvm_enable_tracing(bool enable)
> > +{
> > +	int cpu, ret = enable ? -EINVAL : 0;
> > +
> > +	hyp_spin_lock(&trace_buffer.lock);
> > +
> > +	if (!hyp_trace_buffer_loaded(&trace_buffer))
> > +		goto unlock;
> > +
> > +	for (cpu = 0; cpu < hyp_nr_cpus; cpu++)
> > +		simple_ring_buffer_enable_tracing(per_cpu_ptr(trace_buffer.simple_rbs, cpu),
> > +						  enable);
> > +
> > +	ret = 0;
> > +
> > +unlock:
> > +	hyp_spin_unlock(&trace_buffer.lock);
> > +
> > +	return ret;
> > +}
> > +
> > +int __pkvm_swap_reader_tracing(unsigned int cpu)
> > +{
> > +	int ret;
> > +
> > +	if (cpu >= hyp_nr_cpus)
> > +		return -EINVAL;
> > +
> > +	hyp_spin_lock(&trace_buffer.lock);
> > +
> > +	if (hyp_trace_buffer_loaded(&trace_buffer))
> > +		ret = simple_ring_buffer_swap_reader_page(
> > +				per_cpu_ptr(trace_buffer.simple_rbs, cpu));
> 
> Please keep these things on a single line. I don't care what people
> (of checkpatch) say.

Ack.

> 
> > +	else
> > +		ret = -ENODEV;
> > +
> > +	hyp_spin_unlock(&trace_buffer.lock);
> > +
> > +	return ret;
> > +}
> > -- 
> > 2.51.2.1041.gc1ab5b90ca-goog
> > 
> > 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
