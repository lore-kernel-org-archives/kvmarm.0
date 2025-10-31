Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B922550D4
	for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761931817; cv=none; b=l0hm+WG7R/77ocO5NxYTzFOqltyubh8UEKiDiPp9jOnM6IYFG8DKyHb6QTj74VED4KB5ddkCKS9anVIjUYgUz4oVfZlNEA4APCHMBdKCXKXpvLbAob39bLYQV7brkIXmDNBXjf5qWeTG/hsBt74cIvH5XEezmlGTxvnTi0BGqwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761931817; c=relaxed/simple;
	bh=ELK/TPtUoa0DdzfjuQJxQqd/fmBurZBKRSXbJIZQLus=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f0jC1AnR8mwN9cd39f7wWeKq1IRH5CCOWCynewXmqo0n4xIQMmGFDW2V+WgEBFxo09WGriwWmWLptlA4q3y2L7AQQdx9fm9LPdIXP+fzxtSa62SZzxDBbLN+I6r6VsY3UNbMi8f3HVeEdwyQbhW/8VnaagiHmZ1HSx/VJEnn9vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oJso/Rqx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oJso/Rqx"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429be5aee5bso487241f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 10:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761931813; x=1762536613; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8smNPhdFrk3F9UsFWfFOTzaD0PFIjf/jPl9FFvNvth4=;
        b=oJso/RqxqWacFob//GqGo8VvKroNrNSMY/WMoni27Rg/wJMPd/rgf8ZBBvKPEuJFJF
         BjEul++Tc/iEZ0cBTvxqAjZRvvAhUO9IMhHSJu2CJrqhgslf0rGjbGi+L+1B6RGeL6vc
         8YGuM+Jvj1RTesDzRyY8AhdrnhhHeRA1myQo+Go0dIBmtZP2Qei0GHkNg6LBoCmWqqp+
         vWd/Tmt66h5eBgDnLPM1YfgEJRB88xY88xKoASl+k2dIFCX/wQeFGzz8zYNekodB630N
         9nfqt8bEEJC7lHwajqiqPZ8TCKpf0d1bm10FiMn6ZMVdfGglif0MKeNoGMyOhrIrk8Oy
         26tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761931813; x=1762536613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8smNPhdFrk3F9UsFWfFOTzaD0PFIjf/jPl9FFvNvth4=;
        b=jEeDMoWLaULQV/PoUVNjt3s7ddcZdiC/c8UIgsTmyK/dWTASLIJDOvPUn0ignOkvpU
         NVtfhWrAdA1dFuxVjcABHoBHFVukhrPRshs8FYI067LmbFDud2fvDEqVihFV8EK+px1H
         3DJjc43e5CeaAzXMCejKZiGg8DeCemmVBuopmwTKq3nMOdX5y/dc7CzOqUWZ4+bNvYXK
         gHaI5HcHExN1d3UDafV+K6Ea499wwgqUgO3G1aAep70AyuTB2MOgpCxq/D5JWD0F+pWo
         vvlunEARiCjD/FmTu2RPUadU3cuGfaSSTSusvNkelO53ncBArvuv/pF1Cgy4d5LYKt0c
         3GZw==
X-Forwarded-Encrypted: i=1; AJvYcCXtnswAgRN9c+a3lTkGPW2jRTwac2AGjNaLqnRVZGr2qpCPDolv1s0zJ0wxPuHF/9AnIzswywQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpRlty+bCbrx94BH/6x9Is7sb1ELyC8IwjR5fY/OvLEcJ8ZH7Z
	5JXsJsZMG7v56gmU3t2XE2/cu+xIb8zuOYU4CHbbJOV87eKKvjZJUYEHuUt97Gw9Z4qE/apiQhu
	q1Zm9AtYibuIxmQ==
X-Google-Smtp-Source: AGHT+IGAlLQK0HkJ6COX6kdvZKn0Ro2fXbdMSgyDJ0pItor316xsKGfib1jQEkdwcGXkq1m1difB1/UltgkgBQ==
X-Received: from wmwp25.prod.google.com ([2002:a05:600d:8319:b0:477:c8e:1959])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8310:b0:477:326c:b33f with SMTP id 5b1f17b1804b1-477326cb6d3mr20439815e9.16.1761931812961;
 Fri, 31 Oct 2025 10:30:12 -0700 (PDT)
Date: Fri, 31 Oct 2025 17:30:12 +0000
In-Reply-To: <20250924152214.7292-2-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-2-roypat@amazon.co.uk>
X-Mailer: aerc 0.21.0
Message-ID: <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct map
From: Brendan Jackman <jackmanb@google.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1d0585616aa3..73a15cade54a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>  #endif
>  
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +#ifndef kvm_arch_gmem_supports_no_direct_map
> +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> +#endif
> +#endif /* CONFIG_KVM_GUEST_MEMFD */

The test robot seems happy so I think I'm probably mistaken here, but
AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
which powerpc doesn't set.

If this is indeed an issue I think it can be fixed by just defining
can_set_direct_map() to false when !ARCH_HAS_SET_DIRECT_MAP.
