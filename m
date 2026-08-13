Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478538F941
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 05:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600674; cv=none; b=crLZKBMuVYF4QjknF/eJFNUbgGVkTmfN6676wbanNLY0nV6hofwebUy4/0hbw8Cow3VHg4Z7+U0NWxH+83EtJxrcxr4nlFx+SHsGbFDT/dT1JypMghbVnUH264wLl7Ygi0t3s34cO91OwtK4RTw7+iDFftRs6DfhZo4CpYDBS88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600674; c=relaxed/simple;
	bh=Mrl9k2OYxCttpt0oaJBvFcDv/awuA7xGxUf0yffgjFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buYaKiXLkPHchyITkPIus2qcirlFEfVlZjHsF7epb+xNvMh+LA+YsAJrW/U7B1eyk4wtbEqvAUQ90qlQoFo6XVrQX1YHUX6JiaKUvpXg3WBz9w2ip/fE6yw2MWDO0yHYkMAEGZN4ybfpIn+aHUNrAD/V4HqQJvyn2XPDm0VsSQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pciGXux1; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pciGXux1"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f633e6058so262233f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 22:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786600671; x=1787205471; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+7PeLXe+ue8rItbBi6+JlGfhsV/36WDiPAKPGI7m+do=;
        b=pciGXux1fBRtF7v50vJVn9NaN9lNXSLxNSdFpvvxViKvdSYAsV7nUJ7KgyvpsGz7Ux
         9qnZJxxstBClnwsMR4pKjQ4gm/ytO/Eq2WtBuR+Vu30TywpOdTQNQH2cHiwCrdeqta/A
         WUD/I6odc0ZTHaSeOapbv6BwNlBTA5yu7bM/Nn3c/LtoP4LX9rVSNZTsQ+gr+Dopnm/N
         LlQ9XgMMu7zOuk/ukoPVQUEWDZ/KU6ZW9Q/Zumm/gW80vHlY6tHaXMik3gSI89JVnWpb
         ZFV4OZSlWclUhZzRsUHmQq/jcoFw7S2bSXHPepoXM2odNTYpyo4KYROmo2SCVKJ8beWE
         d3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786600671; x=1787205471;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7PeLXe+ue8rItbBi6+JlGfhsV/36WDiPAKPGI7m+do=;
        b=OdD5FTs90h1BKoH6q3aGkwAtNSgWOiX8Ccg8+WsARKQ2aiLXVSG1lsQrn40GpAwcPo
         M56QOXM2tB/0v+ADVVnUqE0kWzITh1G/e99/6K5uhIQnfxrWFAWUD1iULNi85EYWfdtr
         blZC83gMCkZQl+4ZDK9cxiClhKd2lCt38GRQ/I0zxJ9jOnv6trx8k+4kw5AupsZHy1ty
         pmuUMARPWMM/lqnzB7Jyp0ZUNBwv7Hg2GlIpr4L+ScFrJ7dRHb61o3OwKV7nVsgtD0fB
         A9Xq/TxkNfXCgniEW9VpyKdZDGfnqt+3rjN5SyXvTIfLXTYU6NQHaCN6ffziBpFIiM8j
         t4ag==
X-Forwarded-Encrypted: i=1; AHgh+Rqj+PD89RD4OngB0yG8mxmE60ODgHRTBqhV5iqapyhbxUEIlpchDzpJj1yTbzOdD1hvl/5Qq8I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcRdThWnHuOtAZC6WZt7ajkru/DLWSwiq8iU6OVC//VGOe17lG
	IsvdZf+N7GkXh4K99VoZ3oOjtkRlq7fS2CBCuCeAUlPzTdImMdSfZeV/
X-Gm-Gg: AR+sD10hml3ij920OGz01GzqxNxUWBoc2DjVv1FDU3eXgwWX5JJbI1SpygbowRUCePh
	ghsZFINly8NPDwKPcQHwlr8TFBkUO/yGv7Xi7QrKbq0VK48ukPke02MvB1Nr2bSprVNXcha3ait
	BNJtbS4Gy74OA4f24NaL/ChXFBEX6VfcTjvXCF5za5dMhFKJ/QfuJ2yZK3PPO6CfbHmB4xO/7+P
	mm1RNhlZYftc77/WQpAxfjayYxzR+5A3FXvRRh32JynSZEyYZIggjnwX2fqU1BYfZMAaQg7E587
	Iw2v9EhDrtJszrmS7nFCf2ASAF/4NBehmJ3k905oV6R+9l8JT0jIdmD+ZxJAIgSC3i3cicAYV87
	UsyyQk376jo04tqoLX5euaKrczF+vtti62RHZR8W8p0p3N2dgKjn1bs6hcO3iGZXwbmgVwsOE63
	zZpm9cpUHD4U01+anYNNHivd1SyqxTi+DTaJvHMbowupb3/WEOpGDoRMLfB9twBg/s0BtGc8caR
	5t7vfqnnQ8jBnFFCIvMEt4TvtdY7Y9ci13PITZ0ptYUAmNNeb56wWCVpnkb0eVsFYCRGvLAF3Oz
	L9zTiaqnn1HGbDgOaehtAPDxDf904mGovm+mcI6/egtsDRIHrylbFhVAVnRUIM0Kj20=
X-Received: by 2002:a05:600c:190f:b0:499:484a:98e7 with SMTP id 5b1f17b1804b1-4998218e63dmr29591735e9.14.1786600670592;
        Wed, 12 Aug 2026 22:57:50 -0700 (PDT)
Received: from MacBook-Pro-von-Karl (dynamic-2a02-3100-9c79-1f01-1565-573d-10dc-99f9.310.pool.telefonica.de. [2a02:3100:9c79:1f01:1565:573d:10dc:99f9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998216cf70sm28991305e9.12.2026.08.12.22.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:57:49 -0700 (PDT)
Date: Thu, 13 Aug 2026 07:57:48 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: vgic-v3: Roll back failed
 redistributor region setup
Message-ID: <an1cYl928Fue-z3s@gmail.com>
References: <cover.1786344511.git.kmehltretter@gmail.com>
 <4e00fc25aa61ec52e6ef033a53588ce3f5550982.1786344511.git.kmehltretter@gmail.com>
 <86tsp2139b.wl-maz@kernel.org>
 <anotFcOP0kcQJwrA@gmail.com>
 <86jypv1lxo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jypv1lxo.wl-maz@kernel.org>

On Wed, Aug 12, 2026 at 02:57:07PM +0100, Marc Zyngier wrote:
> On Mon, 10 Aug 2026 22:22:37 +0100,
> Karl Mehltretter <kmehltretter@gmail.com> wrote:
> > Is this closer to what you had in mind?
> 
> No. I want *all* RDs to be gone on failure, and the next successful
> registration to result in all possible RDs to be matched against a
> vcpu if there are enough of them. Effectively an atomic behaviour from
> the PoV of userspace.
> 
> See the patch below for what I came up with.
> 

Understood. I believe your sketch needs two small adjustments:

free_index must be incremented before kvm_io_bus_register_dev().
If registration fails, the current vCPU already has an RD assignment, but
there is otherwise no increment for the teardown path to undo.

The garbage collection in vgic_v3_free_redist_region() should remain.
VM teardown frees the regions before unregistering the RD iodevs, so
removing it would leave rdreg pointers referring to freed regions.

Does that look OK to you? If so, I could include both in v2.
I'll also split the selftest change and have it check only the
final state after the retry.

Thanks,
Karl
