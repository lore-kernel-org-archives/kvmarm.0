Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F67917983
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 09:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087259; cv=none; b=TdQIP1HnrDOYv32NpJEnoKtU9D+JnkwtfBAAWpdJ/ZSFQmNaQv/4Xj0ukitP5S77Nm9OZ9CH5A4AzgZUzgHYBoM5UmX9Jo1Tc4L2ZpjfXNqwFi+M5Q7UqFiXDEtnzIoT3ty4eaqVYDCDIFantaRM1URVMgrgmwBYSZ15wshjd+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087259; c=relaxed/simple;
	bh=IXM6p4NQ5xNMIp+I08MpFl/C4xzL887zpVFg7lffNJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWAEIycbG7m4aRFI2O4OI+ZZe7kfiXR2cITQHWnoB8013vs6zZGd9rQHU9MbT5Z2AEYU7aHO0p8ZY/jCEARWqN9Cst+ySJcDoOJSg0mIDhGDvSqbUvUAUFWozo1t9U0MfQ1cZDbBsMtBR8HWrY65jjfqV1UBUMa7KXtEFlHonJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MCxza7qK; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MCxza7qK"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-40e4afe9ea7so24905e9.1
        for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 01:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706087256; x=1706692056; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SI39RK/rWNckwv2r4B917cux2i/pKiQn7x4kFloCx1A=;
        b=MCxza7qKoN9LN85hBObWNd6DmNSxmgXk2/72t4oAVtXtmq3Ex51W72tYfz/Sc39z1d
         TkmQ5Hh04oXd3aOOWfiyCOOUj9YPsFtFIdcV5J96u8m3T2CswqAIdxG7C81upIAdDERS
         fhE1GGGOtfj33iLvRaaiJzq+9gIRuLSeMp73kFzVKgVXJXSyrImD6J3Ct3DC51zXT1Fd
         uiqxqHgd7kCux6oFHFMfrIBTzP6uYREVRaXnSuL7FNvdfr0L4T3zS5Hg6xPJHZYOCXT2
         wNOZxi0pcZQT246G65xeEreRR/Iw1CZCy6cz1IXbxFJmAtoCXGpGYZo2/sqGrd5+tQsE
         Nzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706087256; x=1706692056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SI39RK/rWNckwv2r4B917cux2i/pKiQn7x4kFloCx1A=;
        b=Maim1Tz6lAQ5WuLM4I5UMI+Q8wQkdxxoy/UMyTg4IqjtXHTMHWgZMS/gi3rJs79oqk
         DyzBgAeXrz/QgFr39SWSGWRqAemULKCujkOc2c0s6FC0WD6Jhkb5gU+F8Ya2q3M+UJeJ
         Naor5SdPl+L9TANofB3xrd5pBqp4SKuU8u7YaT9H9o45Rbc2tRjoJyjb2Is+7P24OvJm
         yaV6DrPImW6/gSfPa9eAvHg7WOaChq7oHPclB5knyVSBFgpiA8n63kt9FBm3thLDe7s4
         mq60QCofarWP9v284RxyODBTaD1Ui4pX72wI2srseEPCnMk5czy0/6AkeB+JbtOSEZul
         bPFA==
X-Gm-Message-State: AOJu0Yys8LJxnWg74+iiX9yzR0ZPmnwwjnrjePnBXrmrgR2NZEzFZVFm
	YxBK8zjoQWyFqkspFlHwPQlH/b8JQknQixjnYc2iKzp0LDh47K8611Rf76FW1A==
X-Google-Smtp-Source: AGHT+IG0lrnvSdMVJPjDEKWKykbbZOKABVazci9lTsykpHwLQImNw7JnWtDPfFCpWv5+CfrTrixLkQ==
X-Received: by 2002:a05:600c:5107:b0:40e:b963:6076 with SMTP id o7-20020a05600c510700b0040eb9636076mr41367wms.5.1706087255568;
        Wed, 24 Jan 2024 01:07:35 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id s16-20020a5d5110000000b0033763a9ea2dsm9142555wrt.63.2024.01.24.01.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 01:07:35 -0800 (PST)
Date: Wed, 24 Jan 2024 09:07:33 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix circular locking dependency
Message-ID: <ZbDTVX1y2bRtJf-G@google.com>
References: <20240123164818.1306122-2-sebastianene@google.com>
 <Za_43qOnVsCPauEr@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za_43qOnVsCPauEr@linux.dev>

On Tue, Jan 23, 2024 at 05:35:26PM +0000, Oliver Upton wrote:
> On Tue, Jan 23, 2024 at 04:48:19PM +0000, Sebastian Ene wrote:
> > The rule inside kvm enforces that the vcpu->mutex is taken *inside*
> > kvm->lock. The rule is violated by the pkvm_create_hyp_vm which acquires

Hi Oliver,

>                                          ^~~~~~~~~~~~~~~~~~
> 
> nit: always suffix function names with '()'
> 
> > the kvm->lock while already holding the vcpu->mutex lock from
> > kvm_vcpu_ioctl. Follow the rule by taking the config lock while getting the
> > VM handle and make sure that this is cleaned on VM destroy under the
> > same lock.
> 
> It is always better to describe a lock in terms of what data it
> protects, the critical section(s) are rather obvious here.
> 
>   Avoid the circular locking dependency altogether by protecting the hyp
>   vm handle with the config_lock, much like we already do for other
>   forms of VM-scoped data.
> 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > Cc: stable@vger.kernel.org
> 
> nitpicks aside, this looks fine.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 

Thanks for the suggestions, I updated the comit message and I will push
a V2 of the patch with the above and the Reviewed-by tag.

Thanks,
Seb

> -- 
> Thanks,
> Oliver
