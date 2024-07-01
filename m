Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB0816631C
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719843049; cv=none; b=RsE/iZgz0iHmk79691odUQ07TVxyGFB4UsWPf2N3Mq2yWQ/UjNtOPC4/oLiyeUwkZEKXBivJ5mvAXAQV3D4r2Wt1dMPqJUK87t0IfsYU5QR/Ez54p/17VuCBIh/k76lal1ApkgDxxBOn7dyHLiR/5PniH62Q3Mp8SHB+gL/H+iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719843049; c=relaxed/simple;
	bh=tiTh+J3beNdExCpBB6xbk5i9pLLhF9/Oz4oRL3aTYrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6ubpiAPA3KGnaFebx/UDEf8lna+WxAgvYVAjsMRdns2CMFzYrV4cvmhxYIj7nYDpK7VY86VArVBqPrOuZYYiJOSJ8WLaCsj78IFtnpTZ5HYU0DfpYpIK9+F2BLrfAGUsijTJC74Yh4RUpVpeO4HG40fbH2L58898fqi8l6ZIn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1J1sVFhN; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1J1sVFhN"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4257c6eea33so64745e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Jul 2024 07:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719843046; x=1720447846; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Km1Ez8bnMs5MXCoo07hLRftaefO9zeRKQ+RQM7Ne4Q=;
        b=1J1sVFhNYhVqFpZ2zpxvL6Ijf1Bf6eKk+Gi6+rT73WkTJC+ksqvSTXONvWckv4weT3
         lKNpUW4xL0M9RaI0HcIK+0UKIBClvOiHeT9uT3TA4cDHDACHe9OCDoA3tvN7hZdUZpbf
         c35zUsneqeeEhI5aTYpGoGhDpexSvypZjFcTaDO6cPx4DcJMt2zeqnBP6Mt+aY26UhF8
         QFgeApQ5ntI+xxmtOrnSDjBr29/JHB5zdQa/MW0c+XLMBsl85fWH0DcHx7qSxgM9Otlp
         abMJoVrVyyCQtx/CcxcXwNGYzKxQ/RcrBvRsLyU7cBKn5oLFP/uYQdQn5zBjI7WE3qnd
         I1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719843046; x=1720447846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Km1Ez8bnMs5MXCoo07hLRftaefO9zeRKQ+RQM7Ne4Q=;
        b=OsTC4M9Qqv/fTYlv92FfQ52b5A5FBe8ERW3wnS5xdHl80fLmKfLTd+kE7/7sygGWMG
         SjL3TeOV/4Jyx4iVu5+iE3TtCWsntQLd4kxfjeG8YeuE8bfurNn0nThmucoB34NfT4tc
         eNGg+WV/bZ+09ImR8EIyJt2ZxkmF7w2p0rVdzcKAxkBcUJot0I1lFgscMWor8SBVhhz/
         eUL5+DiDKzXFzQY8/DPXhMpuUIjhHjKar+ZSdkA0sngP1Cz0VFQFaHlKDpl90N7NYAFy
         /hAF4kD7gmzRQQZ89QpupwBlzggR45WFILo3SfeJ6MTo8y720X279jeW30ErLQ2V7w2V
         aEBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUwoE0L9/aF9Xmlfh97qIl9iy/ifFdIb4VbiyuJEGefZDtu00zsXc5q6rZx8rlMc7z16hQ72wCKZrpHBf6KbK3mzJ7ZyPg
X-Gm-Message-State: AOJu0YxFu2JTNDuOVGwG2c5Lv8eLXosWhcMTiyebu6XQUVRGnb740LiF
	ixpYeMnq9tlM8Z55ipL3OIBUyJbLptpDsnZlp9TKwuIP+siJFzaL2Fg/jqxWCA==
X-Google-Smtp-Source: AGHT+IFtjX/BZqS+uUZ8PF1mKp7f3Esb11KZRNUo9KxHrxIz4V1iA5bVnL0VunIlYUdBUZha4UJQBA==
X-Received: by 2002:a05:600c:1c17:b0:422:ffac:f8c0 with SMTP id 5b1f17b1804b1-4257816691cmr3222955e9.7.1719843045852;
        Mon, 01 Jul 2024 07:10:45 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256af55cccsm156205455e9.16.2024.07.01.07.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 07:10:45 -0700 (PDT)
Date: Mon, 1 Jul 2024 14:10:43 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 6/6] KVM: arm64: Expose guest stage-2 pagetable config
 to debugfs
Message-ID: <ZoK44_CmoDHantBv@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-7-sebastianene@google.com>
 <Zn8hzwIEtvBFjdkk@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zn8hzwIEtvBFjdkk@linux.dev>

On Fri, Jun 28, 2024 at 08:49:19PM +0000, Oliver Upton wrote:
> On Fri, Jun 21, 2024 at 12:32:30PM +0000, Sebastian Ene wrote:
> > Make the start level and the IPA bits properties available in the
> > virtual machine debugfs directory. Make sure that the KVM structure
> > doesn't disappear behind our back and keep a reference to the KVM struct
> > while these files are opened.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/ptdump.c | 50 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 50 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index cc1d4fdddc6e..17649e3cbc8f 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -215,8 +215,58 @@ static const struct file_operations kvm_ptdump_guest_fops = {
> >  	.release	= kvm_ptdump_guest_close,
> >  };
> >  
> > +static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
> > +{
> > +	const struct file *file = m->file;
> > +	struct kvm_pgtable *pgtable = m->private;
> > +
> > +	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
> > +		seq_printf(m, "%2u\n", pgtable->ia_bits);
> > +	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
> > +		seq_printf(m, "%1d\n", pgtable->start_level);
> 
> The name of the file suggests sounds like this is the number of page
> table levels instead of the starting level of the walk.
> 
> So instead:
> 
> 		seq_printf(m, "%1d\n",
> 			   KVM_PGTABLE_LAST_LEVEL - pgtable->start_level + 1);
> 

Ack, I will rewrite this.

> > +	return 0;
> > +}
> > +
> > +static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
> > +{
> > +	struct kvm *kvm = m->i_private;
> > +	struct kvm_s2_mmu *mmu;
> > +	struct kvm_pgtable *pgtable;
> > +	int ret;
> > +
> > +	if (!kvm_get_kvm_safe(kvm))
> > +		return -ENOENT;
> > +
> > +	mmu = &kvm->arch.mmu;
> > +	pgtable = mmu->pgt;
> 
> nitpick: pgtable = &kvm->arch.mmu.pgt
>

Will fix this.

Thanks,
Seb
> -- 
> Thanks,
> Oliver
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
