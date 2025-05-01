Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F725FA31
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746133430; cv=none; b=IXaPy5P76PHflVD6rI8O6BeFK4di2Pd0gAX1Uam29CBiUAr7GpDmJfpjRRMp1eiqrF9eVQhXuAjPKUuGn+l6ri9tiFiRJ+HWiXp1ESHH+scgChLikl3CassVb/I8wIT3B2FwjIA1GYZYFbwOSHnP4l2CZjFv5RR9i2TQT4+23To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746133430; c=relaxed/simple;
	bh=KnH5VvYqnintjP9wB50Y6q1JFqTDQJjI2skX7DvCHiQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rRVPalPEW8BSYb29ZWMjPU6c5K3oiYRhKrD/Dnz6vhK2ZtLKtAtFzXgcHyo7pfx4z1KXgnIK1Uf9DxwK4aaFzlorHswH7pOnTJhC4E1HLgB3bdF4Kbt/apjB+xS41w2LyKeDZGbupTWb/YWS8f3QyPk0hM4Obe9fyjR2xtTGvVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HVF429iG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HVF429iG"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3032ea03448so1350159a91.2
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 14:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746133429; x=1746738229; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3LgD3RsHy0idAPG24WJvE7joJXrg8YFB/6s4D5IWPE=;
        b=HVF429iGOG9/O3G5IaVv5MYIifXPu/jeY9KZ/CxBB+J2UVOg+M00DKxM9XGOu4m9g7
         g5RwAi45SgcAI/XcA2h7qeipVBas15QWKOkIT0NyaluGKcJjPINQ/2lB930dwZLyDrYy
         DpwSVE/CVLRiitiR43VYw7HrmslG9sIBXN2LK8axsJNPeOgl08xPAJAMiF5HcPAET6uM
         7P0XdUWAS+A9vdUiHhryy4msuLoXHT4I7cyAFJaSYdC613W3bXEC7ATce8j67Ntbwcgh
         Osawi22nyMzHLUf+EI8VYM5SfQxQzEINZX21gcXWs4+N7NzWtFZUXifIWx++El61oP4G
         ws+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746133429; x=1746738229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3LgD3RsHy0idAPG24WJvE7joJXrg8YFB/6s4D5IWPE=;
        b=cak5OsFAZBmOT2kmRXiLiRZn5Ofod+aRlzUgGlR33Wo4510+wfzWFhbtBnI4tBNbU7
         q8cRo0nOfKSFW0E0R1cQ9anw3OdN+FxTEToIFWfmKyEL66QmTJjkd7jxBnnm3SerfxZe
         oDFizAYfLmNU990sn50iGAT0oAbSfzH9zabeAEp2eiJqyUf9dUzDgvefVORjxpGQFya/
         SocXnB1z2Zg5YE64sglenboRQRrOEeq9OeqXFZScV+FnzuHMpnzRkm0dp54uYvb2vyI/
         AczUGS9evP899B8NM4SCAMVVljlpESGe+f5MSJlz3ltURq8CNpCTZkRJ3uQW2BYdfaB6
         t0aA==
X-Forwarded-Encrypted: i=1; AJvYcCW3slcWnlbraCJUIGvptU64cOQqfpz5rh40nQGhtS5uRy/BoZNlP8vuzzFAPgzH9ZMnFdh3zPQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqjZ1Sfceiwzog7gbr95JB3wqHrAzrqYJ1X5bLdglXWRBBQwrD
	rHrAHSjggVE09PQwKFTH8oyTPoDJ8nqwubKQb0jFYP2G6fIDpKjelruZBnoHABX8xC/tIXEfnrY
	Ikg==
X-Google-Smtp-Source: AGHT+IFsKbxWNYniktZ+08WA6b0CsvxaU/dos+kZKMRCn6iD7Ks6A9wZ87nfSSI8jfHEMe/wZJjzetRtCUk=
X-Received: from pjbnw14.prod.google.com ([2002:a17:90b:254e:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc2:b0:2ff:4f04:4266
 with SMTP id 98e67ed59e1d1-30a4e6949aemr658697a91.23.1746133428792; Thu, 01
 May 2025 14:03:48 -0700 (PDT)
Date: Thu, 1 May 2025 14:03:47 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
Message-ID: <aBPhs39MJz-rt_Ob@google.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, May 01, 2025, David Matlack wrote:
> This series renames types across all KVM selftests to more align with
> types used in the kernel:
> 
>   vm_vaddr_t -> gva_t
>   vm_paddr_t -> gpa_t

10000% on these.

>   uint64_t -> u64
>   uint32_t -> u32
>   uint16_t -> u16
>   uint8_t  -> u8
> 
>   int64_t -> s64
>   int32_t -> s32
>   int16_t -> s16
>   int8_t  -> s8

I'm definitely in favor of these renames.  I thought I was the only one that
tripped over the uintNN_t stuff; at this point, I've probably lost hours of my
life trying to type those things out.
