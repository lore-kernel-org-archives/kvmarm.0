Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5B53D3CEF
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 11:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213893; cv=none; b=Qg9qSwTkR6Bfk8Ozjr7wwegzirVTJzkDrPKZfchUyuJvGnqUZAQ7hf7fL3zRqv0DuS4VFXZqtNTHf6M4QezzT2rubjWtXPF2FG0ftiW9awLZY2dKfOSolgIk7Nn/mL00f0nnc5PcIufEnfLar5l8ZjHOwGhaQL99GeorYM045rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213893; c=relaxed/simple;
	bh=xub7d8UVLHJ/EeANQ4PqYtB+BzlixBIMOx8ZjkHOPR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvawCuGYk0UDICC3nUWkGz/nwd67GtC4oM4KeDqliE6V2X4ZMil6zbSLzSgFQVuZrT/HFbMc7FWfJ4kP+sl/bmn5bGDqbeW0QkoBy/xXL3Eu60CVIp947GF+yJG9pltgC7L38hxRtXnBhVuuCxwi9umqiWplvUUhRIVBEFavoJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LgjToIX7; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LgjToIX7"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c0868ca8738so653140766b.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 04:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782213891; x=1782818691; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G1i1oDfCJW72UVj6tqHkuUrHq9UVqOgjHQzojRLhWq8=;
        b=LgjToIX7vEDYnlhel1LG7dY46yx90QPV4b4YG08kYjoyZs8/Eu25OG4jrEq38TnVrn
         XY+phYzoel9F9Bhu0MlJXtJByBRh4CH1clJHi1bERJ/RcOIgTeTJ3W5o0m5kCpsfNNHy
         Cz2zddqyCVUchu8UMo+EVxmzzQf3x3KPKQzqfUiUVLINOFygOnJo3Rs5+AA1CcNa5mYb
         ztVX+MSvBmY4AimVFDWoVr+ftKkMy8bbsLBIgYc33oEKBieM6sUe0btMS1DP4Gm4wamC
         IkIliko7Mio/Ltyttgvdq+fRtX0Ic0KfwD4bSRiG1VMvhmBLzOeUiYrMrlV2XbOUSeF5
         jhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782213891; x=1782818691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1i1oDfCJW72UVj6tqHkuUrHq9UVqOgjHQzojRLhWq8=;
        b=pcXDV8CFCBSYAwgDKatJwpd5DMVhQGgnZWszmUIo1GGN3Qdsa+gZElpYwlQgLOhr4g
         ct3ahKgd02JfKq4KCfmPtg24OXYGtgyocBeQb50s7s1JCwfFhAS67aSadL++dQnshmGg
         7bz1NSx8lI09cavGB3JSA1q23VpwU1x3DQ+52jg/NbbyLtCXRNQxNoq2LEPczwlKbyv5
         SeYZaK3hyYuU9UBi4WianQ+QJ5v8quWVHiJyFV0q5a0y0XPyd2A/8QoCejs8jPPL9P1D
         SU5fZULuIIzu2PN5R6QdfGM3A+C/m5Vdc87SFzHenJxRp6nvaJpbT4DyTfg/M4Y9BAFJ
         Y7qA==
X-Forwarded-Encrypted: i=1; AFNElJ/mQFLqfFbsH57etF3Fwds8NiSn1bcwDrI/GCkzStTt7CE+K2d8HnIM6LbT1WU9LIFLfvnWrRE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhoBI6dmzMn3LMxKctYqWp3K4iOH0rf8HGdH1ryTPwIeO4cwLf
	90dz4//JJMZa8Lfmm2k1ta9mgkVNIJxJ2GPeuH3sDJ7GOfM1C21m9MIE7Njw3Lf4Uw==
X-Gm-Gg: AfdE7ckZT2WXtXxnaNWrc1mG3yGaQjUAWovsT4PPx7uzpHNdJoMW067lRetMyFe714q
	ShyEa1pi3IIrNdIwagy13QpY/4wNiH5s47sHPI21+LCe4LmYe41jttkKSq2E9ZJ2dWR/xwmvy2g
	fTqyrlTfUueHWI0KNhGw6s1thJ5JNKQsxQbS51T3QLPDnlwz2QnvIaQ7+hL2MurmDUVy7VSD9a7
	CKcNemXTeN7fkB2WmMIMkskQnx1650npZAlfaoZ2UOLo7O4bpImXwPh4c4L/ogYBz7DS+ZZ5YWB
	HE+ZkpUTtOilmS/rfA6yTomAUFP+uYmPdQEDmE6louijMWoU8L5rJaq7b0ohL22ptJln1MRTMfG
	EsqoAE020ZAZv85R8+0HQp7wT6F9BsIz37S1VfSjLeiwqEZMi7rA7uIwHx74z44+4tbUSdnrb2q
	JQNdymOzUI6xcU19lsu5i4IZ63M7P0gS8Jf1NNN+PxFlNsY1QWF+GT68A2
X-Received: by 2002:a17:907:97d0:b0:c0b:90b3:ad25 with SMTP id a640c23a62f3a-c108eff706cmr105170566b.44.1782213889951;
        Tue, 23 Jun 2026 04:24:49 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0ff4c9610bsm157445566b.42.2026.06.23.04.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 04:24:48 -0700 (PDT)
Date: Tue, 23 Jun 2026 12:24:44 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v4 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ajps_L72BDyofjG7@google.com>
References: <20260616154149.2763214-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616154149.2763214-1-sebastianene@google.com>

On Tue, Jun 16, 2026 at 03:41:42PM +0000, Sebastian Ene wrote:
> Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> FF-A proxy. This restriction was preventing the use of asynchronous
> signaling mechanisms defined by the Arm FF-A specification to
> communicate with the secure services.
> While these calls are markes as optional, there is no reason why the
> hypervisor proxy would block them because:
> 
> 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
>    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
>    Because all forwarded notifications are inherently attributed to
>    the Host by the SPMC, there is no risk of VM ID spoofing
>    originating from the Normal World.
> 
> 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
>    operate strictly via register-based parameters, passing only
>    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
>    not contain memory addresses, offsets, or pointers, forwarding
>    them doesn't pose a risk of memory-based confused deputy attack
>    (e.g., tricking the SPMC into overwriting protected memory).
> 
> While the pKVM proxy behaves as a relayer, it doesn't currently have its
> own FF-A ID(only the host has the ID 0). The behavior of the setup
> flow is covered by the spec in the: '10.9 Notification support without
> a Hypervisor'.

For the whole series:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> 
> ---
> Changes in v4:
> - previous series(v3) had serious issues with the patch number and it
>   appeared like it used a mixed bag from v2 as well. Resend this to
>   restore the correct order of the patches.
> - fix strict check in ffa_check_unused_args_sbz and make it "<= 17"
> - check the receiver endpoint Id in
>   FFA_NOTIFICATION_BIND/FFA_NOTIFICATION_UNBIND instead of the sender
> - use hyp_smccc_1_2_smc all along 
> - check the receiver endpoit Id when doing FFA_NOTIFICATION_GET  
> 
> Changes in v3:
> - applied Will's suggestion to use the introduced method
>   ffa_check_unused_args_sbz for existing calls and added a new
> patch in the beggining of the series to do this.
> - merged the handling of
>   FFA_NOTIFICATION_BITMAP_CREATE/FFA_NOTIFICATION_BITMAP_DESTROY into
> one patch as Vincent suggested and create one handler for both.
> 
> Changes in v2:
> - enforce the MBZ/SBZ fields
> - split the calls into separate patches
> - rebase on 7.1-rc7
> 
> Link to v3:
> https://lore.kernel.org/all/20260616105417.2578670-1-sebastianene@google.com/
> Link to v2:
> https://lore.kernel.org/all/20260608165549.1479409-1-sebastianene@google.com/
> Link to v1:
> https://lore.kernel.org/all/20260501114447.2389222-2-sebastianene@google.com/
> 
> Sebastian Ene (7):
>   KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
>   KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
>   KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
>   KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
> 
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 211 ++++++++++++++++++++++++++++++++--
>  1 file changed, 203 insertions(+), 8 deletions(-)
> 
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
