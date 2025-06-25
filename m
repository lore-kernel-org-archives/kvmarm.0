Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D671E4AB
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750854954; cv=none; b=JCTOPoX29LXXfDaEc2SS3VqfV3ZHZKEGjisYR5FBrfdj7G3V1kmFMd3HnOJCBUuudLyAdFy77mupZuFtrd9TH1WSQhiqq6QHDvD3RiCB0aXwvkQLueoAIKAY4EhrrLft6+5HrQRdMNIrN49vyJw48XEqym1WHzbRHJ/n5qnMI5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750854954; c=relaxed/simple;
	bh=SLebeACRWk6qkca7RgE5fIsKlUh7V/TWthkOW1zhXWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXdys17IL3i1Tnnnf4Bq3SnTRgkyFqyJTY4kEX9+4Wnhwx9YMklkMDByAW4qnxuA0oB0of/c34w30oa/ORPGNj74D7poEE6KLpKPtDyift6nVYpDq7K5wI4CV3r8emqD6nXmbRziIAaW24syJjQ7kl1NvoGCbeheCmX51IlFZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2srySCRZ; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2srySCRZ"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae0c4945c76so85618966b.3
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 05:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750854951; x=1751459751; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2q90HEwNHGnz4Upnp0RKX2HlMlf/DYcXUBx0PZgzyaI=;
        b=2srySCRZMZa3pq+4WdYkgwsHslfU+LkcVyt+z5CUcRFd+SRcWSeb+0YrSfwRpSzT9x
         obJjiXMvIlY2PyUT6UYoZFQS4Tu0VOIpTlVjySC1cwtHlq8+lsftE7DzSjHxbJkGMHZf
         B9Z7mPwPHi2KhF6aoayrxh2OShcEMgWWi5naMikweK6MKcMEfDW3sHc6FJU+7Thg71YG
         A5pF7l6Qoqarr3LYTwh5a4H+n87jsDi1AjBlc+INX1Dv3J+fK05qYN+ugcCTxAI8ag+V
         nlcBikTmijaPGL1RHv35ibEY94FrhJ/PUON46BNu+TELNnxmStApIS5TVRTrE/qRNUH3
         ScJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750854951; x=1751459751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2q90HEwNHGnz4Upnp0RKX2HlMlf/DYcXUBx0PZgzyaI=;
        b=iJjV6anuBTWl6sxa1WzD2Acs4wfeidSdwzDgFMZ8hCUBqk9Lxznixpk0c7UmLjYy+t
         G43hheCBYD0xA/6QetsjWArZsZSFnVUzCBkocKfuRrJePIadQPBjPPGEtCXIbpOZClbm
         36kEN7UfAzX0LtQ0mEQ/OFQpvHwILuDE7abPc3e4xWarBPXgxTxqQCZpGPWIf1MuttRW
         PG1sIry42sZ01Njp/cnIHh+m4I04lNafYJCf25ZMxHZnPzIdPBDgaDAgQKntASzLj/NL
         Q6lK29ivqJFfB9dlw7MWur/BqttnFdfg0sA/c2Z/Oa0MgKgH1j4QA+xSEoHemM3gfgx5
         R34w==
X-Forwarded-Encrypted: i=1; AJvYcCXSm5TVgauDjlM+cxNtLH1yqO2cbcPZ7+FpNrRvrwIJCbRbKRSzE9EE5E4sYCpOOMg2851td5Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPWzoOa1/IzKurAc5QyNjUxu92UK5QD20DstVTSigPDnt/i8LW
	h6OlpK1eqHxnPvK1cfkXs3kZ0gH9lJkGqaYBs97Csjc140/4W4f4av5V4ZxRGZcw2A==
X-Gm-Gg: ASbGncvAMNVzcg2/Dl5GRpJuZjIhkXdMCt6H41pasYZlxGUhb2Ew2JfJou7MCXCXwzP
	Qaju5HGTf/sRPCFVmOf9/OypmA/0YcSWjRIwNEdOyyclaMow+5FAZ3MFdz0KpIZEQe85BrHm7Cn
	XOiQB5u+eQ/G4+f56EQlSAzwlMohSdraicMz57c20PTGr2aSARV13BTIsPYTjh4FdJDtPauqyOp
	iO9CqdgOCkFFQdd6BKAnZReyvt4Zw2K9QxJ4CjpZJ/5pFz+W2LbXGcM41nnQB4R3uI3VIPLJsUE
	RJUujHMbzqwa5DwGBBhVKHgV6DWujSdpYcMjWQgulNUMBld0QJe6BOoi0YpcB4k9A86diPY1phk
	dz3UXzee3V9Hc8YO/S0C7b5UxuVVFaCk=
X-Google-Smtp-Source: AGHT+IGeu1vPbCuiY2js0cAMuyaqjySismzGJ98ewnju3a81TdzXuUCosTL/BoTdvitPihCLhN4tkg==
X-Received: by 2002:a17:907:7254:b0:ae0:c5a6:80e7 with SMTP id a640c23a62f3a-ae0c5a6ad05mr220312566b.16.1750854950527;
        Wed, 25 Jun 2025 05:35:50 -0700 (PDT)
Received: from google.com (8.239.204.35.bc.googleusercontent.com. [35.204.239.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae085beb7e8sm604860966b.41.2025.06.25.05.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 05:35:49 -0700 (PDT)
Date: Wed, 25 Jun 2025 12:35:46 +0000
From: Quentin Perret <qperret@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix error path in init_hyp_mode()
Message-ID: <aFvtIn5SuoAmlvvD@google.com>
References: <20250625123058.875179-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625123058.875179-1-smostafa@google.com>

On Wednesday 25 Jun 2025 at 12:30:58 (+0000), Mostafa Saleh wrote:
> In the unlikely case pKVM failed to allocate carveout, the error path
> tries to access NULL ptr when it de-reference the SVE state from the
> uninitialized nVHE per-cpu base.
> 
> [    1.575420] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [    1.576010] pc : teardown_hyp_mode+0xe4/0x180
> [    1.576920] lr : teardown_hyp_mode+0xd0/0x180
> [    1.577308] sp : ffff8000826fb9d0
> [    1.577600] x29: ffff8000826fb9d0 x28: 0000000000000000 x27: ffff80008209b000
> [    1.578383] x26: ffff800081dde000 x25: ffff8000820493c0 x24: ffff80008209eb00
> [    1.579180] x23: 0000000000000040 x22: 0000000000000001 x21: 0000000000000000
> [    1.579881] x20: 0000000000000002 x19: ffff800081d540b8 x18: 0000000000000000
> [    1.580544] x17: ffff800081205230 x16: 0000000000000152 x15: 00000000fffffff8
> [    1.581183] x14: 0000000000000008 x13: fff00000ff7f6880 x12: 000000000000003e
> [    1.581813] x11: 0000000000000002 x10: 00000000000000ff x9 : 0000000000000000
> [    1.582503] x8 : 0000000000000000 x7 : 7f7f7f7f7f7f7f7f x6 : 43485e525851ff30
> [    1.583140] x5 : fff00000ff6e9030 x4 : fff00000ff6e8f80 x3 : 0000000000000000
> [    1.583780] x2 : 0000000000000000 x1 : 0000000000000002 x0 : 0000000000000000
> [    1.584526] Call trace:
> [    1.584945]  teardown_hyp_mode+0xe4/0x180 (P)
> [    1.585578]  init_hyp_mode+0x920/0x994
> [    1.586005]  kvm_arm_init+0xb4/0x25c
> [    1.586387]  do_one_initcall+0xe0/0x258
> [    1.586819]  do_initcall_level+0xa0/0xd4
> [    1.587224]  do_initcalls+0x54/0x94
> [    1.587606]  do_basic_setup+0x1c/0x28
> [    1.587998]  kernel_init_freeable+0xc8/0x130
> [    1.588409]  kernel_init+0x20/0x1a4
> [    1.588768]  ret_from_fork+0x10/0x20
> [    1.589568] Code: f875db48 8b1c0109 f100011f 9a8903e8 (f9463100)
> [    1.590332] ---[ end trace 0000000000000000 ]---
> 
> As Quentin pointed, the order of free is also wrong, we need to free
> SVE state first before freeing the per CPU ptrs.
> 
> I initially observed this on 6.12, but I could also repro in master.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Probably worth adding:

  Fixes: 66d5b53e20a6 ("KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM")

With that:

  Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
