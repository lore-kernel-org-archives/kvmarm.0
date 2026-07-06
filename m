Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162963A6F1A
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335496; cv=none; b=URw/5bBpTiJUhT00Y3hBiDYZomxT+sQy8ljRm+IP+8cSuN4FRmaaTq8cZE8wdjgJlOGS3So+G6FVBd99N2YutzdNwT6qgl9IR7RGqxFJrb1hKr850CNkeHZzRTWdww5qhCunhgDdS6ZrxsHedsTxGi6ds/FLCYRj60jL3Aos2NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335496; c=relaxed/simple;
	bh=WHI8x60uj9Dpy83ZlmDJ0prQa2yKpaPT6/lcKL4FZkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UdsYmB0+IsyCK6u7qSNO1l117w1BzKtveOKTSIWdWVoajkrFKm+YZGBT9ZYhEyUCZeEPlpq4bI/mAdC93XfuvcPGMR/KDgH4YdnruuhLCdvwO40fMVO2x6KqFrN8rIM3TBaMhwhQNgi46u+iQNo7W/D6Xxq8fZj+PRcag5Np8Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hhTXLbJo; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hhTXLbJo"
X-Forwarded-Encrypted: i=1; AHgh+Rr0KAhpJTvnkza+uzkB+/4mzPRx6Y2gbq8Kjj9uVITacZdrTXJgoikiym9ItSoSTL2wdLdD7hA=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783335489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLSdkB9bSgwejzZC8jZha1t2xigu8Sl8JpF8BfGYcUI=;
	b=hhTXLbJoH+8BEEn/T8y4lTpEPjGDaRnu4sOb5nh57EcGcaI0OJlS/o2llq7yVaVeChfAJh
	X26u0911tuvLRmV2Juga7xC/zCwKNfcCe7KCQCDwRJ0HPgMZTA/K8/pUfatyRCx/wR/r6A
	mqtOi4lLpkjL9mJPE0cZmvbb/wtHwgU=
X-Gm-Message-State: AOJu0Yz2iHWoL+L+sgIIfG3kQN2vGl/OUBoeqWI0+42Q/w9yd+r8dh9r
	E4XGsYcxGu0/kW0qzsZ9ER8zNrryLAjgcAXLQnE50NNWlumN+ogm6+hpJfDWHWXJN02Dx7VxX+L
	o+YJB1L7mJu34YYPmMO/x4XBPthRQfJFD0ajaxqrM
X-Received: by 2002:a05:622a:5909:b0:51c:e80:9e88 with SMTP id
 d75a77b69052e-51c4c0dc8c9mr16396681cf.16.1783335471822; Mon, 06 Jul 2026
 03:57:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706083555.302972-1-fuad.tabba@linux.dev> <20260706083555.302972-3-fuad.tabba@linux.dev>
 <9cb2a188-0bee-4433-b850-6a9fc1da6463@arm.com>
In-Reply-To: <9cb2a188-0bee-4433-b850-6a9fc1da6463@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 11:57:14 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyGq7Zk1aEvb6U9yPNFNrgrUEqvnzMKjz7=Hjcbp1u_9g@mail.gmail.com>
X-Gm-Features: AVVi8CdRY9-sux-4B5rCgsfsq9txiWVB81wINQISkXCCA3u9as8HDxEEC3G47Ik
Message-ID: <CA+EHjTyGq7Zk1aEvb6U9yPNFNrgrUEqvnzMKjz7=Hjcbp1u_9g@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 2/5] Remove newline from end of die() aborts
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 11:54, Suzuki K Poulose <suzuki.poulose@arm.com> wrot=
e:
>
> On 06/07/2026 09:35, Fuad Tabba wrote:
> > die() already adds the newline at the end of the string.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>
> While you are at it, there are plenty more die() with \n, worth fixing
> them too ?

I fixed the ones relevant to this series. I'm happy to do the rest, if
Will doesn't mind the churn. One commit or multiple ones?

Thanks for the review!

Cheers,
/fuad

>
> $ git grep "die(" | grep "\\\n" | grep -v util
> arm64/kvm-cpu.c:                        die("32bit guests are not
> supported\n");
> arm64/kvm-cpu.c:                die("What's that mode???\n");
> builtin-run.c:                  die("Unable to resolve program %s:
> %s\n", src, strerror(errno));
> builtin-run.c:                  die("Pathname too long: %s -> %s\n",
> src, resolved_path);
> include/kvm/fdt.h:                      die("Error creating device tree:
> %s: %s\n",     \
> kvm-cpu.c:                      die("Pause signaled for already paused
> CPU\n");
> kvm.c:                  die("kvm__arch_setup_firmware() failed with
> error %d\n", ret);
> powerpc/kvm.c:          die("Couldn't map %lld bytes for RAM (%d)\n",
> powerpc/kvm.c:          die("Can't allocate %d bytes for HPT\n",
> (1<<HPT_ORDER));
> powerpc/kvm.c:                          die("initrd too big to contain
> in guest RAM.\n");
> powerpc/kvm.c:          die("Couldn't create RTAS FDT properties\n");
> powerpc/spapr_hvcons.c:                 die("term_putc_iov error %d!\n",
> errno);
> powerpc/spapr_pci.c:            die("error making bus subnode, %s\n",
> fdt_strerror(bus_off));
> powerpc/spapr_pci.c:                    die("error making node subnode,
> %s\n", fdt_strerror(bus_off));
> powerpc/xics.c:                 die("Invalid server number for cpuid
> %ld\n", vcpu->cpu_id);
> riscv/fdt.c:            die("Invalid CPU type %s\n", arg);
> riscv/fdt.c:            die("No way to generate IRQCHIP FDT node\n");
> riscv/irq.c:    die("No IRQCHIP found\n");
> term.c: die("term_poll_thread_loop: error polling device fds %d\n", errno=
);
> term.c:         die("Unable to create console input poll thread\n");
> virtio/mmio.c:  die("Unable to generate device tree nodes without
> libfdt\n");
> virtio/vhost.c:         die("Unable to start vhost polling thread\n");
> x86/boot.c:             die("firmware image %s is too big to fit in
> memory (%Lu KB).\n", firmware_filename, (u64)(st.st_size / 1024));
>
>
> > ---
> >   util/util.c | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/util/util.c b/util/util.c
> > index 6f41e2c..05d49c4 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -128,14 +128,14 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char =
*htlbfs_path, u64 size)
> >       unsigned long blk_size;
> >
> >       if (statfs(htlbfs_path, &sfs) < 0)
> > -             die("Can't stat %s\n", htlbfs_path);
> > +             die("Can't stat %s", htlbfs_path);
> >
> >       if ((unsigned int)sfs.f_type !=3D HUGETLBFS_MAGIC)
> > -             die("%s is not hugetlbfs!\n", htlbfs_path);
> > +             die("%s is not hugetlbfs!", htlbfs_path);
> >
> >       blk_size =3D (unsigned long)sfs.f_bsize;
> >       if (sfs.f_bsize =3D=3D 0 || blk_size > size) {
> > -             die("Can't use hugetlbfs pagesize %ld for mem size %lld\n=
",
> > +             die("Can't use hugetlbfs pagesize %ld for mem size %lld",
> >                       blk_size, (unsigned long long)size);
> >       }
> >
> > @@ -144,10 +144,10 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char =
*htlbfs_path, u64 size)
> >       snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
> >       fd =3D mkstemp(mpath);
> >       if (fd < 0)
> > -             die("Can't open %s for hugetlbfs map\n", mpath);
> > +             die("Can't open %s for hugetlbfs map", mpath);
> >       unlink(mpath);
> >       if (ftruncate(fd, size) < 0)
> > -             die("Can't ftruncate for mem mapping size %lld\n",
> > +             die("Can't ftruncate for mem mapping size %lld",
> >                       (unsigned long long)size);
> >       addr =3D mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
> >       close(fd);
>
> For this one :
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> IMPORTANT NOTICE: The contents of this email and any attachments are conf=
idential and may also be privileged. If you are not the intended recipient,=
 please notify the sender immediately and do not disclose the contents to a=
ny other person, use it for any purpose, or store or copy the information i=
n any medium. Thank you.
