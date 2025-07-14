Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F372E630
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505580; cv=none; b=qwKKJ5HjxoGIP8BRBmp5w6DkvdoaHlpzVP/jnQJgfnnYWvjyKWOYKC/Ivpf5rCccfQ6gP9CgPz+UCOm8tBqz6z1ACQBTzYz7d6dF06BLeTVvkksuJUZtq3yHvBq9b373GVmw+Iv6NhjwhV1SxKFG5bihsqu1cbOrxZjsrfqA++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505580; c=relaxed/simple;
	bh=ESp8lys/TFfkUYsV+PMkN+FDh5R3NCEJNy5EZ8FNzFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJxALhhuI8RKTSjafJBErEnvrqXLk1apwKk4Odg8Z8hwcpRkylh5YeXKA6GDzwfTBKGx7cj1FLSbpFhMoyUycuTl8+kyjqu9I0zCdI0ZxB6N9NYxUf2lB6+Ej05K9tMHEgBLXvL6Jw/8vZFpV0vPNglputNKUVt8d1IeNwjz98w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SWdOnpgr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWdOnpgr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752505575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBkJwszFb96r0R8WuWiAyKUt++3xDSiPYlEnHO0jJJ4=;
	b=SWdOnpgrJbU5nbdgqM5r8y+vEAWZdHx7gfUEEznWbferNDuwxzYO5xgcpnQNPlGQO/Z4t5
	HDS6LJ2HF+ZM/wfWKU9cwnmSZ07QwiCFyNITrZSCmSw5S2uvCNwICxh9Nmw8q9eo/D9rxE
	m6IV94JCU62+tmN3YizTKN+usvk/bAA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-ccGTzqn8Mkabt1-9ENlo6Q-1; Mon, 14 Jul 2025 11:06:14 -0400
X-MC-Unique: ccGTzqn8Mkabt1-9ENlo6Q-1
X-Mimecast-MFC-AGG-ID: ccGTzqn8Mkabt1-9ENlo6Q_1752505573
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso25734465e9.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 08:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752505573; x=1753110373;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBkJwszFb96r0R8WuWiAyKUt++3xDSiPYlEnHO0jJJ4=;
        b=NoNO/BktPmMsL7D7KTvEIc7HfpMn84ZAJNmhLAPJBsiUQfdYgxmc4VWox60ITQ5M3s
         GZppUfqPvwF3PBI86wD+zz/2QgU9u+0wflEWlAVpMENRfwQxBk4naJlUa+F55nOsmDbD
         X+0+VdxLfhDFQYG5gMTj3RHqxoiJnwS1C8YCcj9e4GWtYMrSQUBBEIo1jjfGOgnDrHTV
         blW7TMhg6mYvUxfNKnFHd4oGEEXK+gCL44Y5pH2aipVqZuKnRjU7KTxM9cDlsGgHUSxl
         vg1XuSusfoMBjoofq2SFImxxhdqfG6besKwDnM0O7WFtfYbm2n355QKtNmP9KpOMUX8z
         2x7w==
X-Forwarded-Encrypted: i=1; AJvYcCXrjkrnxA+Gq4djo0aNeY407Xtg+Jbd81CPDRxN7U7oyJMR0dFaLNAx334lkCp7lZ10Xnp2ZgM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyElXrKb8NcKrJ8zvy6G0/TzwBOIOUB+7yDAVosPrrTrydHeA6u
	ldACohzl3vFlPbmSlzOLBYRzyw++k0dSUX48cgFuR9oJHsC5Od3KJnNocPWsdgD8r9Pui2Ensha
	nvayD7rp3qD7QH0QjgkktBBuA+vDs8EUj/TQBXFGaSooc4lFOAcrX5ZLxNA==
X-Gm-Gg: ASbGnctlmREAkhhv5catAz1eP0ZSDXU/O5029QIDWPxT+Zs2TM4ZP+SlKB+tfzCMKLS
	F8gvTqLMBOThO4BWO31zK4ejqepUxF6YhdPfAA3lvAgiIKz59c0FQ9d9niBMTsE9moJP2PNBMFh
	8XtwsNgS4u5AsvEJVls68tQWvsVjYMaqD+VIx9MjbSBnpbhEjsW3OFjolrNSd+WiWT1TmbZAF92
	5h+1e6YHZQe6KeMAl/JxclZLrHTYH1MMHP4xuPN11XcqIBL48XnkkRHMoUhjq6WVgahaiYRtZD/
	BrFnT2xVADPKaUIFdEczTNrz2tUMouJ3yJIBtkY9LHwYQ4ex5UX8Vu2Irr6RvMXRnsdk6z/1JoL
	ws208xw==
X-Received: by 2002:a05:600c:6748:b0:456:12ad:ec3d with SMTP id 5b1f17b1804b1-45612adeffbmr54085295e9.14.1752505573246;
        Mon, 14 Jul 2025 08:06:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYsbJcChSlNyEETOw9rWAqCuD9cIcM+BmBSJWfa+9TmNO3gFvEvkvPjLfN5jSxR69quBD8Ug==
X-Received: by 2002:a05:600c:6748:b0:456:12ad:ec3d with SMTP id 5b1f17b1804b1-45612adeffbmr54084725e9.14.1752505572691;
        Mon, 14 Jul 2025 08:06:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc9349sm12501331f8f.45.2025.07.14.08.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 08:06:12 -0700 (PDT)
Message-ID: <2fecf7c9-7eb2-4bda-bf4f-03b4a1a8f871@redhat.com>
Date: Mon, 14 Jul 2025 17:06:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] Documentation: KVM: arm64: Describe VGICv3
 registers writable pre-init
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-7-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250709211417.2074487-7-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OYceCoxcjGfSZc2pp-AHwwBEVBBCmFfsHZjyXxCNkP0_1752505573
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/9/25 11:14 PM, Oliver Upton wrote:
> KVM allows userspace to control GICD_IIDR.Revision and
> GICD_TYPER2.nASSGIcap prior to initialization for the sake of
> provisioning the guest-visible feature set. Document the userspace
> expectations surrounding accesses to these registers.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  Documentation/virt/kvm/devices/arm-vgic-v3.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> index e860498b1e35..c7a1cd22d814 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> @@ -78,6 +78,8 @@ Groups:
>      -ENXIO   The group or attribute is unknown/unsupported for this device
>               or hardware support is missing.
>      -EFAULT  Invalid user pointer for attr->addr.
> +    -EBUSY   Attempt to write a register that is read-only after
> +             initialization
>      =======  =============================================================
>  
>  
> @@ -120,6 +122,15 @@ Groups:
>      Note that distributor fields are not banked, but return the same value
>      regardless of the mpidr used to access the register.
>  
> +    Userspace is allowed to write the following register fields prior to
> +    initialization of the VGIC:
> +
> +      =====================
> +      GICD_IIDR.Revision
> +      GICD_TYPER2.nASSGIcap
> +      =====================
> +
> +
>      GICD_IIDR.Revision is updated when the KVM implementation is changed in a
>      way directly observable by the guest or userspace.  Userspace should read
>      GICD_IIDR from KVM and write back the read value to confirm its expected
> @@ -128,6 +139,12 @@ Groups:
>      behavior.
>  
>  
> +    GICD_TYPER2.nASSGIcap allows userspace to control the support of SGIs
> +    without an active state. At VGIC creation the field resets to the
In [PATCH v4 4/6] KVM: arm64: vgic-v3: Allow userspace to write
GICD_TYPER2.nASSGIcap commit message it was said:

"For convenience, bundle support for vLPIs and vSGIs behind this
feature,allowing userspace to control vPE allocation for VMs in
environments that may be constrained on vPE IDs."

which, I understand goes beyond the simple support of vSGIs. Maybe worth
a clarification.
> +    maximum capability of the system. Userspace is expected to read the field
> +    to determine the supported value(s) before writing to the field.
> +
> +
>      The GICD_STATUSR and GICR_STATUSR registers are architecturally defined such
>      that a write of a clear bit has no effect, whereas a write with a set bit
>      clears that value.  To allow userspace to freely set the values of these two

Thanks

Eric

