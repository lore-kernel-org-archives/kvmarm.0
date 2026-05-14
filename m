Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551E3451C1
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778777127; cv=pass; b=cOXX+j3cApJ1B1NGKfJh4elEM2i274UwpTZM1S31cARr2Wt5fIlawAyfkwDa9tayZspkl1fM8D8oj/UpTl+9fiAgDdb/B3Wdcs03bts9UHRUihOG+2gfqkWfVmTOq704j2otVC3G07G6dOLplBv9yPApM5YntV+vbMfDPb551iE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778777127; c=relaxed/simple;
	bh=PmAIcppCWJmcGf0UnWT1GlVwFgygixvvwcZwvNaEkWE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jAz1+hWFAQF5oIoE+z6Hu8ugVrfSGIf4ub+NwpSMpsti4qo1ggjR82jY4TKWCQzQVEU61ANFV2WLUmVUL1JZ30dwh9uszG/RVk/vII4LXOC9jTDEUaV1eLRk3IZagjOSrKG1bLQfQwNR7QrcGer0lbqeE8Fm6aKHMp5KRt81QRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HVg/0mBg; arc=pass smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HVg/0mBg"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-56a9a7e762bso7791357e0c.3
        for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 09:45:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778777122; cv=none;
        d=google.com; s=arc-20240605;
        b=Yx4bOxRReKpGCSda1MvJ2AEamLgGp7EkP9pQtK8iYHYhxYSRNHZoT/SWm9vQt9m/CT
         3/Byl/gEtnU3yIHbgAzmjDnJBYAyXlFohFhD/Pv05L6ZV0uhGq48XUQMfDhqNL6jm+eb
         aFxJc6FrIqVKEaKNCf/u7XNdv6fx7WA/2bpfLwx3zXKO+nMLULLbwpu1zFwExEJRQY4H
         yjox9MrO0YjROZkfmjp98IcLWx/udvp8R1qLr3PSh4sfpLT/9c4qhIP3Ro82L6D3carG
         Mhl5yoaSCKayprSVPvP2dJpHmRHGLzOwIFZjKkuuPDc6ap7tI57EWx8TNEPzTv6PytVn
         b34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
        fh=0VAPOigH+Z+DvJ07u8fttpbSINphsUE6Zo6CEx39EVM=;
        b=PrYEH9XxN1JKWzZk9S0JxQwFp3kTM6EVarFksrd7lcVR7tlzgshuOIKYy/MW0W2mKs
         xEnTLcby02g1d5+3ect9VZTyhDmmDKFttoNnfEjtvbe1L/tgMX35vojKmOdl3gwTX74T
         047/I1wkoQGvxTdQBHEHZgB592j0p4FXvdy+66NVkMDQdQvQQi89TqImmRYjuZJnxbB2
         1e1ZDF50RNqvCQrLn1S/aHkB0vGxqb8f1PoDfrawpkJlh3LpIzqbYwFWZs937+i3KJGm
         RQ8fbZnbwaWFEZaLQDuZLp1rxwQG+h4jc1x9LY8XcLJXqXCPiOXOmVv5icm1U1jEOZCF
         BiWA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778777122; x=1779381922; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
        b=HVg/0mBgO+NQB5z7L8Fkdosk8QH0wPn1lM46sBnCqApNg6+YR4i6g/6PP1Jz1TKKdO
         hjBg0ZGIWAqtkGvVrBj/H52vY03AcZJG8UJddb4SW2HrQiWTzr7VuoxTysSZpau2UoRN
         kYDYZyF9z0NrSy2DxL2Pj5QHHD/+76gJjNAUtQbrVeTQ4daLjjuiDM6YJ9/MCJWVQCF6
         eiWx7Ow8PvADzjdw/kzGeipiK7tDiXKQPCIhhormzz7ZqiVu82kMWUZLhWFyqpZkBLJK
         Nh+J4ZOl+pQ0f9ZdmYO8Dq++rLIdD9vOWkPqyzLohS/eIWCTp+eiwAv46k87XH6f7r0z
         1Xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778777122; x=1779381922;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
        b=fVpTT9QRHxV0znZJdH32S4CbFxHSibh8xwA3qVwIuUdZDPoA/XSsa88VV9rFojvTZf
         ZJrjja8dk6lLYh6FHSd9Yu05vIVkLdWTmHhsqtMIEtDrD8udoWyOWaFzMr2/AiOgOBLH
         Vc0zP/hS/tI4U1eydB23pxAH5VCBL8HOQQXpAX78mrwbroGJb/Fh215wTgBrSCKzuV98
         CvtplQ8/Tuw4PK0IFoKHsDMZfpNQAQwlLu9dvC87HDGtHD6dcP+J2hN9UQkPRxmZl24R
         L3W0qMsn1f1Enn7cKVXeju4QMhpOs1GN8EGZ88MmMRzu9hfisExsbNkOJjwI27jvZQlA
         hoQg==
X-Forwarded-Encrypted: i=1; AFNElJ9lJgVz00EKlY2UvBkd63H9wiFeCwtnw0SpdaxpsfDgcyt4Ae43Y1a15dReR5mUrP7uQkJaGT0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxhg+RGbFdGR0hnd4Hk9Yno9LSs6j7L13KirjP8uphs71JGzfFW
	WyJdULksG9P6sarkOZK31vX3e0jZzC0QIqpA3NIejNBROAvMtoVS8zMciKsBkLunMVpxfK31C9b
	cxsqTZ0ySLicAsjM0GQfzPo7cWAqUkCepbeWebQ+4
X-Gm-Gg: Acq92OF+qtJwQJgWtslqIgPmnBz9ETU1fZIJlCkYccIjGbSyDubqg1N1X2IeuhwTG3I
	IMlGkzCXjuRzkXZ8kN6LrfB0m13kXgpnokfCHoIIxahKGoH/phPFGMWErXWMV0NHa/R/ZDDeJFJ
	hjeSwe7udUF9AV6fry6WipQ2a8Kv5Thid5/pc1ELk7IU7Kpx3V2w3qwkNnR7FGw67iu+JwUNeMz
	+TjEpYWjBMPSyfZb+ruZsn+S5nbV8moe/a/y8z0x3k8Rvw4zPYvG/N/rxtpFjGyEybBArn8kJKK
	JcxdnaoSzSx//R0q811WK/ebnqxCqn9m8h2E2W1k6xv3Jdsj7KEwbFk9XYljAEg3d0SXrCcnBZk
	PYhZF
X-Received: by 2002:a05:6122:1814:b0:575:178f:62d2 with SMTP id
 71dfb90a1353d-5760c092d3cmr165926e0c.14.1778777121451; Thu, 14 May 2026
 09:45:21 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 May 2026 09:45:20 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 May 2026 09:45:19 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260508081812.12345-1-itazur@amazon.com>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
 <20260508081812.12345-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 14 May 2026 09:45:19 -0700
X-Gm-Features: AVHnY4JqumP2VJstFZ-DobQ0sDmpWwtOhYCl663Ih2m9TKxeTUM0glktONR3Yps
Message-ID: <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: Takahiro Itazuri <itazur@amazon.com>, fvdl@google.com, seanjc@google.com, ljs@kernel.org
Cc: Liam.Howlett@oracle.com, agordeev@linux.ibm.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, alex@ghiti.fr, andrii@kernel.org, 
	aou@eecs.berkeley.edu, ast@kernel.org, baolu.lu@linux.intel.com, 
	borntraeger@linux.ibm.com, bp@alien8.de, bpf@vger.kernel.org, 
	catalin.marinas@arm.com, chenhuacai@kernel.org, corbet@lwn.net, 
	coxu@redhat.com, daniel@iogearbox.net, dave.hansen@linux.intel.com, 
	david@kernel.org, derekmn@amazon.com, dev.jain@arm.com, eddyz87@gmail.com, 
	gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, haoluo@google.com, 
	hca@linux.ibm.com, hpa@zytor.com, itazur@amazon.co.uk, jackabt@amazon.co.uk, 
	jackmanb@google.com, jannh@google.com, jgg@ziepe.ca, jgross@suse.com, 
	jhubbard@nvidia.com, jiayuan.chen@shopee.com, jmattson@google.com, 
	joey.gouly@arm.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	jthoughton@google.com, kalyazin@amazon.co.uk, kas@kernel.org, 
	kernel@xen0n.name, kpsingh@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, lenb@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, loongarch@lists.linux.dev, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, maobibo@loongson.cn, 
	martin.lau@linux.dev, maz@kernel.org, mhocko@suse.com, mingo@redhat.com, 
	mlevitsk@redhat.com, nikita.kalyazin@linux.dev, oupton@kernel.org, 
	palmer@dabbelt.com, patrick.roy@linux.dev, pavel@kernel.org, 
	pbonzini@redhat.com, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, rafael@kernel.org, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, sdf@fomichev.me, 
	shijie@os.amperecomputing.com, skhan@linuxfoundation.org, song@kernel.org, 
	surenb@google.com, suzuki.poulose@arm.com, svens@linux.ibm.com, 
	tabba@google.com, tglx@kernel.org, thuth@redhat.com, urezki@gmail.com, 
	vannapurve@google.com, vbabka@kernel.org, will@kernel.org, 
	willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, 
	yonghong.song@linux.dev, yosry@kernel.org, yu-cheng.yu@intel.com, 
	yuzenghui@huawei.com, zhengqi.arch@bytedance.com, zulinx86@gmai.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Takahiro Itazuri <itazur@amazon.com> writes:

>
> [...snip...]
>

Brought this topic up on the guest_memfd biweekly today!

>
> Agreed with both of you.  I'll adopt the filemap-level approach:
>
> - Move the zap/restore hooks from guest_memfd into filemap_add_folio()
>   / filemap_remove_folio().
> - Tighten AS_NO_DIRECT_MAP semantics so that, for folios in such a
>   mapping, the direct map is invalid for the entire time the folio
>   resides in the page cache.
> - Drop the per-folio KVM_GMEM_FOLIO_NO_DIRECT_MAP bookkeeping in
>   folio->private, since the existence of the folio in the mapping is
>   itself the state.
>
> On each guest memory population path,
>
> - memcpy-based population from userspace goes through the userspace
>   mapping of guest_memfd, not through the kernel direct map, so the
>   filemap-level invariant doesn't affect it.  But this is slow, which
>   is what motivated the write() syscall support.
>
> - write(): meant to speed up the userspace-memcpy case above by doing
>   the copy in the kernel.  I believe Brendan's __GFP_UNMAPPED/mermap
>   work [1] would give us a low-overhead way to get temporary kernel
>   access to an AS_NO_DIRECT_MAP.  Landing mermap may take a while, but
>   this series does not introduce the write() path, so mermap is not a
>   blocker for now.
>
> - kvm_gmem_populate(): this is a TDX/SNP-only path, and NO_DIRECT_MAP
>   is not available on those VM types =E2=80=94
>   kvm_arch_gmem_supports_no_direct_map() returns false for
>   KVM_X86_TDX_VM and KVM_X86_SNP_VM, which are its only callers
>   today.  So it doesn't interact with the filemap invariant IIUC.
>

I'm a little bit uncomfortable this statement since it seems to say TDX
and SNP aren't taken care of. Would just like to discuss (for
a line of sight to SNP and TDX support):

For non-in-place population where the source physical page is different
from the destination physical page,

+ TDX: the TDX module does the population and works with physical
  addresses, so no issue with populate? Other parts of TDX may have
  trouble though, but that can be handled later.
+ SNP: sev_gmem_post_populate() does a memcpy() after using
  kmap_local_page()

Would mermap be a drop in replacement for kmap_local_page() here? Would
guest_memfd need to force a TLB flush after mermap+memcpy?

> So, unless I'm missing any path, adopting the filemap-level approach in
> this series should be fine.
>
>
> I'd like to consult with you folks on how to proceed in advance.  In a
> separate reply on the cover letter thread [2], Lorenzo and Sean
> suggested that the mm pieces should go through the mm subsystem:
>
> On Tue, Apr 21, 2026 at 04:36:00PM +0000, Sean Christopherson wrote:
>> Yeah, when the time comes, the mm pieces definitely need to go through t=
he mm
>> tree.  Ideally, I think this would be merged in two separate parts, with=
 all mm
>> changes going through the mm tree, and then the KVM changes through the =
KVM tree
>> using a stable topic branch/tag from Andrew.
>
> I see two reasonable paths to get there, and would appreciate your
> input on which you prefer:
>
> Path A =E2=80=94 validate on KVM side first, then split:
>   - Post v13 as a single series on the KVM list, gather feedback and
>     make sure the design is acceptable to KVM reviewers.
>   - Once v13 looks good ("the time comes"), do the MM/KVM split,
>     rebase the MM part onto the appropriate MM branch, and post the
>     MM part to linux-mm to build consensus with MM maintainers.
>
> Path B =E2=80=94 split early and seek MM consensus in parallel:
>   - With the filemap rework already in place, do the MM/KVM split
>     now and post the MM part to linux-mm directly.  The KVM part follows
>     on top of a stable topic from MM.
>
> Which of the two would you rather see?  Happy to go either way.
>

Vlastimil pointed out that there's a temporary limitation now that the
mm-tree cannot do stable branches shared between trees now.

I think it depends on how quickly you plan to refresh this series, but
Path A wouldn't be blocked by the temporary limitation.

My opinion would be to go ahead with a new revision (Path A) to fully
address comments before splitting the series. Any Reviewed-bys can be
carried over to the split series anyway :)

Alternatively you could wait till conversion lands :P Either one of us
will need to do more work for conversion wrt direct map removal.

>
> [1] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd=
54f41@google.com/
> [2] https://lore.kernel.org/all/20260506080753.14517-1-itazur@amazon.com/
>
> Takahiro
