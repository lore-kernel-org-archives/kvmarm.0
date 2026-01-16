Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F40233986D
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578067; cv=none; b=NXStgy7Z4IqeReJ86lUoGW+VqX34yavWq3gGOqfoecxUl8jVEEEfXEZldAfFk0uWqsN19orzjTlomvHThzH3OXgK06gubqIr+eYcsfy38B0pNpTDYJeSCyUA3CJ0c7flCNuqhc2mUvPHPYP+aZbZ8UbOCf3ephc5L0hXhuGwsh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578067; c=relaxed/simple;
	bh=cbz4P0q8LjyF0OVI7OVejj9Lnkf5fBOIA9+hzT8ibrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iOptkY95HB5pqA/PLdM/mcnBdWqvvzMWandUDlEJPvhZo2N7XANEMksWB3mhfwU8ffAfCRncizDO6VnV28DN6M4cn7XInzmLG1bvA5s2B8hdGRyB+m5NjFGGplZ+sSc1sdGcAwOal47okiybr/v4icfvfxDZNILLyftGbxteocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pSKvtucV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pSKvtucV"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a090819ed1so14812395ad.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 07:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768578064; x=1769182864; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cbz4P0q8LjyF0OVI7OVejj9Lnkf5fBOIA9+hzT8ibrU=;
        b=pSKvtucVBrMZzx3jRvvIMA69qtaOJRWgTveueQ3wG8dPSVJ+6QqOONB5elTYBv+AcH
         /G8A7Hsj353vG6R/+oUqIWx/U1iKpHMm/MXoYTW6QPQz+AdT4+uwexwWlYJBPslbPmcn
         VuGUTQJbT+UZOZgjIfCLttmMmTEu7ZKUkKEdgOei1TxQE/4FnxXpaft2i9TZRhSb3Bzw
         s6W1jT2xUw1oAAK9d4yvi2Ulo/oo5qXMACzSgZVVvqXTEc44Veh3e3oZz3s4eHdP/Z4d
         IFNsrRYdaXL55yPK+rtEHHs7Us5yrj45oWK4Cs436T3UvjXioD5oeRR6HNDNBQjGExPl
         vVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578064; x=1769182864;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cbz4P0q8LjyF0OVI7OVejj9Lnkf5fBOIA9+hzT8ibrU=;
        b=ezxudHBsMbqywBNKk7bCodQnIsz8hnOKtm+uchPastf8lRYsALYyn6NnYdKDThLioT
         rEKreRDxldDdQ2WxzXH7yf58hGVGOJf59J9E56CSIYXVQfyAzenPtYFMgoGhr5gEj6dj
         3noS7+GgUJmJcOkl82oC1JokfuDVALU+w7Q7EbaseHPPlpcw6IjQD4a1BPUdAd+WNSCa
         RwfaYZUfBP8YuIvZH77SQnKSvWKlLaX7Et5QBPOPnGbIshFyhXsMtfui2eVgwLcQr3zg
         BkumCsPr6OZ0uUwnMvnCHyccEf2IH6tOYZej7nFAJUp0hEfM0SIcxafYFiygahxTY8Do
         Fscw==
X-Forwarded-Encrypted: i=1; AJvYcCUHJBmg6/AKXI+r1+MWjkySOuFlcVYcy6VqO9lpuRdbQgd3/r2OoGWS/yA6d3d4uUnN+p2q/fA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyotsbPouCNt9vVTHOPd13bxW3l1aJIYbLKSx5bLC3+WfwztVaI
	qhzdGvg7T4Skrd54ByoZ4HRkkQtLyUZb2ql9n5aGKJMqaOQNtWRecQMYNycA3hTGr4AWFre5RBo
	bx187Bw==
X-Received: from plss10.prod.google.com ([2002:a17:902:c64a:b0:29f:68b:3550])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf07:b0:2a2:bff6:42ef
 with SMTP id d9443c01a7336-2a7174fa860mr37848805ad.7.1768578064299; Fri, 16
 Jan 2026 07:41:04 -0800 (PST)
Date: Fri, 16 Jan 2026 07:41:02 -0800
In-Reply-To: <4781ba9c5d16394cdd785d008cf2a2d81c5cda35.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <208b151b-f458-4327-94bc-eb3f32d20a68@amazon.com> <4781ba9c5d16394cdd785d008cf2a2d81c5cda35.camel@intel.com>
Message-ID: <aWpcDrGVLrZOqdcg@google.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kalyazin@amazon.com" <kalyazin@amazon.com>, "kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "david@kernel.org" <david@kernel.org>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "jgross@suse.com" <jgross@suse.com>, 
	"surenb@google.com" <surenb@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org" <ast@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"peterz@infradead.org" <peterz@infradead.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jthoughton@google.com" <jthoughton@google.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"prsampat@amd.com" <prsampat@amd.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"andrii@kernel.org" <andrii@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"will@kernel.org" <will@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026, Rick P Edgecombe wrote:
> On Fri, 2026-01-16 at 15:02 +0000, Nikita Kalyazin wrote:
> > > TDX does some clearing at the direct map mapping for pages that
> > > comes from gmem, using a special instruction. It also does some
> > > clflushing at the direct map address for these pages. So I think we
> > > need to make sure TDs don't pull from gmem fds with this flag.
> >=20
> > Would you be able to give a pointer on how we can do that?=C2=A0 I'm no=
t
> > very familiar with the TDX code.
>=20
> Uhh, that is a good question. Let me think.

Pass @kvm to kvm_arch_gmem_supports_no_direct_map() and then return %false =
if
it's a TDX VM.
