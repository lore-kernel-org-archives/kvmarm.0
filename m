Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B971ACECC
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733912330; cv=none; b=R1otmG6ww4xvw1QZjB+859uf6RUxYUNn7BfICPcJo1E/eKqDZEo/Gt/X/H+sch5nOUpB5jstCR2n2Q7kpNJmek/EuTDiIKpQb265QGv+Vb4nx5ZJGMU1IqEAio5WJJBTcSi7XPia9UV0+vCY2XtO8QjW5X4ckLJBWKY7MZWrra8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733912330; c=relaxed/simple;
	bh=meUvehoP0pPXR9PXhZw/v2e/9k24os0TrmSI4rVMEys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWu8jVzNw5ciXue9Pgk8gYYuGFI2OiR4eLhydeUyjUN3Ie8sbCjtF9i835+mAKrNNav3ddCzzetS06MUx+hx+S0gg5m5+9b31CTMfcLplHBPxR0Gk0jAbAnu4eclks8XbjegncC/z32Qd4rLNYSpYaP1fWLfz/TW9lxfrcl8wgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bIG+rxLF; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bIG+rxLF"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa6997f33e4so401673466b.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733912327; x=1734517127; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihYDcY3LWn4CcltGS+7wcqEJGOYARfyiPsaNarrTPi4=;
        b=bIG+rxLFB0sKbBfsjr9fHCNL5A0B8qnYQ1OQgoK8v2oXAUKhRSpUGIQin0MesT9VMz
         LKQAmHoEMHFwoRImbQE7UWPGJSiMssFgS35k1SLyq5bHh0z6MA+do/BU4vjxOcPICkAe
         o3itNSlaG5LnczorjqgLnisKZ5JNWmpUQhQr0y2FWacyIuZk9xKRtpf2Kaga/wNmf2v5
         muxP2XmpoKVxwRvhsbdHWFrFvzdhSMd6YOhio04yjiM9ioiD9Q9+i5PNBF/s3JFEmYQE
         3ETLws0Cp1exoScPpVjH211Ka3nCr1eoyxkb5KD9TqFS6newQk0yBZvpzdivo0l6TH6N
         Hf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733912327; x=1734517127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihYDcY3LWn4CcltGS+7wcqEJGOYARfyiPsaNarrTPi4=;
        b=lC/aTpSy9ILMTECMM8LurH34JDArH9OXkOAz5C4OXR98VnmzpkIfqtx9YiuvvA77PB
         YNmETpI1YoRlDGJCFBiEGoWgEfHDwW54F0cPKyj5cMHPGXwm8+v2hH0XKQ+4JyQ6WVdq
         HdWGmwdoK/HyiEUWXH2gGwpFu30xxu3ymqqhFerfRx1XywkiwkhBIZv35UL93J4J6PuL
         v7kUS4sX3O7PUAQUecApYXDeJUAfOzv2MyHgWPHGrk0qVXn98Md/Q6y7CyAqoASNru8p
         Cg5DBXLFtKtBvY8cwPa08UbH4gO45KBLUBuaXKmFSGlsD60rJFDpDnjKDOeQbL5T38lw
         vb1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVy/5IrLIDBI65LH7qM8PbelnqBXDt+G/k7VrPRt3VSAkE1i5j3axsm750Ek1zyNelVkE8/UIQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsKRpGBjFLyFcpXU/YrW0pkxVXcRNNHix6xrXV6WK3VG19Az/N
	rtR8tPgrzYB9w9xosFK1eg4Pwx5mk369IZYmu9BcSvp+5201slE6qjH95InKbg==
X-Gm-Gg: ASbGncvg61f21C5FhWDOnIDSAkAJN35h5uUcQbCD5vJ6BQU/bYxQGvYeCycRMXAjJQ4
	V3aWpetBjutWjw5ZYx6M1UTwmcLiD753QNpQ/c/lk/lBwDtv25qxumdLxVuebCVCF+xudtsbaJX
	8ZghTlU/ENlXzTLqqdD8BHqb0b0ZGgz/NZn8oMd5dARghKGJYLAKvghbvliPwLflQqEh4RWU+GZ
	Vdk4e1uHe3z/yWrbrm6iy0/UdEnfdRxQ1jP1Fhv6L5LurTjXNe4dGo8qk0QBtqCq8CHW7V4tSc4
	VSFadZKZcb9b
X-Google-Smtp-Source: AGHT+IHm02VkP/5m/qDW5G8yxXRC3oyr+fzt3izQJU/H+8B1ChDswIr+GMq6gipyIZLTGIZO6CUeqA==
X-Received: by 2002:a17:906:3cb1:b0:aa6:66eb:9c06 with SMTP id a640c23a62f3a-aa6b1141c94mr206656266b.5.1733912327068;
        Wed, 11 Dec 2024 02:18:47 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa665119a06sm641148666b.121.2024.12.11.02.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 02:18:46 -0800 (PST)
Date: Wed, 11 Dec 2024 10:18:44 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/18] KVM: arm64: Introduce
 __pkvm_host_mkyoung_guest()
Message-ID: <Z1lnBDBNq_PKKN4l@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-16-qperret@google.com>
 <CA+EHjTzOjwNyUkS5_zSUiAbiCauLKKgkKU6TM_-+Wsh9A0FdRQ@mail.gmail.com>
 <Z1iaof2DgZfZxc4l@google.com>
 <CA+EHjTyzh_tqH-M4zSDEQ9meK_W_c-sQDvJ6H4kBd4e_MCmLfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyzh_tqH-M4zSDEQ9meK_W_c-sQDvJ6H4kBd4e_MCmLfA@mail.gmail.com>

On Wednesday 11 Dec 2024 at 10:11:17 (+0000), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Tue, 10 Dec 2024 at 19:46, Quentin Perret <qperret@google.com> wrote:
> >
> > On Tuesday 10 Dec 2024 at 15:14:03 (+0000), Fuad Tabba wrote:
> > > > +int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> > > > +{
> > > > +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> > > > +       u64 ipa = hyp_pfn_to_phys(gfn);
> > > > +       u64 phys;
> > > > +       int ret;
> > > > +
> > > > +       host_lock_component();
> > > > +       guest_lock_component(vm);
> > > > +
> > > > +       ret = __check_host_unshare_guest(vm, &phys, ipa);
> > >
> > > While I'm bikeshedding some more, does the name
> > > __check_host_unshare_guest() make sense? Should it be something like
> > > __check_host_changeperm_guest(), or something along those lines? (feel
> > > free to ignore this :) )
> >
> > I understand the comment, but not a huge fan of 'changeperm' as that
> > sounds like we're only allowing permission changes while we use this
> > all over the place. Maybe __check_host_is_shared_guest()? Naming is
> > hard, so happy to take suggestions :-)
> 
> I've gone and done it now :) I almost like that, it's the *is* part I
> don't like since it implied a boolean return. Maybe just
> __check_host_shared_guest(), no is?

Deal!

Cheers,
Quentin
