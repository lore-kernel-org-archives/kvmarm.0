Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F43576ED2
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063895; cv=pass; b=W0ewxdjvNIFNdtsSKPJCtlEnWMj/GzkIY7wvEYsNaYwqHvgq4LWSWhW6HcxnKHTYEqPUrKzbf6UBGHy9YTAjW2qAEnJuvwwtvMypDD82qcUelscKkkAopmi0330VdvjO1chcUFan7jELSaHaHDXsOaXPTfz5aMimhIxKmjDmc44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063895; c=relaxed/simple;
	bh=NT0Z/LF1SMhtkavx81DR2GGYYK6aB7iX5ZVgmCMPgvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKpO1BSIzXanHX4ajKDZSE6HacXj4ByF/Y8M6raJW30UmgHDCGpvXrvRaMRP7HNYG2cD1IwRxEdsZfsmY4qG1WKi9pLFnqdex1DkU+aM7UksFArlbOFE269RwpOgYpG5+BpV3Q9yswVsST7hP/UtbCNY6s4ySfoIdURRMYiD67U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WmbMiQPp; arc=pass smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmbMiQPp"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-46accbdfb21so15815fac.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789063890; cv=none;
        d=google.com; s=arc-20260327;
        b=VFh+VrTc2NvJjPF+cPMXCBrGMBnKhH9wUD3NGKNaoOpwC9DcJxUUkQbjnCWO0wDJRV
         0z9nTLS9SvXzWUwMPzGAOk6QoEYMs5ulgO74zI3SFvLeNRWdZ6ReBXxbN3p2O7Qbv2zz
         xX0P1oZWycn0HizzS+wjwsw9q6EoeI2IEKfGkf37uIsmMRt4wa7wxV18BYQQ7Xcb6/fG
         clwpCvCHcayFyt0Lm8oPuWgGBAjHi9EtMWsS0LnHKcIUqu6CMs7mZ07cNmaQXFQCpNVa
         0Sr6WxAd9AYfmJnZi6VNfd0MIvdstZoMZHK1ebyuuXjXqsIU79HxLOtClGFd2ghBz7rs
         x7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        fh=jk/AhfrPgaJdbUIoAM6b+aFfAR5bk9iLS/n3MCeMpOg=;
        b=nz2Hh/cqPwd0nF4Rknmg0/5EPCPDu9jbweFjbvz7y2D1aLPkJQZY+0ZdCDI1VrL3M7
         fHkihZmZJxt5nVJTbfBL+opXJ2htEo7bf40P5Xkfcv3q0O2MelLOB+XXaz3QW79ze8a9
         XEsPffmrPHFIz/OjDgu7HY03SAIxt9tQAdQ2eZDs1EhA9H+gkFnfi/YnLCj3wf4IaEjH
         +OEy2EbGWFNbVXiHZEDU8Yr/buBxbBYCi/TwTs5JDRbiSknTDoHy0qUk/5Vx9RIqaBnc
         AJslMdnZ/GAucX/eVPMjRw9ft5JCoBSjLHSYltSoDO0nlr0RYLEOKYnVya+6isAvyTOV
         bBVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789063890; x=1789668690; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        b=WmbMiQPpTjx4/AwV7saQP8HLwY3p92Znu4pF303th/n/PwC5Hr1MA19o5mmnvLJyF0
         EQpeLoEauDFc6Yjfn6m+dI5uiUDQrgqgxr2q9nHpq2dliLY3dLRF3/Ahq29a8v9+F5R7
         LNZNLAqRweeDTJ2MJOfX7s5wgm5l26blAgVBta+Y+doslM0n9h7H3bwM9d6x5HBZ70oY
         38Yu64XtkeQgOVtFvu01dXvN5Knc+gosRn3LtIlfMJfD4B4mC6gaMNXG7mHKFnpP3g2d
         ABh9QYwJulgkK2+OvWsX+XFWlqwQz1vBMIj+ED/OU22ej/Wa4zHftnt6ZmxwjeTA2kjd
         SgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789063890; x=1789668690;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        b=BR3jtApxIwL69rBm21dTwRvGw996dl+glCMtBfWtz1YWK/kW+nMuJGYGjXLk5XayLk
         Vat2TfGyqtCq3e6WCT8SV9ENbV9rKq5SuyCDox6Kp747zKPCAXrYc8aVgcucyfFJpSD3
         0NlJbo6WVxQVN4pYYDY/mb9ZtTBIOWGs+e56gtFQZ7kNyH0gWqCg5KWf5XHJyrm1cQc8
         uB+3yEcq/Y5a63VEnF8DWWpirOzx52IxSqNjoXGUrJ/lMTDzq1d5UB4e717AXWi4nReN
         KSSXf0NvVvX/rl1OabJTmtNterIpKjKNOxkE0x9M3YDlG9VWX+/BJAmC+3wv3ICfMpWB
         AL4A==
X-Forwarded-Encrypted: i=1; AKwUvBwrjbWszACpYqt0socaRKeLRTtNXzG6gDD1YAqWaYsiQWIsR80SOizrs4kpSZkg8Ut20fUChlE=@lists.linux.dev
X-Gm-Message-State: AFuF++lRsXH3lY+pfgD6PirBvhTrWpYBFH1CwR4nCQNZpG5akMw8zkvk
	RwddpS5fho+IND9dW+lI0MdIiuE5gbApo3kvLyfG8/OjuExUC2CLF1bKz4Ss+uzJh/KrCsLEP0F
	gIAEZnmM2oMaWJA9jVgPBqPtDg66i4jI=
X-Gm-Gg: AYBFou3ryMVZ1ezctaclOSemSCt5xzgAruyYcJDHyWjn78XFeLiPg3ysQ5hmJ74ES9R
	T9KMqx/GQj4OAEPe2t3cyi67dhCF6kpErvPFCtkL0EHmPmDVpDZyacfpHmpaIFgxV04SVFdtqjV
	gGFNLFnzDVWHkbycXYX0yE9zAEvfyC4/T82h1CeQ+DmJpvwGr4go3eEBad7ikKwDzKhorL/5bRh
	ywkr0vfsbGnd6doX19MJ6gkxXl9NnzuOwHZVWHdbeF+WWmckN8fWD64eIB3yULhL99mxA52LkI7
	0nuzyhqDhwKofSPlTkNB4sK9p+/qYYxCtPOVW1TR+Vo+JN9YxeN9+pY=
X-Received: by 2002:a05:6820:55d3:20b0:6b1:ac4f:f708 with SMTP id
 006d021491bc7-6c0bc1d3ad3mr241038eaf.17.1789063890425; Thu, 10 Sep 2026
 11:11:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 10 Sep 2026 14:11:18 -0400
X-Gm-Features: AcwNN1XLr_yN2lEzELD3PcXDse2cuW9BBHCwsQpnROCV_SxzPvFmiqhSaiK704I
Message-ID: <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
	linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 4:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

We should likely do something similar for the other sel_open_*() and
sel_mmap_*() functions too.
In particular, truncation of the status file can bring down systemd
since it is mapped by libselinux.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index c7d91476971c..545a6f89f9e7 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struc=
t file *filp)
>         struct policy_load_memory *plm =3D NULL;
>         int rc;
>
> +       if (filp->f_mode & FMODE_WRITE)
> +               return -EACCES;
> +
>         rc =3D avc_has_perm(current_sid(), SECINITSID_SECURITY,
>                           SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL)=
;
>         if (rc)
> @@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_po=
licy_ops =3D {
>
>  static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma=
)
>  {
> -       if (vma->vm_flags & VM_SHARED) {
> -               /* do not allow mprotect to make mapping writable */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> -
> -               if (vma->vm_flags & VM_WRITE)
> -                       return -EACCES;
> -       }
> -
>         vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
>         vma->vm_ops =3D &sel_mmap_policy_ops;
>
>
> --
> 2.55.0
>
