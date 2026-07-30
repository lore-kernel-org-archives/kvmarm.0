Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F2446833
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433590; cv=pass; b=uxLYwTz3IILGGuTsANXrFCeZR0aY15VA5Mv/AcgqkTu/s1JMOqUuaLrYZNFot4lXvnVxHedWSLoHQTRt5W37OIxR9EUTmkdMRPJCIxlTWSmkMa3f1gvBvXSKdR590VewbULJUyGO/NlKNn8kMtlwcTbHb2phh1zBDXcpjv5chT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433590; c=relaxed/simple;
	bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A6cn5lCQVSzzLdsOvhvoV/zmQGJU0OpvlHvZof1rPh9I5LxSPwS+an96lfTRJR5j7rlNx7staYJNryvbQ50myN9CeNx+rSQ0CNv2+vxpRDl1TVECvKD5hil7bthepBoSQdJfBP726FtWmEgVAwkdkqVC/g4FSMe8Ofzlb0xu+vY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rBAA+2QE; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rBAA+2QE"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca97d139d8dso37455a12.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 10:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433588; cv=none;
        d=google.com; s=arc-20260327;
        b=ZojX5OTjCKrtPUqVgYGkoB+bTsxaduu9Du9oYD2GcetG4TAAgtIFNLcAmFH9KoimcB
         WCdLERHY8AkRxLdo1y0KoZpRKIQ8rrbnnwC2nG2/MhCxjAsQJV6Bw3PZ+8TM0mghRB/I
         rciTFzItQpoz+QUtGA3WiahqDpxd0YrojMjIRSLbCdAZDmHXENRD/TtJKaU11ubzouQm
         68pgOJN2zRpMQRy2k2l4rkL1uCPVToHie/hU36I+g/BANCooCilnMVojf3mUU58HTGHM
         Ypk49Jo1b6UNPwp7XmpCV66UdX4772PPnmqyAUcywpJCmV0rN9yN/VLjFZfb9eePIyQ9
         jOSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
        fh=bGJvWI7diuexU+47T/Tj9T9BIZW5NW4vPTjy7/icsVE=;
        b=BShY2//KYja55AXv/OvTj/F8T4VmOTpzkcADyrU5CSoW3bZA+9XCiC8opNG4O+SjlF
         yjVmqqV+nk0a6nn9Y9lqYAetzPgLzK4rU/g0sLKmCdxdJFR76JnFSUpYYLazjOvPjAPb
         aR2t5ThXHYvSzT3bn/RZLB4HmISTXHdITHsGVr2oUPt7FmpPUD5y+Y55SZjLMfDPmcmu
         RKKRPe2eJV3iBwsLx44zlaUXux+Cjz8hzIrkj2reQDC1c3hpMCyJddXL+pY0sUvetN+2
         VxqqxhrPJDbmv19pLFToIZnDxQrwR+fK2J7sAUBaWCE7V2iyWxlomyzEhl8eoN9MhdVE
         ESJA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785433588; x=1786038388; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
        b=rBAA+2QEnRtPMa0zUd8I12dUUQJIau4c3Ko51zcY7AKTZIqZiZt89cCsarerULQk1f
         SJvwXIvyMyrSnq0GYFQPOsUdLYCgJjLxOHKVn0Hdrq9cmanwLzwEkFZbCWvCuTp9M+iV
         r4fAjjW8P3ZayfQmkssfaIYygAEmcnjoIs9qtFsr8ButJ74CVvNXk3O7FxrhbwgktoYf
         KPJjaWo18LpcFRXVL0JGnpm6CBUdZDRYVgdz3ZWoBmkt3z5AZzWm2GE32AGYul9xk8W3
         vbNwrED1VQ8uD49XVXi+hI5kv1sRtB43isfKFK3Mu6aK57bqbrI8bSXUMz/Dw775ktFJ
         jDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433588; x=1786038388;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
        b=a052CpKDBtO7zy94ApEULWbOc377awH+FQAjS5FV0Yt1tMGnRdkQ1f3sXA2JzHXFWS
         uyOfEBcsjdfXCJhUqkMN5YkGpqmOpRHK99bcD4NXSTYrYYCaa89ymf1zHMwKGsYgy65P
         vtmRFB6Ao6RnHZH9kNiYLD4ZK/U292Zg9ygUOCi0qiDyqgZ5pGBe4ETENLNQriMMdOtI
         UlRE5mOOvzSlxoH1CZgNgi6c4vRZBNc7GfFLoD9iJeadAr8UZbX3mvZ0ws7Li9noWFDY
         hl8xTIvMydx19mlUy0gduHHK+SFCa+md6ZgHKT+zlV5uFRaLGsFClMuPS5kfS1cyC/VR
         /lyQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQRGajfiOOKoNr6Cm+7m8pTgWHyLAtvfFW1Uo9qRvHkeGUkEjz7nPMjV4mBktxJryPZc5N+6g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/kLkAA6hsCmKl+yGtod2ZSRDJRBZKPr8t1XX9B7rbwfJMLywb
	7W9r7gk+e4D726eGiGLQ20B78uJYZgr1V/4EyafpTo9qbmf27rvC3tmVcu0bsZLzuOMNhJ8W0l8
	LaH3GO0zbHiC+8z0gVNvyQYX09XwRx4OsO3zvEz+O
X-Gm-Gg: AR+sD11AewTr5k9J7z61mlfveGFFGQtg6Fy+thnO8n0Op69nxFnjsfYGFkY3hKrRedf
	9/yPqE8QM4aTKxaQ7U+gwrz6UYT4O11s1ILTSpLncHybWhKL/nRs47aE96ue0yQMI13Q2gBR+PQ
	FdmJVnpnKRpkrbLXgBUzAlHpeSTR5uxobsRtAR5jEY2fctvYVfnuYqjh0WF6BvKH9QAbhs55cZh
	PM1fq7obbYS4dKvo32/TQVvbR0lobZxCH8/uc2InEUNSJvda215e+tanjWFGKGq38EdkeV2pc+I
	qpf6gEsXowxZg1U9D7XyfSTYyEwwY437W1QUlPD+pKkkgHqZmALAWF6E26ZH3dfVFU8xmcGXAgu
	BSd+8Pk4ogs7GYsbTY+/JuGOvN962rqB8VQ==
X-Received: by 2002:a05:6a21:e8b:b0:3bf:6ac8:8d29 with SMTP id
 adf61e73a8af0-3c9006bb981mr3748982637.21.1785433585760; Thu, 30 Jul 2026
 10:46:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:46:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:46:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-8-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 10:46:24 -0700
X-Gm-Features: AUfX_mxSA02wZmCDGZHkTAv1sqG45AQrWdNvcUlNspdo9IevcZmmfeKZDjs0tR8
Message-ID: <CAEvNRgHvBTKaG4G5J=sMFGYepEnOFaeCBtjkzN6xmGtZ+o6XxA@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Tarun Sahu <tarunsahu@google.com> writes:

> Introduce kvm_gmem_freeze() to freeze a guest_memfd inode's mapping,
> which prevents fallocate() operations and new page fault allocations
> during preservation.
>
> Use a global SRCU (`kvm_gmem_freeze_srcu`) to synchronize freeze state
> checkers without incurring per-fault locking overhead or risking per-CPU
> memory exhaustion (as per-CPU structure not counted in cgroup) from
> per-inode SRCU structures by faulty/compromised VMM.
>

I wonder if everything to do with freezing should be gated behind
CONFIG_LIVEUPDATE_GUEST_MEMFD. What do people think?

> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>
> [...snip...]
>
