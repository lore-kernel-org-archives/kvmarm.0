Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF9615D4
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 01:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707441743; cv=none; b=Ij2JpkrK5XH9vpHerzdFWdjmStvv3F10IgXsXu5JngdSfrn7kDdi/Rx1vlx0wuTBtlh6y39owlPGfhOThTgiebv1m7vdE9uhNHS2D1Bd3XFSjkAa5q5p/MBFjy41WO0JxW5fC+3bT65EvHzMYvJLMraze5Der5mo/BasijKJDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707441743; c=relaxed/simple;
	bh=/TR1cJLKRZ7qu6VO47XamR64YLXHPgzQDbOxb2ul2qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IEH2dNkcAkqaVGaiC7UQtb+v9FftJu1so+n3Lo3v4SR6FomQvsXSssTKK/V13Y1DaU6Y2vjXP7B1joixMXe7KlxmTpjstAg9pBH1PfMl2iVWPh4wcRSRS+DbN26okThpL4nvvlpO9YPYgupMZPsNWnLGCiu9OaYippDwnmruY5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cfMYY44R; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cfMYY44R"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-204235d0913so226035fac.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 17:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707441741; x=1708046541; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bYUdUfxiMsyMg1eLJUlGCPzcBcDEpAd2dqR1EO83KU=;
        b=cfMYY44RkIM60y8i7EfXNfXfA30UCBhC2wjRY01Ww/vm4373LYwfP/0qJnYA663bVl
         UmXNtuUZvsoBMaktzpZisYcFn/wBf1471ervvLA8qE/PrIGZsScDGQXiChCJENx6Gxqm
         /Od1wlv117wj93L64+v03IcPYpZ93XkvezZX4n6GGVNvg2xFo8pgwLHTdHK1vv6AjVi2
         /HrPGz9h86K+Qn7LTE3Rnf9khGAMrISal/iYXJ4vkwpqwFFqRHNXU/ub1rqAJUXWgfwR
         9WsDTi++CDm53I3G62ILAS8VQGRouml6Xc1Q0La5uEBBarjX7ed2gciIavsRHQeWMFL0
         c/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707441741; x=1708046541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bYUdUfxiMsyMg1eLJUlGCPzcBcDEpAd2dqR1EO83KU=;
        b=ejQUpPIVX6PCByU8E0QkxD9iu2CLQONof9F/8/XxlhZTdtHLPkxVKAz+VSho7CUulr
         cbBhv6l5sNkIyy6BewmwpGmcKio/fq1/du5zfGtZzMBhl7UWD+rqsVhEweYheaQZZavG
         R7qPw8PVCcg7NpY/GT1T9a40IjI5xerPw9o5rjnvu0daw1EnHdXbMldBAVe9QPRKpXs5
         svrhwudNO6SRniALDLtqAomHfTMRhAMTHmoszKIW58PFgWyHMCTWFvdNLwYen3QLfdE3
         7QVTWGtWdZK5lD9u2KJTpECB98p0PbNkfMi9z8JkKY4/7WYPAFpzW4peRgemig78AXa2
         aouQ==
X-Gm-Message-State: AOJu0YzFo803AOI7btFDpbDtlfStWaBSYBHnfgWOYTW2V/Z2pPmncAN3
	wOxtVYie+UGysfBHEmawU+c3JjUVL2OPYcBG35TwZsbu6Qvf/650rN6Xb+Q0SGH890SPlx1ofjO
	WU5LvmiIEe9VewZWHb+UuFjR4GpXnlDW2BB36
X-Google-Smtp-Source: AGHT+IFSxFEFm392BLtgCppQjIi7plXowCwt6ua6fM2hmnZz5cd9La9OdUzvHyKYI93f8vW4Jx6A2frmFsO0KFzpH1Q=
X-Received: by 2002:a05:6870:4725:b0:218:5017:af07 with SMTP id
 b37-20020a056870472500b002185017af07mr208303oaq.0.1707441740910; Thu, 08 Feb
 2024 17:22:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-10-amoorthy@google.com>
 <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com> <CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=Yo8u9TZEuDTEtCV6qw@mail.gmail.com>
In-Reply-To: <CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=Yo8u9TZEuDTEtCV6qw@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 8 Feb 2024 17:21:43 -0800
Message-ID: <CAF7b7mr12opfJTTBC_kt1yoUWTKAV91Q8MrHk8_0ttQsXn9G9w@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 2:38=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Tue, Jan 30, 2024 at 3:58=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > I think that either (1) we move this kvm_prepare_memory_fault_exit
> > logic into the previous patch[1], or (2) we merge this patch with the
> > previous one. IIUC, we can only advertise KVM_CAP_MEMORY_FAULT_INFO on
> > arm64 if this logic is present.
>
> Actually (sorry, about-face from our off-list chat), *does* it make
> sense to merge these two patches?

As per [1]: yes, it makes sense to move the kvm_prepare_memory_fault_exit()=
.

So for the next version, the description is also going to change a bit to

> KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
>
> Prevent the stage-2 fault handler from faulting in pages when
> KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
> call to check the memslot flag. This effects the delivery of stage-2
> faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which userspace
> can attempt to resolve without terminating the guest.

> Delivering stage-2 faults to userspace in this way sidesteps the
> significant scalabiliy issues associated with using userfaultfd for the
> same purpose.

[1] https://lore.kernel.org/kvm/ZcP_JHsMJUlvjAs1@linux.dev/#t
