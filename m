Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A64F1F4295
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742831450; cv=none; b=OkpibK11FyV6nIrObRcyy4o5R7iHLBbszCbit40gw9DyHgD0oKuQN+YLMmWxOIxU1gFpC5AaaIuTnv/bktMWp1waH7sc4usUtcomc2uqqIIMMMjZ3adxlP4lIBn4imuAMKwuJZ0wwef7Kc8abHGONyEyBqRq2MEOeh/xdHUxHrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742831450; c=relaxed/simple;
	bh=G73BqoZTSqdB/GPULe2VlsnAncHW1WKkv8acByNLDMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyHn+UpEUcn3VZ8GPp9Kpbe5EwzWgDks7hdopFze85Eajxb7u4AZAdGF+3tGThmBtG8K22l0B3JULTNtVuJvdWKW5qNWMXwPD3f1cPIcuTIhvHgs2Ra8B5TQ834Sw24QESmiq0FcxOolx770G0sCWrGYplSGzwFEZdvuFfXFMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WbRbcOvP; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WbRbcOvP"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3912d2c89ecso4342638f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 08:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742831447; x=1743436247; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qXRhGeDkSWGWmmVuNBstp6OZum7jWU1CmWmtDqvRvak=;
        b=WbRbcOvPNTqvDNO2+syJ0iIflan7e6A24oa9ZL8AK58yJ8D3ZTTV1gRi21HreaGnBL
         hxfrD/waAYJyIrRfAR8E0omY5RmHbWt9W+QZ6XO1ppoogpG5EDHBX7sSdoOuCnriMMll
         ARfiBclnqmi/lbRXM6AjEkvcxlIAAC9mSrBQmx374fkp3h5fZ8nmouBz9p2JFWZZ+6sz
         Gv3vVI9qD1AdhlvaJ66MjoF9BgzAWfBqsdU7pzkGSkVks+3KTQ6klNOLtyzwXQLvLw8Y
         2woXccd/c77QOWIBbvqCXRIVf8EQgmkXRBXoY/YV7RM9Ohr9wEY3+c8+DB9GQUwvzQ+N
         99nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742831447; x=1743436247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXRhGeDkSWGWmmVuNBstp6OZum7jWU1CmWmtDqvRvak=;
        b=FyCKGRfYLRK/7CvCb6jk0orvVvm2DzYlX691+b6zkEotJN0eObDHwuZICFOo2oRqsr
         IL5MkLKHPUmoxom39pTK63iF3M2BqGaVz5xgk5V5fsttq3qWMNawjX5tGrGwe82TkTDq
         qcdu7/WRmv5E/KOu7biiGS6hDExK7iQ2S+aSADTzOTr3aKC/v8G2x7as4qz+jf53FpDQ
         FCsEGj0dD9lb6KsUVdxAg2VJjv7z7OMMnmgR672oaDfEbhHFuZbTpdhJtEAPfShqnYo1
         ViiHNyRmWiYU50V4MAdHoxIwOZFZpG2NJwucbOSblcM+NvdxiOso3/p7WvfkasbvhY7T
         +e2A==
X-Forwarded-Encrypted: i=1; AJvYcCU4Sv+dzVVhWySby3v/PYVSOcwK6tO2rygfyCopqtjLGMLiBRpJeeDRp+mbsuPCOdaZDZJfKqQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTPZZuCv4aBQMgl1oSyzZ8xwgHg/LUEeXDoCSJPxnO1n0Xmzbj
	pddJsk+m6M/NOFdyPY67qjqpiS+xo8exDR2Jgf1tywylK0KrLVHnSat3Hz2z2gA=
X-Gm-Gg: ASbGnctQGQ2jvoAwFCn20kPcV/q4dmh7Vurdpaw2240jIzk+2PBsTs3EMEnPxnnJUyy
	oAq1KAbW/xv13Hj3be3bOsuPZcj51FzxXTGt2OA7L0MFrSlsOhBeC8dBJXE06PGsGr5i3gW4ZKv
	sswXeQiJBabsaxIQC2KUg3SYT5zhF4fVmWUr/H+d8XMbJXF/+V6HQTvi14kNM3e6X4u7pvxwLr3
	3mKyBw+FHVg8Mz1B7fmHVzqLQ6BDs8Q76jjc0osWGOxVHHlqnkjDdYpKk9sPXauz3VzWRsbf2zi
	WlHAE2724F3q+64Q9jqXFxbpGBxgx+9uTgT+z1r/ZoU=
X-Google-Smtp-Source: AGHT+IEZjj1zr6KjWFTQYscKYFXgO6ZuF3B36U9IG1e4c1569+owWLaEi5bGV7PTpDSJmekOGmMX4w==
X-Received: by 2002:a05:6000:1a8d:b0:38f:2a32:abbb with SMTP id ffacd0b85a97d-3997f8f9d54mr10259058f8f.4.1742831446672;
        Mon, 24 Mar 2025 08:50:46 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3f36sm11533049f8f.32.2025.03.24.08.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:50:46 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:50:45 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
Message-ID: <20250324155045.GB1844993@myrica>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
 <20250322-c669034d2100a75ab6e53882@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250322-c669034d2100a75ab6e53882@orel>

On Sat, Mar 22, 2025 at 12:27:56PM +0100, Andrew Jones wrote:
> On Fri, Mar 14, 2025 at 03:49:05PM +0000, Jean-Philippe Brucker wrote:
> > In order to test all the latest features, default to "max" as the QEMU
> > CPU type on arm64.
> > 
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > ---
> >  arm/run | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arm/run b/arm/run
> > index 561bafab..84232e28 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
> >  			qemu_cpu+=",aarch64=off"
> >  		fi
> >  	elif [ "$ARCH" = "arm64" ]; then
> > -		qemu_cpu="cortex-a57"
> > +		qemu_cpu="max"
> >  	else
> >  		qemu_cpu="cortex-a15"
> 
> arm should also be able to default to 'max', right?

Yes I'll change this.

I didn't earlier because it failed when I tried it, but it looks like I
had QEMU=.../qemu-system-aarch64 in my environment variables, overriding
the default qemu-system-arm (32-bit only). "qemu-system-aarch64 -cpu max"
doesn't boot 32-bit code, but "qemu-system-aarch64 -cpu cortex-a15" does.
Anyway, without explicitly setting the wrong QEMU, "-cpu max" works for
32-bit.

Thanks,
Jean
