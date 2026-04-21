Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCAA33F8B4
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776791344; cv=pass; b=T2zjOdHlqqQDQ2vPjXR4UwZ4ZQWdUivBYsH6lqC+2zUaWW+hWhtc1Gb5QJCJZYyf9WzWlPOdPvpFQ8o54qObTulyEqkl2EfzU6phneQLChTsdD+ypFu52bo+AiMvMvn9Niv23OOu18la9hvKfUiWsVenG+J2nlzZyKjbOLTELlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776791344; c=relaxed/simple;
	bh=fX/Sz0zC6ezU75jh9T36eNVptRuVVrhH7wuRuIMNVVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YvLdi6opXZYsm53TmIDkZSXNa3qj6hD3Qg2hyuWYOxGLF7V1ocHbTtfo8ZpORF2srubGe7NV/Z4/272d7ctCyuChE+dgH4WJBLWnWT0MENeMgd2IAZc0emaprW7d7au8SIKqpjWBnf2kfSDQdgYANc2GRQ77l1p75nHFOb2bXEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTvsS5QU; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTvsS5QU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso251385e9.0
        for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 10:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776791340; cv=none;
        d=google.com; s=arc-20240605;
        b=TrxvujouQQhg8iAGfuJGRzK3EXxqreFbchV+tlpCcG6kVI6N7Q6iStx0XovoO4KvE4
         VY96BSa5gN7ureYoIQHPVsm5N8uu2KRK5w1ttyPNbswPrJ3VTDrKJBwUdc/cf9FFQhxP
         GQ7X/a7V6zNHBBgI5+/7IvSaxVYHaK9fx3eRv2Tuu9+0tKyostyJJCfTfMc61q2ySC/0
         sdmQh34+QUftHw4IJmkiLI/+O8ZQtd3GhwSmrccQfsEbhmzt9zU0LwdorPZVI4+nSZ2Z
         WzXJarACVDI1u/DCbWjpAyG+lYq3lBOCkG1R1ld5jqD/MUnrXREVIaKilZUGqqOwPQpu
         CLow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
        fh=uZOVLpafzsynkvnPWx9ovsgVNHqqpqkO8Tlzm0EypMM=;
        b=C+WlyCDAMQ1hX4DT6too2lb5bkHAKI3sTetzgSDbeosbJqZ812CitvB0oVykqnqUVg
         w7EVVkPn6gJa6YDX0VwM1+88++eK3esOA2nY2fEjXCmxiFkB6t2PP03moOzjF+crQUr6
         B2bodkOMNjnuonDSwGtlWOvpUJaz4l9X1Qim/XBMNYpptI0VIyxtlZWJXn7kVOgXR6ms
         A4BBqYpbgvLIHbF1l0QYPEMjEiRhHZd3bg4B2g9STVeS/q6NCdbsge4umolSTabSvDYF
         h8pt29+a7DYAVO/A5ACKgsHDMLzreXuChJbCCvK/W3UDYmqxRXMnEQnlpBoKn4xMLhSa
         sTOQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776791340; x=1777396140; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
        b=GTvsS5QU0MYKj2Dn0NTDBw3WGPaizB8hn+c+t/1kOSuaRnc4Q7k0uU9Eb1SxbWQGwM
         9M+2pVG7ZG9dECBTyRhyeWvwFzMxPXBKmwF5ITktDxna+/Y0kcjYZbHVlbDz+JEenSvw
         VBB24IBR5uli13mPWu9aF5dUR33IAFmdmnlEouf6NX7cBZEQu4bbkx0qo1BSi8VqSGIw
         NgavzYMgXwEo6cn61ig1I1IAkjRzmTJmb5iqJDn9DNaLABjYWQFpJCsNbfbCt/WdpdJo
         JWfbtleeijK7R/VnqrGDcVYyniUG3dfqy3DH8sCr9MbzODC0NbP2LZQJHx/XFOlyu7bA
         juRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776791340; x=1777396140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
        b=eHv83dvlug5QvzUtrzSqhqJcr1fJvYD8E2tDVghnzzJNxX2Uj6ie+7fApUSN09SnxK
         DSWKEGyClUrmi/Ks4fq7ZR5VWLxP+lx4p4GvlIYf9pi3kE50YRiMrNTq4Vokuetwh2mz
         x4JSlKkBRU+5dXmXRWsy7+aYGCDc9kapQhW+IwQwh7PpuHIV3UkNYk7Y6hCSnkpQE5ri
         ys/63WP+iNNudhNC/xHEkukUWFkbQhXABsQeHVKhL3ozrfRzKJ7MeR0zxSRRwAjDTaAp
         ubbghbGyLnam7az91+oKOhi7KIf3RR7gjTjyGcHzJdMIGQAal8FBufQaHmhKHCy9sIle
         WPDA==
X-Forwarded-Encrypted: i=1; AFNElJ/YRX6uTGqaH1zZSZXE8M0DPFODY9nKCK4wTlj5z7Bv7IBQK2feEOCuBSyYF3OuU7aTshMJ0Ec=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+S49nBGzLuugY3zhhuJP6EiUqGZV34fDwNMDtOWVBPRrkYm1y
	HyBFRuV2d1YfnKpj9HEYTy/krALg7E7GZvT4fBIaPx3GsduBSJFAMoDsMhwOazoZM0nSvxivkg9
	l0slfVyaL4ZOPdhxgyH5GnaeSJoJOP6+fJajlq1x/
X-Gm-Gg: AeBDiesbklgfusC6iUsvRMEOcfJgGwAjaMxdjPd0LQwBK85Jc/66M3SmdBpOzZYFP5B
	WdTQaDCFNCNByDaIDPXB2rknjy0rhWaW6rd7JbB9tvkMOu64bo+HUvbtpkV+6BlpHWHWlML4A7o
	oUDBAfiQEj4UcgJQDj+QMAmIfsZMW4ZLLX9f2yisQhv3Mq+5OBBgvTvTPV6PLupSVdKFW1Q42Xm
	hhJAu3PrrrLXCV4hbN881/KvbJTLOOmlq9GJrYibIeqlPgkjOAfFQj8Cof5P4y7Ui3qjdXbr+6I
	z2pJpInkaPwnrebIsr0uFViuq+95oT/ciy96Ytw=
X-Received: by 2002:a05:600d:6443:10b0:488:c4b2:e832 with SMTP id
 5b1f17b1804b1-489013bd895mr2808755e9.3.1776791339707; Tue, 21 Apr 2026
 10:08:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260410151746.61150-1-kalyazin@amazon.com> <20260410151746.61150-11-kalyazin@amazon.com>
 <aeemS2wm38Cm4qAf@google.com>
In-Reply-To: <aeemS2wm38Cm4qAf@google.com>
From: Frank van der Linden <fvdl@google.com>
Date: Tue, 21 Apr 2026 10:08:48 -0700
X-Gm-Features: AQROBzBifkAsQzS0X3Z1RL6hHFJu96bsJJpCRfOrgFmfYjKrDR-uZJ-l8nIAe34
Message-ID: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: Sean Christopherson <seanjc@google.com>
Cc: Nikita Kalyazin <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Takahiro Itazuri <itazur@amazon.co.uk>, 
	Derek Manwaring <derekmn@amazon.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 9:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Apr 10, 2026, Nikita Kalyazin wrote:
> > From: Patrick Roy <patrick.roy@linux.dev>
> >
> > Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> > ioctl. When set, guest_memfd folios will be removed from the direct map
> > after preparation, with direct map entries only restored when the folio=
s
> > are freed.
> >
> > To ensure these folios do not end up in places where the kernel cannot
> > deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> > address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> >
> > Note that this flag causes removal of direct map entries for all
> > guest_memfd folios independent of whether they are "shared" or "private=
"
> > (although current guest_memfd only supports either all folios in the
> > "shared" state, or all folios in the "private" state if
> > GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> > entries of also the shared parts of guest_memfd are a special type of
> > non-CoCo VM where, host userspace is trusted to have access to all of
> > guest memory, but where Spectre-style transient execution attacks
> > through the host kernel's direct map should still be mitigated.  In thi=
s
> > setup, KVM retains access to guest memory via userspace mappings of
> > guest_memfd, which are reflected back into KVM's memslots via
> > userspace_addr. This is needed for things like MMIO emulation on x86_64
> > to work.
> >
> > Direct map entries are zapped right before guest or userspace mappings
> > of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> > kvm_gmem_get_pfn() [called from the KVM MMU code].
>
> ...
>
> > +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> > +
> > +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> > +{
> > +     return ((u64)folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;
> > +}
> > +
> > +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> > +{
> > +     int r =3D 0;
> > +
> > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +
> > +     if (WARN_ON_ONCE(!(GMEM_I(folio_inode(folio))->flags & GUEST_MEMF=
D_FLAG_NO_DIRECT_MAP)))
> > +             return -EINVAL;
> > +
> > +     if (kvm_gmem_folio_no_direct_map(folio))
> > +             goto out;
> > +
> > +     r =3D folio_zap_direct_map(folio);
> > +     if (!r)
> > +             folio->private =3D (void *)((u64)folio->private | KVM_GME=
M_FOLIO_NO_DIRECT_MAP);
> > +
> > +out:
> > +     return r;
> > +}
> > +
> > +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> > +{
> > +     folio_restore_direct_map(folio);
> > +     folio->private =3D (void *)((u64)folio->private & ~KVM_GMEM_FOLIO=
_NO_DIRECT_MAP);
> > +}
>
> Making guest_memfd responsible for zapping and restoring the direct map o=
n a per-
> folio basis feels wrong given the addition of AS_NO_DIRECT_MAP.  I especi=
ally don't
> like that the "rules" for when an AS_NO_DIRECT_MAP folio has a direct map=
 will vary
> based on the owner, and even within an owner (e.g. guest_memfd) will be a=
d hoc.
>
> E.g. as per the series to add guest_memfd write() support[*]:
>
>   When direct map removal is implemented [2]
>    - write() will not be allowed to access pages that have already
>      been removed from direct map
>    - on completion, write() will remove the populated pages from
>      direct map
>
> That's pretty gross ABI, because with KVM_GMEM_FOLIO_NO_DIRECT_MAP, users=
pace can
> write() exactly once.  To re-write memory, I assume userspace would need =
to do a
> PUNCH_HOLE or truncate.
>
> What's preventing us from handling this automagically in e.g. filemap_add=
_folio()
> and filemap_remove_folio()?  Then the usage rules are pretty straightforw=
ard: the
> kernel must *always* assume the direct map is invalid for folios from
> AS_NO_DIRECT_MAP mappings.
>
> Then if KVM needs to utilize a kernel mapping, e.g. in kvm_gmem_populate(=
), KVM
> could use dedicated variants of kmap_local_xxx() to deal with a local map=
ping for
> a folio/page without a direct map.  Or, KVM could simply disallow the spe=
cific
> sequence that would require KVM to do the memcpy (I'm pretty sure we can =
do that
> with in-place shared=3D>private conversion support).
>
> I realize that could throw a big wrench into write() performance, but IMO=
, before
> merging either series, we need a complete story for exactly how this will=
 all fit
> together, in a maintainable fashion and with sane ABI.
>
> [*] https://lore.kernel.org/all/20251114151828.98165-1-kalyazin@amazon.co=
m
>

I agree with this - this approach would also allow for memory that was
never in the direct map to begin with, or has been taken out already
(for which I happen to have a use case :-)). guest_memfd and other
code can then assume that AS_NO_DIRECT_MAP means they have to take
explicit action to map it if needed. It's a clean, simple ABI.

With the current set of patches, it seems like this couldn't be done
in a clean manner.

- Frank
