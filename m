Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0C53033D8
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335626; cv=none; b=o9QYJh9AsRljCPUyu3YxzYL7TkrusPmErJ+iTDXnmLcNNApQAZ4BTfWwMlsMYLAOtoq1IDOQLD+XF7ZqiF2fIqJf3KDe15KcI/eVz3eYJHc6/kwxw0nEmE29H/Zb5MJ9CtG1J+5IJEccLVBcn8h4UEoqdpGEN1SPdRt3lZMQlLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335626; c=relaxed/simple;
	bh=GX3YG/WC75wUxUB2X8bgmD4zZIgglMM75TE9ngmmPzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kzp9VXaWL7JSgnHEvPE0MsEKCwdltsfoABX7Kl5Ha5FEJbmZ422qTPy5B0P8FE184oIm+AC9E3uNmaLuAaBVqhYv/j0F7yTd/h+1FkyNzt2ZcDrMii1wvkaE3kFugs7AZXTle1bk9Q9uZfWBI32j+HEsj7lQBHUEuMOWVHdU1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EjTc8OzO; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EjTc8OzO"
X-Forwarded-Encrypted: i=1; AHgh+RqURWeBHsfiRFtV/AutrJONvw8dsNE4s+z95QUnyW63bF2gR+4X5UZBc+WBAlkiDfPZrzNBXYM=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783335621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7OlEr7nmKBn/y6kvVk1OfCsj5dOnwgAwBR2R6l8OA4Y=;
	b=EjTc8OzOtzKQnnpfFRvmMqwta7JZYLXghbmRF7+ccapgFs53eXPmGQ3FVQPFMKhfUIzu1l
	j2zHUyb4RpfwOwwUOdP2+KRGHmjqkeuz91B4P50Z1+dR17/qNoWcRj+R47KDKU3tZBmOvl
	yIKPcIDH668Zzoob9SePfr8jZT/qpWE=
X-Gm-Message-State: AOJu0Yy05q6hB5KFObcogGBELKvfisqHEv1mmuxaR9T0oBYzmvJ+51Pn
	qpZmpxKLfqAqTKUzfIazCR1oZRpSnBMvJIRErN/E6P6wM1u9CG0W8I2sZ7r+Od7NwdkkR9cmFkq
	V8j+Z3SgKBb5lX+aGpIznYKAauMPcnuXpqi2NC+ey
X-Received: by 2002:a05:622a:1495:b0:51b:fd5e:e81a with SMTP id
 d75a77b69052e-51c4c11552dmr16883651cf.20.1783335600722; Mon, 06 Jul 2026
 04:00:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706083555.302972-1-fuad.tabba@linux.dev> <20260706083555.302972-4-fuad.tabba@linux.dev>
 <556ab72c-f440-434b-a24d-84200bd25842@arm.com> <akuJ_eFvDHLpiU-Y@raptor>
In-Reply-To: <akuJ_eFvDHLpiU-Y@raptor>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 11:59:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwFtJZS0NDh1Tv6bw8DMs3YRAqVKetrztkNy0O54dCbqA@mail.gmail.com>
X-Gm-Features: AVVi8Ce2Ka6waj2cBqI-M4kN04FiJ4ndSVrEzTZfMt8w2Ei40AfTrmOzgRTb_z0
Message-ID: <CA+EHjTwFtJZS0NDh1Tv6bw8DMs3YRAqVKetrztkNy0O54dCbqA@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all
 memory registration
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 11:57, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Fuad, Suzuki,
>
> On Mon, Jul 06, 2026 at 11:23:47AM +0100, Suzuki K Poulose wrote:
> > Hi Fuad
> >
> > On 06/07/2026 09:35, Fuad Tabba wrote:
> > > Switch kvm__register_mem() and kvm__destroy_mem() from
> > > kvm_userspace_memory_region to kvm_userspace_memory_region2 and
> > > KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
> > > superset; when the extra fields are zero, the ioctl behaves
> > > identically to v1.
> >
> > Doesn't this break using this on older KVM implementations ? Not that I
> > care, but do others care ?
>
> I haven't had the time to review the series, but I do care about this
> change, I find myself from time to time testing old kernels.
>
> I think the two ioctls can coexist without much maintenance burden. For
> example, the usage of KVM_SET_USER_MEMORY_REGION can be kept as-is and
> KVM_SET_USER_MEMORY_REGION2 can be used only for guest_memfd in
> kvm__register_mem().
>
> Thoughts?

Already did that. I'll wait for more reviews before posting V2 with this change.

Cheers,
/fuad

>
> Thanks,
> Alex
>
> >
> > Cheers
> > Suzuki
> >
> >
> > >
> > > This prepares for adding guest_memfd support.
> > >
> > > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > ---
> > >   kvm.c | 11 +++++------
> > >   1 file changed, 5 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/kvm.c b/kvm.c
> > > index 95ccfcb..8a7fd09 100644
> > > --- a/kvm.c
> > > +++ b/kvm.c
> > > @@ -189,7 +189,7 @@ core_exit(kvm__exit);
> > >   int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> > >                  void *userspace_addr)
> > >   {
> > > -   struct kvm_userspace_memory_region mem;
> > > +   struct kvm_userspace_memory_region2 mem;
> > >     struct kvm_mem_bank *bank;
> > >     int ret;
> > > @@ -213,14 +213,14 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> > >             goto out;
> > >     }
> > > -   mem = (struct kvm_userspace_memory_region) {
> > > +   mem = (struct kvm_userspace_memory_region2) {
> > >             .slot                   = bank->slot,
> > >             .guest_phys_addr        = guest_phys,
> > >             .memory_size            = 0,
> > >             .userspace_addr         = (unsigned long)userspace_addr,
> > >     };
> > > -   ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> > > +   ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
> > >     if (ret < 0) {
> > >             ret = -errno;
> > >             goto out;
> > > @@ -239,7 +239,6 @@ out:
> > >   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> > >                   void *userspace_addr, enum kvm_mem_type type)
> > >   {
> > > -   struct kvm_userspace_memory_region mem;
> > >     struct kvm_mem_bank *merged = NULL;
> > >     struct kvm_mem_bank *bank;
> > >     struct list_head *prev_entry;
> > > @@ -320,7 +319,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> > >             flags |= KVM_MEM_READONLY;
> > >     if (type != KVM_MEM_TYPE_RESERVED) {
> > > -           mem = (struct kvm_userspace_memory_region) {
> > > +           struct kvm_userspace_memory_region2 mem = {
> > >                     .slot                   = slot,
> > >                     .flags                  = flags,
> > >                     .guest_phys_addr        = guest_phys,
> > > @@ -328,7 +327,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> > >                     .userspace_addr         = (unsigned long)userspace_addr,
> > >             };
> > > -           ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> > > +           ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
> > >             if (ret < 0) {
> > >                     ret = -errno;
> > >                     goto out;
> >
