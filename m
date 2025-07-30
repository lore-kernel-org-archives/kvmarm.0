Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CE92D9ED8
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753886577; cv=none; b=P4QI0VUw4F0hfp+sTX0MYC9izcWMCW3Ceb812EldR22nORKn1yeSKqG1pl42IMoMX89shjBeX20zBViTh/Tk+3XdjLvao1Z+aJM574YTL+H90s3MHlk0E50WulTICJxWpQleYn99vVOn8I6SudRm9XnMgB4twe/mva/WQhDQdcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753886577; c=relaxed/simple;
	bh=gGRfP7BSpng2geWuLtovyzO2vvewCAFqLFPtlv86Vs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5HmEHK+cDcge8HnA9U5+LUJVEYdeJav93DGugALnZMnOSHK+2DiTQdazNZT7qxbTRlodpp+fApgJv2esIBOIg2zOAYZb4DzcTbuuffdTg0OGci9WJThHJCsjKQZETPlIvGA5dWb6YQUtlfBEUclgSf7+1h+V7gxMJ2h/TxPXwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jyrm56wT; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jyrm56wT"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-707453b0306so34482976d6.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 07:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753886574; x=1754491374; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yE9XS5x/IPLFg7Q0+oI241GEqid5njht4Vd0VCx+/2E=;
        b=jyrm56wTckHmfEw+6BsYUu1EEZb+ZKds+e9v8dKtJBcImBCAfTP9xKp1Jmqpk8rszZ
         f8yRnkhObmsfH+xG+SOYVmfHJGN9tZ8bfOoQeqrNLPwCX2Kr+hIyrSxC6luNbdtE2ltY
         9r766+s0AOVlmrzprH5JsnsIjb556rgNfVseXhpzuUwxLVgIcM2KV351x5WePpoxNPqi
         NvoW8TprTw1Q0YUYVUQOt5XVt7GlsJdMqYNQjwagANaCUFujNCJBwsUqbxrgBpbmzsKI
         GGJOcanfA4qWT4m/DoNyJpZtNUvJzpRge+v0VwHLHTACI/AdeUfyPhY7adY3FYUsBl+j
         KT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753886574; x=1754491374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yE9XS5x/IPLFg7Q0+oI241GEqid5njht4Vd0VCx+/2E=;
        b=v7uPeMObdUQgksbX6GBEMgGYZ0yfM4NPLbV8Fel8keMaJYU9eLia3ryJBkDRtFYsMW
         JX73lJ/y4o7ZW3r7C+RE/9fsEJTyLeYeooJKwGuGCX88+Up+3kvOjSvDnPygSYgdK8LE
         X+CAEhYblSBIcraeNcDBLBN170mwpzYIlaZxiTGDY81YT/pAUk+W1dhfWAUMPJcOHGcG
         5gL3OizeFjtHO2VfyyFHXlwgVfZJZihcK5MiKa7e2E4a6AzIiutaJYMoLiBDTN+seP6n
         cI8yjHWuQT7PfY07WZ1hmavd800x+D2aPaFCxl6u0wIv8M9D6mHecSxvj0Wx2+i8Z3Al
         qEvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMoQ1lA0Tjur0sAknYBUe++oeTN1+VCgpZWUEIMGXBvhtFVwRJ54+ypLPNxyC5Z3HBnF4st7A=@lists.linux.dev
X-Gm-Message-State: AOJu0YziDC6uNxSyt45fwQwu++FaVVx0plsmAtuVVRH65qfYpmDRM59x
	jHHCi/KGYwzCKy98maynIkZr2cC22SVoidjpJ1SeFEmP0VywNlR2W45nN94AM/nw4D0=
X-Gm-Gg: ASbGncvFWMMy6qZML0oPIDuoZqO+yRimrjL9UQGqEZtYWGIOXpg/E0+rHpsMwRGhHwN
	4iZkJQNvXLBPGfo32WVfSAR7woQZS6bwTrhgC6reb1WUloG5hR27i0Upy16defrdtTF9SD6FPRa
	nRSjOZOTtxtlWZng7HZ2KdCotXVREd3LIDBYbOpCv6SPPixG+Us9B64RswoCMXilNzYIGJwXMae
	0sWYPKOIVN0QQ3iullzSFZg3ZfLnCDK8Bjhqp4jGgHqUPkLJ6YCQyL1ZujG9rSXswbRrodXnClU
	ctBo/AfDMKxfKVAJu1advq+B65qmecg1JiKo1D2J6BCfrRvF+vvp9rImJYA3inNDv146y3uTy1K
	wjHzRnPsIHWHVOJGGg0IJO6GGvzEaVC5o5eO6P3h54dL+fAz86kVijC9nFRHbkjSmWySB6izi68
	kzrQk=
X-Google-Smtp-Source: AGHT+IFTshf+JMDcrv8+0/UalWTBjWGXz7BdMW99vihoM+QJWNKuspc/O9f/fXBj039JGJi+af7NVQ==
X-Received: by 2002:a05:6214:ac7:b0:707:4daf:631 with SMTP id 6a1803df08f44-7076719b73dmr50415456d6.42.1753886574527;
        Wed, 30 Jul 2025 07:42:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7074b52ddc7sm39845896d6.77.2025.07.30.07.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 07:42:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uh817-00000000RlW-0qIU;
	Wed, 30 Jul 2025 11:42:53 -0300
Date: Wed, 30 Jul 2025 11:42:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250730144253.GM26511@ziepe.ca>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728175316.3706196-30-smostafa@google.com>

On Mon, Jul 28, 2025 at 05:53:16PM +0000, Mostafa Saleh wrote:
> Register the SMMUv3 through IOMMU ops, that only support identity
> domains. This allows the driver to know which device are currently used
> to properly enable/disable then.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 92 ++++++++++++++++++-
>  1 file changed, 91 insertions(+), 1 deletion(-)

Can you split the new iommu subysstem driver out please? I think I
asked this before.

This series is big, reviewing a new iommu driver should be done separately.

Please review all the comments for the verisilicon driver, I think
many of the remarks apply here too:

 - Domain attachment looks questionable. Please do not have
   attach/detach language at all in the hypervisor facing API.
 - Get the ordering and APIs right so replace works. You need this to support RMRs
 - Use a blocking domain not some unclear detatch idea
 - Use a blocking domain for release
 - Use the smmu-v3 approach for the fwspec, don't store things in the drvdata.

Jason
