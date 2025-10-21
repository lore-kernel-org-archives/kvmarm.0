Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EDD3446C7
	for <kvmarm@lists.linux.dev>; Tue, 21 Oct 2025 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761065783; cv=none; b=hnf1w7kd9E92MEjVRKSCdBC1Nq63WP8zEsyTcafUXACLHpkrULgT+U5OTHz7rFV7e93oK+Sg2B1NkWpkw0V8JKNonJMoapFEM/vbQ9FRRT8XEPGmKfK9C1wT3EdX+/x9mWP8G9YOYn6bOZowT0Okpm0gzhWMpIuq6lxLGlRnvzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761065783; c=relaxed/simple;
	bh=RDkmhC4PKjh9lbEZgOEdown78rPWmXw4ycUHNJGAVxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iahgJqpXifbnJG02JtPDI0htHjMNemyI1qw/6rv8sSqBNeE1KZafAImGbMcTHDrzGQ5HlOdhLhCgD1YH8c3v3ceHby/JnwsUdyXt1qgbQmZ5js9m1kvPfer4ade4yM2ZqIWqiJAv5Kw30X0D/j3ayTm1a248fUMVwxvM/UUoePU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nUwNyp0A; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nUwNyp0A"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290bcced220so50769365ad.1
        for <kvmarm@lists.linux.dev>; Tue, 21 Oct 2025 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761065781; x=1761670581; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QUj6Jzqtl7pAwgzbknudC50aTFamgZNMeXgKkiBAGZE=;
        b=nUwNyp0ASOFk3o4Xy5bhf5hGZDNZE+BOUZxjY7dHBwuwGIkWBq3ofMB6CMKZ4M/z78
         0RsfaPA+P6H5a6rixofLEB0a8Fb6WNtRs3lbSQVY2C7OA3joJ3+sINGCSzfAPvqQ56/q
         2bD/A505V/iTgiwnEeSKBuGb/bLJ+Hk/0YAT28EiG12G09l4YtgzYhu0rzDuyAqcnhSY
         AfLMNVDknZFMRuPlXxm0xmIFRNglwYQE1mVz2hPyFXiKLFSbYzaWP1eMPrprltRitYtb
         f0YdWc5u/0RoTOJ7wwAoxQhbCzq1WZGrzLDhTv7tF3mH/i4CexsVn5Lnb3SSg+myWVRu
         YWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761065781; x=1761670581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QUj6Jzqtl7pAwgzbknudC50aTFamgZNMeXgKkiBAGZE=;
        b=OApSU2gccoCtiWr6X/67GrAed/sicosQQy0D2ztA/V53U52OKerIeOF6BBagiJD697
         nPbN9psdlVJr9XOii2BU+35hPuhGgGgcQTxoaUK02Cgq6FcSXYaSaXpgPr+TtSnvMOOG
         Ww8Am0k6y+NkkBsDdRqbVjFMhzkspRW5Dj3Pc5d1VqKPg9uUX20n9hIw+FtH9KUUjLfI
         zq0St779AedYP3XS83zrzZhPsdlF4BpG1YuOfo3H7k9Pi7clIVEcaL0eHCFvtjppfyCe
         MfOKR9DyQRatdK1Twmwb1kuz7LteE/N2yAsoMVYJOCc3QUv/ZoT2RlIokiIugBaQLMUu
         D2Vg==
X-Forwarded-Encrypted: i=1; AJvYcCVeuq4DQub5KQPxnEmoj4yjRq1gvJ5rU6Ezs6gf00t9iv2Y7xS59LpbDoioCSHNjDDL5/fLxo8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxI4cANEdN4GIV055Bq8/XK0EfM7R27sRZOtczyzqWT3kdgIrwE
	Kq7V+LtxPPqSTGUZHeOjABh2dMXK762QozlbjApiY8C3ztWtJIT9FVMK/YwH9bcvLjl9zb+7Hjv
	ui8MN6Q==
X-Google-Smtp-Source: AGHT+IGOqKmUzCbfjGYr8B2jY/C1mdIZnvxK8+ss+AVkwVotQdjiGEd+3SJ7VfMTaFoQGYSh7+8f99sR5n0=
X-Received: from pjre3.prod.google.com ([2002:a17:90a:b383:b0:33b:51fe:1a75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88e:b0:250:1c22:e78
 with SMTP id d9443c01a7336-290c9c89c9amr235880025ad.1.1761065780727; Tue, 21
 Oct 2025 09:56:20 -0700 (PDT)
Date: Tue, 21 Oct 2025 09:56:19 -0700
In-Reply-To: <d0b369c65e33518d57a40a70c0d13f70bd64db47.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-24-seanjc@google.com>
 <d0b369c65e33518d57a40a70c0d13f70bd64db47.camel@intel.com>
Message-ID: <aPe7M1aUPwqDmQbY@google.com>
Subject: Re: [PATCH v3 23/25] KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-10-16 at 17:32 -0700, Sean Christopherson wrote:
> > Use guard() in tdx_vm_ioctl() to tidy up the code a small amount, but more
> > importantly to minimize the diff of a future change, which will use
> > guard-like semantics to acquire and release multiple locks.
> > 
> > No functional change intended.
> 
> There is a tiny functional change. In the default case it no longer re-copies
> the struct back to userspace.

No?  The default case doesn't copy the struct back even before this patch, it
explicitly skips the copy_to_user().

	mutex_lock(&kvm->lock);

	switch (tdx_cmd.id) {
	case KVM_TDX_CAPABILITIES:
		r = tdx_get_capabilities(&tdx_cmd);
		break;
	case KVM_TDX_INIT_VM:
		r = tdx_td_init(kvm, &tdx_cmd);
		break;
	case KVM_TDX_FINALIZE_VM:
		r = tdx_td_finalize(kvm, &tdx_cmd);
		break;
	default:
		r = -EINVAL;
		goto out;  <====================
	}

	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
		r = -EFAULT;

out:
	mutex_unlock(&kvm->lock);
	return r;
