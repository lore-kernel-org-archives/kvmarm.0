Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29968489
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733911917; cv=none; b=gkVsNiO9wlbbHSG+hTRFN+nkzvkWM0gsFWhqPEopzZ+JDZbqhKlPYMtvjKBmT+7hJc6NzUU/R+46w2/2b6biy86j+adAwdEYSdr5wL6W4PN4Lg1tcEYE77DosMKU9cP872KQrJ/npITBcjOY1KwdrU8krdcW1cCD/QsS/Qgb0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733911917; c=relaxed/simple;
	bh=UNSkvp5Fi4jdAsiQOX2ohUox6oA4Eol6M3ew5tYCm7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oc2npkRqF9VJNCrjot0mvH/qJ8lTJQC6gN/OfFzt4xgmxEoSY8Q4x0GWNUJg6w3mqElqI6gxHVbiSQOUmk5LVWN9PDAf1kbSnBB6Do06m9RPol+EiVzuahe4ph4/VRsIe/F+D9bgSxc0lEaKYcvucPkt80VfBR6y6D1dDTLfp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ew4aQhtr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ew4aQhtr"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so27945e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733911914; x=1734516714; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k5/pBdgJ0WtdygNIfcUkdF80xl9r4Rk30sip5q/77pY=;
        b=ew4aQhtrCzbRIwP1yWqLIeg+8HbJioTb+VHxjKSBRAPvszYpkEkx5cT2y0d5eZqbxZ
         nBH038ujQKjGTTQQrwo40tAvaT4orwyVIAhGnfi+eX9kSVGr/A+NLezvOn2SrftI7WKr
         0zhT+4CjLqrJrv2yR+mci+2I1oPgiPJRGilNF6c28aw2jEx6aVEGAhN5bQsLzdQo28QV
         1gA1FUEAHqIUVuxLMSggZLQaAEz7pvEDgnT/JbFOhAc+DlpfeEWB3yQpmJEI7w31SvHn
         /6Q0/gskl0kVYP70azACfVXEhZX+Xpfp8r3ulKwn3G8TB1Vkqj58UJK4dokBKNlA2YNK
         JsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733911914; x=1734516714;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k5/pBdgJ0WtdygNIfcUkdF80xl9r4Rk30sip5q/77pY=;
        b=tsWeAXpJwJWSnm/wRmvS8XHmHmbjIq47LXtbYys5qnVUGy5YWYdKMsQ5Z7l7SNQQBs
         j35dR8JUsr40T1QdgzLClSP5YXqepV9h18c2yRlkRfcnT5TF7hh4d0qqhN6B0WDYoLt9
         VkjcuWekaQJYHwgFiuxi+UTrHNWzbKkQN3pqYj9qZXVpt0awfr4C+xSz9hZYQD8Mbivl
         Vcdi3lFktkJ/uoRtKM+hznZdgxbT28gBf1pm9iy2V08UfWhcNV2Ohsbpizhh+V3pIcak
         x+ERf86dAbFT8c8p4K4N+yBIYoIOjixTMP6I80FYPzLHS5hV0HzeHKKHpOuLQg2Fc2hr
         Dd2w==
X-Forwarded-Encrypted: i=1; AJvYcCUDllzMwmEdD5nX9o6GkfjQIzslh5Bd0+QwVHNkzkUVBhD3bRbLGzazbTL5LG+vbfMPTqyWiRo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpKNb+Ds88crGPluKw11dwS94CIAJfOh+YORTIuyZsHaDzvid+
	h6YxQ8fB6ExKZVuhGPNv88n3m3FkxhK1avzAt+jIWIiRHKaYBJKWvEWR67IjdK0oBHttYZ0SXS6
	sfBRFyTL8cwGduqDsY3sZoa4s993NDxVmn4Yv
X-Gm-Gg: ASbGncslvUdtJtHYCaxBOXVMh8w+uK/9dlkXeInZPH26C7PG74eGQ9Az1peAdSQbmUb
	XXTJMA4uTqeqILgmKTe8Pc+Y9OXvtAGubeTjb74IRUDGgnRWNZobDv2X4RkmqfkxN
X-Google-Smtp-Source: AGHT+IHKlxzo1xy4xRwvjpYoXuxiOd/XjNGW14dtMQxwLOZNl9tNvycqqdCoKpeiFlUtFyA39Sdg5yzXDCdFY1hYk7g=
X-Received: by 2002:a05:600c:490a:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4361c0e320bmr987705e9.2.1733911913821; Wed, 11 Dec 2024
 02:11:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-16-qperret@google.com>
 <CA+EHjTzOjwNyUkS5_zSUiAbiCauLKKgkKU6TM_-+Wsh9A0FdRQ@mail.gmail.com> <Z1iaof2DgZfZxc4l@google.com>
In-Reply-To: <Z1iaof2DgZfZxc4l@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 10:11:17 +0000
Message-ID: <CA+EHjTyzh_tqH-M4zSDEQ9meK_W_c-sQDvJ6H4kBd4e_MCmLfA@mail.gmail.com>
Subject: Re: [PATCH v2 15/18] KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 10 Dec 2024 at 19:46, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 10 Dec 2024 at 15:14:03 (+0000), Fuad Tabba wrote:
> > > +int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> > > +{
> > > +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> > > +       u64 ipa = hyp_pfn_to_phys(gfn);
> > > +       u64 phys;
> > > +       int ret;
> > > +
> > > +       host_lock_component();
> > > +       guest_lock_component(vm);
> > > +
> > > +       ret = __check_host_unshare_guest(vm, &phys, ipa);
> >
> > While I'm bikeshedding some more, does the name
> > __check_host_unshare_guest() make sense? Should it be something like
> > __check_host_changeperm_guest(), or something along those lines? (feel
> > free to ignore this :) )
>
> I understand the comment, but not a huge fan of 'changeperm' as that
> sounds like we're only allowing permission changes while we use this
> all over the place. Maybe __check_host_is_shared_guest()? Naming is
> hard, so happy to take suggestions :-)

I've gone and done it now :) I almost like that, it's the *is* part I
don't like since it implied a boolean return. Maybe just
__check_host_shared_guest(), no is?

Cheers,
/fuad
