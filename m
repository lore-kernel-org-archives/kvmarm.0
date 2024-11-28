Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7414D44D
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 08:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732783392; cv=none; b=QG9omL4DFvRsP/WgX5Os2rX9zKC3xN13fIfbSUWuJ7xhummbiotNMwb3/ZwoRmNYUoDocqgYntJjIk82McYyeio4hnJH/k+TQR7PhklSPcgAYrbmS6MmG1thT7sEoZH0GsSsvUUH2puwJmT8/mv15pQdYfUnN7nBYXBOGKnUnLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732783392; c=relaxed/simple;
	bh=eD0BKTile3avGYgb6esO7NcB7LFOjudhnPBYvOtuu6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/63Lo42EfmI9AWhVjOFmx38mC+mrvUkgSz/mB3+3VwrRheRHjXPF0rB9b2whGNArVYVmEhyu+qW6Q6IobLuUUFGYgXBHb0ZUO/EmM1VRc9msR+DSuQ3GI7Odht2nQT55KCLmgp/nB7iq1HlY0tAuORFjRjPcKQO7mLZ9JuULuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=a0EXoBCt; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="a0EXoBCt"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa1e6ecd353so31987466b.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732783389; x=1733388189; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tMHb2Kr+9Gyds+XTGzQnx6NFjRgDvoBkrYDD0zxb/+k=;
        b=a0EXoBCtEBJ2C6lZ2OakYJcsfSTyf28JO+HpICa4+JhZ/5hJcgBODCI7N2W82xLnxT
         0ATst4DsymqEQGdVT4S24w+9boFcG7uzlovEue7rl65qxblzVIk/AtreKjXYXGdaqsfU
         FyEwYrdQrDIo784HtqAx853Z1K/mjSsEQQINpveVy2TaAFy4IrsNK/EkVZb6ihTs+Fk5
         j7g/MxyQOE/v43yxJO8kIVgV8v6cpZJzN5nPEyWJaYBwdmGE/crXJOKcYA38G+TYCmrF
         oev6+eTEJA01RcYUVsUM2QSXK8DcqQA4PNzW5oRDy3aZ2ClBQk9B/iNZOiKpwCZF3T7H
         ofCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732783389; x=1733388189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMHb2Kr+9Gyds+XTGzQnx6NFjRgDvoBkrYDD0zxb/+k=;
        b=kQ7rYq142W4Gyb/WFy/vEw02kqQxSTNLII/Qt7LXgJcg/PfSCy34Z9jv+VfriHN/CJ
         y1FJNTdBOYYf4C4BJxxLHPP7a2re77VlnJxkFirE6E6rQ2cjuRTE7A89GfZayhcQu8qe
         qcVBjG8ZZ+6WAtrDf3H2Zy+3EFFbKsmOTDhHkxzAx7hgfa84w27RrK7c3jwleUftCf5f
         GN3IOXjapwHXK7/0B2b9ME+xRhy2ISLGMVRFp7QiZt0xVEu2/EgPHoazdbuGdtsuZZZB
         ed7dn/+ncne4QTt+xFIDhHKoYBp06lE1dB/T+LHCv0jIKEhnDf5suiRsCh1IJvv0l+oG
         /dPw==
X-Forwarded-Encrypted: i=1; AJvYcCWcI8FPVHEwv+FA4LFxTZeLe0487Y9uKJPXhYWEL+FlEa486MwrBjDMpBfoAWTx0Gfuf33+4eE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKttiXFJdLgU0h+43p4wn9NWMyaRePqe+XcPNU7UE/fBlk3dLK
	zM1pq+9PgLDqdxTIdS+na9hwsUFp5+eZ0qAW8PWx4L3MsascSHCgxlmITD+GNaU=
X-Gm-Gg: ASbGncvNRI94miWA44+LsRiiXOWHv9UszNRjpDPd+sGaIl7aSA8AKqD9WXhvUeRbVJS
	EhziCWGKiWRA1be8WQJeuzLoyAkwmRjCQxU0eun5Hovm1//FfzmMLPArwIu0SbV1udQbcDbOqvo
	mgI9u+4y0RlggI0fsfJ0v6ziED3JRWK6Ya60Gz0LjfkZCQOyInQZ7KhK11IvJiXz8bKQ2/x+ugO
	oVfn1VZkRw48W15zeA2d6GeZPrm417qV51A1OpRby8Mgmmc4vLJGbCGWR/FU0jnltbqMRG5lULn
	K6y83L3NQDGwNnvBbihsm7m5OrYVbAt35KQ=
X-Google-Smtp-Source: AGHT+IE91WdNXINf1ttfiGq0DeG9vnUXdI7yQdKbewyZQW5Jp/++7K5EDj28/C2AmS8X01ObB7bPuA==
X-Received: by 2002:aa7:cfd4:0:b0:5d0:8225:aa19 with SMTP id 4fb4d7f45d1cf-5d08225aa9cmr4768526a12.2.1732783388739;
        Thu, 28 Nov 2024 00:43:08 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d097e8f649sm493828a12.59.2024.11.28.00.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 00:43:07 -0800 (PST)
Date: Thu, 28 Nov 2024 09:43:06 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>, Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH v4 15/16] KVM: selftests: Use canonical $(ARCH) paths for
 KVM selftests directories
Message-ID: <20241128-d7a5061ce8160000cd5260bd@orel>
References: <20241128005547.4077116-1-seanjc@google.com>
 <20241128005547.4077116-16-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128005547.4077116-16-seanjc@google.com>

On Wed, Nov 27, 2024 at 04:55:46PM -0800, Sean Christopherson wrote:
> Use the kernel's canonical $(ARCH) paths instead of the raw target triple
> for KVM selftests directories.  KVM selftests are quite nearly the only
> place in the entire kernel that using the target triple for directories,
> tools/testing/selftests/drivers/s390x being the lone holdout.
> 
> Using the kernel's preferred nomenclature eliminates the minor, but
> annoying, friction of having to translate to KVM's selftests directories,
> e.g. for pattern matching, opening files, running selftests, etc.
> 
> Opportunsitically delete file comments that reference the full path of the
> file, as they are obviously prone to becoming stale, and serve no known
> purpose.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Acked-by: Andrew Jones <ajones@ventanamicro.com>
