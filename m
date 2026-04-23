Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B8E3E3C72
	for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776935883; cv=none; b=CrcAwdjP5wIKvqmS6q325ENaM/23hsdvN4q2b+UwNT9mK+CKF5oBBf9yJD3Ao5henUBcBsnr8rItoLwK9oKY4EWPPPEevtA9JjQ75nyaKuWo418GIPdTMarwA+5xbptbgJNl4uuWXCrJ9t8Y8P8PHTjyY8QSI9k5ykgVDEloDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776935883; c=relaxed/simple;
	bh=AZoirHf/5mE5YFev+nodzuKCTioKK86YrjX4J7mCnGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3Yk7h8b5LHUggZbvatM7kdjTONgEuCQ5njhISFC76G8PmvM2rpK1EnDARdL/909w7sMJSCr7HSBerISBCyswfprDS7IeDhLWWbFPA8TY7lXQQQbK7oMK+IWoBB9grCAiUTfwPZAd24d24TjKCyC8IjBk7/7bgNS4gD46+Pegec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hdaeFEgZ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hdaeFEgZ"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67148a70f8aso49603a12.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Apr 2026 02:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776935874; x=1777540674; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jzw3UnIwHGir8Kj1NlO4m24J9zaCTTh7cxmm2qnVabM=;
        b=hdaeFEgZP3+p+uYgaH1D8BYetK6VJyAbiEmZA+Y7jMN7a7YoXgmzmDemqEd/NTtooI
         YKOD9bGbO/sWPq+AItseNg8OEF5sGCHWlnCQdw5E0WScXs6CHnCVRzDDixczpc7IF4tJ
         QQvkt/FW9+5X4YMTdQoArPQfh4s+Q3qWLmTfAfxUCpSVkGHk6Lab1CSk8DEi9e8RJYfe
         BS/bs6Bt26ig/tUGiV6WU1j3IAt9Q/dwStlo88MVQ/YlJA59GnS1Ii/Go6sVBbKm5JsG
         obu8zuLc7FMW5tH3Yj9MFrv1xKdyHhW4EEK9E+YQN/IhOedo60pjGin9piZiYVsNy/m/
         RH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776935874; x=1777540674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzw3UnIwHGir8Kj1NlO4m24J9zaCTTh7cxmm2qnVabM=;
        b=oBM7f/dRzfPCwjOraBf8tVU+PhkqxPfTUqOEklnUx5XOpQDmTzeFcQmonMQhGubsXT
         p8MyMqeN6mQ/bz4Tyegs1GlMHECKgP4ZMrXKGeENwhG5+hz/VMG74JJIvJ0+9/c1nxtw
         hpW88ypFIXSKTRjKxnaWIKXLhlOzgA26bZLMPKeqC8PZDOJELYFc9IJ+OEdHGKz8zxYT
         92KKf4skHyNWvFCfOKBmbmTc1JVLTWk85lnDoXfwJAPL7vdE6eiDao8Rea5s6jVqt1Io
         OF7bQp2ju+1dXU/wU/zJ6DAxPa5Q5fO4OzokyHfvqboeKXnKDDRwfZwbyviWIhb5myON
         DVlQ==
X-Forwarded-Encrypted: i=1; AFNElJ9nAg41TZQeXQATH/3iTxJ6yfQCc2PPgz5mlMcL135kgnEBUMJzgB4XQXBjjfKwT4aKfjQz0Bs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCYRNqLX33RzS2v+oU2snyaCLEIzFvX1BoP4iNxrHVatt4OKMh
	qkL9PN4gLswm8KhA52tg0qmoApFzvy6V1FDz2ijLwoEzQYuhB/ANTGLoOI68TbLImg==
X-Gm-Gg: AeBDietGTu8QRyKeWfC0dKBgDdMQrS2L8b17fMMsuOfaeuWonLOtOV4TIQWABgZ9N2O
	7cr5Ho9dHnq92g33DJMtZIY8DPioMjjRoJzcQNfluAPYIk9choblRnl54Yno/Upq7PyoqVwXdGq
	rjO4rnYcNg3lEZoNwuPJFCSR37fSo4FYm0CUy7xK7hT3rD5eNTPFaV6i28piSyFj2C5VlVCYyhn
	3LhK9Z4JkM0k/mlc/J4yoExaR8hQecrpcRCDnH8cyaIjQzi7SYJPtt1XGzfeooGL8fjPk2kJPB3
	swvGWtsWllVEfesl+bpoBRtQKZ06/5ru9iD5OQbsc9rF1GML+55iYIKLmNoVUFPcvTWbc0O2b8a
	9xHlyk65lhqp1jy31VPgoFxiCSPjKMxV+H0a8HyY533qS5GPtLCRoMh4tNAQcpHxHNAms5/5o7u
	LxxLcB1ijdLscIP+Sdw+/VqFqKcWzxNI1bBw5r+1m35+/wnPN2A9gnljwighe32XdZjXGhJoB01
	Eh/xu3YnFozjzBc910=
X-Received: by 2002:a05:6402:3085:b0:671:dad9:8caf with SMTP id 4fb4d7f45d1cf-6744ed5f907mr227247a12.5.1776935873820;
        Thu, 23 Apr 2026 02:17:53 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba451210e49sm655436766b.10.2026.04.23.02.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 02:17:53 -0700 (PDT)
Date: Thu, 23 Apr 2026 09:17:49 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, oupton@kernel.org, will@kernel.org,
	ayrton@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor
 placement
Message-ID: <aenjvY5VJxFye52e@google.com>
References: <20260422102540.1433704-1-sebastianene@google.com>
 <86bjfb18v1.wl-maz@kernel.org>
 <aejOu98q1lEZoFfW@google.com>
 <20260422-jolly-curassow-of-amplitude-25fbaf@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422-jolly-curassow-of-amplitude-25fbaf@sudeepholla>

On Wed, Apr 22, 2026 at 08:29:06PM +0100, Sudeep Holla wrote:
> On Wed, Apr 22, 2026 at 01:35:55PM +0000, Sebastian Ene wrote:
> > On Wed, Apr 22, 2026 at 01:24:02PM +0100, Marc Zyngier wrote:
> > > On Wed, 22 Apr 2026 11:25:40 +0100,
> > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > 
> > > > Prevent the pKVM hypervisor from making assumptions that the
> > > > endpoint memory access descriptor (EMAD) comes right after the
> > > > FF-A memory region header and enforce a strict placement for it
> > > > when validating an FF-A memory lend/share transaction.
> > 
> > Hello Marc,
> > 
> > > 
> > > As I read this, you want to remove a bad assumption...
> > > 
> > > > 
> > > > Prior to FF-A version 1.1 the header of the memory region
> > > > didn't contain an offset to the endpoint memory access descriptor.
> > > > The layout of a memory transaction looks like this:
> > > > 
> > > >   Field name				| Offset
> > > > 					 -- 0
> > > > [ Header (ffa_mem_region)               |__ ep_mem_offset
> > > >   EMAD 1 (ffa_mem_region_attributes)	|
> > > > ]
> > > > 
> > > > Reject the host from specifying a memory access descriptor offset
> > > > that is different than the size of the memory region header.
> > > 
> > > And yet you decide that you want to enforce this assumption. I don't
> > > understand how you arrive to this conclusion.
> > > 
> > > Looking at the spec, it appears that the offset is *designed* to allow
> > > a gap between the header and the EMAD. Refusing to handle a it seems to be a
> > > violation of the spec.
> > > 
> > > What am I missing?
> > 
> > While the spec allows the gap to be variable (since version 1.1), the
> > arm ff-a driver places it at a fixed position in:
> > ffa_mem_region_additional_setup() 
> > https://elixir.bootlin.com/linux/v7.0/source/drivers/firmware/arm_ffa/driver.c#L671
> > 
> 

Hello Sudeep,

> That's just the current choice in the driver and can be changed in the future.
> 
> > and makes use of the same assumption in: ffa_mem_desc_offset().
> > https://elixir.bootlin.com/linux/v7.0/source/include/linux/arm_ffa.h#L448
> 
> Again this is just in the transmit path of the message the driver is
> constructing and hence it is a simple choice rather than wrong assumption.
>
> > The later one seems wrong IMO. because we should compute the offset
> > based on the value stored in ep_mem_offset and not adding it up with
> > sizeof(struct ffa_mem_region).
> > 
> 
> Sorry what am I missing as the driver is building these descriptors to
> send it across to SPMC, we are populating the field and it will be 0
> before it is initialised

Right, what I meant is having something like this since this function is not limited
to the driver scope and using it from other components would imply relying on the
assumption: 'ep_mem_offset == sizeof(struct ffa_mem_region)'. We will also have to validate
that the `ep_mem_offset` doesn't point outside of the mailbox designated buffer.

---
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 81e603839c4a..62d67dae8b70 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -445,7 +445,7 @@ ffa_mem_desc_offset(struct ffa_mem_region *buf, int count, u32 ffa_version)
        if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(ffa_version))
                offset += offsetof(struct ffa_mem_region, ep_mem_offset);
        else
-               offset += sizeof(struct ffa_mem_region);
+               offset += buf->ep_mem_offset;
 
        return offset;
 }
---

And then move `ffa_mem_region_additional_setup` to be called earlier before `ffa_mem_desc_offset`:
(so that it can setup the value for ep_mem_offset)

---
diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f2f94d4d533e..66de59c88aff 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -691,6 +691,8 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
        mem_region->flags = args->flags;
        mem_region->sender_id = drv_info->vm_id;
        mem_region->attributes = ffa_memory_attributes_get(func_id);
+
+       ffa_mem_region_additional_setup(drv_info->version, mem_region);
        composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
                                               drv_info->version);
 
@@ -708,7 +710,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
        }
        mem_region->handle = 0;
        mem_region->ep_count = args->nattrs;
-       ffa_mem_region_additional_setup(drv_info->version, mem_region);
---

> 
> > Maybe this should be the fix instead and not the one in pKVM ? What do
> > you think ?
> > 
> 
> Can you share the diff you have in mind to understand your concern better
> or are you referring to this patch itself.

Sure, please let me know if you think this is wrong. I might have misunderstood it. 

> 
> > The current implementation in pKVM makes use of the
> > ffa_mem_desc_offset() to validate the first EMAD. If a compromised host
> > places an EMAD at a different offset than sizeof(struct ffa_mem_region),
> > then pKVM will not validate that EMAD.
> >
> 
> Calling the host as compromised if it chooses a different offset seems bit
> of extreme here. I am no sure if I am missing to understand something here.
> 

Sorry for not explaining it, in pKVM model we don't trust the host kernel so we can assume that
everything that doesn't pass the hypervisor validation(in this case the ff-a memory transaction)
can be a potential attack that wants to compromise EL2.

> -- 
> Regards,
> Sudeep

Thanks,
Sebastian
