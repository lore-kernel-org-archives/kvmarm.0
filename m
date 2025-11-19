Received: from mail-il1-f195.google.com (mail-il1-f195.google.com [209.85.166.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F632D9EC7
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763566453; cv=none; b=j+1WNITcD4RHovQvhxj0AGODXBB4DNOenVqGuQRsIJcO+t+k6CEZjXwyk6QEHUiDJDhaL0JwGuLvHF2k+scIAIvcEt4MFJqccnkAEgLIGmqNIH+VGmsAlJHXH8cVpwiQN0kH/3AkfQP6uIfSCMZvpugIx0zwUJ4WuTGTckvXh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763566453; c=relaxed/simple;
	bh=4lQdeVY3VH2QJZwcwd4g5IfjGuUeNy2yw6QUZDY5VCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kE1XuDVzCcblmlqumugB/TekEZOk3+QnSllGqDTcFF6EaOAx9zHy9MNy18j77nBN1pMKbe7ZQYY3CZoTn3FpHBvXxoaKhAcc8PWWFJ6nRsJkFVR7kS8+GBAiGTLvlkEdM9vglEx6ZyJJd3oKtS7dABQSs36/NzM0tOzd6zcay+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=EzG+8YJF; arc=none smtp.client-ip=209.85.166.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EzG+8YJF"
Received: by mail-il1-f195.google.com with SMTP id e9e14a558f8ab-43380a6fe8cso43239485ab.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 07:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1763566450; x=1764171250; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1fdpJ5+3GRFj4jj6xIs9v9Fo+svphOHx6XA1rfUhj4=;
        b=EzG+8YJFpY8x6Z4NLqvCdYpJcQVBPLliYV/tIjxtcZ6mxrBQijirvvQ5T6vgEUI2ic
         EjsoqMwaV80fccyeYWmTeK8xzsG8i7nlV5JdpONjtxmvSVT2EhVW9IEwBfkfhuKKila0
         OY8dmr6JePg64e+mnwTC/RuItwBOnbWfmbHe3bOicTDqV8Y3MUcsvvRd7nMS+seuW841
         41e6Eg6GQm7bkt8EkwUVB7VfhMHzrwFN3h0ySGesbxk7FMx/WisiYOEv2UtsGPTIjBkz
         +2s2wN/lVyL1NphPRjB8jCek0v926IWDhwTAiaOy0RtJNo7mgRTdb/bVSdC/B/D3USGH
         /nHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763566450; x=1764171250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1fdpJ5+3GRFj4jj6xIs9v9Fo+svphOHx6XA1rfUhj4=;
        b=isvdXfp7qwB7H/kZ+cDJS0re6OchJPZFDI78qzcqwpFxxsW/Jtbu7CEcVEjwdmH54V
         RGmbCUQ0MfDd4QC0d7y+FVz4DYndiICBbrh6zQVcDxr/jaruwwZFbhABxl3+GLQte2cJ
         12B/IzJNq0kwYNpXLr+yP/6ZsutzbgSstFRcAsawSpoVFqcUiLgqofJbjKmKKNwwEcRz
         EWfkYUsvo+J6Y2hBCLBMJdPUk2bQkinLB1ncJAATmVoKeSQumPhuLVLCawYtAscEvwhW
         1/bTS1ZErs7SIbTkAs7yM1nWpV0LybPtc54awh19h5rITsRKpFMaPHrLJPprfrSwtIIo
         VIgg==
X-Forwarded-Encrypted: i=1; AJvYcCVR1AYGSE0ArnaafWgACuBmqXCwct/IeBa+ofiQBWihiImbcccBi6xGqCrgSwMfCPrNOcQlQ+s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpouT5+rfkv08uItvmbgGbXJTx3KhsvtEL6oMNy+PkOH8v95vg
	ps0aOC7OOQfLKSeh+Dy8G+wDcQmcT2PQ6DmrvIzojKXHhBRtwl4Gco+T6CyrxfFbz7Y=
X-Gm-Gg: ASbGncttBrfCiGXfw36JJU/wEqHM2EhEka5a2Dp+xG5qcrFZ0zThOIB6Fra/ayM/jtZ
	D/RWBkmqGrRAhQ88M6SzapwD8bNVHxkyXPl5rv7i7avpFY8cT+vftbZ0ZtqZoBnwBObdIIQOTvc
	Q4oJS6ZbZhfC3eIJ26m3TCGA9vFB93ogQaOJDIL+B397dLbrdfJzP+hcIwVjwF87UsSXGhfFSyj
	/UTQkv5oOdWHf0mXsRzc13PH7OvZijcsC6PyrY2bOLw2HbMvFuGA+cldPftuhHCgyze5COtiWFA
	cwWXAk0wdCmVDKM3lcFPAAZstMgEomx9PSIM3Bcqk5gZDcdfiXAS86dpn9FEojhwTuRW422DsIm
	DzwOruhPEPM0VNUtGic8jKMDfrTZ4O5NHVCfiS+XV3Yp5128MsUVc2eEzVS0L22Y3CL1u9R4Ky3
	H1IT5Mlskj0A9o
X-Google-Smtp-Source: AGHT+IFDJZtgEmU/xKXBdBPh5jPVgt8DpT4PjPif1o0uBgO5oq25Qtiwdew7mHjWGTM8edF4aXD1tg==
X-Received: by 2002:a05:6e02:188f:b0:433:70e2:6292 with SMTP id e9e14a558f8ab-4348c942ed2mr244853635ab.15.1763566450054;
        Wed, 19 Nov 2025 07:34:10 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-434839e29a8sm98129465ab.34.2025.11.19.07.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:34:09 -0800 (PST)
Date: Wed, 19 Nov 2025 09:34:08 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org, 
	alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251119-7493c53b2b8e315d7556f699@orel>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20251119131827.GA2206028@e124191.cambridge.arm.com>
 <D63D4CE9-431B-4F76-B769-C4FFB37B76AF@gmail.com>
 <20251119140224.GA2210783@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119140224.GA2210783@e124191.cambridge.arm.com>

On Wed, Nov 19, 2025 at 02:02:24PM +0000, Joey Gouly wrote:
> Hi Nadav,
> 
> On Wed, Nov 19, 2025 at 03:48:13PM +0200, Nadav Amit wrote:
> > 
> > 
> > > On 19 Nov 2025, at 15:18, Joey Gouly <joey.gouly@arm.com> wrote:
> > > 
> > > On Thu, Sep 25, 2025 at 03:19:48PM +0100, Joey Gouly wrote:
> > >> Hi all,
> > >> 
> > >> This series is for adding support to running the kvm-unit-tests at EL2. These
> > >> have been tested with Linux 6.17-rc6 KVM nested virt.
> > >> 
> > >> This latest round I also tested using the run_tests.sh script with QEMU TCG,
> > >> running at EL2.
> > >> 
> > >> The goal is to later extend and add new tests for Nested Virtualisation,
> > >> however they should also work with bare metal as well.
> > > 
> > > Any comments on this series, would be nice to get it merged.
> > 
> > I wonder, does kvm-unit-tests run on bare-metal arm64 these days?
> > 
> > I ran it in-house some time ago (fixing several issues on the way),
> > but IIRC this issue was never fixed upstream:
> > 
> > https://lore.kernel.org/all/C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com/
> > 
> 
> I haven't tested on real bare-metal hardware, I have been booting directly in
> QEMU with both .flat and .efi.

At one point arm64 builds worked on bare-metal - I added commit 993c37be77
("arm/arm64: Zero BSS and stack at startup") as part of that effort. I
don't know if it still works, though, since I haven't tested it in years.

As for this series, I was hoping someone more invested in arm64 would do
some reviewing and testing. Then, given we get some r-b's and t-b's, I'd
give it a quick skim and ship it.

Thanks,
drew
